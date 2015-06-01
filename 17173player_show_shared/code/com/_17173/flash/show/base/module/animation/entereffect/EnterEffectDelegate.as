package com._17173.flash.show.base.module.animation.entereffect
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class EnterEffectDelegate extends BaseModuleDelegate
	{
		public function EnterEffectDelegate()
		{
			super();
			initLsn();
		}
		
		
		private function initLsn():void{
			_e.listen(SEvents.GIFT_BIG_ENTER,function(value:Object):void{
				excute(onGiftAmt,value);});
			_e.listen(SEvents.GIFT_EFFECT_CLOSE,function(value:Object):void{
				excute(onEffectClose,value);});
			_e.listen(SEvents.GIFT_EFFECT_OPEN,function(value:Object):void{
				excute(onEffectOpen,value);});
		}
		
		private function removeLsn():void{
			_e.remove(SEvents.GIFT_BIG_ENTER,onGiftAmt);
			_e.remove(SEvents.GIFT_EFFECT_CLOSE,onEffectClose);
			_e.remove(SEvents.GIFT_EFFECT_OPEN,onEffectOpen);
		}
		
		
		public function onGiftAmt(data:Object):void{
			_swf["addGiftAmt"](data);
		} 
		
		public function onEffectClose(data:Object = null):void{
			_swf["onEffectClose"](data);
		}
		
		public function onEffectOpen(data:Object = null):void{
			_swf["onEffectOpen"](data);
		}
	}
}