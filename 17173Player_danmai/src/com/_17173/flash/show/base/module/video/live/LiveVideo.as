package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.module.video.base.live.LiveManager;
	import com._17173.flash.show.base.module.video.base.live.LiveVideoManager;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 视频类 
	 * @author qiuyue
	 * 
	 */
	public class LiveVideo extends Sprite
	{
		/**
		 * 坐标 
		 */		
		private var _pointArray1:Array = [46,12,480,360,500,214,278,200];
		private var _e:IEventManager = null;
		/**
		 * 区别于其他LiveVideo，无任何意义，不要用于其他地方 
		 */		
		private var _index:int = 0;
		/**
		 *新手任务播放时间，领取奖励 
		 */		
//		private var _liveTime:int = 60 * 1000 * 40;
		
		/**
		 * 麦序，表示在主麦，1麦，2麦 
		 */		
		private var _micIndex:int = 1;
		/**
		 * loading圈 
		 */		
		private var _loadingIcon:LoadingIcon = null;
		
		private var _underLineSprite:Sprite = new Sprite();
		
		private var _videoSprite:Sprite = null;
		
		/**
		 * 音量条 
		 */		
		private var _volumePanel:LiveVolumePanel = null;
		private var _videoTitle:VideoTitle = null;
		/**
		 * 是否三麦 
		 */		
		private var _isSanMai:Boolean;
		
		private var _liveManager:LiveManager;
		public function LiveVideo(micIndex:int, index:int, isSanMai:Boolean)
		{
			super();
			this._isSanMai = isSanMai;
			this._index = index;
			this._micIndex = micIndex;
			_liveManager = new LiveManager(index);
			_e = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
			_e.listen(SEvents.SHOW_LIVE_VIDEO,showLiveVideo);
			_videoSprite = new Sprite();
			this.addChild(_videoSprite);
			_underLineSprite.x = this["_pointArray1"][0];
			_underLineSprite.y = this["_pointArray1"][1];
			this.addChild(_underLineSprite);
			this.addEventListener(MouseEvent.MOUSE_OVER,mouse_over);
			this.addEventListener(MouseEvent.MOUSE_OUT,mouse_out);
			
			_volumePanel = new LiveVolumePanel(_micIndex);
			_volumePanel.x = 510;
			_volumePanel.y = 200;
			_volumePanel.alpha = 0;
			this.addChild(_volumePanel);
			_volumePanel.visible = false;
		}
		
		private function mouse_over(e:MouseEvent):void{
			if(_volumePanel){
				TweenLite.killTweensOf(_volumePanel);
				_volumePanel.visible = true;
				TweenLite.to(_volumePanel,0.5,{"x":500,"alpha":1});
			}
		}
		
		private function mouse_out(e:MouseEvent):void{
			if(_volumePanel){
				TweenLite.killTweensOf(_volumePanel);
				TweenLite.to(_volumePanel,0.5,{"x":510,"alpha":0});
			}
		}
		
		
		/**
		 * 右上角 分辨率 图标 
		 */
		public function set loadingIcon(value:LoadingIcon):void
		{
			_loadingIcon = value;
			_loadingIcon.mouseEnabled = false;
		}
		
		/**
		 * 右上角 分辨率 图标 
		 */
		public function set videoTitle(value:VideoTitle):void
		{
			_videoTitle = value;
		}
		
		public function get videoData():Object
		{
			return _liveManager.videoData;
		}
		
		public function set videoData(value:Object):void
		{
			_liveManager.videoData = value;
		}
		
		/**
		 * 拉流管理类 
		 */
		public function get liveVideoManager():LiveVideoManager
		{
			return _liveManager.liveVideoManager;
		}
		
		public function get underLineSprite():Sprite
		{
			return _underLineSprite;
		}
		
		public function set underLineSprite(value:Sprite):void
		{
			_underLineSprite = value;
		}
		
		public function get micIndex():int
		{
			return _micIndex;
		}
		
		public function set micIndex(value:int):void
		{
			_micIndex = value;
		}
		
		public function get index():int
		{
			return _index;
		}
		/**
		 * loading加载图  
		 * @param isShow
		 * 
		 */		
		private function loading(isShow:int):void{
			
			_loadingIcon.x = _pointArray1[0] + int(_pointArray1[2]/2);
			_loadingIcon.y = _pointArray1[1] + int(_pointArray1[3]/2);
			
			if(isShow == 0){
				if(_loadingIcon){
					_loadingIcon.visible = false;
					_loadingIcon.stop();
				}
			}else{
				if(_loadingIcon){
					_loadingIcon.visible = true;
					_loadingIcon.play();
				}
			}
		}
		/**
		 * 是否显示loading图  
		 * @param data
		 * 
		 */		
		public function isShowLoading(data:Object):void{
			if(data){
				if(data.hasOwnProperty("index")){
					if(data.hasOwnProperty("isShow")){
						if(data.index == index){
							loading(data.isShow);
						}
					}
				}
				if(data.hasOwnProperty("micIndex")){
					if(data.hasOwnProperty("isShow")){
						if(data.micIndex == micIndex){
							loading(data.isShow);
						}
					}
				}
			}else{
				loading(0);
			}
		}
		
		
		/**
		 * 拉流成功 
		 * @param data
		 * 
		 */		
		private function showLiveVideo(data:Object): void
		{
			Debugger.log(Debugger.INFO,"(LiveVideo)","拉流连接成功")
			var dataIndex:int = data.index as int;
			var video:DisplayObject = data.video as DisplayObject;
			if(data.index == index){
				if(!_videoSprite.contains(video)){
					_videoSprite.addChild(video);
					video.x = this["_pointArray1"][0];
					video.y = this["_pointArray1"][1];
					video.width = this["_pointArray1"][2];
					video.height = this["_pointArray1"][3];
				}
				resetPauseBtn();
				updatePauseBtnMouse(true);
				_e.send(SEvents.UPDATE_SOUND_STATUS,{"order":micIndex});
				loading(0);
			}
//			Ticker.tick(_liveTime,taskComplete,1);
		}
		
//		private function taskComplete():void{
//			_e.send(SEvents.TASK_TIME_COMPLETE);
//		}
			/**
		 * 是否可以点击按钮
		 * @param _isConnected
		 * 
		 */		
		private function updatePauseBtnMouse(_isConnected:Boolean):void{
			if(_volumePanel){
				_volumePanel.updateBtnMouse(_isConnected);
			}
			
		}
		
		/**
		 * 暂停按钮是否可点击 true为可以
		 * @param bool
		 * 
		 */		
		public function changeConnected(bool:Boolean):void{
			updatePauseBtnMouse(bool);
		}
		
		/**
		 * 是否显示音量条 
		 * 
		 */		
		public function resetPauseBtn():void{
			if(_volumePanel){
				_volumePanel.resetPauseBtn();
			}
		}
		/**
		 * 声音状态改变 
		 * @param isMute
		 * 
		 */		
		public function changeSoundStatus(isMute:int):void{
			var soundNumber:Number = isMute == 1 ? 0: _volumePanel.volumeNumber/100;
			_liveManager.changeSound(soundNumber);
		}
		/**
		 * 改变声音 
		 * @param volume
		 * 
		 */		
		public function onLiveVolumeChange(volume:int,isMute:int):void{
			if(isMute == 0){
				var soundNumber:Number  = volume/100;
				_liveManager.changeSound(soundNumber);
			}
		}
		
		/**
		 * 是否显示视频清晰度 
		 * @param videoIndex
		 * 
		 */		
		public function isShowVideoTitle(videoIndex:int):void{
			if(videoIndex > 0 && _videoTitle.totalFrames >= videoIndex){
				_videoTitle.visible = true;
				_videoTitle.gotoAndStop(videoIndex);
			}else{
				_videoTitle.visible = false;
				_videoTitle.stop();
			}
			var pointArray:Array = this["_pointArray"+micIndex] as Array;
			if(_isSanMai){
				if(micIndex == 1){
					_videoTitle.x = pointArray[0] + 8 ;
					_videoTitle.y = pointArray[1] + 8;
				}else{
					_videoTitle.x = pointArray[0] + 5;
					_videoTitle.y = pointArray[1] + 5;
				}
			}else{
				_videoTitle.x = pointArray[0] +  pointArray[2] - _videoTitle.width - 8;
				_videoTitle.y = pointArray[1] + 8;
			}
		}
		
		/**
		 * 重连 
		 * 
		 */		
		public function reConnectLive():void{
			if(_volumePanel.pauseState){
				connectLive(false);
			}
		}
		public function connectLive(isClearVideo:Boolean = true):void{
			Debugger.log(Debugger.INFO,"(LiveVideo)","connectLive LiveVideo Play");
			updatePauseBtnMouse(false);
			_liveManager.live(isClearVideo);
			
		}
		
		public function clearVideo():void{
			Debugger.log(Debugger.INFO,"(LiveVideo)","清理视频画面");
			_liveManager.clearVideo();
			loading(0);
		}
		
		/**
		 * 关闭拉流
		 * 
		 */		
		public function endVideo():void	{
			clearVideo();
			Debugger.log(Debugger.INFO,"(LiveModule)"," endVideo"); 
			_volumePanel.visible = false;
			loading(0);
//			Ticker.stop(taskComplete);
		}
		
		/**
		 * 暂停 
		 * 
		 */		
		public function pause():void{
			if(_volumePanel.pauseState){
				loading(1);
				connectLive(false);
			}else{
				_liveManager.stopLiveVideoManager();
			}
		}
		
		/**
		 * 移动 
		 * 
		 */		
		public function move(micIndex:int):void{
			Debugger.log(Debugger.INFO,"(LiveVideo)","当前Index为"+_index,"当前麦为"+this.micIndex,"目标麦为"+micIndex);
			this.micIndex = micIndex;
			var pointArray:Array = this["_pointArray"+this.micIndex] as Array;
			this.x = _pointArray1[0];
			this.y = _pointArray1[1];
			
			
			_loadingIcon.x = _pointArray1[0] + int(_pointArray1[2]/2);
			_loadingIcon.y = _pointArray1[1] + int(_pointArray1[3]/2);
			
			if(_videoTitle){
				if(_isSanMai){
					if(micIndex == 1){
						_videoTitle.x = _pointArray1[0] + 8 ;
						_videoTitle.y = _pointArray1[1] + 8;
					}else{
						_videoTitle.x = _pointArray1[0] + 5;
						_videoTitle.y = _pointArray1[1] + 5;
					}
				}else{
					_videoTitle.x = _pointArray1[0] +  _pointArray1[2] - _videoTitle.width - 8;
					_videoTitle.y = _pointArray1[1] + 8;
				}
			}
		}
		
	}
}