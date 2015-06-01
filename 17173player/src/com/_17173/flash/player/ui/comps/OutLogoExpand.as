package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 站外播放器logo分开跳转两个不同的地址
	 * 17173:http://www.17173.com/?vid=video_zz
	 * 视频：http://v.17173.com/?vid=video_vz
	 * @author anqinghang
	 * 
	 */	
	public class OutLogoExpand extends Logo
	{
		private var _logo173:Sprite;
		private var _logoWord:Sprite;
		
		public function OutLogoExpand()
		{
			super();
			url = "http://v.17173.com";
			
			addMask();
		}
		
		private function addMask():void {
			_logo173 = new Sprite();
			_logo173.buttonMode = true;
			_logo173.graphics.clear();
			_logo173.graphics.beginFill(0xffffff, 0);
			_logo173.graphics.drawRect(0, 0, 55, 18);
			_logo173.graphics.endFill();
			_logo173.addEventListener(MouseEvent.CLICK, logo173Click);
			addChild(_logo173);
			
			_logoWord = new Sprite();
			_logoWord.buttonMode = true;
			_logoWord.graphics.clear();
			_logoWord.graphics.beginFill(0xffffff, 0);
			_logoWord.graphics.drawRect(0, 0, 32, 18);
			_logoWord.graphics.endFill();
			_logoWord.x = 55;
			_logoWord.addEventListener(MouseEvent.CLICK, _logoWordClick);
			addChild(_logoWord);
		}
		
		protected function _logoWordClick(event:MouseEvent):void
		{
			toUrl("http://v.17173.com/?vid=video_vz");
		}
		
		protected function logo173Click(event:MouseEvent):void
		{
			toUrl("http://www.17173.com/?vid=video_zz");
		}
		
		private function toUrl(url:String):void {
			Util.toUrl(url);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
			if (Context.variables["showBackRec"]) {
				
			} else {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
			}
		}
		
		override protected function onClick(event:MouseEvent):void {
			
		}
		
		override public function get skinObject():Object {
			return {"logo":mc_logo};
		}
		
	}
	
}