package com._17173.flash.show.base.module.roomset
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.components.common.plugbutton.IconAlignType;
	import com._17173.flash.show.base.components.common.plugbutton.MenuButton;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.bottombar.BottomEvents;
	import com._17173.flash.show.base.module.bottombar.IButtonManager;
	import com._17173.flash.show.base.module.roomset.common.BottomButtonManager;
	import com._17173.flash.show.base.module.roomset.view.OpertView;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class RoomSet extends BaseModule implements IButtonManager
	{
		private var _buttonManager:BottomButtonManager;
		private var _hornMsgCache:Array = null;
		private var _added:Boolean = false;
		private var _opertView:OpertView;
		private var _display:Boolean = false;
		private var _e:IEventManager;
		private var _s:IServiceProvider;
		private var _plgBtn:MenuButton;
		
		public function RoomSet()
		{
			super();
			_version = "0.0.0";
			
			//检查权限是否添加功能入口
			checkIsAddModEnter();
			
			addServerLsn();//暂时为了解决 socket消息广播
		}
		
		private function initRoom():void{
			
			_hornMsgCache = [];
			this.mouseEnabled = false;
			_opertView = new OpertView();
			_opertView.mouseEnabled = false;
			this.addChild(_opertView);
			//初始化按钮
			//addServerLsn();
			addEventLsn();			
		}
		
		private function addEventLsn():void{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(BottomEvents.EDIT_GONGGAO,editGonggao);
			_e.listen(BottomEvents.MOVE_USER,moveUser);
			_e.listen(SEvents.UPLOAD_OL_VIDEO_CLICK,showOlVideo);
			_e.listen(SEvents.CHANGE_BOTTOM_BUTTON,updateButtons);
			//测试功能,关闭
			_e.listen(SEvents.CHANGE_VIDEO_STATUS,changeMaiLabel);
			_e.listen(SEvents.CHANGE_BOTTOM_BUTTON_LABEL,onChangeLabel);
			_e.listen(SEvents.CHANGE_PUBLICCHAT_CLICK,onClickChangePublicChat);
			_e.listen(SEvents.CHANGE_ROOMGIFT_EFFECT_CLICK,onClickChangeGiftEff);
			_e.listen(SEvents.PUBLIC_CHAT_CHANGE,changePublicLabel);
			_e.listen(SEvents.GIFT_EFF_CHANGE,changeGiftEffLabel); 
			_e.listen(SEvents.USER_AUTH_CHANGED,onButtonRef);
			_e.listen(SEvents.CHANGE_ROOM_STATUS,onChangeRoomStatusLabel);
			_e.listen(SEvents.BOTTOM_CAMER_CLICK,sendClick4Type);
		}
		
		private function addServerLsn():void{
			//监听用户信息改变 如头像，名字，图标
			//监听广播消息
			//监听 按钮数据信息
			//scoket
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider; 
			_s.socket.listen(SEnum.R_ROOM_GONGGAO.action, SEnum.R_ROOM_GONGGAO.type,updateGonggao);
		} 
		
		/**
		 *检查用户是否登陆 
		 * 检查用户是否有权限操作此模块
		 * 如果满足条件发送入口按钮添加到左边菜单栏
		 */		
		private function checkIsAddModEnter():void
		{
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			if(user.me.isLogin){
				_buttonManager = new BottomButtonManager();
				var btnArray:Array = _buttonManager.getButtonDatas();
				if(btnArray.length>0)
				{
					initRoom();
					addButtons(btnArray);
					addModEnter();
				}
			}
		}
		
		/**
		 *添加模块入口按钮 
		 *房间设置按钮
		 */		
		private function addModEnter():void
		{
			_plgBtn = new MenuButton("RoomSet_PlugButton_Click","房间设置",new Icon_sett(),IconAlignType.TOP);
			//添加按钮点击事件
			_e.listen("RoomSet_PlugButton_Click",roomsetBtnClickHandler);
			//添加其他类型监听
			_e.listen(SEvents.BOTTOM_BUTTON_CLICK,plgBtnClickHandler); 
			_e.send(SEvents.ADD_BOTTOM_BUTTON,_plgBtn);
		}
		/**
		 * 房间设置按钮点击事件 
		 * @param event
		 * 
		 */		
		private function roomsetBtnClickHandler(data:Object):void
		{
			var button:MenuButton = data as MenuButton;		
			var pot:Point = button.parent.parent.globalToLocal(button.localToGlobal(new Point(0, 0)));
			_e.send(SEvents.OPEN_ROOM_SET,pot);
		}
		
		private function plgBtnClickHandler(data:Object):void
		{
			var type:String = data as String;
			if(type != "RoomSet_PlugButton_Click" && this._display)
			{
				close();
			}
		}
		
		/**
		 *显示缓存 
		 * @param e
		 * 
		 */		
		override protected function onAdded(e:Event):void{
			_added = true;
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

		
		
		private function updateButtons(data:Object = null):void{
			removeAllButtons();
			var user:User = Context.getContext(CEnum.USER) as User;
			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "用户按钮检测,用户权限: " + user.me.auth.join(","));
			addButtons(_buttonManager.getButtonDatas());
		}

		/**
		 *打开公告板子 
		 * @param data
		 * 
		 */		
		private function editGonggao(data:Array):void{
			var pot:Point = data[0];
			_opertView.onEditGonggaoClick(pot);
		}
		/**
		 *转移用户面板 
		 * @param data
		 * 
		 */		
		private function moveUser(data:Array):void{
			var pot:Point = data[0];
			_opertView.onChangeRoomClick(pot);
		}
		/**
		 *显示离线录像 
		 * @param data
		 * 
		 */		
		private function showOlVideo(data:Array):void{
			var pot:Point = data[0];
			_opertView.showHideOffLineVidew(pot);
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
			_opertView.updateButtonLabel(SEvents.REQUEST_MAI_CLICK,labels[user.getUserMicStatus(user.me.id)]);
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
			_opertView.updateButtonLabel(SEvents.CHANGE_ROOM_STATUS_CLICK,labels[showData.roomStatus]);
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
			if(_opertView)
			   _opertView.updateGonggao();
			
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.CHANGE_GONGGAO);
		}
		/**
		 *添加按钮 
		 * 
		 */		
		public function addButtons(buttons:Array):void{
			_opertView.addButtons(buttons);
		}
		/**
		 *移除所有按钮 
		 * 
		 */		
		public function removeAllButtons():void{
			_opertView.removeAllButtons();
		}
		/**
		 *移除按钮 
		 * 
		 */		
		public function removeButtons(buttons:Array):void{
			_opertView.removeButtons(buttons);
		}
		/**
		 *变更按钮label 
		 * @param data
		 * 
		 */		
		public function onChangeLabel(data:Object):void{
			_opertView.updateButtonLabel(data.type,data.label);
		}
		
		/**
		 *强制点击 
		 * @param type
		 * 
		 */		
		private function sendClick4Type(type:String):void{
			_opertView.sendClick4Type(type);
		}
		
		/***
		 * 显示房间设置模块
		 * */
		public function display(data:Object):void
		{
			_display = !_display;
			if(_display)
			{			
				//舞台监听
				Context.stage.addEventListener(MouseEvent.MOUSE_UP,onStageClick);
				this.y = data.y;
				this.x = -(this.width+50);				
				this.visible = _display;
				
				TweenMax.to(this, .3, {x:50, onComplete:onComplete, onCompleteParams:[true]});
			}
			else
				close();
		}
		/**
		 * 动画执行完成
		 * */
		private function onComplete(value:Boolean):void
		{
			this.visible = value;
		}		
		
		/**
		 *如果点击了屏幕
		 * @param e
		 * 
		 */		
		private function onStageClick(e:Event):void{
			if(!Utils.checkIsChild(e.target as DisplayObject,this) && e.target != _plgBtn){
				close();
			}
		}

		private function close():void
		{
			_display=false;
			if(Context.stage.hasEventListener(MouseEvent.MOUSE_UP))
			    Context.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageClick);
			TweenMax.to(this, .3, {x:-this.width+50,onComplete:onComplete, onCompleteParams:[false]});
		}
	}
}