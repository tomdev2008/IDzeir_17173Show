package com._17173.flash.player.ui.stream.outGift.ui
{
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class OutGiftUI extends Sprite implements IExtraUIItem
	{
		private var _btn:DisplayObject;
		
		public function OutGiftUI()
		{
			super();
			init();
		}
		
		private function init():void {
			//			_btn = new mc_sendGiftBtn();
			_btn = new mc_out_sendGiftBtn();
			_btn.x = -_btn.width;
			addChild(_btn);
		}
		
		public function refresh(isFullScreen:Boolean=false):void {
			
		}
		
		public function get side():Boolean {
			return ExtraUIItemEnum.SIDE_RIGHT;
		}
	}
}


