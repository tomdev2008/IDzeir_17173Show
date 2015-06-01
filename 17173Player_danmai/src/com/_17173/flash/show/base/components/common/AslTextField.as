package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.util.Util;
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 *固定长度的文本
	 * <br>如果超过其长度会自动隐藏文本，并且在在其后尾追加(...);
	 * <br>并未考虑截取后...前有空格的问题,后期添加；
	 * @author zhaoqinghao
	 * 
	 */	
	public class AslTextField extends TextField
	{
		private var _showWidth:int;
		/**
		 *原始字符串 
		 */		
		private var _protoText:String = null;
		/**
		 *截取后显示字符串 
		 */		
		private var _showText:String = null;
		/**
		 *检测长度超了 
		 */		
		private var _tooLong:Boolean;
		
		public function AslTextField(showWidth:int = 50)
		{
			super();
			_showWidth = showWidth;
			
			autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function get showWidth():int
		{
			return _showWidth;
		}

		public function set showWidth(value:int):void
		{
			_showWidth = value;
			text = _protoText;
		}

		override public function set text(value:String):void{
			_protoText = value;
			super.text = value;
			Util.shortenText(this, _showWidth);
		}
		
		override public function get text():String{
			return super.text;
		}
		
//		override public function set htmlText(value:String):void{
//			_protoText = value;
//			super.htmlText = value;
//			autoLenText();
//		}
//		
//		override public function get htmlText():String{
//			return super.htmlText;
//		}
		
		public function proText():String{
			return _protoText;
		}
		
//		private function autoLenText():void{
//			if (!super.text || !getTextFormat(0, 1) || _showWidth <= 0) return;
//			var fmt:TextFormat = getTextFormat(0, 1);
//			defaultTextFormat = fmt;
//			var _testTF:TextField = new TextField();
//			_testTF.text = ".";
//			var baseDotW:Number = _testTF.textWidth;
//			
//			//要求的宽度还不如3个点那么宽,就不做处理
//			if (_showWidth <= (baseDotW * 3)) {
//				_testTF.text = "...";
//			} else {
//				var ttext:String = super.text;
//				_testTF.text = ttext;
//				var needShorten:Boolean = false;
//				//如果文字的宽度大于要求的宽度,则需要处理
//				if (_testTF.textWidth > _showWidth) {
//					needShorten = true;
//				}
//				
//				if (needShorten) {
//					//需要缩短到{需求的宽度-三个点的宽度}
//					var shortenTo:Number = _showWidth - baseDotW * 3;
//					var shortend:String = ttext;
//					var complete:Boolean = false;
//					//一个一个字符的减少,直到宽度符合要求
//					while (complete == false) {
//						if (shortend.length >= 1) {
//							shortend = shortend.substr(0, shortend.length - 1);
//							_testTF.text = shortend;
//							if (_testTF.textWidth <= shortenTo) {
//								complete = true;
//							}
//						} else {
//							complete = true;
//						}
//					}
//					super.text = shortend + "...";
//				}
//			}
//		}

	}
}