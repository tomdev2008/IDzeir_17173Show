package com._17173.flash.core.components.common.data
{
	import flash.display.BitmapData;

	public class AnimData
	{
		
		private var _bd:BitmapData = null;
		private var _x:int = 0;
		private var _y:int = 0;
		private var _offsetX:int = 0;
		private var _offsetY:int = 0;
		
		public function AnimData()
		{
		}

		/**
		 * 指定的位图数据 
		 */
		public function get bd():BitmapData
		{
			return _bd;
		}

		/**
		 * @private
		 */
		public function set bd(value:BitmapData):void
		{
			_bd = value;
		}

		/**
		 * 位置信息 
		 */
		public function get x():int
		{
			return _x;
		}

		/**
		 * @private
		 */
		public function set x(value:int):void
		{
			_x = value;
		}

		/**
		 * 位置信息 
		 */
		public function get y():int
		{
			return _y;
		}

		/**
		 * @private
		 */
		public function set y(value:int):void
		{
			_y = value;
		}

		/**
		 * 偏移信息 
		 */
		public function get offsetX():int
		{
			return _offsetX;
		}

		/**
		 * @private
		 */
		public function set offsetX(value:int):void
		{
			_offsetX = value;
		}

		/**
		 * 偏移信息 
		 */
		public function get offsetY():int
		{
			return _offsetY;
		}

		/**
		 * @private
		 */
		public function set offsetY(value:int):void
		{
			_offsetY = value;
		}
		
		public function clone():AnimData {
			var ad:AnimData = new AnimData();
			for (var key:String in this) {
				ad[key] = this[key];
			}
			ad.x = _x;
			ad.y = _y;
			ad.offsetX = _offsetX;
			ad.offsetY = _offsetY;
			if(bd!=null){
				ad.bd = bd;
			}
			return ad;
		}

	}
}