package com._17173.flash.show.base.module.animation.base
{
	import flash.display.Sprite;
	
	public class BaseAnimationLayer extends Sprite implements IAnimactionLayer
	{
		public function BaseAnimationLayer()
		{
			super();
			mouseChildren = false;
			mouseEnabled = false;
		}
		
		public function addAnimation(aData:AnimationObject):void
		{
			this.addChild(aData.mc);
		}
		
		public function removeAnimation(adata:AnimationObject):void
		{
			if(this.contains(adata.mc)){
				this.removeChild(adata.mc);
			}
		}
	}
}