package com._17173.flash.player.ui.comps.fullscreen
{
	import flash.display.MovieClip;

	/**
	 * seo 视频游戏全屏
	 * @author anqinghang
	 * 
	 */	
	public class FullScreenSeoVideo extends FullScreen
	{
		public function FullScreenSeoVideo()
		{
			super();
		}
		
		override protected function get icon():MovieClip {
			return new mc_fullScreen_seo_video();
		}
		
	}
}