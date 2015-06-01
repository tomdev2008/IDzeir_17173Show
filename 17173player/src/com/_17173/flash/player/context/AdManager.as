package com._17173.flash.player.context
{
	import com._17173.flash.core.ad.AdEnum;
	import com._17173.flash.core.ad.BaseAdManager;
	import com._17173.flash.core.ad.display.AdA2_Baidu;
	import com._17173.flash.core.ad.display.AdError;
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.ad.model.AdData;
	import com._17173.flash.core.ad.model.AdDataResolver;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.interfaces.IRendable;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.net.loaders.resolver.JSONResolver;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.business.stream.custom.StreamCustomDataRetriver;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 广告管理类.
	 * 负责加载并解析广告数据文件,基础的广告业务以及派发消息通知.
	 *  
	 * @author shunia-17173
	 */	
	public class AdManager extends BaseAdManager implements IContextItem
	{
		
		/**
		 * 广告文件路径 
		 */		
		protected var _adURL:String = "";
		
		/**
		 * 存放广告位显示配置
		 */		
		protected var _showFlag:Object = {};
		
		private var _A2:IAdDisplay = null;
		
		private var _A2_baidu:IAdDisplay = null;
		
		private var _AdError:IAdDisplay = null;
		
		/**
		 * 暂停广告 
		 */		
		private var _A3:IAdDisplay = null;
		
		/**
		 * 当前的播放轮数
		 */		
		private var _currentCount:int = 0;
		
		public function AdManager()
		{
			super();
		}
		
		public function get contextName():String {
			return ContextEnum.AD_MANAGER;
		}
		
		public function startUp(param:Object):void {
			Debugger.log(Debugger.INFO, "[ad]", "版本号:1.0.21");
			
			prepareADInfo();
			
			//监听启动广告调度事件
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_START_LOAD_AD_INFO, prepareInitAds);
		}
		
		/**
		 * 根据当前播放器类型和传入的adType判断对应读取的广告配置文件地址和要显示哪些广告位
		 */		
		protected function prepareADInfo():void {
			//解析配置
			var p:AdPath = new AdPath(_("type"));
			_adURL = p.currentPath;
//			_adURL = "assets/shortSwfAdTest.json";
//			_adURL = "http://10.6.212.172/ad13.json";
//			_adURL = "http://10.6.212.172/ad6.json";
//			_adURL = "http://10.6.212.172/ad2.json   ";
//			_adURL = "http://127.0.0.1:8080/test/ad2.json"; 
			Debugger.log(Debugger.INFO, "[ad]", "广告配置路径: " + _adURL);
			//光该位置和类型限制数据
			_showFlag = AdPosition.getPosition();
		}
		
		/**
		 * 根据_adURL来判断如何加载广告
		 */		
		protected function prepareInitAds(data:Object):void {
			Debugger.tracer(Debugger.ERROR, "[AD]" + "adUrl:" + _adURL);
			reInitAD();
			if (Util.validateStr(_adURL)) {
				//启动加载
				initAds();
				//通知广告已经初始化
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_INIT);
			} else {
				//不需要加载广告，直接到结束
			}
		}
		
		/**
		 * 防止直接内部切换视频的时候广告未播放完毕导致多个广告的问题
		 */		
		private function reInitAD():void {
			if (_A2) {
//				Global.businessManager.removeRenderItem(IRendable(_A2));
				_(ContextEnum.BUSINESS_MANAGER).removeRenderItem(IRendable(_A2));
				_A2.removeEventListener("adComplete", onAdA2Complete);
				_A2.removeEventListener("onAdError", onA2Error);
				_A2 = null;
			}
			if (_A2_baidu) {
//				Global.businessManager.removeRenderItem(IRendable(_A2_baidu));
				_(ContextEnum.BUSINESS_MANAGER).removeRenderItem(IRendable(_A2_baidu));
				_A2_baidu.removeEventListener("adComplete", onAdBaiduComplete);
				_A2_baidu.removeEventListener("onAdError", onAdBaiduError);
				_A2_baidu = null;
			}
			if (_AdError) {
//				Global.businessManager.removeRenderItem(IRendable(_AdError));
				_(ContextEnum.BUSINESS_MANAGER).removeRenderItem(IRendable(_AdError));
				_AdError.removeEventListener("adComplete", onAdErrorComplete);
				_AdError.removeEventListener("onAdError", onAdErrorError);
				_AdError = null;
			}
			_A3 = null;
		}
		
		/**
		 * 广告调度 
		 */		
		protected function initAds():void {
			Debugger.log(Debugger.INFO, "[ad]", "开始加载广告数据文件!" + _adURL);
			//加载广告调度文件
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption(
				_adURL, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, 
				onAdConfigRetrived, onAdConfigError);
			option.manuallyResolver = JSONResolver;
			loader.load(option);
		}
		
		/**
		 * 广告文件成功加载完成调度
		 *  
		 * @param data
		 */		
		protected function onAdConfigRetrived(data:Object):void {
			if (validateAdData(data)) {
				Debugger.log(Debugger.INFO, "[ad]", "加载广告数据文件成功!");
				//解析广告数据
				init(data, _showFlag);
				//闪播广告数据
				
				showFlashAD();
				//显示广告
				showAd();
			} else {
				Debugger.log(Debugger.INFO, "[ad]", "加载广告数据文件解析失败!");
				//显示广告
				showErrorAd();
			}
			//通知广告数据初始化完成
			onAdInitComplete();
		}
		
		/**
		 * 闪播广告 
		 */		
		private function showFlashAD():void {
			_(ContextEnum.JS_DELEGATE).send("videoQuickPlay", getAdData(AdEnum.A6));
//			JSBridge.addCall("videoQuickPlay", getAdData(AdEnum.A6));
		}
		
		/**
		 * 验证广告文件.
		 *  
		 * @param data
		 * @return 
		 */		
		protected function validateAdData(data:Object):Boolean {
			if (data == "-1") {
				//广告配置文件如果解析失败会返回-1
				return false;
			} else {
				return true;
			}
		}
		
		/**
		 * 开始显示广告 
		 */		
		protected function showAd():void {
			Debugger.log(Debugger.INFO, "[ad]", "开始启动广告播放!");
			
			var a1:Array = getAdData(AdEnum.A1);
			var a2:IAdDisplay = getAd(AdEnum.A2);
			
			if (a1 && a1.length > 0) {
				//是否有A1
				if (a2 && a2.display) {
					if (a2.sourceData.length >= 2) {
						//如果A2有两轮前贴，那么轮流播放
						showFirstAD(3);
					} else {
						if (a2.sourceData && a2.sourceData.length > 0 && (a2.sourceData[0] as AdData).roundNum == 1) {
							//如果唯一的一轮是前贴是第一轮那么轮流播放
							showFirstAD(3);
						} else {
							//前贴是第二轮，播放大前贴
							showFirstAD(1);
						}
					}
				} else {
					//没有A2直接播放A1
					showFirstAD(1);
				}
			} else {
				if (!a2 || !a2.display) {
					//没有A1和A2播放百度联盟广告
//					startAdThird();
					Debugger.tracer(Debugger.INFO, "[AD]" + "无前贴广告，直接开始视频");
					onFirstAdComplete();
				} else {
					//没有A1但是有A2直接播放A2
					startAdA2();
				}
			}
		}
		
		/**
		 * 根据参数播放前贴（大前贴+前贴的组合）
		 * 1：大前贴 2：前贴 3:随机某一个
		 */		
		private function showFirstAD(value:int):void {
			switch(value) {
				case 1:
					_currentCount = 1;
					startAdA1(getAdData(AdEnum.A1)[0]);
					break;
				case 2:
					startAdA2();
					break;
				case 3:
					//轮流播放A1或者A2
					var showA1Flag:Boolean = AdDataResolver.getLastShowFlag() == 1;
					if (showA1Flag) {
						AdDataResolver.saveCurrentShowFlag(2);
						_currentCount = 1;
						startAdA1(getAdData(AdEnum.A1)[0]);
					} else {
						AdDataResolver.saveCurrentShowFlag(1);
						startAdA2();
					}
					break;
				default : 
					AdDataResolver.saveCurrentShowFlag(2);
					_currentCount = 1;
					startAdA1(getAdData(AdEnum.A1)[0]);
			}
		}
		
		/**
		 * 广告配置文件解析错误调用
		 */		
		protected function showErrorAd():void {
			Debugger.log(Debugger.INFO, "[ad]", "启动解析错误流程!");
//			Global.eventManager.send(PlayerEvents.BI_AD_DATA_ERROR);
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_DATA_ERROR);
			startAdThird();
		}
		
		/**
		 * 广告文件获取失败.
		 *  
		 * @param error
		 */		
		protected function onAdConfigError(error:Object):void {
			Debugger.log(Debugger.INFO, "[ad]", "无法加载广告数据文件!");
//			Global.eventManager.send(PlayerEvents.BI_AD_DATA_ERROR);
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_DATA_ERROR);
			if (Util.validateObj(_showFlag, AdEnum.A2) && Util.validateObj(_showFlag[AdEnum.A2], "third")) {
				startAdThird();
			} else {
				showErrorPage();
			}
		}
		
		/**
		 * 广告文件数据已获取 
		 */		
		protected function onAdInitComplete():void {
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_DATA_RETIVED);
		}
		
		/**
		 * 广告已经结束播放 
		 */		
		protected function onShowAdComplete():void {
			_("isADPlayComplete", true);
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_COMPLETE);
		}
		
		/**
		 * 大前贴 
		 */		
		private function startAdA1(valule:Object):void {
			if (checkShowState("A2") && isAdAvalible(AdEnum.A1)) {
//				var A1Data:Array = _adConf[AdEnum.A1];valule
//				if (A1Data && A1Data.length && A1Data[0].url != "") {
				if (valule && valule["url"] != "") {
					Debugger.log(Debugger.INFO, "[ad]", "展示大前贴广告!");
					//有大前贴则等待js返回大前贴结果
					var js:* = _(ContextEnum.JS_DELEGATE);
					js.send("onStartA1", valule);
					js.listen("onA1Complete", onAdA1Complete);
					js.listen("onAdA1Begin",onAdA1Begin);
					
					//站外播放器没有大前帖，直接跳过
					if(_(ContextEnum.SETTING)["type"] == PlayerType.F_ZHANWAI) {
						onAdA1Complete();
					}
				} else {
					//没有大前贴则开始播放前贴
					Debugger.log(Debugger.INFO, "[ad]", "无大前贴数据,播放前贴广告!");
					onAdA1Complete();
				}
			} else {
				//没有大前贴则开始播放前贴
				Debugger.log(Debugger.INFO, "[ad]", "无大前贴数据,播放前贴广告!");
				onAdA1Complete();
			}
		}
		
		private function onAdA1Begin():void {
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ADA1_BEGIN);
		}
		
		/**
		 * 大前贴完成则直接开始播放视频 
		 */		
		private function onAdA1Complete():void {
			Debugger.log(Debugger.INFO, "[ad]", "大前贴广告播放结束!");
			checkFirstFinish();
		}
		
		private function checkFirstFinish():void {
			var a1:Array = getAdData(AdEnum.A1);
			var a2:IAdDisplay = getAd(AdEnum.A2);
			if (a1.length == 2) {
				onFirstAdComplete();
			} else {
				//查找前贴里是否还存在第二轮广告
				if (!a2 || !a2.display || a2.sourceData.length == 0) {
					onFirstAdComplete();
				} else {
					_currentCount = 2;
					if (a2.sourceData.length == 2) {
						//如果A2有轮，那么重新赋值，直接播放第二轮
						var temp:Array = [];
						temp.push(a2.sourceData[1]);
						a2.data = temp;
						startAdA2();
					} else {
						if (a2.sourceData[0]["roundNum"] == 2) {
							//如果A2里剩余的是第二轮，那么直接播放
							startAdA2();
						} else {
							//如果A2里剩余的是第一轮，那么直接结束广告播放
							onFirstAdComplete();
						}
					}
				}
			}
			//以下为将来大前贴支持第二轮播放做准备
//			if (a1.length == 1) {
//				
//			} else {
//				if (_currentCount == 2) {
//					onFirstAdComplete();
//				} else {
//					if (!a2 || !a2.display || a2.sourceData.length < 2) {
//						_currentCount = 2;
//						startAdA1(getAdData(AdEnum.A1)[1]);
//					} else {
//						_currentCount = 2;
//						//随机播放A1或者A2
//						var showA1Flag:Boolean = AdDataResolver.getLastShowFlag() == 1;
//						if (showA1Flag) {
//							//播放A1第二轮
//							Debugger.log(Debugger.INFO, "[ad]", "11");
//							AdDataResolver.saveCurrentShowFlag(2);
//							startAdA1(getAdData(AdEnum.A1)[1]);
//						} else {
//							//播放A2第二轮
//							Debugger.log(Debugger.INFO, "[ad]", "12");
//							AdDataResolver.saveCurrentShowFlag(1);
//							var temp1:Array = [];
//							temp1.push(a2.sourceData[1]);
//							a2.data = temp1;
//							startAdA2();
//						}
//					}
//				}
//			}
		}
		
		/**
		 * 开始播放前贴广告 
		 */		
		private function startAdA2():void {
			if (checkShowState("A2") && isAdAvalible(AdEnum.A2)) {
				_A2 = getAd(AdEnum.A2);
				if (_A2 && !_A2.error) {
					Debugger.log(Debugger.INFO, "[ad]", "前贴广告开始播放!");
					//_A2.resize(Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth, Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - 10);
//					Global.businessManager.addRenderItem(IRendable(_A2));
					_(ContextEnum.BUSINESS_MANAGER).addRenderItem(IRendable(_A2));
					_A2.addEventListener("adComplete", onAdA2Complete);
					_A2.addEventListener("onAdError", onA2Error);
//					(Global.uiManager.getLayer("adpopup") as PopupLayer).popdown(_A2.display, new Point(0, 0));
					_(ContextEnum.UI_MANAGER).getLayer("adpopup").popdown(_A2.display, new Point(0, 0));
				}
			} else {
				onFirstAdComplete();
			}
		}
		
		/**
		 * 前贴播放结束 
		 * @param data
		 */		
		private function onAdA2Complete(data:Object = null):void {
			Debugger.log(Debugger.INFO, "[ad]", "前贴广告播放结束!");
			_(ContextEnum.UI_MANAGER).hideErrorPanel();
			_(ContextEnum.UI_MANAGER).getLayer("adpopup").cleanPopUp();
			
			if (getAd(AdEnum.A2).sourceData.length == 2) {
				//如果前贴已经播放了两轮，那么结束
				onFirstAdComplete();
			} else {
				if (getAd(AdEnum.A2).sourceData[0]["roundNum"] == 1) {
					//如果已经播放的是第一轮，那么检测大前贴中是否还有第二轮
					var a1:Array = getAdData(AdEnum.A1);
					if (a1.length == 2) {
						_currentCount = 2;
						startAdA1(getAdData(AdEnum.A1)[1]);
					} else {
						onFirstAdComplete();
					}
				} else {
					onFirstAdComplete();
				}
			}
			
		}
		
		private function onA2Error(e:Event):void {
//			onAdA2Complete(null);
			onAdConfigError(null);
		}
		
		/**
		 * 关闭a2
		 */		
		private function hideA2():void {
			if(_A2)
			{
//				Global.uiManager.closePopup(_A2.display);
				_(ContextEnum.UI_MANAGER).closePopup(_A2.display);
				_A2.removeEventListener("adComplete", onAdA2Complete);
				_A2.removeEventListener("onAdError", onA2Error);
				_A2 = null;
			}
		}
		
		/**
		 * 会阻断播放过程的广告已经播放完了(大前贴或者前贴) 
		 */		
		private function onFirstAdComplete():void {
			//闪播广告开始展现
			_(ContextEnum.JS_DELEGATE).send("videoQuickPlayShow");
			// 要发到window下
			if (_("type") == PlayerType.S_ZHANNEI) {
				JSBridge.addCall("liveplayAdEnd", null, "window");
			}
			
			hideA2();//关闭前贴放在最后是为了防止单独过滤前贴素材的时候，切换前贴和百度广告或者拦截页面时候会漏出后面pt的bug
			Debugger.log(Debugger.INFO, "[ad]", "广告播放结束!进入视频播放流程!");
			startAdA4();
			startAdA5();
			
			if (checkShowState("A3")) {
//				Global.eventManager.listen(PlayerEvents.UI_PLAY_OR_PAUSE, onShowA3, this);
				_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_PLAY_OR_PAUSE, onShowA3);
				//分享功能的时候会直接调用视频的时间，不会派发PlayerEvents.UI_PLAY_OR_PAUSE事件，所以需要监听视频的这个事件
//				Global.eventManager.listen(PlayerEvents.VIDEO_RESUME, onRemoveA3);
				_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.VIDEO_RESUME, onRemoveA3);
			}
			
			onShowAdComplete();
		}
		
		private function onShowA3(isPlay:Boolean):void {
			if (isPlay) {
				hideA3();
			} else {
				showA3();
			}
		}
		
		private function onRemoveA3(data:Object):void {
			hideA3();
		}
		
		/**
		 * 显示暂停广告 
		 */		
		private function showA3():void {
			if(!_A3 && isAdAvalible(AdEnum.A3))
			{
				_A3 = getAd(AdEnum.A3);
			}
			if (_A3 && !_A3.error) {
				_A3.addEventListener("close", 
					function (evt:Event):void
					{
						hideA3();
					}
				);
//				var w:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoWidth;
//				var h:Number = (Context.getContext(ContextEnum.UI_MANAGER) as UIManager).avalibleVideoHeight;
				var w:Number = _(ContextEnum.UI_MANAGER).avalibleVideoWidth;
				var h:Number = _(ContextEnum.UI_MANAGER).avalibleVideoHeight;
				if (!_A3["showFlag"](w, h)) {
					//根据当前播放器的宽高判断是否可以显示暂停广告 
					return;
				}
//				Global.uiManager.popup(_A3.display);
				_(ContextEnum.UI_MANAGER).popup(_A3.display);
			}
		}
		
		/**
		 * 隐藏暂停广告 
		 */		
		private function hideA3():void {
			if (_A3) {
//				Global.uiManager.closePopup(_A3.display);
				_(ContextEnum.UI_MANAGER).closePopup(_A3.display);
			}
		}
		
		/**
		 * 下底广告 
		 */		
		private function startAdA4():void {
			var A4:IAdDisplay = getAd(AdEnum.A4);
			if (A4 && !A4.error) {
				Debugger.log(Debugger.INFO, "[ad]", "有下底广告，开始加载");
				//加载完成,附加到controlbar中
//				Global.eventManager.send(PlayerEvents.BI_AD_SHOW_A4, A4);
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_SHOW_A4, A4);
			} else {
				Debugger.log(Debugger.INFO, "[ad]", "无下底广告");
			}
		}
		
		/**
		 * 挂角广告 
		 */		
		private function startAdA5():void {
			var A5:IAdDisplay = getAd(AdEnum.A5);
			if (A5 && !A5.error) {
				Debugger.log(Debugger.INFO, "[ad]", "有挂角广告，开始加载");
				//加载完成,附加到controlbar中
//				Global.eventManager.send(PlayerEvents.BI_AD_SHOW_A5, A5);
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_SHOW_A5, A5);
			} else {
				Debugger.log(Debugger.INFO, "[ad]", "无挂角广告");
			}
		}
		/**
		 * 显示第三方（百度联盟）的广告
		 */		
		private function startAdThird():void {
			Debugger.log(Debugger.INFO, "[ad]", "广告数据异常，执行第三方广告");
			//只有站内点播才显示百度推广，因为站外无法保证allowScriptAccess参数
			if (!Util.validateObj(_showFlag[AdEnum.A2], "third")) {
				Debugger.log(Debugger.INFO, "[ad]", "站外播放器不允许播放第三方广告，直接开始视频");
//				Global.uiManager.hideErrorPanel();
				_(ContextEnum.UI_MANAGER).hideErrorPanel();
				onFirstAdComplete();
				return;
			}
			if (!_A2_baidu) {
				_A2_baidu = new AdA2_Baidu();
				_A2_baidu.data = null;
			}
//			Global.uiManager.popup(_A2_baidu.display, new Point(0, 0));
//			Global.businessManager.addRenderItem(IRendable(_A2_baidu));
			_(ContextEnum.UI_MANAGER).popup(_A2_baidu.display, new Point(0, 0));
			_(ContextEnum.BUSINESS_MANAGER).addRenderItem(IRendable(_A2_baidu));
			_A2_baidu.addEventListener("adComplete", onAdBaiduComplete);
			_A2_baidu.addEventListener("onAdError", onAdBaiduError);
		}
		
		private function removeADBaidu():void {
			if(_A2_baidu)
			{
//				Global.uiManager.closePopup(_A2_baidu.display);
//				Global.businessManager.removeRenderItem(IRendable(_A2_baidu));
				_(ContextEnum.UI_MANAGER).closePopup(_A2_baidu.display);
				_(ContextEnum.BUSINESS_MANAGER).removeRenderItem(IRendable(_A2_baidu));
				_A2_baidu.removeEventListener("adComplete", onAdBaiduComplete);
				_A2_baidu.removeEventListener("onAdError", onAdBaiduError);
				_A2_baidu = null;
			}
		}
		
		/**
		 * 第三方前贴播放结束 
		 * @param data
		 */		
		private function onAdBaiduComplete(data:Object = null):void {
			Debugger.log(Debugger.INFO, "[ad]", "第三方前贴广告播放结束!");
			removeADBaidu();
//			Global.uiManager.hideErrorPanel();
			_(ContextEnum.UI_MANAGER).hideErrorPanel();
			
			onFirstAdComplete();
		}
		
		private function onAdBaiduError(e:Event):void {
			Debugger.log(Debugger.INFO, "[ad]", "第三方广告错误!");
			removeADBaidu();
			showErrorPage();
		}
		
		/**
		 * 检测其它可以控制广告显示/隐藏的限制
		 * @param type 要检查的状态
		 * @return 
		 * 
		 */		
		protected function checkShowState(type:String):Boolean {
			var re:Boolean = true;
			var ui:Object = _("UIModuleData");
			
			if (type == "A2") {
//				if (Context.variables["type"] == Settings.PLAYER_TYPE_FILE_OUT_CUSTOM) {
				if (_("type") == PlayerType.F_CUSTOM) {
					//检查点播企业版是否配置前贴广告
					if (Util.validateObj(ui, FileCustomerDataRetriver.M10)) {
						re = ui[FileCustomerDataRetriver.M10];
					} else {
						re = true;
					}
//				} else if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
				} else if (_("type") == PlayerType.S_CUSTOM) {
					if (Util.validateObj(ui, StreamCustomDataRetriver.M10)) {
						re = ui[StreamCustomDataRetriver.M10];
					} else {
						re = true;
					}
				}
			}
			
			if (type == "A3") {
//				if (Context.variables["type"] == Settings.PLAYER_TYPE_FILE_OUT_CUSTOM) {
				if (_("type") == PlayerType.F_CUSTOM) {
					//检查点播企业版是否配置暂停广告
					if (Util.validateObj(ui, FileCustomerDataRetriver.M11)) {
						re = ui[FileCustomerDataRetriver.M11];
					} else {
						re = true;
					}
//				} else if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
				} else if (_("type") == PlayerType.S_CUSTOM) {
					if (Util.validateObj(ui, StreamCustomDataRetriver.M11)) {
						re = ui[StreamCustomDataRetriver.M11];
					} else {
						re = true;
					}
				}
			}
			return re;
		}
		
		private function showErrorPage():void {
			Debugger.log(Debugger.INFO, "[ad]", "广告被屏蔽!");
			if (!_AdError) {
				_AdError = new AdError();
			}
			_AdError.data = null;
//			Global.uiManager.popup(_AdError.display, new Point(0, 0));
//			Global.businessManager.addRenderItem(IRendable(_AdError));
			_(ContextEnum.UI_MANAGER).popup(_AdError.display, new Point(0, 0));
			_(ContextEnum.BUSINESS_MANAGER).addRenderItem(IRendable(_AdError));
			_AdError.addEventListener("adComplete", onAdErrorComplete);
		}
		
		/**
		 * 广告错误结束 
		 * @param data
		 */		
		private function onAdErrorComplete(data:Object = null):void {
			Debugger.log(Debugger.INFO, "[ad]", "错误广告播放结束!");
			if(_AdError)
			{
//				Global.uiManager.closePopup(_AdError.display);
//				Global.businessManager.removeRenderItem(IRendable(_AdError));
				_(ContextEnum.UI_MANAGER).closePopup(_AdError.display);
				_(ContextEnum.BUSINESS_MANAGER).removeRenderItem(IRendable(_AdError));
				_AdError.removeEventListener("adComplete", onAdErrorComplete);
				_AdError.removeEventListener("onAdError", onAdErrorError);
				_AdError = null;
			}
//			Global.uiManager.hideErrorPanel();
			_(ContextEnum.UI_MANAGER).hideErrorPanel();
			
			onFirstAdComplete();
		}
		
		private function onAdErrorError(data:Object):void {
//			Global.uiManager.hideErrorPanel();
			_(ContextEnum.UI_MANAGER).hideErrorPanel();
			
			onFirstAdComplete();
		}
	}
}