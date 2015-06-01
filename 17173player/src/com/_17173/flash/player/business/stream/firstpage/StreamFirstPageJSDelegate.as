package com._17173.flash.player.business.stream.firstpage
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.core.video.interfaces.IVideoPlayer;
	import com._17173.flash.player.context.BusinessJSDelegate;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	public class StreamFirstPageJSDelegate extends BusinessJSDelegate
	{
		public function StreamFirstPageJSDelegate()
		{
			super();
		}
		
		override public function startUp(param:Object):void {
			super.startUp(param);
			
			listen("setPlay", onPlayByCid);
			listen("togglePlay", onTogglePause);
		}
		
		private function onTogglePause():void {
			Debugger.log(Debugger.INFO, "从js调用首页播放器停止");
//			var v:IVideoPlayer = Global.videoManager.video;
			var v:IVideoPlayer = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video;
			if (v && v.video) {
				v.pause();
				v.stop();
			}
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_LOADING);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_LOADING);
		}
		
		protected function onPlayByCid(roomID:String):void {
			Debugger.log(Debugger.INFO, "从js调用进行直播播放,  room=", roomID);
			var obj:Object = Context.variables;
			if (Context.variables.hasOwnProperty("liveRoomId")) {
				if (roomID == Context.variables["liveRoomId"]) {
//					return;
				}
			}
//			Global.eventManager.send(PlayerEvents.BI_SWITCH_STREAM, {"roomID":roomID});
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_SWITCH_STREAM, {"roomID":roomID});
		}
		
		override protected function onEnd():void {
			super.onEnd();
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.VIDEO_FINISHED);
//			Global.eventManager.send(PlayerEvents.VIDEO_FINISHED);
		}
		
	}
}