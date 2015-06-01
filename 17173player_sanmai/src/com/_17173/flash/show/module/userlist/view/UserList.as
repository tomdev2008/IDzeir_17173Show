package com._17173.flash.show.module.userlist.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.userlist.view.IUserListManager;
	import com._17173.flash.show.base.module.userlist.view.MicItemRender;
	import com._17173.flash.show.base.module.userlist.view.UserListEvent;
	import com._17173.flash.show.base.module.userlist.view.UserListPanel;
	import com._17173.flash.show.base.module.userlist.view.UserListTabContainer;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenMax;

	import flash.events.Event;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-11  下午3:05:56
	 */
	public class UserList extends BaseModule implements IUserListManager
	{
		/**用户列表组*/
		private var panelMap:Vector.<UserListPanel> = new Vector.<UserListPanel>();
		/**用户列表tab容器*/
		private var tabPanel:UserListTabContainer;
		/**用户列表当前显示状态*/
		private var _isShow:Boolean = false;

		public function UserList()
		{
			super();
			addChildren();
		}

		public function get isShow():Boolean
		{
			return _isShow;
		}

		/**
		 * 初始化可见组件
		 *
		 */
		private function addChildren():void
		{
			drawBorder();

			tabPanel = new UserListTabContainer();
			//用户列表
			var userListPanelUI:UserListPanel = new UserListPanel();
			userListPanelUI.addEventListener(UserListEvent.TOUCH_LIST_BOTTOM, onNextPage);
			tabPanel.addItem("user", Context.getContext(CEnum.LOCALE).get("peoTab", "userList"), userListPanelUI);
			//管理员列表
			var masterListPanelUI:UserListPanel = new UserListPanel();
			tabPanel.addItem("master", Context.getContext(CEnum.LOCALE).get("masTab", "userList"), masterListPanelUI);
			//麦序列表
			var micListPanelUI:UserListPanel = new UserListPanel(MicItemRender);
			micListPanelUI.tag = "mic";
			tabPanel.addItem("mic", Context.getContext(CEnum.LOCALE).get("micTab", "userList"), micListPanelUI);

			tabPanel.x = tabPanel.y = 1.5;
			panelMap.push(userListPanelUI, masterListPanelUI, micListPanelUI);

			enableListByIndex(0);
			tabPanel.addEventListener(Event.CHANGE, changeHandler);
			this.addChild(tabPanel);

		}

		/**
		 * 请求下一页用户数据
		 * @param event
		 *
		 */
		protected function onNextPage(event:UserListEvent):void
		{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.hasNextPage || true)
			{
				user.getUserBatchByPage(user.page + 1, 20);
					//Debugger.tracer("请求下页："+(user.page+1));	
			}
			else
			{
				//trace("没有下一页了")
			}
		}

		/**
		 * 清空用户列表
		 *
		 */
		public function clear():void
		{
			for each(var i:UserListPanel in panelMap)
			{
				i.clear();
			}
		}

		/**
		 * 锁定非激活的列表
		 * @param value
		 *
		 */
		private function enableListByIndex(value:uint):void
		{
			for(var i:uint = 0; i < panelMap.length; i++)
			{
				panelMap[i].locked = (i != value)
			}
		}

		protected function changeHandler(event:Event):void
		{
			enableListByIndex(tabPanel.selectedIndex);
		}

		/**
		 * 绘制用户列表背景和边框线
		 *
		 */
		private function drawBorder():void
		{
			this.graphics.lineStyle(1, /*0x763ea5*/ 0x500093, .7);
			this.graphics.beginFill(0x000000, .65);
			this.graphics.drawRoundRect(0, 0, 215, 515, 3, 3);
			this.graphics.endFill();
		}

		/**
		 * 重置用户麦序列表数据
		 * @param arr
		 *
		 */
		public function changeMicList(arr:Array):void
		{
			panelMap[2].clear();
			panelMap[2].dataProvider(arr);
		}

		/**
		 * 清空用户列表和管理员列表，麦序列表服务器记录的数据，防止掉线，不能清除
		 *
		 */
		public function exitAll():void
		{
			panelMap[0].clear();
			panelMap[1].clear();
		}

		/**
		 * 删除用户
		 * @param user
		 * @param type 指定的删除列表 0为用户列表和管理员列表，1为管理员列表，2为麦序列表
		 *
		 */
		public function exitUser(user:IUserData, type:uint = 0):void
		{
			if(user == null)
				return;
			if(type == 0)
			{
				//防止麦序用户掉线重新排麦，服务器记录麦序列表定时推送下麦消息，用户离开不操作麦序
				panelMap[0].removeItem(int(user.id));
				panelMap[1].removeItem(int(user.id));
			}
			else if(type == 1)
			{
				panelMap[1].removeItem(int(user.id));
			}
			else if(type == 2)
			{
				panelMap[2].removeItem(int(user.id));
			}
		}

		/**
		 * 用户进入
		 * @param user
		 * @param type 0为用户列表，1为管理员列表，2为麦序列表
		 *
		 */
		public function entryUser(user:IUserData, type:uint = 0):void
		{
			if(user == null)
			{
				return;
			}

			if(type == 0)
			{
				panelMap[0].addItem(user);
					//if(user.isAdmin)panelMap[1].addItem(user);
			}
			if(type == 1)
				panelMap[1].addItem(user);
			if(type == 2)
				panelMap[2].addItem(user);
		}
		/**
		 * 用户数据更新
		 * @param value
		 *
		 */
		public function userUpdate(value:String):void
		{
			for each(var i:UserListPanel in panelMap)
			{
				i.userUpdate(value);
			}
		}
		
		public function levelUp(user:IUserData):void
		{
			panelMap[0].levelUp(user);
			panelMap[1].levelUp(user);
		}

		/**
		 * 向某个列表中添加一批数
		 * @param value
		 * @param type 0为用户列表，1为管理员列表，2为麦序列表
		 *
		 */
		public function updateList(value:Array, type:uint = 0):void
		{
			for each(var i:IUserData in value)
			{
				this.entryUser(i, type);
			}
		}


		public function show():void
		{
			_isShow = !_isShow;
			if(_isShow)
			{
				this.visible = _isShow;
				TweenMax.to(this, .3, {x:0, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[true]});
			}
			else
			{
				TweenMax.to(this, .3, {x:-this.width, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[false]});
			}
		}
		private function onComplete(bool:Boolean):void
		{
			var _ieventManager:IEventManager = (Context.getContext(CEnum.EVENT) as IEventManager);
			//_ieventManager.send(SEvents.USER_LIST_MOVE_COMPLETE, {x:this.x, y:this.y, width:Math.min(216,this.width), height:this.height});
			this.visible = bool;
		}
		private function onUpdate():void
		{
			var _ieventManager:IEventManager = (Context.getContext(CEnum.EVENT) as IEventManager);
			_ieventManager.send(SEvents.USER_LIST_POSITION_UPDATE, {x:this.x, y:this.y, width:Math.min(216,this.width), height:this.height})
		}

		public function goto(index:int):void
		{
			tabPanel.goto(index);
			_isShow = this.visible = true;
			TweenMax.to(this, .3, {x:0, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[true]});
		}

		override public function set x(value:Number):void
		{
			if(!this.visible)
				return;
			super.x = value;
			onUpdate();
		}
		override public function set y(value:Number):void
		{
			//舞台resize时候会导致y位置错误，取消y只设置的屏蔽
			//if(!this.visible)return;
			super.y = value;
			onUpdate();
		}
	}
}