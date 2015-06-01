package com._17173.flash.player.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.model.PlayerVideoSize;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * 视频层. 
	 * @author shunia-17173
	 */	
	public class VideoLayer extends Sprite
	{
		
		private static const DOUBLE_CLICK_INTERVAL:int = 215;
		private var _doubleClickInterval:uint = 0;
		private var _allowDoubleClickCheck:Boolean = false;
		private var _preview:Pic = null;
		private var _tempAW:Number = 0;
		private var _tempTW:Number = 0;
		private var _videoStart:Boolean = false;
		/**
		 * 水印
		 */		
		private var _waterMark:ISkinObject = null;
		/**
		 * 视频加载时出现的loading圈 
		 */		
		private var _loading:ISkinObject = null;
		
		public function VideoLayer()
		{
			super();
			
			_allowDoubleClickCheck = true;
			addEventListener(MouseEvent.CLICK, onVideoClickHandler);
			
//			_loading = Global.skinManager.attachSkinByName(SkinsEnum.LOADING, this);
			_loading = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.LOADING, this);
			
			resize();
			addEventListeners();
		}
		
		private function addEventListeners():void {
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.UI_HIDE_PREVIDEW_PAGE, hidePreview);
			eventManager.listen(PlayerEvents.UI_SHOW_PREVIDEW_PAGE, initPreview);
			eventManager.listen(PlayerEvents.VIDEO_INIT, videoInit);
			eventManager.listen(PlayerEvents.VIDEO_LOADED, resize);
			eventManager.listen(PlayerEvents.UI_RESIZE, resize);
			eventManager.listen(PlayerEvents.UI_VIDEO_RESIZE, resize);
			eventManager.listen(PlayerEvents.UI_INTED, onModuleComplete);
			eventManager.listen(PlayerEvents.VIDEO_START, videoStart);
			eventManager.listen(PlayerEvents.VIDEO_FINISHED, videoFinished);
			eventManager.listen(PlayerEvents.VIDEO_NOT_FOUND, videoFinished);
		}
		
		private function initPreview(url:String):void {
			if (Util.validateStr(url) == false) {
				return;
			}
			if (_preview && contains(_preview)) {
				removeChild(_preview);
				_preview = null;
			}
			
			_preview = new Pic();
			addChild(_preview);
			
			if(_preview && contains(_preview)) {
				_preview.visible = true;
				_preview.buttonMode = true;
				_preview.width = Context.stage.stageWidth;
//				_preview.height = Context.stage.stageHeight - Global.uiManager.bottomBarHeight;
				_preview.height = Context.stage.stageHeight - Context.getContext(ContextEnum.UI_MANAGER).bottomBarHeight;
				_preview.content = url;
			}
		}
		
		private function hidePreview(data:Object):void {
			if (_preview && contains(_preview) && _preview.visible) {
				_preview.visible = false;
				removeChild(_preview);
			}
		}
		
		private function videoInit(data:Object):void {
			_videoStart = false;
//			if (Global.videoManager && Global.videoManager.video && Global.videoManager.video.video) {
//				addChildAt(Global.videoManager.video.video, 0);
//			}
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video.video) {
				addChildAt((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video.video, 0);
			}
			if (_waterMark && _waterMark.display && contains(_waterMark.display)) {
				//清除水印
				_waterMark.display.visible = false;
			}
		}
		
		/**
		 * 视频区域鼠标点击事件解析.判断是双击或者单击以应对不同处理逻辑.
		 *  
		 * @param event
		 */		
		protected function onVideoClickHandler(event:MouseEvent):void {
			if (_allowDoubleClickCheck) {
				if (_doubleClickInterval) {
					//double clicked
					clearInterval(_doubleClickInterval);
					_doubleClickInterval = 0;
					
					onDoubleClick();
				} else {
					_doubleClickInterval = setInterval(function ():void {
						clearInterval(_doubleClickInterval);
						_doubleClickInterval = 0;
						onSingleClick();
					}, DOUBLE_CLICK_INTERVAL);
				}
			} else {
				onSingleClick();
			}
		}
		
		/**
		 * 双击视频区域. 
		 */		
		private function onDoubleClick():void {
//			Global.eventManager.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_TOGGLE_FULL_SCREEN, null, null, true);
		}
		
		/**
		 * 单击视频区域. 
		 */		
		private function onSingleClick():void {
			//非直播则增加点击视频暂停的功能
//			Global.eventManager.send(PlayerEvents.UI_PLAY_OR_PAUSE, !Global.videoManager.isPlaying);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_PLAY_OR_PAUSE, !(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying);
		}
		
		/**
		 * flash大小改变. 
		 */		
		private function resize(data:Object = null):void {
			resizeLoading();
//			var tw:Number = Global.uiManager.avalibleVideoWidth;
//			var th:Number = Global.uiManager.avalibleVideoHeight;
			var tw:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			var th:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, tw, th);
			this.graphics.endFill();
			
			if(_preview && contains(_preview)) {
				_preview.width = tw;
				_preview.height = th;
			}
			
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (v && v.video) {
				var aw:Number = 0;
				var ah:Number = 0;
//				var currentVideoScale:int = Global.settings.videoScale;
				var currentVideoScale:int = Context.getContext(ContextEnum.SETTING)["videoScale"];
				
				//退出全屏，回复原始播放比例
				if (Context.stage.displayState == StageDisplayState.NORMAL) {
//					currentVideoScale = Settings.VIDEO_SCALES[Settings.VIDEO_SIZE_100];
					currentVideoScale = PlayerVideoSize.VIDEO_SCALES[PlayerVideoSize.VIDEO_SIZE_100];
				}
				
//				if (currentVideoScale == Settings.VIDEO_SIZE_ORIGINAL) {
				if (currentVideoScale == PlayerVideoSize.VIDEO_SIZE_ORIGINAL) {
					aw = v.originalWidth;
					ah = v.originalHeight;
//				} else if (currentVideoScale == Settings.VIDEO_SIZE_FULL) {
				} else if (currentVideoScale == PlayerVideoSize.VIDEO_SIZE_FULL) {
					aw = tw;
					ah = th;
				} else {
					//保持高宽比填满
					var scaleX:Number = tw / v.originalWidth;
					var scaleY:Number = th / v.originalHeight;
					scaleX = scaleY = scaleX < scaleY ? scaleX : scaleY;
					//算出最大高宽
					var maxW:Number = v.originalWidth * scaleX;
					var maxH:Number = v.originalHeight * scaleY;
//					if (currentVideoScale == Settings.VIDEO_SIZE_FIT || 
//						currentVideoScale == Settings.VIDEO_SIZE_100) {
					if (currentVideoScale == PlayerVideoSize.VIDEO_SIZE_FIT || 
						currentVideoScale == PlayerVideoSize.VIDEO_SIZE_100) {
						aw = maxW;
						ah = maxH;
					} else {
						switch (currentVideoScale) {
//							case Settings.VIDEO_SIZE_50 : 
							case PlayerVideoSize.VIDEO_SIZE_50 : 
								aw = maxW * 0.5;
								ah = maxH * 0.5;
								break;
//							case Settings.VIDEO_SIZE_75 : 
							case PlayerVideoSize.VIDEO_SIZE_75 : 
								aw = maxW * 0.75;
								ah = maxH * 0.75;
								break;
						}
					}
				}
//				Global.videoManager.video.resize(int(aw), int(ah));
//				Global.videoManager.video.center(int(tw), int(th));
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video.resize(int(aw), int(ah));
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video.center(int(tw), int(th));
				_tempAW = int(aw);
				_tempTW = int(tw);
				//因为水印的位置是跟视频的位置有关系，所以需要在这里处理，而不是在视频添加的地方处理
				showWaterMart();
			}
		}
		
		/**
		 * 模块获取结束，开始加载水印
		 */		
		private function onModuleComplete(data:Object):void {
			showWaterMart();
		}
		
		/**
		 * 判断，并且加载水印
		 */		
		private function showWaterMart():void {
			var vm:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (!vm || !vm.video || !vm.video.video || !contains(vm.video.video) || Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_5 || !_videoStart || vm.video.video.width <= 0) {
				return;
			}
//			Debugger.log(Debugger.INFO, "[videoLayer]", "showWaterMart:" + _videoStart + "   " + Context.stage.stageWidth);
			//视频水印、目前只有在直播站外才有
			if (Context.variables["UIModuleData"] && Context.variables["UIModuleData"]["m3"]) {
				if (!_waterMark) {
//					_waterMark = Global.skinManager.attachSkinByName(SkinsEnum.WATER_MARK, this);
					_waterMark = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.WATER_MARK, this);
				}
				setChildIndex(_waterMark.display, this.numChildren - 1);
				_waterMark.display.visible = true;
				_waterMark.display.x = _tempAW - _waterMark.display.width - 10 + (_tempTW - _tempAW) / 2;//当前视频的宽度-水印宽度-10像素偏移- 视频的实际x坐标
				_waterMark.display.y = getWaterMarkY(); 
			}
		}
		
		/**
		 * 根据不同的情况获取水印的y坐标
		 */		
		private function getWaterMarkY():Number {
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER);
			var tempH:int = 38;//38是站外播放器搜索条的高度
			if (v.video.y > tempH) {
				return v.video.y + 10;
			} else {
				return tempH;
			}
		}
		
		/**
		 * 清空显示对象 
		 */		
		public function clear():void {
			while (numChildren) {
				removeChildAt(0);
			}
		}
		
		private function videoStart(data:Object):void {
			_videoStart = true;
			showWaterMart();
		}
		
		/**
		 * 视频结束清除水印显示水印 
		 */		
		protected function videoFinished(data:Object):void {
			Debugger.log(Debugger.INFO, "[videoLayer]", "videoFinished");
			_videoStart = false;
			if (_waterMark && _waterMark.display) {
				_waterMark.display.visible = false;
			}
		}
		
		private function resizeLoading():void {
			_loading.display.x = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth - 73) / 2;
			_loading.display.y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - 73) / 2;
//			_loading.display.x = (Global.uiManager.avalibleVideoWidth - 73) / 2;
//			_loading.display.y = (Global.uiManager.avalibleVideoHeight - 73) / 2;
		}
		
	}
}