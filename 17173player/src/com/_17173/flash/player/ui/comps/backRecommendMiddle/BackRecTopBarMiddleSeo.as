package com._17173.flash.player.ui.comps.backRecommendMiddle
{
	public class BackRecTopBarMiddleSeo extends BackRecTopBarMiddle
	{
		public function BackRecTopBarMiddleSeo()
		{
			super();
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
	}
}