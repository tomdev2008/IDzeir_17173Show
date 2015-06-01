package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class CocktailAndChampagneDelegate extends BaseModuleDelegate
	{
		public function CocktailAndChampagneDelegate()
		{
			super();
			_e.listen(SEvents.GIFT_CAC_ANIMATION,function(value:Object):void{
				excute(addGiftAmt,value);});
		}
		
		private function addGiftAmt(data:Object):void{
			_swf["addGiftAmt"](data);
		}
	}
}