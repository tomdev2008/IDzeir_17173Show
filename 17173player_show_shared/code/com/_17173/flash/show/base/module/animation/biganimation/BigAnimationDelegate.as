package com._17173.flash.show.base.module.animation.biganimation
{
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
			_e.listen(SEvents.GIFT_ANIMATION,onShowAnimation);
		}
		
		private function onShowAnimation(data:Object):void{
			//判断如果类型对就展示大动画
			var type:int = data.giftType;
			if(type == 2 || type == 0){
				_e.send(SEvents.GIFT_BIG_ANIMATION,data);
			}
		}
		
		private function removeLsn():void{
			_e.remove(SEvents.GIFT_ANIMATION,onShowAnimation);
		}
		
		override protected function onUnload():void{
			removeLsn();
		}
	}
}