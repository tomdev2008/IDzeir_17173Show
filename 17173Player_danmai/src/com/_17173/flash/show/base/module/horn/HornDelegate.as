package com._17173.flash.show.base.module.horn
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.model.MessageVo;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class HornDelegate extends BaseModuleDelegate
	{
		private var _hornMsgs:Array = null;
		private var _moduleLoaded:Boolean = false;
		private var _cacheMsg:Array = null;
		public function HornDelegate()
		{
			super();
			_hornMsgs = [];
			_cacheMsg = [];
			_s.socket.listen(SEnum.R_MIN_HORN.action, SEnum.R_MIN_HORN.type, hornBack);
			_s.socket.listen(SEnum.R_HORN_MSG.action, SEnum.R_HORN_MSG.type, hornBack1);
		}
		
		override protected function onModuleLoaded():void
		{
			super.onModuleLoaded();
			_moduleLoaded = true;
			sendCache();
		}
		
		/**
		 *小喇叭回来
		 * @param data
		 *
		 */
		private function hornBack(data:Object):void
		{
			if(!cacheToMsg(hornBack,data)){
				var msg:MessageVo = MessageVo.getMsgVo(data.ct);
				//派发广播消息（小喇叭消息）
				_e.send(SEvents.HORN_MESSAGE, msg);
			}
			
		}
		
		/**
		 *小喇叭缓存
		 * @param data
		 *
		 */
		private function hornBack1(data:Object):void
		{
			var msg:MessageVo = MessageVo.getMsgVo(data.ct);
			//派发广播消息（小喇叭消息）
			if (_moduleLoaded)
			{
				_e.send(SEvents.HORN_MESSAGE_CACHE, msg);
			}
			else
			{
				_hornMsgs[_hornMsgs.length] = msg
			}
		}
		
		/**
		 *派发缓存数据
		 *
		 */
		private function sendCache():void
		{
			var msg:Object;
			var len:int = _hornMsgs.length;
			for (var i:int = 0; i < len; i++)
			{
				msg = _hornMsgs[i];
				_e.send(SEvents.HORN_MESSAGE_CACHE, msg);
			}
			
			//所有缓存数据进行处理
			var fun:Function;
			var data:Object;
			len = _cacheMsg.length;
			for (var j:int = 0; j < len; j++) 
			{
				msg = _cacheMsg[j];
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
				_cacheMsg[_cacheMsg.length] = {back:fun,data:data};
			}
			return iscache;
		}
	}
}