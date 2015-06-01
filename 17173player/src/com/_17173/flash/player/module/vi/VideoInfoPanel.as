package com._17173.flash.player.module.vi
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		private var _clsBtn:MovieClip = null;
		
		private var _videoBR:TextField = null;
		private var _audioBR:TextField = null;
		private var _fps:TextField = null;
		private var _res:TextField = null;
		private var _download:TextField = null;
		private var _streamStatus:TextField = null;
		private var _loadedTime:TextField = null;
		private var _liveAddr:TextField = null;
		
		private var _w:Number = 320;
		private var _h:Number = 160;
		
		private var _lastBytes:int = 0;
		
		public function VideoInfoPanel()
		{
			super();
			
			graphics.beginFill(0xCCCCCC, .8);
			graphics.drawRect(0, 0, 320, 260);
			graphics.endFill();
			
			_clsBtn = new mc_clsBtn();
			_clsBtn.x = width - _clsBtn.width - 5;
			_clsBtn.y = 5;
			_clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			addChild(_clsBtn);
			
			var tf:TextField = packupTF();
			tf.text = "视频码率: ";
			tf.x = 5;
			tf.y = 5;
			_videoBR = packupTF();
			_videoBR.x = tf.width + 3;
			_videoBR.y = tf.y;
			
			tf = packupTF();
			tf.text = "音频码率: ";
			tf.x = 5;
			tf.y = _videoBR.y + _videoBR.height + 5;
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
			tf.text = "当前视频分辨率: ";
			tf.x = 5;
			tf.y = _fps.y + _fps.height + 5;
			_res = packupTF();
			_res.x = tf.width + 3;
			_res.y = tf.y;
			
			tf = packupTF();
			tf.text = "当前下载速率: ";
			tf.x = 5;
			tf.y = _res.y + _res.height + 5;
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
			tf.text = "当前缓冲区长度: ";
			tf.x = 5;
			tf.y = _streamStatus.y + _streamStatus.height + 5;
			_loadedTime = packupTF();
			_loadedTime.x = tf.width + 3;
			_loadedTime.y = tf.y;
			
			tf = packupTF();
			tf.text = "当前流地址: ";
			tf.x = 5;
			tf.y = _loadedTime.y + _loadedTime.height + 5;
			_liveAddr = packupTF();
			_liveAddr.x = tf.width + 3;
			_liveAddr.y = tf.y;
			_liveAddr.wordWrap = true;
			_liveAddr.multiline = true;
			_liveAddr.width = 235;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
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
			var vm:Object = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (vm) {
				try {
					_liveAddr.text = escapeNullString(vm.data.connectionURL) + escapeNullString(vm.data.streamName);
					if (vm.video) {
						_res.text = vm.video.video.videoWidth + " * " + vm.video.video.videoHeight;
					}
					if (vm.source) {
						_streamStatus.text = escapeNullString(vm.source.currentVideoStatus);
						var str:Object = vm.source.stream;
						if (str) {
							_loadedTime.text = escapeNullString(str.bufferLength);
							var bytes:int = (str.bytesLoaded - _lastBytes) / 1024;
							_lastBytes = str.bytesLoaded;
							_download.text = bytes + " KB/s";
							//fps
							_fps.text = int(str.currentFPS) + " 帧/秒";
							if (str.info) {
								_videoBR.text = int(str.info.playbackBytesPerSecond / 1024 * 8) + " kbps";
								//元数据
								var meta:Object = str.info.metaData;
								if (meta) {
									_audioBR.text = int(meta.audiodatarate) + " kbps";
								}
							}
						} else {
							initTexts();
						}
					} else {
						initTexts();
					}
				} catch (e:Error) {};
			}
//			var dr:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
//			if (dr && dr.hasOwnProperty("optimal")) {
//			}
		}
		
		private function escapeNullString(s:String):String {
			if (s == null) {
				return "";
			} else {
				return s;
			}
		}
		
		private function initTexts():void {
			try {
				_streamStatus.text = "-";
				_loadedTime.text = "-";
				_download.text = "-";
				_fps.text = "-";
				_liveAddr.text = "-";
				_videoBR.text = "-";
				_audioBR.text = "-";
			} catch (e:Error) {};
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