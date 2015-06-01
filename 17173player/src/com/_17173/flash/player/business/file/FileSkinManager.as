package com._17173.flash.player.business.file
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.context.SkinManager;
	import com._17173.flash.player.ui.comps.ControlBarTimer;
	import com._17173.flash.player.ui.comps.Logo;
	import com._17173.flash.player.ui.comps.PlayAndPause;
	import com._17173.flash.player.ui.comps.PlayAndPauseBig;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.TopBar;
	import com._17173.flash.player.ui.comps.controlbar.ControlBar;
	import com._17173.flash.player.ui.comps.def.ControlBarDefButton;
	import com._17173.flash.player.ui.comps.fullscreen.FullScreen;
	import com._17173.flash.player.ui.comps.progressbar.ControlBarProgress;
	import com._17173.flash.player.ui.comps.volume.VolumeBar;
	import com._17173.flash.player.ui.file.FileBottomBar;
	import com._17173.flash.player.ui.file.RightBar;
	
	import flash.display.Sprite;
	
	public class FileSkinManager extends SkinManager
	{
		public function FileSkinManager()
		{
			super();
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, Logo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.BOTTOM_BAR, FileBottomBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.RIGHT_BAR, RightBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULLSCREEN_TOP_BAR, TopBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.NORMAL_TOP_BAR, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.CONTROL_BAR, ControlBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.DEFINITION, ControlBarDefButton));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PROGRESS_BAR, ControlBarProgress));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.VOLUME, VolumeBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE, PlayAndPause));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE_BIG, PlayAndPauseBig));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULL_SCREEN, FullScreen));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.TIMER, ControlBarTimer));
		}
		
		override public function resize():void {
//			if(Context.stage.stageWidth <= 200 || Context.stage.stageHeight <= 185) {
//				getSkin("timeBar").display.visible = false;
//				getSkin("logo").display.visible = true;
//				getSkin("fullScreen").display.visible = true;
//				getSkin("defBtn").display.visible = false;
//				getSkin("volumeBar").display.visible = true;
//				getSkin("rightbar_mobile").display.visible = false;
//			} else {
//				getSkin("timeBar").display.visible = true;
//				getSkin("logo").display.visible = false;
//				getSkin("fullScreen").display.visible = true;
//				getSkin("defBtn").display.visible = true;
//				getSkin("volumeBar").display.visible = true;
//				getSkin("rightbar_mobile").display.visible = true;
//			}
		}
		
	}
}