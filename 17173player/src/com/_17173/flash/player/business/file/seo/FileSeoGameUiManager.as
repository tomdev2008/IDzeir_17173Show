package com._17173.flash.player.business.file.seo
{
	import com._17173.flash.player.ui.file.FileBackRecommend;
	import com._17173.flash.player.ui.file.seo.FileBackRecommendSeo;

	public class FileSeoGameUiManager extends FileSeoVideoUIManager
	{
		public function FileSeoGameUiManager()
		{
			super();
			_("backRecTitleColor", "0x0697cc");
		}
		
		override protected function get backRecommend():FileBackRecommend {
			return new FileBackRecommendSeo();
		}
		
	}
}