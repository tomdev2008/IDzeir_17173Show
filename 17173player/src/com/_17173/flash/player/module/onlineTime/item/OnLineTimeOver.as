package com._17173.flash.player.module.onlineTime.item
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.DefineFrameMovieClip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class OnLineTimeOver extends Sprite
	{
		/**
		 *等待领取
		 */
		private var _overTime:DefineFrameMovieClip = null;

		public function OnLineTimeOver()
		{
			super();
			var _jbp:MovieClip = new mc_jubaoben();
			_jbp.gotoAndStop(1);
			_jbp.mouseEnabled = false;
			_jbp.x = 9;
			_jbp.y = 52;
			this.addChild(_jbp);
			_overTime = new DefineFrameMovieClip(new mc_overTime(), 6, Context.stage.frameRate);
			_overTime.visible = true;
			_overTime.mouseChildren = false;
			_overTime.stop(1);
			_overTime.mc.sLabel.text = "领元宝";
			_overTime.buttonMode = true;
			this.addChild(_overTime);
		}


		public function play():void
		{
			_overTime.play(true);
		}

		public function stop():void
		{
			_overTime.stop(1);
		}

	}
}
