package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.skin.SkinObjectPrototype;
	import com._17173.flash.player.context.SkinManager;
	import com._17173.flash.player.ui.comps.PlayAndPause;
	import com._17173.flash.player.ui.comps.PlayAndPauseBig;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.StreamLogo;
	import com._17173.flash.player.ui.comps.TopBar;
	import com._17173.flash.player.ui.comps.Watermark;
	import com._17173.flash.player.ui.comps.controlbar.ControlBar;
	import com._17173.flash.player.ui.comps.fullscreen.FullScreen;
	import com._17173.flash.player.ui.comps.volume.VolumeBar;
	import com._17173.flash.player.ui.stream.StreamBottomBar;
	import com._17173.flash.player.ui.stream.StreamRightBar;
	import com._17173.flash.player.ui.stream.extra.StreamExtraBar;
	import com._17173.flash.player.ui.stream.extra.StreamSecondExtraBar;
	
	import flash.display.Sprite;
	
	public class StreamSkinManager extends SkinManager
	{
		public function StreamSkinManager()
		{
			super();
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
			
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.BOTTOM_BAR, StreamBottomBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.RIGHT_BAR, StreamRightBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULLSCREEN_TOP_BAR, TopBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.NORMAL_TOP_BAR, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.LOGO, StreamLogo));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.CONTROL_BAR, ControlBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.DEFINITION, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PROGRESS_BAR, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.VOLUME, VolumeBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE, PlayAndPause));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.PLAY_AND_PAUSE_BIG, PlayAndPauseBig));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.FULL_SCREEN, FullScreen));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.TIMER, Sprite));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.STREAM_EXTRA_BAR, StreamExtraBar));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.WATER_MARK, Watermark));
			addSkinConfig(new SkinObjectPrototype(SkinsEnum.STREAM_SECOND_EXTRA_BAR, StreamSecondExtraBar));

		}
		
	}
}