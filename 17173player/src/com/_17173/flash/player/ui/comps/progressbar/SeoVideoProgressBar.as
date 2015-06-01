package com._17173.flash.player.ui.comps.progressbar
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * SEO 视频游戏  进度条组件
	 * @author anqinghang
	 */	
	public class SeoVideoProgressBar extends BaseProgressBar
	{
		private var _rightBtnClickEvent:Event;
		private var _leftBtnClickEvent:Event;
		private var _hideTipEvent:Event;
		
		public function SeoVideoProgressBar(stage:DisplayObject = null, defaultHeight:Number = 8)
		{
			super(stage, defaultHeight);
			this.proValue = 0;
		}
		
		override protected function get btn():MovieClip {
			return new mc_ball_seo_video();
		}
		
		override protected function get leftBtn():DisplayObject {
			return new mc_progressbar_left_seo_video();
		}
		
		override protected function get rightBtn():DisplayObject {
			return new mc_progressbar_right_seo_video();
		}
		
		override public function setProgressBarState(value:Boolean):void {
			if (value) {
				_mouseOn = true;
//				_currentHeight = 15;
//				y = -5;
			} else {
				_mouseOn = false;
//				_currentHeight = 11;
//				y = -2.5;
			}
			resize();
			if (!_mouseDragFlag) {
				moveBtn();
			}
		}
		
		override protected function trackBarMouseUp(event:MouseEvent):void
		{
			_proValue = event.localX / _trackBar.width;
			moveBtn();
			resize();
//			dispatchProgressChange();
		}
		
		override protected function resetCurrentPro():void {
			if (this.mouseX < _trackBar.x) {
				_proValue = 0;
			} else if (this.mouseX > (_trackBar.x + _trackBar.width)) {
				_proValue = 1;
			} else {
				_proValue = (this.mouseX - _trackBar.x) / _trackBar.width;
			}
			moveBtn();
			resize();
		}
		
		override protected function get btnOffset():Number {
			return 5;
		}
		
		override public function get height():Number {
			return 10;
		}
		
		override public function set proValue(value:Number):void {
			if (!_mouseDragFlag) {
				super.proValue = value;
			}
		}
		
		override protected function get proBarColor():uint{
			return 0xd83727;
		}
		
		override protected function rightMouseClick(event:Event):void
		{
			_mouseDragFlag = true;
			if (!_rightBtnClickEvent) {
				_rightBtnClickEvent = new Event("rightBtnClickEvent");
			}
			this.dispatchEvent(_rightBtnClickEvent);
		}
		
		override protected function leftMouseClick(event:Event):void
		{
			_mouseDragFlag = true;
			if (!_leftBtnClickEvent) {
				_leftBtnClickEvent = new Event("leftBtnClickEvent");
			}
			this.dispatchEvent(_leftBtnClickEvent);
		}
		
		override protected function thisMouseMove(event:MouseEvent):void {
			super.thisMouseMove(event);
			if (this.mouseX < _trackBar.x || this.mouseX > (_trackBar.x + _trackBar.width)) {
				if (!_hideTipEvent) {
					_hideTipEvent = new Event("hideTipEvent");
				}
				this.dispatchEvent(_hideTipEvent);
			}
		}
		
	}
}