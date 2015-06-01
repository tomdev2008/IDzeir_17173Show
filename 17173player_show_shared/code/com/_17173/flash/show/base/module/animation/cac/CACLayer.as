package com._17173.flash.show.base.module.animation.cac
{
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.extAnimation.CACAnimation;
	
	import flash.geom.Point;

	/**
	 *香槟鸡尾酒布局管理 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CACLayer extends BaseAnimationLayer
	{
		public function CACLayer()
		{
			super();
		}
		
		
		public function setupPostion(datas:Array):void{
			var post:Array = CACConfig.getInstans().pots.slice();
			var count:int = 0;
			var rand:int = 0;
			var tmpPot:Point;
			var amo:CACAnimation;
			while(count < datas.length){
				amo = datas[count] as CACAnimation;
				rand = Math.floor((Math.random() * post.length));
				tmpPot = post.splice(rand,1)[0] as Point;
				amo.mcX = tmpPot.x;
				amo.mcY = tmpPot.y;
				count++;
			}
		}
	}
}