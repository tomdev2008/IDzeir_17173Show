package com._17173.flash.show.base.module.broadcast
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.sanmai.module.base.BaseModuleDelegate;
	
	import flash.events.Event;
	import com._17173.flash.show.model.PEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 大公告代理类
	 *  
	 * @author shunia-17173
	 */	
	public class BroadcastDelegate extends BaseModuleDelegate
	{
		
		/**
		 * 大公告的缓存数据 
		 */		
		private var _broadcasts:Array = null;
		
		public function BroadcastDelegate()
		{
			super();
			
			_broadcasts = [];
			
			//监听大公告数据消息
			_s.socket.listen(SEnum.R_BROADCAST.action, SEnum.R_BROADCAST.type, onBroadCastData);
		}
		
		override public function get name():String {
			return PEnum.BROADCAST;
		}
		
		private function onBroadCastData(data:Object):void {
			_broadcasts.push(data);
			
			onBroadCast();
		}
		
		override protected function onLoadCompelte(e:Event):void {
			super.onLoadCompelte(e);
			
			onBroadCast();
			
//			var pos:ScenePos = new ScenePos();
//			pos.isAbsolute = true;
//			pos.left = (ScenePos.SCENE_WIDTH - _swf.width) / 2;
//			pos.top = 522;
//			pos.name = _swf.name;
//			pos.content = _swf;
//			pos.id = name;
			
			_e.send(SEvents.REG_SCENE_POS, _swf);
		}
		
		/**
		 * 把数据交给模块处理 
		 */		
		private function onBroadCast():void {
			if (_swf && _broadcasts) {
				while (_broadcasts.length > 0) {
					_swf["data"] = _broadcasts.shift();
				}
			}
		}
		
		override public function get version():String {
			return Context.variables["conf"].ver.Broadcast;
		}
		
	}
}