package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.utils.getTimer;
	
	/**
	 * 负责对播放器文件的加载.
	 * 测速并提供码率.
	 *  
	 * @author shunia.huang
	 */	
	[SWF(backgroundColor="0xFF9900", frameRate="30")]
	public class Preloader extends Sprite
	{
		
		private var _loadTime:int = 0;
		private var _progressTime:int = 0;
		private var _interval:uint = 0;
		private var _t:int = 0;
		private var _h:int = 0;
		private var _l:int = int.MAX_VALUE;
		private var _e:int = 0;
		private var _bytesLoadedBase:int = 0;
		private var _bitrate:int = 0;
		private var _mainSwf:Object = null;
		
		private var _loader:Loader = null;
		
		public function Preloader()
		{
			//检测舞台
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		protected function init(e:Event = null):void {
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			var type:int = stage.loaderInfo.parameters["type"];
			
			var url:String = "Player_file.swf";
			if (type == 1) {
//				url = "http://loc.v.17173.com/flash/Player_file.swf";
				url = getFlashUrl() + "Player_file.swf";
			} else if (type == 2) {
				url = getFlashUrl() + "Player_stream.swf";
			}
			if (url) {
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadInit);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoaded);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
				_loader.load(new URLRequest(url), new LoaderContext(true, ApplicationDomain.currentDomain));
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
			if (_t > _h) {
				_h = _t;
			}
			if (_l > _t && _t != 0) {
				_l = _t;
			}
		}
		
		protected function onSwfLoaded(event:Event):void {
			var time:int = getTimer() - _loadTime;
			_e = _loader.contentLoaderInfo.bytesTotal / (time / 1000) / 1024;
			_mainSwf = _loader.content;
			_mainSwf["speed"] = _e;
			addChild(_loader.content);
			
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfLoaded);
			_loader.unload();
		}
		
		private function getFlashUrl():String
		{
			var ref:String = stage.loaderInfo.loaderURL;
			if (validateStr(ref) == false) {
				ref = "";
			} else {
				ref = ref.substring(0, ref.lastIndexOf("/"));
			}
			return ref;
		}
		
		public function validateStr(s:String):Boolean {
			return s != null && s.replace(" ", "") != "";
		}
	}
}