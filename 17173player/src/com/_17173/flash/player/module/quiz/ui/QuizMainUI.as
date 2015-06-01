package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.player.module.quiz.ui.QuizControlBar.QuizUIBottomBar;
	import com._17173.flash.player.module.quiz.ui.QuizControlBar.QuizUITopBar;
	
	import flash.display.Sprite;
	
	public class QuizMainUI extends Sprite
	{
		private var _topBarUI:QuizUITopBar;
		private var _bottomBarUI:QuizUIBottomBar;
		private var _quizDataArr:Array;
		
		public static const TOP_BAR_HEIGHT:int = 32;
		public static const BOTTOM_BAR_HEIGHT:int = 56;
		
		public function QuizMainUI()
		{
			super();
			init();
			resize();
		}
		
		public function set quizData(value:Array):void {
			_quizDataArr = [];
			_quizDataArr = value;
			_topBarUI.quizData = _quizDataArr;
			resize();
		}
		
		private function init():void {
			_topBarUI = new QuizUITopBar();
			addChild(_topBarUI);
			_bottomBarUI = new QuizUIBottomBar();
			addChild(_bottomBarUI);
		}
		
		private function drawBg():void {
		}
		
		public function resize():void {
			_bottomBarUI.y = _topBarUI.height;
		}
		
		public function get currentSelectData():Object {
			return _topBarUI.currentSelectData;
		}
		
	}
}