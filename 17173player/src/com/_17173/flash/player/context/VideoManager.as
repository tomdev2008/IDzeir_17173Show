package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.video.BaseVideoManager;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.player.model.PlayerEvents;
	
	public class VideoManager extends BaseVideoManager implements IContextItem
	{
		public function VideoManager()
		{
			super();
			_videoData = new VideoData();
		}
		
		override public function init(videoData:IVideoData):void {
			super.init(videoData);
			
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_READY);
		}
		
		override protected function onVideoDimensionChanged():void {
			super.onVideoDimensionChanged();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_VIDEO_RESIZE);
		}
		
		/**
		 * 停止播放 
		 */		
		override protected function onVideoStopped():void {
			super.onVideoStopped();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_STOP);
		}
		
		/**
		 * 连上之后就已经开始下载了. 
		 */		
		override protected function onVideoConnected(data:Object = null):void {
			super.onVideoConnected();
			
			_source.stream.bufferTime = Context.getContext(ContextEnum.SETTING).loadToStart;
			
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_INIT);
		}
		
		/**
		 * 视频播放完成 
		 */		
		override protected function onVideoFinished():void {
			super.onVideoFinished();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_FINISHED);
		}
		
		override protected function onVideoPause(data:Object = null):void {
			super.onVideoPause();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_PAUSE);
		}
		
		override protected function onVideoResume():void {
			super.onVideoResume();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_RESUME);
		}
		
		override protected function onVideoBufferEmpty():void {
			if (_isFinished) return;
			super.onVideoBufferEmpty();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_BUFFER_EMPTY);
		}
		
		override protected function onVideoBufferFull():void {
			super.onVideoBufferFull();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_BUFFER_FULL);
		}
		
		override protected function onVideoStart():void {
			super.onVideoStart();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_START);
		}
		
		/**
		 * 视频开始播放.即metadata事件已经到达.
		 * 直播也会提供metadata事件. 
		 * @param info
		 */		
		override protected function onVideoReadyToPlay(info:Object):void {
			super.onVideoReadyToPlay(info);
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_LOADED, info);
		}
		
		override protected function onVideoSeek(data:Object):void {
			super.onVideoSeek(data);
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_SEEK, data);
		}
		
		override protected function onVideoSeekStart(data:Object):void {
			super.onVideoSeekStart(data);
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_SEEK_START);
		}
		
		override protected function onVideoBufferFlush():void {
			super.onVideoBufferFlush();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_BUFFER_FLUSH);
		}
		
		override protected function onVideoReadyFail():void {
			super.onVideoReadyFail();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_CAN_NOT_CONNECT);
		}
		
		override protected function onVideoNotFound():void {
			super.onVideoNotFound();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.VIDEO_NOT_FOUND);
		}
		
		override public function set volume(value:int):void {
			super.volume = value;
		}
		
		public function get contextName():String {
			return ContextEnum.VIDEO_MANAGER;
		}
		
		public function startUp(param:Object):void {
		}
		
	}
}