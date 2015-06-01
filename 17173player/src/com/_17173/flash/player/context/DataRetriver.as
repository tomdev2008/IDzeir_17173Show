package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.utils.Dictionary;

	/**
	 * abstract 
	 * @author shunia-17173
	 */	
	public class DataRetriver implements IContextItem
	{
		
		protected var _reLoadDic:Dictionary;
		
		public function DataRetriver()
		{
		}
		
		public function startDispatch(cid:String, onSuccess:Function, onFail:Function):void
		{
		}
		
		public function reqForMore(id:String, callback:Function):void {
			
		}
		
		/**
		 * 封装loader. 
		 * @param url
		 * @param callback
		 * @param format
		 * @param data
		 * @param resolver
		 * @param repeated  如果有重复请求是否去重
		 */		
		protected function packupLoader(url:String, onResult:Function, 
										format:String = LoaderProxyOption.FORMAT_JSON, 
										sourceData:Object = null, 
										resolver:Class = null, 
										validateFunc:Function = null,
										onFault:Function = null):void {
			//已经有这个请求了,打断掉
			if (_reLoadDic[url]) {
				LoaderProxy(_reLoadDic[url]).cancel();
			}
			
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				url, 
				format, 
				LoaderProxyOption.TYPE_FILE_LOADER, 
				function (data:Object):void {
					//默认使用"000000"作为返回数据成功的标识
					if(validateFunc == null) {
						validateFunc = validateResult;
					}
					//验证数据是否成功
					if (validateFunc(data) == false) {
						//报错
//						var code:String = data.hasOwnProperty("code") ? data.code : "0";
						var msg:String = data is String ? data : data.msg;
						msg += ("->" + url);
						onDataError(onFault, data, PlayerErrors.DATA_IO_ERROR, msg);
					} else {
						_reLoadDic[url] = null;
						//回调
						if (onResult != null) {
							onResult.call(null, data);
						}
					}
				}, 
				//io错误
				function (data:Object):void {
					_reLoadDic[url] = null;
					//首先进行断线重连
//					if (doReload(url, callback, format, sourceData, resolver, valedata, errorBack) == false) {
						onDataError(onFault, data, PlayerErrors.DATA_IO_ERROR, "");
//					}
				});
			option.data = sourceData;
			option.manuallyResolver = resolver == null ? JSONResolver : resolver;
			loader.load(option);
			
			_reLoadDic[url] = loader;
		}
		
		private function onDataError(errorCallback:Function, errorData:Object, errorType:String, errorMsg:String):void {
			if(errorCallback != null) {
				errorCallback.call(null, errorData);
			} else {
				onError(PlayerErrors.packUpError(errorType, errorMsg));
			}
		}
		
		/**
		 * 判断接口正确性. 
		 * @param data
		 * @return 
		 */		
		protected function validateResult(data:Object):Boolean {
			if (data && data.hasOwnProperty("code")) {
				if (data.code == PlayerErrors.HAND_SHAKE_SUCCESS_CODE) {
					//成功
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Error派发. 
		 * @param type
		 * @param code
		 * @param msg
		 */		
		protected function onError(error:Object):void {
//			Global.eventManager.send(PlayerEvents.ON_PLAYER_ERROR, error);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.ON_PLAYER_ERROR, error);
		}
		
		public function get contextName():String {
			return ContextEnum.DATA_RETRIVER;
		}
		
		public function startUp(param:Object):void {
			_reLoadDic = new Dictionary();
		}
		
	}
}