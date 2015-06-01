package com._17173.flash.show.base.module.video.base.push
{
	import flash.media.SoundCodec;

	public class MicData
	{
		private var _codec:String;
		private var _rate:int;
		private var _silenceLevel:Number;
		private var _timeout:int;
		private var _volume:int;
		private var _gain:int;
		
		public function MicData()
		{
			_codec = SoundCodec.NELLYMOSER;
			
			_rate = 22;
			_silenceLevel = 0;
			_timeout = 0;
			_volume = 1;
			
			_gain = 60;
		}
		
		/**
		 * 麦克风根据url参数强制设置
		 * 
		 * ?m=0,1,22,60
		 *  
		 * @param m
		 * 
		 */		
		public function updateByConfig(m:String):void {
			var conf:Array = m.split(",");
			if (conf && conf.length) {
				//音频编码 0或者其他
				_codec = conf[0] == "0" ? SoundCodec.NELLYMOSER : SoundCodec.SPEEX;
				//音量  0~1
				_volume = conf[1];
				//采样率 6, 8, 11, 22, 44
				_rate = conf[2];
				//平衡 0~100
				_gain = conf[3];
			}
		}

		public function get gain():int
		{
			return _gain;
		}

		public function set gain(value:int):void
		{
			_gain = value;
		}

		public function get volume():int
		{
			return _volume;
		}

		public function set volume(value:int):void
		{
			_volume = value;
		}

		public function get timeout():int
		{
			return _timeout;
		}

		public function set timeout(value:int):void
		{
			_timeout = value;
		}

		public function get silenceLevel():Number
		{
			return _silenceLevel;
		}

		public function set silenceLevel(value:Number):void
		{
			_silenceLevel = value;
		}

		public function get rate():int
		{
			return _rate;
		}

		public function set rate(value:int):void
		{
			_rate = value;
		}

		public function get codec():String
		{
			return _codec;
		}

		public function set codec(value:String):void
		{
			_codec = value;
		}

	}
}