package com._17173.flash.show.base.module.bottombar
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.bottombar.service.BottomButtonManager;
	import com._17173.flash.show.base.module.bottombar.view.BottomBarUI;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class BottomBar extends BaseModule implements IButtonManager
	{
		private var _barUI:BottomBarUI = null;
		private var _buttonManager:BottomButtonManager;
		private var _hornMsgCache:Array = null;
		private var _added:Boolean = false;
		
		public function BottomBar()
		{
			super();
			_version = "0.0.3";
		}
		
		override protected function init():void{
			_barUI = new BottomBarUI();
			_hornMsgCache = [];
			this.mouseEnabled = false;
			_barUI.mouseEnabled = false;
			this.addChild(_barUI);
			//初始化按钮
			addServerLsn();
			addEventLsn();
			initButton();
		}
		
		
		private function addEventLsn():void{
			var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			event.listen(BottomEvents.EDIT_GONGGAO,editGonggao);
			event.listen(BottomEvents.MOVE_USER,moveUser);
			event.listen(SEvents.UPLOAD_OL_VIDEO_CLICK,showOlVideo);
			event.listen(SEvents.CHANGE_BOTTOM_BUTTON,updateButtons);
			//测试功能,关闭
//			event.listen(SEvents.USER_ENTER, showNotification);
			event.listen(SEvents.CHANGE_SELF_NAME,updateUserInfo);
			event.listen(SEvents.HORN_MESSAGE,showHornMsg);
			event.listen(SEvents.HORN_MESSAGE_CACHE,onHornMsg);
			event.listen(SEvents.CHANGE_VIDEO_STATUS,changeMaiLabel);
			event.listen(SEvents.CHANGE_BOTTOM_BUTTON_LABEL,onChangeLabel);
			event.listen(SEvents.CHANGE_PUBLICCHAT_CLICK,onClickChangePublicChat);
			event.listen(SEvents.CHANGE_ROOMGIFT_EFFECT_CLICK,onClickChangeGiftEff);
			event.listen(SEvents.PUBLIC_CHAT_CHANGE,changePublicLabel);
			event.listen(SEvents.GIFT_EFF_CHANGE,changeGiftEffLabel); 
			event.listen(SEvents.USER_AUTH_CHANGED,onButtonRef);
			event.listen(SEvents.USER_DATA_UPDATE,onUserInfoChange);
			event.listen(SEvents.CHANGE_ROOM_STATUS,onChangeRoomStatusLabel);
			event.listen(SEvents.BOTTOM_CAMER_CLICK,sendClick4Type);
			event.listen(SEvents.USER_NAME_UPDATE,onNameChange);
		}
		/**
		 *显示缓存 
		 * @param e
		 * 
		 */		
		override protected function onAdded(e:Event):void{
			_added = true;
			showCacheHorn();
		}
		/**
		 *用户信息更新 
		 * @param data
		 * 
		 */		
		private function onUserInfoChange(data:Object = null):void{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.me && user.me.id == data){
				updateUserInfo(null);
			}
		}
		/**
		 *更新名字后刷新底栏名字 
		 * @param data
		 * 
		 */		
		private function onNameChange(data:Object):void{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.me && data && (user.me.id == data.ct.userId)){
				updateUserInfo(null);
			}
		}
		
		/**
		 *刷新按钮 
		 * @param data
		 * 
		 */		
		private function onButtonRef(data:Object = null):void{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.me.id == (data as String)){
				updateButtons();
			}
		}
		
		/**
		 *改变按钮label 
		 * @param data
		 * 
		 */	
		private function changePublicLabel(data:Object):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var labelsrt:String  = local.get("btn_label_openpublic", "bottom");
			var showData:ShowData = Context.variables["showData"] as ShowData;
			if(showData.publicChat == 1){
				labelsrt = local.get("btn_label_closepublic", "bottom");
			}
			onChangeLabel({label:labelsrt,type:SEvents.CHANGE_PUBLICCHAT_CLICK});
		}
		/**
		 *改变按钮label 
		 * @param data
		 * 
		 */		
		private function changeGiftEffLabel(data:Object):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var labelsrt:String  = local.get("btn_label_opengifteff", "bottom");
			var showData:ShowData = Context.variables["showData"] as ShowData;
			if(showData.selfGiftShow == 1){
				labelsrt = local.get("btn_label_closegifteff", "bottom");
			}
			onChangeLabel({label:labelsrt,type:SEvents.CHANGE_ROOMGIFT_EFFECT_CLICK});
		}
		/**
		 *关闭公聊 
		 * @param data
		 * 
		 */		
		private function onClickChangePublicChat(data:Object):void{
			var showdata:ShowData = Context.variables["showData"]as ShowData;
			if(showdata.publicChat == 0){
				//开启
				openPublic();
			}else{
				//关闭
				var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.popupAlert(local.get("title_close_public","bottom"),local.get("cont_close_public","bottom"),-1,Alert.BTN_OK|Alert.BTN_CANCEL,closePublic);
			}
		}
		/**
		 *开启公聊 
		 * 
		 */		
		private function closePublic():void{
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//提交数据
			var data:Object = {};
			data.flag = 0;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.CHANGE_PUBLICCHAT,data,onPublicChatSecc,onFail);
		}
		/**
		 *关闭公聊 
		 * 
		 */		
		private function openPublic():void{
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			var data:Object = {};
			data.flag = 1;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.CHANGE_PUBLICCHAT,data,onPublicChatSecc,onFail);
		}
		
		private function onPublicChatSecc(data:Object):void{
			//不做任何操作
		}
		
		private function onFail(data:Object):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			ui.popupAlert(local.get("system_title","components"),data.msg,-1,Alert.BTN_OK);
		}
		
		/**
		 * 点击关闭礼物效果
		 * @param data
		 * 
		 */		
		private function onClickChangeGiftEff(data:Object):void{
			var showdata:ShowData = Context.variables["showData"]as ShowData;
			if(showdata.selfGiftShow == 0){
				//开启
				openGiftEff();
			}else{
				//关闭
				var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.popupAlert(local.get("title_close_gift","bottom"),local.get("cont_close_gift","bottom"),-1,Alert.BTN_OK|Alert.BTN_CANCEL,closeGiftEff);
			}
		}
		/**
		 *开启礼物效果 
		 * 
		 */		
		private function openGiftEff():void{
			var showdata:ShowData = Context.variables["showData"]as ShowData;
			showdata.selfGiftShow = 1;
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.GIFT_EFF_CHANGE);
		}
		/**
		 *关闭礼物效果 
		 * 
		 */		
		private function closeGiftEff():void{
			var showdata:ShowData = Context.variables["showData"]as ShowData;
			showdata.selfGiftShow = 0;
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.GIFT_EFF_CHANGE);
		}
		
		
