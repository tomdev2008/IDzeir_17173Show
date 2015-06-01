package com._17173.flash.player.module.stat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.PluginEnum;
	
	import flash.display.Loader;
	import flash.events.Event;

	public class StatDelegate implements IStat, IContextItem
	{
		
		/**
		 * 缓存的统计数据 
		 */		
		private var _stats:Array = null;
		/**
		 * BI统计模块 
		 */		
		private var _bi:Object = null;
		
		public function StatDelegate() {
			
		}
		
		/**
		 * 代理接口
		 * 如果模块已加载则发送统计数据
		 * 否则缓存起来等待模块加载
		 *  
		 * @param type 统计类型
		 * @param data 统计数据
		 */		
		public function stat(type:String, event:String, data:Object):void {
			if (_bi) {
				_bi.stat(type, event, data);
			} else {
				_stats.push({"type":type, "event":event, "data":data});
			}
		}
		
		public function get contextName():String {
			return ContextEnum.STAT;
		}
		
		public function startUp(param:Object):void {
			_stats = [];
			
			//业务逻辑走完才开始加载模块
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.listen(PlayerEvents.BI_COMPLETE, initBiModule);
			
			//广告播放器加载完毕 由于统计模块需要一个事件来启动，普通是BI_COMPLETE，但是使用这个事件其它组件会初始化，因此单独为广告播放器开启一个事件
			e.listen(PlayerEvents.BI_ADPALYER_COMPLET, initBiModule);
		}
		
		/**
		 * 启动模块加载
		 *  
		 * @param data
		 */		
		private function initBiModule(data:Object = null):void {
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.remove(PlayerEvents.BI_COMPLETE, initBiModule);
			
			var p:IPluginManager = Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager;
			var i:IPluginItem = p.getPlugin(PluginEnum.STAT);
			i.addEventListener(PluginEvents.COMPLETE, onLoaded);
		}
		
		/**
		 * 模块已加载
		 *  
		 * @param e
		 */		
		private function onLoaded(e:Event):void {
			var w:Object = e.target.warpper;
			_bi = w is Loader ? w.content : w;
			
			var s:Object = null;
			while (_stats.length > 0) {
				s = _stats.shift();
				if(_bi.hasOwnProperty("stat")){
					_bi.stat(s.type, s.event, s.data);
				}
			}
		}
		
	}
}