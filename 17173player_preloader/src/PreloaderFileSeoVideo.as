package
{
	public class PreloaderFileSeoVideo extends PreloaderFile
	{
		public function PreloaderFileSeoVideo()
		{
			super();
		}
		
		override protected function prepareConfig():void {
			super.prepareConfig();
			
			_conf.url = "Player_seo_video.swf";
		}
	}
}