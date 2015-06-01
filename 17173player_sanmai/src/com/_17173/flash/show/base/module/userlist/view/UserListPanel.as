package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.components.common.Grid9Skin;
	import com._17173.flash.show.base.components.common.SimpleUserInfoRender;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Point;

	[Event(name="touchListBottom", type="com._17173.flash.show.base.module.userlist.view.UserListEvent")]
	/**
	 * @author idzeir
	 * 创建时间：2014-2-12  下午5:49:53
	 */
	public class UserListPanel extends VGroup
	{
		protected var userList:AscList;

		private var _islocked:Boolean = false;
		/**
		 * 列表缓存的数据
		 */
		private var cacheMap:Array = [];
		/**
		 * 当前显示中的数据
		 */
		private var dataArr:Array = [];

		private var _tag:String = "";

		public function UserListPanel(itemRender:Class = null)
		{
			super();
			userList = new AscList(477, false, itemRender ? itemRender : SimpleUserInfoRender);
			userList.sliderSkin(new Grid9Skin(Slider_thumb_sanmai));
			userList.addEventListener(ProgressEvent.PROGRESS, onMaxScroll);
			userList.addEventListener(Event.SELECT, selectHandler);
			userList.width = 210;
			addChild(userList);				
		}

		public function get tag():String
		{
			return _tag;
		}

		public function set tag(value:String):void
		{
			_tag = value;
		}


		protected function onMaxScroll(event:ProgressEvent):void
		{
			if(event.bytesTotal==event.bytesLoaded)
			{
				if(this.hasEventListener(UserListEvent.TOUCH_LIST_BOTTOM))
				{
					//滚动条到达底部触发事件
					this.dispatchEvent(new UserListEvent(UserListEvent.TOUCH_LIST_BOTTOM));
				}
			}
		}


		// 没用了，可以删除		
		protected function selectHandler(event:Event):void
		{
			var ievent:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			var stagePos:Point = this.localToGlobal(new Point(this.width, this.y));
		}

		override public function get width():Number
		{
			return userList.width;
		}

		/**
		 * 设置列表数据
		 * @param data
		 *
		 */
		public function dataProvider(data:Array):void
		{
			userList.clear();
			dataArr.length = 0;

			//如果为非激活状态，缓存数据
			if(this._islocked)
			{
				//cacheMap.length = 0;
				//cacheMap=data.concat();
				data.forEach(function(e:*, index:int, arr:Array):void
					{
						addItem(e);
					});

				return
			}

			dataArr = data.concat();

			sortOwner();

			userList.dataProvider = dataArr;
		}

		/**
		 * 添加一条用户数据
		 * @param data
		 * @return
		 *
		 */
		public function addItem(data:Object):DisplayObject
		{
			if(this._islocked)
			{
				//锁定状态下缓存数据，下次激活时候再进行添加显示
				push({type: 1, data: data, id: data.hasOwnProperty("user") ? data.user.id : data.id});
				return null;
			}
			if(indexOf(data.id) != -1 || data.hasOwnProperty("user") && indexOf(data.user.id) != -1)
			{
				return null;
			}
			dataArr.push(data);

			//sortOwner();			
			
			//服务器已经设置单麦房房主sortNum 100亿
			var owner:int = indexOfOwner();
			
			if(owner != -1)
			{
				(dataArr[owner] as IUserData).sortNum=10E10;
			}			
			
			var item:DisplayObject = userList.addItem(data);
			
			//如果是游客不进行排序，直接扔最后面
			if(tag!="mic"&&!isGuest(data as IUserData)){
				userList.relist();
			}			
			return item;
		}
		/**
		 * 用户等级提升，刷新列表排序 
		 * @param user
		 * 
		 */		
		public function levelUp(user:IUserData):void
		{
			var showData:ShowData = Context.variables["showData"];
			
			//用户已经在列表中
			if(user&&indexOf(user.id)>=0)
			{
				//非房主
				if(tag!="mic")
				{
					//单麦房主不刷，三麦全刷
					if(showData.type == "0")
					{
						var ownerID:String = showData["roomOwnMasterID"];
						if(ownerID!=user.id)
						{
							userList.relist();
						}
					}else{
						userList.relist();
					}					
				}
			}
		}
		
		private function isGuest(user:IUserData):Boolean
		{
			return Number(user.id)<0;
		}

		/**
		 * 单麦房提升房主的位置
		 *
		 */
		private function sortOwner():void
		{
			if(tag != "mic")
			{
				dataArr.sortOn("sortNum", Array.NUMERIC | Array.DESCENDING);
				var ownerIndex:int = indexOfOwner();
				//房主进入房间并且不在第一个位置，提升到第一位
				if(ownerIndex != -1 && ownerIndex != 0)
				{
					dataArr.unshift(dataArr.splice(ownerIndex, 1)[0]);
				}
			}
		}

		/**
		 * 查找房主在用户列表中的sortNum排位
		 * @return
		 *
		 */
		private function indexOfOwner():int
		{
			var showData:ShowData = Context.variables["showData"];
			//单麦房0,三麦1
			if(showData.type == "0")
			{
				//本地测试没有房主数据，排序按三麦房执行
				var owner:IUserData = (Context.getContext(CEnum.USER) as IUser).getUser(showData["roomOwnMasterID"]);
				if(owner)
				{
					//返回-1时候房主未进入房间
					return dataArr.indexOf(owner);
				}
				//没找到房主数据
				return -1;
			}
			//不是单麦房
			return -1;
		}

		/**
		 * 判断制定id用户是否已经显示到列表中了
		 * @param uid 用户id
		 * @return 返回在列表中的显示位置，-1时为未显示
		 *
		 */
		private function indexOf(uid:String):int
		{
			for(var i:uint = 0; i < dataArr.length; i++)
			{
				if(this._tag != "mic" && dataArr[i].id == uid || dataArr[i].hasOwnProperty("user") && dataArr[i].user.id == uid)
				{
					return i;
				}
			}
			return -1;
		}

		/**
		 * 删除用户
		 * @param uid
		 *
		 */
		public function removeItem(uid:int):void
		{
			if(this._islocked)
			{
				//非激活状态，先缓存数据，激活之后删除
				push({type: 2, data: uid, id: uid});
				return;
			}

			if(indexOf(String(uid)) == -1)
			{
				return;
			}
			dataArr.splice(indexOf(String(uid)), 1);
			//userList.dataProvider = dataArr;
			userList.removeItemByKey("id", uid);
		}

		/**
		 * 清除列表中的数据
		 *
		 */
		public function clear():void
		{
			this.cacheMap.length = 0;
			this.dataArr.length = 0;
			userList.clear();
		}

		/**
		 * 当前显示条数
		 * @return
		 *
		 */
		public function get size():uint
		{
			return userList.size;
		}

		/**
		 * 锁定列表之后，只缓存数据，不在更新界面
		 * @param bool
		 *
		 */
		public function set locked(bool:Boolean):void
		{
			this._islocked = bool;
			if(!bool)
			{
				//切换到激活状态时，清理缓存 的数据
				update();
			}
		}

		public function get locked():Boolean
		{
			return this._islocked
		}		
		
		/**
		 * 添加锁定状态下的缓存数据 
		 * @param data
		 * 
		 */		
		private function push(value:Object):void
		{
			if (cacheMap.length > 0)
			{
				for (var i:uint = 0; i < cacheMap.length; i++)
				{
					if (cacheMap[i]&&cacheMap[i].id == value.id)
					{
						//置空旧状态，清理数据时候跳过
						cacheMap[i] = null;
					}
				}				
			}
			cacheMap.push(value);
		}

		/**
		 * type = 1时为添加用户列表和管理员列表，type = 2时为删除用户，其它为添加麦序列表
		 *
		 */
		override public function update():void
		{
			for each(var i:Object in cacheMap)
			{
				if(i==null)continue;
				if(i.type == 1)
				{
					this.addItem(i.data);
						//userList.addItem(i.data);
				}
				else if(i.type == 2)
				{
					//userList.removeItemByKey("id",i.data);
					this.removeItem(i.data)
				}
				else
				{
					if(i.user)
						this.addItem(i);
				}
			}
			cacheMap.length = 0;
		}

		/**
		 * 用户数据更新
		 * @param value 用户id
		 *
		 */
		public function userUpdate(value:String):void
		{
			if(this.indexOf(value)==-1)
			{
				return;
			}
			var data:*;
			if(tag != "mic")
			{
				data = (Context.getContext(CEnum.USER) as IUser).getUser(value);
			}
			else
			{
				data = userList.getItem("id", value);
				if(data)
				{
					data.user = (Context.getContext(CEnum.USER) as IUser).getUser(value);
				}					
			}
			if(data)
			{
				userList.updateItem("id", value, data);
			}			
		}
	}
}