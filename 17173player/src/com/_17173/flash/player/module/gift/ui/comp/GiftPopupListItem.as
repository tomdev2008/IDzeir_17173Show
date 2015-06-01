package com._17173.flash.player.module.gift.ui.comp
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 弹出列表渲染项,默认显示一个文字
	 *  
	 * @author shunia-17173
	 */	
	public class GiftPopupListItem extends Sprite
	{
		
		private var _bg:DisplayObject = null;
		private var _tf:TextField = null;
		
		private var _data:Object = null;
		
		public function GiftPopupListItem()
		{
			super();
			
			buttonMode = true;
			useHandCursor = true;
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		protected function onOut(event:MouseEvent):void {
			if (_tf) {
				_tf.textColor = 0xFFFFFF;
			}
		}
		
		protected function onOver(event:MouseEvent):void {
			if (_tf) {
				_tf.textColor = 0xFDCD00;
			}
		}
		
		public function set data(value:Object):void {
			_data = value;
			var result:String = null;
			if (value.hasOwnProperty("toString")) {
				result = value["toString"]();
			} else {
				result = String(value);
			}
			if (result == null) result = "null";
			_bg = new mc_listItemBG();
			addChild(_bg);
			
			var fmt:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			_tf = new TextField();
			_tf.defaultTextFormat = fmt;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = result;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			addChild(_tf);
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function resize(w:Number):void {
			_tf.x = (w - _tf.width) / 2;
			_tf.y = (height - 2 - _tf.height) / 2;
			_bg.width = w;
		}
		
	}
}