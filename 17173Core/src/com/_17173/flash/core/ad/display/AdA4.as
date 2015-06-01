package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;

	/**
	 * 下底广告 
	 * @author shunia-17173
	 */	
	public class AdA4 extends BaseAdDisplay
	{
		
		private static const W:int = 235;
		private static const H:int = 20;
		
		public function AdA4()
		{
			super();
		}
		
		override public function resize(w:Number, h:Number):void {
			super.resize(W, H);
		}
		
//		override protected function addBack(w:Number, h:Number):void{
//			
//		}
		
		override protected function onAdComplete():void {
			super.onAdComplete();
		}
		
		override protected function resizeAd():void {
			super.resizeAd();
		}
		
	}
}