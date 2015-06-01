package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class Double11Act extends AnimationPlay
	{
		public function Double11Act()
		{
			super();
		}
		
		override protected function otherAction():void{
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showInfo") && tmc.showInfo != null){
				var tmpTf:TextField;
				var showInfo:MovieClip = tmc.showInfo;
				if(showInfo && showInfo.sLabel){
					if(showInfo.sLabel){
						tmpTf = showInfo.sLabel as TextField;
						tmpTf.htmlText = getTName();//名字
					}
					if(showInfo.gLabel){
						tmpTf = showInfo.gLabel as TextField;
						tmpTf.htmlText = getGname();//礼物
					}
					if(showInfo.cLabel){
						tmpTf = showInfo.cLabel as TextField;
						tmpTf.htmlText = getCName();//数量
					}
				}
			}
		}
		
		private function getTName():String{
			return  data.sName ;
		}
		
		private function getCName():String{
			return data.giftNum;
		}
		
		private function getGname():String{
			return data.giftName;
		}
		
	}
}