package com._17173.flash.player.ui.comps
{
	import flash.display.MovieClip;

	/**
	 * seo 游戏视频 loading
	 * @author anqinghang
	 * 
	 */
	public class LoadingSeoGame extends Loading
	{
		public function LoadingSeoGame()
		{
			super();
		}
		
		override protected function get loadingMC():MovieClip {
			return new mc_loading_seo_game();
		}
		
	}
}