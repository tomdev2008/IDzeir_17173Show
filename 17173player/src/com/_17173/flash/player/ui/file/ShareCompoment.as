package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.share.QQWeiboParams;
	import com._17173.flash.core.util.share.QQZoneShareParams;
	import com._17173.flash.core.util.share.ShareTo;
	import com._17173.flash.core.util.share.ShareToParams;
	import com._17173.flash.core.util.share.WeiboShareParams;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	/**
	 * 分享组件
	 *  
	 * @author shunia-17173
	 */	
	public class ShareCompoment extends Sprite
	{
		private var _share:MovieClip = null;
		private var _isLoading:Boolean = false;
		private var _shareName:String = "";
		
		public function ShareCompoment()
		{
			super();
		}
		
		/**
		 * 是否直播 
		 */		
		private function get isStream():Boolean {
			return v && v.isStream;
		}
		
		/**
		 * 视频数据
		 *  
		 * @return 
		 */		
		private function get v():IVideoData {
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			if (v) {
				return v.data;
			} else {
				return null;
			}
		}
		
		/**
		 * 显示分享 
		 */		
		public function showShare():void {
			if (_share) {
				onShareLoaded(_share);
			} else {
				//如果正在加载,则不做处理
				if (_isLoading) return;
				_isLoading = true;
				var loader:LoaderProxy = new LoaderProxy();
//				var option:LoaderProxyOption = new LoaderProxyOption(Global.settings.ref + "/assets/Share.swf", LoaderProxyOption.FORMAT_SWF, LoaderProxyOption.TYPE_ASSET_LOADER, onShareLoaded);
				var option:LoaderProxyOption = new LoaderProxyOption(Context.getContext(ContextEnum.SETTING)["ref"] + "/assets/Share.swf", LoaderProxyOption.FORMAT_SWF, LoaderProxyOption.TYPE_ASSET_LOADER, onShareLoaded);
				loader.load(option);
			}
		}
		
		/**
		 * 成功加载
		 *  
		 * @param data
		 */		
		private function onShareLoaded(data:Object):void {
			_isLoading = false;
			if (_share == null) {
				_share = data is MovieClip ? data as MovieClip : data.content as MovieClip;
				_share.addEventListener("clickEvent", clickShare);
				_share.addEventListener("close", closeShare);
				_share.addEventListener("WeiboEvent", clickShare);
				_share.addEventListener("qzoneEvent", clickShare);
				_share.addEventListener("QQEvent", clickShare);
				_share.addEventListener("sohuWeiboEvent", clickShare);
				_share.addEventListener("renrenEvent", clickShare);
				_share.addEventListener("kaixinEvent", clickShare);
				_share.addEventListener("doubanEvent", clickShare);
				_share.addEventListener("baiduEvent", clickShare);
			}
			//传递参数
			shareCall();
			//弹出
//			Global.uiManager.popup(_share);
			Context.getContext(ContextEnum.UI_MANAGER).popup(_share);
			//没出后推并且不是直播,则暂停
			if (!Context.variables["showBackRec"] && !isStream) {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
//				Global.eventManager.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
//				Global.videoManager.togglePlay(false);
			}
		}
		
		/**
		 * 给swf文件传递参数 
		 */		
		private function shareCall():void {
			if (isStream) {
				_share.call(prepareStreamParams());
			} else {
				_share.call(prepareFileParams());
			}
		}
		
		/**
		 * 准备直播分享基本参数
		 * 直播分享框大小和点播不同
		 *  
		 * @return 
		 */		
		private function prepareStreamParams():Object {
			return {
				"sharepagelink" : Context.variables["url"], 
				"shareflashlink" : Context.variables["flashURL"], 
//				"title" : v ? "" : v["title"],
				"title" : getTitle(),
				"width" : 580,
				"height" : 370,
				"domain" : "http://v.17173.com/live",
				"fullType" : "allowFullScreenInteractive"
			};
		}
		
		/**
		 * 准备点播分享基本参数 
		 * 
		 * @return 
		 */		
		private function prepareFileParams():Object {
			return {
				"sharepagelink" : Context.variables["url"], 
				"shareflashlink" : Context.variables["flashURL"], 
//				"title" : v ? "" : v["title"],
				"title" : getTitle(),
				"width" : 480,
				"height" : 400,
				"domain" : "http://v.17173.com",
				"fullType" : "allowFullScreen"
			};
		}
		
		/**
		 * 点击分享
		 *  
		 * @param e
		 */		
		private function clickShare(e:Event):void {
			doFullScreen();
			var shareParam:Object = null;
			if (isStreamType()) {
				_shareName = "  @17173游戏直播";
			} else {
				_shareName = "  @17173游戏视频";
			}
			switch (e.type) {
				case "WeiboEvent" : 
					shareParam = new WeiboShareParams();
					break;
				case "qzoneEvent" : 
					shareParam = new QQZoneShareParams();
					break;
				case "QQEvent" : 
					shareParam = new QQWeiboParams();
					if (isStreamType()) {
						_shareName = "  @17173直播频道";
					}
					break;
//				case "renrenEvent" : 
//					shareParam = new RenRenShareParams();
//					break;
//				case "sohuWeiboEvent" : 
//					shareParam = new SohuWeiBoParams();
//					break;
//				case "kaixinEvent" : 
//					shareParam = new KaixinParams();
//					break;
//				case "doubanEvent" : 
//					shareParam = new DoubanParams();
//					break;
//				case "baiduEvent" : 
//					shareParam = new BaiduParams();
//					break;
			}
			if (shareParam) {
				installShareParams(shareParam);
				ShareTo.t(shareParam as ShareToParams);
			}
		}
		
		/**
		 * 统一处理分享内容
		 *  
		 * @param param
		 */		
		private function installShareParams(param:Object):void {
			//标题
			param.title = getTitle();
			if (isStream) {
				//直播分享链接
				param.url = Context.variables["flashURL"];
			} else {
				//点播分享链接
				param.url = Context.variables["url"];
				//点播分享缩略图
				param.pic = v ? v["thumbnail"] : null;
			}
		}
		
		/**
		 * 获取分享视频标题
		 *  
		 * @return 
		 */		
		private function getTitle():String {
			var s:Array = [];
			if (isStreamType()) {
				return '我正在17173游戏直播平台观看  "' + Context.variables["nickName"] + '"在"' + Context.variables["roomName"] + '"' + Context.variables["gameName"] + '的直播，点击链接火速前往围观~' + _shareName;
			} else {
				//如果有大类定义
				var b:Boolean = v && Object(v).hasOwnProperty("aClassName") && v["aClassName"] != "其他";
				//把小类说明嵌入进去
				if (b) {
					s[0] = v["bClassName"] ? v["bClassName"] : "";
				} else {
					s[0] = "";
				}
				//标题
				s[1] = v["title"] ? v["title"] : "";
				//整合
				return "这个" + s[0] + "视频真不错！" + s[1] + _shareName;
			}
		}
		
		/**
		 * 判断是否是直播播放器
		 */		
		private function isStreamType():Boolean {
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_FIRST_PAGE || 
//				Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM || 
//				Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_ZHANNEI) {
			if (Context.variables["type"] == PlayerType.S_SHOUYE || 
				Context.variables["type"] == PlayerType.S_CUSTOM || 
				Context.variables["type"] == PlayerType.S_ZHANNEI) {
				return true;
			} else {
				return false;
			}
		}
		
//		private function weiboClickEvent(evt:Event):void {
//			var param:WeiboShareParams = new WeiboShareParams();
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
//				weibo_outStream(param);
//			} else {
//				weibo_file(param);
//			}
//		}
//		
//		/**
//		 * 点播微博分享
//		 */		
//		private function weibo_file(param:WeiboShareParams):void {
//			if(FileVideoData(Global.videoData).aClassName != "其他")
//			{
//				param.title = "这个"+ FileVideoData(Global.videoData).bClassName +"视频真不错！ " + Global.videoData["title"] + "  @17173游戏视频";
//			}
//			else
//			{
//				param.title = "这个视频真不错！ " + Global.videoData["title"] + "  @17173游戏视频";
//			}
//			param.url = Global.settings.pageURL;
//			param.pic = FileVideoData(Global.videoData).thumbnail;
//			ShareTo.t(param);
//		}
//		
//		/**
//		 * 直播站外微博分享
//		 */	
//		private function weibo_outStream(param:WeiboShareParams):void {
//			param.title = "这个视频真不错！ " + Global.videoData["title"] + "  @17173游戏视频";
//			param.url = _liveOutSwfUrl + Global.settings.pageURL.split("|")[0];
////			param.pic = FileVideoData(Global.videoData).thumbnail;
//			ShareTo.t(param);
//		}
//		
//		private function QzoneClickEvent(evt:Event):void
//		{
//			doFullScreen();
//			var param:QQZoneShareParams = new QQZoneShareParams();
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
//				Qzone_outStream(param);
//			} else {
//				Qzone_file(param);
//			}
//		}
//		
//		/**
//		 * 点播qq空间分享
//		 */	
//		private function Qzone_file(param:QQZoneShareParams):void {
//			param.title = Global.videoData["title"];
//			param.url = Global.settings.pageURL;
//			param.pic = FileVideoData(Global.videoData).thumbnail;
//			ShareTo.t(param);
//		}
//		
//		/**
//		 * 直播站外qq空间分享
//		 */	
//		private function Qzone_outStream(param:QQZoneShareParams):void {
//			param.title = Global.videoData["title"];
//			param.url = _liveOutSwfUrl + Global.settings.pageURL.split("|")[0];
////			param.pic = FileVideoData(Global.videoData).thumbnail;
//			ShareTo.t(param);
//		}
//		
//		private function qqClickEvent(evt:Event):void
//		{
//			doFullScreen();
//			var param:QQWeiboParams = new QQWeiboParams();
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
//				qq_outStream(param);
//			} else {
//				qq_file(param);
//			}
//		}
//		
//		/**
//		 * 点播qq空间
//		 */		
//		private function qq_file(param:QQWeiboParams):void {
//			param.title = Global.videoData["title"] + "  @17173游戏视频";
//			param.url = Global.settings.pageURL;
//			param.pic = FileVideoData(Global.videoData).thumbnail;
//			ShareTo.t(param);
//		}
//		
//		/**
//		 * 直播站外qq空间
//		 */		
//		private function qq_outStream(param:QQWeiboParams):void {
//			param.title = Global.videoData["title"] + "  @17173游戏视频";
//			param.url = _liveOutSwfUrl + Global.settings.pageURL.split("|")[0];
//			ShareTo.t(param);
//		}
		
		private function doFullScreen():void {
//			if (Global.settings.isFullScreen) {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function closeShare(evt:Event):void
		{
			closeThis();
		}
		
		private function closeThis():void
		{
			if (_share) {
//				Global.uiManager.closePopup(_share);
				Context.getContext(ContextEnum.UI_MANAGER).closePopup(_share);
			}
//			Global.videoManager.togglePlay(true);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(true);
		}
		
	}
}