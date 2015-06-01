package com._17173.flash.player.module.onlineTime.item
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.DefineFrameMovieClip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class OlCountDownMC extends Sprite
	{
		public var _mc:DefineFrameMovieClip = null;

		public function OlCountDownMC()
		{
			super();
			var _jbp:MovieClip = new mc_jubaoben();
			_jbp.gotoAndStop(1);
			_jbp.mouseChildren = _jbp.mouseEnabled = false;
			_jbp.x = 9;
			_jbp.y = 52;
			this.addChild(_jbp);
			
			_mc = new DefineFrameMovieClip(new mc_countTime(), 6, Context.stage.frameRate);
			_mc.mouseChildren = false;
			_mc.mouseEnabled = false;
			this.addChild(_mc);
		}
		
		public function updateTime(time:String):void{
			_mc.mc.sLabel.text = time;
		}


		public function play():void
		{
			_mc.play();
		}

		public function stop():void
		{
			_mc.stop(1);
		}
	}
}
