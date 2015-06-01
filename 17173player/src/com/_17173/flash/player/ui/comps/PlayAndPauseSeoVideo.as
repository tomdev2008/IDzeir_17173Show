package com._17173.flash.player.ui.comps
{
	/**
	 * seo 视频游戏播放按钮
	 * @author anqinghang
	 * 
	 */	
	public class PlayAndPauseSeoVideo extends PlayAndPause
	{
		public function PlayAndPauseSeoVideo()
		{
			super();
		}
		
		override protected function initMC():void {
			_btn = new mc_playAndPause_seo_video();
			addChild(_btn);
		}
		
	}
}