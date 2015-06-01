package com._17173.flash.player.module.onlineTime
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.tip.TooltipData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *在线时长module
	 * @author zhaoqinghao
	 *
	 */
	public class OnLineTime extends Sprite
	{

		private var _manager:OnLineTimeManager = null;
		private var _ui:OnLineTimeUI = null;
		private var _timeCount:int = 0;
		private const STATUSURL:String = "http://v.17173.com/live/task/onlineCoinStatus.action";
		private const GETGIFTURL:String = "http://v.17173.com/live/task/getOnlineCoin.action";
		private var status:Array = ["cd","wait","effect"];
		/**
		 *在线时长开关（后台数据控制）
		 */
		private var _onLineSwitch:Boolean = false;

		public function OnLineTime()
		{
			super();
			//添加广告加载完成，显示在线时长
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_AD_COMPLETE, onAdCmp);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_SWITCH_STREAM, onStreamChange);
			init();
		}

		private function init(obj:Object = null):void
		{
			var ver:String = "1.0.4";
			var roomId:String = Context.variables["liveRoomId"];
			var url:String = replaceURL(Context.variables["url"]);
			Debugger.log(Debugger.INFO, "[OnLineTime]", "在线时长模块[版本:" + ver + "]初始化! " + url);
			onResize();
			this.addEventListener(Event.ADDED_TO_STAGE, onShow);
			_manager = new OnLineTimeManager(url);
			_timeCount = _manager.getTimeCount();
			_ui = new OnLineTimeUI();
			this.addChild(_ui);
			startTimer();
			//如果广告已经播放完毕则直接显示
			if (Context.variables["ADPlayComplete"] == true)
			{
				Debugger.log(Debugger.INFO, "[OnLineTime]", "广告播放完毕自动显示模块");
				Ticker.tick(1000,onAdCmp);
			}else{
				Debugger.log(Debugger.INFO, "[OnLineTime]", "等待广告完成事件");
			}
		}

		private function onAdCmp(data:Object = null):void
		{
			Context.getContext(ContextEnum.EVENT_MANAGER).remove(PlayerEvents.BI_AD_COMPLETE, onAdCmp);
			Debugger.log(Debugger.INFO, "[OnLineTime]", "显示在线时长");
			//不是登录用户直接显示面板 登录用户请求是否可以显示 并且在线时长为未显示状态.
			if (Context.getContext(ContextEnum.SETTING).userLogin && !_onLineSwitch)
			{
				getTimeStatus();
			}
			else
			{
				_onLineSwitch = true;
				onLineTimeShow();
			}
		}

		private function onShow(e:Event):void
		{
			addLsn();
		}

		private function onHide(e:Event):void
		{
			removeLsn();
		}

		/**
		 *站外回链会加上？XXXXX 判断如果有？则去除之后的 
		 * @param url
		 * 
		 */		
		private function replaceURL(url:String):String{
			var nURL:String = url;
			if(nURL && nURL.indexOf("?")>0){
				nURL = nURL.slice(0,nURL.indexOf("?"));
			}
			return nURL;
		}
		
		private function onStreamChange(data:Object = null):void{
			_onLineSwitch = false;
			onLineTimeShow();
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_AD_COMPLETE, onAdCmp);
		}
		
		/**
		 *显示计时
		 *
		 */
		private function onLineTimeShow():void
		{
			Debugger.log(Debugger.INFO, "[OnLineTime]", "是否显示" + _onLineSwitch);
			//需要判断是否可以显示
			if (_onLineSwitch)
			{
				if (!Context.stage.contains(this))
				{
					Context.stage.addChildAt(this,Context.stage.numChildren-1);
				}
			}
			else
			{
				if (Context.stage.contains(this))
				{
					Context.stage.removeChild(this);
				}
			}
		}

		/**
		 *添加监听
		 *
		 */
		private function addLsn():void
		{
			Context.getContext(ContextEnum.EVENT_MANAGER).listen("onLineTimeGift", getGift);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onHide);
			this.addEventListener(MouseEvent.CLICK,onClick);
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, onResize);
		}

		/**
		 *移除监听
		 *
		 */
		private function removeLsn():void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onHide);
			this.removeEventListener(MouseEvent.CLICK,onClick);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).remove(PlayerEvents.UI_RESIZE, onResize);
		}
		
		/**
		 *点击统计 
		 * @param e
		 * 
		 */		
		private function onClick(e:Event = null):void{
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.QM, StatTypeEnum.EVENT_CLICK, {"action":RedirectDataAction.ACTION_CLICK_ONLINETIME,"oType":_ui.status});
		}

		private function onResize(e:Event = null):void
		{
			//放置位置
			var plug:IPluginManager = Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager;
			var bottomBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.BOTTOM_BAR);
			var controlBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.CONTROL_BAR);
			var offsety:int = 100 + (plug.hasPlugin(PluginEnum.GIFT) ? 25 : 0);
			//y坐标 需要计算底栏 控制栏  与是否有礼物动画小人;
			//添加了隐藏按钮 在全屏模式下则需要留出隐藏按钮;
			if(Context.getContext(ContextEnum.SETTING)["isFullScreen"]){
				offsety += 40;
			}
			this.y = Context.stage.stageHeight - bottomBar.display.height - controlBar.display.height - offsety;
