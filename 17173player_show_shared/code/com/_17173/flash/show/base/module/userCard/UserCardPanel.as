package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.show.base.components.common.UserItemRender;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 用户选项卡面板.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCardPanel extends BasePanel
	{
		
		/**
		 * 卡片数据 
		 */		
		private var _data:IUserCardData = null;
		/**
		 * 基本信息面板. 
		 */		
		private var _infoContainer:UserItemRender = null;
		/**
		 * 身份信息图标 
		 */		
		private var _roleInfoContainer:UserCardRoleInfoItem = null;
		/**
		 * 分隔用户信息面板和基本操作面板 
		 */		
		private var _line1:DisplayObject = null;
		/**
		 * 基本操作面板 
		 */		
		private var _baseActionPanel:UserCardAuthActionList = null;
		/**
		 * 分隔基本操作面板和扩展操作面板 
		 */		
		private var _line2:DisplayObject = null;
		/**
		 * 扩展权限操作面板 
		 */		
		private var _expandActionPanel:UserCardExtendAuthActionList = null;

		private var _line0:DisplayObject;
		
		public function UserCardPanel()
		{
			super();
			
			this.setSkin_line(null);
			this.setSkin_Close(null);
			if(this.title)
			{
				title.visible = false;
			}
			
			width = 165;
			height = 10;
		}
		
		public function set data(value:IUserCardData):void {
			_data = value;
			
			createCards();
			createLines();
			updateCards();
			updateLines();
			
			if (_expandActionPanel) {
				height = _expandActionPanel.y + _expandActionPanel.height + 12;
			} else {
				height = _baseActionPanel.y + _baseActionPanel.height + 12;
			}
		}
		
		public function get data():IUserCardData {
			return _data;
		}
		
		protected function createCards():void {
			if (_infoContainer == null) {
				_infoContainer = new UserItemRender();
				_infoContainer.hideVip = false;
				addChild(_infoContainer);
			}
			if(_roleInfoContainer == null) {
				_roleInfoContainer = new UserCardRoleInfoItem();
				addChild(_roleInfoContainer);
			}
			if (_baseActionPanel == null) {
				_baseActionPanel = new UserCardAuthActionList();
				_baseActionPanel.addEventListener("actionSelected", onActionSelected);
				addChild(_baseActionPanel);
			}
			var expandArr:Array = _data.expandActions;
			if (expandArr && expandArr.length > 0 && _expandActionPanel == null) {
				_expandActionPanel = new UserCardExtendAuthActionList();
				_expandActionPanel.addEventListener("actionSelected", onActionSelected);
				addChild(_expandActionPanel);
			}
		}
		
		/**
		 * 点击了某个action后会触发事件,此处为回调.
		 *  
		 * @param event
		 */		
		protected function onActionSelected(event:Event):void {
			var target:UserCardBaseActionList = event.target as UserCardBaseActionList;
			var data:Object = target.selected;
			if (data) {
				hide();
				var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
				//将事件和用户id发出去
				e.send(data.event, data.uid);
			}
		}
		
		protected function createLines():void {
			if(_line0 == null && _roleInfoContainer) {
				_line0 = createLine();
				_line0.width = 161;
				_line0.height = 2;
				_line0.x = 2;
				addChild(_line0);
			}				
			if (_line1 == null && _baseActionPanel) {
				_line1 = createLine();
				_line1.width = 161;
				_line1.height = 2;
				_line1.x = 2;
				addChild(_line1);
			}
			if (_line2 == null && _expandActionPanel) {
				_line2 = createLine();
				_line2.width = 161;
				_line2.height = 2;
				_line2.x = 2;
				addChild(_line2);
			}
		}
		
		/**
		 * 创建一条线.
		 *  
		 * @return 
		 */		
		private function createLine():MovieClip {
			var line:MovieClip = new Line_Normal();
			line.x = 1;
			line.mouseChildren = false;
			line.mouseEnabled = false;
			return line;
		}
		
		protected function updateCards():void {
			_infoContainer.x = 5;
			_infoContainer.y = 5;
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			_infoContainer.user = user.getUser(_data.uid);
			_roleInfoContainer.user = user.getUser(_data.uid);
			var offsetY:Number = 0;
			if(_roleInfoContainer.hasGraphic)
			{					
				_roleInfoContainer.x = 10;
				_roleInfoContainer.y = 65;
				offsetY = 35;		
			}
			if (_baseActionPanel) {
				_baseActionPanel.data = _data.baseActions;
				_baseActionPanel.x = 10;
				if (_data.baseActions.length > 0) {
					_baseActionPanel.y = 55 + 9 + offsetY;//list的顶部需要与头部有个15像素的间隔
				} else {
					_baseActionPanel.y = 53 + offsetY;
				}
			}
			if (_expandActionPanel) {
				_expandActionPanel.data = _data.expandActions;
				_expandActionPanel.x = 10;
				if (_data.expandActions.length > 0) {
					_expandActionPanel.y = _baseActionPanel.y + _baseActionPanel.height + 20;
				} else {
					_expandActionPanel.y = _baseActionPanel.y + _baseActionPanel.height;
				}
			}
			
		}
		
		private function updateLines():void {
			var offsetY:Number = 0;
			if(_line0) {
				if (_roleInfoContainer && _roleInfoContainer.hasGraphic) {
					_line0.visible = true;
					_line0.y = 55;
					offsetY = 35;
				} else {
					_line0.visible = false;
				}
			}
			if (_line1) {
				//没有数据时候隐藏line
				if (_infoContainer&&_data.baseActions.length>0) {
					_line1.visible = true;
					_line1.y = 55 + offsetY;
				} else {
					_line1.visible = false;
				}
			}
			if (_line2) {
				if (_baseActionPanel) {
					//没有数据时候隐藏line
					if (_expandActionPanel && _data.expandActions.length > 0) {
						_line2.visible = true;
						_line2.y = _baseActionPanel.y + _baseActionPanel.height + 10;
					} else {
						_line2.visible = false;
					}
				} else {
					_line2.visible = false;
				}
			}
		}
		
		////////////////////////
		//
		// 置空
		//
		////////////////////////
		override protected function initTitle():void {
		}
	}
}