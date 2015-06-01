package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.BusinessJSDelegate;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	public class FileBusinessJSDelegate extends BusinessJSDelegate
	{
		/**
		 * 前贴/大前贴/错误 播放完毕标识位
		 */		
		private var _fistAdCompletFlag:Boolean;
		
		public function FileBusinessJSDelegate()
		{
			super();
		}
		
		override public function startUp(param:Object):void {
			super.startUp(param);
			
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_AD_COMPLETE, firestAdComplete);
//			listen("setPause", setPause);
			listen("setPlay", onSeek);
			listen("playNext", onPlayNext);
			listen("setPauseOnly", setPauseOnly);
			listen("toPlay", onPlay);
		}
		
		/**
		 * 设置播放或者暂停
		 */
		override protected function onPause():void {
			Debugger.log(Debugger.INFO, "JS调用播放器进行暂停!");
			if (!(_(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished) {
				// 暂停
				_(ContextEnum.VIDEO_MANAGER) && 
					_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_PLAY_OR_PAUSE, false);
			}
		}
		
		/**
		 * 前贴/大前贴/错误 播放完毕 
		 */		
		private function firestAdComplete(data:Object):void {
			_fistAdCompletFlag = true;
		}
		
		/**
		 * 设置暂停，并且不显示暂停广告
		 * 奇遇使用
		 */		
		private function setPauseOnly():void {
			if (!(_(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished && _fistAdCompletFlag) {
				var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
				v.togglePlay(false);
			}
		}
		
//		private function setPause():void {
//			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
//			v.togglePlay(false);
//		}
		
		/**
		 * 直接设置视频跳转到某个位置
		 */
		private function onSeek(value:String):void
		{
			if (!_fistAdCompletFlag) {
				return;
			}
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			v.togglePlay(true);
			
			if (value && value != "" && int(value) > 0) {
				v.seek(int(value));
			}
		}
		
		private function onPlay():void {
			if (!_fistAdCompletFlag) {
				return;
			}
			_(ContextEnum.VIDEO_MANAGER) && 
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_PLAY_OR_PAUSE, true);
		}
		
		/**
		 * 直接从js获取，开始播放新的视频
		 */
		private function onPlayNext(cid:String):void
		{
			var id:String = Base64.decodeStr(cid);
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.send(PlayerEvents.BI_SWITCH_STREAM, {"cid":id});
		}
		
		/**
		 * 存播放记录
		 */
		public function onLocalPoint():void {
			var obj:Object = new Object();
//			var videoData:IVideoData = Global.videoData;
			var videoData:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			var isPlayed:int = (videoData.playedTime) > (videoData.totalTime - 10) ? 1 : 0;
//			obj["uid"] = Global.settings.userID;
			obj["uid"] = Context.getContext(ContextEnum.SETTING).userID;
			obj["vid"] = videoData["cid"];
			obj["playtime"] = int(videoData.playedTime);
			obj["isfinished"] = isPlayed;
			obj["date"] = new Date().getTime();
			obj["per"] = int(videoData.playedTime / videoData.totalTime * 100) + "%";
			//			JSBridge.addCall("log", "发送记录到js: " + obj["playtime"] + "秒, 是否播放结束: " + obj["isfinished"], "console");
			send("onLocalPoint", obj);
		}
		
		/**
		 * 跳转到评论 
		 */		
		public function showTalk():void {
			send("showReview");
		}
		
		/**
		 * 获取连播的状态
		 * true:不联播
		 */
		public function getPlayNextState():Boolean
		{
			//返回true为不联播
			var re:Boolean = true;
			JSBridge.addCall("flashNextClosed", null, null, 
				function(value:Object):void{
					if (value == "null" || value == null) {
						re = true;
					} else {
						var temp:Boolean = value as Boolean;
						if(temp) {
							re = true;
						} else {
							re = false;
						}
					}
				});
			return re;
		}
		
		/**
		 * 判断是否有大前贴播放器
		 * 供点播站外播放器播放大前贴使用
		 */		
		public function checkCanShowDaQianTie():String {
			var re:String = "";
			var s:String = Context.variables["flashURL"];
			var jsBack:Boolean = JSBridge.addCall("supportA1", getCid(), null,
				function(value:Object):void {
//					Debugger.log(Debugger.INFO, "站外大前贴测试0：" + value);
					var backStr:String = value as String;
//					Debugger.log(Debugger.INFO, "站外大前贴测试：" + backStr);
					if (backStr && backStr != "") {
						re = backStr;
					} else {
						re = "";
					}
				}, false);
			if (!jsBack) {
				re = "";
			}
//			Debugger.log(Debugger.INFO, "站外大前贴测试1：" + re);
			return re;
		}
		
		/**
		 * 根据当前flashURL的地址，截取出cid原始的数据
		 * 点播站外展示大前贴定位使用
		 */		
		private function getCid():String {
			var re:String = "";
			var url:String = Context.variables["flashURL"];
			if (!url || url == "") {
				return "";
			}
//			Debugger.log(Debugger.INFO, "站外大前贴测试0111：" + url);
			if (url.indexOf("swf") != -1) {
				var tempArr:Array = url.split("/");
				if (Util.validateStr(tempArr[tempArr.length - 1] as String)) {
					re = (tempArr[tempArr.length - 1] as String).split(".")[0];
					if (Util.validateStr(re)) {
//						Debugger.log(Debugger.INFO, "站外大前贴测试0112222：" + re);
						return re;
					}
				}
			}
			return re = Base64.encodeStr(Context.variables["cid"]);
		}
		
	}
}