package com._17173.flash.player.ui.file.seo
{
	import com._17173.flash.player.ui.file.BackRecommendSmall;
	/**
	 * 后推荐第三级推荐 seo video
	 * @author anqinghang
	 * 
	 */	
	public class BackRecommendSmallSeo extends BackRecommendSmall
	{
		public function BackRecommendSmallSeo(width:Number, height:Number)
		{
			super(width, height);
		}
		
		override protected function addCenter():void {
			_center = new mc_backRec_small_replay();
			addChild(_center);
		}
		
	}
}