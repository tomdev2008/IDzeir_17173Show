package com._17173.flash.show.base.module.horn
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.module.chat.InTextBar;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SendMessagePanel extends Sprite
	{
		private var _bg:HornSendBG;
		private var _sendButton:Button;
		private var _cancelButton:Button;
		private var _inText:InTextBar = null;
		
		override public function get width():Number
		{
			return (_bg?_bg.width : super.width);
		}
		
		public function SendMessagePanel()
		{
			super();
			_bg = new HornSendBG();
			_bg.x = 0;
			_bg.y = 0;
			this.addChild(_bg);
			
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			_inText = new InTextBar(lc.get("guangbotip","horn"));
			_inText.x = 9;
			_inText.y = 6;
			
			_inText.inTxt.width = 340;
			_inText.backgroundColor = 0x31023D;
			_inText.inTxt.height = 90;
			_inText.inTxt.y = 0;
			_inText.inTxt.x = 0;
			_inText.inTxt.maxChars = 100;
			_inText.inTxt.wordWrap = true;
			_inText.smileDir = 1;
			
			_inText.smileFace.y = 100;
			_inText.smileFace.x = 230;
			this.addChild(_inText);
			
			_sendButton = new Button("<font color='#FFFF93'>" + lc.get("send","horn")+ "</font>", false);
			_sendButton.setSkin(new HornSendBtn());
			_sendButton.width = 40;
			_sendButton.height = 22;
			_sendButton.x = 263;
			_sendButton.y = 102;
			_sendButton.addEventListener(MouseEvent.CLICK, send);
			ui.registerTip(_sendButton,lc.get("send_showgb_tip","horn"));
			this.addChild(_sendButton);
			
			
			_cancelButton = new Button(lc.get("close","horn"),false);
			_cancelButton.setSkin(new HornCancelBtn());
			_cancelButton.width = 40;
			_cancelButton.height = 22;
			_cancelButton.x = _sendButton.x + _sendButton.width + 10;
			_cancelButton.y = _sendButton.y;
			_cancelButton.addEventListener(MouseEvent.CLICK, close);
			ui.registerTip(_cancelButton,lc.get("change_showgb_tip","horn"));
			this.addChild(_cancelButton);
		}
		
		
		private function close(e:MouseEvent):void{
			this.visible = false;
		}
		
		private function send(e:MouseEvent):void{
			var text:String = _inText.text
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			if(text == ""){
				ui.popupAlert(local.get("system_title","components"),local.get("send_guangbo","horn"),-1,Alert.BTN_OK);
				return;
			}
			var len:int = _inText.length;
			if(len > 100){
				ui.popupAlert(local.get("system_title","components"),local.get("send_guangbo1","horn"),-1,Alert.BTN_OK);
				return;
			}
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//提交数据
			var data:Object = {};
			data.msg = text;
			data.result = "json";
			data.roomId = (Context.variables["showData"]).roomID;
			server.http.getData(SEnum.SEND_HORN,data,onSecc,onFail);
			_sendButton.disabled = true;
		}
		
		private function onSecc(obj:Object):void{
			_sendButton.disabled = false;
			_inText.clear();
			close(null);
		}
		
		private function onFail(obj:Object):void{
			_sendButton.disabled = false;
			_inText.clear();
		}
	}
}