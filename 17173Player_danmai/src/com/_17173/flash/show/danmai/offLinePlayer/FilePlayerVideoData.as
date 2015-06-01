package com._17173.flash.show.danmai.offLinePlayer
{
	public class FilePlayerVideoData extends VideoData
	{
		private var _aClass:String = null;
		private var _bClass:String = null;
		private var _info:Object = null;
		private var _thumbnail:String = null;
		private var _isEncrypt:Boolean = false;
		private var _isMultiStream:Boolean = false;
		private var _defaultDef:String = "0";
		private var _splitLength:int = 0;
		private var _aClassName:String = "";
		private var _bClassName:String = "";
		
		public function FilePlayerVideoData() 
		{
		}
		
		/**
		 * 大类别 
		 */
		public function get aClass():String
		{
			return _aClass;
		}
		
		/**
		 * @private
		 */
		public function set aClass(value:String):void
		{
			_aClass = value;
		}
		/**
		 * 大类别 
		 */
		public function get aClassName():String
		{
			return _aClassName;
		}
		
		/**
		 * @private
		 */
		public function set aClassName(value:String):void
		{
			_aClassName = value;
		}
		
		/**
		 * 子类别 
		 */
		public function get bClass():String
		{
			return _bClass;
		}
		
		/**
		 * @private
		 */
		public function set bClass(value:String):void
		{
			_bClass = value;
		}
		
		/**
		 * 子类别 
		 */
		public function get bClassName():String
		{
			return _bClassName;
		}
		
		/**
		 * @private
		 */
		public function set bClassName(value:String):void
		{
			_bClassName = value;
		}
		
		/**
		 * 分段与否 
		 */
		public function get isMultiStream():Boolean
		{
			return _isMultiStream;
		}
		
		/**
		 * 视频缩略图 
		 */
		public function get thumbnail():String
		{
			return _thumbnail;
		}
		
		/**
		 * @private
		 */
		public function set thumbnail(value:String):void
		{
			_thumbnail = value;
		}
		
		/**
		 * 是否加密视频. 
		 * @return 
		 * 
		 */		
		public function get isEncrypt():Boolean
		{
			return _isEncrypt;
		}
		
		public function set isEncrypt(value:Boolean):void
		{
			_isEncrypt = value;
		}
		
		/**
		 * 一共有几个分段
		 * @return 
		 */		
		public function get splitLength():int
		{
			return _splitLength;
		}
		
		public function set splitLength(value:int):void
		{
			_splitLength = value;
		}
		
		/**
		 * 视频完整信息 
		 * @return 
		 * 
		 */		
		public function get info():Object
		{
			return _info;
		}
		
		public function set info(value:Object):void
		{
			if (value) {
				_info = value;
				
				for (var key:String in _info) {
					if (_defaultDef == "0") {
						_defaultDef = key;
					} else {
						if (key < _defaultDef) {
							_defaultDef = key;
						}
					}
				}
				_splitLength = _info[key]["split"].length;
			}
		}
		
		/**
		 * 默认清晰度. 
		 * @return 
		 */		
		public function get defaultDef():String {
			return _defaultDef;
		}
		
		/**
		 * 默认清晰度. 
		 * @return 
		 */		
		public function set defaultDef(value:String):void {
			_defaultDef = value;
		}
		
		/**
		 * 切换视频信息 
		 * @param cdn
		 * @param def
		 * @param split
		 * @return 
		 */		
		public function switchTo(cdn:int, def:String, split:int):Boolean {
			if (_info == null) return false;
			resetTotalTime(def);
			resetTotalBytes(def);
			if (_info.hasOwnProperty(def)) {
				if (_info[def].split.length > split) {
					if (_info[def].split[split].url.length > cdn) {
						_streamName = _info[def].split[split].url[cdn];
						return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 获取当前清晰度，当前分段下有几个cdn 
		 * @param def 清晰度
		 * @param split 分段
		 * @return 
		 * 
		 */		
		public function getCdnNum(def:String, split:int):int {
			var re:int = 0;
			if (_info.hasOwnProperty(def)) {
				if (_info[def].split.length > split) {
					re = _info[def].split[split].url.length;
				} else {
					re = 0;
				}
			} else {
				re = 0;
			}
			return re;
		}
		
		private function resetTotalBytes(def:String):void
		{
			totalBytes = _info[def].totalSize;
		}
		
		/**
		 * 根据播放时间确定分段 
		 * @param def	清晰度
		 * @param time	在整个视频时间长度上的时间点
		 * @return 
		 */		
		public function getSplitInfo(def:String, time:Number):Object {
			if (_info.hasOwnProperty(def)) {
				var split:Array = _info[def]["split"];
				var splitLen:int = split.length;
				var d:int = 0;
				for (var i:int = 0; i < splitLen; i ++) {
					d = split[i].duration;
					if (time < d) {
						return {"time":time, "index":i};
					} else {
						time -= d;
					}
				}
			}
			return null;
		}
		
		/**
		 * 获取当前分段之前分段的时长
		 */
		public function getBeforeLength(def:String, split:int):Number
		{
			var time:Number = 0;
			for(var i:int = split; i > 0; i--)
			{
				time += int(_info[def].split[i - 1].duration);
			}
			return time;
		}
		
		/**
		 * 根据播放的时间获取对应的需要加载的bytes
		 */
		public function getBytesByTime(def:String, time:int):Number
		{
			return Math.ceil(time * _info[def].totalSize / _info[def].totalTime);
		}
		
		/**
		 * 获取所有的清晰度信息,逗号隔开
		 * 例如:"1,2,6"
		 */
		public function getAllDef():String
		{
			var defInfo:String = "";
			for(var item:Object in info)
			{
				defInfo += item + ",";
			}
			return defInfo = defInfo.slice(0, defInfo.length - 1);
		}
		
		/**
		 * 因为视频初始化之后会拿到真实的duration，并使用真实的数据，所以，要将数据源中的值改变
		 */
		public function resetTheDuration(def:String, split:int, value:Number):void
		{
			_info[def].split[split].duration = value;
			resetTotalTime(def);
		}
		
		/**
		 * 重新赋值数据源中的totalTime值
		 * 因为视频初始化之后会拿到真实的duration，并使用真实的数据，所以，要将数据源中的值改变
		 * 因为不同清晰度情况下，可能会出现分段时间不一样，导致总时间不一样的问题，所以每次都重置一下总时间
		 */
		private function resetTotalTime(def:String):void
		{
			var sum:Number = 0;
			for(var i:int = 0; i < _info[def].split.length; i++)
			{
				var item:Object = _info[def].split[i];
				if(item.hasOwnProperty("duration"))
				{
					sum += Number(item["duration"]);
				}
			}
			_info[def].totalTime = sum;
			totalTime = _info[def].totalTime;
		}
	}
}
