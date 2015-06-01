package com._17173.flash.show.base.module.horn
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	
	public class HornModule extends BaseModule
	{
		private var _e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
		private var _hornMsgCache:Array = null;
		private var _added:Boolean = false;
		private var _hornPanel:HornPanel;
		public function HornModule()
		{
			_hornPanel = new HornPanel();
			super();
			this.addChild(_hornPanel);
		}
		
		override protected function init():void{
			_hornMsgCache = [];
			_e.listen(SEvents.HORN_MESSAGE,showHornMsg);
			_e.listen(SEvents.HORN_MESSAGE_CACHE,onHornMsg);
		}
		
		override public function set y(value:Number):void
		{
			super.y = value - _hornPanel.height;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			_hornPanel.size = Context.stage.stageWidth - value;
		}
		
		/**
		 *显示缓存 
		 * @param e
		 * 
		 */		
		override protected function onAdded(e:Event):void{
			_added = true;
			showCacheHorn();
		}
		
		/**
		 *接受到喇叭消息 
		 * @param data
		 * 
		 */		
		private function showHornMsg(data:Object):void{
			if(_hornPanel){
				_hornPanel.addMessage(data);
			}
		}
		
		private function onHornMsg(data:Object):void{
			_hornMsgCache[_hornMsgCache.length] = data;
			if(_added){
				showCacheHorn();
			}
		}
		
		/**
		 *显示缓存 
		 * 
		 */		
		private function showCacheHorn():void{
			var data:Object;
			var len:int = _hornMsgCache.length;
			for (var i:int = 0; i < len; i++) 
			{
				data = _hornMsgCache[i];
				showHornMsg(data);
			}
			_hornMsgCache = [];
			
		}
	}
}