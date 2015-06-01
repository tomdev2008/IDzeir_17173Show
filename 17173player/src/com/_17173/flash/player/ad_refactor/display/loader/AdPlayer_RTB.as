package com._17173.flash.player.ad_refactor.display.loader
{
	import flash.display.Sprite;

	/**
	 * 好耶RTB广告，由js显示
	 * 兜底广告的一种
	 * @author anqinghang
	 * 
	 */	
	public class AdPlayer_RTB extends BaseAdPlayer
	{
		public function AdPlayer_RTB()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			sendInfoToJS();
		}
		
		/**
		 * 通知js显示RTB广告
		 */		
		private function sendInfoToJS():void {
			_display = new Sprite();
			super.complete(null);
		}
		
	}
}