//		private function showNotification(data:Object):void
//		{
//			if (_userLoginNotification == null) {
//				_userLoginNotification = new UserLoginNotificationPanel();
//				
//				var scenePos:SceneElement = new SceneElement();
//				scenePos.content = _userLoginNotification;
//				scenePos.isAbsolute = false;
//				scenePos.bottom = 54;
//				scenePos.right = 10;
//				var event:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
//				event.send(SEvents.REG_SCENE_POS, scenePos);
//			}
//			_userLoginNotification.data = data.user;
//		}

		private function addServerLsn():void{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			server.socket.listen(SEnum.R_ROOM_GONGGAO.action, SEnum.R_ROOM_GONGGAO.type,updateGonggao);
			
		}
		
		
		private function initButton():void{
			_buttonManager = new BottomButtonManager();
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.me.isLogin){
				updateUserInfo(null);
				initBtns();
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BOTTOM_BUTTON_CMP);
			}
		} 
		/**
		 *初始化按钮与更新按钮规则不一致 
		 * 
		 */		
		private function initBtns():void{
			removeAllButtons();
			addButtons(_buttonManager.getButtonDatas());
			_barUI.resize();
		}
		
		private function updateButtons(data:Object = null):void{
			removeAllButtons();
			var user:User = Context.getContext(CEnum.USER) as User;
			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "用户按钮检测,用户权限: " + user.me.auth.join(","));
			addButtons(_buttonManager.getButtonDatas());
			_barUI.resize();
		}
		
		private function updateUserInfo(data:Object):void{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			_barUI.updateUserInfo(user.me);
		}
		/**
		 *打开公告板子 
		 * @param data
		 * 
		 */		
		private function editGonggao(data:Array):void{
			var pot:Point = data[0];
			_barUI.onEditGonggaoClick(pot);
		}
		/**
		 *转移用户面板 
		 * @param data
		 * 
		 */		
		private function moveUser(data:Array):void{
			var pot:Point = data[0];
			_barUI.onChangeRoomClick(pot);
		}
		/**
		 *显示离线录像 
		 * @param data
		 * 
		 */		
		private function showOlVideo(data:Array):void{
			var pot:Point = data[0];
			_barUI.showHideOffLineVidew(pot);
		}
		/**
		 *显示缓存 
		 * 
		 */		
		private function showCacheHorn():void{
			var data:Object;
			var len:int = _hornMsgCache.length;
			for (var i:int = 0; i < len; i++) 
			{
				data = _hornMsgCache[i];
				showHornMsg(data);
			}
			_hornMsgCache = [];
			
		}
		
		private function onHornMsg(data:Object):void{
			_hornMsgCache[_hornMsgCache.length] = data;
			if(_added){
				showCacheHorn();
			}
		}
		/**
		 *接受到喇叭消息 
		 * @param data
		 * 
		 */		
		private function showHornMsg(data:Object):void{
			_barUI.addMessage(data);
		}
		/**
		 *改变麦状态按钮label 
		 * @param data
		 * 
		 */		
		private function changeMaiLabel(data:Object):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			//当前麦状态 正式接入后调用真是数据
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var labels:Array = [local.get("btn_label_actionmai","bottom"),local.get("btn_label_cancalmai","bottom"),local.get("btn_label_exitmai","bottom")];
			_barUI.updateButtonLabel(SEvents.REQUEST_MAI_CLICK,labels[user.getUserMicStatus(user.me.id)]);
		}
		/**
		 *改变开启房间按钮label 
		 * @param data
		 * 
		 */		
		private function onChangeRoomStatusLabel(data:Object):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var showData:ShowData = Context.variables["showData"] as ShowData;
			var labels:Array = [local.get("btn_label_openroom","bottom"),local.get("btn_label_closeroom","bottom")];
			_barUI.updateButtonLabel(SEvents.CHANGE_ROOM_STATUS_CLICK,labels[showData.roomStatus]);
		}
		
		/**
		 *接受到公告信息改变的消息 
		 * @param data
		 * 
		 */		
		private function updateGonggao(data:Object):void{
			//解析公告数据
			var showData:ShowData = Context.variables["showData"] as ShowData
			var obj:Object = data.ct;
			showData.announcement = obj;
			var data:Object = showData.announcement;
			_barUI.updateGonggao();
			
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.CHANGE_GONGGAO);
		}
		/**
		 *添加按钮 
		 * 
		 */		
		public function addButtons(buttons:Array):void{
			_barUI.addButtons(buttons);
		}
		/**
		 *移除所有按钮 
		 * 
		 */		
		public function removeAllButtons():void{
			_barUI.removeAllButtons();
		}
		/**
		 *移除按钮 
		 * 
		 */		
		public function removeButtons(buttons:Array):void{
			_barUI.removeButtons(buttons);
		}
		/**
		 *变更按钮label 
		 * @param data
		 * 
		 */		
		public function onChangeLabel(data:Object):void{
			_barUI.updateButtonLabel(data.type,data.label);
		}
		/**
		 *添加消息 
		 * 
		 */		
		private function addMessage():void{
			_barUI.addMessage(null);
		}
		/**
		 *改变登录状态 
		 * 
		 */		
		public function changeLoginState():void{
			_barUI.changeLogin(true);
		}
		
		/**
		 *强制点击 
		 * @param type
		 * 
		 */		
		private function sendClick4Type(type:String):void{
			_barUI.sendClick4Type(type);
		}
		
	}
}