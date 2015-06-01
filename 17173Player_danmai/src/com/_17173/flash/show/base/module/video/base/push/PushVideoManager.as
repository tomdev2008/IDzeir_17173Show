package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.video.BaseVideoManager;
	import com._17173.flash.show.base.context.errorrecord.ErrorRecordType;
	import com._17173.flash.show.base.module.responsetest.operation.StreamMessage;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 数据管理类
	 * @author qiuyue
	 * 
	 */	
	public class PushVideoManager extends BaseVideoManager
	{
		public function PushVideoManager()
		{
			super();
		}
		/**
		 * 点播源.
		 */		
		protected  override function prepSource():void {
			if(!_source){
				_source = new PushVideoSource();
			}
		}
		
		override public function dispose():void
		{
			if (_video){
				_video.stop();
			}
			if(_source){
				_source.close();
			}
			BandWidthListener.getInstance().clear();
		}
		
		
		override protected function onP2pFailed():void{
			super.onP2pFailed();
			rePush();
			sendError(ErrorRecordType.PUSH_STREAM_ERROR);
		}
		
		override protected function onP2pClosed():void{
			super.onP2pClosed();
			rePush();
			sendError(ErrorRecordType.PUSH_STREAM_CLOSE_ERROR);
		}
		
		override protected function onP2pRejected():void{
			super.onP2pRejected();
			rePush();
			sendError(ErrorRecordType.PUSH_STREAM_REJECTED_ERROR);
		}
		
		override protected function onConnectionFailed():void{
			super.onConnectionFailed();
			rePush();
			sendError(ErrorRecordType.PUSH_CONN_ERROR);
		}
		
		override protected function onConnectionRejected():void{
			super.onConnectionRejected();
			rePush();
			sendError(ErrorRecordType.PUSH_CONN_REJECTED_ERROR);
		}
		
		override protected function onConnectClosed():void{
			super.onConnectClosed();
			rePush();
			sendError(ErrorRecordType.PUSH_CONN_CLOSE_ERROR);
		}
		
		private function rePush():void{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.VIDEO_RE_PUSH);
			BandWidthListener.getInstance().clear();
		}
		
		/**
		 * 停止播放 
		 */		
		override protected function onVideoFinished():void{
			super.onVideoFinished();
			rePush();
		}
		
		/**
		 * 开始推流
		 */		
		override protected function onVideoPubilsh():void {
			super.onVideoPubilsh();
			(Context.getContext(EventManager.CONTEXT_NAME) as IEventManager).send(SEvents.CONNECT_STREAM_SUCCESS);
			if(VideoEquipmentManager.getInstance().mic && VideoEquipmentManager.getInstance().camera){
				var obj:Object = VideoEquipmentManager.getInstance().getStreamData();
				_source.stream.send("@setDataFrame", "onMetaData", {
					"audiocodecid":obj.ac,
					"audiosamplerate":obj.ar,
					"videocodecid":obj.vc,
					"framerate":obj.fr,
					"width":obj.wd,
					"height":obj.ht,
					"datarate":obj.dr
				});
			}
			BandWidthListener.getInstance().setNetStream(_source);
			//保存推流stream
			StreamMessage.stream = _source.stream;
		}
		
		/**
		 *发送错误统计 
		 * @param type 错误统计类型 ErrorRecordType中定义
		 * 
		 */		
		private function sendError(type:String):void{
			var info:Object = {inter:"",info:"",name:source.connectionURL+source.streamURL};
			Context.getContext(CEnum.EVENT).send(SEvents.ERROR_RECORD,{code:type,info:info});
		}
		
		private function testError():void{
			sendError(ErrorRecordType.PUSH_CONN_CLOSE_ERROR);
			sendError(ErrorRecordType.PUSH_CONN_REJECTED_ERROR);
			sendError(ErrorRecordType.PUSH_CONN_ERROR);
			sendError(ErrorRecordType.PUSH_STREAM_CLOSE_ERROR);
			sendError(ErrorRecordType.PUSH_STREAM_REJECTED_ERROR);
			sendError(ErrorRecordType.PUSH_STREAM_ERROR);
		}
	}
}