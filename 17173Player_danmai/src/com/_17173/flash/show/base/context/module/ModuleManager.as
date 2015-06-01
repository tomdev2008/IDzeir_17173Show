package com._17173.flash.show.base.context.module
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.show.model.CEnum;

	/**
	 * 模块管理类.
	 *  
	 * @author shunia-17173
	 */	
	public class ModuleManager implements IModuleManager, IContextItem
	{
		
		/**
		 * 注册进来的delegate类字典 
		 */		
		private var _mainDelegates:Object = null;
		private var _subDelegates:Object = null;
		/**
		 * 从配置文件中解析出来的配置数据 
		 */	    
		private var _config:Object = null;
		/**
		 * 已经实例化过的模块代理类 
		 */		
		private var _inited:Object = null;
		
		public function ModuleManager()
		{
		}
		
		public function set config(value:*):void {
			for each (var conf:Object in value) {
				_config[conf.name] = conf;
			}
		}
		
		public function initMain():void {
			//初始化所有主要模块
			for (var k:String in _mainDelegates) {
				if (hasModule(k) && !_inited[k]) {
					var d:IModuleDelegate = get(k);
					if (d) {
						d.config = getConfig(k);
						d.load();
					}
				}
			}
		}
		
		public function regDelegate(moduleName:String, delegate:Class = null ,isMain:Boolean = false):void {
			if(isMain){
				_mainDelegates[moduleName] = delegate;
			}else{
				_subDelegates[moduleName] = delegate;
			}
		}
		
		public function deregisterDelegate(moduleName:String):void {
			if(hasModule(moduleName) && _subDelegates[moduleName]) {
				delete _subDelegates[moduleName];
			}
			if(hasModule(moduleName) && _mainDelegates[moduleName]) {
				delete _mainDelegates[moduleName];
			}
		}
		
		public function hasModule(moduleName:String):Boolean {
			return _config.hasOwnProperty(moduleName);
		}
		
		private function getConfig(moduleName:String):Object {
			return _config[moduleName];
		}
		
		public function load(moduleName:String):void
		{
			var delegate:IModuleDelegate = get(moduleName);
			
			if (delegate) {
				var config:Object = getConfig(moduleName);
				delegate.config = config;
				delegate.autoLoad();
				if (config && !config.autoLoad) {
					delegate.autoLoad();
				}
			}
		}
		
		public function loadAll():void {
			for (var k:String in _mainDelegates) {
				if (hasModule(k)) {
					load(k);
				}
			}
		}
		
		public function unload(moduleName:String):void
		{
			var delegate:IModuleDelegate = get(moduleName);
			if(delegate) {
				delegate.unload();
				delete _inited[moduleName];
			}
		}
		
		public function unloadAll():void {
			for (var k:String in _inited) {
				unload(k);
			}
		}
		
		/**
		 * 获取指定名称的模块的实例
		 * 
		 * 前提是配置文件里需要有，如果没有配置，则认为模块不存在，即便注册了也可以使用
		 *  
		 * @param moduleName 模块名
		 * @return 根据模块名获取的模块实例
		 */		
		public function get(moduleName:String):IModuleDelegate
		{
			var d:IModuleDelegate;
			if (hasModule(moduleName) && _inited.hasOwnProperty(moduleName)) {
				return _inited[moduleName];
			} else if (hasModule(moduleName) && _mainDelegates.hasOwnProperty(moduleName)) {
				d = new _mainDelegates[moduleName]();
				_inited[moduleName] = d;
				return d;
			} else if(hasModule(moduleName) && _subDelegates.hasOwnProperty(moduleName)) {
				d = new _subDelegates[moduleName]();
				_inited[moduleName] = d;
				return d;
			} else {
				return null;
			}
		}
		
		public function get contextName():String
		{
			return CEnum.MODULE;
		}
		
		public function startUp(param:Object):void
		{
			_config = {};
			_mainDelegates = {};
			_subDelegates = {};
			_inited = {};
		}
		
		public function initAllSub():void
		{
			for (var k:String in _subDelegates) {
				if (hasModule(k) && !_inited[k]) {
					var d:IModuleDelegate = get(k);
					if (d) {
						d.config = getConfig(k);
					}
				}
			}
		}
		
		public function loadAllSub():void
		{
			for (var k:String in _subDelegates) {
				if (hasModule(k)) {
					var d:IModuleDelegate = get(k);
					d.autoLoad();
				}
			}
			
		}
		
	}
}