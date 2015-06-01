package com._17173.flash.core.ad.model
{
	import com._17173.flash.core.ad.AdEnum;
	import com._17173.flash.core.ad.display.AdA2;
	import com._17173.flash.core.ad.display.AdA3;
	import com._17173.flash.core.ad.display.AdA3_baidu;
	import com._17173.flash.core.ad.display.AdA4;
	import com._17173.flash.core.ad.display.AdA5;
	import com._17173.flash.core.ad.display.StreamAdA4;
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	public class AdDataResolver
	{
		private static var _cookie:Cookies = null;
		
		/**
		 * 百度联盟广告
		 */		
		public static const AD_TYPE_BAIDU:String = "baidu";
		
		/**
		 * 是否可以显示前贴第三方广告
		 */		
		private static var _canA2Third:Boolean = false;
		
		/**
		 * 是否可以显示暂停第三方广告
		 */		
		private static var _canA3Third:Boolean = false;
		
		public function AdDataResolver()
		{
		}
		
//		public static function resolve2(data:Object, showFlag:Object):Object {
//			var o:Object = {};
//			var re:Object = {};
//			
//			var func:Function = function (type:String):void {
//				if (data.hasOwnProperty(type)) {
//					var d:Object = data[type];
//					if (validateData(d)) {
//						o[type] = packAdData(type, d);
//					}
//				}
//			};
//			if (showFlag.hasOwnProperty(AdEnum.A1) && showFlag[AdEnum.A1]) {
//				func(AdEnum.A1);
//			} else {
//				o[AdEnum.A1] = new Array();
//			}
//			if (showFlag.hasOwnProperty(AdEnum.A2)) {
//				if (Util.validateObj(showFlag[AdEnum.A2], "third")) {
//					_canA2Third = true;
//				}
//				func(AdEnum.A2);
//			}
//			if (showFlag.hasOwnProperty(AdEnum.A3)) {
//				if (Util.validateObj(showFlag[AdEnum.A3], "third")) {
//					_canA3Third = true;
//				}
//				func(AdEnum.A3);
//			}
//			if (showFlag.hasOwnProperty(AdEnum.A4) && showFlag[AdEnum.A4]) {
//				func(AdEnum.A4);
//			}
//			if (showFlag.hasOwnProperty(AdEnum.A5) && showFlag[AdEnum.A5]) {
//				func(AdEnum.A5);
//			}
//			//解析闪播数据
//			func(AdEnum.A6);
//			
//			packA2(o);
//			
//			re[AdEnum.A1] = o[AdEnum.A1];
//			re[AdEnum.A2] = getAd(AdEnum.A2, o);
//			re[AdEnum.A3] = getAd(AdEnum.A3, o);
//			re[AdEnum.A4] = getAd(AdEnum.A4, o);
//			re[AdEnum.A5] = getAd(AdEnum.A5, o);
//			re[AdEnum.A6] = o[AdEnum.A6];
//			
//			return re;
//		}
		
		public static function resolve(data:Object, showFlag:Object):Object {
			var o:Object = {};
			var re:Object = {};
			
			var func:Function = function (type:String):void {
				if (oldData.hasOwnProperty(type)) {
					var d:Object = oldData[type];
					if (validateData(d)) {
						o[type] = packAdData(type, d);
					}
				}
			};
			var oldData:Object = new Object();
			oldData[AdEnum.A1] = new Array(); 
			oldData[AdEnum.A2] = new Array();
			oldData[AdEnum.A3] = new Array();
			oldData[AdEnum.A4] = new Array();
			oldData[AdEnum.A5] = new Array();
			oldData[AdEnum.A6] = new Array();
			
			var newData:Object = new Object();
			newData = data["root"];
			if (newData == null) return null;
			
			/**
			 * 将新的格式重写成旧的格式
			 */
			for (var i:int = 0; i < (newData as Array).length; i++)
			{
				var chan:Object = new Object();
				chan = (newData as Array)[i]['chan'];
				if (chan.hasOwnProperty('custom'))
				{
					if (chan.hasOwnProperty('id'))
					{
						var id:int = chan['id'];
						var adItem:Object = new Object();
						adItem.m = 0;
						adItem.v = new Object();
						adItem.v.roundNum = 1;
						adItem.v.e = chan['custom']['e'];
						adItem.v.t = chan['custom']['t'];
						adItem.v.j = chan['custom']['j'];
						adItem.v.r = chan['custom']['r'];
						adItem.v.u = chan['custom']['u'];
						adItem.v.sc = chan['sc'];
						adItem.v.cc = chan['cc'];
						adItem.v.tsc = chan['trd']['u'];
						adItem.v.iu = chan['custom']["iu"];
						
						if ((chan['id'] == 74 || chan['id'] == 75 || chan['id'] == 67 || chan['id'] == 68))
						{
							oldData[AdEnum.A2].push(adItem);
						} 
						else if (chan['id']==73) {
							oldData[AdEnum.A1].push(adItem);
						}
						else if (chan['id']==76)
						{
							oldData[AdEnum.A3].push(adItem);
						}
						else if (chan['id']==78)
						{
							oldData[AdEnum.A4].push(adItem);
						}
						else if (chan['id']==77)
						{
							oldData[AdEnum.A5].push(adItem);
						}
						else if (chan['id']==61)
						{
							/**
							 * 在此添加闪播广告逻辑 
							 * todo
							 */
							oldData[AdEnum.A6].push(adItem);
						}
					}
				}
			}
			/**
			 * 在此进行数据处理
			 */
			if (showFlag.hasOwnProperty(AdEnum.A1) && showFlag[AdEnum.A1]) {
				func(AdEnum.A1);
			} else {
				o[AdEnum.A1] = new Array();
			}
			if (showFlag.hasOwnProperty(AdEnum.A2)) {
				if (Util.validateObj(showFlag[AdEnum.A2], "third")) {
					_canA2Third = true;
				}
				func(AdEnum.A2);
			}
			if (showFlag.hasOwnProperty(AdEnum.A3)) {
				if (Util.validateObj(showFlag[AdEnum.A3], "third")) {
					_canA3Third = true;
				}
				func(AdEnum.A3);
			}
			if (showFlag.hasOwnProperty(AdEnum.A4) && showFlag[AdEnum.A4]) {
				func(AdEnum.A4);
			}
			if (showFlag.hasOwnProperty(AdEnum.A5) && showFlag[AdEnum.A5]) {
				func(AdEnum.A5);
			}
			//解析闪播数据
			func(AdEnum.A6);
			
//			packA2(o);
			
			re[AdEnum.A1] = o[AdEnum.A1];
			re[AdEnum.A2] = getAd(AdEnum.A2, o);
			re[AdEnum.A3] = getAd(AdEnum.A3, o);
			re[AdEnum.A4] = getAd(AdEnum.A4, o);
			re[AdEnum.A5] = getAd(AdEnum.A5, o);
			re[AdEnum.A6] = o[AdEnum.A6];
			
			return re;
		}
		
		private static function validateData(a:Object):Boolean {
			for (var i:int=0;i<a.length;i++)
			{
				var item:Object = a[i];
				if (item.hasOwnProperty("v") && item['v'].hasOwnProperty('u'))
				{
				}
				else
				{
					return false;
				}
			}
			return true;
		}
		
		private static function packAdData(t:String, o:Object):Array {
			var ads:Array = [];
			
			//m字段暂时无效
			//			var m:int = o["m"];
			//判断是否前贴并且选曲第二组,当随机大于等于0.5的时候,选取第二组
			//			var willSkipFirst2:Boolean = t == AdEnum.A2 && Math.random() >= 0.5;
			for (var i:int = 0; i < o.length; i ++) {
				//如果是前贴并且随机到了第二组并且当前不是后两个,直接跳过
				//				if ((willSkipFirst2 && i < 2) || (!willSkipFirst2 && i >= 2)) {
				//					continue;
				//				}
				var item:Object = o[i]['v'];
				if (item == null) return null;
				if (!item.hasOwnProperty('u')) return null;
				//只有url有值才返回
				if (Util.validateStr(item["u"])) {
					var adData:AdData = new AdData();
					adData.extension = item["e"];
					adData.round = item["r"];
					adData.roundNum = item["roundNum"]
					adData.time = item["t"];
					adData.type = t;
					adData.url = item["u"];
					adData.jumpTo = item["j"];
					adData.cc = item["cc"];
					adData.sc = item["sc"];
					adData.tsc = item["tsc"];
					adData.disappearTime = item["t1"];
					adData.iframeUrl = item["iu"];
					if (item.hasOwnProperty("y")) {
						adData.yOffset = item["y"];
					}
					ads.push(adData);
				}
			}
			return ads;
		}
		
//		/**
//		 * 重新包装A2
//		 * @param value 已经封装好的广告数据
//		 */		
//		private static function packA2(value:Object):void {
//			return;
//			if (!value.hasOwnProperty(AdEnum.A1) || !value.hasOwnProperty(AdEnum.A2)){
//				return;
//			} else {
//				var temp:Array = value[AdEnum.A1];
//				if ((value[AdEnum.A1] as Array).length <= 0) {
//					//如果没有大前帖，前帖随机一个
//					if ((value[AdEnum.A2] as Array).length == 2) {
//						if (getLastShowFlag() == 1){
//							(value[AdEnum.A2] as Array).pop();
//							saveCurrentShowFlag(2);
//						} else {
//							(value[AdEnum.A2] as Array).shift();
//							saveCurrentShowFlag(1);
//						}
//					}
//				} else {
//					//如果有大前帖，并且两个前帖，删除第二个前帖
//					if ((value[AdEnum.A2] as Array).length > 1) {
//						(value[AdEnum.A2] as Array).pop();
//					}
//				}
//			}
//		}
		
		/**
		 * 获取当前应该显示那个前贴片
		 * @return 1：第一个 2：第二个
		 * 
		 */		
		public static function getLastShowFlag():int {
			if (!_cookie) {
				//初始化cookie
				_cookie = new Cookies("shared", "/");
			}
			var re:String = _cookie.get("adShowNum") as String;
			if (re) {
				return int(re);
			} else {
				return 1;
			}
		}
		
		public static function saveCurrentShowFlag(value:int):void {
			if (!_cookie) {
				//初始化cookie
				_cookie = new Cookies("shared", "/");
			}
			_cookie.put("adShowNum", value.toString());
			_cookie.flush(null, onFail);
			_cookie.close();
			_cookie = null;
		}
		
		private static function onFail():void {
			Debugger.log(Debugger.ERROR, "save adFlag failed!");
		}
		
		public static function getAd(type:String, obj:Object):IAdDisplay {
			var data:Array = obj[type];
			if (data == null || data.length == 0) return null;
			var dis:IAdDisplay = null;
			switch (type) {
				case AdEnum.A2:
					if (!_canA2Third) {
						var temp:Array = [];
						for (var i:int = 0; i < data.length; i++) {
							if ((data[i] as AdData).url != AD_TYPE_BAIDU) {
								temp.push(data[i]);
							}
						}
						data = temp;
						//解决如果广告配置解析将前贴的第一轮和第二轮数组位置放错的问题，正常情况下是不会出现这种情况
						if (data.length == 2 && data[0]["roundNum"] == 2) {
							var t:Array = [];
							t.push(data[1]);
							t.push(data[2]);
							data = t;
						}
					}
					if (data && data.length > 0) {
						dis = new AdA2();
						dis["canThird"] = _canA2Third;
					} else {
						dis = null;
					}
					break;
				case AdEnum.A3:
					if ((data[0] as AdData).url == AD_TYPE_BAIDU) {
						if (_canA3Third) {
							dis = new AdA3_baidu();
						} else {
							dis = null;
						}
					} else {
						dis = new AdA3();
					}
					break;
				case AdEnum.A4:
					if (Context.variables["type"] == "f3" || Context.variables["type"] == "f5" || Context.variables["type"] == "f6") {
						//直播站内、直播首页、直播站外
						dis = new StreamAdA4();
					} else {
						dis = new AdA4();
					}
					break;
				case AdEnum.A5:
					dis = new AdA5();
					break;
				
			}
			if (dis) {
				dis.data = data;
			}
			return dis;
		}
	}
}