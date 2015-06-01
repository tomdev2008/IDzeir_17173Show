package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import flash.display.Sprite;
	
	public class QuizUIOfficialPrecBar extends Sprite
	{
//		private var _bg:MovieClip;
		private var _bg:Sprite;
//		private var _bar:MovieClip;
		private var _bar:Sprite;
		private var _mask:Sprite;
		private var _w:Number = 0;
		private var _h:int = 10;
		private var _wa:int = 134;
		private var _pec:Number = 0;
		
		public function QuizUIOfficialPrecBar()
		{
			super();
			init();
		}
		
		private function init():void {
			initBar();
//			initMask();
			resize();
		}
		
		public function setData(value:Number):void {
			if (!value || isNaN(value)) {
				value = 0;
			}
			if (value >= 0) {
				_pec = value;
				_w = _wa * _pec;
			}
//			_bar.width = _bg.width * _pec;
			getBar();
			getBarBG();
//			_bar.scaleX = _pec;
//			initMask();
			resize();
		}
		
		private function initBar():void {
//			_bg = new mc_quizOfficialPecBarBg();
			_bg = getBarBG();
			addChild(_bg);
			
//			_bar = new mc_quizOfficialPecBar();
			_bar = getBar();
			_bg.addChild(_bar);
		}
		
		/**
		 * 进度条内容
		 */		
		private function getBar():Sprite {
			if (!_bar) {
				_bar = new Sprite();
			}
			var tempW:Number;
			if (_w < 1) {
				if (_w > 0) {
					tempW = 1;
				} else {
					tempW = 0;
				}
			} else {
				tempW = _w > 2 ? (_w - 1) : 0;
			}
			_bar.graphics.clear();
			_bar.graphics.beginFill(0xee375d);
			_bar.graphics.drawRoundRect(0, 0, tempW, 10, 2, 2);
			_bar.graphics.endFill();
			return _bar;
		}
		
		/**
		 * 进度条背景
		 */		
		private function getBarBG():Sprite {
			if (!_bg) {
				_bg = new Sprite();
			}
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x262626);
			_bg.graphics.drawRoundRect(0, 0, _wa, 12, 2, 2);
			_bg.graphics.endFill();
			return _bg;
		}
		
		private function initMask():void {
			if (!_mask) {
				_mask = new Sprite();
				_bg.addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRoundRect(0, 0, _wa - _w, _h, 0, 0);
			_mask.graphics.endFill();
		}
		
		public function resize():void {
			if (_bg) {
				_bg.x = 0;
				_bg.y = 0;
			}
			if (_bar) {
				_bar.x = 0.5;
				_bar.y = 1;
			}
//			if (_mask) {
//				_mask.x = 0;
//				_mask.y = 1;
//			}
		}
		
		public function setWidth(value:Number):void {
			_wa = value;
			_bg.width = value;
			setData(_pec);
		}
		
	}
}