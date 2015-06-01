package com._17173.flash.player.ui.comps.fullscreen
{
	import flash.display.MovieClip;

	/**
	 * 点播站外使用的回链全屏
	 * @author 安庆航
	 * 
	 */	
	public class BackLinkFullScreen extends FullScreen
	{
		public function BackLinkFullScreen()
		{
			super();
		}
		
		override protected function get icon():MovieClip {
			return new mc_backLinkFullScreen;
		}
		
	}
}