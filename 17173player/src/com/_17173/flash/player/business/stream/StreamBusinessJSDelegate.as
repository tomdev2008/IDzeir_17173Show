package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.BusinessJSDelegate;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;

	public class StreamBusinessJSDelegate extends BusinessJSDelegate
	{
		
		override public function startUp(param:Object):void {
			super.startUp(param);
			
			listen("setPlay", onPlayByCid);
			listen("quizChange", quizChangeFromServices);
			listen("upMoney", upMoney);
			// 奇遇接口
			listen("qiyuPlayAndPause", onQiyu);
		}
		
		/**
		 * 奇遇功能的播放和暂停不能展示广告, 所以单独调用videoManager的播放接口, 不使用PlayerEvents.UI_TOGGLE_PLAY_AND_PAUSE. 
		 * @param playing 是否正在播放,因为转换boolean值的特殊性,所以这个参数是int型,1=true,否则false.
		 */		
		protected function onQiyu(playing:int):void {
			Debugger.log(Debugger.INFO, "[js]", "奇遇: " + ((playing == 1) ? "播放" : "暂停"));
			if (playing != 1) {
				var v:IVideoManager = _(ContextEnum.VIDEO_MANAGER);
				if (v) v.togglePlay(false);
			} else {
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_RELOAD_VIDEO);
			}
		}
		
		protected function onPlayByCid():void {
			var roomID:String = Context.variables["roomID"];
			Debugger.log(Debugger.INFO, "从js调用进行直播播放,  room=", roomID);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_SWITCH_STREAM, {"roomID":roomID});
//			Global.eventManager.send(PlayerEvents.BI_SWITCH_STREAM, {"roomID":roomID});
		}
		
		private function quizChangeFromServices(value:String):void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUZI_CHANGE_FROM_SERVICES, value);
		}
		
		private function upMoney(data:Object = null):void {
//			Debugger.log(Debugger.INFO, "[streamBusinessJS]从js调用获取,用户信息改变");
			if (!data || !Util.validateObj(Context.variables, "userInfo")) {
//				Debugger.log(Debugger.INFO, "[streamBusinessJS]从js调用获取,用户信息改变,未带数据");
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_USER_INFO_CHANGE);
			} else {
				var userInfo:Object = Context.variables["userInfo"];
				if (data.hasOwnProperty("jinbi")) {
//					Debugger.log(Debugger.INFO, "[streamBusinessJS]从js调用获取,用户信息改变,带数据 金币：" + data.jinbi);
					userInfo["jinbi"] = data.jinbi;
				}
				if (data.hasOwnProperty("yinbi")) {
//					Debugger.log(Debugger.INFO, "[streamBusinessJS]从js调用获取,用户信息改变,带数据" + data.yinbi);
					userInfo["yinbi"] = data.yinbi;
				}
				if (data.hasOwnProperty("jindou")) {
					userInfo["jindou"] = data.jindou;
				}
				if (data.hasOwnProperty("yindou")) {
					userInfo["yindou"] = data.yindou;
				}
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.BI_USER_INFO_GETED, "1");
			}
		}
		
		/**
		 * 通知js当前竞猜是否显示
		 * 0：不显示
		 * 1：显示
		 */		
		public function sendQuizState(value:int):void {
			Debugger.log(Debugger.INFO, "通知js竞猜的显示状态:" + value);
			send("quizShow", value);
		}
		
		override protected function onEnd():void {
			super.onEnd();
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.VIDEO_FINISHED);
//			Global.eventManager.send(PlayerEvents.VIDEO_FINISHED);
		}
		
	}
}