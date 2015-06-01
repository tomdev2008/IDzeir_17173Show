package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayerType;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Image;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_SWF;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class AdDisplay_guajiao extends BaseAdDisplay_refactor
	{
		
		private static const S_W:int = 80;
		private static const S_H:int = 60;
		private static const B_W:int = 634;
		private static const B_H:int = 60;
		private static const SIDE_W:int = 5;
		private static const SIDE_H:int = 12;
		
		private var _close:MovieClip = null;
		
		public function AdDisplay_guajiao()
		{
			super();
			
			_supportedPlayer[AdPlayerType.IMAGE] = AdPlayer_Image;
			_supportedPlayer[AdPlayerType.SWF] = AdPlayer_SWF;
			
			_close = new mc_ad_close();
			_close.x = width - _close.width + 1;
			_close.y = 1;
			addChild(_close);
			
			_close.addEventListener(MouseEvent.CLICK, closeClick);
		}
		
		override protected function onLoadSucc(result:Object):void {
			super.onLoadSucc(result);
		}
		
		override public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
		}
		
		private function closeClick(evt:MouseEvent):void {
			evt.stopPropagation();
			dispatchEvent(new Event("close"));
		}
		
		override public function get width():Number {
			return S_W;
		}
		
		override public function get height():Number {
			return S_H;
		}
	}
}