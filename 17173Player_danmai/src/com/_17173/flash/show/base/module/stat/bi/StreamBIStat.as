package com._17173.flash.player.module.stat.bi
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.module.stat.base.StatUtil;
	import com._17173.flash.show.base.module.stat.bi.PlayerBIStat;

	/**
	 * 直播统计,发往BI
	 *  
	 * @author 庆峰
	 */	
	public class StreamBIStat extends PlayerBIStat
	{
		
		private var _isFirstTime:Boolean = false;
		private var _getCidTimes:int = 10;
		
		public function StreamBIStat(version:String, path:String, appkey:String)
		{
			super(version, path, appkey);
			StatUtil.initUserMark();
		}
		
//		override public function stat(type:String, data:Object):void {
//			if (StatUtil.userMark == "") {
//				Ticker.tick(200, function():void {stat(type, data)});
//			} else {
//				super.stat(type, data);
//			}
//		}
		/**
		 * 启动统计
		 *  
		 * @param type
		 * @param data
		 */		
		override public function stat(type:String, data:Object):void {
			if (StatUtil.userMark == "") {
				//userMark初始化需要几秒
				Ticker.tick(200, function():void {stat(type, data)});
			} else {
//				super.stat(type, data);
				if (type == StatTypeEnum.EVENT_LOADED) {
					var cid:String = Context.variables["cid"];
					if (cid && cid != "") {
						super.stat(type, data);
					} else {
						Ticker.tick(200, function ():void {
							_getCidTimes --;
							if (_getCidTimes == 0){
								//super只能在类实例方法中使用 所以调用superStat
								superStat(type, data);
							} else {
								stat(type, data);
							}
						});
					}
				} else {
					super.stat(type, data);
				}
			}
		}
		
		private function superStat(type:String, data:Object):void{
			super.stat(type, data);
		}
		
		override protected function resolveTypeData(type:String, data:Object):Array {
			var d:Array = super.resolveTypeData(type, data);
			//直播企业版播放器的channel字段要截取_http:之前的参数
			if (StatUtil.playerType == "f6") {
				for each (var item:Object in d) {
					if (item["k"] == "channel") {
						var temp:Array = (item["v"] as String).split("_http://");
//						var temp:Array = (item["v"] as String).split("_file://");
						if (temp.length > 0) {
							item["v"] = temp[0];
						}
						break;
					}
				}
			}
			
			switch (type) {
				case StatTypeEnum.EVENT_LOADED:
					d.push({"k":"currevent", "v":"zb_play_load"});
					
					break;
				case StatTypeEnum.EVENT_REDIRECT:
					d.push({"k":"currevent", "v":"zb_play_click"});
					if (data is RedirectData) {
						d.push({"k":"click_type", "v":data["click_type"]});
						d.push({"k":"action", "v":data["action"]});
					}
					break;
				case StatTypeEnum.EVENT_PLAY_START:
					d.push({"k":"currevent", "v":"zb_play_start"});
					d.push({"k":"cdn", "v":ip});
					d.push({"k":"liveid", "v":Context.variables["liveId"]});
					d.push({"k":"opt", "v":opts});
					d.push({"k":"pdid", "v":""});
					d.push({"k":"homeid", "v":Context.variables["liveRoomId"]});
					break;
			}
			//上一个事件
			d.push({"k":"preevent", "v":""});
			//视频类别
			d.push({"k":"video_cate", "v":""});
			//统计不同产品来源的访问
			d.push({"k":"appid", "v":"webgame"});
			//统计不同房间类型的数据量  秀场用
			d.push({"k":"pdid", "v":""});
			//统计不同房间的数据量 秀场用
			d.push({"k":"homeid", "v":""});
			
			return d;
			//return d;
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
		
		protected function get opts():String {
			var s:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
			if (s && s.hasOwnProperty("opts")) {
				var opts:Array = s["opts"];
				if (opts && opts.length > 0) {
					return opts[opts.length - 1]["opt"];
				}
				return s["opts"];
			} else {
				return "";
			}
		}
		
	}
}