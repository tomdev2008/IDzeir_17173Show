package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.components.common.UserItemRender;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.bottombar.BottomBar;
	import com._17173.flash.show.base.utils.LoginUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 *ui 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomBarUI extends SkinComponent
	{
		private var _userButton:UserButton = null;
		private var _gonggaoButton:GonggaoButton = null;
		private var _userInfo:UserItemRender  = null;
		private var _buttomBar:BottomButtonBar = null;
		private var _loginBtn:Button = null;
		private var _registerBtn:Button = null;
		private var _gonggaoPanel:GongGaoPanel = null;
		private var _userInfoPanel:UserInfoPanel = null;
		private var _editGonggaoPanel:GongGaoEditPanel = null;
		private var _changeRoomPanel:ChangeRoomPanel = null;
		private var _showMessageUI:BottomShowMessage = null;
		private var _sendMessageUI:BottomSendMessage = null;
		private var _offlineVideo:OffLineVideoPanel = null;
		private var _ggMessage:Sprite = null;
		private var _parentbar:BottomBar = null;
		/**
		 *互斥面板
		 */		
		private var _closePanels:Array = null;
		/**
		 *是否显示发送信息中 
		 */		
		private var _showSendmessage:Boolean = false;
		/**
		 *面板容器 
		 */		
		public var panelCn:Sprite = null;
		
		private var _userInfoSp:Sprite = null;
		
		public function BottomBarUI()
		{
			super();
			this.mouseEnabled = false;
		}
		
		override protected function onInit():void{
			super.onInit();
			panelCn = new Sprite();
			this.addChild(panelCn);
			
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			setSkin_Bg(new Bottom_BG());
			this.width = 1920;
			this.height = 50;
			//用户列表
			_userButton = new UserButton();
			_userButton.setSkin(new Bottom_btn_Bg());
			_userButton.x = 0;
			_userButton.y = 1;
//			ui.registerTip(_userButton,lc.get("user_list_tip","bottom"));
			this.addChild(_userButton);
			
			var _line:MovieClip = new Bottom_Line();
			_line.mouseEnabled = false;
			_line.x = _userButton.width; 
			_line.y = 1;
			_line.height = 47;
			this.addChild(_line);
			//公告按钮
			_gonggaoButton = new GonggaoButton();
			_gonggaoButton.setSkin(new Bottom_btn_Bg());
			_gonggaoButton.x = _userButton.x + _userButton.width + 2;
			_gonggaoButton.y = 1;
//			ui.registerTip(_gonggaoButton,lc.get("room_gg_tip","bottom"));
			this.addChild(_gonggaoButton);
			
			_line = new Bottom_Line();
			_line.mouseEnabled = false;
			_line.x = _gonggaoButton.x + _gonggaoButton.width;
			_line.y = 1;
			_line.height = 47;
			this.addChild(_line);
			//登录
			_loginBtn = new Button("登录");
			_loginBtn.setSkin(new Butoon_LoginBg())
			_loginBtn.x = 137;
			_loginBtn.y = 9;
			_loginBtn.width = 65;
			_loginBtn.height = 30;
			this.addChild(_loginBtn);
			
			//注册
			_registerBtn = new Button("注册");
			_registerBtn.x = _loginBtn.x + _loginBtn.width + 7;
			_registerBtn.y = 9;
			_registerBtn.width = 65;
			_registerBtn.height = 30;
			this.addChild(_registerBtn);
			//用户信息
			_userInfo = new UserItemRender();
			_userInfo.x = 131 ;
			_userInfo.y = -2;
			_userInfo.buttonMode = true;
			this.addChild(_userInfo);
			_userInfo.visible = false;
			
			_userInfoSp = new Sprite();
			_userInfoSp.x = 131;
			_userInfoSp.y = -2;
			_userInfoSp.buttonMode = true;
			this.addChild(_userInfoSp);
			_userInfoSp.visible = false;
			//按钮组
			_buttomBar = new BottomButtonBar();
			_buttomBar.height = 45;
			_buttomBar.x = 341;
			this.addChild(_buttomBar)
			_buttomBar.visible = false;
			
			_ggMessage = new Sprite();
			_ggMessage.mouseEnabled = false;
			_ggMessage.x = this.width - 434
			_ggMessage.y = 11;
			this.addChild(_ggMessage);
			
			//显示消息
			_showMessageUI = new BottomShowMessage();
			_showMessageUI.x = 0;
			_showMessageUI.y = -2;
			_showMessageUI.visible = true;
			_showMessageUI.closeCallBack = showSendMsg;
			_ggMessage.addChild(_showMessageUI);
			//发送消息
			_sendMessageUI = new BottomSendMessage();
			_sendMessageUI.x = 440;
			_sendMessageUI.y = -2;
			_sendMessageUI.visible = false;
			_sendMessageUI.closeCallBack = showMessage;
			_ggMessage.addChild(_sendMessageUI);
			_closePanels = [];
		} 
		
		
		override protected function onShow():void{
			_userButton.addEventListener(MouseEvent.CLICK, onUserClick);
			_gonggaoButton.addEventListener(MouseEvent.CLICK, onGonggaoClick);
			_loginBtn.addEventListener(MouseEvent.CLICK, onLoginClick);
			_registerBtn.addEventListener(MouseEvent.CLICK, onRegisterClick);
			_userInfoSp.addEventListener(MouseEvent.CLICK, onInfoClick);
		}
		
		override protected function onHide():void{
			_userButton.removeEventListener(MouseEvent.CLICK, onUserClick);
			_gonggaoButton.removeEventListener(MouseEvent.CLICK, onGonggaoClick);
			_loginBtn.removeEventListener(MouseEvent.CLICK, onLoginClick);
			_registerBtn.removeEventListener(MouseEvent.CLICK, onRegisterClick);
			_userInfoSp.addEventListener(MouseEvent.CLICK, onInfoClick);
		}
		
		override protected function onUpdate():void{
			checkLoginState();
		}
		
		
		/**
		 *更新容器位置 
		 * 
		 */		
		override protected function onRePosition():void{
			_buttomBar.x = _userInfo.x + _userInfo.width + 15;
			_ggMessage.x = this.width - 434;
			_ggMessage.x = this.width - 434;
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize();
			//判断当前窗口是否大于最小宽度
//			if(Context.stage.stageWidth >= limitWidth){
				this.width = Context.stage.stageWidth;
//			}else{
//				this.width = limitWidth;
//			}
		}
		/**
		 *当前容器最小宽度 
		 * @return 
		 * 
		 */		
		override public function get limitWidth():int{
			//左边按钮宽度 + 用户信息宽度 + 按钮栏宽度 + 右边信息宽度
			return 131 + _userInfo.width + 15 + _buttomBar.width + 10 + 435;
		}
		
		private function onUserClick(e:Event):void{
			var button:DisplayObject = e.currentTarget as DisplayObject;
			var pot:Point = this.globalToLocal(button.localToGlobal(new Point(0, 0)));
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.OPEN_USER_LIST);
		}
		
		private function onInfoClick(e:Event):void{
			var button:DisplayObject = e.currentTarget as DisplayObject;
			var pot:Point = this.globalToLocal(button.localToGlobal(new Point(0, 0)));
			showHideUserInfo(pot);
			e.stopImmediatePropagation();
		}
		
		private function onLoginClick(e:Event):void{
			Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
		}
		
		private function onRegisterClick(e:Event):void{
			//跳转注册 并注册完返回首页
			Util.toUrl(LoginUtil.getRegUrl());
		}
		
		/**
		 *显示广播消息UI 
		 * 
		 */		
		private function showMessage():void{
			hideSendToRight();
		}
		
		/**
		 *显示发送消息UI 
		 * 
		 */		
		private function showSendMsg():void{
			//检测是否登录，如果登录则显示发送消息，如果未登录则弹出登录框;
			var showdata:ShowData = Context.variables["showData"] as ShowData;
			if(showdata.masterID !=null && int(showdata.masterID) > 0){
				showSendToLeft();
			}else{
				Context.getContext(CEnum.EVENT).send(SEvents.LOGINPANEL_SHOW);
			}
			
		}
		
		
		private function showSendToLeft():void{
			_sendMessageUI.visible = true;
			TweenLite.to(_sendMessageUI,.3,{x:0});
			_showMessageUI.visible = true;
//			_sendMessageUI.visible = true;
		}
		
		private function hideSendToRight():void{
			TweenLite.to(_sendMessageUI,.3,{x:440,onComplete:onRighted});
//			_sendMessageUI.visible = false;
		}
		
		private function onRighted():void{
			_showMessageUI.visible = true;
		}
		
		/**
		 *点击公告按钮 
		 * @param e
		 * 
		 */		
		public function onGonggaoClick(e:Event):void{
			var button:DisplayObject = e.currentTarget as DisplayObject;
			var pot:Point = this.globalToLocal(button.localToGlobal(new Point(0, 0)));
			
			if(_gonggaoPanel && panelCn.contains(_gonggaoPanel)){
				hideGonggao();
			}else{
				showGonggao(pot);
			}
			e.stopImmediatePropagation();
		}
		
		public function updateGonggao():void{
			if(_gonggaoPanel && panelCn.contains(_gonggaoPanel)){
				_gonggaoPanel.update();
			}
		}
		
		/**
		 *更新用户信息 
		 * @param data
		 * 
		 */		
		public function updateUserInfo(data:Object):void{
			_userInfo.user = Context.getContext(CEnum.USER).me;
//			_userInfo.updateFace();
//			_userInfo.addIcon();
			
			_userInfoSp.graphics.clear();
			_userInfoSp.graphics.beginFill(0x000000,.01);
			_userInfoSp.graphics.drawRect(0,0,_userInfo.width,_userInfo.height);
			_userInfoSp.graphics.endFill();
			resize();
		}
		
		/**
		 *检测是否登录 
		 * 
		 */		
		private function checkLoginState():void{
			//检测是否登录用户
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var showData:ShowData = Context.variables["showData"] as ShowData;
			if(showData.masterID !=null && int(showData.masterID) > 0){
				changeLogin(true);
				//加载自己用户
				updateUserInfo(user.me);
				if(_showSendmessage){
					showSendMsg();
				}else{
					showMessage();
				}
			}else{
				changeLogin(false);
			}
			resize();
			Debugger.log(Debugger.INFO, "[信息输出]", "用户ID",user.me.id);
		}
		
		/**
		 *添加按钮 
		 * @param data
		 * 
		 */		
		public function addButtons(data:Array):void{
			_buttomBar.addButtons(data);
			resize();
		}
		
		/**
		 *移除按钮 
		 * @param data
		 * 
		 */		
		public function removeButtons(data:Array):void{
			_buttomBar.removeButtons(data);
			resize();
		}
		/**
		 *移除所有按钮 
		 * 
		 */		
		public function removeAllButtons():void{
			_buttomBar.removeAllButton();
			resize();
		}
		
		/**
		 * 登录登出对界面的操作
		 * 
		 */		
		public function changeLogin(logined:Boolean = false):void{
				_userInfo.visible = logined;
				_userInfoSp.visible = logined;
				_buttomBar.visible = logined;
				_loginBtn.visible = !logined;
				_registerBtn.visible = !logined;
		}
		/**
		 *外部强制发送按钮点击 
		 * @param type
		 * 
		 */		
		public function sendClick4Type(type:String):void{
			_buttomBar.sendClick4Type(type);
		}
		/**
		 *点击转移观众按钮 
		 * 
		 */		
		public function onChangeRoomClick(pot:Point):void{
			if(_changeRoomPanel && panelCn.contains(_changeRoomPanel)){
				hideChangeRoom();
			}else{
				showChangeRoom(pot);
			}
		}
		
		/**
		 *点击修改公告 
		 * 
		 */		
		public function onEditGonggaoClick(pot:Point):void{
			if(_editGonggaoPanel && panelCn.contains(_editGonggaoPanel)){
				hideEditGonggao();
			}else{
				showEditGonggao(pot);
			}
		}
		
		
		private function showEditGonggao(pot:Point):void{
			if(_editGonggaoPanel == null){
				_editGonggaoPanel = new GongGaoEditPanel();
				addToClosePanel(_editGonggaoPanel);
			}
			_editGonggaoPanel.x = pot.x + 3;
			_editGonggaoPanel.y =  - (_editGonggaoPanel.height + 5); 
			panelCn.addChild(_editGonggaoPanel);
			closeOther(_editGonggaoPanel);
		}
		
		public function hideEditGonggao():void{
			if(_editGonggaoPanel && panelCn.contains(_editGonggaoPanel)){
				panelCn.removeChild(_editGonggaoPanel);
			}
		}
		
		public function showHideOffLineVidew(pot:Point):void{
			if(_offlineVideo && panelCn.contains(_offlineVideo)){
				hideOLView();
			}else{
				showOLView(pot);
			}
		}
		
		/**
		 *显示
		 * @param data
		 * 
		 */		
		public function showOLView(pot:Point):void{
			if(_offlineVideo == null){
				_offlineVideo = new OffLineVideoPanel();
				addToClosePanel(_offlineVideo);
			}
			_offlineVideo.x  = pot.x + 3;
			_offlineVideo.y =  -(_offlineVideo.height  + 5); 
			panelCn.addChild(_offlineVideo);
			
			closeOther(_offlineVideo);
		}
		/**
		 *隐藏公告 
		 * 
		 */		
		public function hideOLView():void{
			if(_offlineVideo && panelCn.contains(_offlineVideo)){
				panelCn.removeChild(_offlineVideo);
			}
		}
		
		
		/**
		 *显示 
		 * @param data
		 * 
		 */		
		public function showGonggao(pot:Point):void{
			if(_gonggaoPanel == null){
				_gonggaoPanel = new GongGaoPanel();
				addToClosePanel(_gonggaoPanel);
			}
			_gonggaoPanel.x  = pot.x + 3;
			_gonggaoPanel.y =  - (_gonggaoPanel.height  + 5); 
			panelCn.addChild(_gonggaoPanel);
			
			closeOther(_gonggaoPanel);
		}
		/**
		 *隐藏公告 
		 * 
		 */		
		public function hideGonggao():void{
			if(_gonggaoPanel && panelCn.contains(_gonggaoPanel)){
				panelCn.removeChild(_gonggaoPanel);
			}
		}
		/**
		 *关闭移动观众界面 
		 * 
		 */		
		public function hideChangeRoom():void{
			if(_changeRoomPanel && panelCn.contains(_changeRoomPanel)){
				panelCn.removeChild(_changeRoomPanel);
			}
		}
		/**
		 *显示移动观众 
		 * 
		 */		
		
		public function showChangeRoom(pot:Point):void{
			if(_changeRoomPanel == null){
				_changeRoomPanel = new ChangeRoomPanel();
				addToClosePanel(_changeRoomPanel);
			}
			_changeRoomPanel.x  = pot.x + 3;
			_changeRoomPanel.y =  - (_changeRoomPanel.height + 5); 
			panelCn.addChild(_changeRoomPanel);
			
			closeOther(_changeRoomPanel);
		}
		
		
		/**
		 *打开关闭用户信息 
		 * 
		 */		
		public function showHideUserInfo(pot:Point):void{
			if(_userInfoPanel == null){
				_userInfoPanel = new UserInfoPanel();
				addToClosePanel(_userInfoPanel);
			}
			_userInfoPanel.x = pot.x + 3;
			_userInfoPanel.y = - (_userInfoPanel.height + 5);
			if(_userInfoPanel.parent){
				_userInfoPanel.parent.removeChild(_userInfoPanel);
			}else{
				panelCn.addChild(_userInfoPanel);
				closeOther(_userInfoPanel);
			}
		}
		/**
		 *更新按钮label 
		 * @param type 按钮事件类型
		 * @param newLabel 按钮label
		 * @param newType 新类型(是否需要修改类型，默认为不修改)
		 * 
		 */		
		public function updateButtonLabel(type:String, newLabel:String, newType:String = null):void{
			_buttomBar.updateLabel(type, newLabel);
			resize();
		}
		
		/**
		 *添加消息 
		 * 
		 */		
		public function addMessage(msg:Object):void{
			_showMessageUI.addMessage(msg);
		}
		
		private function get bottomBar():BottomBar{
			if(_parentbar == null){
				_parentbar = this.parent as BottomBar; 
			}
			return _parentbar;
		}
		
		/**
		 *添加 到互斥面板
		 * @param panel
		 * 
		 */		
		private function addToClosePanel(panel:DisplayObject):void {
			var added:Boolean = false;
			var ds:DisplayObject;
			var len:int = _closePanels.length
			for (var i:int = 0; i < len; i++) {
				ds = _closePanels[i];
				if(ds === panel){
					added = true;
					break;
				}
			}
			if (!added) {
				_closePanels[_closePanels.length] = panel;
			}
		}
		
		/**
		 *关闭其他面板 
		 * @param panel
		 * 
		 */		
		private function closeOther(panel:DisplayObject):void {
			var ds:DisplayObject;
			var len:int = _closePanels.length
			for (var i:int = 0; i < len; i++) {
				ds = _closePanels[i];
				if (ds != panel) {
					if (ds.parent) {
						ds.parent.removeChild(ds);
					}
				}
			}
		}
		
	}
}