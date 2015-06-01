package com._17173.flash.player.module.stat.qm
{
	
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.PluginEnum;
	
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import com._17173.flash.player.module.vi.VideoInfoPanel;
	
	/**
	 * 用户视频播放质量检测模块.
	 *  
	 * @author shunia-17173
	 */	
	public class QM extends Sprite
	{
		
		/**
		 * 统计路径 
		 */		
		private static const BASE_URL:String = "http://stat.v.17173.com/?src=flash";
		
		private var _bufferData:Array = null;
		private var _isTicking:Boolean = false;
		private var _tickTimer:int = 0;
		/**
		 * 视频信息面板 
		 */		
		private var _videoInfoPanel:VideoInfoPanel = null;
		/**
		 * 浏览器cookie 
		 */		
		private var _brCookie:Object = null;
		/**
		 * 取opt的index 
		 */		
		private var _optIndex:int = -1;
		private var _currentCID:int = 0;
		
		/**
		 * loading开始时视频加载的字节数字
		 */		
		private var _startLoadingNum:Number = 0;
		
		public function QM()
		{
			super();
			_bufferData = [];
			
			init();
		}
		
		protected function init():void {
			var version:String = "1.0.8";
			
			Debugger.log(Debugger.INFO, "[QM]", "播放质量统计模块[版本" + version + "]初始化!");
			
			getKeysFromBrowserCookie();
			
			if (!Util.validateStr(_brCookie["seq"])) {
				//flash 本地cookie，使用随机10位字符串+时间戳当作用户id
				var c:Cookies = new Cookies("shared", "/");
				if (c) {
					var cookie:Object = c.get("statCookie");
					if (!cookie) {
						var r:String = String(Math.random() * 1E10 >> 0);
						var t:String = String(new Date().time);
						cookie = {"user": r + "_" + t};
						c.put("statCookie", cookie, true);
					}
					_brCookie["seq"] = cookie.user;
				}
			}
			
			//获取消息
			var eventManager:Object = Context.getContext(ContextEnum.EVENT_MANAGER);
			if (eventManager) {
				eventManager.listen("showLoading", onShowingLoading);
				eventManager.listen("hideLoading", onHideLoading);
				//回链
				eventManager.listen("statRedirect", onRedirect);
				//点击
				eventManager.listen("statClick", onClick);
				//展示
				eventManager.listen("statShow", onShow);
				
//				eventManager.listen("onVideoInit", onInit);
			}
			
			sendFPV();
			
			//开启快捷键支持视频信息面板
			registerVideoInfo();
			
			Ticker.tick(2000, onCheckNodeInfo, 0);
		}
		
		private function onCheckNodeInfo():void {
			if (v && v.cid != _currentCID && v.playedTime > 0) {
				_currentCID = v.cid;
				
				if (opts && opts.length > 0) {
					while (opts.length > (_optIndex + 1)) {
						_optIndex ++;
						var o:Object = opts[_optIndex];
						sendNodeInfo(o);
					}
				} else {
					sendNodeInfo(null);
				}
			}
		}
		
		/**
		 * 点击 
		 * 
		 * @param data
		 */		
		private function onClick(data:Object):void {
			//暂时只统计直播站外（企业版）
			if (Context.variables["type"] != "f6") return;
			if (data) {
				onSendData({"id":"click", "action":data.action});
			}
		}
		
		/**
		 * 展示 
		 * 
		 * @param data
		 */		
		private function onShow(data:Object):void {
			//暂时只统计直播站外（企业版）
			if (Context.variables["type"] != "f6") return;
			if (data) {
				onSendData({"id":"show", "action":data.action});
			}
		}
		
		/**
		 * 回链 
		 * @param data
		 */		
		private function onRedirect(data:Object):void {
			if (data) {
				sendRedirectData(data);
			}
		}
		
		/**
		 * 发送回链环境
		 *  
		 * @param data
		 */		
		private function sendRedirectData(data:Object):void {
			onSendData({"id":"goback", "action":data.action});
		}
		
		/**
		 * 注册视频信息页面 
		 */		
		private function registerVideoInfo():void {
			var plugin:IPluginManager = Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager;
			var keyboard:Object = plugin.getPlugin(PluginEnum.KEYBOARD);
			if (keyboard && keyboard.hasOwnProperty("registerKeymap")) {
				keyboard.registerKeymap(onShowVideoInfo, Keyboard.CONTROL, Keyboard.NUMBER_1);
			}
		}
		
		/**
		 * 弹出视频信息页面 
		 */		
		private function onShowVideoInfo():void {
			if (_videoInfoPanel == null) {
				_videoInfoPanel = new VideoInfoPanel();
			}
			_videoInfoPanel.x = 20;
			_videoInfoPanel.y = 20;
			Context.stage.addChild(_videoInfoPanel);
		}
		
		/**
		 * 从浏览器cookie里获取用户唯一标示和渠道id 
		 */		
		private function getKeysFromBrowserCookie():void {
			_brCookie = {"seq":"", "channelid":""};
			if (JSBridge.enabled) {
				var cookie:String = JSBridge.addCall("function () { return document.cookie; }", null, "");
//				var cookie:String = "os=Win 7,bro=ff,sr=1366*768,ln=undefined; Hm_lvt_bb6514b03b6e773087dfd5f65438bf33=1385370158; Hm_lpvt_bb6514b03b6e773087dfd5f65438bf33=1385370158; live_17173_unique=92bbc6da6d9a4fa5be39e73007fdd2fd; JSESSIONID=abcYBUCURJlYi9cnWFoku; ONLINE_TIME=1385370158939; DIFF=1385370158253; SUV=1385371600828739; sessionid=138537160082873913853701778842921385370158252|2; sessionid2=138537160082873913853701778842921385370158252|2; NUV=1385395200000; IPLOC=CN1100";
				if (Util.validateStr(cookie)) {
					var keys:Array = cookie.split(";");
					for each (var pair:Object in keys) {
						var pairs:Array = pair.split("=");
						if (pairs && pairs.length == 2) {
							var k:String = Util.trimStr(pairs[0]);
							if (k == "liveqd") {
								_brCookie["channelid"] = pairs[1];
							} else if (k == "live_17173_unique") {
								_brCookie["seq"] = pairs[1];
							}
						}
					}
				}
			}
		}
		
		/**
		 * 隐藏了loading 
		 */		
		private function onHideLoading(data:Object):void {
			Ticker.stop(checkBuff);
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
		 * 缓冲状态 
		 */		
		private function onShowingLoading(data:Object):void {
			if (!_isTicking) {
				_isTicking = true;
				//计时2分钟发送
				Ticker.tick(120000, sendBufferStat);
			}
			
			//时间标记,当为0是进行记录,在hide的时候通过判断时间是否被记录来确认隐藏的准确时长
			if (_tickTimer == 0) {
				_tickTimer = getTimer();
			}
			
			Ticker.stop(checkBuff);
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && Context.getContext(ContextEnum.VIDEO_MANAGER).video && Context.getContext(ContextEnum.VIDEO_MANAGER).video.stream) {
				_startLoadingNum = Context.getContext(ContextEnum.VIDEO_MANAGER).video.stream.bytesLoaded;
				Ticker.tick(10000, checkBuff);
			}
		}
		
		/**
		 * 10秒检测
		 * 如果10秒内未加载到任何数据，向后端发送一个记录
		 */		
		private function checkBuff():void {
			Ticker.stop(checkBuff);
			try {
				var end:Number = Context.getContext(ContextEnum.VIDEO_MANAGER).video.stream.bytesLoaded;
				if (end - _startLoadingNum <= 0) {
					var obj:Object = {"cdn":v.streamName,"liveid":Context.getContext(ContextEnum.VIDEO_MANAGER)["data"]["cid"],"id":"demandplayfalse","type":"1"};
					onSendData(obj);
				}
			} catch (e:Error) {};
		}
		
		/**
		 * 发送缓冲统计 
		 */		
		private function sendBufferStat():void {
			_isTicking = false;
			
			if (_bufferData.length > 0) {
				//数据打包发出
				var i:String = "";
				var infos:Array = [];
				//字符串拼接
				while (_bufferData.length) {
					var data:Array = _bufferData.shift();
					
					infos.push("{" + data.join(",") + "}");
				}
				i = "{" + infos.join(",") + "}";
				
				var id:String = "buffer";
				if (!Context.variables["lv"]) {
					id = "demandbuffer";
				}
				
				var d:Object = {"info":i, "id":id};
				
				if (opts && opts.length > 0 && _optIndex >= 0 && (_optIndex + 1) <= opts.length) {
					d["opt"] = opts[_optIndex].opt;
				}
				
				onSendData(d);
			}
		}
		
		/**
		 * 发送fpv统计 
		 */		
		private function sendFPV():void {
			var id:String = "fpv";
			if (!Context.variables["lv"]) {
				id = "demandfpv";
			}
			onSendData({"id":id});
		}
		
		/**
		 * 当数据可用时发送节点信息. 
		 */		
		private function sendNodeInfo(i:Object):void {
			if (ip != null) {
				var id:String = "play";
				if (!Context.variables["lv"]) {
					id = "demandplay";
				}
				var info:Object = {"id":id};
				
				info.cdn = ip;
				info.liveid = v.cid;
				
				if (i && i.hasOwnProperty("opt")) {
					info.opt = i.opt;
				}
				
				onSendData(info);
			}
		}
		
		/**
		 * 数据封装发送
		 *  
		 * @param data
		 */		
		private function onSendData(data:Object):void {
			//必须字段(过滤字段)
			var url:String = BASE_URL + "&seq=" + _brCookie["seq"];
			url += "&channelid=" + _brCookie["channelid"];
			url += "&ftype=" + TYPE_DICT[Context.variables["type"]];
			url += "&url=" + Context.variables["refPage"];
			//数据字段
			for (var key:String in data) {
				url += ("&" + key + "=" + data[key]);
			}
			//时间戳
			url += "&t=" + new Date().time;
			
			try {
				var urlReq:URLRequest = new URLRequest(url);
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				urlLoader.load(urlReq);
			} catch (e:Error) {};
		}
		
		private static const TYPE_DICT:Object = {
			"f1":"1", 
			"f2":"2", 
			"f3":"3", 
			"f4":"4", 
			"f5":"5", 
			"f6":"6", 
			"f7":"7"
		};
		
		protected function onError(event:IOErrorEvent):void {
			
		}
		
		private function get opts():Array {
			var s:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
			if (s && s.hasOwnProperty("opts")) {
				return s["opts"];
			} else {
				return null;
			}
		}
		
		private function get v():Object {
			var vm:Object = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (vm && vm.hasOwnProperty("data") && vm.data) {
				return vm.data;
			} else {
				return null;
			}
		}
		
		private function get ip():String {
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