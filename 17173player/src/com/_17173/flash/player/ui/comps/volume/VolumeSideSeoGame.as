package com._17173.flash.player.ui.comps.volume
{
	import flash.display.MovieClip;

	public class VolumeSideSeoGame extends VolumeSideSeo
	{
		public function VolumeSideSeoGame()
		{
			super();
		}
		
		override protected function get btn():MovieClip {
			return new mc_ball_seo_game();
		}
		
	}
}