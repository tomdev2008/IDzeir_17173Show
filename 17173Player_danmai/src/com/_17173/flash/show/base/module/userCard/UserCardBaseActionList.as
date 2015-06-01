package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.List;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 用户选项卡动作列表基类.
	 *  
	 * @author shunia-17173
	 */	
	public class UserCardBaseActionList extends Sprite
	{
		
		/**
		 * 操作列表. 
		 */		
		protected var _list:List = null;
		/**
		 * 操作选项类. 
		 */		
		protected var _listItemRenderer:Class = UserCardListItemRenderer;
		/**
		 * 操作列表 
		 */		
		protected var _data:Array = null;
		
		public function UserCardBaseActionList()
		{
			super();
			
			_list = new List(0, false, _listItemRenderer);
			_list.width = 156;
			_list.gap = 2;
			addChild(_list);
			
			_list.addEventListener(Event.SELECT, onListClicked);
		}
		
		public function set data(value:Array):void {
			_data = value;
			
			var v:Array =[];
			for each (var item:Object in _data) {
				v.push(item);
			}
			_list.dataProvider = v;
		}
		
		public function get selected():Object {
			return _list.selected;
		}
		
		/**
		 * 选项被点击.将事件和所导致的用户id派发出去.
		 *  
		 * @param event
		 */		
		private function onListClicked(event:Event):void {
			if (selected) {
				dispatchEvent(new Event("actionSelected"));
			}
		}
		
	}
}