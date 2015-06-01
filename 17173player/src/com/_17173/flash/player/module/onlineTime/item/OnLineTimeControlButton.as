package com._17173.flash.player.module.onlineTime.item
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class OnLineTimeControlButton extends Sprite
	{
		private var _mcArrowLeft:MovieClip = null;
		private var _mcArrowRight:MovieClip = null;
		private var _mcArrowRightLeft:MovieClip = null;
		private var _mcArrowLeftRight:MovieClip = null;
		private var _state:String = null;
		
		public function OnLineTimeControlButton()
		{
			super();
			_mcArrowLeft = new mc_arrowLeft();
			_mcArrowRight = new mc_arrowRight();
			_mcArrowRightLeft = new mc_arrowRightLeft();
			_mcArrowLeftRight = new mc_arrowLeftRight();
			_mcArrowLeftRight.gotoAndStop(0);
			_mcArrowRightLeft.gotoAndStop(0);
			
			addChild(_mcArrowLeft);
			addChild(_mcArrowRight);
			addChild(_mcArrowLeftRight);
			addChild(_mcArrowRightLeft);
			
			_mcArrowLeft.visible = false;
			_mcArrowRight.visible = false;
			_mcArrowLeftRight.visible = false;
			_mcArrowRightLeft.visible = false;
			
			_mcArrowLeft.visible = true;
			
			_mcArrowLeftRight.addFrameScript(_mcArrowLeftRight.totalFrames - 1, onArrowLeftRightLastFrame);
			_mcArrowRightLeft.addFrameScript(_mcArrowRightLeft.totalFrames - 1, onArrowRightLeftLastFrame);
		}
		
		private function showLeft():void
		{
			_mcArrowLeft.visible = true;
			_mcArrowRight.visible = false;
			_mcArrowLeftRight.visible = false;
			_mcArrowRightLeft.visible = false;
		}
		
		public function showRight():void
		{
			_mcArrowLeft.visible = false;
			_mcArrowRight.visible = true;
			_mcArrowLeftRight.visible = false;
			_mcArrowRightLeft.visible = false;
		}
		
		public function turnRight():void
		{
			_mcArrowLeft.visible = false;
			_mcArrowRight.visible = false;
			_mcArrowLeftRight.visible = true;
			_mcArrowRightLeft.visible = false;
			_mcArrowLeftRight.play();
		}
		
		public function turnLeft():void
		{
			_mcArrowLeft.visible = false;
			_mcArrowRight.visible = false;
			_mcArrowLeftRight.visible = false;
			_mcArrowRightLeft.visible = true;
			_mcArrowRightLeft.play();
		}
		
		private function onArrowLeftRightLastFrame():void
		{
			showRight();
			_mcArrowLeftRight.stop();
			_mcArrowLeftRight.gotoAndStop(0);
		}
		
		private function onArrowRightLeftLastFrame():void
		{
			showLeft();
			_mcArrowRightLeft.stop();
			_mcArrowRightLeft.gotoAndStop(0);
		}
	}
}