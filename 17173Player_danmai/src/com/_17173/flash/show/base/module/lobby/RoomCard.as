package com._17173.flash.show.base.module.lobby
{
	import flash.display.Sprite;
	
	public class RoomCard extends Sprite implements IRoomCard
	{
		/**
		 * 房间数据 
		 */		
		protected var _data:Object;
		protected static const PIC_APP:String = "!a-6-232x131.jpg";
		public function RoomCard()
		{
			super();
		}
		
		public function set info(value:Object):void
		{
			_data = value;
			setupPic();
			update();
		}
		
		/**
		 *需要加入图片链接 
		 * 
		 */		
		protected function setupPic():void{
			if(_data.hasOwnProperty("picUrl") && _data.picUrl is String){
				_data.picUrl = _data.picUrl + PIC_APP;
			}
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