package com._17173.flash.player.ui.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.BottomBar;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class StreamBottomBar extends BottomBar
	{
		/**
		 * 判断mouse是不是在三个bar上
		 */
		public var _mouseOnBar:Boolean = false;
		
		public function StreamBottomBar()
		{
			super();
		}
		
		public function set mouseOnBar(value:Boolean):void {
			_mouseOnBar = value;
		}
		/**
		 * 添加ControlBar
		 * 根据当前宽度决定是否要添加ControlBar
		 */		
		override protected function addControlBar():void {
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_5) {
				
			} else {
				if (_controlBar && _controlBar.display && !contains(_controlBar.display)) {
//					_controlBar = Global.skinManager.attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
					_controlBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
				}
			}
		}
		
		
		public override function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					resize();
					TweenLite.killTweensOf(this);
					y = Context.stage.stageHeight - height;
					break;
				case SkinEvents.SHOW_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight - height});
					}
					break;
				case SkinEvents.HIDE_FLOW : 
					if (_mouseOnBar) return ;
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight});
					}
					break;
			}
		}
		
		/**
		 * 根据当前的播放器宽度设置是否要显示ControlBar
		 */		
		override protected function resetControlBar():void {
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_5) {
				if (_controlBar && contains(_controlBar.display)) {
//					Global.skinManager.deattachSkinByName(SkinsEnum.CONTROL_BAR);
					(Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).deattachSkinByName(SkinsEnum.CONTROL_BAR);
				}
			} else {
				if (!_controlBar || !contains(_controlBar.display)) {
//					_controlBar = Global.skinManager.attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
					_controlBar =(Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.CONTROL_BAR, this, 0);
					(_controlBar.display as Sprite).mouseEnabled = _mouseEnableFlag;
					(_controlBar.display as Sprite).mouseChildren = _mouseChilderFlag;
				}
			}
		}
		
	}
}