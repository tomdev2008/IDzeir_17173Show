package
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	/**
	 * 负责对站外播放器文件的加载.
	 * 测速并提供码率.
	 *  
	 * @author 安庆航
	 */	
	[SWF(backgroundColor="0x000000", frameRate="30")]
	public class PreloaderFileFirstpage extends PreloaderFile
	{
		private var _loader:URLLoader;
		private var _version:String;
		//获取当前服务器的版本号
		private var _getVersion:Boolean;
		
		public function PreloaderFileFirstpage()
		{
			getUrlVerson();
			super();
		}
		
		override protected function prepareConfig():void {
			super.prepareConfig();
			
			_conf.url = "Player_file_out.swf";
		}
		
		/**
		 * 获取当前服务器的版本号
		 */		
		private function getUrlVerson():void {
			_loader = new URLLoader();
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			_loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securtyErrorHandler);
			var request:URLRequest = new URLRequest("http://v.17173.com/japi/getStatVersion?t=" + new Date().time);
			
			try {
				_loader.load(request);
			}
			catch (error:Error) {
				_version = "";
				_getVersion = true;
			}
		}
		
		protected function securtyErrorHandler(event:SecurityErrorEvent):void
		{
			_getVersion = true;
			_version = "";
		}
		
		protected function loaderCompleteHandler(evt:Event):void
		{
			_getVersion = true;
			var temp:Object = JSON.parse(_loader.data);
			if (temp.hasOwnProperty("version")) {
				_version = temp["version"];
			}
		}
		
		protected function errorHandler(evt:IOErrorEvent):void
		{
			_getVersion = true;
			_version = "";
		}
		
		override protected function startLoad(url:String):void {
			if (!_getVersion) {
				setTimeout(startLoad, 200, url);
			} else {
				if (!_version || _version == "") {
					
				} else {
					url = getUrl();
				}
				super.startLoad(url);
			}
		}
		
		/**
		 * 重新封装url，服务器版本号
		 */		
		private function getUrl():String {
			var temp:String = getFlashUrl();
			var tempArr:Array = temp.split("/");
			var re:String = "";
			for (var i:int = 0; i < tempArr.length; i++) {
				if (i == tempArr.length - 2) {
					re += _version + "/";
				}
				re += tempArr[i] + "/";
			}
			re = re.substring(0, re.lastIndexOf("/"));
			return re + _conf.url;
		}
	}
}