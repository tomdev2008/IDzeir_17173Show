package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Logo extends Sprite
	{
		protected var url:String = "http://www.17173.com";
		
		public function Logo()
		{
			super();
			
			var logo:MovieClip = new skinObject.logo();
			addChild(logo);
			
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onClick(event:MouseEvent):void {
			Util.toUrl(url);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
			if (Context.variables["showBackRec"]) {
				
			} else {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
			}
		}
		
		public function get skinObject():Object {
			return {"logo":mc_logo_file};
		}
		
	}
}