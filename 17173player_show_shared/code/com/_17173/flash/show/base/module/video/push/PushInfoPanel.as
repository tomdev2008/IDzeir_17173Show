package com._17173.flash.show.base.module.video.push
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
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	
	/**
	 * 视频信息面板,通过加载QM模块后,用快捷键Ctrl+1调出
	 *  
	 * @author shunia-17173
	 */	
	public class PushInfoPanel extends Sprite
	{
		private var _videoBR:TextField = null;
		private var _audioBR:TextField = null;
		private var _fps:TextField = null;
		private var _download:TextField = null;
		private var _streamStatus:TextField = null;
		private var _liveAddr:TextField = null;
		private var _bufferLength:TextField = null;
		private var _playbackBytesPerSecond:TextField = null;
		private var _bytesLoaded:TextField = null;
		private var decodedFrames:TextField = null;
		private var droppedFrames:TextField = null;
		private var currentBytesPerSecond:TextField = null;
		private var audioBufferByteLength:TextField = null;
		private var videoBufferByteLength:TextField = null;
		
		private var dataBufferByteLength:TextField = null;
		
		private var qualityIndex:TextField = null;
		
		private var bandWidth:TextField = null;
		
		private var byteloaded:int = 0;
		
		private var _w:Number = 320;
		private var _h:Number = 160;
		
		private var _lastBytes:int = 0;
		
		private var source:BaseVideoSource = null;
		
		public function PushInfoPanel(live:IVideoSource)
		{
			super();
			
			this.source = live as BaseVideoSource;
			graphics.beginFill(0xCCCCCC, .8);
			graphics.drawRect(0, 0, 320, 480);
			graphics.endFill();
			var tf:TextField = packupTF();
			tf.text = "提供 NetStream 视频损失率: ";
			tf.x = 5;
			tf.y = 5;
			_videoBR = packupTF();
			_videoBR.x = tf.width + 3;
			_videoBR.y = tf.y;
			
			
			tf = packupTF();
			tf.text = "当前视频帧数: ";
			tf.x = 5;
			tf.y = _videoBR.y + _videoBR.height + 5;
			_fps = packupTF();
			_fps.x = tf.width + 3;
			_fps.y = tf.y;
			
			tf = packupTF();
			tf.text = "摄像头高度：";
			tf.x = 5;
			tf.y = _fps.y + _fps.height + 5;
			_audioBR = packupTF();
			_audioBR.x = tf.width + 3;
			_audioBR.y = tf.y;
			
			
			tf = packupTF();
			tf.text = "摄像头宽度：";
			tf.x = 5;
			tf.y = _audioBR.y + _audioBR.height + 5;
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
			tf.text = "流的播放速率: ";
			tf.x = 5;
			tf.y = _bufferLength.y + _bufferLength.height + 5;
			_playbackBytesPerSecond = packupTF();
			_playbackBytesPerSecond.x = tf.width + 3;
			_playbackBytesPerSecond.y = tf.y;
			_playbackBytesPerSecond.wordWrap = true;
			_playbackBytesPerSecond.multiline = true;
			_playbackBytesPerSecond.width = 235;
			
			
			
			tf = packupTF();
			tf.text = "已加载字节: ";
			tf.x = 5;
			tf.y = _playbackBytesPerSecond.y + _playbackBytesPerSecond.height + 5;
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
			tf.text = "放弃的视频帧数: ";
			tf.x = 5;
			tf.y = decodedFrames.y + decodedFrames.height + 5;
			droppedFrames = packupTF();
			droppedFrames.x = tf.width + 3;
			droppedFrames.y = tf.y;
			droppedFrames.wordWrap = true;
			droppedFrames.multiline = true;
			droppedFrames.width = 235;
			
			tf = packupTF();
			tf.text = "填充缓冲区的速率: ";
			tf.x = 5;
			tf.y = droppedFrames.y + droppedFrames.height + 5;
			currentBytesPerSecond = packupTF();
			currentBytesPerSecond.x = tf.width + 3;
			currentBytesPerSecond.y = tf.y;
			currentBytesPerSecond.wordWrap = true;
			currentBytesPerSecond.multiline = true;
			currentBytesPerSecond.width = 235;
			
			tf = packupTF();
			tf.text = "视频缓冲区大小: ";
			tf.x = 5;
			tf.y = currentBytesPerSecond.y + currentBytesPerSecond.height + 5;
			videoBufferByteLength = packupTF();
			videoBufferByteLength.x = tf.width + 3;
			videoBufferByteLength.y = tf.y;
			videoBufferByteLength.wordWrap = true;
			videoBufferByteLength.multiline = true;
			videoBufferByteLength.width = 235;
			
			tf = packupTF();
			tf.text = "音频缓冲区大小: ";
			tf.x = 5;
			tf.y = videoBufferByteLength.y + videoBufferByteLength.height + 5;
			audioBufferByteLength = packupTF();
			audioBufferByteLength.x = tf.width + 3;
			audioBufferByteLength.y = tf.y;
			audioBufferByteLength.wordWrap = true;
			audioBufferByteLength.multiline = true;
			audioBufferByteLength.width = 235;
			
			tf = packupTF();
			tf.text = "缓冲区大小: ";
			tf.x = 5;
			tf.y = audioBufferByteLength.y + audioBufferByteLength.height + 5;
			dataBufferByteLength = packupTF();
			dataBufferByteLength.x = tf.width + 3;
			dataBufferByteLength.y = tf.y;
			dataBufferByteLength.wordWrap = true;
			dataBufferByteLength.multiline = true;
			dataBufferByteLength.width = 235;
			
			
			tf = packupTF();
			tf.text = "上限值: ";
			tf.x = 5;
			tf.y = dataBufferByteLength.y + dataBufferByteLength.height + 5;
			bandWidth = packupTF();
			bandWidth.x = tf.width + 3;
			bandWidth.y = tf.y;
			bandWidth.wordWrap = true;
			bandWidth.multiline = true;
			bandWidth.width = 235;
			
			
			tf = packupTF();
			tf.text = "当前流地址: ";
			tf.x = 5;
			tf.y = bandWidth.y + bandWidth.height + 5;
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
				if(VideoEquipmentManager.getInstance().isPluginSelected){
					_download.text = VideoEquipmentManager.getInstance().pluginCamera.width +"";
					_audioBR.text = VideoEquipmentManager.getInstance().pluginCamera.height +"";
				}else{
					_download.text = VideoEquipmentManager.getInstance().camera.width +"";
					_audioBR.text = VideoEquipmentManager.getInstance().camera.height +"";
				}
				var str:NetStream = null;
				if(source && source.stream){
					str = source.stream;
				}
				if (str) {
					if(source && source.currentVideoStatus){
						_streamStatus.text = source.currentVideoStatus;
						
					}
					if(source){
						_liveAddr.text = source.connectionURL +"/"+ source.streamURL;
					}
					
					_bufferLength.text = str.bufferLength +"s";
					_fps.text = int(str.currentFPS) + " 帧/秒";
					if (str.info) {
						_videoBR.text = str.info.videoLossRate.toString();
						_playbackBytesPerSecond.text = str.info.playbackBytesPerSecond +"字节/秒";
						droppedFrames.text = str.info.droppedFrames +"帧";
						currentBytesPerSecond.text = String((str.info.currentBytesPerSecond/1000).toFixed(1)) +"KB";
						audioBufferByteLength.text = str.info.audioBufferByteLength.toString();
						videoBufferByteLength.text = str.info.videoBufferByteLength.toString();
						dataBufferByteLength.text = str.info.dataBufferByteLength.toString();
						
					}
					var num:int = VideoEquipmentManager.getInstance().camera.bandwidth;
					bandWidth.text = num +",上行带宽大概为"+(int(num/1000) + 10)+"KB";
					_bytesLoaded.text = int((str.bytesLoaded - byteloaded)/1024) + "字节数";
					byteloaded = str.bytesLoaded;
					decodedFrames.text = str.decodedFrames +"";
				}
			}catch(e:Error){
				Debugger.log(Debugger.INFO,"[PushInfoPanel]",e);
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


