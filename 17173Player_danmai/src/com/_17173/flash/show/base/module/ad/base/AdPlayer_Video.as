package  com._17173.flash.show.base.module.ad.base
{
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class AdPlayer_Video extends BaseAdPlayer
	{
		
		private var _video:Video = null;
		private var _nc:NetConnection = null;
		private var _ns:NetStream = null;
		private var _meta:Boolean = false;
		// 用于记录循环播放时的前置时间
		private var _baseTime:Number = 0;
		
		public function AdPlayer_Video()
		{
		}
		
		override protected function init():void {
			super.init();
			
			_nc = new NetConnection();
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
			_nc.connect(null);
		}
		
		protected function onStatus(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetConnection.Connect.Success" : 
					_ns = new NetStream(_nc);
					_ns.bufferTime = 3;
					_ns.client = this;
					_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
					_ns.play(_data.url);
					
					_video = new Video();
					_video.attachNetStream(_ns);
					_display = _video;
					_soundTarget = _ns;
					break;
				case "NetStream.Play.StreamNotFound" : 
				case "NetStream.Connect.Failed" : 
				case "NetStream.Connect.Closed" : 
					error(event.info);
					break;
				case "NetStream.Play.Stop" : 
					_baseTime += _ns.time * 1000;
					_ns.seek(0);
					break;
			}
		}
		
		public function onPlayStatus(value:Object):void {
			
		}
		
		public function onXMPData(data:Object):void {
			
		}
		
		public function onCuePoint():void {
			
		}
		
		override public function getTime():Number {
			return _ns ? _ns.time * 1000 + _baseTime : 0;
		}
		
		public function onMetaData(info:Object):void {
			_meta = true;
			_video.attachNetStream(_ns);
			
			complete(_video);
		}
		
		override public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			if (_meta) {
				var vw:int = _video.videoWidth;
				var vh:int = _video.videoHeight;
				var sw:Number = vw > _w ? _w / vw : 1;
				var sh:Number = vh > _h ? _h / vh : 1;
				var sc:Number = sw > sh ? sh : sw;
				var tmpW:int = Math.ceil(sc * vw);
				var tmpH:int = Math.ceil(sc * vh);
				_video.width = tmpW > vw ? vw : tmpW;
				_video.height = tmpH > vh ? vh : tmpH;
			}
		}
		
		override public function dispose():void {
			super.dispose();
			_meta = false;
			if (_video) {
				_video.attachNetStream(null);
				_video = null;
			}
			if (_ns) {
				_ns.close();
				_ns.dispose();
				_ns = null;
			}
			if (_nc) {
				_nc.close();
				_nc = null;
			}
		}
		
	}
}