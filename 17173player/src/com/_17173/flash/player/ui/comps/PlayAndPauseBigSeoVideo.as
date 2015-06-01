package com._17173.flash.player.ui.comps
{
	import flash.display.DisplayObject;

	/**
	 * seo 视频游戏大播放按钮
	 */	
	public class PlayAndPauseBigSeoVideo extends PlayAndPauseBig
	{
		public function PlayAndPauseBigSeoVideo()
		{
			super();
		}
		
		override protected function get btn():DisplayObject {
			return new mc_playAndPause_big_seo_video(); 
		}
		
	}
}