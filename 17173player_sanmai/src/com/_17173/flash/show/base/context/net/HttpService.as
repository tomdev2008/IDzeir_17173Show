package com._17173.flash.show.base.context.net
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.show.model.SError;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.model.SError;
	
	import flash.net.URLVariables;

	/**
	 * Http请求代理类.
	 *  
	 * @author shunia-17173
	 */	
	public class HttpService implements IHttpService
	{

		private var _enabled:Boolean = true;
		
		public function HttpService()
		{
		}
		
		public function getData(action:String, params:Object, onResult:Function, onFail:Function=null, skipErrorCheck:Boolean = false):void
		{
			if(!this._enabled)
			{
				SError.handleServerError({"code":"-000005"});
				return;
			}
			Debugger.log(Debugger.INFO, "[http]", "get请求：" + action + ", " + JSON.stringify(params));
			var v:URLVariables = null;
			if (params is URLVariables) {
				v = params as URLVariables;
			} else {
				v = new URLVariables();
				for (var key:String in params) {
					v[key] = params[key];
				}
			}
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = action;
			option.data = v;
			option.format = LoaderProxyOption.FORMAT_JSON;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.manuallyResolver = JSONResolver;
			option.onSuccess = function (data:Object):void {
				if (Context.variables["debug"]) {
					Debugger.log(Debugger.INFO, "[http]", "get请求返回：" + action + ", " + JSON.stringify(params));
					Debugger.log(Debugger.INFO, "[http]", "get请求返回：" + JSON.stringify(data));
				}
				if (data && data.hasOwnProperty("code") && data.code == "000000") {
					if(data.hasOwnProperty("obj")){
						var result:Object = data.obj;
						onResult(result);
					}else{
						onResult(data);
					}
				} else {
					if (onFail != null) {
						onFail(data);
					}
					if (!skipErrorCheck) {
						SError.handleServerError(data);
					}
				}
			};
			option.onFault = onFail;
			loader.load(option);
		}
		
		public function postData(action:String, data:Object, onResult:Function = null, onFail:Function=null, skipErrorCheck:Boolean = false):void
		{
			if(!this._enabled)
			{
				SError.handleServerError({"code":"-000005"});
				return;
			}
			Debugger.log(Debugger.INFO, "[http]", "post请求：" + action + ", " + JSON.stringify(data));
			var v:URLVariables = null;
			if (data is URLVariables) {
				v = data as URLVariables;
			} else {
				v = new URLVariables();
				for (var key:String in data) {
					v[key] = data[key];
				}
			}
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = action;
			option.data = v;
			option.isGET = false;
			option.format = LoaderProxyOption.FORMAT_JSON;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.manuallyResolver = JSONResolver;
			option.onSuccess = function (data:Object):void {
				if (Context.variables["debug"]) {
					Debugger.log(Debugger.INFO, "[http]", "post请求返回：" + action + ", " + JSON.stringify(data));
					Debugger.log(Debugger.INFO, "[http]", "post请求返回：" + JSON.stringify(data));
				}
				if (data && data.hasOwnProperty("code") && data.code == "000000") {
					var result:Object = data.obj;
					if(onResult!=null)onResult(result);
				} else {
					if (onFail != null) {
						onFail(data);
					}
					if (!skipErrorCheck) {
						SError.handleServerError(data);
					}
				}
			};
			option.onFault = onFail;
			loader.load(option);
		}
		
		public function getAsset(url:String, onResult:Function, onFail:Function = null):void {
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.onFault = onFail;
			option.type = LoaderProxyOption.TYPE_ASSET_LOADER;
			option.onSuccess = function (data:Object):void {
				if (data && data.hasOwnProperty("content")) {
					onResult(data["content"]);
				}
			};
			loader.load(option);
		}
		
		public function getFile(url:String, onResult:Function, onFail:Function = null):void {
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.onFault = onFail;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.onSuccess = onResult;
			loader.load(option);
		}
		
		public function set enabled(bool:Boolean):void
		{
			_enabled = bool;
		}
	}
}