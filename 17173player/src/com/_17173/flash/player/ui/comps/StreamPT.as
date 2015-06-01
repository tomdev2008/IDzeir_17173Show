package com._17173.flash.player.ui.comps
{
	
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.ui.BasePT;
	
	import flash.events.Event;
	
	/**
	 * 品推新界面
	 *  
	 * @author xppiao-17173
	 */	
	public class StreamPT extends BasePT
	{
		
		public function StreamPT()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			_pt = new mc_streamPT();
			//_pt.gotoAndStop(1);
			addChild(_pt);
			
			_ptw = _pt.width;
			_pth = _pt.height;
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.ADA1_BEGIN,onAdA1Begin);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_AD_COMPLETE,onAdEnd);
		}
		
		private function onAdA1Begin(e:Object):void {
			_pt.visible = false;
		}
		
		private function onAdEnd(e:Object):void {
			_pt.visible = true;
		}
		
		override protected function onAdded(event:Event):void {
			_pt.play();
			//重置一下位置
			//			resize();
		}
	}
}

