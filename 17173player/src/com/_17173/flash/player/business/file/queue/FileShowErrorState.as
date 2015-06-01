package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.IKeyboardManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.BusinessManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;

	/**
	 * 验证是否有调度错误和获取视频信息的错误
	 */	
	public class FileShowErrorState extends FileState
	{
		private var e:IEventManager;
		
		public function FileShowErrorState()
		{
			super();
			e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
		}
		
		override public function enter():void {
			Debugger.log(Debugger.INFO, "[business]", "业务逻辑错误错误验证");
			var hasError:Boolean = transcationData["error"] || (Context.getContext(ContextEnum.BUSINESS_MANAGER) as BusinessManager).error;
			if (hasError) {
				Debugger.log(Debugger.INFO, "[business]", "业务逻辑中出现错误，显示错误信息");
				var error:PlayerErrors = transcationData["error"] ? transcationData["error"] : (Context.getContext(ContextEnum.BUSINESS_MANAGER) as BusinessManager).error;
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ON_PLAYER_ERROR, error);
			} else {
				e.send(PlayerEvents.BI_PLAYER_INITED);
				e.send(PlayerEvents.UI_HIDE_BIG_PALY_BTN);
				loadPlug();
				
				Context.getContext(ContextEnum.UI_MANAGER).toggleEnabled(true);
				var type:String = Context.getContext(ContextEnum.SETTING)["type"];
//				if (type == Settings.PLAYER_TYPE_FILE_ZHANWAI || type == Settings.PLAYER_TYPE_FILE_OUT_CUSTOM) {
				if (type == PlayerType.F_ZHANWAI || type == PlayerType.F_CUSTOM) {
					(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(true);
				}
				else {
//					(Context.getContext(ContextEnum.VIDEO_MANAGER) as VideoManager).togglePlay(Global.settings.autoPlay);
					(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(Context.getContext(ContextEnum.SETTING).autoPlay);
				}
				
				//用户实际看到视频时间点
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_REAL_START, {});
			}
			complete();
		}
		
		/**
		 * 加载键盘管理类
		 */		
		private function loadPlug():void {
			var k:IKeyboardManager = Context.getContext(ContextEnum.KEYBOARD) as IKeyboardManager;
			k.enable = true;
		}
		
	}
}