package com._17173.flash.player.ui.comps
{
	import flash.display.DisplayObject;

	/**
	 * seo 游戏视频大播放按钮
	 */	
	public class PlayAndPauseBigSeoGame extends PlayAndPauseBig
	{
		public function PlayAndPauseBigSeoGame()
		{
			super();
		}
		
		
		override protected function get btn():DisplayObject {
			return new mc_playAndPause_big_seo_game(); 
		}
		
	}
}