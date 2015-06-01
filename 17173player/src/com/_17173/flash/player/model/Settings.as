package com._17173.flash.player.model 
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.StageDisplayState;
	
	/**
	 * 播放器设置,使用sharedobject进行控制.
	 *  
	 * @author shunia-17173
	 */	
	public class Settings implements IContextItem
	{
		
		public static const ENV_LOCAL:int = 0;
		public static const ENV_REMOTE:int = 1;
		
		/**
		 * 清晰度字典
		 */
		public var defName:Object = {"0":"自动","1":"标清","2":"高清","4":"超清","8":"原画"};
		/**
		 * 播放器类型. 0:点播站内, 1:直播站内 
		 */		
//		private var _type:String = Settings.PLAYER_TYPE_FILE_ZHANEI;
		private var _type:String = PlayerType.F_ZHANEI;
		
		private var _params:Object = null;
		private var _cookie:Cookies = null;
		private var _cid:String = null;
		private var _ckey:String = null;
		private var _isLive:Boolean = false;
		private var _volume:Number = 50;
		private var _autoPlay:Boolean = true;
		private var _videoPageURL:String = null;
		private var _flashURL:String = null;
		private var _useP2P:Boolean = false;
		private var _path:Object = null;
		private var _isFullScreen:Boolean = false;
		private var _loadToStart:int = 3;
		private var _videoScale:int = PlayerVideoSize.VIDEO_SIZE_FIT;
		private var _userLogin:Boolean = false;
		private var _userID:String = null;
		private var _userName:String = null;
		private var _userImage:String = null;
		private var _debug:Boolean = true;
		private var _env:int = -1;
		private var _isSaving:Boolean = false;
		private var _speed:Number = 0;
		private var _isError:Boolean = false;
		private var _liveRoomID:String = null;
		private var _def:String = "-1";//清晰度,默认值为不存在（正常为1，2，4，8）
		private var _showLogo:Boolean = false;//站内默认不显示
		private var _canShare:Boolean = true;//站内默认可以
		private var _isAutoDef:Boolean = false;//是否是播放器自动算出的清晰度
		private var _nikeName:String = "";//主播名（直播用）
		private var _gameName:String = "";//游戏名（直播用）
		private var _roomName:String = "";//房间名（直播用）
		
		public function Settings()
		{
			//初始化cookie
			_cookie = new Cookies("shared", "/");
		}
		
		public function startUp(param:Object):void
		{
			_params = param;
			
			parseParams();
			
			_("controlBarHeight", 35);
			
			//直播默认缓冲15秒
			_loadToStart = _isLive ? 2 : 3;
		}
		
		private function parseParams():void {
			_debug = parseP(_params, "debug", false);
			_type = parseP(_params, "type", null);
			_isLive = parseP(_params, "lv", false);
//			_useP2P = parseP(_params, "pr", false);
			_cid = parseP(_params, "cid", null);
			_ckey = parseP(_params, "ckey", null);
			_userID = parseP(_params, "userId", null);
			
			_autoPlay = parseP(_params, "autoplay", true);
			_canShare = parseP(_params, "canShare", true);
			_showLogo = parseP(_params, "canShare", false);
			_liveRoomID = parseP(_params, "liveRoomId", null);
			
			if (Util.validateStr(_userID) && _userID != "undefined") {
				_userLogin = true;
			}
			if (_debug) {
				_params["ad"] = _params["adTest"];
			}
			
			var saved:String = getCookie("volume");
			if(saved && saved.length > 0)
			{
				var temp:Array = saved.split("_");
				if(temp.length > 1)
				{
					_volume = Number(temp[1]);
				}
			}
			
			//获取so中的def
			var soDef:String = getCookie("def");
			if (soDef) {
				_def = soDef;
			}
			
			var jsNS:String = _params["objectName"];
			if (jsNS) {
				JSBridge.defaultNameSpace = jsNS;
			} else {
				JSBridge.defaultNameSpace = "window";
			}
		}
		
		private function parseP(obj:Object, property:String, defaultValue:*):* {
			return obj.hasOwnProperty(property) ? obj[property] : defaultValue;
		}

		/**
		 * 全局参数 
		 * @return 
		 */		
		public function get params():Object
		{
			return _params;
		}

		/**
		 * 将cookie数据写入缓存 
		 * @param key
		 * @param value
		 */		
		public function saveCookie(key:String, value:*):void {
			if (_cookie == null) {
				_cookie = new Cookies("shared", "/");
			}
			_cookie.put(key, value);
			
			if (!_isSaving) {
				_isSaving = true;
				//save later
				Ticker.tick(3000, onSave);
			}
		}
		
		/**
		 * 存cookie,写io 
		 */		
		private function onSave():void {
			_isSaving = false;
			_cookie.flush(null, onFail);
			_cookie.close();
			_cookie = null;
		}
		
		private function onFail():void {
			Debugger.log(Debugger.ERROR, "Cookie flush failed!");
		}
		
		/**
		 * flash cookie 
		 * @param key
		 * @return 
		 */		
		public function getCookie(key:String):* {
			if (_cookie == null) {
				_cookie = new Cookies("shared", "/");
			}
			return _cookie.get(key);
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get volume():Number
		{
			return _volume;
		}

		/**
		 * 音量 
		 * @param value
		 */		
		public function set volume(value:Number):void
		{
			_volume = value;
			saveCookie("volume", "v_" + _volume);
		}
		
		/**
		 * 获取so中的清晰度
		 * @private 
		 * @return 
		 */		
		public function get def():String
		{
			return _def;
		}
		
		/**
		 * 往so中设置清晰度
		 * @param value
		 */		
		public function set def(value:String):void
		{
			_def = value;
//			saveCookie("def", _def);
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}

		/**
		 * 是否自动播放 
		 * @param value
		 */		
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get userID():String
		{
			return _userID;
		}

		/**
		 * 用户id 
		 * @param value
		 */		
		public function set userID(value:String):void
		{
			_userID = value;
		}

		public function get userName():String
		{
			return _userName;
		}

		public function set userName(value:String):void
		{
			_userName = value;
		}

		/**
		 * 用户图片地址 
		 * @return 
		 */		
		public function get userImage():String
		{
			return _userImage;
		}

		/**
		 * @private 
		 * @param value
		 */		
		public function set userImage(value:String):void
		{
			_userImage = value;
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get pageURL():String
		{
			return _videoPageURL;
		}

		/**
		 * 视频播放页面链接 
		 * @param value
		 */		
		public function set pageURL(value:String):void
		{
			_videoPageURL = value;
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get useP2P():Boolean
		{
			return _useP2P;
		}

		/**
		 * 是否使用p2p 
		 * @param value
		 */		
		public function set useP2P(value:Boolean):void
		{
			_useP2P = value;
		}

		/**
		 * 是否debug状态 
		 * @return 
		 */		
		public function get debug():Boolean
		{
			return _debug;
		}

		/**
		 * 用户是否已登录 
		 * @return 
		 */		
		public function get userLogin():Boolean
		{
			return _userLogin;
		}
		
		/**
		 * 用户是否已登录 
		 * @return 
		 */		
		public function set userLogin(value:Boolean):void
		{
			this._userLogin = value;
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get path():Object
		{
			return _path;
		}

		/**
		 * 当前路径的配置文件 
		 * @param value
		 */		
		public function set path(value:Object):void
		{
			_path = value;
		}

		/**
		 * @private 
		 * @return 
		 */		
		public function get flashURL():String
		{
			return _flashURL;
		}

		/**
		 * 当前视频swf文件的链接 
		 * @param value
		 */		
		public function set flashURL(value:String):void
		{
			_flashURL = value;
		}
		
		/**
		 * @private
		 * @return  
		 */		
		public function get isFullScreen():Boolean
		{
			return _isFullScreen;
		}

		/**
		 * 当前是否全屏 
		 * @param value
		 */		
		public function set isFullScreen(value:Boolean):void
		{
			_isFullScreen = value;
		}

		/**
		 * 视频加载多少秒才开始播放 
		 * @return 
		 */		
		public function get loadToStart():int
		{
			return _loadToStart;
		}

		public function get env():int
		{
			if (_env < 0) {
				var uri:String = _("stage").loaderInfo.loaderURL.split("/")[0];
				if (uri == "http" || uri == "https") {
					_env = ENV_REMOTE;
				} else {
					_env = ENV_LOCAL;
				}
			}
			return _env;
		}

		/**
		 * 弹出登陆框让用户登陆 
		 */		
		public function login():void {
			if (_userLogin == false) {
				if (_("stage").displayState != StageDisplayState.NORMAL) {
					_("stage").displayState = StageDisplayState.NORMAL;
				}
				JSBridge.addCall("needLogin");
			}
		}
		
		/**
		 * 视频缩放等级 
		 * @return 
		 * 
		 */		
		public function get videoScale():int
		{
			return _videoScale;
		}

		public function set videoScale(value:int):void {
			_videoScale = value;
			
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_VIDEO_RESIZE);
		}

		/**
		 * 加载视频的速度
		 * @return 
		 * 
		 */		
		public function get speed():Number
		{
			return _speed;
		}

		public function set speed(value:Number):void
		{
			_speed = value;
		}
		
		/**
		 * 当前是否已经是错误状态
		 * 错误状态是能够影响到视频播放的错误,例如:获取ns错误,获取文件主数据错误
		 */		
		public function get isError():Boolean
		{
			return _isError;
		}
		
		
		public function set isError(value:Boolean):void
		{
			_isError = value;
		}
		
		/**
		 * 当前播放器所在的域地址. 
		 * @return 
		 */		
		public function get ref():String {
			return params["ref"];
		}
		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 是否显示logo
		 */		
		public function get showLogo():Boolean
		{
			return _showLogo;
		}
		
		
		public function set showLogo(value:Boolean):void
		{
			_showLogo = value;
		}
		
		/**
		 * 是否可以使用分享功能
		 */		
		public function get canShare():Boolean
		{
			return _canShare;
		}
		
		
		public function set canShare(value:Boolean):void
		{
			_canShare = value;
		}

		public function get ckey():String
		{
			return _ckey;
		}

		public function set ckey(value:String):void
		{
			_ckey = value;
		}

		public function get isAutoDef():Boolean
		{
			return _isAutoDef;
		}
		
		public function set isAutoDef(value:Boolean):void
		{
			_isAutoDef = value;
		}

		public function get contextName():String
		{
			return ContextEnum.SETTING;
		}
		
		public function get liveRoomID():String
		{
			return _liveRoomID;
		}
		
		public function set liveRoomID(value:String):void
		{
			_liveRoomID = value;
		}
		
		/**
		 * 以时间戳作为mark 
		 * @return 
		 */		
		private function createTimeStamp():String {
			return String(new Date().time);
		}

		/**
		 * 主播名
		 */		
		public function get nikeName():String
		{
			return _nikeName;
		}

		public function set nikeName(value:String):void
		{
			_nikeName = value;
		}
		/**
		 * 游戏名
		 */
		public function get gameName():String
		{
			return _gameName;
		}

		public function set gameName(value:String):void
		{
			_gameName = value;
		}

		/**
		 * 房间名
		 */		
		public function get roomName():String
		{
			return _roomName;
		}

		public function set roomName(value:String):void
		{
			_roomName = value;
		}
		
	}
}