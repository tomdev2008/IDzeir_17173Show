package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 显示firstPage
	 */	
	public class FileShowFirstPage extends FileState
	{
		private var _e:IEventManager;
		
		public function FileShowFirstPage()
		{
			super();
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
		}
		
		override public function added():void {
			_e.listen(PlayerEvents.UI_PLAY_OR_PAUSE, onUIVideoPlayAndPause);
		}
		
		override public function enter():void {
			if (Util.validateObj(Context.variables, "showFP") && Context.variables["showFP"] && !Util.validateObj(transcationData, "error")) {
				Debugger.tracer(Debugger.INFO, "显示初始页");
				_e.send(PlayerEvents.UI_HIDE_PT);
				_e.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
				_e.send(PlayerEvents.UI_SHOW_PREVIDEW_PAGE, FileVideoData(transcationData["videoData"]).thumbnail);
			} else {
				Debugger.tracer(Debugger.INFO, "跳过初始页");
				_e.send(PlayerEvents.UI_HIDE_BIG_PALY_BTN);
				_e.send(PlayerEvents.UI_HIDE_PREVIDEW_PAGE);
				_e.remove(PlayerEvents.UI_PLAY_OR_PAUSE, onUIVideoPlayAndPause);
				complete();
			}
		}
		
		/**
		 * 点播站外显示firstPage时候可以点击播放按钮，进行开始
		 */		
		private function onUIVideoPlayAndPause(data:Object):void {
//			(Context.getContext(ContextEnum.UI_MANAGER) as UIManager).showPT();
			Context.getContext(ContextEnum.UI_MANAGER).showPT();
			_e.remove(PlayerEvents.UI_PLAY_OR_PAUSE, onUIVideoPlayAndPause);
			_e.send(PlayerEvents.UI_HIDE_BIG_PALY_BTN);
			_e.send(PlayerEvents.UI_HIDE_PREVIDEW_PAGE);
			complete();
		}
	}
}