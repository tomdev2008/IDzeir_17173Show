package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class FlowerMiniAnimation extends AnimationPlay
	{
		public function FlowerMiniAnimation()
		{
			super();
		}
		override protected function otherAction():void{
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showInfoMc") && tmc.showInfoMc != null){
				var showInfo:MovieClip = tmc.showInfoMc as MovieClip;
				var tf1:TextField;
				var tmpTf:TextField;
				if(showInfo.sLabel){
					tmpTf = showInfo.sLabel as TextField;
					tmpTf.height = 19;
					tmpTf.htmlText = getSName();
				}
				if(showInfo.gLabel){
					tmpTf = showInfo.gLabel as TextField;
					tmpTf.htmlText = getTName();
				}
			}
		}
		
		override public function loadCmp(data:IResourceData):void{
			try{
				if(data != null){
					_loadFail = false;
					_loaded = true;
					_mc = data.source;
					_mc.mouseChildren = false;
					_mc.mouseEnabled = false;
					if(_onLoadCallBack != null){
						_onLoadCallBack()
					}
				}else{
					_loading = false;
					Debugger.log(Debugger.ERROR, "[FlowerMini]", "加载错误:", _url);
					_loadFail = true;	
					_loaded = true;
					if(_onLoadCallBack != null){
						_onLoadCallBack()
					}
				}
			}catch(e:Error){
				Debugger.log(Debugger.ERROR, "[FlowerMini]", "数据配错误率好吗！", _url);
				_loading = false;
				Debugger.log(Debugger.ERROR, "[FlowerMini]", "加载错误:", _url);
				_loadFail = true;	
				_loaded = true;
				if(_onLoadCallBack != null){
					_onLoadCallBack()
				}
			}
			
		}
		
		private function getSName():String{
			return Utils.formatToHtml(data.sName) ;
		}
		
		private function getTName():String{
			return data.sNo;
		}
		
		override public function toStopEnd():void{
			//			Debugger.log(Debugger.INFO, "[FlowerMini]", "停止动画: " + url,"动画对象：",_mc);
			if(_mc){
				_mc.gotoAndStop(_mc.totalFrames);
				stopChild1(_mc);
				otherAction();
			}
		}
		
		protected function stopChild1(mc:MovieClip):void{
			mc.stop();
			mc.gotoAndStop(mc.totalFrames);
			if(mc.getChildAt(0) is MovieClip){
				stopChild1(mc.getChildAt(0) as MovieClip)
			}
		}
	}
}