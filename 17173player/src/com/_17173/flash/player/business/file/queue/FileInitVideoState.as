package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.BusinessManager;
	import com._17173.flash.player.context.ContextEnum;

	/**
	 * 初始化视频
	 */	
	public class FileInitVideoState extends FileState
	{
		public function FileInitVideoState()
		{
			super();
			Debugger.log(Debugger.INFO, "[business]", "准备初始化视频init");
		}
		
//		override public function enter():void {
//			
//		}
		
		override public function enter():void {
			Debugger.log(Debugger.INFO, "[business]", "准备初始化视频");
			var hasError:Boolean = transcationData["error"] || (Context.getContext(ContextEnum.BUSINESS_MANAGER) as BusinessManager).error;
			if (!hasError) {
				if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager)) {
					Debugger.log(Debugger.INFO, "[business]", "业务逻辑正常，开始初始化视频!");
				} else {
					Debugger.log(Debugger.INFO, "[business]", "业务逻辑错误，找不到VideoManger");
				}
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).init(transcationData["videoData"]);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
			} else {
				Debugger.log(Debugger.INFO, "[business]", "存在逻辑错误，显示错误页面!");
			}
			complete();
		}
		
//		private function startVideo(data:Object = null):void {
//			var hasError:Boolean = transcationData["error"] || (Context.getContext(ContextEnum.BUSINESS_MANAGER) as BusinessManager).error;
//			if (!hasError) {
//				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).init(transcationData["videoData"]);
//				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
//			}
//			complete();
//		}
	}
}