package com._17173.flash.show.base.context.resource
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.data.AnimData;
	import com._17173.flash.show.base.utils.RenderUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	public class ResourceManager  implements IResourceManager,IContextItem
	{
		
		private var _callbacks:Dictionary = null;
		private var _failbacks:Dictionary = null;
		/**
		 *普通资源 
		 */		
		private var _sources:Dictionary = null;
		/**
		 *动画资源 
		 */		
		private var _bmaSources:Dictionary = null;
		private var _refPath:String = null;
		/**
		 *空闲超时限制 
		 */		
		private var gcLimit:int = 1000 * 30 * 1;
		/**
		 *检测间隔 
		 */		
		private var checkTime:int = 1000 * 10;
		
		public function ResourceManager()
		{
			_callbacks = new Dictionary();
			_sources = new Dictionary();
			_failbacks = new Dictionary();
			_bmaSources = new Dictionary();
		}
		
		/**
		 *返回给所有回调资源 
		 * @param url
		 * @param data
		 * 
		 */		
		private function onCallsByUrl(key:String,data:*):void{
			var calls:Array = _callbacks[key] as Array;
			var call:Function;
			var len:int = calls.length
			for (var i:int = 0; i < len; i++) 
			{
				call = calls[i] as Function;
				if(call != null){
					call.apply(null,[data]);
				}
			}
		}
		/**
		 *错误回调 
		 * @param url
		 * 
		 */		
		private function onFailCallsByUrl(url:String):void{
			var calls:Array = _failbacks[url] as Array;
			var call:Function;
			var len:int = calls.length
			for (var i:int = 0; i < len; i++) 
			{
				if(calls[i]){
					call = calls[i] as Function;
					call.apply(null);
				}
			}
		}
		/**
		 *清空回调函数 
		 * @param url
		 * 
		 */		
		private function clearCallsByUrl(url:String):void{
			delete _callbacks[url];
			delete _failbacks[url];
		}
		
		/**
		 *获取资源 
		 * @param url 资源地址
		 * @param key AS连接名（获取MC类型的类时传入）
		 * @param callBack(加载完成或失败后回调)
		 * 
		 */		
		public function loadResource(url:String,callBack:Function = null,key:String = null):void{
			//判断url
			if(!Util.validateStr(url)) return;
			url = replaceUrl(url);
			//如果存在 直接返回
			if(_sources[url] !=null){
				if(callBack == null)return;
				if(key){
					var data:*  = getLinkResource(_sources[url].source as MovieClip,key);
					if(data is IResourceData){
						callBack.apply(null,[data]);
					}else{
						var rs:MovieClipResourceData = new MovieClipResourceData(data,key);
						callBack.apply(null,[rs]);
					}
				}else{
					callBack.apply(null,[_sources[url]]);
				}
			}else{ //不存在
				var cbs:Array;
				var cbs1:Array;
				//如果已经加载 则将回调方法添加到回调数组
				if(_callbacks[url] !=null){
					cbs = _callbacks[url] as Array;
					cbs.push(callBack);
					_callbacks[url] = cbs;
				}else{ //加载
					_callbacks[url] = [callBack];
					var loader:LoaderProxy = new LoaderProxy();
					var option:LoaderProxyOption = new LoaderProxyOption();
					option.url = url;
					option.onFault = function(data:Object):void{
						clearCallsByUrl(url);
						Debugger.log(Debugger.ERROR, "[ResourceManager]", "加载资源失败，资源地址: ", url);
					}
					option.type = LoaderProxyOption.TYPE_ASSET_LOADER;
					option.onSuccess = function (data:Object):void {
						var resourceData:*;
						if(data is Bitmap){	//如果是图片
							resourceData = new BitmapResourceData(data,url);
							_sources[url] = resourceData;
						}
						else if(data is MovieClip){//如果是动画
							_sources[url] = new MovieClipResourceData(data,url);
							if(key){
								resourceData = new MovieClipResourceData(getLinkResource(_sources[url].source as MovieClip,key),key);
							}else{
								resourceData = _sources[url];
							}
						}else{	//其他
							resourceData = new BaseResourceData(data,url);
							_sources[url] = resourceData;
						}
						onCallsByUrl(url,resourceData);
						clearCallsByUrl(url);
						
					};
					loader.load(option);
				}
			}
		}
		
		public function getResource(key:String):*{
			var result:*;
			if(ApplicationDomain.currentDomain.hasDefinition(key)){
				var cla:Class = ApplicationDomain.currentDomain.getDefinition(key) as Class;
				result = new cla();
			}
			return result;
		}
		
		
		private function getLinkResource(mc:MovieClip, skinName:String):*{
			var result:*;
			//如果资源有父级并且是loader那么证明可以通过反射获取该类,否则可能是其他类型资源，直接返回该资源
			if(mc && mc.parent && mc.parent is Loader){
				var loader:Loader = mc.parent as Loader;
				if(loader.contentLoaderInfo.applicationDomain.hasDefinition(skinName)){
					var cla:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(skinName)  as Class;
					result = new cla();
				}else{
					Debugger.log(Debugger.ERROR, "[加载动画错误]","动画链接"+skinName);
				}
			}else{
				result = mc;
			}
			return result;
		}
		
		public function addAnimDatas4Mc(key:String, mc:MovieClip, colorClip:Boolean = true):Boolean
		{
			if(_bmaSources[key] == null){
				_bmaSources[key] = RenderUtil.movieClipToBitmapdata(mc, colorClip);
				return true;
			}
			return false;
		}
		
		/**
		 *复制动画数据 
		 * @param arr
		 * @return 
		 * 
		 */		
		private function clone4AnimDatas(arr:Array):Array{
			var result:Array = [];
			var anim:AnimData;
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++) 
			{
				anim = arr[i] as AnimData;
				result[result.length] = anim.clone();
			}
			return result;
		}
		
		
		public function get contextName():String{
			return CEnum.SOURCE;
		}
		
		public function startUp(param:Object):void{
			_refPath = Context.variables["ref"];
		}
		
		/**
		 *替换路径为绝对完整路径 
		 * @param url
		 * @return 
		 * 
		 */		
		private function replaceUrl(url:String):String{
			if(url.indexOf("http://") < 0 && url.indexOf("https://") < 0){
				if(_refPath && _refPath.indexOf("http://") < 0 && _refPath.indexOf("https://") < 0){
					
				}else{
					var idx:int = url.indexOf("/");
					if(idx != 0){
						url = "/" + url;
					}
					url = _refPath + url;
				}
			}
			return url;
		}
		/**
		 *资源回收装在数据 
		 * @param cTime
		 * @param limit
		 * 
		 */		
		public function setupGC(data:Object):void{
			checkTime = data.checkTime * 1000;
			gcLimit = data.gcLimit * 1000;
			Ticker.tick(checkTime,checkExpired,-1);
		}
		
		/**
		 *检测过期 
		 * 
		 */		
		public function checkExpired():void
		{
			// TODO Auto Generated method stub
			for (var key:String in _sources) 
			{
				var data:BaseResourceData = _sources[key];
				if(data.isAutoGc && data.freeTime > gcLimit){
					Debugger.log(Debugger.INFO, "[资源清理]", "清理资源：",key);
					delete _sources[key];
				}
			}
			
		}
		
		public function getAnimDatas(key:String):Array
		{
			var result:Array;
			if(_bmaSources[key] != null){
				result = clone4AnimDatas(_bmaSources[key]);
			}
			return result;
		}
		
	}
}