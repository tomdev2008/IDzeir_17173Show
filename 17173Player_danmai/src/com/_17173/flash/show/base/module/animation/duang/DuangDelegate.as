package com._17173.flash.show.base.module.animation.duang
{
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class DuangDelegate extends BaseModuleDelegate
	{
		public function DuangDelegate()
		{
			super();
		}
		
		override protected function onModuleLoaded():void
		{
			Ticker.tick(2000,function ():void{
				addListeners();
			});
		}
		
		private function addListeners():void
		{
			//礼物消息
			this._e.listen(SEvents.STAGE_DUANG,onGiftMsg);
		}
		
		private function onGiftMsg(data:Object):void
		{
			if(this.module)
				this.module["showGift"]({"data":data});
		}
	}
}