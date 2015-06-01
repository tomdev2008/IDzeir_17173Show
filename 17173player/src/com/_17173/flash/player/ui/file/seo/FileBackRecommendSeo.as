package com._17173.flash.player.ui.file.seo
{
	import com._17173.flash.player.ui.file.FileBackRecommend;
	
	public class FileBackRecommendSeo extends FileBackRecommend
	{
		public function FileBackRecommendSeo()
		{
			super();
		}
		
		override protected function resizeBackRecommend(w:Number, h:Number):void {
			_backRecBig = new BackRecommendSeo(w, h);
			_backRecBig.resize();
			_backRecBig.setMoreInfo(_moreInfo, _moreLabel, _moreUrl);
			_backRecBig.x = ((_bg.width - w) / 2) < 0 ? 0: ((_bg.width - w) / 2);
			_backRecBig.y = (_bg.height - h) / 2;
			if (!this.contains(_backRecBig)) {
				addChild(_backRecBig);
			}
		}
		
		override protected function resizeBackRecommendSmall(w:Number, h:Number):void {
			_backRecSmall = new BackRecommendSmallSeo(w, h);
			_backRecSmall.resize();
			if (!this.contains(_backRecSmall)) {
				addChild(_backRecSmall);
			}
		}
		
		override protected function resizeBackRecommendMiddle(w:Number, h:Number):void {
			_backRecMiddle = new BackRecommendMiddleSeo(w, h);
			_backRecMiddle.resize();
			_backRecMiddle.setMoreInfo(_moreInfo, _moreLabel, _moreUrl);
			if (!this.contains(_backRecMiddle)) {
				addChild(_backRecMiddle);
			}
		}
		
	}
}