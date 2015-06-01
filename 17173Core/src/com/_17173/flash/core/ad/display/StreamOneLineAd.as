package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 直播下底广告中的一个文字链.
	 *  
	 * @author shunia-17173
	 */	
	public class StreamOneLineAd extends Sprite
	{
		
		private static const MAX_CHAR:int = 15;
		
		private var _text:String = null;
		private var _url:String = null;
		private var _tf:TextField = null;
		
		public function StreamOneLineAd()
		{
			super();
			
			var fmt:TextFormat = new TextFormat();
			fmt.underline = true;
			fmt.color = 0x5C5C5C;
			
			_tf = new TextField();
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = "";
			_tf.defaultTextFormat = fmt;
			_tf.selectable = false;
			//最多支持15个字
			_tf.maxChars = 15;
			addChild(_tf);
			
			buttonMode = true;
			useHandCursor = true;
			mouseChildren = false;
		}
		
		public function get text():String
		{
			return _text;
		}
		
		public function set text(value:String):void
		{
			_text = value;
			if (_text.length > 15) {
				_text = _text.slice(0, MAX_CHAR);
			}
			
			_tf.text = _text;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
			
			addEventListener(MouseEvent.CLICK, onJump);
		}
		
		protected function onJump(event:MouseEvent):void
		{
			Util.toUrl(_url);
		}
		
	}
}