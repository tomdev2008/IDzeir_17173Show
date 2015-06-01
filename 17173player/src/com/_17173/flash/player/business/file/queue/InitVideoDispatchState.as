package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	
	/**
	 * 获取调度state
	 */	
	public class InitVideoDispatchState extends FileState
	{
		public function InitVideoDispatchState()
		{
			super();
		}
		
		override public function enter():void {
			Debugger.log(Debugger.INFO, "[business]", "启动调度!");
			Context.getContext(ContextEnum.DATA_RETRIVER).startDispatch(
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data ? (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["cid"] : Context.variables["cid"], 
				onVideoDataRetrived, onVideoDataFail);
//			Global.dataRetriver.startDispatch(
//				Global.videoData ? Global.videoData["cid"] : Context.variables["cid"], 
//				onVideoDataRetrived, onVideoDataFail);
		}
		
		/**
		 * 获取视频调度成功
		 * @param video 解析过后的视频信息类
		 */	
		protected function onVideoDataRetrived(video:IVideoData):void {
			Debugger.log(Debugger.INFO, "[business]", "调度已获取!");
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_GET_VIDEO_INFO, video);
			transcationData["videoData"] = video;
//			if (Context.variables.hasOwnProperty("t")) {
//				Debugger.log(Debugger.INFO, "[business] t:" + Context.variables["t"]);
//			}
			complete();
		}
		
		/**
		 * 视频调度失败 
		 */		
		protected function onVideoDataFail(error:PlayerErrors):void {
			Debugger.log(Debugger.INFO, "[business]", "调度获取失败!");
			transcationData["error"] = error;
			complete();
		}
	}
	
}