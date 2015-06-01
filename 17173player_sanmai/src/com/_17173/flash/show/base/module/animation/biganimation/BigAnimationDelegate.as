package com._17173.flash.show.base.module.animation.biganimation
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class BigAnimationDelegate extends BaseModuleDelegate
	{
		public function BigAnimationDelegate()
		{
			super();
			initLsn();
		}
		
		private function initLsn():void{
			_e.listen(SEvents.GIFT_BIG_ANIMATION,addGiftAmt);
		}
		
		
		private function addGiftAmt(data:Object):void{
			try
			{
				_swf["addGiftAmt"](data);
			}catch (e:Error){
				Debugger.log(Debugger.WARNING,"[BigAnimationDelegate]","礼物数据配置有问题");
			}
		}
		
	}
}