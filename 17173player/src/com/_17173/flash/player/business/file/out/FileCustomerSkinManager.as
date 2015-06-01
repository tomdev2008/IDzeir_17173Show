package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.business.file.FileSkinManager;
	import com._17173.flash.player.ui.comps.SearchTopBar;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.controlbar.FileCustomerControlBar;
	import com._17173.flash.player.ui.file.FileCustomerLogo;
	import com._17173.flash.player.ui.file.FileCustomerRightBar;
	
	public class FileCustomerSkinManager extends FileSkinManager
	{
		public function FileCustomerSkinManager()
		{
			super();
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, FileCustomerLogo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.OUT_TOP_BAR, SearchTopBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.RIGHT_BAR, FileCustomerRightBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.CONTROL_BAR, FileCustomerControlBar));
		}
		
	}
}