package com._17173.flash.core.plugin
{
	
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.util.Util;
	
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 模块管理器 
	 * @author shunia-17173
	 */	
	public class PluginManager implements IContextItem, IPluginManager
	{
		
		public static const CONTEXT_NAME:String = "pluginManager";
		
		/**
		 * 当前已实例化过的模块 
		 */		
		private var _plugins:Dictionary = null;
		private var _initPluginNum:int = 0;
		private var _initPlugins:Dictionary = null;
		private var _inited:Dictionary = null;
		private var _initedNum:int = 0;
		
		private var _initing:Boolean = false;
		
		public function PluginManager()
		{
			_plugins = new Dictionary();
			_inited = new Dictionary();
		}
		
		public function addPlugin(name:String, module:Class = null):void {
			if (hasPlugin(name)) return;
			_plugins[name] = module;
		}
		
		/**
		 * 初始化当前已注册的模块 
		 */		
		public function initAll():void {
			_initing = true;
			_initPlugins = new Dictionary();
			//记录长度
			for (var name:String in _plugins) {
				_initPluginNum ++;
				_initPlugins[name] = _plugins[name];
			}
			//启动模块
			for (name in _initPlugins) {
				initPlugin(name);
			}
			Context.getContext(EventManager.CONTEXT_NAME).send(PluginEvents.READY);
		}
		
		/**
		 * 模块初始化结束 
		 * @param e
		 */		
		private function onPluginComplete(e:Event):void {
			_inited[e.target.name] = e.target;
			//remove
			e.target.removeEventListener(PluginEvents.COMPLETE, onPluginComplete);
			_initedNum ++;
			if (_initing && _initedNum == _initPluginNum) {
				_initing = false;
				_initPlugins = null;
				Context.getContext(EventManager.CONTEXT_NAME).send(PluginEvents.ALL_COMPLETE);
			}
		}
		
		public function getPlugin(name:String):IPluginItem {
			var item:IPluginItem = null;
			if (_inited.hasOwnProperty(name)) {
				item = _inited[name];
			} else {
				//注册这个模块,为之后初始化做准备
				addPlugin(name);
				item = initPlugin(name);
			}
			return item;
		}
		
		/**
		 * 根据名字初始化一个控件,如果是注册的类 
		 * @param name
		 * @return 
		 */		
		private function initPlugin(name:String):IPluginItem {
			var item:IPluginItem = null;
			//创建一个外部加载的插件.
			var hasCls:Boolean = _plugins.hasOwnProperty(name) && _plugins[name] && _plugins[name] is Class;
			var cls:Class = hasCls 
				? 
				_plugins[name] : ExternalPluginItem;
			item = new cls();
			var path:Object = splitPluginPath(name);
			item.name = path.name;
			//非注册类,用的外部类
			if (!hasCls) {
				(item as ExternalPluginItem).path = path.path;
			}
			if (item) {
				//初始化
				item.addEventListener(PluginEvents.COMPLETE, onPluginComplete);
				item.init();
			}
			
			return item;
		}
		
		private function splitPluginPath(name:String):Object {
			//如果传来的名称里没有地址解析符,则认为非相对路径,不做解析处理
			if (name.indexOf("/") == -1) return {"name":name};
			
			var loadPath:String = Context.variables.ref;
			var loadPaths:Array = loadPath.split("/");
			//如果路径最后不是'/',则加上
			var path:Object = {};
			var splits:Array = name.split("/");
			var n:String = splits[splits.length - 1];
			var p:String = splits[0];
			if (Util.validateStr(p)) {
				//过滤掉前面的.或者..的相对路径
				if (p == "." || p == "..") {
					splits.shift();
				}
				if (p == "..") {
					loadPaths.pop();
				}
				p = loadPaths.concat(splits).join("/");
			}
			
			path.name = n;
			//只支持swf模块
			path.path = p + ".swf";
			
			return path;
		}
		
		public function hasPlugin(name:String):Boolean {
			return _plugins.hasOwnProperty(name);
		}
		
		public function removePlugin():Boolean {
			return false;
		}
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			_plugins = new Dictionary();
			_inited = new Dictionary();
			
			for (var key:String in param) {
				addPlugin(key, param[key]);
			}
			Context.getContext(EventManager.CONTEXT_NAME).send(PluginEvents.INIT);
		}
		
	}
}