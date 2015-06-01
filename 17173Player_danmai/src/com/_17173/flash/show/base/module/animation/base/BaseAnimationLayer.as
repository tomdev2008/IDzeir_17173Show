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
		
		public function addAnimation(aData:IAnimationPlay):void
		{
			if(aData.bgEffect){
				this.addChild(aData.bgEffect);
			}
			if(aData.mc){
				this.addChild(aData.mc);
			}
			if(aData.bfEffect){
				this.addChild(aData.bfEffect);
			}
		}
		
		public function removeAnimation(adata:IAnimationPlay):void
		{
			if(adata.bgEffect && this.contains(adata.bgEffect)){
				this.removeChild(adata.bgEffect);
			}
			if(this.contains(adata.mc)){
				this.removeChild(adata.mc);
			}
			if(adata.bfEffect && this.contains(adata.bfEffect)){
				this.removeChild(adata.bfEffect);
			}
		}
	}
}