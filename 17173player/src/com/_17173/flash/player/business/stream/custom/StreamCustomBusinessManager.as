package com._17173.flash.player.business.stream.custom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.socket.ISocketManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.stream.StreamBusinessManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoManager;
	import com._17173.flash.player.context.socket.SEnum;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;

	public class StreamCustomBusinessManager extends StreamBusinessManager
	{
		//根据liveRoomId获取cid的重试次数
		private var _infoErrorCount:int = 0;
		public function StreamCustomBusinessManager()
		{
			super();
		}
		
		override protected function initUI():void {
			var d:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
			//获取自定义配置
			d["getConfig"](getUIModuleScuess, getUIModuleScuess);
		}
		
		override protected function initVideoDispatch():void {
			var d:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
			var url:String = Context.variables["url"];
			Debugger.log(Debugger.INFO, "[business]", "获取到参数: url=" + url);
			if (Util.validateStr(url)) {
				//去掉传入带|的拼接ref的数据
				url = url.split("|")[0];
				//去掉传入的地址后面带参数的情况
				url = url.split("?")[0];
				var split:Array = url.split("/");
				//放到线上经过301跳转的时候会给url最后一位加上“/”，所以加一个判断
				if (url.slice(url.length - 1, url.length) == "/") {
					Context.variables["liveRoomId"] = split[split.length - 2];
				} else {
					Context.variables["liveRoomId"] = split[split.length - 1];
				}
			}
			//根据返回的数据获取cid
//			d["getCID"](Context.variables["liveRoom"], onGetCIDSucc, onGetCIDFail);
			d["getCID"](Context.variables["liveRoomId"], onGetCIDSucc, onGetCIDFail);
		}
		
		/**
		 * 成功获取配置信息
		 *  
		 * @param value
		 */		
		private function getUIModuleScuess(value:Object = null):void {
			showRec();
			initModules(value);
		}
		
		/**
		 * 显示秀场推荐
		 */		
		private function showRec():void {
			var obj:Object = Context.variables["UIModuleData"];
			if (obj && obj[StreamCustomDataRetriver.M17] && Context.stage.stageWidth >= PlayerScope.PLAYER_WIDTH_6 && Context.stage.stageHeight >= PlayerScope.PALYER_HEIGHT_4) {
				var showRec:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.SHOW_REC);
			}
		}
		
		/**
		 * 成功获取cid
		 *  
		 * @param data
		 */		
		private function onGetCIDSucc(data:Object):void {
			Context.variables["userId"] = data.userInfo.userId;
			var cid:String = data.liveInfo.live.cId;
//			Global.videoData["cid"] = Util.validateStr(cid) ? cid : null;
//			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["cid"] = Util.validateStr(cid) ? cid : null;
			Context.variables["ckey"] = data.liveInfo.live.ckey;
			Context.variables["roomID"] = Context.variables["liveRoomId"];
			Context.variables["cdnType"] = data.liveInfo.live["cdnType"];
			Context.variables["streamName"] = data.liveInfo.live["streamName"];
			startVideo();
		}
		
		/**
		 * 获取cid失败 
		 */		
		private function onGetCIDFail(data:Object):void {
			_infoErrorCount++;
			if (_infoErrorCount < 3)
			{
				var d:Object = Context.getContext(ContextEnum.DATA_RETRIVER);
				d["getCID"](Context.variables["liveRoomId"], onGetCIDSucc, onGetCIDFail);
			}
			else
			{
				var error:PlayerErrors = new PlayerErrors();
				error.error = PlayerErrors.STREAM_DISPATCH_PARAMETER_INVALID
				onError(error);
			}
		}
		
		/**
		 * 初始化模块.
		 *  
		 * @param conf
		 */		
		private function initModules(conf:Object):void {
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_INTED);
		}
		
		private function startVideo():void {
			super.initVideoDispatch();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_OUT_PLAYER_DATA_READY);
		}
		
		override protected function onAdPlayComplete(data:Object=null):void
		{
			super.doHidePT();
			
			//用户实际看到视频时间点
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_REAL_START, {});
		}
		
		override protected function onBIReady(data:Object):void {
			super.onBIReady(data);
			
			initSocket();
		}
		
		//站外监听停止播放
		private function initSocket():void{
			var _socket:ISocketManager = ISocketManager(Context.getContext(ContextEnum.SOCKET_MANAGER));
			_socket.listen(SEnum.R_PLAY_START, onPlayStart);
			_socket.listen(SEnum.R_PLAY_END, onPlayStop);
			_socket.startConnect();
		}
		
		private function onPlayStop(e:Object):void {
			var _iEventManager:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			var _videoManager:VideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as VideoManager;
			_videoManager.stop();
			_iEventManager.send(PlayerEvents.VIDEO_FINISHED);
		}
		/**
		 * 开始播放 
		 */		
		private function onPlayStart(e:Object):void {
			onSwitchStream({"roomID":Context.variables["roomID"]});
		}
		
		override protected function showSpecilUI():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SPECIL_COMP_ENABLE, [ExtraUIItemEnum.UI_SPECILE_ENABLE_FULL, ExtraUIItemEnum.UI_SPECILE_ENABLE_VOLUME, ExtraUIItemEnum.LOGO, ExtraUIItemEnum.OUT_LOGO, ExtraUIItemEnum.OUT_GIFT]);
		}
	}
}