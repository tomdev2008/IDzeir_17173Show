package com._17173.flash.player.ui.comps
{
	public class TopBarSeoVideo extends TopBar
	{
		public function TopBarSeoVideo()
		{
			super();
		}
		
		override protected function addShrink():void {
			_shrink = new mc_topbar_shrink_seo_video();
			addChild(_shrink);
		}
		
		override protected function addFull():void
		{
			_full = new mc_topbar_full_seo_video();
			addChild(_full);
		}
		
		override protected function addHundred():void
		{
			_hundred = new mc_topbar_hundred_seo_video();
			addChild(_hundred);
		}
		
		override protected function addSeventyFive():void
		{
			_seventyFive = new mc_topbar_seventyFive_seo_video();
			addChild(_seventyFive);
		}
		
		override protected function addFifty():void
		{
			_fifty = new mc_topbar_fifty_seo_video();
			addChild(_fifty);
		}
		
	}
}