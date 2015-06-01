package com._17173.flash.show.base.module.video.base.push
{
	

	public class CameraData
	{
		
		public static const DEF_HIGH:int = 1;
		public static const DEF_NORMAL:int = 2;
		public static const DEF_LOW:int = 3;
		
		
		/**
		 *  
		 * 1. 70000 / 80   =  600kbps
		 * 2. 70000 / 70   =  580kbps
		 * 3. 60000 / 70   =  500kbps
		 * 4. 50000 / 70   =  450kbps
		 * 5. 50000 / 100  =  430kbps 
		 * 
		 */		
		
		public function CameraData()
		{
			_cWidth = 64000;
			_cHeight = 48000;
			_fps = 12;
			_keyFrameInterval = 48;
			def = DEF_NORMAL;
		}
		
		public function set def(value:int):void {
			switch (value) {
				case DEF_HIGH : 
					_bandwidth = 0;
					_quality = 70;
					break;
				case DEF_LOW : 
					_cWidth = 320;
					_cHeight = 240;
					_bandwidth = 20000;
					_quality = 50;
					_fps = 10;
					_keyFrameInterval = 30;
					break;
				default : 
					_cWidth = 640;
					_cHeight = 480;
					_bandwidth = 50000;
					_quality = 65;
					_fps = 13;
					_keyFrameInterval = 26;
					break;
			}
		}
		
		/**
		 * ����ͷ���url����ǿ������
		 * 
		 * ?c=480,320,20000,70,15,15
		 *  
		 * @param c
		 */		
		public function updateByConfig(c:String):void {
			var conf:Array = c.split(",");
			if (conf && conf.length) {
				//�ɼ����
				_cWidth = conf[0];
				//�ɼ��߶�
				_cHeight = conf[1];
				//��� 
				_bandwidth = conf[2];
				//���� 0~100
				_quality = conf[3];
				//�ɼ�֡Ƶ
				_fps = conf[4];
				//�ؼ�֡���,ϵͳĬ��15
				_keyFrameInterval = conf[5];
			}
		}
		
		private var _cWidth:int;
		private var _cHeight:int;
		private var _fps:int;
		private var _bandwidth:int;
		private var _quality:int;
		private var _keyFrameInterval:int;

		public function get keyFrameInterval():int
		{
			return _keyFrameInterval;
		}

		public function set keyFrameInterval(value:int):void
		{
			_keyFrameInterval = value;
		}

		public function get quality():int
		{
			return _quality;
		}

		public function set quality(value:int):void
		{
			_quality = value;
		}

		public function get bandwidth():int
		{
			return _bandwidth;
		}

		public function set bandwidth(value:int):void
		{
			_bandwidth = value;
		}

		public function get fps():int
		{
			return _fps;
		}

		public function set fps(value:int):void
		{
			_fps = value;
		}

		public function get cHeight():int
		{
			return _cHeight;
		}

		public function set cHeight(value:int):void
		{
			_cHeight = value;
		}

		public function get cWidth():int
		{
			return _cWidth;
		}

		public function set cWidth(value:int):void
		{
			_cWidth = value;
		}

	}
}