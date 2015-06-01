package  com._17173.flash.show.base.module.stat
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	public class StatDelegate extends BaseModuleDelegate implements IStat, IContextItem
	{
		
		/**
		 * 缓存的统计数据 
		 */		
		private var _stats:Array = null;
		/**
		 * BI统计模块 
		 */		
		private var _bi:Object = null;
		
		private var _loaded:Boolean;
		
		public function StatDelegate() {
			startUp(null);
			super();
			_e.listen(SEvents.BI_STAT, onBIStatEvent);
			Debugger.log(Debugger.INFO, "[Stat]", "BI统计模块");
		}
		
		override protected function  onModuleLoaded():void{
			super.onModuleLoaded();
			_loaded = true;
//			//派发进入房间
//			_e.send(SEvents.SEND_QM,{"id":"fpv"});
			_bi = _swf;
			checkCache();
			stat(StatTypeEnum.BI, StatTypeEnum.EVENT_LOADED, "");
		}
		
		private function checkCache():void {
			if (_stats && _stats.length > 0) {
				for (var i:int = 0; i < _stats.length; i++) {
					stat(_stats[i]["type"], _stats[i]["event"], _stats[i]["data"]);
				}
			}
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
			return CEnum.STAT;
		}
		
		public function startUp(param:Object):void {
			_stats = [];
			//业务逻辑走完才开始加载模块
//			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
//			e.listen(PlayerEvents.BI_COMPLETE, initBiModule);
		}
		
		private function onBIStatEvent(data:Object):void {
			if (data.hasOwnProperty("type") && data.hasOwnProperty("event")) {
				var temp:Object;
				if (data.hasOwnProperty("data")) {
					temp = data["data"];
				} else {
					temp = null;
				}
				stat(data["type"], data["event"], temp);
			}
		}
		
	}
}