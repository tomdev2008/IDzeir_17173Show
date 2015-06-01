package com._17173.flash.core.components.common
{
	
	import com._17173.flash.core.components.skin.skinclass.CheckBoxSkin;
	
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class CheckBox extends Button
	{
		private const FONT_NAME:String = "Microsoft YaHei,微软雅黑,宋体,Monaco";
		protected var _labelTf:TextField = null;
		private var _checkLabel:String = "";
		protected var _color:uint = 0xFFFFFF;
		private var _selected:Boolean = false;
		/**
		 * 复选框
		 * @param label 复选框显示文字
		 * @param fontColor 复选框默认字体，可以使用html标签改变字体大小颜色
		 */
		public function CheckBox(label:String = "",fontColor:uint = 0x8B7D98)
		{
			_color = fontColor;
			_checkLabel = label;
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = _color;
			textFormat.size = 12;
			textFormat.font = FONT_NAME;
			_labelTf = new TextField();
			_labelTf.x = 30;
			_labelTf.y = 0;
			_labelTf.width = 1;
			_labelTf.height = 10;
			_labelTf.setTextFormat(textFormat);
			_labelTf.defaultTextFormat = textFormat;
			_labelTf.selectable = false;
			this.addChild(_labelTf);
			super("",true);
		}
		
		override protected function initSkinVo():void{
		  _skinVo = new CheckBoxSkin(this);
		}
		
		override protected function onInit():void{
			super.onInit();
		}
		
		override protected function onShow():void{
			super.onShow();
			updateLabel();
		}
		
		override protected function onHide():void{
			super.onHide();
		}
		
		/**
		 * 刷新label文字
		 */
		protected function updateLabel():void{
			_labelTf.htmlText = _checkLabel;
			_labelTf.width = Math.max(30, _labelTf.textWidth+4);
			_labelTf.height = Math.max(12, _labelTf.textHeight+4);
			changeRect(this.getIconWidth() + _labelTf.width,Math.max(this.height,_labelTf.height));
		}
		
		/**
		 * checkbox的显示文字
		 */
		override public function get label():String
		{
			return _checkLabel;
		}
		/**
		 * checkbox的显示文字
		 */
		override public function set label(value:String):void
		{
			_checkLabel = value;
			updateLabel();
		}
		
		/**
		 * 对齐文本的位置
		 * @param rect checkbox皮肤（复选框）的大小位置
		 */
		public function boxPostion(rect:Rectangle):void{
			_labelTf.x = rect.width + 2;
			_labelTf.y = (rect.height - _labelTf.height)/2;
		}
		
		/**
		 * 获取皮肤复选框的icon宽
		 */
		public function getIconWidth():int{
			var skin:CheckBoxSkin = this.skinVo as CheckBoxSkin;
			return skin.iconWidth();
		}
	}
}