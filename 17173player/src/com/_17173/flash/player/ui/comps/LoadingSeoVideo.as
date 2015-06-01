package com._17173.flash.player.ui.comps
{
	import flash.display.MovieClip;
	/**
	 * seo video loading
	 * @author anqinghang
	 * 
	 */
	public class LoadingSeoVideo extends Loading
	{
		public function LoadingSeoVideo()
		{
			super();
		}
		
		override protected function get loadingMC():MovieClip {
			return new mc_loading_seo_video();
		}
		
	}
}