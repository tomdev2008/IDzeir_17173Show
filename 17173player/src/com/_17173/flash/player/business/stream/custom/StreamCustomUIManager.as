package com._17173.flash.player.business.stream.custom
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.business.stream.StreamUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.quiz.ui.out.OutQuizStartBtn;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.StreamOutLogo;
	import com._17173.flash.player.ui.file.ShareCompoment;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.outGift.OutGift;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class StreamCustomUIManager extends StreamUIManager
	{
		private var _bulletsFlag:Boolean = false;
		private var _bulletsIsLoading:Boolean = false;
		private var _giftFlag:Boolean = false;
		private var _giftIsLoading:Boolean = false;
		private var _UIMOduleData:Object;
		private var _giftUI:DisplayObject;
		private var _bullets:Object;
		private var _outGift:OutGift;
		private var _logo:StreamOutLogo;
		private var _otherLogo:Object;
		private var _otherLogoIsLoading:Boolean = false;
		private var _share:ShareCompoment = null;
		private var _streamExtraBarShowDic:Dictionary = null;
		private var _quizBtn:OutQuizStartBtn;
		private var _componenAfterLayer:Sprite;
		private var _specileMouseStateArr:Array;
		
		public function StreamCustomUIManager()
		{
			super();
			_streamExtraBarShowDic = new Dictionary();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.UI_INTED, onBIModuleDataComplete);
			eventManager.listen(PlayerEvents.UI_SHOW_SHARE, onShowShareHandler);
			eventManager.listen(PlayerEvents.UI_SPECIL_COMP_ENABLE, specilCompEnable);
		}
		
//		override protected function initComponents():void {
//			super.initComponents();
//			
//			//扩展层,暂时用户放竞猜(由于竞猜需要在其他ui之上，但是在秀场推荐之下，所以使用此层)
//			_componenAfterLayer = new Sprite();
//			_componenAfterLayer.name = "componenAfter";
//			_layers[_componenAfterLayer.name] = _componenAfterLayer;
//			Context.stage.addChild(_componenAfterLayer);
//		}
		
		override protected function initStreamBar():void {
			if (Context.variables.hasOwnProperty("UIModuleData")) {
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_RESIZE);
			}
		}
		
		private function onBIModuleDataComplete(data:Object):void {
//			initAddStream();
			//派发resize事件，让所有受该模块影响的重新渲染
//			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_RESIZE);
			super.onBIReady(null);
		}
		
		/**
		 * 初始化streamExtraBar
		 * 如果有模块信息并且streamExtraBar未被初始化
		 */		
		private function initAddStream():void {
			if (Context.variables.hasOwnProperty("UIModuleData")) {
				addStreamBar();
			}
		}
		
		private function addStreamBar():void {
			if (Context.stage.stageWidth < PlayerScope.PLAYER_WIDTH_5) {
				if (_streamExtraBar) {
//					_streamExtraBar = Global.skinManager.deattachSkinByName(SkinsEnum.STREAM_EXTRA_BAR);
					_streamExtraBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).deattachSkinByName(SkinsEnum.STREAM_EXTRA_BAR);
				}
				return;
			} else {
				_UIMOduleData = Context.variables["UIModuleData"];
				checkResizeDic();
				if (_UIMOduleData[StreamCustomDataRetriver.M1] || _UIMOduleData[StreamCustomDataRetriver.M2] || _UIMOduleData[StreamCustomDataRetriver.M7] || _UIMOduleData[StreamCustomDataRetriver.M8]) {
//					var bottomBar:ISkinObject = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR);
					var bottomBar:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR);
					if (!Context.getContext(ContextEnum.SETTING)["isFullScreen"] && (!_streamExtraBar || !(bottomBar.display as Object).contains(_streamExtraBar.display))) {
//						_streamExtraBar = Global.skinManager.attachSkinByName(SkinsEnum.STREAM_EXTRA_BAR, DisplayObjectContainer(bottomBar.display));
						_streamExtraBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).attachSkinByName(SkinsEnum.STREAM_EXTRA_BAR, DisplayObjectContainer(bottomBar.display));
						_streamExtraBar.call("registerItem",[ExtraUIItemEnum.LOGO, ExtraUIItemEnum.OUT_LOGO],[ExtraUIItemEnum.OUT_BULLET, ExtraUIItemEnum.OUT_GIFT,ExtraUIItemEnum.QUIZ]);
					}
					_streamExtraBar.display.height = 36;
					//由于_streamExtraBar会在派发UI_COMP_ENABLE_CHANGE后初始化,因此这里有个记录,使用过后清空这个记录
					if (_specileMouseStateArr && _specileMouseStateArr.length > 0) {
						_streamExtraBar.call("specilCompEnable", _specileMouseStateArr);
						_specileMouseStateArr = [];
					}
