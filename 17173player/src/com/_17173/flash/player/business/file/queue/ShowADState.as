package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	public class ShowADState extends FileState
	{
		private var e:IEventManager;
		
		public function ShowADState()
		{
			super();
			e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
		}
		
		override public function enter():void {
			var isLocal:Boolean = transcationData["adIsLocal"];
			var is173:Boolean = transcationData["adIs173"];
			var isInList:Boolean = transcationData["adIsInSkipList"];
			if (isLocal || is173 || isInList) {
				skipShowAD();
			} else {
				startShowAD();
			}
		}
		
		/**
		 * 正常显示广告
		 */		
		protected function startShowAD():void {
			Debugger.log(Debugger.INFO, "显示广告");
			e.listen(PlayerEvents.BI_AD_COMPLETE, onAdPlayComplete);
			e.listen(PlayerEvents.BI_AD_DATA_RETIVED, onAdDataRetrived);
			e.listen(PlayerEvents.BI_AD_DATA_ERROR, onAdDataRetrived);
			
			e.send(PlayerEvents.BI_START_LOAD_AD_INFO);
		}
		
		/**
		 * 跳过广告
		 */		
		protected function skipShowAD():void {
			Debugger.log(Debugger.INFO, "跳过广告");
			e.send(PlayerEvents.UI_HIDE_PT);
			onAdDataRetrived(null);
			onAdPlayComplete(null);
		}
		
		private function onAdDataRetrived(data:Object):void {
			Debugger.log(Debugger.INFO, "广告数据已经获取");
			e.remove(PlayerEvents.BI_AD_DATA_RETIVED, onAdDataRetrived);
			e.remove(PlayerEvents.BI_AD_DATA_ERROR, onAdDataRetrived);
		}
		
		private function onAdPlayComplete(data:Object = null):void {
			Debugger.log(Debugger.INFO, "广告播放结束");
			e.remove(PlayerEvents.BI_AD_COMPLETE, onAdPlayComplete);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_PT);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_PT);
			
			transcationData["isADPlayComplete"] = true;
			complete();
		}
		
	}
}