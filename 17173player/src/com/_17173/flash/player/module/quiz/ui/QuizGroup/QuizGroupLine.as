package com._17173.flash.player.module.quiz.ui.QuizGroup
{
	import flash.display.Sprite;
	
	/**
	 * 竞猜group中使用的分割线
	 */	
	public class QuizGroupLine extends Sprite
	{
		public function QuizGroupLine(w:int, h:int)
		{
			super();
			init(w, h);
		}
		
		private function init(w:int, h:int):void {
			this.graphics.clear();
			this.graphics.beginFill(0x303030);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
		}
	}
}