package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.HGroup;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class QuizTextBG extends Sprite
	{
		private var _w:int;
		private var _h:int;
		private var con:HGroup;
		private var _bg:quizTextInputBG;
		public function QuizTextBG(w:int, h:int)
		{
			super();
			_w = w;
			_h = h;
			init();
		}
		
		public function addItem(child:DisplayObject):void {
			con.addChild(child);
			resize();
		}
		
		private function init():void {
			_bg = new quizTextInputBG();
			_bg.width = _w;
			_bg.height = _h;
			this.addChild(_bg);
			con = new HGroup();
			this.addChild(con);
		}
		
		private function resize():void {
//			graphics.clear();
//			graphics.beginFill(0xffffff);
//			graphics.drawRect(0, 0, con.width , con.height);
//			graphics.endFill();
		}
	}
}