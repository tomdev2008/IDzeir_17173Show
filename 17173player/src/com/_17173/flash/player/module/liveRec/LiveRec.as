package com._17173.flash.player.module.liveRec
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.module.liveRec.ui.comp.RunText;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 点播里面放直播推荐 
	 * @author 安庆航
	 */	
	public class LiveRec extends Sprite
	{
		public static const GET_LIVE_URL:String = "http://v.17173.com/live/index/recommendLive.action?";
		
		private var _bg:Sprite = null;
		private var _rt:RunText = null;
		private var _logo:MovieClip = null;
		private var _close:MovieClip = null;
		private var _data:Object = null;
		private var _logoC:Sprite = null;
		
		public function LiveRec()
		{
			super();
			init();
		}
		
		public function init():void {
			var ver:String = "1.0.3";
			Debugger.log(Debugger.INFO, "[liveRec]", "点播推直播模块[版本:" + ver + "]初始化!");
			
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_SHOW_LIVE_REC, getLiveState);
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_RESIZE, resize);
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
//			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.SKIN_EVENT, skinEventHandler);
		}
		
		private function skinEventHandler(data:Object):void {
			if (!_bg || !Context.stage.contains(_bg)) {
				return;
			}
			var isFull:Boolean = Context.getContext(ContextEnum.SETTING).isFullScreen;
			if (isFull && data && data.hasOwnProperty("event")) {
				if (data["event"] == SkinEvents.SHOW_FLOW) {
					TweenLite.to(_bg, 0.5, {"y":35});//36是因为全屏下 全屏的topbar 是35
				} else if (data["event"] == SkinEvents.HIDE_FLOW) {
					TweenLite.to(_bg, 0.5, {"y":0});
				}
			}
			if (!isFull) {
				if (_bg.y != 0) {
					TweenLite.to(_bg, 0.5, {"y":0});
				}
			}
		}
		
		private function thisMouseRollOver(evt:MouseEvent):void {
			if (_close && _bg.contains(_close)) {
				_close.visible = true;
			}
			if (_rt && _bg.contains(_rt)) {
				_rt.mouseRollOver(null);
			}
		}
		
		private function thisMouseRollOut(evt:MouseEvent):void {
			if (_close && _bg.contains(_close)) {
				_close.visible = false;
			}
			if (_rt && _bg.contains(_rt)) {
				_rt.mouseRollOut(null);
			}
		}
		
		private function mouseRollOver(evt:MouseEvent):void {
			if (_close) {
				_close.gotoAndStop(2);
			}
		}
		
		private function mouseRollOut(evt:MouseEvent):void {
			if (_close) {
				_close.gotoAndStop(1);
			}
		}
		
		private function closeThis(evt:MouseEvent):void {
			if (_rt) {
				_rt.stopRun();
			}
			if (Context.stage && _bg && Context.stage.contains(_bg)) {
				Context.stage.removeChild(_bg);
			}
		}
		
		/**
		 * 根据当前点播的游戏分类，来获取直播那个状态
		 */		
		private function getLiveState(data:Object):void {
			if (!data || !data.hasOwnProperty("aClass") || !data.hasOwnProperty("bClass")) {
				return;
			}
			_data = data;
			var aClass:String = data["aClass"] as String;
			var bClass:String = data["bClass"] as String;
			if (!Util.validateStr(aClass) || !Util.validateStr(bClass)) {
				return;
			}
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(
				GET_LIVE_URL + "gameType=" + aClass + "&gameCode=" + bClass +  "&", LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, onGetLiveSucess, onGetLiveSucess);
			loader.load(loaderOption);
		}
		
		private function onGetLiveSucess(data:Object):void {
			if (data && data.hasOwnProperty("code") && data["code"] == "000000") {
				if (data.hasOwnProperty("obj")) {
					if (data["obj"].hasOwnProperty("liveStatus") && data["obj"]["liveStatus"] == "1") {
						if (data["obj"]["gameName"] && data["obj"]["url"]) {
							showTitle(data["obj"]["gameName"], data["obj"]["url"]);
						} else {
							showDefaultRec()
						}
					} else {
						showDefaultRec()
					}
				}
			} else {
				showDefaultRec()
			}
		}
		
		/**
		 * url地址为从直播内容里随机选择一个
		 */		
		private function showDefaultRec():void {
			var title:String = _("lrt");//lrt(liveRecTitle)
			var url:String = _("liveurl");
			if (!Util.validateStr(url)) {
				url = "http://v.17173.com/live/index/liveRoomRandom.action?vid=db_button2";
			}
			if (title && title.length > 0) {
				showTitle(title, url, true);
			}
		}
		
		/**
		 * 开始显示推荐的内容
		 * @param title 直播的名称
		 * @param url 直播的地址
		 * 
		 */		
		private function showTitle(title:String, url:String, useDefault:Boolean = false):void {
			if (!_bg) {
				_bg = new Sprite();
				_bg.addEventListener(MouseEvent.ROLL_OVER, thisMouseRollOver);
				_bg.addEventListener(MouseEvent.ROLL_OUT, thisMouseRollOut);
			} else {
				_bg.removeChildren(0, _bg.numChildren - 1);
			}
			Context.stage.addChild(_bg);
			if (!_logoC) {
				_logoC = new Sprite();
			}
			_bg.addChild(_logoC);
			if (!_logo) {
				_logo = new mc_live_logo();
			}
			_logo.mouseEnabled = false;
			_logoC.addChild(_logo);
			if (!_rt) {
				_rt = new RunText();
			} else {
				_rt.removeChildren(0, _rt.numChildren - 1);
			}
			_bg.addChild(_rt);
			if (!_close) {
				_close = new mc_live_close();
			}
			_close.buttonMode = true;
			_close.useHandCursor = true;
			_close.visible = false;
			_close.addEventListener(MouseEvent.MOUSE_OVER, mouseRollOver);
			_close.addEventListener(MouseEvent.MOUSE_OUT, mouseRollOut);
			_close.addEventListener(MouseEvent.CLICK, closeThis);
			_bg.addChild(_close);
			_rt.init(title, url, useDefault);
			resize();
		}
		
		private function resize(data:Object = null):void {
			if (_bg && Context.stage.contains(_bg)) {
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x272727);
				_bg.graphics.drawRect(0, 0, 230, 40); //205是整个组件的宽度, 26是高度
				_bg.graphics.endFill();
				_bg.x = Context.stage.stageWidth - 230;
				var isFull:Boolean = Context.getContext(ContextEnum.SETTING).isFullScreen;
				if (isFull) {
					_bg.y = 35; //36是因为全屏下 全屏的topbar 是35
				} else {
					_bg.y = 0;
				}
			}
			if (_logoC && _bg.contains(_logoC)) {
				_logoC.graphics.clear();
				_logoC.graphics.beginFill(0x393939);
				_logoC.graphics.drawRect(0, 0, 39, 40);
				_logoC.graphics.endFill();
			}
			if (_logo && _logoC.contains(_logo)) {
				_logo.x = (_logoC.width - _logo.width) / 2;
				_logo.y = (_logoC.height - _logo.height) / 2;
			}
			if (_rt && _bg.contains(_rt)) {
				_rt.x = _logoC.width + 10;
				_rt.y = (_bg.height - _rt.height) / 2;
				Debugger.log(Debugger.INFO, _rt.height, _bg.height, _rt.y);
			}
			if (_close && _bg.contains(_close)) {
				_close.x = 230 - _close.width - 6;//9是设计给的距离
				_close.y = 6;
			}
		}
		
		/**
		 * 出现后推的时候要关闭这个推荐 
		 * @param data
		 * 
		 */		
		private function showBackRec(data:Object):void {
			closeThis(null);
		}
		
		/**
		 * 隐藏后推的时候要再把这个显示出来
		 * @param data
		 * 
		 */		
		private function hideBackRec(data:Object):void {
			if (_data && Context.stage && _bg && !Context.stage.contains(_bg)) {
				getLiveState(_data);
			}
		}
	}
}