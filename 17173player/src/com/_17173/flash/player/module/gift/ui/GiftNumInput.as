package com._17173.flash.player.module.gift.ui
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import com._17173.flash.player.module.gift.ui.comp.GiftPopupList;
	import com._17173.flash.player.module.gift.ui.comp.GiftPopupInput;
	
	/**
	 * 选择礼物数量的输入弹出框
	 *  
	 * @author shunia-17173
	 */	
	public class GiftNumInput extends GiftPopupInput
	{
		public function GiftNumInput()
		{
			super();
			
			_input.type = TextFieldType.INPUT;
			var format:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			format.align = TextFormatAlign.CENTER;
			_input.defaultTextFormat = format;
			_input.text = "1";
			_input.maxChars = 4;
			_input.restrict = "0-9";
			_input.height = _input.textHeight + 2;
			
			format = new TextFormat(null, 12, 0xb9b9b9);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "个";
			addChild(tf);
			tf.x = _input.width + 5;
			
			for (var i:int = 0; i < numChildren; i ++) {
				var c:DisplayObject = getChildAt(i);
				c.y = (height - c.height) / 2;
			}
		}
		
		override protected function initPopView():GiftPopupList {
			var popupList:GiftPopupList = new GiftPopupList();
			
			popupList.data = [100, 75, 50, 25, 10];
			
			return popupList;
		}
		
		override protected function get actualWidth():Number {
			return 41;
		}
		
		override protected function onPopupSelected(event:Event):void {
			super.onPopupSelected(event);
			var result:Number = Number(_popupView.selectedData);
			if (isNaN(result)) {
				result = 1;
			}
			_input.text = String(result);
		}
		
		public function get giftNum():int {
			return Number(_input.text);
		}
		
	}
}