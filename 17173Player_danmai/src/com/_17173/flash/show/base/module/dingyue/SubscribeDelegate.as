package com._17173.flash.show.base.module.dingyue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.CEnum;
	
	public class SubscribeDelegate extends BaseModuleDelegate
	{
		private var _moduleLoaded:Boolean = false;
		private var _msgs:Array = null;
		public function SubscribeDelegate()
		{
			super();
			_msgs = [];
			(Context.getContext(CEnum.EVENT) as EventManager).listen(DingyueBtn.DINGYUE_GUIDE,showGuide);
			(Context.getContext(CEnum.EVENT) as EventManager).listen(DingyueBtn.DINGYUE_GUIDE_RP,rePostion);
		}
		
		private function showGuide(data:Object):void{
			if(!_moduleLoaded){
				cacheToMsg(sendEvent,{type:DingyueBtn.DINGYUE_GUIDE,data:data});
			}
			
		}
		
		private function rePostion(data:Object):void{
			if(!_moduleLoaded){
				cacheToMsg(sendEvent,{type:DingyueBtn.DINGYUE_GUIDE_RP,data:data});
			}
		}
		
		
		private function sendEvent(info:Object):void{
			var type:String = info.type;
			var data:Object = info.data;
			(Context.getContext(CEnum.EVENT) as EventManager).send(type,data);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_moduleLoaded = true;
			sendCache();
		}
		/**
		 *派发缓存数据
		 *
		 */
		private function sendCache():void
		{
			
			//所有缓存数据进行处理
			var fun:Function;
			var data:Object;
			var len:int = _msgs.length;
			var msg:Object;
			len = _msgs.length;
			for (var j:int = 0; j < len; j++) 
			{
				msg = _msgs[j];
				fun = msg.back;
				data = msg.data;
				fun.apply(null,[data]);
			}
			
		}
		
		/**
		 *是否缓存 如果模块没加载完毕则自动加入缓存中
		 * @param fun 缓存回调
		 * @param data 回调数据
		 * @return 
		 * 
		 */
		private function cacheToMsg(fun:Function, data:Object):Boolean
		{
			var iscache:Boolean = !_moduleLoaded;
			if(iscache){
				_msgs[_msgs.length] = {back:fun,data:data};
			}
			return iscache;
		}
	}
}