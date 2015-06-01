package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.JointStyle;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * giftItem的容器,默认展示4个礼物
	 *  
	 * @author shunia-17173
	 */	
	public class GiftButtons extends Sprite
	{
		
		/**
		 * 最多礼物个数 
		 */		
		private static const MAX_GIFT_NUM:int = 6;
		
		private var _prev:Sprite = null;
		private var _select:Sprite = null;
		private var _giftData:Object = null;
		private var _selectedGiftIndex:int = -1;
		
		private var _gifts:Array = null;
		
		private var _frame:MovieClip = null;
		
		public function GiftButtons()
		{
			super();
			
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("requestGift", onRequestingGift);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("requestGiftHide", onRequestingGiftHide);
		}
		
		public function set data(value:Object):void {
			_giftData = value;
			
			var gifts:Object = _giftData.obj.gifts;
			_gifts = [];
			//两层
			// 类别: 
			//	该类别下的礼物数组
			for (var key:String in gifts) {
				var arr:Array = gifts[key];
				if (arr && arr.length > 0) {
					for (var j:int = 0; j < arr.length; j ++) {
						var obj:Object = arr[j];
						//把礼物一个个都拿出来
						if (obj.status == "ENABLE") {
							_gifts.push(obj);
						}
					}
				}
			}
			
			var item:GiftItem = null;
			var tempH:Number = 0;
			var len:int = _gifts.length > MAX_GIFT_NUM ? MAX_GIFT_NUM : _gifts.length;
			for (var i:int = 0; i < len; i ++) {
				item = new GiftItem();
				item.gift = _gifts[i];
				item.addEventListener(MouseEvent.CLICK, onGiftClicked);
				item.x = tempH;
				addChild(item);
				tempH += item.width + 5;
			}
			
			_select = new Sprite();
			_select.graphics.clear();
			_select.graphics.lineStyle(1, 0xFECE00,1,false,"normal",null,JointStyle.ROUND);
			_select.graphics.beginFill(0x00FFFF00, 0);
			_select.graphics.drawRect(-.5, -.5, 36.5, 26.5);
			_select.graphics.endFill();
			_select.mouseChildren = _select.mouseEnabled = false;
		}
		
		private function onRequestingGiftHide(e:Object):void {
			if (_frame && contains(_frame)) {
				removeChild(_frame);
				_frame = null;
			}
		}
		
		private function onRequestingGift(e:Object):void {
			if (_frame == null) {
				_frame = new mc_gifts_frame();
			}
			_frame.mouseChildren = false;
			_frame.mouseEnabled = false;
			_frame.width = this.width + 6;
			_frame.x = -2;
			_frame.y = -1;
			addChild(_frame);
		}
		
		/**
		 * 礼物被选中 
		 * @param event
		 */		
		protected function onGiftClicked(event:MouseEvent):void {
			onRequestingGiftHide(null);
			
			if (_prev) _prev.removeChild(_select);
			var t:Sprite = event.currentTarget as Sprite;
			if (t) {
				_selectedGiftIndex = Number(t.name);
				t.addChild(_select);
				_prev = t;
			}
		}

		public function get selectedGiftIndex():int
		{
			return _selectedGiftIndex;
		}

	}
}