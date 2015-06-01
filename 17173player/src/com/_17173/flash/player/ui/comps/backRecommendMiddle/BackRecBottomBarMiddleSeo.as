package com._17173.flash.player.ui.comps.backRecommendMiddle
{
	public class BackRecBottomBarMiddleSeo extends BackRecBottomBarMiddle
	{
		public function BackRecBottomBarMiddleSeo()
		{
			super();
		}
		
		override protected function addRightBar():void {
			_rightbar = new mc_backRec_small_replay();
			addChild(_rightbar);
		}
	}
}