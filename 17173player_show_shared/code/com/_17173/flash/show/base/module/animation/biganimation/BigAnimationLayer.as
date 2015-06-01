package com._17173.flash.show.base.module.animation.biganimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimactionLayer;
	

	/**
	 *动画播放层级 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BigAnimationLayer extends BaseAnimationLayer implements IAnimactionLayer
	{
		public function BigAnimationLayer()
		{
			super();
		}
		/**
		 *添加动画 
		 * @param aData
		 * 
		 */		
		override public function addAnimation(aData:AnimationObject):void{
			var type:String = aData.type;
			switch(type)
			{
				case AnimationType.ATYPE_CAR:
				{
				
					break;
				}
				case AnimationType.ATYPE_FLOWER:
				{
					aData.mc.x = -1920/2;
					aData.mc.y = -1000/2;
					break;
				}
				case AnimationType.ATYPE_TUZI:
				{
					aData.mc.x = -300;
					aData.mc.y = -200;
					break;
				}
				case AnimationType.ATYPE_TECH:
				{
					aData.mc.x = -200;
					aData.mc.y = -170;
					break;
				}
			}
			this.addChild(aData.mc);
		}
	}
}