package com._17173.flash.player.ui.comps.progressbar
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * SEO 游戏视频  进度条组件
	 * @author anqinghang
	 */	
	public class SeoGameProgressBar extends SeoVideoProgressBar
	{
		public function SeoGameProgressBar(stage:DisplayObject=null, defaultHeight:Number=8)
		{
			super(stage, defaultHeight);
		}
		
		override protected function get btn():MovieClip {
			return new mc_ball_seo_game();
		}
		
		override protected function get leftBtn():DisplayObject {
			return new mc_progressbar_left_seo_game();
		}
		
		override protected function get rightBtn():DisplayObject {
			return new mc_progressbar_right_seo_game();
		}
		
		override protected function get proBarColor():uint{
			return 0x0697cc;
		}
		
	}
}