package com._17173.flash.show.base.module.userlist
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.utils.Dictionary;


	/**
	 * 用户列表delegate代理
	 * @author idzeir
	 * 创建时间：2014-2-18  上午11:25:58
	 */
	public class UserListDelegate extends BaseModuleDelegate
	{
		/**
		 * 用户列表所有用户数据
		 */
		private var iUserDataMap:Dictionary = new Dictionary(true);
		/**
		 * 管理员数据
		 */
		private var _adminMap:Dictionary = new Dictionary(true);
		/**
		 * 麦序数据
		 */
		private var _micMap:Array = new Array();

		private var user:IUser;
		/**
		 * 初始化麦序和管理员数据 每次接收到用户列表事件时候的麦序和管理员是完整的，所以只初始化一次
		 */
		private var hasUserUpdate:Boolean = false;

		/**
		 * 当前已经获得的页数
		 */
		private var curPage:Number = 0;

		/**
		 * 缓存的消息
		 */
		private var _handlers:Array = [];
		/**
		 * 是否正在执行清除缓存操作
		 */
		private var isDealing:Boolean = false;

		public function UserListDelegate()
		{
			super();
			this.addListeners();
		}

		private function addListeners():void
		{
			user = Context.getContext(CEnum.USER) as IUser;			
			//服务器驱动
			this._e.listen(SEvents.USER_ENTER, userEnterHandler);
			this._e.listen(SEvents.USER_EXIT, userExitHandler);
			this._e.listen(SEvents.USER_KICK_OUT, onkickUser);
			this._e.listen(SEvents.USER_LIST_UPDATE, userListUpdateHandler);
			//this._e.listen(SEvents.USER_IN_MIC_LIST_SUCCESS,onPaiMai);
			//this._e.listen(SEvents.USER_OUT_MIC_LIST_SUCCESS,downPaiMai);
			this._e.listen(SEvents.UPDATE_MIC_DATA, onMicDataChanage);
			//this._e.listen(SEvents.MIC_DOWN_MESSAGE, onShowFinish);
			this._e.listen(SEvents.ADMIN_TO_NORMAL_USER, unAdminUser);
			this._e.listen(SEvents.NORMAL_USER_TO_ADMIN, adminUser);
			//this._e.listen(SEvents.CHANGE_VIDEO_STATUS,onVideoChanage);
			this._e.listen(SEvents.USER_DATA_UPDATE, onUserDataUpdate);
			this._e.listen(SEvents.USER_LEVEL_UP,onLevelUp);
			//用户列表开关事件，交互驱动
			this._e.listen(SEvents.OPEN_USER_LIST, showUserList);
			this._e.listen(SEvents.USER_INIT_FROM_SPEAK,addUserFromSpeak);

			this._s.socket.listen(SEnum.R_PAIMAIXU.action, SEnum.R_PAIMAIXU.type, onMicEntryExit);
			
			this._s.socket.listen(SEnum.R_HAND.action,SEnum.R_HAND.type,onLogion);
		}
		
		
		/**
		 * 加载模块失败，清理delegate 监听
		 *
		 */
		override protected function clear():void
		{
			super.clear();

			user = null;
			this._handlers = null;
			//服务器驱动
			this._e.remove(SEvents.USER_ENTER, userEnterHandler);
			this._e.remove(SEvents.USER_EXIT, userExitHandler);
			this._e.remove(SEvents.USER_KICK_OUT, onkickUser);
			this._e.remove(SEvents.USER_LIST_UPDATE, userListUpdateHandler);
			//this._e.remove(SEvents.USER_IN_MIC_LIST_SUCCESS,onPaiMai);
			//this._e.remove(SEvents.USER_OUT_MIC_LIST_SUCCESS,downPaiMai);
			this._e.remove(SEvents.UPDATE_MIC_DATA, onMicDataChanage);
			//this._e.remove(SEvents.MIC_DOWN_MESSAGE, onShowFinish);
			this._e.remove(SEvents.ADMIN_TO_NORMAL_USER, unAdminUser);
			this._e.remove(SEvents.NORMAL_USER_TO_ADMIN, adminUser);
			//this._e.remove(SEvents.CHANGE_VIDEO_STATUS,onVideoChanage);
			this._e.remove(SEvents.USER_DATA_UPDATE, onUserDataUpdate);
			this._e.remove(SEvents.USER_LEVEL_UP,onLevelUp);
			//用户列表开关事件，交互驱动
			this._e.remove(SEvents.OPEN_USER_LIST, showUserList);

			this._e.listen(SEvents.USER_INIT_FROM_SPEAK,addUserFromSpeak);
			
			this._s.socket.removeListen(SEnum.R_PAIMAIXU.action, SEnum.R_PAIMAIXU.type, onMicEntryExit);
			this._s.socket.removeListen(SEnum.R_HAND.action,SEnum.R_HAND.type,onLogion);
		}

		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();

			//_IView = this._swf as IUserListManager;
			//加载失败不会执行onModuleLoaded 后期优化代码可以去掉。
			/*if(!_IView)
			{
				//Debugger.log(Debugger.WARNING,"模块加载失败："+JSON.stringify(this._config));
				return;
			}*/
			
			//加载成功清楚缓存的数据
			this.dealCache();
		}		

		/**
		 * 清除模块加载完成之前的缓存消息
		 *
		 */
		private function dealCache():void
		{
			while(this._handlers.length > 0)
			{
				var cache:Object = this._handlers.shift();

				var handle:Function = cache._handle;
				handle.apply(null, [cache.data]);
			}
			isDealing = false;
		}

		/**
		 * 验证接口
		 * @param value
		 * @return 可调用返回true否则返回false
		 *
		 */
		private function validate(value:Object):Boolean
		{
			if(!this._swf || isDealing)
			{
				this._handlers.push(value);
				return false;
			}
			return true;
		}
		/**
		 * 将正在说话的用户添加到用户列表 
		 * @param value
		 * 
		 */		
		private function addUserFromSpeak(value:IUserData):void
		{
			if(!this.validate({_handle:addUserFromSpeak, data:value}))
			{
				return;
			}
			if(!value||value.hidden)
				return;
			//跳过已经存在的用户
			if(!this.iUserDataMap.hasOwnProperty(value.id))
			{
				this.module.data = {"entryUser":[value]};
				//this._IView.entryUser(value.user);
				this.iUserDataMap[value.id] = value;
			}
			//判断是否进管理员列表
			if(validateAdmin(value) && !this._adminMap.hasOwnProperty(value.id))
			{
				this.module.data = {"entryUser":[value,1]};
				//this._IView.entryUser(value.user, 1);
				this._adminMap[value.id] = value;
			}
		}
		
		/**
		 * 用户等级提升，影响用户排序 
		 * @param value
		 * 
		 */		
		private function onLevelUp(value:Object):void
		{
			if(!this.validate({_handle:onLevelUp, data:value}))
			{
				return;
			}
			var type:uint = value["type"];
			if(type != 2 && type != 3)
			{
				return;
			}
			module.data = {"levelUp":[value.userInfo as IUserData]};
			//this._IView.levelUp(value.userInfo as IUserData);
		}
		/**
		 * 已经登录房间回调 
		 * @param value
		 * 
		 */		
		private function onLogion(value:*):void
		{
//			if(!this.validate({_handle:onLogion, data:value}))
//			{
//				return;
//			}
			
			//this._s.socket.removeListen(SEnum.R_HAND.action,SEnum.R_HAND.type,onLogion);
			user.getUserBatchByPage(1, 20);
		}

		private function onMicDataChanage(value:*):void
		{
			if(!this.validate({_handle:onMicDataChanage, data:value}))
			{
				return;
			}
			//value 为上麦用户的数组
			this.onVideoChanage(value);
		}

		/**
		 * 进出麦序维护
		 * @param value
		 *
		 */
		private function onMicEntryExit(value:Object):void
		{
			if(!this.validate({_handle:onMicEntryExit, data:value}))
			{
				return;
			}
			var obj:Object = value.ct;
			obj["timestamp"] = value.timestamp;
			var micType:int = obj.micType;
			//Debugger.log(Debugger.INFO,"(MicManager)","麦序改变","麦序为"+micType);
			//Debugger.log(Debugger.INFO,"(MicManager)","userId",obj.userId);
			if(micType == 0)
			{				
				if(obj["userinfo"])
				{
					obj["userinfo"]["micStatus"] = 1;
					(Context.getContext(CEnum.USER) as IUser).addUserFromData(obj["userinfo"]);
					Debugger.log(Debugger.INFO, "[麦序] 用户进麦序", JSON.stringify(value.ct["userinfo"]));
					var iUserData:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(obj.userId);
					(Context.getContext(CEnum.USER) as IUser).addMicUserFormatData(iUserData);
					_e.send(SEvents.USER_IN_MIC_LIST_SUCCESS, iUserData);
					//自己排麦打开麦序列表
					if(iUserData&&iUserData.id == (Context.getContext(CEnum.USER) as IUser).me.id)
					{
						this.module.data = {"goto":[2]};
						//this._IView.goto(2);
						if(!Context.stage.contains(this._swf))
						{
							this._e.send(SEvents.REG_SCENE_POS, this._swf);
							this._swf.x = -this._swf.width;
						}
					}
				}
			}
			else
			{
				if(obj["userInfo"])
				{
					(Context.getContext(CEnum.USER) as IUser).addUserFromData({"userId":obj.userId, "micStatus":0});
				}				
				Debugger.log(Debugger.INFO, "[麦序] 用户出麦序", JSON.stringify(obj.userinfo));
				(Context.getContext(CEnum.USER) as IUser).removeMicUseById(obj.userId);
			}
			this.onVideoChanage();
		}

		/**
		 * 直播状态改变（直播结束）
		 * @param value
		 *
		 */
		private function onShowFinish(value:*):void
		{
			if(!this.validate({_handle:onShowFinish, data:value}))
			{
				return;
			}
			var _user:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(value.masterId);
			downPaiMai(_user);
		}

		/**
		 * 用户信息卡踢人事件
		 * @param value 事件包含的数据value.toUser为被操作的用户，value.opUser为操作的用户
		 *
		 */
		private function onkickUser(value:*):void
		{
			if(this.validate({_handle:onkickUser, data:value}))
			{
				exitUser({user:user.getUser(value["toUser"]["userId"])});
			}
		}

		/**
		 * 用户数据更新刷新用户列表
		 * @param value
		 *
		 */
		private function onUserDataUpdate(value:String):void
		{
			if(!this.validate({_handle:onUserDataUpdate, data:value}))
			{
				//this._IView.userUpdate(value);
				return;
			}
			this.module.data = {"userUpdate":[value]};
		}

		/**
		 * 麦上状态改变如切麦等操作
		 * @param value
		 *
		 */
		private function onVideoChanage(value:* = null):void
		{
			if(!this.validate({_handle:onVideoChanage, data:value}))
			{
				return;
			}			
			try{				
				var order:Object = Context.variables.showData.order;
				var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
				var onshowList:Array = [];
	
				//临时表，防止重复麦序列表
				var _tempMap:Dictionary = new Dictionary(true);
	
				try
				{
					var orderArr:Array = iuser.orderArray();
					//从showdata里面提取正在直播的用户，并且展示从麦序里面移除
					if(orderArr)
					{
						for(var i:uint = 0; i < 3; i++)
						{
							var info:IUserData = orderArr[i];
							if(info)
							{
								var user:IUserData = info;
								//防止麦序重复
								if(!_tempMap.hasOwnProperty(user.id))
								{
									onshowList.push({index:i + 1, user:user});
									_tempMap[user.id] = user;
								}
								//Debugger.log(Debugger.INFO,this+">>order"+i+"麦序状态改变:"+user.name);
								//从麦序表里面删除重复数据								
							}
						}
					}
	
					this._micMap = iuser.micList;
					//合并剩余的麦序表中的数据
					for each(var obj:* in this._micMap)
					{
						if(!_tempMap.hasOwnProperty(obj.id))
						{
							onshowList.push({index:4, user:obj, id:obj.id});
							_tempMap[obj.id] = obj;
						}
					}
				}
				catch(e:Error)
				{
				}
	
				_tempMap = null;
	
				//---------------debug info
				var micNames:String = "";
				for each(var e:* in onshowList)
				{
					micNames += "," + e.user.name;
				}
				Debugger.log(Debugger.INFO, "[麦序]", " 当前麦序：" + micNames);
				//----------------
	
				//this._IView.changeMicList(onshowList);
				this.module.data = {"changeMicList":[onshowList]};
				
				_e.send(SEvents.CHANGE_VIDEO_STATUS);
			}catch(e:Error){
				Debugger.log(Debugger.WARNING,"[麦序] 用户列表错误原因："+e.getStackTrace());
			}
		}

		/**
		 * 用户信息卡提升管理员操作
		 * @param value value.opUser为操作的用户，value.toUser为被操作的用户
		 *
		 */
		private function adminUser(value:*):void
		{
			if(!this.validate({_handle:adminUser, data:value}))
			{
				return;
			}
			var aUser:IUserData = user.getUser(value["toUser"]["userId"]);
			if(this._adminMap.hasOwnProperty(aUser.id) || aUser.hidden)
			{
				return;
			}
			this._adminMap[aUser.id] = aUser;
			//this._IView.entryUser(aUser, 1);
			this.module.data = {"entryUser":[aUser,1]};
		}

		/**
		 * 移除麦序里面的数据
		 * @param id
		 * @return
		 *
		 */
		private function removeMicUser(id:String):IUserData
		{
			var index:int = this.indexMicUser(id);
			if(index != -1)
			{
				return this._micMap.splice(index, 1)[0];
			}
			return null;
		}

		/**
		 * 麦序列表单独排序 判断用户是否在麦序列表
		 * @param id
		 * @return
		 *
		 */
		private function indexMicUser(id:String):int
		{
			var _temp:Array = this._micMap.concat();
			
			for(var i:uint = 0; i < _temp.length; i++)
			{
				if(_temp[i].id == id)
				{
					return i;
				}
			}
			return -1;
		}

		/**
		 * 是否正在上麦
		 * @param id
		 * @return
		 *
		 */
		private function isUserOnVideo(id:String):Boolean
		{
			var order:Object = Context.variables.showData.order;
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);

			for(var i:uint = 1; i <= 3; i++)
			{
				var info:Object = order[String(i)];
				if(info)
				{
					var user:IUserData = iuser.getUser(String(info.masterId));
					if(user.id == id)
					{
						return true;
					}
				}
			}
			return false;
		}

		/**
		 * 用户信息卡取消管理员操作
		 * @param value value.opUser为操作的用户，value.toUser为被操作的用户
		 *
		 */
		private function unAdminUser(value:*):void
		{
			if(!this.validate({_handle:unAdminUser, data:value}))
			{
				return;
			}
			var aUser:IUserData = user.getUser(value["toUser"]["userId"]);
			//多重管理身份
			if(!this._adminMap.hasOwnProperty(aUser.id) || aUser.hidden || validateAdmin(aUser))
			{
				return;
			}
			delete this._adminMap[aUser.id];
			//this._IView.exitUser(aUser, 1);
			this.module.data = {"exitUser":[aUser,1]};
		}

		/**
		 * 用户出麦序
		 * @param value
		 *
		 */
		private function downPaiMai(value:IUserData):void
		{
			if(!this.validate({_handle:downPaiMai, data:value}))
			{
				return;
			}
			var aUser:IUserData = value;
			removeMicUser(aUser.id);
			//Debugger.log(Debugger.INFO,this+" >>用户下麦:"+aUser.name);
			onVideoChanage();
		}

		/**
		 * 用户进麦序
		 * @param value
		 *
		 */
		private function onPaiMai(value:IUserData):void
		{
			if(!this.validate({_handle:onPaiMai, data:value}))
			{
				return;
			}
			var aUser:IUserData = value;
			//如果在麦序列表或者正在直播，不往麦序添加用户
			if(this.indexMicUser(aUser.id) != -1 || this.isUserOnVideo(aUser.id))
			{

			}
			else
			{
				this._micMap.push(aUser);
			}
			//已经在麦序里的用户不添加数据，但是还会刷新列表
			onVideoChanage();
			//Debugger.log(Debugger.INFO,this+">>用户上麦:"+aUser.name);
		}

		/**
		 * 用户列表显示隐藏接口
		 * @param value
		 *
		 */
		private function showUserList(value:* = null):void
		{
			if(!this.validate({_handle:showUserList, data:value}))
			{
				return;
			}
			if(!Context.stage.contains(this._swf))
			{
				this._e.send(SEvents.REG_SCENE_POS, this._swf);
				this._swf.x = -this._swf.width;
			}
			
			this.module.data = {"show":null};
			//this._IView.show();
		}

		/**
		 * 请求下一页用户列表更新ui
		 * @param value
		 *
		 */
		private function userListUpdateHandler(value:*):void
		{
			//Debugger.log(Debugger.INFO,"列表应答："+JSON.stringify(value));
			if(!this.validate({_handle:userListUpdateHandler, data:value}))
			{
				return;
			}
			//服务器假人不推离开消息，如果收到page==1且没有下一页说明不够一页用户了，重新刷列表。(服务器不推假人离开消息不合理)
			if(user.page == 1 && value.length > 0 && !user.hasNextPage)
			{
				this.module.data = {"exitAll":null};
				//this._IView.exitAll();
				this.iUserDataMap = new Dictionary(true);
				this._adminMap = new Dictionary(true);
			}

			//取消if判断 服务器推假人也是走0,6接口
			if(this.curPage != user.page || true)
			{
				for each(var i:IUserData in value)
				{
					if(!this.iUserDataMap.hasOwnProperty(i.id))
					{
						if(i.hidden)
							continue;
						this.iUserDataMap[i.id] = i;
						//this._IView.entryUser(i);
						this.module.data = {"entryUser":[i]};
						
						if(!this._adminMap.hasOwnProperty(i.id) && validateAdmin(i))
						{
							this._adminMap[i.id] = i;
							//this._IView.entryUser(i, 1);
							this.module.data = {"entryUser":[i,1]};
						}
					}
				}
				this.curPage = user.page;
			}
			else
			{
				//Debugger.tracer("列表应答："+value.length+" 总数："+user.count);
			}

			initOtherTwoList();
		}

		/**
		 * 初始化麦序列表数据和管理员列表
		 *
		 */
		private function initOtherTwoList():void
		{
			if(!hasUserUpdate)
			{
				//获取初始的admins				
				for each(var i:IUserData in user.adminList)
				{
					if(!this._adminMap.hasOwnProperty(i.id))
					{
						if(i.hidden)
							continue;
						this._adminMap[i.id] = i;
						//this._IView.entryUser(i, 1);
						this.module.data = {"entryUser":[i,1]};
					}
				}
				onVideoChanage();				
				hasUserUpdate = true;
			}
		}

		/**
		 * 用户退出
		 * @param value
		 *
		 */
		private function userExitHandler(value:*):void
		{
			//Debugger.log(Debugger.INFO,"用户离开："+JSON.stringify(value));
			if(!this.validate({_handle:userExitHandler, data:value}))
			{
				return;
			}
			exitUser(value);
		}

		/**
		 * 用户离开清楚数据
		 * @param value
		 *
		 */
		private function exitUser(value:*):void
		{
			if(value.user == null || value.user.hidden)
				return;
			//清楚列表中的ui控件
			//this._IView.exitUser(value.user);
			this.module.data = {"exitUser":[value.user]};
			//清楚用户表的数据
			if(this.iUserDataMap.hasOwnProperty(value.user.id))
			{
				delete this.iUserDataMap[(value.user).id];
			}
			//清楚管理员表的数据
			if(this._adminMap.hasOwnProperty(value.user.id))
			{
				delete this._adminMap[(value.user).id];
			}
			//清楚麦序表的数据
			if(this.indexMicUser(value.user.id) != -1)
			{
				//delete this._micMap[(value.user).id];
				removeMicUser(value.user.id);
			}
		}

		/**
		 * 用户进入
		 * @param value
		 *
		 */
		private function userEnterHandler(value:*):void
		{
			if(!this.validate({_handle:userEnterHandler, data:value}))
			{
				return;
			}
			if(value.user.hidden)
				return;
			//跳过已经存在的用户
			if(!this.iUserDataMap.hasOwnProperty(value.user.id))
			{
				this.module.data = {"entryUser":[value.user]};
				//this._IView.entryUser(value.user);
				this.iUserDataMap[value.id] = value.user;
			}
			//判断是否进管理员列表
			if(validateAdmin(value.user) && !this._adminMap.hasOwnProperty(value.user.id))
			{
				this.module.data = {"entryUser":[value.user,1]};
				//this._IView.entryUser(value.user, 1);
				this._adminMap[value.user.id] = value.user;
			}

		}

		/**
		 * 判断用户是否进管理员列表
		 * @param value
		 * @return
		 *
		 */
		private function validateAdmin(value:IUserData):Boolean
		{
			var iAuthority:IAuthorityData = (Context.getContext(CEnum.USER) as IUser).validateAuthority(value, AuthorityStaitc.THINT_IS_ADMIN);
			return iAuthority.can;
		}
	}
}