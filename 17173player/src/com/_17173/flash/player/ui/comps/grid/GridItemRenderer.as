package com._17173.flash.player.ui.comps.grid
{
	import flash.display.Sprite;
	
	public class GridItemRenderer extends Sprite implements IGridItemRenderer
	{
		
		protected var _w:Number = 0;
		protected var _h:Number = 0;
		protected var _data:Object = null;
		
		public function GridItemRenderer()
		{
			super();
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		public function set data(value:Object):void {
			_data = value;
		}
		
		override public function get width():Number {
			return _w ? _w : super.width;
		}
		
		override public function get height():Number {
			return _h ? _h : super.height;
		}
		
		override public function set width(value:Number):void {
			_w = value;
		}
		
		override public function set height(value:Number):void {
			_h = value;
		}
		
		public function dispose():void {
			// TODO Auto Generated method stub
			_data = null;
			removeChildren(0, numChildren - 1);
		}
		
	}
}