//					_streamExtraBar.call("remevoAllItem");
					initBarChildren(_UIMOduleData);
				}
			}
		}
			
		/**
		 * 初始化扩展调工具栏中的内容
		 * @param value 扩展工具栏内的数据
		 * 
		 */		
		private function initBarChildren(value:Object):void {
			var show:Boolean = true;
			//17173logo
			if (Util.validateObj(value, StreamCustomDataRetriver.M1) && value[StreamCustomDataRetriver.M1] && _streamExtraBarShowDic["logo"]) {
				if (!_logo) {
					_logo = new StreamOutLogo();
					_streamExtraBar.call("addItem", _logo, ExtraUIItemEnum.LOGO);
				}
				show = true;
			} else {
				show = false;
			}
			if (_logo) {
				_logo.visible = show;
			}
			
			//合作Logo
			if (!_otherLogoIsLoading) {
				if (Util.validateObj(value, StreamCustomDataRetriver.M2) && value[StreamCustomDataRetriver.M2] && _streamExtraBarShowDic["otherLogo"]) {
					if (!_otherLogo) {
						var otherLogo:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.PLAYER_OTHER_LOGO);
						_otherLogoIsLoading = true;
						otherLogo.addEventListener(PluginEvents.COMPLETE, otherLogoComplete);
					}
					show = true;
				} else {
					show = false;
				}
				if (_otherLogo) {
					(_otherLogo as DisplayObject).visible = show;
				}
			}
			
			//送礼
			if (Util.validateObj(value, StreamCustomDataRetriver.M8) && value[StreamCustomDataRetriver.M8] && (_streamExtraBarShowDic["gift"] as Boolean)) {
				if (!_outGift) {
					_outGift = new OutGift();
				}
				show = true;
			} else {
				show = false;
			}
			if (_outGift) {
				_outGift.visible = show;
			}
			
			//弹幕
			if (!_bulletsIsLoading) {
				if (Util.validateObj(value, StreamCustomDataRetriver.M7) && value[StreamCustomDataRetriver.M7] && _streamExtraBarShowDic["bullet"] && _streamExtraBarShowDic["bullet"]) {
					if (!_bulletsFlag) {
						var bu:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.BULLETS_OUT);
						_bulletsIsLoading = true;
						bu.addEventListener(PluginEvents.COMPLETE, buComplete);
					}
					show = true;
				} else {
					show = false;
				}
				if (_bullets) {
					(_bullets as DisplayObject).visible = show;
				}
			}
			//站外竞猜
			if (Util.validateObj(value, StreamCustomDataRetriver.M16) && value[StreamCustomDataRetriver.M16] && _streamExtraBarShowDic["outQuiz"]) {
				show = true;
				if (!_quizBtn) {
					_quizBtn = new OutQuizStartBtn();
					_streamExtraBar.call("addItem", _quizBtn, ExtraUIItemEnum.QUIZ);
				}
			} else {
				show = false;
			}
			if (_quizBtn) {
				_quizBtn.visible = show;
			}
			
			/*
			if (!_quizUI) {
				_quizUI = new OutQuizMainUI();
				_componenAfterLayer.addChild(_quizUI);
			}*/
			//_quizUI.y = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight - _quizUI.height;
		}
		
		private function otherLogoComplete(evt:PluginEvents):void {
			_otherLogoIsLoading = false;
			_otherLogo = evt.currentTarget.warpper;
			if (Util.validateObj(_UIMOduleData, StreamCustomDataRetriver.M2) && _UIMOduleData[StreamCustomDataRetriver.M2] && _streamExtraBarShowDic["otherLogo"]) {
				(_otherLogo as DisplayObject).visible = true;
			} else {
				(_otherLogo as DisplayObject).visible = false;
			}
		}
		
		private function buComplete(evt:PluginEvents):void {
			_bulletsFlag = true;
			_bulletsIsLoading = false;
			_bullets = evt.currentTarget.warpper;
//			_bullets.addToBar();
			if (Util.validateObj(_UIMOduleData, StreamCustomDataRetriver.M7) && _UIMOduleData[StreamCustomDataRetriver.M7] && _streamExtraBarShowDic["bullet"]) {
				(_bullets as DisplayObject).visible = true;
			} else {
				(_bullets as DisplayObject).visible = false;
			}
		}
		
