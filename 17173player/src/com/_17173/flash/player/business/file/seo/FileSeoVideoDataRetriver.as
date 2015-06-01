package com._17173.flash.player.business.file.seo
{
	import com._17173.flash.player.business.file.FileDataRetriver;
	
	public class FileSeoVideoDataRetriver extends FileDataRetriver
	{
		public function FileSeoVideoDataRetriver()
		{
			super();
		}
		
		override protected function getMoreUrl(id:String):String {
			return MOREPATH_URL.replace("{0}", id) +　"/from/videoGame";
		}
		
		override protected function getAddPlayNumberUrl(cid:String):String {
			return "http://v.17173.com/api/videoPlayNum/AddZqPlayNum/id/" + cid + "/from/videoGame";
		}
		
	}
}