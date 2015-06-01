package com._17173.flash.player.ui.file.seo
{
	import com._17173.flash.player.ui.comps.backRecommendMiddle.BackRecBottomBarMiddleSeo;
	import com._17173.flash.player.ui.comps.backRecommendMiddle.BackRecTopBarMiddleSeo;
	import com._17173.flash.player.ui.file.BackRecommendMiddle;
	
	public class BackRecommendMiddleSeo extends BackRecommendMiddle
	{
		public function BackRecommendMiddleSeo(width:Number, height:Number)
		{
			super(width, height);
		}
		
		override protected function addTopBar():void {
			_topbar = new BackRecTopBarMiddleSeo();
			addChild(_topbar);
		}
		
		override protected function addBottomBar():void {
			_bottompBar = new BackRecBottomBarMiddleSeo();
			addChild(_bottompBar);
		}
		
	}
}