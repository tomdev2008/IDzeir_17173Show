package com._17173.flash.player.ui.comps.backRecommend
{
	public class BackRecTopBarSeo extends BackRecTopBar
	{
		public function BackRecTopBarSeo(width:Number)
		{
			super(width);
		}
		
		override protected function get titleColor():uint {
			if (_("backRecTitleColor")) {
				return _("backRecTitleColor");
			} else {
				return 0xd83727;
			}
		}
		
		override protected function addMoreC():void {
			
		}
		
		override protected function addRightBar():void {
			
		}
		
	}
}