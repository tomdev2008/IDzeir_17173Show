package com._17173.flash.show.base.module.animation.flowermini
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class FlowerMiniDelegate extends BaseModuleDelegate
	{
		public function FlowerMiniDelegate()
		{
			super();
			_e.listen(SEvents.GIFT_FLOWER_MINI,function(value:Object):void{
				excute(addGiftAmt,value);});
			_e.listen(SEvents.GIFT_ANIMATION_HX,function(value:Object):void{
				excute(addExtFlow,value);});
		}
		
		private function addGiftAmt(data:Object):void{
			_swf["addGiftAmt"](data);
		}
		
		private function addExtFlow(data:Object):void{
			_swf["addExtFlow"](data);
		}
	}
}