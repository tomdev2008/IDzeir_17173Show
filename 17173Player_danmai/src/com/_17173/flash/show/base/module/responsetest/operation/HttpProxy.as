package com._17173.flash.show.base.module.responsetest.operation
{
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class HttpProxy
	{
		private var _loader:URLLoader;	
		private var _httpStatusHandler:Function;
		private var _ioErrorHandler:Function;
		
		public function HttpProxy()
		{
			
		}
		
		public function start(url:String,httpStatusHandler:Function,ioErrorHandler:Function):void
		{
			_httpStatusHandler = httpStatusHandler;
			_ioErrorHandler = ioErrorHandler;
			//添加监听器
			_loader = new URLLoader();
			configureListeners(_loader);
			var request:URLRequest = new URLRequest(url);
			try {
				_loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, _httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, _ioErrorHandler);
		}
	}
}