package com._17173.flash.show.base.module.animation.extAnimation
{
	import com._17173.flash.show.base.module.animation.base.AnimationPlay;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ShowIconAnimation extends AnimationPlay
	{
		public function ShowIconAnimation()
		{
			super();
		}
		
		private var showIcon:MovieClip;
		override protected function otherAction():void{
			var tmc:MovieClip = _mc as MovieClip;
			if(tmc.hasOwnProperty("showIcon") && tmc.showIcon != null){
				var tmpTf:MovieClip = tmc.showIcon;
				if(showIcon != tmpTf){
					tmpTf.addChild(Utils.getURLGraphic(data.giftPicPath,true,40,40));
					showIcon = tmpTf;
				}
			}
			
			if(tmc.hasOwnProperty("sLabel") && tmc.sLabel != null){
				var tmp:TextField = tmc.sLabel as TextField;
				tmp.text = getSName();
			}
			if(tmc.hasOwnProperty("tLabel") && tmc.tLabel != null){
				var tmp1:TextField = tmc.tLabel as TextField;
				tmp1.text = getTName();
			}
		}
		private function getSName():String{
			var str:String =  Utils.formatToHtml(_data.sName) ;
			return str;
		}
		
		private function getTName():String{
			var str:String =  Utils.formatToHtml(_data.tName) ;
			return str;
		}
	}
}