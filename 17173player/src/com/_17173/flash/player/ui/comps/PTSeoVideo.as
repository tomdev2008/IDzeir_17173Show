package com._17173.flash.player.ui.comps
{
	import flash.display.MovieClip;

	public class PTSeoVideo extends PT
	{
		public function PTSeoVideo()
		{
			super();
		}
		
		override protected function get pt():MovieClip {
			return new mc_pt_seo_video();
		}
	}
}