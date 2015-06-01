package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Face extends Sprite
	{

		private var _head:Sprite;
		private var _mask:Shape;
		private var _border:Shape;
		
		public function Face(_x:Number = 17,_y:Number = 17,radio:Number = 17)
		{
			super();
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000,0);
			_mask.graphics.drawCircle(_x,_y,radio);
			_mask.graphics.endFill();
			
			_border = new Shape();
			_border.graphics.lineStyle(1,0xffffff,.6);
			_border.graphics.drawCircle(_x,_y,radio);
			_border.graphics.endFill();
		}
		
		public function set head(url:String):void
		{
			_head = Utils.getURLGraphic(url, true, 40, 40) as Sprite;
			this.removeChildren();
			this.addChild(_head);
			this.addChild(_mask);
			this.addChild(_border);
			_head.mask = _mask;
			_border.x = _border.y = _mask.x = _mask.y = (40-_mask.width)*.5;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value - (40-_mask.width)*.5
		}
		
		override public function get x():Number
		{
			return super.x + (40-_mask.width)*.5
		}
		
		override public function set y(value:Number):void
		{
			super.y = value - (40-_mask.width)*.5
		}
		
		override public function get y():Number
		{
			return super.y + (40-_mask.width)*.5
		}
		
		override public function get width():Number
		{
			return _mask.width;
		}
		
		override public function get height():Number
		{
			return _mask.height;
		}
	}
}