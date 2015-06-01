package com._17173.flash.player.module.bullets
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * 弹幕输入框.
	 *  
	 * @author shunia-17173
	 */	
	public class BulletInput extends Sprite
	{
		
		private var _input:DisplayObject = null;
		private var _tf:TextField = null;
		private var _bg:Sprite = null;
		private static const CHAT_LIMIT:int = 20;
		
		public function BulletInput(skin:Class)
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.lineStyle(1, 0x747474);
			_bg.graphics.beginFill(0x353535, 0.8);
			_bg.graphics.drawRect(0, 0, 285, 50);
			_bg.graphics.endFill();
			
			_input = new skin();
			addChild(_input);
			_input.addEventListener("onSend", onSendBullet);
			
			_tf = new TextField();
			_tf.height = 23;
			_tf.width = 200;
			DisplayObjectContainer(_input).addChild(_tf);
			_tf.x = 3;
			_tf.y = _input.height - _tf.height;
			_tf.textColor = 0xFFFFFF;
			//如果没登陆,限制10个字符
//			if (!Context.getContext(ContextEnum.SETTING).userLogin && Context.variables["type"] != Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
			_tf.maxChars = getMaxBulletChars();
			_tf.type = TextFieldType.INPUT;
			_tf.addEventListener(TextEvent.TEXT_INPUT, onInputting);
			_tf.addEventListener(KeyboardEvent.KEY_UP, onEnterCheck);
			_tf.addEventListener(Event.CHANGE,onChange);
			
			//强制处理焦点
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("streamBarHided", onHide);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("streamBarShowed", onShow);
		}
		
		private function getMaxBulletChars():int {
			if (!Context.getContext(ContextEnum.SETTING).userLogin) {
				if (Context.variables["type"] == PlayerType.S_CUSTOM) {
					return 10;
				} else {
					return 20;
				}
			} else {
				if (Context.variables["type"] == PlayerType.S_CUSTOM) {
					return 20;
				} else {
					return 150;
				}
			}
		}
		
		private function onChange(e:Event):void{
			_tf.text =getLimitText(_tf.text);
		}
		private function onShow(data:Object = null):void {
//			setFocus();
		}
		
		private function onHide(data:Object = null):void
		{
			Context.stage.focus = Context.stage;
		}
		
		protected function onInputting(event:TextEvent):void
		{
			Context.getContext(ContextEnum.EVENT_MANAGER).send("bulletInputing");
		}
		
		/**
		 *获取截取后的字符串 
		 * @param str
		 * @return 
		 * 
		 */		
		private function getLimitText(str:String):String{
			return str;
//			var newStr:String = "";
//			var len:int = str.length;
//			var count:int = 0;
//			while(count < len){
//				newStr = str.substring(0,count+1);
//				if(Util.checkStrLength(newStr)>=CHAT_LIMIT){
//					break;
//				}
//				count++;
//			}
//			return newStr;
		}
		
		protected function onAdded(event:Event):void {
			setFocus();
		}
		
		protected function onEnterCheck(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.ENTER) {
				//输入了回车
				onSendBullet(null);
			}
		}
		
		private function onSendBullet(e:Event):void {
			dispatchEvent(new Event("sendBullet"));
		}
		
		public function get content():String {
			return _tf.text;
		}
		
		public function set content(value:String):void {
			if (_tf) {
				_tf.text = value;
			}
		}
		
		public function set isFullScreen(value:Boolean):void {
			if (value) {
				if (contains(_bg)) {
					removeChild(_bg);
					_input.x = 0;
					_input.y = 0;
				}
			} else {
				addChildAt(_bg, 0);
				_input.x = (_bg.width - _input.width) / 2;
				_input.y = (_bg.height - _input.height) / 2;
			}
		}
		
		override public function set visible(value:Boolean):void {
			super.visible = value;
			
			if (visible) {
				setFocus();
			}
		}
		
		private function setFocus():void {
			if (_tf) {
				Context.stage.focus = _tf;
			}
		}
		
	}
}