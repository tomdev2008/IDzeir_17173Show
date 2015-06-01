package com._17173.flash.player.module.gift
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.gift.anim.GiftAnim;
	import com._17173.flash.player.module.gift.ui.GiftFlyEffectManager;
	import com._17173.flash.player.module.gift.ui.GiftTip;
	import com._17173.flash.player.module.gift.ui.GiftUI;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;

	/**
	 * 礼物模块
	 *
	 * @author shunia-17173
	 */
	public class Gifts extends Sprite
	{

		public static const TIP_NO_TARGET:Array = ["请从右侧聊天列表中选择礼物要发送的对象"];
		public static const TIP_NO_GIFT:Array = ["请选择要发送的礼物"];
		public static const TIP_NO_NUM:Array = ["请选择礼物的数量"];
		public static const TIP_FAIL:Array = ["礼物发送失败"];
		public static const TIP_SUCCESS:Array = ["礼物发送成功"];
		public static const TIP_NO_MONEY:Array = ["对不起您的账户余额不足，请|", "|", "充值"];

		//获取礼物列表接口
		//http://v.17173.com/live/g_giftData.action
		public static const GET_GIFT_URL:String = "http://v.17173.com/live/g_giftData.action";
		//送礼接口
		//http://v.17173.com/live/g_sendGift.action?giftId=4&receiverId=100000420&count=1&roomId=1000001202&chatRoomId=1000001202-1
		public static const SEND_GIFT_URL:String = "http://v.17173.com/live/g_sendGift.action";

		private var _crypt:String = null;
		private var _ui:GiftUI = null;
		private var _anim:GiftAnim = null;
		private var _tip:GiftTip = null;
		/**
		 *礼物飞屏层级
		 */
		private var _flyEffectLayer:Sprite = null;
		/**
		 *飞屏管理
		 */
		private var _flyManager:GiftFlyEffectManager = null;
		/**
		 * 充值弹框
		 */
		private var _chargeTip:MovieClip = null;

		public function Gifts()
		{
			super();

			init();
			
//			testFly();
		}

		protected function init():void
		{
			var ver:String = "1.0.81";
			Debugger.log(Debugger.INFO, "[gift]", "礼物模块[版本:" + ver + "]初始化!");
			//先请求礼物列表
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(GET_GIFT_URL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onGiftGot, onGiftGot);
			loader.load(loaderOption);
			//初始化ui
			var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			if (streamBar && streamBar.display)
			{
				_ui = new GiftUI();
				this._ui.visible = false;
				streamBar.call("addItem", _ui, ExtraUIItemEnum.GIFT);
				_ui.addEventListener("sendGift", onSendGift);
				_ui.addEventListener("showGiftTip", showGiftTip);
				_ui.addEventListener("hideGiftTip", hideGiftTip);
			}

			//送礼小人动画
			_anim = new GiftAnim();
			_anim.addEventListener("close", onAnimClose);
			Context.stage.addChild(_anim);

			//飞屏层
			_flyEffectLayer = new Sprite();
//			_flyEffectLayer.mouseChildren = _flyEffectLayer.mouseEnabled = false;
			Context.stage.addChild(_flyEffectLayer);
			_flyManager = new GiftFlyEffectManager(_flyEffectLayer);

			//防刷
			Context.getContext(ContextEnum.JS_DELEGATE).listen("giftCrypt", onCrypt);
			//设置送礼对象
			Context.getContext(ContextEnum.JS_DELEGATE).listen("setPre", onSetPre);
			//送礼动画
			Context.getContext(ContextEnum.JS_DELEGATE).listen("giftsDone", onGiftsSent);
			//显示全局
			Context.getContext(ContextEnum.JS_DELEGATE).listen("toGlobalGift", onGiftGlobalSent);

			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, onResize);
		}


		private function testFly():void
		{
			Ticker.tick(1000, testCreateDate, -1);
		}

		private function testCreateDate():void
		{
			if ((Math.random() * 1000) > 500)
			{
				//全局
				onGiftGlobalSent(getMsg());
			}
			else
			{
				//本地
				onGiftsSent(getMsg());
			}

			function getMsg():Object
			{
				var obj:Object = {};
				obj.showRich = 1;
				obj.userName = "&amp;lt;xxoo&gt;<>";
				obj.toUserName = "<我是一个大坑" + int(Math.random() * 10)+">";
				obj.giftCount = "" + int(Math.random() * 1000);
				obj.giftName = "坑";
				obj.liveroomShowtime = 2;
				obj.globalShowtime = 2;
				return obj;
			}
		}



		/**
		 * 礼物数据获取回调
		 *
		 * @param data
		 */
		private function onGiftGot(data:Object):void
		{
			//currency是获取礼物返回的币种类型： 1：金币，5：银币
			if (data && data.hasOwnProperty("obj") && data.obj)
			{
				if (_ui)
				{
					_ui.giftData = data;
					//显示
					this._ui.visible = true;
					_ui.dispatchEvent(new Event("updated"));
				}
			}
			else
			{
				Debugger.log(Debugger.ERROR, "[gift]", "礼物数据获取失败!");
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ON_PLAYER_ERROR, PlayerErrors.packUpError(PlayerErrors.GIFT_DATA_ERROR));
			}
		}

		private function onResize(data:Object = null):void
		{
			if(_flyManager){
				_flyManager.onResize();
			}
		}

		private function onAnimClose(e:Event):void
		{
			_anim.removeEventListener("close", onAnimClose);
			Context.stage.removeChild(_anim);
			_anim = null;
		}

		/**
		 * 防刷,验证参数
		 */
		private function onCrypt(str:String):void
		{
			_crypt = str;
		}

		/**
		 * 用户送礼达到某个阀值,需要在播放器上显示送礼动画
		 */
		private function onGiftsSent(gift:Object):void
		{
			if (_anim)
			{
				_anim.showSendGifts({giftCount: 2});
			}
			if (gift.hasOwnProperty("showRich") && gift.showRich == 1)
			{
				onGiftLocalSent(gift);
		}
		}

		/**
		 *全站
		 * @param gift
		 *
		 */
		private function onGiftGlobalSent(gift:Object):void
		{
			if (_flyManager)
			{
				_flyManager.addMessage(gift, 1);
			}
		}

		/**
		 *本房间
		 * @param gift
		 *
		 */
		private function onGiftLocalSent(gift:Object):void
		{
			if (_flyManager)
			{
				_flyManager.addMessage(gift);
			}
		}

		/**
		 * 显示礼物价格等信息
		 * @param event
		 */
		protected function showGiftTip(event:Event):void
		{
			var target:Object = event.target;
			var data:Object = target.gift;
			var globalPos:Point = target.localToGlobal(new Point(target.width / 2, 0));
			if (_tip == null)
			{
				_tip = new GiftTip();
			}

			_tip.data = data;
			_tip.position = globalPos;
			Context.stage.addChild(_tip);
		}

		/**
		 * 隐藏礼物信息
		 * @param event
		 */
		protected function hideGiftTip(event:Event):void
		{
			if (_tip && Context.stage.contains(_tip))
			{
				Context.stage.removeChild(_tip);
			}
		}

		/**
		 * 发送礼物
		 * @param event
		 */
		protected function onSendGift(event:Event):void
		{
			//送礼
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(SEND_GIFT_URL, LoaderProxyOption.FORMAT_VARIABLES, LoaderProxyOption.TYPE_FILE_LOADER, onGiftSent);
			var s:String = "";
			for (var key:String in _ui.packedGiftParam)
			{
				s += key + "=" + _ui.packedGiftParam[key] + "&";
			}
			Debugger.log(Debugger.INFO, "[gift]", "正在发送礼物: ", s);
			s += ("cs=" + _crypt);
			var v:URLVariables = new URLVariables(s);
			loaderOption.data = v;
			loaderOption.manuallyResolver = JSONResolver;
			loader.load(loaderOption);
		}

		private function onGiftSent(data:Object):void
		{
			if (data.code == "000000")
			{
				//成功
				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(TIP_SUCCESS);
				//发送送礼成功事件
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_GIFT_SENT);
			}
			else if (data.code == "000005")
			{
				onNotEnoughMoney();
					//余额不足
//				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(TIP_NO_MONEY, onGotoPurchase);
			}
			else if (data.code == "000007")
			{
				onNotEnoughMoney(1);
			}
			else
			{
				//失败了,数据里带出错消息
				Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr([data.msg], null);
				Debugger.log(Debugger.ERROR, "[gift]", "code: ", data.code, ", message: ", data.msg);
			}
		}

		/**
		 * 钱不够引导充值
		 */
		private function onNotEnoughMoney(type:int = 0):void
		{
			//初始化
			if (_chargeTip == null)
			{
				_chargeTip = new mc_giftCharge_frame2();
				//金币不足去充值 银币不足去兑换 
				_chargeTip.clsBtn.addEventListener(MouseEvent.CLICK, onClose);
			}
			else
			{
				if (_chargeTip.btn.numChildren > 0)
				{
					_chargeTip.btn.removeChildAt(0);
					_chargeTip.btn.removeEventListener(MouseEvent.CLICK, onGotoPurchase);
					_chargeTip.btn.removeEventListener(MouseEvent.CLICK, onGotoExchange);
				}
			}
			if (type == 0)
			{
				_chargeTip.btn.addChild(new mc_gtmoneyBtn());
				_chargeTip.btn.addEventListener(MouseEvent.CLICK, onGotoPurchase);
			}
			else
			{
				_chargeTip.btn.addChild(new mc_gtexchangeBtn());
				_chargeTip.btn.addEventListener(MouseEvent.CLICK, onGotoExchange);
			}
			//弹出
			Context.getContext(ContextEnum.UI_MANAGER).popup(_chargeTip);
		}



		private function onClose(e:Event):void
		{
			//关闭
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(_chargeTip);
		}

		/**
		 *去充值
		 * @param e
		 *
		 */
		private function onGotoPurchase(e:Event = null):void
		{
			if (Context.stage.displayState != StageDisplayState.NORMAL)
			{
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			//http://v.17173.com/live/ucenter/goMpkgAccountLookup.action
//			navigateToURL(new URLRequest("http://v.17173.com/live/ucenter/payment.action"), "_blank");
			Util.toUrl("http://v.17173.com/live/ucenter/payment.action");
		}

		/**
		 *去兑换
		 * @param e
		 *
		 */
		private function onGotoExchange(e:Event = null):void
		{
			if (Context.stage.displayState != StageDisplayState.NORMAL)
			{
				Context.stage.displayState = StageDisplayState.NORMAL;
			}

			//			navigateToURL(new URLRequest("http://v.17173.com/live/ucenter/payment.action"), "_blank");
			Util.toUrl("http://v.17173.com/live/ucenter/goMpkgAccountLookup.action");
		}

		private function onSetPre(uid:String, name:String, roomID:String, chatRoomID:String):void
		{
			Debugger.log(Debugger.INFO, "[gift]", "设置送礼用户: ", name, ",", uid, ",", roomID, ",", chatRoomID);
			if (Util.validateStr(uid) && Util.validateStr(name))
			{
				var obj:Object = {"name": HtmlUtil.encodeHtml(name), "id": uid, "room": roomID, "chatRoom": chatRoomID};
				_ui.addUser(obj);
			}
		}

	}
}
