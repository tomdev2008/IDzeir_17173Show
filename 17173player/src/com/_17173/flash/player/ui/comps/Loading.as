package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	/**
	 * 视频加载进度控件
	 *  
	 * @author shunia-17173
	 */	
	public class Loading extends Sprite
	{
		
		private var _loading:MovieClip = null;
		
		public function Loading()
		{
			super();
			
			_loading = loadingMC;
			addChild(_loading);
			_loading.visible = false;
			_loading.gotoAndStop(1);
			
			var e:IEventManager = _(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.listen(PlayerEvents.VIDEO_BUFFER_EMPTY, onInit);
			e.listen(PlayerEvents.VIDEO_START, onInit);
			e.listen(PlayerEvents.VIDEO_BUFFER_FULL, onRemove);
			e.listen(PlayerEvents.VIDEO_NOT_FOUND, onRemove);
			e.listen(PlayerEvents.VIDEO_FINISHED, onRemove);
			e.listen(PlayerEvents.VIDEO_CAN_NOT_CONNECT, onRemove);
			e.listen(PlayerEvents.VIDEO_STOP, onRemove);
			e.listen(PlayerEvents.REINIT_VIDEO, onRemove);
			e.listen(PlayerEvents.BI_PLAYER_INITED, onInit);
			e.listen(PlayerEvents.VIDEO_PAUSE, onRemove);
			
			e.listen(PlayerEvents.UI_SHOW_LOADING, onInit);
			e.listen(PlayerEvents.UI_HIDE_LOADING, onRemove);
		}
		
		protected function get loadingMC():MovieClip {
			return new mc_loading();
		}
		
		private function onInit(data:Object = null):void {
			Ticker.stop(checkLoadingProgress);
			onShow();
			Ticker.tick(1, checkLoadingProgress, 0, true);
		}
		
		private function onRemove(data:Object = null):void {
			Ticker.stop(checkLoadingProgress);
			onHide();
		}
		
		private function onShow(data:Object = null):void {
			if (_loading.visible == false) {
//				Global.eventManager.send("showLoading");
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send("showLoading");
				_loading.visible = true;
				_loading.gotoAndPlay(1);
			}
		}
		
		private function checkLoadingProgress():void {
//			var videoManager:IVideoManager = Global.videoManager as IVideoManager;
			var videoManager:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager
			if (videoManager && videoManager.isFinished) {
				onRemove();
				return;
			}
			if (Context.variables["showRec"]) {
				onRemove();
				return;
			}
			var loaded:Number = videoManager.data.loadedTime;
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			var p:int = loaded / settings.loadToStart * 100;
			_loading["text"] = int(p);
//			trace("loaded time: " + loaded + ",loading progress: " + p);
//			Debugger.tracer("loaded time: " + loaded + ",loading progress: " + p);
			if (loaded <= 0.1) {
				onShow();
			} else if (p >= 99) {
				_loading["text"] = 100;
				onHide();
//				Global.eventManager.send(PlayerEvents.VIDEO_LOADING_GET_100);
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.VIDEO_LOADING_GET_100);
			}
		}
		
		private function onHide():void {
			if (_loading.visible == true) {
//				Global.eventManager.send("hideLoading");
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send("hideLoading");
				_loading.visible = false;
				_loading.gotoAndStop(1);
				_loading["text"] = 0;
			}
		}
		
	}
}