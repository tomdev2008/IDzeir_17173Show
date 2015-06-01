package com._17173.flash.show.module.userlist.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.module.userlist.view.IUserList;
	import com._17173.flash.show.base.module.userlist.view.ListEvent;
	import com._17173.flash.show.base.module.userlist.view.UserListItem;
	import com._17173.flash.show.base.module.userlist.view.UserListPanel;
	import com._17173.flash.show.base.module.userlist.view.UserListTabContainer;
	import com._17173.flash.show.model.CEnum;
	import com.greensock.TweenMax;
	
	import flash.events.Event;

	/**
	 * 用户列表模块
	 * @author idzeir
	 * 创建时间：2014-2-11  下午3:05:56
	 */
	public class UserList extends BaseModule implements IUserList
	{
		private var panelMap:Vector.<UserListPanel> = new Vector.<UserListPanel>();

		private var tabPanel:UserListTabContainer;

		private var userListPanelUI:UserListPanel;
		
		private var masterListPanelUI:UserListPanel;
		/**
		 * 当前的显示状态 
		 */		
		private var _isShow:Boolean = false;
		
		/**
		 * 缩放时候最小的高度
		 */
		private var _min_Height:int  = 567;
		/**
		 * 初始化标识 显示到舞台后才=true 
		 */		
		private var _inited:Boolean = false;

		public function UserList()
		{
			super();
			_version = "1.8.1";
			addChildren();
		}
		/**
		 * 初始化标识  显示到舞台后才=true 
		 */	
		public function get inited():Boolean
		{
			return _inited;
		}
		
		/**
		 * 当前的显示状态 
		 * @return 
		 */		
		public function get isShow():Boolean
		{
			return _isShow;
		}

		/**
		 * 初始化ui界面 
		 */		
		private function addChildren():void
		{
			drawBorder();
			
			tabPanel = new UserListTabContainer();
			//观众列表
			userListPanelUI = new UserListPanel(UserListItem);
			userListPanelUI.showGuest = true;
			userListPanelUI.addEventListener(ListEvent.TOUCH_BOTTOM, onNextPage);
			tabPanel.addItem("user", Context.getContext(CEnum.LOCALE).get("peoTab", "userList"), userListPanelUI);
			//管理员列表
			masterListPanelUI = new UserListPanel(UserListItem);
			tabPanel.addItem("master", Context.getContext(CEnum.LOCALE).get("masTab", "userList"), masterListPanelUI);

			tabPanel.x = tabPanel.y = 1.5;
			panelMap.push(userListPanelUI, masterListPanelUI);
			enableListByIndex(0);
			tabPanel.addEventListener(Event.CHANGE, changeHandler);
			this.addChild(tabPanel);
			
			/* 功能隐藏
			var close:Button = new Button();
			close.setSkin(new UserListArrowSkin1_8());
			close.x = this.width - close.width*.5 - 5;
			close.y = close.height*.5 + 5;
			close.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
			{
				e.stopImmediatePropagation();
				e.stopPropagation();
				show();
			});
			
			this.addChild(close);*/
			
			Context.stage.addEventListener(Event.RESIZE,onResize);
			onResize();			
		}
		
		/**
		 * 自适应高度 
		 * @param event
		 */		
		protected function onResize(event:Event=null):void
		{
			var theight:int = Math.max((Context.getContext(CEnum.UI) as IUIManager).sceneRect.height - 120,this._min_Height);
			
			userListPanelUI.height = theight;
			masterListPanelUI.height = theight;
			this.tabPanel.update();
			drawBorder(theight);
		}
		
		/**
		 * 滑动到用户列表底部请求新数据 
		 * @param event
		 */		
		protected function onNextPage(event:ListEvent):void
		{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.hasNextPage)
			{
				user.getUserBatchByPage(user.page + 1, 20);
			}
		}


		/**
		 * 清空用户列表
		 */
		public function clear():void
		{
			for each(var i:UserListPanel in panelMap)
			{
				i.clear();
			}
		}
		
		/**
		 *  激活指定的tab标签页，非激活状态的页面将缓存数据
		 * @param value tab的索引
		 */		
		private function enableListByIndex(value:uint):void
		{
			for(var i:uint = 0; i < panelMap.length; i++)
			{
				panelMap[i].locked = (i != value)
			}
		}
		
		/**
		 * 切换tab标签 处理 
		 * @param event
		 */		
		protected function changeHandler(event:Event):void
		{
			enableListByIndex(tabPanel.selectedIndex);
		}
		/**
		 * 绘制用户列表边框 背景 
		 * @param height
		 */		
		private function drawBorder(height:int = 515):void
		{
			this.graphics.clear();
			//this.graphics.lineStyle(1, /*0x763ea5*/ 0x500093, .7);
			this.graphics.beginFill(0x22022a, 1);
			this.graphics.drawRoundRect(0, 0, 176, height, 3, 3);
			this.graphics.endFill();
		}
		
		/**
		 * 三麦统一接口（单麦未实现） 
		 * @param arr
		 */		
		public function changeMicList(arr:Array):void
		{
		}
		
		/**
		 * 清空用户列表 
		 */		
		public function exitAll():void
		{
			//观众列表
			panelMap[0].clear();
			//管理员列表
			panelMap[1].clear();
		}
		
		/**
		 * 用户离开房间 
		 * @param user 用户信息
		 * @param type 操作的tab索引 0=观众列表，1=管理员列表，2=麦序列表
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
				//panelMap[2].removeItem(int(user.id));
			}
		}
		
		/**
		 * 用户进入房间 
		 * @param user 用户信息
		 * @param type 操作的tab索引 0=观众列表，1=管理员列表，2=麦序列表
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
			}
			if(type == 1)
			{
				panelMap[1].addItem(user);
			}
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
		
		/**
		 * 列表中的用户升级 
		 * @param user 用户信息 
		 */		
		public function levelUp(user:IUserData):void
		{
			panelMap[0].levelUp(user);
			panelMap[1].levelUp(user);
		}
		
		/**
		 * 用户列表批量更新数据 
		 * @param value 用户信息组
		 * @param type 操作的tab索引 0=观众列表，1=管理员列表，2=麦序列表
		 * 
		 */		
		public function updateList(value:Array, type:uint = 0):void
		{
			for each(var i:IUserData in value)
			{
				this.entryUser(i, type);
			}
		}
		
		/**
		 * 隐藏用户列表接口 
		 */		
		public function hiden():void
		{
			_isShow = false;
			TweenMax.to(this, .3, {x:-this.width, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[false]});
		}
		/**
		 * 显示用户列表接口 
		 */		
		public function show():void
		{
			_inited = true;
			_isShow = !_isShow;
			this.mouseChildren = false;
			if(_isShow)
			{
				this.visible = _isShow;
				TweenMax.fromTo(this, .3, {x:-this.width}, {x:50, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[true]});
			}
			else
			{
				TweenMax.to(this, .3, {x:-this.width, onUpdate:onUpdate, onComplete:onComplete, onCompleteParams:[false]});
			}
		}
		/**
		 * 用户列表动画执行完毕处理 
		 * @param bool 调用的显示类型true=显示，false=隐藏
		 */		
		private function onComplete(bool:Boolean):void
		{
			this.mouseChildren = true;
			this.visible = bool;
		}
		
		/**
		 * 旧版本做聊天跟随效果 
		 * 
		 */		
		private function onUpdate():void
		{
			
		}
		/**
		 * 三麦房间自己排麦打开麦序列表功能 
		 * @param index
		 */		
		public function goto(index:int):void
		{
			//单麦房不存在麦序，取消弹出麦序列表
		}
	}
}