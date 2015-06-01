package com._17173.flash.core.ad.model
{
	import com._17173.flash.core.ad.interfaces.IAdData;
	
	import flash.net.registerClassAlias;

	public class AdData implements IAdData
	{
		
		private var _type:String = null;
		private var _url:String = null;
		private var _time:int = 0;
		private var _extension:int = 0;
		private var _round:int = 0;
		private var _jumpTo:String = null;
		private var _sc:String = null;
		private var _cc:String = null;
		private var _tsc:Array = null;
		private var _yOffset:Number = 0;
		private var _roundNum:int = 1;
		//闪播广告用的
		private var _disappearTime:int = 0;
		private var _iframeUrl:String = null;
		
		public function AdData()
		{
			registerClassAlias("AdData", AdData);
		}
		/**
		 *客户点击统计请求地址 
		 * @return 
		 * 
		 */
		public function get tsc():Array
		{
			return _tsc;
		}

		public function set tsc(value:Array):void
		{
			_tsc = value;
		}

		/**
		 *好耶点击统计 
		 * @return 
		 * 
		 */		
		public function get cc():String
		{
			return _cc;
		}

		public function set cc(value:String):void
		{
			_cc = value;
		}

		/**
		 *好耶曝光请求地址 
		 * @return 
		 * 
		 */
		public function get sc():String
		{
			return _sc;
		}

		public function set sc(value:String):void
		{
			_sc = value;
		}

		/**
		 * 广告类型,前贴/大前贴/下底/挂角/暂停 
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:String):void
		{
			_type = value;
		}

		/**
		 * 广告文件地址 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

		/**
		 * 广告文件时长 
		 */
		public function get time():int
		{
			return _time;
		}

		/**
		 * @private
		 */
		public function set time(value:int):void
		{
			_time = value;
		}

		/**
		 * 广告文件类型 
		 */
		public function get extension():int
		{
			return _extension;
		}

		/**
		 * @private
		 */
		public function set extension(value:int):void
		{
			_extension = value;
		}

		/**
		 * 广告文件轮播次数 
		 */
		public function get round():int
		{
			return _round;
		}

		/**
		 * @private
		 */
		public function set round(value:int):void
		{
			_round = value;
		}

		/**
		 * 广告跳转链接 
		 * 
		 * @return 
		 */		
		public function get jumpTo():String
		{
			return _jumpTo;
		}

		public function set jumpTo(value:String):void
		{
			_jumpTo = value;
		}
		
		public function get yOffset():Number
		{
			return _yOffset;
		}
		
		public function set yOffset(value:Number):void
		{
			_yOffset = value;
		}

		/**
		 * 闪播广告时间
		 *  
		 * @return 
		 */		
		public function get disappearTime():int
		{
			return _disappearTime;
		}

		public function set disappearTime(value:int):void
		{
			_disappearTime = value;
		}

		/**
		 * 闪播广告地址 
		 * @return 
		 */		
		public function get iframeUrl():String
		{
			return _iframeUrl;
		}

		public function set iframeUrl(value:String):void
		{
			_iframeUrl = value;
		}

		public function get roundNum():int
		{
			return _roundNum;
		}

		/**
		 * 当前广告属于第几轮
		 * @param value
		 * 
		 */		
		public function set roundNum(value:int):void
		{
			_roundNum = value;
		}

		
	}
}