//		/**
//		 * 延弹幕模块在_streamExtraBar中的位置，因为需要弹幕模块在礼物模块的左边
//		 */		
//		private function putGiftToBar():void {
//			if (Util.validateObj(_UIMOduleData, StreamCustomDataRetriver.M8) && _UIMOduleData[StreamCustomDataRetriver.M8]) {
//				if (_bulletsFlag) {
//					if (_streamExtraBarShowDic["gift"]) {
//						//当播放器小到一定宽度时会先隐藏礼物，因此要判断当前是否可以显示礼物
//						if (_giftFlag) {
//							_bullets.addToBar();
//						}
//					} else {
//						_bullets.addToBar();
//					}
//				}
//			} else {
//				_bullets.addToBar();
//			}
//		}
		
		protected function onShowShareHandler(data:Object):void
		{
			if(!_share)
			{
				_share = new ShareCompoment();
			}
			_share.showShare();
		}
		
		override protected function onShowBackRecommand(data:Object):void {
			if (Util.validateObj(_UIMOduleData, StreamCustomDataRetriver.M15) && _UIMOduleData[StreamCustomDataRetriver.M15]) {
				super.onShowRec(true);
			}
		}
		
		/**
		 * 对UI界面进行重新布局. 
		 */		
		override protected function onUIResize(data:Object = null):void {
			initAddStream();
			super.onUIResize(data);
		}
		
		/**
		 * 根据当前宽度计算那些组件可以被显示
		 */		
		private function checkResizeDic():void {
			var w:Number = Context.stage.stageWidth;
			_streamExtraBarShowDic["logo"] = true;
			_streamExtraBarShowDic["otherLogo"] = true;
			_streamExtraBarShowDic["gift"] = true;
			_streamExtraBarShowDic["bullet"] = true;
			_streamExtraBarShowDic["outQuiz"] = true;
			if (w < PlayerScope.PLAYER_WIDTH_1) {
				if (_UIMOduleData[StreamCustomDataRetriver.M1]) {
					//如果17173logo显示的话
					_streamExtraBarShowDic["otherLogo"] = false;
				}
			}
			if (w < PlayerScope.PLAYER_WIDTH_7) {
				_streamExtraBarShowDic["outQuiz"] = false;
			}
			if (w < PlayerScope.PLAYER_WIDTH_2) {
				_streamExtraBarShowDic["bullet"] = false;
			}
		}
		
		/**
		 * 记录注册过来的特殊标记
		 * 暂时只有声音和全屏
		 */		
		private function specilCompEnable(value:Object):void {
			if (!_specileMouseStateArr) {
				_specileMouseStateArr = value as Array;
			} else {
				var temp:Array = value as Array;
				if (temp) {
					for (var i:int = 0; i < temp.length; i++) {
						if (_specileMouseStateArr.indexOf(temp[i]) == -1) {
							_specileMouseStateArr.push(temp[i]);
						}
					}
				}
			}
		}
		
	}
}