package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class BandWidthListener
	{
		private static var _instance:BandWidthListener = null;
		private var _netStream:NetStream = null;
		private var _conn:NetConnection = null;
		private var _e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
		private var lowIndex:int = 0;
		private var addIndex:int = 0;
		
		private var videoObj:Object = {};
		private var audioObj:Object = {};
		
		public function BandWidthListener()
		{
		}
		
		public static function getInstance():BandWidthListener{
			if(_instance == null){
				_instance = new BandWidthListener();
			}
			return _instance;
		}
		
		public function setNetStream(iVideoSource:IVideoSource):void{
			_netStream = iVideoSource.stream;
			_conn = iVideoSource.connection;
			Ticker.tick(200, dataUpdate, -1);
			Ticker.tick(5000, changeBandWidth, -1);
			restartObj();
		}
		
		public function clear():void{
			Ticker.stop(dataUpdate);
			Ticker.stop(changeBandWidth);
			restartObj();
		}
		
		private function restartObj():void{
			videoObj = new Object();
			videoObj["moreVideoData"] = 0;
			videoObj["videoData"] = 0;
			audioObj = new Object();
			audioObj["moreAudioData"] = 0;
			audioObj["audioData"] = 0;
		}
		
		private function changeBandWidth():void{
//			trace(videoObj["moreVideoData"] / (videoObj["moreVideoData"] + videoObj["videoData"]));
			if(videoObj["moreVideoData"] / (videoObj["moreVideoData"] + videoObj["videoData"]) > 0.1){
				_e.send(SEvents.BANDWIDTH_CHANGE, -100);
			}else{
				_e.send(SEvents.BANDWIDTH_CHANGE, 100);
			}
			restartObj();
		}
		
		private function dataUpdate():void{
			try
			{
				if(_conn && _conn.connected &&_netStream && _netStream.info){
					if(_netStream.info.videoBufferByteLength > 0){
						videoObj["moreVideoData"] +=1;
					}else{
						videoObj["videoData"] +=1;
					}
					
//					if(_netStream.info.audioBufferByteLength > 0){
//						audioObj["moreAudioData"] +=1;
//					}else{
//						audioObj["audioData"] +=1;
//					}
//					trace("videoObj.moreVideoData" + videoObj.moreVideoData);
//					trace("videoObj.videoData" + videoObj.videoData);
//					
//					trace("audioObj.moreAudioData" + audioObj.moreAudioData);
//					trace("audioObj.audioData" + audioObj.audioData);
					
//					if(_netStream.info.videoBufferByteLength > 1000 || _netStream.info.audioBufferByteLength > 500){
//						lowIndex++;
//						addIndex = 0;
//					}else{
//						lowIndex = 0;
//						addIndex++;
//					}
//					if(lowIndex >= 5){
//						_e.send(SEvents.BANDWIDTH_CHANGE, -1000);
//						lowIndex = 0;
//						addIndex = 0;
//					}
//					if(addIndex >= 5){
//						_e.send(SEvents.BANDWIDTH_CHANGE, 1000);
//						lowIndex = 0;
//						addIndex = 0;
//					}
				}else{
					clear();
				}
			} 
			catch(error:Error) 
			{
				clear();
			}
			
		}
	}
}