package com._17173.flash.player.business.file.seo
{
	import com._17173.flash.player.business.file.FileUIManager;
	import com._17173.flash.player.ui.comps.PTSeoVideo;
	import com._17173.flash.player.ui.file.FileBackRecommend;
	import com._17173.flash.player.ui.file.seo.FileBackRecommendSeo;
	
	public class FileSeoVideoUIManager extends FileUIManager
	{
		public function FileSeoVideoUIManager()
		{
			super();
			_("backRecTitleColor", "0xd83727");
		}
		
		override public function showPT():void {
			if (_pt == null) {
				_pt = new PTSeoVideo();
			}
			_ptLayer.popup(_pt, null, true);
		}
		
		override protected function get backRecommend():FileBackRecommend {
			return new FileBackRecommendSeo();
		}
		
	}
}