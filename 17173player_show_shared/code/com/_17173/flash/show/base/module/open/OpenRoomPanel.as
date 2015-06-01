package com._17173.flash.show.base.module.open
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.components.common.RadioGroup;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class OpenRoomPanel extends Sprite
	{
		private var password:TextField = null;
		
		private var openRoom:OpenRoom = null;
		
		private var radioGroup:RadioGroup = null;
		
		private var roomTypeId:int = 0;
		
		private var format:TextFormat = null;
		private var freeInfo:TextField = null;
		private var passwordInfo:TextField = null;
		private var payInfo:TextField = null;
		
		private var titleFormat:TextFormat = null;
		private var title:TextField = null;
		
		private var numberText:TextField = null;
		
		private var okBtn:Button = null;
		
		private var cancelBtn:Button = null;
		
		private var _s:IServiceProvider = null;
		
		public function OpenRoomPanel()
		{	
			openRoom = new OpenRoom();
			this.addChild(openRoom);
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			openRoom.button1.gotoAndStop(2);
			radioGroup = new RadioGroup();
			radioGroup.pushRadio(openRoom.button1, btn1Select);
			radioGroup.pushRadio(openRoom.button2, btn2Select, btn2Cancel);
			radioGroup.pushRadio(openRoom.button3, btn3Select);
			radioGroup.updateRaido(openRoom.button1);
			format = FontUtil.DEFAULT_FORMAT;
			format.color = 0x63acff;
			format.size =12;
			freeInfo = new TextField();
			freeInfo.defaultTextFormat = format;
			freeInfo.x = 55;
			freeInfo.y = 78;
			freeInfo.selectable = false;
			freeInfo.autoSize = TextFieldAutoSize.LEFT;
			freeInfo.text = Context.getContext(CEnum.LOCALE).get("freeInfo", "openModule");
			this.addChild(freeInfo);
			passwordInfo = new TextField();
			passwordInfo.defaultTextFormat = format;
			passwordInfo.x = 55;
			passwordInfo.y = 116;
			passwordInfo.selectable = false;
			passwordInfo.autoSize = TextFieldAutoSize.LEFT;
			passwordInfo.text = Context.getContext(CEnum.LOCALE).get("passwordInfo", "openModule");
			this.addChild(passwordInfo);
			payInfo = new TextField();
			payInfo.defaultTextFormat = format;
			payInfo.x = 55;
			payInfo.y = 150;
			payInfo.selectable = false;
			payInfo.autoSize = TextFieldAutoSize.LEFT;
			payInfo.text = Context.getContext(CEnum.LOCALE).get("payInfo", "openModule");
			this.addChild(payInfo);
			titleFormat = FontUtil.DEFAULT_FORMAT;
			titleFormat.color = 0xc0bdc2;
			titleFormat.size =14;
			title = new TextField();
			title.defaultTextFormat = titleFormat;
			title.x = 10;
			title.y = 7;
			title.selectable = false;
			title.autoSize = TextFieldAutoSize.LEFT;
			title.text = Context.getContext(CEnum.LOCALE).get("title", "openModule");
			this.addChild(title);
			okBtn = new Button(Context.getContext(CEnum.LOCALE).get("ok", "openModule"));
			okBtn.width = 65;
			okBtn.height = 28;
			okBtn.x = 181;
			okBtn.y = 200;
			this.addChild(okBtn);
			cancelBtn = new Button(Context.getContext(CEnum.LOCALE).get("cancel", "openModule"));
			cancelBtn.width = 65;
			cancelBtn.height = 28;
			cancelBtn.x = 296;
			cancelBtn.y = 200;
			this.addChild(cancelBtn);
			okBtn.addEventListener(MouseEvent.CLICK,ok);
			cancelBtn.addEventListener(MouseEvent.CLICK,cancel);
			numberText = new TextField;
			numberText.selectable = false;
			var mat:TextFormat = FontUtil.DEFAULT_FORMAT;
			mat.color =0x9774c6;
			mat.size = 12;
			numberText.defaultTextFormat = mat;
			numberText.autoSize = TextFieldAutoSize.LEFT;
			numberText.text =  Context.getContext(CEnum.LOCALE).get("numberInfo", "openModule");
			numberText.x = 67;
			numberText.y = 144;
			this.addChild(numberText);
			numberText.visible = false;
			password = new TextField;
			mat.color =0x9774c6;
			password.defaultTextFormat = mat;
			password.maxChars = 10;
			password.displayAsPassword = true;
			password.restrict ="A-Za-z0-9";
			password.x = 67;
			password.y = 146;
			password.width = 130;
			password.height = 30;
			password.type = TextFieldType.INPUT;
			password.addEventListener(FocusEvent.FOCUS_IN,focusHandler);
			password.addEventListener(FocusEvent.FOCUS_OUT,focusHandler);
			this.addChild(password);
			openRoom.passwordBg.visible = false;
			password.visible = false;
		}
		
		protected function focusHandler(event:FocusEvent):void
		{
			switch(event.type)
			{
				case FocusEvent.FOCUS_IN:
					numberText.visible = false;
					break;
				case FocusEvent.FOCUS_OUT:
					if(password.text == ""){
						numberText.visible = true;
					}
					break;
			}
		}
		
		private function ok(e:MouseEvent):void
		{
			var locale:Locale = Context.getContext(CEnum.LOCALE) as Locale;
			if(!radioGroup.getCurrentRadio()){
				(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips","jsProxy"),locale.get("roomType","openModule"),-1,1);
				return;
			}
			if(roomTypeId == 2){
				if(password.text == ""){
					(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips","jsProxy"),locale.get("noPassword","openModule"),-1,1);
					return;
				}
				if(password.text.length < 4){
					(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips","jsProxy"),locale.get("passwordShort","openModule"),-1,1);
					return;
				}
			}
			var price:String = "0";
			if(roomTypeId == 1){
				price = "100";
			}
			setRoom(roomTypeId,password.text.toLocaleLowerCase(),price,3);
			
		}
		private function cancel(e:MouseEvent = null):void
		{
			(Context.getContext(CEnum.UI) as UIManager).removePanel(this);
//			if(this && this.parent){
//				this.parent.removeChild(this);
//			}
		}
		private function btn1Select():void
		{
			roomTypeId = 0;
		}
		
		private function btn3Select():void
		{
			roomTypeId = 1;
		}
		
		
		private function btn2Select():void
		{
			roomTypeId = 2;
			openRoom.passwordBg.visible = true;
			numberText.visible = true;
			password.visible = true;
			password.text = "";
			openRoom.button3.y = 185;
			payInfo.y = 180;
		}
		private function btn2Cancel():void
		{
			openRoom.passwordBg.visible = false;
			numberText.visible = false;
			password.visible = false;
			password.text = "";
			openRoom.button3.y = 155;
			payInfo.y =150;
		}
		
		
		public function setRoom(roomTypeId:int, roomPwd:String, roomPrice:String, hdLevel:int):void
		{		
			Debugger.log(Debugger.INFO,"[OpenModule]","发送设置房间类型消息");
			var urlVa:URLVariables = new URLVariables;
			urlVa["roomId"] = Context.variables.showData.roomID;
			urlVa["type"] = roomTypeId;
			urlVa["name"] = "lala";
			urlVa["pwd"] = roomPwd;
			urlVa["price"] = roomPrice;
			urlVa["result"] = "json";
			_s.http.getData(
				SEnum.domain + "/fr_switchStatus.action", 
				urlVa, 
				onRoomResult, onRoomFault);
			cancel();
		}
		
		private function onRoomResult(data:Object):void
		{
			Context.getContext(EventManager.CONTEXT_NAME).send(SEvents.OPENR_ROOM_SUCC);
		}
		
		private function onRoomFault(data:Object):void
		{
			if(data.hasOwnProperty("msg")){
//				(Context.getContext(CEnum.UI) as IUIManager).popupAlert("",data.msg,-1,Alert.BTN_OK);
				Context.getContext(EventManager.CONTEXT_NAME).send(SEvents.OPEN_ROOM_FAIL,data.msg);
			}
		}
	}
}