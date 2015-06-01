package com._17173.flash.show.base.module.video.base.live
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	public class LiveManager
	{
		private var _index:int = 0;
		private var _liveVideoManager:LiveVideoManager =new LiveVideoManager;
		/**
		 * 获取调度Manager
		 */		
		private var _gslbManager:LiveGslbManager  = null;
		private var _videoData:Object = {};
		private var _e:IEventManager = null;
		private var _isClearVideo:Boolean = true;
		public function LiveManager(index:int)
		{
			this._index = index;
			_e = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
		}
		
		/**
		 * 区别于其他LiveVideo，无任何意义，不要用于其他地方 
		 */
		public function get index():int
		{
			return _index;
		}
		
		public function get liveVideoManager():LiveVideoManager
		{
			return _liveVideoManager;
		}
		
		public function set liveVideoManager(value:LiveVideoManager):void
		{
			_liveVideoManager = value;
		}
		
		/**
		 * 拉流 cid，ckey，name，cdntype 
		 */
		public function get videoData():Object
		{
			return _videoData;
		}
		
		/**
		 * @private
		 */
		public function set videoData(value:Object):void
		{
			_videoData = value;
		}
		
		public function live(isClearVideo:Boolean):void{
			_isClearVideo = isClearVideo;
			startGslb();
		}
		
		public function stopLiveVideoManager():void{
			_liveVideoManager.stop();
		}
		
		public function clearVideo():void{
			if(!VideoEquipmentManager.getInstance().isPluginSelected){
				_liveVideoManager.stop();
			}
			if(_liveVideoManager.video && _liveVideoManager.video.video){
				(_liveVideoManager.video.video as Video).clear();
				_liveVideoManager.video.video.visible = false;
			}
		}
		
		/**
		 * @param 音量值
		 * 
		 */		
		public function changeSound(volumeNumber:Number):void{
			var st : SoundTransform = new SoundTransform();
			st.volume = volumeNumber;
			if(_liveVideoManager && _liveVideoManager.source && _liveVideoManager.source.stream){
				_liveVideoManager.source.stream.soundTransform = st;
			}
		}
		
		
		/**
		 * 链接拉流 
		 * @param ct
		 * 
		 */		
		private function startGslb():void{
			if(videoData.cId != null && videoData.ckey != null && videoData.name != null && videoData.cdntype != null){
				_gslbManager = new LiveGslbManager();
				_gslbManager.live(videoData.cId, videoData.ckey, videoData.name, videoData.cdntype, gslbSucc, gslbFail);
			}
			
		}
		
		/**
		 * 获取调度成功 
		 * @param data
		 * 
		 */		
		private function gslbSucc(data:Object):void
		{
			startLive(data);
		}
		/**
		 * 获取调度失败 
		 * @param data
		 * 
		 */		
		private function gslbFail():void
		{
			(Context.getContext(CEnum.UI) as IUIManager).popupAlert("提示","获取调度失败，请刷新界面",-1,Alert.BTN_OK)
		}
		
		
		/**
		 * 开始拉流
		 * 
		 */		
		private function startLive(data:Object):void
		{
			addProviderEvent();
			_liveVideoManager.index = index;
			var baseVideoData:LiveVideoData = new LiveVideoData();
			baseVideoData.connectionURL = data.connectionURL;
			baseVideoData.streamName = data.streamName;
			baseVideoData.cId = videoData.cId;
			baseVideoData.ckey = videoData.ckey;
			baseVideoData.name = videoData.name;
			baseVideoData.cdntype = videoData.cdntype;
			baseVideoData.optimal = data.optimal;
			_liveVideoManager.init(baseVideoData);
			
		}
		
		private function addProviderEvent():void
		{
			removeProviderEvent();
			_e.listen(SEvents.LIVE_CONNECTED+index, onConnected);
			_e.listen(SEvents.LIVE_DISCONNECTED+index, onDisConnected);
		}
		
		private function removeProviderEvent():void
		{
			_e.remove(SEvents.LIVE_CONNECTED+index, onConnected);
			_e.remove(SEvents.LIVE_DISCONNECTED+index, onDisConnected);
		}
		
		
		/**
		 * 拉流成功 
		 * @param data
		 * 
		 */		
		private function onConnected(data:Object): void
		{
			removeProviderEvent();
			if(_isClearVideo){
				(_liveVideoManager.video.video as Video).clear();
			}
			_liveVideoManager.video.video.visible = true;
			_e.send(SEvents.SHOW_LIVE_VIDEO,{"index":index, "video":_liveVideoManager.video.video});
		}
		
		/**
		 *  拉流失败，重连
		 * @param data
		 * 
		 */		
		private function onDisConnected(data:Object): void
		{
			Debugger.log(Debugger.INFO,"(LiveVideo)","DisConnected LiveVideo Play");
			live(true);
		}
		
	}
}