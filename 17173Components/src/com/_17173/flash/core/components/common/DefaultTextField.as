package com._17173.flash.core.components.common
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 *带默认文本TextField
	 * @author zhaoqinghao
	 * 
	 */	
	public class DefaultTextField extends TextField
	{
		private var _defaultText:String = null;
		private var _changed:Boolean = false;
		/**
		 *是否是密码框 
		 */		
		private var _showPassWord:Boolean = false;
		
		/**
		 * 带默认内容的文本显示对象
		 * @param default 默认显示的文字
		 */
		public function DefaultTextField(defaultText:String)
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Microsoft YaHei,微软雅黑,宋体,Monaco";
			_defaultText = defaultText;
			super();
			this.defaultTextFormat = textFormat;
			this.setTextFormat(textFormat);
			this.width = 100;
			this.height = 30;
			this.addEventListener(FocusEvent.FOCUS_IN,onFocusIn);
			this.type = TextFieldType.INPUT;
			this.text = _defaultText;
		}
		
		
		/**
		 * 文本为密码是是否显示成***
		 */
		public function get showPassWord():Boolean
		{
			return _showPassWord;
		}

		public function set showPassWord(value:Boolean):void
		{
			_showPassWord = value;
		}

		/**
		 *是否修改过文本 
		 * @return 
		 * 
		 */
		public function get changed():Boolean
		{
			return _changed;
		}
		
		private function onFocusIn(e:FocusEvent):void{
			if(this.text == _defaultText){
				this.text = "";
			}
			if(_showPassWord){
				displayAsPassword = true;
			}
			this.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		
		private function onFocusOut(e:FocusEvent):void{
			this.removeEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
			if(text.replace(" ","") == ""){
				displayAsPassword = false;
				this.text = _defaultText;
				_changed = false;
			}else{
				_changed = true;
			}
		}

	}
}