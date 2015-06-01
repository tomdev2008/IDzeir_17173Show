package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 *进场动画 
	 * @author zhaoqinghao
	 * 
	 */	
	public class EnterAnimation extends AnimationObject
	{
		public function EnterAnimation()
		{
			super();
		}
		
		override protected function otherAction():void{
			if(_actionOk) return;
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showInfoMc") && tmc.showInfoMc != null){
				var tmpTf:TextField;
				var showInfo:MovieClip = tmc.showInfoMc;
				if(showInfo && showInfo.sLabel){
					_actionOk = true;
					if(showInfo.sLabel){
						tmpTf = showInfo.sLabel as TextField;
						tmpTf.htmlText = getTName();
					}
					if(showInfo.fLabel){
						tmpTf = showInfo.fLabel as TextField;
						tmpTf.htmlText = getTName();
					}
				}
			}
		}
		
		private function getTName():String{
			var str:String = "" + Utils.formatToHtml(_data.sName) + "";
			return str;
		}
	}
}