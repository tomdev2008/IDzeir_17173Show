package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 竞猜投入进度条
	 */	
	public class QuizPercentBar extends Sprite
	{
		private var _type:int;
		private var _bg:MovieClip;
		private var _bar:MovieClip;
		private var _mask:Sprite;
		private var _w:int = 0;
		private var _h:int = 10;
		private var _wa:int = 255;
		
		public function QuizPercentBar(type:int = 0)
		{
			super();
			_type = type;
			init();
		}
		
		private function init():void {
			initBar();
			initMask();
			resize();
		}
		
		public function setData(value:Number):void {
			if (value >= 0) {
				_w = _wa - (_wa * value);
			}
			initMask();
			resize();
		}
		
		private function initBar():void {
			_bg = new quizPecBarBg();
			addChild(_bg);
			
			if (_type == 0) {
				_bar = new quizPecBarRed();
			} else {
				_bar = new quizPecBlue();
			}
			_bg.addChild(_bar);
		}
		
		private function initMask():void {
			if (!_mask) {
				_mask = new Sprite();
				_bg.addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x303030);
			if (_type == 0) {
				_mask.graphics.drawRoundRect(0, 0, _w, _h, 0, 7);
			} else {
				_mask.graphics.drawRoundRect(0, 0, _w, _h, 7, 0);
			}
			_mask.graphics.endFill();
		}
		
		public function resize():void {
			if (_bar) {
				_bar.x = 2;
				_bar.y = 2;
			}
			if (_mask) {
				if (_type == 1) {
					_mask.x = 2;
				} else {
					_mask.x = _wa - _mask.width + 2;
				}
				_mask.y = 2;
			}
		}
	}
}