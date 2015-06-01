package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.ui.comps.BottomBar;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	public class FileBottomBar extends BottomBar
	{
		public function FileBottomBar()
		{
			super();
		}
		
		/**
		 * 添加ControlBar
		 * 根据当前宽度决定是否要添加ControlBar
		 */		
		override protected function addControlBar():void {
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_4) {
				
			} else {
				if (_controlBar && _controlBar.display && !contains(_controlBar.display)) {
//					_controlBar = Global.skinManager.attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
					_controlBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
				}
			}
		}
		
		/**
		 * 根据当前的播放器宽度设置是否要显示ControlBar
		 */		
		override protected function resetControlBar():void {
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_4) {
				if (_controlBar && contains(_controlBar.display)) {
//					Global.skinManager.deattachSkinByName(SkinsEnum.CONTROL_BAR);
					(Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).deattachSkinByName(SkinsEnum.CONTROL_BAR);
				}
			} else {
				if (!_controlBar || !contains(_controlBar.display)) {
//					_controlBar = Global.skinManager.attachSkinByName(SkinsEnum.CONTROL_BAR, this);
					_controlBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.CONTROL_BAR, this);
				}
			}
		}
		
	}
}