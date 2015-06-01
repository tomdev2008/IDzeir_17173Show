package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.DataRetriver;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.module.quiz.data.QuizData;
	
	import flash.net.URLVariables;

	/**
	 * 直播数据接口集合. 
	 * @author shunia-17173
	 */	
	public class StreamDataRetriver extends DataRetriver
	{
		
		//http://gslb.tv.sohu.com/live?cid=398408&ckey=null&ver=2.0&prot=3&optimal=1&sip=&t=0.6546480348333716
		/**
		 * 调度链接 
		 */		
		protected static const DISPATCH_URL:String = "http://gslb.v.17173.com/live";
		/**
		 * 后推链接 
		 */		
		private static const PERSONAL_MORE_PATH:String = "http://v.17173.com/live/ch_like.action";
		private static const ORG_MORE_PATH:String = "http://v.17173.com/live/ch_orgLike.action";
		/**
		 * 直播信息 
		 */		
		private static const STREAM_INFO:String = "http://v.17173.com/live/l_flashLiveInfo.action";
		
		public static const STREAM_SERACH_RUL:String = "http://v.17173.com/live/search/";
		/**
		 * 获取竞猜用户的状态
		 */		
		private static const QUIZ_USER_STATE:String = "http://v.17173.com/live/jc_getUserGuessCompetence.action";
		/**
		 * 添加竞猜信息
		 */
		private static const QUIZ_ADD_QUIZ_DATA:String = "http://v.17173.com/live/jc_openGuess.action";
		/**
		 * 获取用户信息（头像、金币、银币等）
		 */		
		private static const GET_USER_INFO:String = "http://v.17173.com/live/mi_info.action";
		
		/**
		 * 获取竞猜信息
		 */
		private static const QUIZ_GET_QUIZ_INFO:String = "http://v.17173.com/live/jc_getAllGuessInfo.action";
		
		/**
		 * 额外的信息,包含直播标题,机构/个人的类别,直播间链接,直播id等 
		 */		
		private var _info:Object = null;
		private var _isRequestingInfo:Boolean = false;
		
		private var _cid:String = null;
		private var _ckey:String = null;
		private var _cdnType:int = 0;
		private var _isP2p:Boolean = false;
		private var _p2pUrl:String = null;
		private var _streamName:String = null;
		private var _onSuccess:Function = null;
		private var _onFail:Function = null;
		
		private var _ip:String = null;
		private var _ports:Array = null;
		private var _lastfix:String = null;
		private var _portIndex:int = 0;
		
		private static const RETRY:int = 20;
		
		private var _retry:int = 0;
		private var _optimal:int = 1;
		
		//缓存的opt结果的数组,每当调度成功之后会往这个数组里放入当前的opt状态.
		private var _opts:Array = [];
		
		public function StreamDataRetriver()
		{
		}
		
		/**
		 * 发起调度 
		 * @param cid
		 * @param callback
		 */		
		override public function startDispatch(cid:String, onSuccess:Function, onFail:Function):void {
			var v:Object = Context.variables;
			_cid = v["cid"];
			_ckey = v["ckey"];
			_cdnType = v["cdnType"];
			_streamName = v["streamName"];

			_isP2p = v["pr"];
			_p2pUrl = v["p2pUrl"];
			
			_onSuccess = onSuccess;
			_onFail = onFail;
			_optimal = 1;
			_retry = RETRY;
			
			dispatch();
		}
		
		public function get opts():Array {
			return _opts;
		}
		
		private function dispatch():void {
//			_onSuccess(parseDataToObject(null));
//			return;
			if (Util.validateStr(_cid) && Util.validateStr(_ckey) && Util.validateStr(_streamName)) {
				var u:String = 
					"cid=" + _cid + 
					"&ckey=" + _ckey + 
					"&ver=2.0" +
					"&prot=3" +
					"&optimal=" + _optimal + 
					"&sip=";
				u += ("&cdntype=" + int(_cdnType));
				u += ("&name=" + String(_streamName));
				//添加p2p
				
				//如果是p2p并且cdnType不是5 就默认是yc的p2p 这时候要更换调度链接
				//cdnType==5 是网宿的p2p 
				//cdnType!=5 是云成的p2p
				if((_isP2p)&&(_cdnType!=5)){
					u += ("&isp2p=" + 1);
					u += ("&p2purl=" + _p2pUrl);
				}else{
					u += ("&isp2p=" + 0);
				}
				packupLoader(
					DISPATCH_URL, 
					function (data:Object):void {
						_onSuccess(parseDataToObject(data));
						if (_optimal == 0) {
							_optimal = 1;
						}
					}, 
					LoaderProxyOption.FORMAT_VARIABLES, 
					new URLVariables(u
						), 
					null, 
					null, 
					function (e:Object):void {
						_optimal = 0;
						onDispatchFail(e, _onFail);
					}
				);
			} else {
				Debugger.log(Debugger.ERROR, "[dispatch]", "参数无效, cid: " + _cid, ",ckey: " + _ckey, ",cdnType: " + _cdnType, ",streamName: " + _streamName);
				var error:Object = PlayerErrors.packUpError(
					PlayerErrors.STREAM_DISPATCH_PARAMETER_INVALID, "调度失败,没有cid/ckey/cdnType/streamName参数!");
				onDispatchFail(error, _onFail);
			}
		}
		
		private function onDispatchFail(error:Object, onFail:Function):void {
			if (error.hasOwnProperty("code")) {
				Debugger.log(Debugger.INFO, "[调度]", "失败,重试倒数第" + _retry + "次");
				_retry --;
				if (_retry <= 0) {
					//尝试到结束
					onFail(PlayerErrors.packUpError(PlayerErrors.STREAM_DISPATCH_NO_SERVER, error.msg));
				} else {
					//3秒后重试
					Ticker.tick(3000, dispatch);
				}
			} else {
				onFail(error);
			}
		}
		
		/**
		 * 调度数据解析. 
		 * @param data
		 * @return 
		 */		
		private function parseDataToObject(data:Object):Object {
//			var v:StreamVideoData = Global.videoData as StreamVideoData;
			var v:StreamVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data as StreamVideoData;

//			onTestIp(data.url);
			var u:String = null;
			var n:String = null;
			if (data.hasOwnProperty("port")) {
				try {
					_portIndex = 0;
					_ip = data.ip;
					_lastfix = data.key;
					_ports = data.hasOwnProperty("port") && data.port ? data.port.split("|") : null;
					var isRtmp:Boolean = _ip.substr(0, 4).indexOf("rtmp") != -1;
					if (isRtmp) {
						//没端口认为是rtmp
						n = _ip;
						u = _lastfix;
					} else {
						//http就连起来
						n = null;
						u = _ip + _ports[0] + _lastfix;
						u += "&t=" + new Date().time;
					}
				} catch (e:Error) {
					n = null;
					u = data.url;
				}
			} else {
				n = null;
				u = data.url;
			}
			
			Debugger.log(Debugger.INFO, "[调度]", "当前地址: ", n + u);
			
			v.streamName = u;
			v.connectionURL = n;
			
			v.useP2P = Context.variables["pr"];
			v.isStream = true;
			
			_opts.push({"opt":_optimal, "url":u});
			
			return v;
		}
		
		private function onTestIp(url:String):void {
			var arr:Array = url.split("8080");
			if (arr.length) {
				_ip = arr[0];
				_ports = ["8080", "8080", "8080"];
				_lastfix = arr[arr.length - 1];
			}
		}
		
		public function changePort():String {
			if (_ports == null || _ports.length == 0) {
				return null;
			}
			_portIndex ++;
			if (_portIndex >= _ports.length) {
				_portIndex = 0;
				return null;
			}
			var u:String = _ip + _ports[_portIndex] + _lastfix;
			Debugger.log(Debugger.INFO, "[调度]", "切换到端口" + (_portIndex + 1) + ": ", _ports[_portIndex] + ", 实际url: " + u);
			return u;
		}
		
		/**
		 * 请求后推 
		 * @param callback
		 */		
		override public function reqForMore(id:String, callback:Function):void {
//			var videoData:StreamVideoData = Global.videoData as StreamVideoData;
			var videoData:StreamVideoData = ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data) as StreamVideoData;
			var url:String = (videoData.isOrg ? ORG_MORE_PATH : PERSONAL_MORE_PATH);
			var v:URLVariables = new URLVariables();
			v.decode("liveRoomId=" + id);
			packupLoader(url, callback, LoaderProxyOption.FORMAT_JSON, v);
		}
		
		/**
		 * 获取指定直播的详细信息 
		 * @param roomID
		 * @param callback
		 */		
		public function getInfo(roomID:String, callback:Function = null, failback:Function = null):void {
			if (_isRequestingInfo) return;
			_isRequestingInfo = true;
			var url:String = STREAM_INFO;
			var v:URLVariables = new URLVariables();
			v.decode("liveRoomId=" + roomID);
			packupLoader(url, 
				function (data:Object):void {
					_isRequestingInfo = false;
					_info = data;
					_info.roomID = roomID;
					if (callback != null) {
						callback(_info);
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					_isRequestingInfo = false;
					if(failback != null){
						failback(PlayerErrors.packUpError(PlayerErrors.LIVE_INFO_ERROR, "url: " + url));
					}
//					onError(PlayerErrors.packUpError(PlayerErrors.LIVE_INFO_ERROR, "url: " + url));
				});
		}
		
		/**
		 * 获取当前直播间竞猜功能用户的状态
		 * @param roomID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getUserQuizState(roomID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_USER_STATE;
			var v:URLVariables = new URLVariables();
			v.decode("liveroomId=" + roomID);
			packupLoader(url, 
				function (data:Object):void {
					if (onSuccess != null) {
						onSuccess(data);
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 获取用户信息
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getUserInfo(onSuccess:Function, onFail:Function):void {
			var url:String = GET_USER_INFO;
			packupLoader(url, 
				function (data:Object):void {
					if (onSuccess != null) {
						onSuccess(data);
					}
				}, LoaderProxyOption.FORMAT_JSON, null, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 添加竞猜信息
		 * @param data
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function addQuizInfo(data:Object, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_ADD_QUIZ_DATA;
			var v:URLVariables = new URLVariables();
			v.decode("liveroomId=" + data["roomID"]);
			v.decode("title=" + data["title"]);
			v.decode("a=" + data["leftTitle"]);
			v.decode("b=" + data["rightTitle"]);
			v.decode("currency=" + data["currency"]);
			packupLoader(url, 
				function (data:Object):void {
					if (onSuccess != null) {
						onSuccess(data);
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 加载竞猜数据
		 */		
		public function LoadQuzi(roomID:String, needTrueTime:Boolean, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_GET_QUIZ_INFO;
			var v:URLVariables = new URLVariables();
			v.decode("liveroomId=" + roomID);
//			v.decode("liveroomId=" + "1");
			v.decode("realtime=" + needTrueTime);
			v.decode("type=3");
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code")) {
						if (onSuccess != null) {
							onSuccess(retriverQuziInfo(data));
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, validateGetQuizInfo, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 判断接口正确性. 
		 * @param data
		 * @return 
		 */		
		protected function validateGetQuizInfo(data:Object):Boolean {
			if (data && data.hasOwnProperty("code")) {
				return true;
			}
			return false;
		}
		
		/**
		 * 解析竞猜数据
		 */	
		private function retriverQuziInfo(value:Object):Array {
			var re:Array = [];
			if (Util.validateObj(value, "obj")) {
				var temp:Array = [];
				if (value["obj"].hasOwnProperty("govguessinfo")){
					temp = value["obj"]["govguessinfo"];
					if (temp) {
						for (var j:int = 0; j < temp.length; j++) {
							var item:QuizData = new QuizData();
							item.resolveData(temp[j]);
							item.type = 0;
							if (item.id != "") {
								re.push(item);
							}
						}
					}
				}
				if (value["obj"].hasOwnProperty("guessinfo")) {
					temp = value["obj"]["guessinfo"];
					if (temp) {
						for (var i:int = 0; i < temp.length; i++) {
							var item1:QuizData = new QuizData();
							item1.resolveData(temp[i]);
							item1.type = 1;
							if (item1.id != "") {
								re.push(item1);
							}
						}
					}
				}
			}
			return re;
		}

		
	}
}