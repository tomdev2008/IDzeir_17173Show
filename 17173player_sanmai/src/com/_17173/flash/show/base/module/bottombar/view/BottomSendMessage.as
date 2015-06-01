package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.module.chat.InTextBar;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *发送按钮板 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomSendMessage extends Sprite
	{
		
		private var _iconSound:MovieClip = null;
		private var _sendMessageBtn:BottomButton = null;
		private var _closeBtn:BottomButton = null;

		public function get isClose():Boolean
		{
			return _isClose;
		}

		public function set isClose(value:Boolean):void
		{
			_isClose = value;
		}

		private var _closeCallBack:Function = null;
		private var _inText:InTextBar = null;
		private var _tip:TextField = null;
		private var _isClose:Boolean = true;
		public function BottomSendMessage()
		{
			super();
			init();
			mouseEnabled = false;
		}
		
		private function init():void{
			_iconSound = new Bottom_IconSound();
			_iconSound.y = 2;
			_iconSound.mouseEnabled = false;
			this.addChild(_iconSound);
			
			this.graphics.beginFill(0x18033C);
			this.graphics.drawRect(0 ,-5,430,40);
			this.graphics.endFill();
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			_inText = new InTextBar(lc.get("guangbotip","bottom"));
			_inText.width = 320;
			_inText.backgroundColor = 0x110720
			_inText.x = _iconSound.width + 6;
			this.addChild(_inText);
			
			_sendMessageBtn = new BottomButton(new ButtonBindData("","",-1,false,new Bottom_IconSend()));
			_sendMessageBtn.setSkin(new Button_SendBg())
			_sendMessageBtn.width = 31;
			_sendMessageBtn.height = 28;
			_sendMessageBtn.x = _inText.x + _inText.width + 4;
			_sendMessageBtn.addEventListener(MouseEvent.CLICK,onSendMessage);
			ui.registerTip(_sendMessageBtn,lc.get("send_showgb_tip","bottom"));
			this.addChild(_sendMessageBtn);
			
			_closeBtn = new BottomButton(new ButtonBindData("","",-1,false,new Bottom_IconClose()));
			_closeBtn.width = 31;
			_closeBtn.height = 28;
			_closeBtn.x = _sendMessageBtn.x + _sendMessageBtn.width+1;
			_closeBtn.addEventListener(MouseEvent.CLICK,onClose);
			ui.registerTip(_closeBtn,lc.get("change_showgb_tip","bottom"));
			this.addChild(_closeBtn);
			
		}
		
		private function onClose(e:Event):void{
			if(_closeCallBack != null){
				_closeCallBack();
			}
		}
		
		private function onSendMessage(e:Event):void{
			var text:String = _inText.text
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			if(text == ""){
				ui.popupAlert(local.get("system_title","components"),local.get("send_guangbo","bottom"),-1,Alert.BTN_OK);
				return;
			}
			var len:int = _inText.length;
			if(len > 100){
				ui.popupAlert(local.get("system_title","components"),local.get("send_guangbo1","bottom"),-1,Alert.BTN_OK);
				return;
			}
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//提交数据
			var data:Object = {};
			data.msg = text;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.SEND_HORN,data,onSecc,onFail);
			_sendMessageBtn.disabled = true;
		}
		
		
		
		private function onSecc(obj:Object):void{
			_sendMessageBtn.disabled = false;
//			hide();	
			_inText.clear();
			onClose(null);
		}
		
		private function onFail(obj:Object):void{
			_sendMessageBtn.disabled = false;
			_inText.clear();
		}
		
		
		public function get closeCallBack():Function
		{
			return _closeCallBack;
		}
		
		public function set closeCallBack(value:Function):void
		{
			_closeCallBack = value;
		}

	}
}