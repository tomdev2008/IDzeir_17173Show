package com._17173.flash.show.base.module.animation.base
{
	public interface IAnimactionLayer
	{
		/**
		 *添加动画 
		 * @param aData
		 * 
		 */		
		function addAnimation(aData:AnimationObject):void;
		/**
		 *移除动画
		 */
		function removeAnimation(adata:AnimationObject):void;
	}
}