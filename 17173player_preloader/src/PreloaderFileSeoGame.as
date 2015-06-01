package
{
	public class PreloaderFileSeoGame extends PreloaderFile
	{
		public function PreloaderFileSeoGame()
		{
			super();
		}
		
		override protected function prepareConfig():void {
			super.prepareConfig();
			
			_conf.url = "Player_seo_game.swf";
		}
		
	}
}