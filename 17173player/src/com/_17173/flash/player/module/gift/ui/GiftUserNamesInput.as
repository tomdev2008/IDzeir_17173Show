package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.player.module.gift.ui.comp.GiftPopupInput;
	import com._17173.flash.player.module.gift.ui.comp.GiftPopupList;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 送礼对象的输入弹出框
	 *  
	 * @author shunia-17173
	 */	
	public class GiftUserNamesInput extends GiftPopupInput
	{
		
		private var _storedUserNames:Array = null;
		private var _nameListData:Array = null;
		private var _selectedUser:Object = null;
		
		public function GiftUserNamesInput()
		{
			var format:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = format;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "给";
			tf.selectable = false;
			addChild(tf);
			
			super();
			_input.selectable = false;
			format = new TextFormat(null, 12, 0xb9b9b9);
			format.align = TextFormatAlign.LEFT;
			_input.defaultTextFormat = format;
			_input.wordWrap = true;
			_input.multiline = false;
			_input.text = " ";
			_input.height = _input.textHeight + 4;
			
			var sendBtn:DisplayObject = new mc_sendGiftBtn();
			addChild(sendBtn);
			sendBtn.addEventListener(MouseEvent.CLICK, onClick);
			
			var tempW:Number = 0;
			for (var i:int = 0; i < numChildren; i ++) {
				var c:DisplayObject = getChildAt(i);
				c.y = (height - c.height) / 2;
				c.x = tempW;
				tempW += c.width + 2;
			}
			sendBtn.x = _inputBG.x + _inputBG.width - sendBtn.width - 2;
			_input.x = _inputBG.x + 2;
			
			_storedUserNames = [];
			_nameListData = [];
		}
		
		public function addUser(user:Object):void {
			onHide();
			if (user.hasOwnProperty("name")) {
				if (_nameListData.indexOf(user.name) == -1) {
					if (_storedUserNames.length == 6) {
						_storedUserNames.shift();
					}
					_storedUserNames.push(user);
					if (_nameListData.length == 6) {
						_nameListData.shift();
					}
					_nameListData.push(user.name);
					
					_selectedUser = user;
					_input.text = user.name;
					
					if (_popupView) {
						_popupView.data = _nameListData;
					}
				} else {
					_input.text = user.name;
				}
			}
		}
		
		override protected function initPopView():GiftPopupList {
			var list:GiftPopupList = new GiftPopupList();
			list.data = _nameListData;
			return list;
		}
		
		public function get selectedUser():Object {
			return _selectedUser;
		}
		
		protected function onClick(event:Event):void {
			dispatchEvent(new Event("sendGiftClicked"));
		}
		
		override protected function get actualWidth():Number {
			return 140;
		}
		
		override protected function get actualTextWidth():Number {
			return 140;
		}
		
		override protected function onPopupSelected(event:Event):void {
			super.onPopupSelected(event);
			
			for each (var obj:Object in _storedUserNames) {
				if (obj.name == _popupView.selectedData) {
					_selectedUser = obj;
					_input.text = obj.name;
					return;
				}
			}
		}
		
	}
}