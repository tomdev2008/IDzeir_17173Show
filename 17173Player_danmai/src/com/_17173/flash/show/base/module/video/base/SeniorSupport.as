package com._17173.flash.show.base.module.video.base 
{
	
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.VideoCodec;
	import flash.net.NetStream;  //NetStream 对象是 NetConnection 对象中的一个通道    此通道可以使用 NetStream.publish() 发布流，也可以使用 NetStream.play() 订阅发布的流并接收数据

	public class SeniorSupport implements ISenior
	{
		private var _ns:NetStream;
		
		public function SeniorSupport() 
		{
		}
		/**
		 * 消除回音
		 * @param mic
		 * 
		 */		
		public function setEnhanceMic(mic:Microphone):void
		{
			if (mic) { 
				var micOption:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				micOption.autoGain = false;
				micOption.nonLinearProcessing = false;  //启用非线性处理。
				mic.enhancedOptions = micOption;
			}
			
		}
		/**
		 * 设置流的编码与帧速率
		 * @param ns
		 * @return 
		 * 
		 */
		public function setH264(ns:NetStream):NetStream
		{
			_ns = ns;
			var h264:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_3_1); //设置视频编码的配置文件和级别。
			//将每个参数均设置为 -1 以使用同一个编码值作为捕获值。
			h264.setMode(-1, -1, -1); //设置用于编码视频的分辨率和帧速率。
			//完整传输而没有使用视频压缩算法进行插值处理的视频帧（称为关键帧或 Instantaneous Decoding Refresh (IDR) 帧）数。
			//设置为 -1 以使用为 Camera 对象指定的同一个值。
			h264.setKeyFrameInterval( -1);
			_ns.videoStreamSettings = h264;
			return _ns;
		}
		/**
		 * 得到解码器的解码方式
		 * @return 
		 * 
		 */		
		public function getVideoCodecId():int
		{
			var codecId:int = -1;
			var codecName:String = _ns.videoStreamSettings.codec.toLocaleLowerCase();  // 用于压缩的视频编解码器名。
			switch(codecName){
				case VideoCodec.H264AVC.toLocaleLowerCase():
					codecId = 7;
					break;
				case VideoCodec.SORENSON.toLocaleLowerCase():
					codecId = 2;
					break;
			}
			return codecId;
		}
		/**
		 * 流大小   当前编码的宽度，以像素为单位。
		 * @return 
		 * 
		 */		
		public function getStreamWidth():int
		{
			return _ns.videoStreamSettings.width;
		}
		/**
		 * 流大小   当前编码的高度，以像素为单位。
		 * @return 
		 * 
		 */	
		public function getStreamHeight():int
		{
			return _ns.videoStreamSettings.height;
		}
		
		/**
		 * 检索当前输出视频输入信号可以使用的最大带宽，以每秒字节数为单位。
		 * @return 
		 * 
		 */		
		public function getBandWidth():int
		{
			return _ns.videoStreamSettings.bandwidth;
		}
		
	}

}