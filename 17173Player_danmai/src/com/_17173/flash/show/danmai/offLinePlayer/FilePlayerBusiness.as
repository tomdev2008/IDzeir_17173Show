package com._17173.flash.show.danmai.offLinePlayer
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.show.model.CEnum;
	
	import flash.media.Video;

	/**
	 * 单麦房 
	 * @author 安庆航
	 * 
	 */	
	public class FilePlayerBusiness
	{
		private var _video:Video = null;
		
		private var _cid:String = "";
		
		private var _fileData:FilePlayerVideoData = null;
		
		private var _videoManager:FileVideoManager = null;
		
		private var _fdr:FilePlayerDataRetriver = null;
		
		private var _videoParent:Object = null;
		private var _videoWidth:Number = 100;
		private var _videoHeight:Number = 100;
		private var _videoX:int = 0;
		private var _videoY:int = 0;
		
		private var _isPause:Boolean = false;
		/**
		 * 是否自动连续播放
		 */		
		private var _autoLoop:Boolean = true;
		
		
		public function FilePlayerBusiness()
		{
			_video = new Video();
			_fileData = new FilePlayerVideoData();
			_videoManager = new FileVideoManager();
			_fdr = new FilePlayerDataRetriver();
			Context.variables["PlayerFileVideoData"] = _fileData;
		}
		
		public function get isPause():Boolean
		{
			return _isPause;
		}

		/**
		 * 单麦离线录像启动方法
		 * @param cid
		 * 
		 */		
		public function start(cid:String):void {
			_cid = Base64.decodeStr(cid);
			init();
			_isPause = false;
		}
		
		private function init():void {
			_videoManager.stop();
			_fdr.startDispatch(_cid, onVideoDataRetrived, onVideoDataFail);
		}
		
		/**
		 * 视频调度已经获取 
		 * @param video
		 */		
		protected function onVideoDataRetrived(video:FilePlayerVideoData):void {
			_videoManager.init(video);
			_videoManager.togglePlay(true);
			_video = (_videoManager.video.video as Video);
			_video.visible = true;
			_video.width = videoWidth;
			_video.height = videoHeight;
			_video.x = videoX;
			_video.y = videoY;
			if (videoParent) {
				if (videoParent.contains(_video)) {
					videoParent.removeChild(_video);
				}
				videoParent.addChild(_video);
			}
			
			Context.getContext(CEnum.EVENT).listen(PlayerEvents.VIDEO_BUFFER_FULL, onBuffFull);
			Context.getContext(CEnum.EVENT).listen(PlayerEvents.VIDEO_FINISHED, onFinished);
		}
		
		/**
		 * 视频调度失败 
		 */		
		protected function onVideoDataFail(error:Object):void {
			Context.getContext(CEnum.EVENT).send(PlayerEvents.GET_VIDEO_DATA_ERROR);
		}
		
		/**
		 * 缓冲结束直接开始播放
		 */		
		private function onBuffFull(data:Object):void {
			if (!_videoManager.isPlaying) {
				_videoManager.togglePlay(true);
			}
		}
		
		/**
		 * 视频结束，从新开始播放
		 */		
		private function onFinished(data:Object):void {
			if (autoLoop) {
				_videoManager.replay();
			}
		}
		
		/**
		 * 播放
		 */		
		public function play():void {
			_videoManager.togglePlay(true);
			_isPause = false;
		}
		
		/**
		 * 暂停
		 */		
		public function pause():void {
			_videoManager.togglePlay(false);
			_isPause = true;
		}
		
		/**
		 * 停止视频
		 */		
		public function stop():void {
			_video.visible = false;
			_videoManager.stop();
			_isPause = false;
		}
		
		public function setVolum(value:int):void {
			_videoManager.volume = value;
			Context.variables["PlayerFileVideoVolume"] = value;
		}
		
		public function set autoLoop(value:Boolean):void
		{
			_autoLoop = value;
		}

		/**
		 * 是否自动连续播放
		 */
		public function get autoLoop():Boolean
		{
			return _autoLoop;
		}

		/**
		 * video的宽
		 */
		public function get videoWidth():Number
		{
			return _videoWidth;
		}

		/**
		 * @private
		 */
		public function set videoWidth(value:Number):void
		{
			_videoWidth = value;
		}

		/**
		 * video的高
		 */
		public function get videoHeight():Number
		{
			return _videoHeight;
		}

		/**
		 * @private
		 */
		public function set videoHeight(value:Number):void
		{
			_videoHeight = value;
		}

		/**
		 * video添到父容器的x
		 */
		public function get videoX():int
		{
			return _videoX;
		}

		/**
		 * @private
		 */
		public function set videoX(value:int):void
		{
			_videoX = value;
		}

		/**
		 * video添到父容器的y
		 */
		public function get videoY():int
		{
			return _videoY;
		}

		/**
		 * @private
		 */
		public function set videoY(value:int):void
		{
			_videoY = value;
		}

		/**
		 * video被添加的容器
		 */
		public function get videoParent():Object
		{
			return _videoParent;
		}

		/**
		 * @private
		 */
		public function set videoParent(value:Object):void
		{
			_videoParent = value;
		}


	}
}