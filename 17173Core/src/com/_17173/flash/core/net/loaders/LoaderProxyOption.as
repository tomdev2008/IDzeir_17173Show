package com._17173.flash.core.net.loaders
{
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	/**
	 * LoaderProxy的加载配置类.
	 *  
	 * @author shunia-17173
	 */	
	public class LoaderProxyOption
	{
		public static const FORMAT_BINARY:String = "binary";
		public static const FORMAT_JSON:String = "json";
		public static const FORMAT_XML:String = "xml";
		public static const FORMAT_TEXT:String = "text";
		public static const FORMAT_IMAGE:String = "image";
		public static const FORMAT_SWF:String = "swf";
		public static const FORMAT_VARIABLES:String = "variables";
		
		public static const TYPE_ASSET_LOADER:String = "asset_loader";
		public static const TYPE_FILE_LOADER:String = "file_loader";
		
		private var _url:String = null;
		private var _format:String = null;
		private var _type:String = null;
		
		private var _onAvaliable:Function = null;
		private var _onSuccess:Function = null;
		private var _onFault:Function = null;
		
		private var _manuallyResolver:Class = null;
		private var _isGET:Boolean = true;
		private var _allowSecurityCheck:Boolean = true;
		private var _data:Object = null;
		private var _useLoader:Boolean = false;
		
		public function LoaderProxyOption(
			url:String = null, 
			format:String = null, 
			type:String = null, 
			onSuccess:Function = null, 
			onFault:Function = null, 
			onAvaliable:Function = null)
		{
			_url = _url && url == null ? _url : url;
			_format = _format && format == null ? _format : format;
			_type = _type && type == null ? _type : type;
			_onSuccess = _onSuccess != null && onSuccess == null ? _onSuccess : onSuccess;
			_onFault = _onFault != null && onFault == null ? _onFault : onFault;
			_onAvaliable = _onAvaliable != null && onAvaliable == null ? _onAvaliable : onAvaliable;
		}
		
		/**
		 * 加载器的类型.如果是加载显示对象类的,使用TYPE_ASSET_LOADER.
		 * 否则全部当做文件/数据进行加载,使用TYPE_FILE_LOADER.
		 *  
		 * @return 
		 */		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(value:String):void
		{
			_type = value;
		}
		
		/**
		 * 数据类型.即请求返回的数据或文件的格式.
		 *  
		 * @return 
		 */		
		public function get format():String
		{
			return _format;
		}
		
		public function set format(value:String):void
		{
			_format = value;
		}
		
		/**
		 * 请求的url地址
		 *  
		 * @return 
		 */		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		/**
		 * 请求为可用状态时回调.
		 *  
		 * @param value
		 */		
		public function set onAvaliable(value:Function):void
		{
			_onAvaliable = value;
		}
		
		public function get onAvaliable():Function {
			return _onAvaliable;
		}
		
		/**
		 * 请求成功的回调.
		 *  
		 * @param value
		 */		
		public function set onSuccess(value:Function):void
		{
			_onSuccess = value;
		}
		
		public function get onSuccess():Function {
			return _onSuccess;
		}
		
		/**
		 * 请求失败的回调
		 *  
		 * @param value
		 */		
		public function set onFault(value:Function):void
		{
			_onFault = value;
		}
		
		public function get onFault():Function {
			return _onFault;
		}
		
		/**
		 * 返回数据解析器.
		 * 当数据请求成功返回时,如果设置了此解析器,将会用此解析器将数据进行处理后再通过成功回调函数进行返回.
		 * 此解析器需实现IManuallyResolver接口. 
		 * 
		 * @param value
		 */		
		public function set manuallyResolver(value:Class):void
		{
			_manuallyResolver = value;
		}
		
		public function get manuallyResolver():Class {
			return _manuallyResolver;
		}
		
		/**
		 * 是否是get请求,false时将会当做post发出.
		 *  
		 * @return 
		 */		
		public function get isGET():Boolean
		{
			return _isGET;
		}
		
		public function set isGET(value:Boolean):void
		{
			_isGET = value;
		}
		
		/**
		 * 是否需要检测crossdomain文件.
		 *  
		 * @return 
		 */		
		public function get allowSecurityCheck():Boolean
		{
			return _allowSecurityCheck;
		}
		
		public function set allowSecurityCheck(value:Boolean):void
		{
			_allowSecurityCheck = value;
		}
		
		/**
		 * Post或get时需要附加的数据.
		 *  
		 * @return 
		 */		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		/**
		 * @private
		 */		
		public function get useLoader():Boolean
		{
			return _useLoader;
		}
		
		/**
		 * 设置是否直接使用loader返回.当且仅当使用 TYPE_ASSET_LOADER 时此属性才有效. 
		 * @param value
		 */		
		public function set useLoader(value:Boolean):void
		{
			_useLoader = value;
		}
		
		////////////////////////////
		//
		//	internal方法
		//
		///////////////////////////
		
		/**
		 * 获取当前属性所产生的loader的包,用以提供给LoaderProxy进行解析并处理.
		 *  
		 * @return 
		 */		
		internal function getLoader():Object {
			//验证属性是否完整
			//TO-DO
			if (_type == LoaderProxyOption.TYPE_ASSET_LOADER) {
				return makeAssetLoader();
			} else {
				return makeFileLoader();
			}
		}
		
		internal function makeAssetLoader():Object {
			var loader:Loader = new Loader();
			var req:URLRequest = new URLRequest(_url);
			return {
				"loader" : loader, 
				"handler" : loader.contentLoaderInfo, 
				"request" : req, 
				"key" : _useLoader ? "" : "content" 		//去掉content,直接返回loader
			};
		}
		
		internal function makeFileLoader():Object {
			var loader:URLLoader = new URLLoader();
			var req:URLRequest = new URLRequest(_url);
			if (!_isGET) {
				req.method = URLRequestMethod.POST;
			} else {
				req.method = URLRequestMethod.GET;
			}
			req.data = _data;
			if (_format == LoaderProxyOption.FORMAT_BINARY) {
				req.contentType = URLLoaderDataFormat.BINARY;
			} else if (_format == LoaderProxyOption.FORMAT_VARIABLES) {
				req.contentType = URLLoaderDataFormat.VARIABLES;
			} else if (_format == LoaderProxyOption.FORMAT_JSON || _format == LoaderProxyOption.FORMAT_XML || _format == LoaderProxyOption.FORMAT_TEXT) {
				req.contentType = URLLoaderDataFormat.TEXT;
			}
			return {
				"loader" : loader, 
				"handler" : loader, 
				"request" : req, 
				"key" : "data"
			};
		}
		
	}
}