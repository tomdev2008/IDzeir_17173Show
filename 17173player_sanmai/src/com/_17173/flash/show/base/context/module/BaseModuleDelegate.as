package com._17173.flash.show.base.context.module
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.ExternalPluginItem;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.model.SharedModel;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;

	/**
	 * 模块代理类.每个此代理类用于封装指定的模块.
	 * 用来负责与其他模块进行通信和接口调用.
	 * 并负责对指定的模块进行加载.
	 *  
	 * @author shunia-17173
	 */	
	public class BaseModuleDelegate implements IModuleDelegate
	{
		
		/**
		 * 插件 
		 */		
		protected var _p:IPluginManager = null;
		/**
		 * 网络 
		 */		
		protected var _s:IServiceProvider = null;
		/**
		 * 事件管理 
		 */		
		protected var _e:IEventManager = null;
		/**
		 * 模块显示对象 
		 */		
		protected var _swf:DisplayObject = null;
		/**
		 * 模块配置 
		 */		
		protected var _config:Object = null;
		/**
		 *资源管理 
		 */		
		protected var _r:IResourceManager = null;
		/**
		 * 模块加载代理 
		 */		
		private var _item:IPluginItem = null;
		/**
		 *皮肤资源名 
		 */		
		private var _resouceName:String = "";
		
		/**
		 * 模块加载完成前的缓存数据 
		 */		
		protected var _handles:Array;
		
		public function BaseModuleDelegate()
		{
			_p = Context.getContext(CEnum.PLUGIN) as IPluginManager;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_r = Context.getContext(CEnum.SOURCE) as IResourceManager;
			_handles = [];
		}
		
		public function set config(value:Object):void
		{
			_config = value;
			//判断是否有配置文件并且可以自动加载
			
		}
		
		public function autoLoad():void{
			if (_config && _config.hasOwnProperty("autoLoad") && _config.autoLoad) {
				load();
			}
		}
		
		public function load():void {
			//如果存在资源则必须提前加载
			if (_config.hasOwnProperty("resourceName") && _config.resourceName) {
				loadResource();
			}else{
				loadModule();
			}
		}
		
		/**
		 *加载模块 
		 * 
		 */		
		protected function loadModule():void{
			if (_item == null && _swf == null) {
				_item = _p.getPlugin(_config.name);
				_item.addEventListener(PluginEvents.COMPLETE, onLoadCompelte);
			}
		}
		
		/**
		 *加载资源
		 * 资源加载完成回调自动加载模块 
		 */		
		protected function loadResource():void{
			//加载资源
			_resouceName = _config.resourceName;
			_r.loadResource(SharedModel.assetsUIDir + _resouceName, loadResourceCmp, null);
		}
		
		protected function loadResourceCmp(resource:IResourceData):void{
			if(resource){
				Debugger.log(Debugger.INFO, "[module]",  _config.name+"模块,加载皮肤成功","UI皮肤Name" + _config.resourceName);
			}else{
				Debugger.log(Debugger.INFO, "[module]",  _config.name+"模块,加载皮肤失败","UI皮肤Name" + _config.resourceName);
			}
			loadModule();
		}
		
		/**
		 * 模块加载完成.
		 *  
		 * @param e
		 */		
		private function onLoadCompelte(e:Event):void {
			//加载出来的swf赋给当前模块显示对象
			_swf = (_item as ExternalPluginItem).warpper;
			
			var log:String = _config.name + "模块";
			if (module) {
				var ver:String = module.version;
				log += Util.validateStr(ver) ? " 版本[" + ver + "] " : "";	
			}
			
			_item.removeEventListener(PluginEvents.COMPLETE, onLoadCompelte);
			
			if(_swf)
			{
				if (_swf is Loader) {
					var c:DisplayObject = Loader(_swf).content;
					//				Loader(_swf).unloadAndStop();
					_swf = c;
				}
				_item = null;
				if (_swf is IModule) {
					IModule(_swf).name = _config.name;
				}
				
				if (_swf && _config.hasOwnProperty("autoAdd") && _config.autoAdd) {
					_e.send(SEvents.REG_SCENE_POS, _swf);
				}
				
				onModuleLoaded();				
				//只给模块本身发加载完成事件
				_e.send(SEvents.FW_MODULE_LOADED, _config.name, this);	
				
				log += "加载成功";
				Debugger.log(Debugger.INFO, "[module]", log);
			}else{
				
				log += "加载失败";
				Debugger.log(Debugger.INFO, "[module]", log);
				this.clear();
			}			
		}
		
		/**
		 * 需要被覆写用以处理模块被加载完之后的逻辑 
		 */		
		protected function onModuleLoaded():void {
			//override
			if(this._handles.length>0)
			{
				clearHandlers();
			}
		}
		
		private function clearHandlers():void
		{
			for each (var i:Object in this._handles)
			{
				var handle:Function = i["handle"];
				var pars:* = i["value"];
				if (handle!=null)
				{
					handle.apply(null, pars ? [pars] : null);
				}
			}
			_handles.length = 0;
		}
		
		public function excute(handle:Function,value:* = null):void
		{
			if(!module)
			{
				this._handles.push({"handle": handle, "value": value});
				return;
			}
			handle.apply(null,value?[value]:null);
		}
		
		public function get module():IModule
		{
			return _swf ? _swf as IModule : null;
		}
		
		public function unload():void
		{
			if (_swf) {
				if (_swf.parent && _swf.parent.contains(_swf)) {
					if (!(_swf.parent is Loader)) {
						_swf.parent.removeChild(_swf);
					} else {
						Loader(_swf.parent).unloadAndStop();
					}
				}
				if (_swf is Loader) {
					Loader(_swf).unloadAndStop();
				}
			}
			onUnload();
			_item = null;
			_swf = null;
		}
		
		/**
		 * 清除本delegate资源
		 * 
		 */		
		protected function clear():void
		{
			Debugger.log(Debugger.INFO, "[module]", _config.name + " ", this, "  1.清除delegate层数据 2.注销ModeleManager中delegate");
			//1.反注册删除moduleManager中的数据
			(Context.getContext(CEnum.MODULE) as IModuleManager).deregisterDelegate(_config.name);
			
			//2.子类覆盖清除构造时候的事件
		}
		
		/**
		 *卸载时调用
		 * 
		 */		
		protected function onUnload():void{
			clear();
		}
	}
}