package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.show.base.components.common.BitmapAnim;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;

	/**
	 *香槟鸡尾酒小动画类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class CACAnimation extends AnimationPlay
	{
		
		public function CACAnimation()
		{
			super();
		}
		override public function run():void
		{
			if(checkFrame(mc)){
				playEnd();
			}
		}
		
		
		override public function loadCmp(data:IResourceData):void
		{
			
			if(data != null && data.source != null){
				_loadFail = false;
				_loaded = true;
				var resouce:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
				var mc:MovieClip = data.newSource;
				resouce.addAnimDatas4Mc(data.key,mc);
				_mc = new BitmapAnim();
				_mc.data = resouce.getAnimDatas(data.key);
				_mc.x = mcX;
				_mc.y = mcY;
				_mc.mouseChildren = false;
				_mc.mouseEnabled = false;
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
				play();
			}else{
				_loading = false;
				_loadFail = true;	
				_loaded = true;
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}
			
			
		}
		
		/**
		 *检测是否播放完 
		 * @param mc
		 * @return 
		 * 
		 */		
		override protected function checkFrame(mc:*):Boolean{
			if(mc.frame == mc.totalFrame-1){
				stopChild(mc);
				return true;
			}
			otherAction();
			return false;
		}
		
		override protected function stopChild(mc:*):void{
			mc.stop();
		}
		
		override protected function startChild(mc:*):void{
			mc.gotoAndPlay(0);
		}
		
		override protected function returnSelfPool():void{
			//返回池
			SimpleObjectPool.getPool(CACAnimation).returnObject(this);
		}
		
		override public function returnObj():void{
			_mc = null;
			_loaded = false;
			_loadFail = false;
			_url = null;
			_ttFrame = 0;
			_data = null;
			_type = null;
			_onLoadCallBack = null;
			_actionOk = false;
			returned = true;
			data = null;
			returnSelfPool();
			mcX = 0;
			mcY = 0;
			
		}
	}
}