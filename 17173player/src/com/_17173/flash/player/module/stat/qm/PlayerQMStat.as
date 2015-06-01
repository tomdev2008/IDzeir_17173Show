package com._17173.flash.player.module.stat.qm
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.stat.base.StatBase;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.module.stat.base.StatUtil;
	
	/**
	 * 发往stat.17173.com的统计
	 *  
	 * @author 庆峰
	 */	
	public class PlayerQMStat extends StatBase
	{
		
		protected static const TYPE_DICT:Object = {
			"f1":"1", 
			"f2":"2", 
			"f3":"3", 
			"f4":"4", 
			"f5":"5", 
			"f6":"6", 
			"f7":"7"
		};
		
		protected var _e:IEventManager = null;
		
		private var _currentCID:int = 0;
		
		public function PlayerQMStat(path:String)
		{
			super(path);
			
			_filter = createFilterData();
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			//视频加载
			_e.listen("onVideoInit", onVideoLoaded);
			//视频初始化成功
			_e.listen("onBIGetVideoInfo", onPlayerInited);
		}
		
		private function onPlayerInited(data:Object):void {
			stat(StatTypeEnum.EVENT_FPV, null);
		}
		
		/**
		 * 必备字段
		 *  
		 * @return 
		 */		
		protected function createFilterData():Array {
			var arr:Array = [];
			//来源
			arr.push({"k":"src", "v":"flash"});
			//session
			arr.push({"k":"sessionid", "v":StatUtil.session});
			//播放器类型
			arr.push({"k":"ftype", "v":TYPE_DICT[StatUtil.playerType]});
			return arr;
		}
		
		/**
		 * 视频开始加载
		 *  
		 * @param data
		 */		
		protected function onVideoLoaded(data:Object):void {
			Ticker.stop(onCheckPlayInfo);
			//每2秒
			Ticker.tick(1000, onCheckPlayInfo, 0);
		}
		
		private function onCheckPlayInfo():void {
			if (isVideoChanged && v.playedTime >= 5) {
				//移除计时
				Ticker.stop(onCheckPlayInfo);
				//更新当前cid
				_currentCID = v.cid;
				
				stat(StatTypeEnum.EVENT_FVV, null);
			}
		}
		
		/**
		 * 根据之前记录的cid来判断当前视频是否已经改变
		 *  
		 * @return 
		 */		
		private function get isVideoChanged():Boolean {
			return v && v.cid != _currentCID;
		}
		
		/**
		 * 视频数据
		 *  
		 * @return 
		 */		
		protected function get v():Object {
			var vm:Object = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (vm && vm.hasOwnProperty("data") && vm.data) {
				return vm.data;
			} else {
				return null;
			}
		}
		
		/**
		 * cdn的ip地址或者域名
		 *  
		 * @return 
		 */		
		protected function get ip():String {
			if (v) {
				var u:String = Util.validateStr(v.connectionURL) ? v.connectionURL : v.streamName;
				var urlSplited:Array = u.split("://");
				if (urlSplited.length > 1) {
					urlSplited = urlSplited[1].split("/");
					return urlSplited[0];
				}
			}
			return null;
		}
		
	}
}