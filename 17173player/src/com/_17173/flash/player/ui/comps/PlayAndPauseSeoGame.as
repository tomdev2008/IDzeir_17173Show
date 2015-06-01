package com._17173.flash.player.ui.comps
{
	/**
	 * seo 游戏视频播放按钮
	 * @author anqinghang
	 * 
	 */	
	public class PlayAndPauseSeoGame extends PlayAndPause
	{
		public function PlayAndPauseSeoGame()
		{
			super();
		}
		
		override protected function initMC():void {
			_btn = new mc_playAndPause_seo_game();
			addChild(_btn);
		}
		
	}
}