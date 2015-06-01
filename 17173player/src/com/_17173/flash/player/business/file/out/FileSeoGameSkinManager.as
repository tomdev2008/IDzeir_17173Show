package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.business.file.FileSkinManager;
	import com._17173.flash.player.ui.comps.ControlBarTimerSeoVideo;
	import com._17173.flash.player.ui.comps.LoadingSeoGame;
	import com._17173.flash.player.ui.comps.PlayAndPauseBigSeoGame;
	import com._17173.flash.player.ui.comps.PlayAndPauseSeoGame;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.TopBarSeoGame;
	import com._17173.flash.player.ui.comps.controlbar.FileSeoGameControlBar;
	import com._17173.flash.player.ui.comps.def.ControlBarDefButtonSeoVideo;
	import com._17173.flash.player.ui.comps.fullscreen.FullScreenSeoGame;
	import com._17173.flash.player.ui.comps.progressbar.ProgressBarSeoGame;
	import com._17173.flash.player.ui.comps.volume.VolumeSeoGame;
	
	import flash.display.Sprite;
	
	public class FileSeoGameSkinManager extends FileSkinManager
	{
		public function FileSeoGameSkinManager()
		{
			super();
		}
		
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.RIGHT_BAR, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOADING, LoadingSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULLSCREEN_TOP_BAR, TopBarSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.CONTROL_BAR, FileSeoGameControlBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULL_SCREEN, FullScreenSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE, PlayAndPauseSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE_BIG, PlayAndPauseBigSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.TIMER, ControlBarTimerSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.VOLUME, VolumeSeoGame));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.DEFINITION, ControlBarDefButtonSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PROGRESS_BAR, ProgressBarSeoGame));
		}
		
	}
}