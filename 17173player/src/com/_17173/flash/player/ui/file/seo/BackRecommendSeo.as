package com._17173.flash.player.ui.file.seo
{
	import com._17173.flash.player.ui.comps.backRecommend.BackRecBottomBarSeo;
	import com._17173.flash.player.ui.comps.backRecommend.BackRecTopBarSeo;
	import com._17173.flash.player.ui.file.BackRecommend;

	/**
	 * 后推 seo
	 * @author anqinghang
	 * 
	 */	
	public class BackRecommendSeo extends BackRecommend
	{
		public function BackRecommendSeo(width:Number, height:Number)
		{
			super(width, height);
		}
		
		override protected function addTopBar():void {
			_topbar = new BackRecTopBarSeo(width);
			_topbar.resize();
			addChild(_topbar);
		}
		
		override protected function addBottomBar():void {
			_bottompBar = new BackRecBottomBarSeo(width);
			addChild(_bottompBar);
		}
		
	}
}