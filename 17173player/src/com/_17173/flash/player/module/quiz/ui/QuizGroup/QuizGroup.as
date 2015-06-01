package com._17173.flash.player.module.quiz.ui.QuizGroup
{
	import flash.display.Sprite;
	
	public class QuizGroup extends Sprite
	{
		private var _w:int;
		private var _h:int;
		private var _line:int;
		private var _row:int;
		private var _currentData:Array;
		private var _rowH:int = 32;
		private var _fourRow:Array = [88, 176, 338];
		private var _fiveRow:Array = [88, 176, 338, 406];
		
		public function QuizGroup(line:int, row:int, w:int = 512)
		{
			super();
			_line = line;
			_row = row;
			_w = w;
			init();
		}
		
		private function init():void {
			_h = _rowH * (_line + 1);
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
			
			initLine();
		}
		
		private function initLine():void {
			var tempRow:Array;
			var tempLine:Array;
			if (_row == 4) {
				tempRow = _fourRow;
			} else {
				tempRow = _fiveRow;
			}
			var item:QuizGroupLine;
			for (var i:int = 0; i < _row; i++) {
				item = new QuizGroupLine(2, _h);
				item.x = tempRow[i];
				item.y = 0;
				this.addChild(item);
			}
			for (var j:int = 0; j < _line; j++) {
				item = new QuizGroupLine(_w, 2);
				item.x = 0;
				item.y = _rowH * (j + 1);
				this.addChild(item);
			}
		}
		
	}
}