package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.module.gift.Gifts;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 礼物ui界面
	 * 
	 * 包含礼物动画,礼物列表,选人界面,选数量界面,选人弹出界面
	 *  
	 * @author shunia-17173
	 */	
	public class GiftUI extends Sprite implements IExtraUIItem
	{
		
		private var _giftBtns:GiftButtons = null;
		private var _giftNumInput:GiftNumInput = null;
		private var _userNameInput:GiftUserNamesInput = null;
		private var _packedGiftParam:Object = null;
		
		public function GiftUI()
		{
			super();
			
			var fmt:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			
			var tf:TextField = new TextField();
			tf.defaultTextFormat = fmt;
			tf.text = "送:";		//@auther:qingfeng time:20130225	 修改此处文字为产品需求  
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.selectable = false;
			addChild(tf);
			
			_giftBtns = new GiftButtons();
			addChild(_giftBtns);
			
			_giftNumInput = new GiftNumInput();
			addChild(_giftNumInput);
			
			_userNameInput = new GiftUserNamesInput();
			_userNameInput.addEventListener("sendGiftClicked", onSendGift);
			addChild(_userNameInput);
			
			resize();
		}
		
		protected function onSendGift(event:Event):void {
			//各种提示消息
			if (_giftBtns.selectedGiftIndex < 0) {
				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(Gifts.TIP_NO_GIFT);
			} else if (_giftNumInput.giftNum <= 0) {
				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(Gifts.TIP_NO_NUM);
			} else if (_userNameInput.selectedUser == null) {
				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(Gifts.TIP_NO_TARGET);
			} else {
				//可以发送了
				_packedGiftParam = {};
				_packedGiftParam.giftId = _giftBtns.selectedGiftIndex;
				_packedGiftParam.count = _giftNumInput.giftNum;
				_packedGiftParam.receiverId = _userNameInput.selectedUser.id;
				_packedGiftParam.roomId = _userNameInput.selectedUser.room;
				_packedGiftParam.chatRoomId = _userNameInput.selectedUser.chatRoom;
				dispatchEvent(new Event("sendGift"));
			}
		}
		
		public function set giftData(value:Object):void {
			if (_giftBtns) {
				_giftBtns.data = value;
				
				resize();
			}
			
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.RESIZE});
		}
		
		public function addUser(obj:Object):void {
			if (_userNameInput) {
				_userNameInput.addUser(obj);
			}
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
		}
		
		public function resize():void
		{
			if (parent == null) return;
			
			var child:DisplayObject = null;
			var temp:Number = 0;
			for (var i:int = 0; i < numChildren; i ++) {
				child = getChildAt(i);
				child.x = temp;
				child.y = (height - child.height) / 2;
				temp += child.width + 10;
			}
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_RIGHT;
		}

		public function get packedGiftParam():Object
		{
			return _packedGiftParam;
		}

	}
}