package com._17173.flash.show.base.module.qm
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 *统计模块
	 * @author zhaoqinghao
	 *
	 */
	public class QM extends BaseModule
	{
		public function QM()
		{
			super();
			_version = "0.0.1";
			this.mouseChildren = false;
			initInfo();
		}
		private var cookInfo:Object;
		private static const BASE_URL:String = "http://stat.v.17173.com/show/?src=flash";

		private function initInfo():void
		{
			cookInfo = {};
			addLsn()
		}

		private function addLsn():void
		{
			var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			e.listen(SEvents.SEND_QM, onQmEvent);
		}

		/**
		 * 从浏览器cookie里获取用户唯一标示和渠道id
		 */
		private function getKeysFromBrowserCookie():void
		{
			cookInfo = {"seq": "", "channelid": ""};
			if (JSBridge.enabled)
			{
				var cookie:String = JSBridge.addCall("function () { return document.cookie; }", null, "");
				//				var cookie:String = "os=Win 7,bro=ff,sr=1366*768,ln=undefined; Hm_lvt_bb6514b03b6e773087dfd5f65438bf33=1385370158; Hm_lpvt_bb6514b03b6e773087dfd5f65438bf33=1385370158; live_17173_unique=92bbc6da6d9a4fa5be39e73007fdd2fd; JSESSIONID=abcYBUCURJlYi9cnWFoku; ONLINE_TIME=1385370158939; DIFF=1385370158253; SUV=1385371600828739; sessionid=138537160082873913853701778842921385370158252|2; sessionid2=138537160082873913853701778842921385370158252|2; NUV=1385395200000; IPLOC=CN1100";
				
				if (Util.validateStr(cookie))
				{
					var keys:Array = cookie.split(";");
					for each (var pair:Object in keys)
					{
						var pairs:Array = pair.split("=");
						if (pairs && pairs.length == 2)
						{
							var k:String = Util.trimStr(pairs[0]);
							if (k == "showqd")
							{
								cookInfo["channelid"] = pairs[1];
							}
							else if (k == "show_17173_unique")
							{
								cookInfo["seq"] = pairs[1];
							}
						}
					}
				}
			}
		}

		private function removeLsn():void
		{
			var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			e.remove(SEvents.SEND_QM, onQmEvent);
		}

		private function onQmEvent(info:Object):void
		{
			var id:String = info.id;
			switch (id)
			{
				case "fpv": //进入直播间
				{
					onFPV(info);
					break;
				}
				case "play": //播放
				{
					onFVV(info);
					break;
				}
				case "buffer": //缓冲
				{
					onVideoBuffer(info);
					break;
				}
			}
		}

		/**
		 * 数据封装发送
		 *
		 * @param data
		 */
		private function onSendData(data:Object):void
		{
			//必须字段(过滤字段)
			getKeysFromBrowserCookie();
			var url:String = BASE_URL + "&seq=" + cookInfo["seq"];
			url += "&channelid=" + cookInfo["channelid"];
			//数据字段
			for (var key:String in data)
			{
				url += ("&" + key + "=" + data[key]);
			}
			//时间戳
			url += "&t=" + new Date().time;

			try
			{
				var urlReq:URLRequest = new URLRequest(url);
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
				urlLoader.load(urlReq);
				Debugger.log(Debugger.ERROR, "[QM]", "发送统计", url);
			}
			catch (e:Error)
			{
				Debugger.log(Debugger.ERROR, "[QM]", "统计模块请求异常", e.message);
			}
			;
		}

		protected function onError(event:IOErrorEvent):void
		{
			Debugger.log(Debugger.ERROR, "[QM]", "统计模块请求异常");
		}

		/**
		 *pvv统计
		 * @param data
		 *
		 */
		private function onFVV(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[QM]", "发送FVV");
			onSendData(data);
		}

		/**
		 * fpv统计
		 * @param data
		 *
		 */
		private function onFPV(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[QM]", "发送FPV");
			onSendData(data);
		}

		/**
		 * 缓冲统计
		 * @param data
		 *
		 */
		private function onVideoBuffer(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[QM]", "发送BUFFER");
			onSendData(data);
		}



	}
}
