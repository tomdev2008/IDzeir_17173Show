package com._17173.flash.show.base.components.event
{
	import flash.events.Event;
	
	public class MoveEvent extends Event
	{
		private var _data:Object;
		public function MoveEvent(type:String,data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_data = data;
			super(type, bubbles, cancelable);
		}
		/**
		 * 单个组件移动完毕
		 */		
		public static const ITEM_MOVE_END:String = "item_move_end";
		/**
		 *可以播放下个组件 
		 */		
		public static const PLAY_NEXT:String = "play_next";
		/**
		 * move数量变更
		 */		
		public static const COUNT_CHANGE:String = "count_change";
		/**
		 *自动开始 
		 */		
		public static const AUTO_START:String = "auto_start";
		/**
		 *自动停止 
		 */		
		public static const AUTO_STOP:String = "auto_stop";

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

	}
}