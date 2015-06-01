package com._17173.flash.show.base.module.lobby
{
	import flash.display.Sprite;
	
	public class RoomCard extends Sprite implements IRoomCard
	{
		/**
		 * 房间数据 
		 */		
		protected var _data:Object;
		
		public function RoomCard()
		{
			super();
		}
		
		public function set info(value:Object):void
		{
			_data = value;
			update();
		}
		
		public function get url():String
		{
			return null;
		}
		
		protected function update():void
		{
			
		}
	}
}