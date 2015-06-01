package com._17173.flash.player.ad_refactor
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.delegate.AdDelegate_daqiantie_qiantie;
	import com._17173.flash.player.ad_refactor.delegate.AdDelegate_error;
	import com._17173.flash.player.ad_refactor.delegate.AdDelegate_others;
	import com._17173.flash.player.ad_refactor.delegate.AdDelegate_shanbo;
	import com._17173.flash.player.ad_refactor.delegate.IAdDelegate;
	import com._17173.flash.player.ad_refactor.interfaces.IAdController;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 播放器广告逻辑系统.负责处理各个广告实例之间的交互逻辑和依赖关系
	 *  
	 * @author 庆峰
	 */	
	public class AdController extends EventDispatcher implements IAdController 
	{
		
		/**
		 * 各个广告实现的集合 
		 */		
		protected var _delegates:Object = null;
		
		public function AdController()
		{
			_delegates = {};
		}
		
		public function set data(value:Object):void {
			if (value) {
				onAdResult(value);
			} else {
				onAdError(null);
				sendBI("0");
			}
		}
		
		public function dispose():void {
			for each (var delegate:IAdDelegate in _delegates) {
				delegate.dispose();
			}
		}
		
		protected function onAdError(error:Object):void {
			Debugger.log(Debugger.INFO, "[ad]", "无法加载广告数据文件!");
			// 启动错误逻辑代理
			if (!_delegates["error"]) {
				var delegate:IAdDelegate = new AdDelegate_error();
				delegate.onComplete = 
					function (r:Object = null):void {
						// 阻断性广告播放完毕
						onAdQiantieComplete(null);
					};
				delegate.onError = 
					function (e:Object = null):void {
						onAdQiantieComplete(null);
					};
				_delegates["error"] = delegate;
			}
			_delegates["error"].data = error;
		}
		
		/**
		 * 正确或者错误
		 *  
		 * @param data
		 */		
		protected function onAdResult(value:Object):void {
			if (!value || !value.hasOwnProperty(AdType.QIANTIE)) {
				// 为空或者没有A2属性,数据应该就是废了,出第三方广告或者广告屏蔽
				onAdError(value);
				sendBI("0");
			} else {
				// 先提供闪播数据
				initShanbo(value);
				// 再检查前贴和大前贴逻辑,目前需要前贴和大前贴同时支持
				initDaqiantieAndQiantie(value);
			}
		}
		
		/**
		 * 统合扩展前贴和普通前贴的逻辑,两者可以在同一轮进行互斥播放.
		 *  
		 * @param data
		 */		
		protected function initDaqiantieAndQiantie(value:Object):void {
			if (!_delegates["da_qian_tie_qian_tie"]) {
				// 初始化两个回调方法用来处理广告播放结束和出错的逻辑
				var delegate:IAdDelegate = new AdDelegate_daqiantie_qiantie();
				delegate.onComplete = 
						function (d:Object = null):void {
							// 阻断性广告播放完毕
							onAdQiantieComplete(value);
						};
				delegate.onError = 
						function (e:Object = null):void {
							// 如果出错就出第三方广告或者广告屏蔽
							onAdError(e);
							if (e && e["id"] && e["id"] != "") {
								sendBI(e["id"]);
							}
						};
				_delegates["da_qian_tie_qian_tie"] = delegate;
			}
			_delegates["da_qian_tie_qian_tie"].data = value;
		}
		
		/**
		 * 前贴或者大前贴或者错误界面或者第三方广告结束,此时应该进入视频界面了
		 *  
		 * @param value
		 */		
		protected function onAdQiantieComplete(value:Object):void {
			Debugger.log(Debugger.INFO, "[ad]", "前贴片广告组播放完毕!");
			
			// 全局标志
			_("isADPlayComplete", true);
			// 通知广告结束
			dispatchEvent(new Event("complete"));
			// 闪播
			Debugger.log(Debugger.INFO, "[ad]", "展示闪播");
			_(ContextEnum.JS_DELEGATE).send("videoQuickPlayShow");
			// 直播需要的接口
			if (_("type") == PlayerType.S_ZHANNEI || _("type") == PlayerType.A_PAD) {
				_(ContextEnum.JS_DELEGATE).send("liveplayAdEnd");			// 前贴广告播放结束
			}
			//点播用，现用于通知“奇遇广告”可以开始计时了
			if (_("type") == PlayerType.F_ZHANEI) {
				_(ContextEnum.JS_DELEGATE).send("firstAdEnd");			// 前贴广告播放结束
			}
			if (_("type") == PlayerType.A_OUT) {
				_(ContextEnum.JS_DELEGATE).send("outerClose");             // 通知js前贴广告播放结束
			}
			// 启动其它广告
			initOtherAds(value);
		}
		
		/**
		 * 初始化闪播
		 *  
		 * @param value
		 */		
		protected function initShanbo(value:Object):void {
			if (value && value.hasOwnProperty(AdType.SHANBO) && value[AdType.SHANBO]) {
				var delegate:IAdDelegate = new AdDelegate_shanbo();
				delegate.data = value[AdType.SHANBO];
			}
		}
		
		/**
		 * 启动非前贴或者大前贴的其他广告
		 *  
		 * @param data
		 */		
		protected function initOtherAds(value:Object):void {
			if (!value) return;
			if (!_delegates["other"]) {
				_delegates["other"] = new AdDelegate_others();
			}
			_delegates["other"].data = value;
		}
		
		/**
		 * 
		 * @param type 0：广告配置请求url被屏蔽
		 * @param value 2：表示广告被屏蔽
		 * 
		 */		
		private function sendBI(type:String):void {
			var adFlag:String = "";
			switch (type) {
				case "0":
					//大前贴第一轮
					adFlag = "0";
					break;
				case "73":
					//大前贴第一轮
					adFlag = "1";
					break;
				case "98":
					//大前贴第二轮
					adFlag = "2";
					break;
				case "74":
					//前贴第一轮
					adFlag = "3";
					break;
				case "75":
					//前贴第二轮
					adFlag = "4";
					break;
			}
			var obj:Object = {};
			obj["ads_code"] = adFlag;//bi统计中的闪播广告类型
			obj["is_replay"] = "2";//0:第一次播放 1：第二次播放  2：被屏蔽
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_AD_SHOW, obj);
		}
		
	}
}