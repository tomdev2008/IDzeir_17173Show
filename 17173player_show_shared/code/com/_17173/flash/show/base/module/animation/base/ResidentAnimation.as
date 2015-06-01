package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.show.base.context.resource.IResourceData;

	/**
	 *常驻动画，不停播放，不能自动回收 
	 * @author zhaoqinghao
	 * 
	 */	
	public class ResidentAnimation extends AnimationObject
	{
		public function ResidentAnimation()
		{
			super();
		}
		
		//加载完即自动播放
		override public function loadCmp(data:IResourceData):void
		{
			super.loadCmp(data);
			if(data != null && data.source != null){
				play();
			}
			
		}
	}
}