//			this.y = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight - (offsety + 10);
		}

		/**
		 *开始计时
		 *
		 */
		private function startTimer():void
		{
			Ticker.tick(1000, onTime, -1);
		}

		/**
		 *
		 * 暂停计时
		 */
		private function stopTimer():void
		{
			Ticker.stop(onTime);
		}


		private function onTime(data:Object = null):void
		{
			if (checkTimeSpeedPass())
			{
				if (_timeCount > 0)
				{
					_timeCount--;
				}
				_manager.update(_timeCount);
				_ui.update(_timeCount);
			}
		}

		private function resetTime():void
		{
			_timeCount = OnLineTimeManager.CD_COUNT;
		}

		/**
		 *检测时间是否不正确运行（加速）
		 * @return
		 *
		 */
		private function checkTimeSpeedPass():Boolean
		{
			return true;
		}

		/**
		 *发送领取礼物请求
		 *
		 */
		private function getGift(data:Object = null):void
		{
			Debugger.log(Debugger.INFO, "[OnLineTime]", "点击领取礼物");
			if (Context.variables["type"] != PlayerType.S_ZHANNEI)
			{
				//回连页面;
				var url:String = Context.variables.url;
				if (Util.validateStr(url))
				{
					url = url.split("|")[0];
				}
				//回链
				var r:RedirectData = new RedirectData();
				r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
				if (Util.validateStr(url))
				{
					r.url = url;
				}
				r.action = RedirectDataAction.ACTION_BACK_GIFT;
				r.send();
				Debugger.log(Debugger.INFO, "[OnLineTime]", "回连");
				stopTimer();
				//并且取消计时
				return;
			}

			//判断是否登录
			if (!Context.getContext(ContextEnum.SETTING).userLogin)
			{
				//调用登录js
				Debugger.log(Debugger.INFO, "[OnLineTime]", "调用登录js");
				Context.getContext(ContextEnum.SETTING).login();
				return;
			}
			//请求
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(GETGIFTURL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onGiftShow, onGiftShowFail);
			option.manuallyResolver = JSONResolver;
			loader.load(option);
			Debugger.log(Debugger.INFO, "[OnLineTime]", "发送礼物请求");
		}

		/**
		 *请求成功
		 * @param data
		 *
		 */
		private function onGiftShow(data:Object = null):void
		{
			if (data.code == "000000")
			{
				if (data.hasOwnProperty("obj") && data.obj.hasOwnProperty("reward"))
				{
					var reward:int = data.obj.reward;
					_ui.giftShow(reward);
					Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_REQUEST_USERINFO);
				}
				else
				{
					Debugger.log(Debugger.INFO, "[OnLineTime]", "领取礼物数据返回成功后数据错误", data.code, data.msg);
					Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("领取失败"))
				}

				if (data.hasOwnProperty("obj") && data.obj.hasOwnProperty("rewardNum"))
				{
					var rewardNum:int = data.obj.rewardNum;
					//小于领取限制 从新计时
					if (rewardNum < OnLineTimeManager.REWARD_LIMIT)
					{
						resetTime();
					}
					else
					{
						Ticker.tick(2500, onGiftEnd, 1);
					}
				}
			}
			else if (data.code == "100000")
			{
				Debugger.log(Debugger.INFO, "[OnLineTime]", "领取礼物数据返回成功后数据错误", data.code, data.msg);
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("领取失败"))
				onGiftEnd();
			}
			else
			{
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent(data.msg))
				Debugger.log(Debugger.INFO, "[OnLineTime]", "领取礼物接口返回提示", data.code, data.msg);
			}

			//如果还有后续奖励则设置时间

		}

		/**
		 *所有礼物领取完毕
		 *
		 */
		private function onGiftEnd(data:Object = null):void
		{
			_onLineSwitch = false;
			onLineTimeShow();
			stopTimer();
		}

		/**
		 *如果请求失败 自动显示继续倒计时
		 * @param data
		 *
		 */
		private function onGiftShowFail(data:Object = null):void
		{
			_onLineSwitch = false;
			onLineTimeShow();

			if (data.hasOwnProperty("code") && data.hasOwnProperty("msg"))
			{
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("领取礼物失败!"));
			}
			else
			{
				Context.getContext(ContextEnum.UI_MANAGER).showTooltip(TooltipData.fromContent("领取礼物失败!"));
			}
			Debugger.log(Debugger.INFO, "[OnLineTime]", data.code + ":" + data.msg);
		}

		/**
		 *获取当前是否可以显示倒计时
		 *
		 */
		private function getTimeStatus(data:Object = null):void
		{
			Debugger.log(Debugger.INFO, "[OnLineTime]", "获取用户状态");
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(STATUSURL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onTimeDate, onTimeDateFail);
			option.manuallyResolver = JSONResolver;
			loader.load(option);
		}

		/**
	   *在线时长状态返回
		  * @param obj
	   *
		  */
		private function onTimeDate(obj:Object):void
		{
			Debugger.log(Debugger.INFO, "[OnLineTime]", "[在线时长状态接口]", obj.code, obj.msg);
			if (obj.code == "000000")
			{
				//可以显示
				_onLineSwitch = true;
			}
			else
			{
				_onLineSwitch = false;
				stopTimer();
			}
			onLineTimeShow();
		}

		/**
		 *在线时长错误，不显示时长版
		 * @param obj
		 *
		 */
		private function onTimeDateFail(obj:Object):void
		{
			_onLineSwitch = false;
			_manager.delectSelfdata();
			onLineTimeShow();
			stopTimer();
			Debugger.log(Debugger.INFO, "[OnLineTime]", "[在线时长状态接口错误]");
		}
	}
}
