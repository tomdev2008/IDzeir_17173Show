package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.IconButton;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;

	/**
	 * 竞猜顶部栏按钮（按钮+分隔竖线）
	 * @author Kevin
	 * 
	 */	
	public class QuizUITopBarBtn extends Sprite
	{
		private var _sourceData:MovieClip;
		private var _btn:Button;
		private var _line:Shape;
		private var _order:int;
		private var _label:String;
		
		public function QuizUITopBarBtn(icon:Boolean = false)
		{
			if (icon) {
				_btn = new IconButton(new mc_quiz_icon_guan());
			} else {
				_btn = new Button();
			}
			_label = _btn.label;
			_sourceData = new quizTitleBtn();
			_btn.setSkin(_sourceData);
			addChild(_btn);
			
			_line = new Shape();
			_line.graphics.clear();
			_line.graphics.beginFill(0x303030);
			_line.graphics.drawRect(0, 0, 1, QuizMainUI.TOP_BAR_HEIGHT);
			_line.graphics.endFill();
			_line.x = _btn.width;
			addChild(_line);
			
			this.graphics.clear();
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, _btn.width + 1, QuizMainUI.TOP_BAR_HEIGHT);
			this.graphics.endFill();
		}
		
		public function set bgAlphe(value:Number):void {
			if (_sourceData) {
				_sourceData.alpha = value;
			}
		}
		
		public function set label(value:String):void {
			_btn.label = value;
			_label = value;
			_btn.update();
		}
		
		public function get label():String {
			return _label;
		}
		
		override public function set width(value:Number):void {
			_btn.width = value;
			_line.x = _btn.width;
		}
		
		override public function set height(value:Number):void {
			_btn.height = value;
		}
		
		override public function get width():Number {
			return _btn.width + 1;
		}
		
		public function set selected(value:Boolean):void {
			_btn.selected = value;
		}

		/**
		 * 当前btn是第几个
		 */		
		public function get order():int
		{
			return _order;
		}

		public function set order(value:int):void
		{
			_order = value;
		}
		/**
		 * 获取真实的btn
		 */
		public function get btn():Button
		{
			return _btn;
		}


	}
}