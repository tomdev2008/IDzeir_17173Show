package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;

	/**
	 * 大前贴和前贴的控制逻辑
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_daqiantie_qiantie extends BaseAdDelegate
	{
		
		private var _count:int = 0;
		
		private var _ads:Array = null;
		private var _delegates:Object = null;
		private var _daqiantieNS:String = "";
		
		/**
		 * 需要注册一个完成和错误的回调方法,用来交给调用者进行逻辑处理.
		 *  
		 * @param onComplete
		 * @param onError
		 */		
		public function AdDelegate_daqiantie_qiantie()
		{
			_delegates = {};
		}
		
		override public function set data(value:Object):void {
			fileterData(value);
			
			_data = value;
			init();
		}
		
		/**
		 * 点播站外大前贴数据过滤
		 */		
		private function fileterData(value:Object):void {
			if (_("type") == PlayerType.F_ZHANWAI || _("type") == PlayerType.A_OUT) {
				var showNS:String = _(ContextEnum.JS_DELEGATE).checkCanShowDaQianTie();
				if (!showNS || showNS == "") {
//					Debugger.log(Debugger.INFO, "[前贴、大前贴广告]没有大前贴播放器");
					value[AdType.DAQIANTIE] = [];
				} else {
					_daqiantieNS = showNS;
//					Debugger.log(Debugger.INFO, "[前贴、大前贴广告]可以播放大前贴");
				}
			}
		}
		
		override protected function init():void {
			Debugger.log(Debugger.INFO, "[ad]", "扩展前贴/前贴初始化");
			var daqiantie:Array = _data[AdType.DAQIANTIE];
			var qiantie:Array = _data[AdType.QIANTIE];
			_ads = combineDaqiantieAndQiantie(daqiantie, qiantie);
			
			preCalcAdData();
			
			startShowQiantieOrDaqiantie();
		}
		
		/**
		 * 把当前的大前贴数据和前贴数据根据业务需求组合起来.</br>
		 * 当前需求要求分两轮,每轮都有可能有前贴或者扩展前贴,单轮中同时有扩展和普通的情况下,按50%的几率互斥出现.
		 *  
		 * @param daqiantie
		 * @param qiantie
		 * @return 
		 */		
		protected function combineDaqiantieAndQiantie(daqiantie:Array, qiantie:Array):Array {
			var result:Array = [];
			
			// 先提出来
			var d1:AdData_refactor = daqiantie && daqiantie.length > 0 ? daqiantie[0] : null;
			var d2:AdData_refactor = daqiantie && daqiantie.length > 1 ? daqiantie[1] : null;
			var q1:AdData_refactor = qiantie && qiantie.length > 0 ? qiantie[0] : null;
			var q2:AdData_refactor = qiantie && qiantie.length > 1 ? qiantie[1] : null;
			// 根据业务关系判断组合,第一轮大前贴和前贴互斥
//			var r:AdData_refactor = daqiantieAndQiantieSingleRound(d1, q1, "adRound1");
			var r:AdData_refactor = Daqiantie_qiantie_relation.getRelation(d1, q1, 100);
			if (r) {
				result.push(r);
			}
			// 第二轮大前贴和前贴互斥
//			r = daqiantieAndQiantieSingleRound(d2, q2, "adRound2");
			r = Daqiantie_qiantie_relation.getRelation(d2, q2, 100);
			if (r) {
				result.push(r);
			}
			
			return result;
		}
		
		/**
		 * 因为大前贴和前贴有业务逻辑关系,根据逻辑判断当前是要播放大前贴还是前贴.</br>
		 * 不同的组合,逻辑在实现时有细微差别:</br>
		 * 1.两个都是扩展前贴 -> 要保证时间叠加,最好是像前贴片一样,实现连续播放,所以这时传给大前贴的是一个数组.</br>
		 * 2.两个都是普通前贴 -> 按照原来的逻辑即可,传入数组.</br>
		 * 3.一个扩展一个普通 -> 要保证时间叠加,必须在所传的addata里增加新的字段,用来标识总时间,这时为了让逻辑在判断的时候更简单,可以不再传入数组,改为传入单个addata对象.</br>
		 * 所以这里做个看起来复杂的分支,把多种情况的做一个判断.
		 */		
		protected function startShowQiantieOrDaqiantie():void {
			var type:String = null;
			var isSame:Boolean = true;
			for each (var ad:AdData_refactor in _ads) {
				if (type == null) {
					type = ad.type;
				} else {
					// 只要遇到不一样的type,就直接取消循环
					if (ad.type != type) {
						isSame = false;
						break;
					}
				}
			}
			if (isSame) {
				// 类型相同的情况下,根据类型判断是要走大前贴还是前贴
				switch (type) {
					case AdType.DAQIANTIE : 
						startDaqiantie(_ads, complete);		// 播完就是前贴结束
						break;
					case AdType.QIANTIE : 
						startQiantie(_ads, complete);		// 播完就是前贴结束
						break;
					default : 
						showNext();
						break;
				}
			} else {
				// 准备一个个展现
				showNext();
			}
		}
		
		/**
		 * 预处理数据,将广告时间总和录入广告数据中 
		 */		
		protected function preCalcAdData():void {
			// 从数组的尾部开始循环
			var i:int = _ads.length - 1;
			var t:int = 0;
			var ad:AdData_refactor = null;
			for (i; i >= 0; i --) {
				ad = _ads[i];
				t += ad.time;
				ad.totalTime = t;
			}
		}
		
		/**
		 * 寻找下一个前贴类型的广告 
		 */		
		protected function showNext():void {
			var ad:AdData_refactor = _ads && _ads.length > 0 ? _ads.shift() : null;
			if (ad) {
				_count ++;
				if (ad.type == AdType.DAQIANTIE) {
					// 大前贴逻辑
					startDaqiantie(ad, showNext);
				} else if (ad.type == AdType.QIANTIE) {
					// 前贴逻辑
					startQiantie(ad, showNext);
				}
			} else {
				complete(null);
				Debugger.log(Debugger.INFO, "[ad]", _count == 0 ? "没有前贴/扩展前贴数据!" : "前贴与大前贴已经播放完毕!");
			}
		}
		
		/**
		 * 启动大前贴
		 *  
		 * @param ad
		 */		
		protected function startDaqiantie(ad:Object, callback:Function):void {
			Debugger.log(Debugger.INFO, "[ad]", "展示大前贴广告!");
			if (!_delegates["daqiantie"]) {
				var delegate:IAdDelegate = new AdDelegate_daqiantie();
				delegate.onComplete = 
					function ():void {
						Debugger.log(Debugger.INFO, "[ad]", "大前贴播放完毕!");
						if (callback != null) {
							callback.apply(null, null);
						}
					};
				delegate.onError = error;
				_delegates["daqiantie"] = delegate;
			}
			if (_daqiantieNS && _daqiantieNS != "") {
				_delegates["daqiantie"].ns = _daqiantieNS;
			} else {
				_delegates["daqiantie"].ns = null;
			}
			_delegates["daqiantie"].data = ad;
			
			//记录bi统计
			var obj:Object = {};
			if (ad["id"] == "98") {
				obj["ads_code"] = "2";//大前贴第二轮
			} else {
				obj["ads_code"] = "1";//大前贴第一轮
			}
			
			obj["is_replay"] = "0";//不是重复播放
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_AD_SHOW, obj);
		}
		
		/**
		 * 启动前贴 
		 * 
		 * @param ad
		 */		
		protected function startQiantie(ad:Object, callback:Function):void {
			Debugger.log(Debugger.INFO, "[ad]", "展示普通前贴广告!");
			if (!_delegates["qiantie"]) {
				var delegate:IAdDelegate = new AdDelegate_qiantie();
				delegate.onComplete = 
					function ():void {
						Debugger.log(Debugger.INFO, "[ad]", "前贴播放完毕!");
						if (callback != null) {
							callback.apply(null, null);
						}
					};
				delegate.onError = error;
				_delegates["qiantie"] = delegate;
			}
			_delegates["qiantie"].data = ad;
		}
		
		override public function dispose():void {
			for (var k:String in _delegates) {
				_delegates[k].dispose();
			}
		}
		
	}
}