package com._17173.flash.player.module.stat.qm
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.module.stat.base.StatUtil;
	
	import flash.utils.getTimer;

	/**
	 * 点播往stat.17173.com发送的统计
	 *  
	 * @author 庆峰
	 */	
	public class FileQMStat extends PlayerQMStat
	{
		
		/**
		 * 缓冲开始时的时间戳,用来计算单次缓冲耗时 
		 */		
		private var _loadingStartTime:int = 0;
		/**
		 * 视频开始时间戳,用来计算播放耗时 
		 */		
		private var _videoStartTime:int = 0;
		/**
		 * 缓冲次数 
		 */		
		private var _bufferTime:int = 0;
		/**
		 * 暂停次数 
		 */		
		private var _pauseTime:int = 0;
		
		public function FileQMStat(path:String)
		{
			super(path);
			StatUtil.initUserMark();
			//监听超时
			_e.listen("onBIVideoPlayOutTime", onOutOfTime);
			//开始缓冲
			_e.listen("uiShowLoading", onShowLoading);
			//停止缓冲
			_e.listen("uiHideLoading", onHideLoading);
			//视频停止播放
			_e.listen("onVideoFinished", onVideoFinished);
			//视频暂停
			_e.listen("onPlayOrPause", onVideoPause);
		}
		
		override protected function createFilterData():Array {
			var f:Array = super.createFilterData();
			//用户标识
			f.push({"k":"cookie_mark", "v":StatUtil.userMark});
			return f;
		}
		
		private function onVideoPause(data:Object):void
		{
			if (data == false) {
				_pauseTime ++;
			}
		}
		
		override protected function onVideoLoaded(data:Object):void {
			super.onVideoLoaded(data);
			
			_videoStartTime = 0;
			_loadingStartTime = 0;
			_bufferTime = 0;
			_pauseTime = 0;
		}
		
		/**
		 * 缓冲开始
		 *  
		 * @param data
		 */		
		protected function onShowLoading(data:Object):void {
			_loadingStartTime = getTimer();
			_bufferTime ++;
		}
		
		/**
		 * 缓冲隐藏
		 *  
		 * @param data
		 */		
		protected function onHideLoading(data:Object):void {
			_loadingStartTime = 0;
		}
		
		private function onVideoFinished(data:Object):void {
			stat(StatTypeEnum.EVENT_DEF, null);
		}
		
		/**
		 * 超时检测
		 *  
		 * @param data
		 */		
		protected function onOutOfTime(data:Object=null):void {
			stat(StatTypeEnum.EVENT_PLAY_OUT_OF_TIME, null);
		}
		
		private function patchBaseData(value:Object):Object {
			//视频id
			value["vid"] = StatUtil.cid;
			//播放页地址
			value["playurl"] = StatUtil.refPage;
			//文件地址(cdn地址)
//			var uv:URLVariables = new URLVariables("a=" + v.streamName);
			value["cdn"] = encodeURIComponent(v.streamName);
			//已播放时长
			value["playprocess"] = v ? v.playedTime : 0;
			//当前清晰度
			value["currentquality"] = Context.getContext(ContextEnum.SETTING).def;
			
			return value;
		}
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			var d:Object = null;
			switch (type) {
				case StatTypeEnum.EVENT_FPV : 
					//不使用flash来记pv
//					d = getFPVData(data);
					break;
				case StatTypeEnum.EVENT_FVV : 
					//不使用flash来记vv
//					d = getFVVData(data);
					break;
				case StatTypeEnum.EVENT_SWITCH_CDN : 
					d = getSwitchCDNData(data);
					break;
				case StatTypeEnum.EVENT_DEF : 
					d = getDefData(data);
					break;
				case StatTypeEnum.EVENT_PLAY_OUT_OF_TIME : 
					d = getOutOfTimeData(data);
					break;
				default : 
					break;
			}
			
			var arr:Array = [];
			if (d) {
				for (var k:String in d) {
					arr.push({"k":k, "v":d[k]});
				}
			}
			
			return arr;
		}
		
		protected function getFPVData(data:Object):Object {
			var d:Object = {"id":"demandfpv"};
			
			return patchBaseData(d);
		}
		
		protected function getFVVData(data:Object):Object {
			var d:Object = {"id":"demandplay"};
			return patchBaseData(d);
		}
		
		private function getOutOfTimeData(data:Object):Object {
			var d:Object = {"id":"demandbuffer"};
			//已经缓冲了的秒数
			d["buffertime"] = _loadingStartTime <= 0 ? 0 : (getTimer() - _loadingStartTime) / 1000;
			return patchBaseData(d);
		}
		
		/**
		 * 切换cdn
		 *  
		 * @param data
		 */		
		protected function getSwitchCDNData(data:Object):Object {
			var d:Object = {"id":"demandcdn"};
			return patchBaseData(d);
		}
		
		protected function getDefData(data:Object):Object {
			var d:Object = {"id":"demandquality"};
			//视频总时长
			d["duration"] = v.totalTime;
			//播放耗时
			d["consumingtime"] = (getTimer() - _videoStartTime) / 1000;
			//缓冲次数
			d["buffercount"] = _bufferTime;
			//清晰度
			d["quality"] = v.getAllDef();
			//暂停次数
			d["pausetime"] = _pauseTime;
			
			return patchBaseData(d);
		}
		
	}
}