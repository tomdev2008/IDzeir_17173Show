package com._17173.flash.player.ui.comps.fullscreen
{
	import flash.display.MovieClip;
	/**
	 * seo 游戏视频全屏
	 * @author anqinghang
	 * 
	 */	
	public class FullScreenSeoGame extends FullScreen
	{
		public function FullScreenSeoGame()
		{
			super();
		}
		
		override protected function get icon():MovieClip {
			return new mc_fullScreen_seo_game();
		}
	}
}