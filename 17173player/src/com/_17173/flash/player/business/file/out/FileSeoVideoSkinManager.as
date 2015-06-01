package com._17173.flash.player.business.file.out
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.business.file.FileSkinManager;
	import com._17173.flash.player.ui.comps.ControlBarTimerSeoVideo;
	import com._17173.flash.player.ui.comps.LoadingSeoVideo;
	import com._17173.flash.player.ui.comps.PlayAndPauseBigSeoVideo;
	import com._17173.flash.player.ui.comps.PlayAndPauseSeoVideo;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.TopBarSeoVideo;
	import com._17173.flash.player.ui.comps.controlbar.FileSeoVideoControlBar;
	import com._17173.flash.player.ui.comps.def.ControlBarDefButtonSeoVideo;
	import com._17173.flash.player.ui.comps.fullscreen.FullScreenSeoVideo;
	import com._17173.flash.player.ui.comps.progressbar.ProgressBarSeoVideo;
	import com._17173.flash.player.ui.comps.volume.VolumeSeoVideo;
	
	import flash.display.Sprite;
	
	public class FileSeoVideoSkinManager extends FileSkinManager
	{
		public function FileSeoVideoSkinManager()
		{
			super();
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.RIGHT_BAR, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOADING, LoadingSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULLSCREEN_TOP_BAR, TopBarSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.CONTROL_BAR, FileSeoVideoControlBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULL_SCREEN, FullScreenSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE, PlayAndPauseSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE_BIG, PlayAndPauseBigSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.TIMER, ControlBarTimerSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.VOLUME, VolumeSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.DEFINITION, ControlBarDefButtonSeoVideo));
//			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PROGRESS_BAR, ControlBarProgressSeoVideo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PROGRESS_BAR, ProgressBarSeoVideo));
		}
	}
}