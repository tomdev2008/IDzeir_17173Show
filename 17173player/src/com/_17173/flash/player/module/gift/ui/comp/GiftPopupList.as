package com._17173.flash.player.module.gift.ui.comp
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 弹出列表类,默认是vertical排列
	 *  
	 * @author shunia-17173
	 */	
	public class GiftPopupList extends Sprite
	{
		
		private var _bg:Shape = null;
		private var _data:Array = null;
		private var _items:Array = null;
		private var _itemLayer:Sprite = null;
		
		private var _w:Number = 60;
		private var _h:Number = 100;
		private var _selectedData:Object = null;
		
		public function GiftPopupList(data:Array = null)
		{
			super();
			
			_bg = new Shape();
			addChild(_bg);
			
			_itemLayer = new Sprite();
			addChild(_itemLayer);
			
			_items = [];
			
			data = data;
		}
		
		public function set data(value:Array):void {
			if (value) {
				_data = value;
				refresh();
			}
		}
		
		public function get selectedData():Object {
			return _selectedData;
		}
		
		private function refresh():void {
			clear();
			
			createChildren();
		}
		
		private function createChildren():void {
			if (_data == null || _data.length == 0) return;
			
			for (var i:int = 0; i < _data.length; i ++) {
				var item:GiftPopupListItem = new GiftPopupListItem();
				item.addEventListener(MouseEvent.CLICK, onItemSelected);
				item.data = _data[i];
				_itemLayer.addChild(item);
				_items.push(item);
				if (_w < item.width) _w = item.width;
			}
			
			resize();
		}
		
		protected function onItemSelected(event:MouseEvent):void {
			var item:GiftPopupListItem = event.currentTarget as GiftPopupListItem;
			if (item) {
				_selectedData = item.data;
				dispatchEvent(new Event("itemSelected"));
			}
		}
		
		private function resize():void {
			var temp:Number = 0;
			for (var i:int = 0; i < _itemLayer.numChildren; i ++) {
				var item:GiftPopupListItem = _itemLayer.getChildAt(i) as GiftPopupListItem;
				item.resize(_w);
				item.y = temp;
				temp += item.height;
			}
			
			_h = _itemLayer.height;
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x353535, 0.8);
			_bg.graphics.drawRect(0, 0, _w, _h);
			_bg.graphics.endFill();
		}
		
		private function clear():void {
			var c:GiftPopupListItem = null;
			while (_itemLayer.numChildren) {
				c = _itemLayer.getChildAt(0) as GiftPopupListItem;
				c.removeEventListener(MouseEvent.CLICK, onItemSelected);
				_items.splice(_items.indexOf(c), 1);
				_itemLayer.removeChild(c);
			}
		}
		
		override public function get width():Number {
			return _w;
		}
		/**
		 *获取真实高度 
		 * @return 
		 * 
		 */		
		public function get layerWeight():Number {
			return _itemLayer.width;
		}
	}
}