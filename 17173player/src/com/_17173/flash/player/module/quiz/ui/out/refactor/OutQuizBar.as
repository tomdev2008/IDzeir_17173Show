package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * 进度条 
	 * 
	 * @author 庆峰
	 */	
	public class OutQuizBar extends Sprite
	{
		
		private var _bgColor:uint = 0;
		private var _color:uint = 0;
		private var _h:Number = 12;
		private var _w:Number = 0;
		
		private var _bg:Shape = null;
		private var _bar:Shape = null;
		
		private var _reverse:Boolean = false;
		private var _percent:Number = 1;
		
		public function OutQuizBar(bgColor:uint, color:uint, reverse:Boolean = false)
		{
			super();
			
			_bgColor = bgColor;
			_color = color;
			_reverse = reverse;
			
			_bg = new Shape();
			addChild(_bg);
			
			_bar = new Shape();
			addChild(_bar);
		}
		
		protected function update():void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(_bgColor, 0.2);
			_bg.graphics.drawRoundRect(0, 0, _w, _h, 5, 5);
			_bg.graphics.endFill();
			
			_bar.graphics.clear();
			_bar.graphics.beginFill(_color, 1);
			var barW:Number = _percent * (_w - 2);
			if ((_percent > 0.00000001)&&(barW<1)) barW = 1;
			var barX:Number = _reverse ? _w - 1 - barW : 1;
			_bar.graphics.drawRoundRect(barX, 1, barW, _h - 2, 5, 5);
			_bar.graphics.endFill();
		}
		
		override public function set width(value:Number):void {
			_w = value;
			
			update();
		}
		
		override public function set height(value:Number):void {
			_h = value;
			
			update();
		}
		
		public function set percent(value:Number):void {
			_percent = value;
			
			update();
		}
	}
}