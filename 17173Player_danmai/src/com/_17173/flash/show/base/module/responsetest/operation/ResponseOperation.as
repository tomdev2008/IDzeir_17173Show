package com._17173.flash.show.base.module.responsetest.operation
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.source.VideoSourceInfo;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.utils.getTimer;

	public class ResponseOperation
	{
		private static const  BAIDU:String = "baidu";
		private static const  CDN:String = "cdn";
		private static const  SERVER:String = "server";
		
		
		
		private var _resVO:ResponseVo;
		private var _index:Number=0;
		private var _urlArray:Array;
		private var _starTime:int = 0;
		private var _current:Object;
		private var _currentBytes:Number;
		
		public function ResponseOperation(resVO:ResponseVo)
		{
			_resVO=resVO;
			creatUrlPool();
		}
        
		/**
		 * 创建推拉流Http 协议URL地址 
		 * 
		 */		
		private function creatUrlPool():void
		{
			var showData:ShowData = Context.variables["showData"] as ShowData;
			_resVO.roomId = showData.liveInfo.masterNo;
			
			_urlArray = new Array();
			//静态地址
			_urlArray.push({"type":BAIDU,"url":"http://v.17173.com/servercheck.html"});

			if(_resVO.mode == "push")
			{
				_urlArray.push({"type":SERVER,"url":SEnum.GSLB_PUSH_URL}); //推流调度服务地址
				if(showData.pushVideoData)
				{	
					_resVO.cdnUrl = showData.pushVideoData.connectionURL; //推流地址
					//cdn推流地址rtmp://push.cdn3.v.17173.com:1935/slive/483902_1411627562816
					//_urlArray.push({"type":CDN,"connectionURL":showData.pushVideoData.connectionURL,"streamURL":showData.pushVideoData.streamName});	
				}
			}
			else
			{
				_urlArray.push({"type":SERVER,"url":SEnum.GSLB_LIVE_URL});//拉流调度服务地址
				if(showData.liveVideoData)
				{
					//cdn调度地址
					//_urlArray.push({"type":CDN,"url":showData.liveVideoData.ip});
					//cdn流地址
					//_urlArray.push({"type":CDN,"connectionURL":showData.liveVideoData.connectionURL,"streamURL":showData.liveVideoData.streamName});
					_resVO.streamName = showData.liveVideoData.streamName;					
				}	
			}
			if(_index<_urlArray.length)
			       testUrlResponse();
		}
		
		private function testUrlResponse():void
		{		
			if(_index<_urlArray.length)
			{
				_current = _urlArray[_index];
				_index++;
				_starTime = getTimer();
				
				if(_current.hasOwnProperty("url"))
				{
					var httProxy:HttpProxy = new HttpProxy();
					httProxy.start(_current.url,httpStatusHandler,ioErrorHandler);
				}/*else if(_current.hasOwnProperty("connectionURL"))
				{
					var streamProxy:StreamProxy = new StreamProxy();
					streamProxy.start(_current.connectionURL,_current.streamURL,streamInvoke);
				}*/
			}
			else
			{
				if(StreamMessage.stream)
				{
					_currentBytes = StreamMessage.stream.bytesLoaded;
					Ticker.tick(2000,loadSpeed,1);
				}
			}
		}
		/**
		 * netstream 链接回调函数 
		 * @param type
		 * @param data
		 * 
		 */		
		private function streamInvoke(type:String, data:Object = null):void
		{
			if(type == VideoSourceInfo.START)
			{
				_resVO.cdnhostTime =  getTimer() - _starTime;
				if(StreamMessage.stream)
				{
					_currentBytes = StreamMessage.stream.bytesLoaded;
					Ticker.tick(1000,loadSpeed,1);
				}	
			}else if(type == VideoSourceInfo.STREAM_NOT_FOUND || type ==  VideoSourceInfo.P2P_FAILED || type == VideoSourceInfo.STOP || type == VideoSourceInfo.P2P_CLOSED)
				sendResult();
		}
		
		private function loadSpeed():void
		{
			_resVO.cdnhostBytes = Math.round(StreamMessage.stream.bytesLoaded - _currentBytes)/2000;
			if(_resVO.mode=="push")
				_resVO.cdnhostBytes = -1;
			sendResult();
		}
		
		/**
		 * http通信错误处理 
		 * @param event
		 * 
		 */		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			var msg:String = event.text;
			if(msg)
			_resVO.cdnUrl = msg.substr(msg.indexOf("http://"),msg.length);
			//_resVO.cdnUrl = msg;
			Debugger.log(Debugger.INFO, "[ResponseTest]", "错误返回CDN Host 地址", msg);
		}
		
		/**
		 * http通信状态码
		 * @param event
		 * 
		 */	
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			Debugger.log(Debugger.INFO, "[ResponseTest]", "访问服务地址", _current.url);
			var time:Number = getTimer() - _starTime;
		     switch(_current.type)
			 {
				 case BAIDU:
				 {
					 _resVO.baiduTime = time;
					 break;
				 }
				 case CDN:
				 {
					 _resVO.cdnTime = time;
					 break;
				 }
				 case SERVER:
				 {
					 _resVO.glsbTime = time;
					 break;
				 }
			 }

			 testUrlResponse();
		}
		/**
		 * 格式化结果格式 
		 * 
		 */		
		private function sendResult():void
		{
			var result:Object=new Object();
			result.userId = _resVO.userId;
			result.mode = _resVO.mode;
			result.servercheck = _resVO.baiduTime;
			result.glsbTime = _resVO.glsbTime;
			result.cdnTime = _resVO.cdnTime;
			result.roomId = _resVO.roomId;
			result.streamName = _resVO.streamName;
			//result.cdnUrl = _resVO.cdnUrl;
			//result.cdnhostTime = _resVO.cdnhostTime;
			result.cdnhostBytes = _resVO.cdnhostBytes;
			var e:IEventManager = Context.getContext(EventManager.CONTEXT_NAME) as IEventManager;
			e.send(SEvents.SEND_QM,{"id":"responsetest","info":result});
		}
	}
}