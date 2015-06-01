package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.business.file.FileSkinManager;
	import com._17173.flash.player.ui.comps.OutLogoExpand;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.fullscreen.BackLinkFullScreen;
	import com._17173.flash.player.ui.file.OutPlayerTopBar;
	
	public class FileOutSkinManager extends FileSkinManager
	{
		public function FileOutSkinManager()
		{
			super();
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, OutLogoExpand));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.OUT_TOP_BAR, OutPlayerTopBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULL_SCREEN, BackLinkFullScreen));
		}
		
	}
}