package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.module.animation.base.AnimationType;
	import com._17173.flash.show.base.module.animation.base.SceneTips;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

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
			_mc.mouseChildren = false;
			_mc.mouseEnabled = true;
			_mc.buttonMode = true;
			this.mc.addEventListener(MouseEvent.ROLL_OVER,onOver);
			var ui:IUIManager = Context.getContext(CEnum.UI);
			ui.registerTip(this.mc,SceneTips.tip);
			this.mc.addEventListener(MouseEvent.CLICK,onClick);
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
		
		public function onClick(e:MouseEvent):void{
			var ui:IUIManager = Context.getContext(CEnum.UI);
			ui.registerTip(this.mc,SceneTips.tip);
		}
		
	    public function onOver(e:MouseEvent):void{
//			this.mc.addEventListener(MouseEvent.ROLL_OUT,onOut);
			var ui:IUIManager = Context.getContext(CEnum.UI);
			ui.registerTip(this.mc,SceneTips.tip);
		}
//		
//		public function onOut(e:MouseEvent):void{
//			this.mc.removeEventListener(MouseEvent.ROLL_OUT,onOut);
//		}
	}
}