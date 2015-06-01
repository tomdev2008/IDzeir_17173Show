package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.BusinessManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 点播推荐直播
	 */	
	public class FileShowLiveRecState extends FileState
	{
		public function FileShowLiveRecState()
		{
			super();
		}
		
		override public function enter():void {
			var hasError:Boolean = transcationData["error"] || (Context.getContext(ContextEnum.BUSINESS_MANAGER) as BusinessManager).error;
			if (!hasError) {
				var obj:Object = {};
//				obj["aClass"] = FileVideoData(Global.videoData).aClass;
//				obj["bClass"] = FileVideoData(Global.videoData).bClass;
//				Global.eventManager.send(PlayerEvents.UI_SHOW_LIVE_REC, obj);
				obj["aClass"] = FileVideoData((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data).aClass;
				obj["bClass"] = FileVideoData((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data).bClass;
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_LIVE_REC, obj);
			}
			complete();
		}
	}
}