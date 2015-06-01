package com._17173.flash.player.ui.comps.progressbar
{
	import com._17173.flash.core.context.Context;

	/**
	 * SEO 游戏视频  进度条
	 * @author anqinghang
	 */	
	public class ProgressBarSeoGame extends ProgressBarSeoVideo
	{
		public function ProgressBarSeoGame()
		{
			super();
		}
		
		override protected function get progressBar():BaseProgressBar {
			return new SeoGameProgressBar(Context.stage);
		}
		
	}
}