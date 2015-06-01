package
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	/**
	 * 负责对站内播放器文件的加载.
	 * 测速并提供码率.
	 *  
	 * @author 安庆航
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class PreloaderFile extends BasePreloader
	{
		
		private var _loadTime:int = 0;
		private var _progressTime:int = 0;
		private var _t:int = 0;
//		private var _h:int = 0;
//		private var _l:int = int.MAX_VALUE;
		private var _bytesLoadedBase:int = 0;
		
		public function PreloaderFile()
		{
			super();
		}
		
		override protected function prepareConfig():void {
			super.prepareConfig();
			
			_conf.url = "Player_file.swf";
		}
		
		override protected function startLoad(url:String):void {
			super.startLoad(url);
			
			if (_loader) {
				_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadInit);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			}
		}
		
		protected function onLoadInit(event:Event):void {
			_progressTime = _loadTime = getTimer();
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoadInit);
		}
		
		protected function onProgress(event:ProgressEvent):void {
			var tt:int = getTimer();
			_t = (event.bytesLoaded - _bytesLoadedBase) / 1024 / ((tt - _progressTime) / 1000);
			_progressTime = tt;
			_bytesLoadedBase = event.bytesLoaded;
//			if (_t > _h) {
//				_h = _t;
//			}
//			if (_l > _t && _t != 0) {
//				_l = _t;
//			}
		}
		
		override protected function onSwfLoaded(event:Event):void {
			_conf.speed = updateLoadSpeed();
			
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onLoadInit);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			super.onSwfLoaded(event);
		}
		
		protected function updateLoadSpeed():int {
			var time:int = getTimer() - _loadTime;
			if(time == 0) {
				time = 1;
			}
			return _loader.contentLoaderInfo.bytesTotal / (time / 1000) / 1024;
		}
		
	}
}