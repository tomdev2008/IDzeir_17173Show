package
{

	/**
	 * 负责对站外播放器文件的加载.
	 * 测速并提供码率.
	 *  
	 * @author 安庆航
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class PreloaderFileCustomer extends PreloaderFile
	{
		public function PreloaderFileCustomer()
		{
			super();
			trace("");
		}
		
		override protected function prepareConfig():void {
			super.prepareConfig();
			_conf.url = "Player_file_customOut.swf";
		}
	}
}