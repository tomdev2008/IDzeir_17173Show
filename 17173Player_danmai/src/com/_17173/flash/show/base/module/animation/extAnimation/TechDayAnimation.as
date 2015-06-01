package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 *双节礼物效果 
	 * @author zhaoqinghao
	 * 
	 */	
	public class TechDayAnimation extends AnimationPlay
	{
		/**
		 *双节礼物效果 
		 * @author zhaoqinghao
		 * 
		 */	
		public function TechDayAnimation()
		{
			super();
		}
		
		override protected function otherAction():void{
			if(_actionOk) return;
			var tmc:MovieClip = _mc as MovieClip;
			var tmpTf:TextField;
			if(tmc.hasOwnProperty("sLabel") && tmc.sLabel){
				tmpTf = tmc.sLabel as TextField;
				tmpTf.htmlText = getTName();//名字
			}
			if(tmc.hasOwnProperty("fLabel") &&tmc.fLabel){
				tmpTf = tmc.fLabel as TextField;
				tmpTf.htmlText = getCName();//数量
			}
		}
		
		private function getTName():String{
			var str:String = "" + Utils.formatToHtml(_data.sName) + "";
			return str;
		}
		
		private function getCName():String{
			var str:String = "收到" + "" + Utils.formatToHtml(_data.giftCount) + "个"+ _data.giftName + "";
			return str;
		}
	}
}