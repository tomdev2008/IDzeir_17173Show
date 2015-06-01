package com._17173.flash.player.ui.comps.fullscreen
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FullScreen extends Sprite implements ISkinObjectListener
	{
		
		protected var _comp:MovieClip = null;
		
		public function FullScreen()
		{
			super();
			init();
			addListen();
			setEnable(false);
		}
		
		protected function addListen():void {
			addEventListener(MouseEvent.CLICK, onMouseClick);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_GET_VIDEO_INFO, getVideoInfo);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_PLAYER_SWITCH_STREAM, onSwitchStream);
		}
		
		protected function init():void {
			_comp = icon;
			addChild(_comp);
		}
		
		protected function get icon():MovieClip {
			return new mc_toogle_fullscreen();
		}
		
		private function getVideoInfo(data:Object):void {
			setEnable(true);
		}
		
		private function onSwitchStream(data:Object):void {
			setEnable(false);
		}
		
		protected function onMouseClick(event:MouseEvent):void {
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN, null, null, true);
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					onResize();
					break;
			}
		}
		
		private function setEnable(value:Boolean):void {
			this.mouseEnabled = value;
			this.mouseChildren = value;
		}
		
		protected function onResize():void {
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			if (settings) {
				if (settings.isFullScreen) {
					_comp.isFullScreen = true;
				} else {
					_comp.isFullScreen = false;
				}
			}
		}
		
	}
}