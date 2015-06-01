package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 *活动类，三个title的通用动画 
	 * @author zhaoqinghao
	 * 
	 */	
	public class Activity_ThreeTitleNormalAnimation extends AnimationPlay
	{
		public function Activity_ThreeTitleNormalAnimation()
		{
			super();
		}
		
		override protected function otherAction():void{
			if(_actionOk) return;
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showInfoMc") && tmc.showInfoMc != null){
				var tf1:TextField;
				var tmpTf:TextField;
				var nameMc:MovieClip = mc.showInfoMc
				if(nameMc.sLabel){
					tmpTf = nameMc.sLabel as TextField;
					tmpTf.htmlText = getSName();
				}
				if(nameMc.gLabel){
					tmpTf = nameMc.gLabel as TextField;
					tmpTf.htmlText = getGName();
				}
				if(nameMc.bLabel){
					tmpTf = nameMc.bLabel as TextField;
					tmpTf.htmlText = getTName();
				}
			}
		}
		
		private function getSName():String{
			var str:String = "[" +  Utils.formatToHtml(_data.sName) + "]";
			return str;
		}
		
		private function getGName():String{
			var str:String = "为  "  + _data.tName + "   ";
			return str;
		}
		
		private function getTName():String{
			var str:String = "点燃 [" + Utils.formatToHtml(_data.giftName) + "]";
			return str;
		}
	}
}