package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.core.video.source.BaseVideoSource;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 视频信息面板,通过加载QM模块后,用快捷键Ctrl+1调出
	 *  
	 * @author shunia-17173
	 */	
	public class VideoInfoPanel extends Sprite
	{
		
//		private var _clsBtn:MovieClip = null;
		
		private var _videoBR:TextField = null;
		private var _audioBR:TextField = null;
		private var _fps:TextField = null;
		private var _download:TextField = null;
		private var _streamStatus:TextField = null;
		private var _liveAddr:TextField = null;
		private var _bufferLength:TextField = null;
		private var _indexBR:TextField = null;
		
		private var _cameraWidthAndHeight:TextField = null;
		
		private var _w:Number = 320;
		private var _h:Number = 160;
		
		private var _lastBytes:int = 0;
		
		private var source:BaseVideoSource = null;
		
		private var index:int;
		
		private var _byteloaded:TextField = null;
		
		private var byteloaded:int = 0;
	
		private var _bytesLoaded:TextField = null;
		private var decodedFrames:TextField = null;
		private var videoBytesPerSecond:TextField = null;
		private var audioBytesPerSecond:TextField = null;
		private var loseRate:TextField = null;
		
		public function VideoInfoPanel(live:IVideoSource , index:int)
		{
			super();
			
			this.source = live as BaseVideoSource;
			graphics.beginFill(0xCCCCCC, .8);
			graphics.drawRect(0, 0, 320, 400);
			graphics.endFill();
			
//			_clsBtn = new mc_clsBtn();
//			_clsBtn.x = width - _clsBtn.width - 5;
//			_clsBtn.y = 5;
//			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
//			addChild(_clsBtn);
			
			var tf:TextField = packupTF();
			tf.text = "Index为: ";
			tf.x = 5;
			tf.y = 5;
			_indexBR = packupTF();
			_indexBR.x = tf.width + 3;
			_indexBR.y = tf.y;
			_indexBR.text = index.toString();
			
			tf = packupTF();
			tf.text = "播放速率: ";
			tf.x = 5;
			tf.y =  _indexBR.y + _indexBR.height + 5;;
			_videoBR = packupTF();
			_videoBR.x = tf.width + 3;
			_videoBR.y = tf.y;
			
			
			tf = packupTF();
			tf.text = "视频缓冲区速率: ";
			tf.x = 5;
			tf.y = _videoBR.y + _videoBR.height + 5;
			videoBytesPerSecond = packupTF();
			videoBytesPerSecond.x = tf.width + 3;
			videoBytesPerSecond.y = tf.y;
			videoBytesPerSecond.wordWrap = true;
			videoBytesPerSecond.multiline = true;
			videoBytesPerSecond.width = 235;
			
			tf = packupTF();
			tf.text = "音频缓冲区速率: ";
			tf.x = 5;
			tf.y = videoBytesPerSecond.y + videoBytesPerSecond.height + 5;
			audioBytesPerSecond = packupTF();
			audioBytesPerSecond.x = tf.width + 3;
			audioBytesPerSecond.y = tf.y;
			audioBytesPerSecond.wordWrap = true;
			audioBytesPerSecond.multiline = true;
			audioBytesPerSecond.width = 235;
			
			
			
			tf = packupTF();
			tf.text = "丢掉帧数: ";
			tf.x = 5;
			tf.y = audioBytesPerSecond.y + audioBytesPerSecond.height + 5;
			_audioBR = packupTF();
			_audioBR.x = tf.width + 3;
			_audioBR.y = tf.y;
			
			tf = packupTF();
			tf.text = "当前视频帧数: ";
			tf.x = 5;
			tf.y = _audioBR.y + _audioBR.height + 5;
			_fps = packupTF();
			_fps.x = tf.width + 3;
			_fps.y = tf.y;
			
			tf = packupTF();
			tf.text = "当前下载速率: ";
			tf.x = 5;
			tf.y = _fps.y + _fps.height + 5;
			_download = packupTF();
			_download.x = tf.width + 3;
			_download.y = tf.y;
			
			tf = packupTF();
			tf.text = "当前流状态: ";
			tf.x = 5;
			tf.y = _download.y + _download.height + 5;
			_streamStatus = packupTF();
			_streamStatus.x = tf.width + 3;
			_streamStatus.y = tf.y;
			
			tf = packupTF();
			tf.text = "缓冲时间: ";
			tf.x = 5;
			tf.y = _streamStatus.y + _streamStatus.height + 5;
			_bufferLength = packupTF();
			_bufferLength.x = tf.width + 3;
			_bufferLength.y = tf.y;
			_bufferLength.wordWrap = true;
			_bufferLength.multiline = true;
			_bufferLength.width = 235;
			
			
			tf = packupTF();
			tf.text = "已加载字节: ";
			tf.x = 5;
			tf.y = _bufferLength.y + _bufferLength.height + 5;
			_bytesLoaded = packupTF();
			_bytesLoaded.x = tf.width + 3;
			_bytesLoaded.y = tf.y;
			_bytesLoaded.wordWrap = true;
			_bytesLoaded.multiline = true;
			_bytesLoaded.width = 235;
			
			tf = packupTF();
			tf.text = "decodedFrames: ";
			tf.x = 5;
			tf.y = _bytesLoaded.y + _bytesLoaded.height + 5;
			decodedFrames = packupTF();
			decodedFrames.x = tf.width + 3;
			decodedFrames.y = tf.y;
			decodedFrames.wordWrap = true;
			decodedFrames.multiline = true;
			decodedFrames.width = 235;
			
			
			tf = packupTF();
			tf.text = "视频损失率: ";
			tf.x = 5;
			tf.y = decodedFrames.y + decodedFrames.height + 5;
			loseRate = packupTF();
			loseRate.x = tf.width + 3;
			loseRate.y = tf.y;
			loseRate.wordWrap = true;
			loseRate.multiline = true;
			loseRate.width = 235;
			
			
			tf = packupTF();
			tf.text = "摄像头宽高:";
			tf.x = 5;
			tf.y = loseRate.y + loseRate.height + 5;
			_cameraWidthAndHeight = packupTF();
			_cameraWidthAndHeight.x = tf.width + 3;
			_cameraWidthAndHeight.y = tf.y;
			_cameraWidthAndHeight.wordWrap = true;
			_cameraWidthAndHeight.multiline = true;
			_cameraWidthAndHeight.width = 235;
			
			
			tf = packupTF();
			tf.text = "当前流地址: ";
			tf.x = 5;
			tf.y = _cameraWidthAndHeight.y + _cameraWidthAndHeight.height + 5;
			_liveAddr = packupTF();
			_liveAddr.x = tf.width + 3;
			_liveAddr.y = tf.y;
			_liveAddr.wordWrap = true;
			_liveAddr.multiline = true;
			_liveAddr.width = 235;
			
			
			var _close:DisplayObject = createClsBtn();
			_close.addEventListener(MouseEvent.CLICK, onClose);
			_close.x = width - _close.width;
			_close.y = 0;
			this.addChild(_close);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function createClsBtn():DisplayObject {
			var b:Sprite = new Sprite();
			b.buttonMode = true;
			b.useHandCursor = true;
			
			b.graphics.beginFill(0x333333, 1);
			b.graphics.drawRect(0, 0, 30, 30);
			b.graphics.lineStyle(3, 0xFFFFFF, 1);
			b.graphics.moveTo(3, 3);
			b.graphics.lineTo(27, 27);
			b.graphics.moveTo(27, 3);
			b.graphics.lineTo(3, 27);
			b.graphics.endFill();
			
			return b;
		}
		
		protected function onClose(event:MouseEvent):void {
			if (parent) {
				parent.removeChild(this);
			}
			Ticker.stop(onUpdateStatus);
		}
		
		protected function onAdded(event:Event):void {
			_lastBytes = 0;
			Ticker.tick(1000, onUpdateStatus, 0);
		}
		
		private function onUpdateStatus():void {
			//视频数据
			try{
				var str:NetStream = null;
				if(source && source.stream){
					str = source.stream;
				}
				
				if(source && source.info){
					_cameraWidthAndHeight.text = source.info.width +"X" +source.info.height;
				}
				if (str) {
					if(source.currentVideoStatus){
						_streamStatus.text = source.currentVideoStatus;
					}
					if(source){
						_liveAddr.text = source.connectionURL + source.streamURL;
					}
					_bufferLength.text = str.bufferLength +"s";
					_fps.text = int(str.currentFPS) + " 帧/秒";
					_bytesLoaded.text = int((str.bytesLoaded - byteloaded)/1024) + "字节数";
					byteloaded = str.bytesLoaded;
					decodedFrames.text = str.decodedFrames +"";
					if (str.info) {
						_download.text = int(str.info.currentBytesPerSecond / 1000) + " KB/s";
						_videoBR.text = int(str.info.playbackBytesPerSecond / 1000 * 8) + " kbps";
						videoBytesPerSecond.text = int(str.info.videoBytesPerSecond / 1000 * 8) + " kbps";
						audioBytesPerSecond.text = int(str.info.audioBytesPerSecond / 1000 * 8) + " kbps";
						_audioBR.text = str.info.droppedFrames +"";
						loseRate.text = str.info.videoLossRate +"";
					}
				}
			}catch(e:Error){
				Debugger.log(Debugger.INFO,"[VideoInfoPanel]",e);
			}
			
		}
		
		private function packupTF():TextField {
			var tf:TextField = new TextField();
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 12, 0xFFFFFF);
			tf.defaultTextFormat = fmt;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = "-";
			addChild(tf);
			return tf;
		}
		
	}
}


