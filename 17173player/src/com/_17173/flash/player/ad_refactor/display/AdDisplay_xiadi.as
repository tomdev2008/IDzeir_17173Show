package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayerType;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_Image;
	import com._17173.flash.player.ad_refactor.display.loader.AdPlayer_SWF;
	
	import flash.display.Sprite;

	public class AdDisplay_xiadi extends BaseAdDisplay_refactor
	{
		private var _mask:Sprite;
		
		public function AdDisplay_xiadi()
		{
			super();
			
			_supportedPlayer[AdPlayerType.IMAGE] = AdPlayer_Image;
			_supportedPlayer[AdPlayerType.SWF] = AdPlayer_SWF;
			addMask();
		}
		
		/**
		 * 为了防止物料里有超过指定宽高的内容，做一个遮罩
		 */		
		private function addMask():void {
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0, 0);
			_mask.graphics.drawRect(0, 0, 235, 20);
			_mask.graphics.endFill();
			this.addChild(_mask);
			this.mask = _mask;
		}
		
		override protected function onLoadSucc(result:Object):void {
			super.onLoadSucc(result);
		}
		
		override public function resize(w:int, h:int):void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, 235, 20);
			graphics.endFill();
			
			super.resize(w, h);
		}
		
		override public function get height():Number {
			return 20;
		}
		
		override public function get width():Number {
			return 235;
		}
		
	}
}