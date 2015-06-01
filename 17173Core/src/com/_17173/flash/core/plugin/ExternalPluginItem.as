package com._17173.flash.core.plugin
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 加载的插件封装类.
	 *  
	 * @author shunia-17173
	 */	
	public class ExternalPluginItem extends EventDispatcher implements IPluginItem
	{
		
		/**
		 * 插件名 
		 */		
		private var _name:String = null;
		/**
		 * 插件路径 
		 */		
		private var _path:String = null;
		/**
		 * 加载的显示对象 
		 */		
		private var _wrapper:DisplayObject = null;
		/**
		 * 是否加载完成 
		 */		
		private var _complete:Boolean = false;
		/**
		 * 是否初始化过 
		 */		
		private var _inited:Boolean = false;
		
		public function ExternalPluginItem()
		{
			super();
		}
		
		public function set name(value:String):void {
			_name = value;
		}
		
		public function get name():String {
			return _name;
		}
		
		/**
		 * 初始化,开始加载路径所指定的插件 
		 */		
		public function init():void {
			_inited = true;
			if (validatePath()) {
				try {
					var loader:LoaderProxy = new LoaderProxy();
					var option:LoaderProxyOption = new LoaderProxyOption(
						_path, 
						LoaderProxyOption.FORMAT_SWF, 
						LoaderProxyOption.TYPE_ASSET_LOADER, 
						onLoadComplete, 
						onLoadFail);
					loader.load(option);
				} catch (e:Error) {
					//文件不存在啊啥的,报错
					onLoadFail(null);
				}
			}
		}
		
		/**
		 * 出错了
		 *  
		 * @param error
		 */		
		private function onLoadFail(error:Object):void {
			_complete = true;
			//如果加载错误，返回一个空的sprite
			_wrapper = new Sprite();
			dispatchEvent(new PluginEvents(PluginEvents.COMPLETE));
		}
		
		/**
		 * 加载完成的回调.
		 *  
		 * @param data
		 */		
		private function onLoadComplete(data:DisplayObject):void {
			_complete = true;
			_wrapper = data;
			
			var interval:uint = setInterval(function ():void {
				clearInterval(interval);
				dispatchEvent(new PluginEvents(PluginEvents.COMPLETE));
			}, 500);
		}
		
		private function validatePath():Boolean {
			return true;
		}
		
		public function get isInited():Boolean {
			return _inited;
		}

		public function get path():String {
			return _path;
		}

		public function set path(value:String):void {
			_path = value;
		}

		public function get complete():Boolean {
			return _complete;
		}

		public function get warpper():DisplayObject {
			return _wrapper;
		}

	}
}