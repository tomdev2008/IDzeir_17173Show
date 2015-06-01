package com._17173.flash.player.module.stat.qm
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.module.stat.base.StatUtil;
	
	import flash.utils.getTimer;
	
	/**
	 * 直播统计
	 * 发往stat.17173.com 
	 * @author 庆峰
	 */	
	public class StreamQMStat extends PlayerQMStat
	{
		
		/**
		 * 取opt的index 
		 */		
		private var _optIndex:int = -1;
		
		private var _bufferData:Array = [];
		private var _isTicking:Boolean = false;
		private var _tickTimer:int = 0;
		
		public function StreamQMStat(path:String)
		{
			super(path);
			StatUtil.initUserMark();
			//开始缓冲
			_e.listen("showLoading", onShowLoading);
			//结束缓冲
			_e.listen("hideLoading", onHideLoading);
		}
		
		override protected function createFilterData():Array {
			var f:Array = super.createFilterData();
			f.push({"k":"seq", "v":StatUtil.seq ? StatUtil.seq : StatUtil.userMark});
			f.push({"k":"channelid", "v":StatUtil.channel});
			f.push({"k":"url", "v":StatUtil.refPage});
			
			return f;
		}
		
		/**
		 * 缓冲开始
		 *  
		 * @param data
		 */		
		protected function onShowLoading(data:Object=null):void {
			if (!_isTicking) {
				_isTicking = true;
				//计时2分钟发送
				Ticker.tick(120000, sendBufferStat);
			}
			
			//时间标记,当为0是进行记录,在hide的时候通过判断时间是否被记录来确认隐藏的准确时长
			if (_tickTimer == 0) {
				_tickTimer = getTimer();
			}
		}
		
		/**
		 * 缓冲结束
		 *  
		 * @param data
		 */		
		protected function onHideLoading(data:Object=null):void {
			if (_tickTimer != 0) {
				//缓冲时长
				var timeLen:int = (getTimer() - _tickTimer) / 1000;
				//视频数据
				var vm:Object = Context.getContext(ContextEnum.VIDEO_MANAGER);
				if (vm) {
					var videoData:Object = vm["data"];
					if (videoData) {
						var cid:String = videoData["cid"];
						//{{10, 10000, 127.0.0.1:1000}}
						//第一项loading出现的时长(从出现到消失),第二项视频的id,第三项请求的地址(只要http://xxxx/中间xxxx那一段);
						var opt:String = (opts && opts.length > 0) ? opts[opts.length - 1].opt : "0";
						_bufferData.push([timeLen, cid, ip, opt]);
					}
				}
			}
			_tickTimer = 0;
		}
		
		/**
		 * 发送缓冲统计 
		 */		
		private function sendBufferStat():void {
			stat(StatTypeEnum.EVENT_PLAY_BUFFER, null);
		}
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			var d:Object = null;
			switch (type) {
				case StatTypeEnum.EVENT_FPV : 
					d = getFPVData(data);
					break;
				case StatTypeEnum.EVENT_FVV : 
					d = getFVVData(data);
					break;
				case StatTypeEnum.EVENT_PLAY_BUFFER : 
					d = getBufferData(data);
					break;
				case StatTypeEnum.EVENT_CLICK : 
					d = getClickData(data);
					break;
				case StatTypeEnum.EVENT_SHOW : 
					d = getShowData(data);
					break;
				case StatTypeEnum.EVENT_REDIRECT : 
					d = getRedirectData(data);
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
		
		/**
		 * FPV
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getFPVData(data:Object):Object {
			var d:Object = {"id":"fpv"};
			return d;
		}
		
		/**
		 * FVV
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getFVVData(data:Object):Object {
			var d:Object = null;
			if (ip != null) {
				d = {"id":"play"};
				//播放地址
				d["cdn"] = ip;
				//视频cid
				d["liveid"] = v.cid;
				//opt参数
				if (opts && opts.length > 0) {
					while (opts.length > (_optIndex + 1)) {
						_optIndex ++;
						var o:Object = opts[_optIndex];
					}
				}
				//其他数据
				if (data) {
					for (var key:String in data) {
						d[key] = data[key];
					}
				}
			}
			return d;
		}
		
		/**
		 * 缓冲统计
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getBufferData(data:Object):Object {
			_isTicking = false;
			
			var d:Object = null;
			if (_bufferData.length > 0) {
				d = {"id":"buffer"};
				
				//数据打包发出
				var i:String = "";
				var infos:Array = [];
				//字符串拼接
				while (_bufferData.length) {
					var buffer:Array = _bufferData.shift();
					
					infos.push("{" + buffer.join(",") + "}");
				}
				i = "{" + infos.join(",") + "}";
				
				d["info"] = i;
			}
			return d;
		}
		
		/**
		 * 展示统计
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getShowData(data:Object):Object {
			//直播外链才统计
			if (StatUtil.playerType != "f6") return null;
			
			var d:Object = {"id":"show"};
			d["action"] = data.action;
			return d;
		}
		
		/**
		 * 点击统计
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getClickData(data:Object):Object {
			//直播外链才统计
			
			if (StatUtil.playerType != "f6" && !qmFilterPass(data)) return null;
			
			var d:Object = {"id":"click"};
			d["action"] = data.action;
			return d;
		}
		
		/**
		 * 回链统计
		 *  
		 * @param data
		 * @return 
		 */		
		protected function getRedirectData(data:Object):Object {
			//直播外链才统计
			if (StatUtil.playerType != "f6") return null;
			
			var d:Object = {"id":"goback"};
			d["type"] = data.click_type;
			d["action"] = data.action;
			return d;
		}
		
		protected function get opts():Array {
			var s:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
			if (s && s.hasOwnProperty("opts")) {
				return s["opts"];
			} else {
				return null;
			}
		}
		
		/**
		 *检测是否可以发送点击事件 
		 * @param data
		 * @return 
		 * 
		 */		
		protected function qmFilterPass(data:Object):Boolean{
			var pass:Boolean = false;
			if(data.hasOwnProperty("action") && data.action == RedirectDataAction.ACTION_CLICK_ONLINETIME){
				pass = true;
			}
			return pass;
		}
		
	}
}