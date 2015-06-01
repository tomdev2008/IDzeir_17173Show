package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.show.base.context.resource.IResourceData;
	
	import flash.display.MovieClip;

	/**
	 *常驻动画，不停播放，不能自动回收 
	 * @author zhaoqinghao
	 * 
	 */	
	public class ResidentAnimation extends AnimationPlay
	{
		public function ResidentAnimation()
		{
			super();
		}
		
		
		override public function loadCmp(data:IResourceData):void
		{
			//加载完即自动播放
			super.loadCmp(data);
			if(data != null && data.source != null){
				play();
			}
		}
		
		override protected function checkFrame(mc:*):Boolean{
			if(mc == null) return false;
			//判断如果是最后一针暂停则停止
			if(data.effectEndType == AnimationType.SCENE_EFFECT_STOP){
				if(mc.currentFrame == mc.totalFrames ){
					(mc as MovieClip).stop();
				}
				otherAction();
			}else{
				otherAction();
			}
			return false;
		}
	}
}