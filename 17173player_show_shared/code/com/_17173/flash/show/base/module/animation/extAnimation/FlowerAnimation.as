package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationObject;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class FlowerAnimation extends AnimationObject
	{
		public function FlowerAnimation()
		{
			super();
		}
		
		override protected function otherAction():void{
			if(_actionOk) return;
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showInfoMc") && tmc.showInfoMc != null){
				_actionOk = true;
				var tf1:TextField;
				var tmpTf:TextField;
				if(tmc.showInfoMc && tmc.showInfoMc.nameMc){
					var nameMc:MovieClip = tmc.showInfoMc.nameMc;
					if(nameMc.sLabel){
						tmpTf = nameMc.sLabel as TextField;
						tmpTf.htmlText = getSName();
					}
					if(nameMc.gLabel){
						tmpTf = nameMc.gLabel as TextField;
						tmpTf.htmlText = getGName();
					}
					if(nameMc.tLabel){
						tmpTf = nameMc.tLabel as TextField;
						tmpTf.htmlText = getTName();
					}
				}
			}
		}
		
		private function getSName():String{
			var str:String = "[" +  Utils.formatToHtml(_data.sName) + "]";
			return str;
		}
		
		private function getGName():String{
			var str:String = "赠送   "  + _data.giftName + "   给";
			return str;
		}
		
		private function getTName():String{
			var str:String = "[" + Utils.formatToHtml(_data.tName) + "]";
			return str;
		}
		
	}
}