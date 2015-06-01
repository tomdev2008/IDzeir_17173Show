package com._17173.flash.show.base.context.user
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityData;
	import com._17173.flash.show.base.context.authority.IAuthority;
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 用户数据管理.
	 *  
	 * @author shunia-17173
	 */	
	public class User implements IContextItem, IUser, IUserAuthority
	{
		
		private static const BATCH_REQ_NUM:int = 8;
		
		private var _e:IEventManager = null;
		/**
		 * 此标志用于判断当前是否可以取用户列表.当当前用户登陆的消息没有返回的时候,即此标记位falsh时,取用户列表会失败. 
		 */		
		private var _inited:Boolean = false;
		/**
		 * 在_inited标记位false时请求过的用户列表数据. 
		 */		
		private var _postListRequests:Array = null;
		/**
		 * 用户数据缓存,所有请求过的用户数据都在这里 
		 */		
		private var _users:Dictionary = null;
		/**
		 * 当前正在异步取的用户列表,作为一个临时记录,用来避免重复取相同id的用户数据
		 * 下载完成之后会清掉 
		 */		
		private var _asyncPool:Dictionary = null;
		/**
		 * 是否不使用异步缓存队列 
		 */		
		private var _ignorePool:Boolean = false;
//		/**
//		 * 用户卡片 
//		 */		
//		private var _card:IUserCard = null;
//		/**
//		 * 插件 
//		 */		
//		private var _cardItem:IPluginItem = null;
//		/**
//		 * 要显示出卡片的用户 
//		 */		
//		private var _cardUser:Object = null;
		private var _hasNextPage:Boolean = false;
		
		private var _page:int = 0;
		private var _count:int = 0;
		
		/**
		 * 屏蔽私聊用户过滤字典
		 */		
		private var _privateChatFilterDic:Dictionary = new Dictionary();
		
		/**
		 * 管理员列表
		 */		
		private var _adminlist:Array = [];
		/**
		 * 麦序列表 
		 */		
		private var _miclist:Array = [];

		private var _checked:Boolean;
		//游客数量
		private var _guestTotal:uint;
		/**正在请求用户列表*/
		private var _isGetting:Boolean = false;
		
		public function User()
		{
		}
		
		/**
		 * 是否有下一页 
		 */
		public function get hasNextPage():Boolean
		{
			return this._hasNextPage;
		}

		public function get me():IUserData {
			var showData:ShowData = Context.variables["showData"] as ShowData;
			if (showData && hasUser(showData.masterID)) {
				return _users[showData.masterID];
			} else {
				Debugger.tracer("[user] 尝试获取当前用户失败,用户数据不存在!");
				return null;
			}
		}
		
		public function addUser(user:IUserData):IUserData {
			//不存在或者当前引用与传入的值不同
			if (!hasUser(user.id) || _users[user.id] != user) {
				_users[user.id] = user;
				(user as UserData).dispatchDataUpdate();
			}
			return user;
		}
		
		public function createUserFromData(data:Object):IUserData{
			return new UserData(data);
		}
		
		public function addUserFromData(data:Object,_isWeak:Boolean = true):IUserData {
			var uid:String = Utils.validate(data,"userId") ? data["userId"] : data["masterId"];;
			var user:UserData = null;
			if (hasUser(uid)) {
				user = _users[uid];
				user.update(data,_isWeak);
			} else {
				user = new UserData(data,_isWeak);
				_users[user.id] = user;
				user.dispatchDataUpdate();
			}
			return user;
		}
		
		public function addUserFormSpeaker(data:Object):IUserData
		{
			var uid:String = Utils.validate(data,"userId") ? data["userId"] : data["masterId"];;
			var user:UserData = null;
			if(!hasUser(uid))
			{
				user = new UserData(data,false);
				_users[user.id] = user;
				_e.send(SEvents.USER_INIT_FROM_SPEAK,user);
			}else{
				user = _users[uid];
				user.isWeak = false;
			}
			return user;
		}
		
		public function addMicUserFormatData(data:Object):IUserData
		{			
			var user:IUserData = data as IUserData;
			
			if(user)
			{
				var index:int = this.getMicUserIndex(user.id);
				if(index==-1)
				{
					this._miclist.push(user);
				}
			}
			return user;
		}
		
		public function removeMicUseById(value:String):IUserData
		{
			var index:int = this.getMicUserIndex(value);
			if(index!=-1)
			{
				return this._miclist.splice(index,1)[0];
			}
			return null;
		}
		
		/**
		 * 获取用户在当前麦序列表里的位置
		 *  
		 * @param id 用户id
		 * @return 顺序,从0开始
		 */		
		private function getMicUserIndex(id:String):int
		{
			for(var i:uint = 0;i<this._miclist.length;i++)
			{
				if(this._miclist[i].id == id)
				{
					return i;
				}
			}
			return -1;
		}
		
		public function getUserMicStatus(id:String):int
		{
			var micStatus:int = 0;
			
			var index:int = this.getMicUserIndex(id);
			if(index!=-1)
			{
				micStatus = 1;
			}
			
			if(getMicIndex(id) != -1){
				micStatus = 2;
			}
			return micStatus;
		}
		
//		public function getUserBatch(ids:Array, onGet:Function):void {
//			//声明一个局部方法,用递归来管理多个异步加载
//			var start:Function = function (s:Array, f:Function, d:Array):void {
//				var i:int = d.length;
//				var t:Array = [];
//				var len:int = (i + BATCH_REQ_NUM) > s.length ? (s.length - i) : BATCH_REQ_NUM;
//				for (var j:int = 0; j < len; j ++) {
//					var id:String = s[i + j];
//					getUserAsync(id, function (data:IUserData):void {
//						t.push(data);
//						if (t.length == len) {
//							d = d.concat(t);
//							if (d.length == s.length) {
//								onGet(d);
//							} else {
//								start(s, f, d);
//							}
//						}
//					});
//				}
//			};
//			start(ids, onGet, []);
//		}
		
//		public function getUserAsync(id:String, onGet:Function):void {
//			if (hasUser(id)) {
//				//缓存
//				onGet(_users[id]);
//			} else {
//				if (!inAsync(id, onGet)) {
//					//取
//					var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
//					s.http.getData("http://show.17173.com/i_info.action", null, function (data:Object):void {
//						var u:UserData = new UserData();
//						u.update(data);
//						
//						onGet(u);
//					});
//				}
//			}
//		}
		
		public function getUserBatchByPage(page:int, size:int):void {
			if(_isGetting)return;
			if (!_inited) {
				_postListRequests.push({"page":page, "size":size});
			} else {
				_isGetting = true;
				var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
				s.socket.send(SEnum.S_USER_LIST, {"pno":page, "rpp":size});				
			}			
		}
		
//		/**
//		 * 处理异步缓存队列.
//		 * 如果异步队列中没有当前id的请求,则缓存起来.
//		 *  
//		 * @param id
//		 * @param callback
//		 */		
//		private function inAsync(id:String, callback:Function):Boolean {
//			var c:Array = _asyncPool.hasOwnProperty(id) ? _asyncPool[id] : [];
//			if (c.indexOf(callback) == -1) {
//				c.push(callback);
//				_asyncPool[id] = c;
//				return false;
//			} else {
//				return true;
//			}
//		}
		
		public function hasUser(id:String):Boolean {
			return _users.hasOwnProperty(id);
		}
		
		public function getUser(id:String):IUserData {
			if (hasUser(id)) {
				return _users[id];
			} else {
				//Debugger.log(Debugger.ERROR, "[USER]", "查找用户失败，用户ID: " + id);
				return null;
			}
		}
		
		/**
		 * 验证用户是否可执行某项操作
		 * @param target 用户vo
		 * @param action 执行的操作
		 * @return 用户权限返回数据
		 * 
		 */		
		public function validateAuthority(target:IUserData, action:String):IAuthorityData
		{
			var re:Object = IAuthority(Context.getContext(CEnum.AUTHORITY)).getAuthorityInfo(target.auth, action);
			var aut:AuthorityData = new AuthorityData();
			if (re) {
				//权限中是否直接有可操作的选项
				if (re.hasOwnProperty("can")) {
					aut.can = re["can"];
				} else {
					aut.can = false;
				}
				//可操作的限制
				if (re.hasOwnProperty("limit")) {
					if (re["limit"] && re["limit"].hasOwnProperty("min")) {
						aut.limit = re["limit"]["min"];
					} else {
						aut.limit = -1;
					}
					//限制的特殊形态：财富登记
					if (re["limit"] && re["limit"].hasOwnProperty("wealth")) {
						if (target.richLevel >= re["limit"]["wealth"]) {
							aut.can = true;
						} else {
							aut.can = false;
						}
					}
				} else {
					aut.limit = -1;
				}
			}
//			Debugger.log(Debugger.INFO, "[权限验证]" +　"用户组：" + target.auth + "   事件:" + action + "结果:" + aut.can + "   限制条件：" + aut.limit);
			return aut;
		}
		
		/**
		 * 验证用户A是否有对用户B执行X操作的权限
		 * @param target 用户A
		 * @param action x操作
		 * @param to 用户B
		 * @return 用户权限返回数据
		 * 
		 */		
		public function validateAuthorityTo(target:IUserData, action:String, to:IUserData):IAuthorityData
		{
			var authA:Array = target.auth;
			var authB:Array = to.auth;
			var re:Object = IAuthority(Context.getContext(CEnum.AUTHORITY)).getAuthorityInfo(authA, action);
			var canDo:int = -1;
			//权限中是否直接有可操作的选项
			if (re.hasOwnProperty("can")) {
				canDo = re["can"] == true || re["can"] == "true" ? canDo = 1 : canDo = -1;
			} else {
				canDo = -1;
			}
			if (re.hasOwnProperty("limit")) {
				//获取可用户操作的对象列表
				if (re["limit"] && re["limit"].hasOwnProperty("list")) {
					var list:Array = re["limit"]["list"];
					for (var i:int = 0; i < authB.length; i++) {
						if (canDo == 0) {
							break;
						}
						//查询被操作用户的权限是否有可操作对象列表之外的
						if (list.indexOf(int(authB[i])) == -1) {
							canDo = 0;
							break;
						} else {
							//查看可操作用户权限是否有特殊要求
							if (re["limit"] && re["limit"].hasOwnProperty("broadcaster")) {
								for (var item:String in re["limit"]["broadcaster"]) {
									if (item == authB[i]) {
										if (int(target.starLevel) >= int(re["limit"]["broadcaster"][item])) {
											canDo = 1;
										} else {
											canDo = 0;
										}
									} else {
										canDo = 1;
									}
								}
							} else {
								canDo = 1;
							}
						}
					}
				}
			}
			var v:AuthorityData = new AuthorityData();
			v.can = canDo == 1 ? true : false;
			v.limit = -1;
//			Debugger.log(Debugger.INFO, "[权限验证]" +　"用户组：" + authA + "   事件:" + action + "被操作用户组:" + authB + "结果:" + v.can);
			return v;
		}
		
		public function showCard(userID:String, stagePos:Point = null, filterList:Array = null,isAuto:Boolean = true):void {
			if(userID!=null)
			{
				var u:IUserData = getUser(userID);
				if(u&&!u.isWeak){
					_e.send(SEvents.SHOW_USER_CARD, {"user":u, "pos":stagePos, "filterList":filterList,"isAuto":isAuto});
				}
			}
//			if (_card) {
//				_card.showCard(UserCardData.wrapperUser(userData), stagePos);
//				_cardUser = null;
//			} else {
//				if (!_cardItem) {
//					var p:IPluginManager = Context.getContext(CEnum.PLUGIN) as IPluginManager;
//					_cardItem = p.getPlugin(PEnum.USER_CARD);
//					_cardItem.addEventListener(PluginEvents.COMPLETE, onUserCardLoaded);
//				}
//				_cardUser = {"user":userData, "pos":stagePos};
//			}
		}
		
		public function autoHideCard():void
		{
			_e.send(SEvents.HIDE_USER_CARD);
		}
		
//		/**
//		 * 用户卡片加载完成.
//		 *  
//		 * @param e
//		 */		
//		private function onUserCardLoaded(e:Event):void {
//			_cardItem.removeEventListener(PluginEvents.COMPLETE, onUserCardLoaded);
//			//获取card
//			_card = ExternalPluginItem(_cardItem).warpper as IUserCard;
//			_cardItem = null;
//			
//			if (_cardUser) {
//				_card.showCard(UserCardData.wrapperUser(_cardUser.user), _cardUser.pos);
//				_cardUser = null;
//			}
//		}
		
		public function get contextName():String
		{
			return CEnum.USER;
		}
		
		public function startUp(param:Object):void
		{
			_users = new Dictionary();
			_asyncPool = new Dictionary();
			_inited = false;
			_postListRequests = [];
			
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			//等待应用初始化完成,监听用户数据相关接口
			_e.listen(SEvents.APP_INIT_COMPLETE, onInitDataListeners);
		}
		
		private function onInitDataListeners(data:Object = null):void {
			_inited = true;
			var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//用户退出房间
			s.socket.listen(SEnum.R_USER_EXIT.action, SEnum.R_USER_EXIT.type, onUserExit);
			//用户登陆
			s.socket.listen(SEnum.R_USER_ENTER.action, SEnum.R_USER_ENTER.type, onUserEnter);
			//用户列表更新
			s.socket.listen(SEnum.R_USER_LIST.action, SEnum.R_USER_LIST.type, onUserListUpdate);
			//用户等级提升
			s.socket.listen(SEnum.R_USER_INFO_UPDATE.action,SEnum.R_USER_INFO_UPDATE.type,onUserLevelUp);
			//管理员踢人
			s.socket.listen(SEnum.R_KICK_USER.action, SEnum.R_KICK_USER.type, onKickUser);
			//修改用户名消息
			s.socket.listen(SEnum.R_RENAME.action, SEnum.R_RENAME.type,updateUserName);
			//服务器同步用户数量
			s.socket.listen(SEnum.R_MEMBER_COUNT_CHANGE.action,SEnum.R_MEMBER_COUNT_CHANGE.type,function(value:Object):void
			{
				_count = value["ct"];
				Debugger.log(Debugger.INFO,"[user] 服务器同步用户数：",_count);
				_e.send(SEvents.USER_COUNT_CHANGED, _count);
			});
			s.socket.listen(SEnum.R_GUEST_COUNT.action,SEnum.R_GUEST_COUNT.type,function(value:Object):void
			{
				_guestTotal = value["ct"];
				Debugger.log(Debugger.INFO,"[user] 服务器同步游客数：",_guestTotal);
				_e.send(SEvents.UPDATE_GUEST_COUNT, _guestTotal);
			});
				
			
			var o:Object = null;
			while (_postListRequests && _postListRequests.length > 0) {
				o = _postListRequests.shift();
				getUserBatchByPage(o.page, o.size);
			}
			_postListRequests = null;
//			s.socket.send(SEnum.S_USER_LIST, {});
		}
		
		/**
		 * 修改用户名
		 */
		private function updateUserName(data:Object):void
		{
			/*data.ct.userId
			data.ct.name*/
			var userInfo:Object = data["ct"];	
			userInfo.userName = userInfo.name;
			this.addUserFromData(userInfo);
			
			_e.send(SEvents.USER_NAME_UPDATE,data);
		}
		
		/**
		 * 踢人操作
		 */
		private function onKickUser(data:Object):void
		{
			var obj:Object = {};
			obj["timestamp"] = data["timestamp"];
			obj["opUser"] = data.hasOwnProperty("userInfo") ? data["userInfo"] : null;
			obj["toUser"] = data.hasOwnProperty("toUserInfo") ? data["toUserInfo"] : null;
			
			_e.send(SEvents.USER_KICK_OUT, obj, null, true);
			
			if(obj["toUser"])
			{
				var id:String = obj["toUser"]["userId"];
				if (hasUser(id)) {
					delete _users[id];
					_count--;
					_e.send(SEvents.USER_COUNT_CHANGED, _count);
					/*if(int(id)<0)
					{
						_guestTotal -= (_guestTotal > 0 ? 1 : 0);
						_e.send(SEvents.UPDATE_GUEST_COUNT,_guestTotal);
					}*/
					checkUserList();
				}
			}
		}
		
		private function onUserLevelUp(value:Object):void
		{
			var data:Object=value["ct"];
			if(data.type==2)
			{
				data.masterLevel=data.level;
			}else if(data.type==3){
				data.fanLevel=data.level;
			}	
			data["timestamp"] = value["timestamp"];
			data.userInfo.userId=data.userInfo.masterId;
			//更新用户等级
			data.userInfo=this.addUserFromData(data);
			//聊天信息
			_e.send(SEvents.USER_LEVEL_UP,data);
		}
		
		/**
		 * 用户退出房间. 
		 */		
		private function onUserExit(data:Object):void {
			var id:String = data["masterId"];
			if(id == me.id)
			{
				//自己离开房间或者被离开
				return;
			}
			var user:IUserData = null;
			//如果此用户在当前缓存中有,则删掉
			if (hasUser(id)) {
				user = _users[id];
				delete _users[id];
			} else {
				user = new UserData(data);
			}
			_count --;
			_e.send(SEvents.USER_EXIT, {"user":user,"timestamp":data["timestamp"]});
			/*if(!user.isLogin)
			{
				_guestTotal -= (_guestTotal > 0 ? 1 : 0);
				_e.send(SEvents.UPDATE_GUEST_COUNT,_guestTotal);
			}*/
			//用户数变更
			_e.send(SEvents.USER_COUNT_CHANGED, _count);
			checkUserList();
		}
		
		private function checkUserList():void
		{
			if(_count<40&&!_checked)
			{
				_checked = true;
				this.getUserBatchByPage(1,40);
			}else if(_count>40){
				_checked = false;
			}
		}
		
		/**
		 * 用户登陆房间. 
		 */		
		private function onUserEnter(data:Object):void {
			var id:String = data["masterId"];
			var user:IUserData = null;
			if (!_users.hasOwnProperty(id)) {
				user = addUserFromData(data.ct,false);	
				_count ++;
			} else {
				user = getUser(id);
				(user as UserData).update(data.ct,false);
			}			
			_e.send(SEvents.USER_ENTER, {"user":user,"timestamp":data["timestamp"]});
			//用户数变更
			_e.send(SEvents.USER_COUNT_CHANGED, _count);
			
			/*if(!user.isLogin)
			{
				_guestTotal++;
				_e.send(SEvents.UPDATE_GUEST_COUNT,_guestTotal);
			}*/
			//商品到期提示
			if(user.id==me.id&&user.expireSoon)
			{
				Context.getContext(CEnum.EVENT).send(SEvents.ADD_INFO_TO_CHAT,{info:(Context.getContext(CEnum.LOCALE) as ILocale).get("goodsNotice","chatPanel"),color:0xCC9966,isPrivate:1});
			}
			//判断用户是否有进场动画
			if(user.hidden != 1 &&  user.extInfo && user.extInfo.hasOwnProperty("enterEffect") && user.extInfo.enterEffect == 1){
				//发送进场动画事件
				_e.send(SEvents.GIFT_BIG_ENTER,user);
				//判断如果有提示需要发送到聊天
				if(user.extInfo.hasOwnProperty("enterEffectTip") && user.extInfo.enterEffectTip != ""){
					var tip:String = user.extInfo.enterEffectTip;
					//替换人名
					tip = tip.replace("[cName]",user.name);
					Context.getContext(CEnum.EVENT).send(SEvents.ADD_INFO_TO_CHAT,{info:tip,color:0xFF9900});
				}
			}
//			_e.send(SEvents.GIFT_BIG_ENTER,user);
			checkUserList();
		}
		
		/**
		 * 用户列表更新. 
		 */		
		private function onUserListUpdate(data:Object):void {
			//页数,人数
			var info:Object = data.ct[0];
			//麦序
			var micList:Object = data.ct[1]["miclist"];
			//用户
			var userList:Object = data.ct[1]["ulist"];
			//管理员
			var adminList:Object = data.ct[1]["adminlist"];
			
			//是否有下一页
			if (info.nextflag == 1) {
				_hasNextPage = true;
			} else {
				_hasNextPage = false;
			}
			
			var users:Array = [];
			for each (var obj:Object in userList) {
				var uid:String = obj.masterId;
				users.push(addUserFromData(obj,false));
			}
			
			obj=null;
			this._miclist.length = 0;
			for each(obj in micList)
			{
				if(this._miclist.indexOf(this.getUser(obj.masterId))==-1)
				{
					obj.micStatus = 1;
					var user:IUserData = this.addUserFromData(obj,false);
					this._miclist.push(user);
				}
			}
			
			obj=null;
			this._adminlist.length = 0;
			for each(obj in adminList)
			{
				if(this._adminlist.indexOf(this.getUser(obj.masterId))==-1)this._adminlist.push(this.addUserFromData(obj,false));
			}					
			
			//超出服务器页数之后取消page赋值
			if(users.length!=0)
			{				
				_page = info.pno;
			}
			_count = info.ucount;
			
			//Debugger.log(_count<0?Debugger.WARNING:Debugger.INFO," 服务器返回人数："+_count, " 是否有下页："+info.nextflag, " 当前批用户人数："+users.length, " 麦序人数："+this._miclist.length, " 管理员人数："+this.adminList.length);
			//用户列表变更
			_e.send(SEvents.USER_LIST_UPDATE, users);
			//用户数变更
			_e.send(SEvents.USER_COUNT_CHANGED, _count);	
			
			_isGetting = false;
		}
		
		public function get adminList():Array
		{			
			return this._adminlist;
		}
		
		public function get micList():Array
		{
			return this._miclist;
		}
		
		public function get page():int {
			return _page;
		}
		
		public function get count():int {
			return Math.max(0, _count);
		}
		
		public function get guestTotal():uint
		{
			return _guestTotal;
		}

		public function get privateChatFilterDic():Dictionary
		{
			return _privateChatFilterDic;
		}

		public function set privateChatFilterDic(value:Dictionary):void
		{
			_privateChatFilterDic = value;
		}
		
		
		public function orderArray():Array{
			var orderArray:Array = new Array();
			var array:Array = Context.variables.showData.getMicData();
			var userData:IUserData;
			if(array.length > 0){
				for(var i:int = 0 ;i < array.length ;i++){
					var obj:Object = array[i];
					if(obj && obj.masterId != 0){
						userData = getUser(obj.masterId);
						orderArray.push(userData);
					}else{
						orderArray.push(null);
					}
				}
			}
			return orderArray;
		}
		
		public function getMicIndex(userId:String):int{
			var index:int = -1;
			var array:Array = Context.variables.showData.getMicData();
			if(array.length > 0){
				for(var i:int = 0 ;i < array.length ;i++){
					var obj:Object = array[i];
					if(obj && obj.masterId != 0){
						if(obj.masterId == userId){
							index = i+1;
						}
					}
				}
			}
			return index;
		}

	}
}