package com._17173.flash.show.base.module.animation.base
{
	public interface IAnimactionLayer
	{
		/**
		 *添加动画 
		 * @param aData
		 * 
		 */		
		function addAnimation(aData:IAnimationPlay):void;
		/**
		 *移除动画
		 */
		function removeAnimation(adata:IAnimationPlay):void;
	}
}