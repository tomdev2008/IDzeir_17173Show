package com._17173.flash.player.ad_refactor.haoye
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.ad_refactor.filter.AdDataBaiduFilter;
	import com._17173.flash.player.ad_refactor.filter.AdDataConfigFilter;
	import com._17173.flash.player.ad_refactor.filter.AdDataPlayerFilter;
	import com._17173.flash.player.ad_refactor.interfaces.IAdDataParser;
	import com._17173.flash.player.ad_refactor.interfaces.IAdFilter;
	
	/**
	 * 当前广告逻辑所使用的原始数据过滤器.把数据请求得来的原始数据处理为大前贴,前贴等这些逻辑所需要的数据形式和格式.
	 *  
	 * @author 庆峰
	 */	
	public class AdHaoyeParser implements IAdDataParser
	{
		
		/**
		 * 过滤器 
		 */		
		protected var _filters:Array = [
			new AdDataPlayerFilter(), 
			new AdDataBaiduFilter(), 
			new AdDataConfigFilter()
		];
		
		public function AdHaoyeParser(filters:Array) {
			if (filters) _filters = _filters.concat(filters);
		}
		
		/**
		 * 好耶会传过来一个数组,包含所有的广告组,由于前贴片组两轮需要做互斥处理,必须处理轮数问题,所以只能根据数组顺序提前判断前贴片类型,其余的广告位通过id判断即可.
		 *  
		 * @param data
		 * @return 
		 */		
		public function parse(data:Array):Object {
			var result:Object = {};
			var ad:Object = null;
			
			// 先处理前贴片组
			var d:Array = [];
			var q:Array = [];
			// 前面四个是前贴片或者大前贴
			// 前两个是大前贴
			ad = data[0].chan;
			d.push(createDaqiantie(ad));
			ad = data[1].chan;
			d.push(createDaqiantie(ad));
			result[AdType.DAQIANTIE] = d;
			// 接下来两个是前贴
			ad = data[2].chan;
			q.push(createQiantie(ad));
			ad = data[3].chan;
			q.push(createQiantie(ad));
			result[AdType.QIANTIE] = q;
			
			// 其他的广告用for循环来处理更方便
			var o:Object = null;
			for (var i:int = 4; i < data.length; i ++) {
				ad = data[i].chan;
				o = createZanting(ad);
				if (!o) o = createZantingBanner(ad);
				if (!o) o = createXiadi(ad);
				if (!o) o = createGuajiao(ad);
				if (!o) o = createShanbo(ad);
				if (o && o.ad) {
					result[o.type] = o.ad;
				}
			}
			
			return result;
		}
		
		protected function createDaqiantie(data:Object):Object {
			if (basicValidate(data) && 
				(data.id == "73" || data.id == "98" || 
					data.id == "66" || data.id == "99")) {
				return createAdData(AdType.DAQIANTIE, data);
			}
			return null;
		}
		
		protected function createQiantie(data:Object):Object {
			if (basicValidate(data) && 
				(data.id == "74" || data.id == "75" || 
					data.id == "67" || data.id == "68")) {
				return createAdData(AdType.QIANTIE, data);
			}
			return null;
		}
		
		protected function createZanting(data:Object):Object {
			if (basicValidate(data) && 
				data.id == "76" || data.id == "69") {
				return {"type":AdType.ZANTING, "ad":createAdData(AdType.ZANTING, data)};
			}
			return null;
		}
		
		protected function createZantingBanner(data:Object):Object {
			if (basicValidate(data) && 
				data.id == "97" || data.id == "101") {
				return {"type":AdType.ZANTING_BANNER, "ad":createAdData(AdType.ZANTING_BANNER, data)};
			}
			return null;
		}
		
		protected function createXiadi(data:Object):Object {
			if (basicValidate(data) && 
				data.id == "78" || data.id == "70") {
				return {"type":AdType.XIADI, "ad":createAdData(AdType.XIADI, data)};
			}
			return null;
		}
		
		protected function createGuajiao(data:Object):Object {
			if (basicValidate(data) && 
				data.id == "77" || data.id == "71") {
				return {"type":AdType.GUAJIAO, "ad":createAdData(AdType.GUAJIAO, data)};
			}
			return null;
		}
		
		protected function createShanbo(data:Object):Object {
			if (basicValidate(data) && 
				data.id == "61" || data.id == "87") {
				return {"type":AdType.SHANBO, "ad":createAdData(AdType.SHANBO, data)};
			}
			return null;
		}
		
		/**
		 * 通过原始数据创建AdData,这里会根据业务逻辑来决定是否创建addata.
		 *  
		 * @param type
		 * @param data
		 * @return 
		 */		
		protected function createAdData(type:String, data:Object):Object {
			var ad:AdData_refactor = new AdData_refactor();
			
			ad.id = data.id;
			ad.name = data.name;
			ad.type = type;
			ad.tsc = data.trd.u;
			ad.cc = formatUrl(data.cc);
			ad.sc = data.sc;
			
			var custom:Object = data.custom;
			ad.url = custom.hasOwnProperty("u") ? custom.u : null;
			ad.extension = custom.hasOwnProperty("e") ? custom.e : null;
			ad.time = custom.hasOwnProperty("t") ? custom.t : null;
			ad.jumpTo = custom.hasOwnProperty("j") ? custom.j : null;
			ad.iframeUrl = custom.hasOwnProperty("iu") ? custom.iu : null;
			ad.disappearTime = custom.hasOwnProperty("t1") ? custom.t1 : null;
			ad.round = custom.hasOwnProperty("r") ? custom.r : null;
			
			// 对广告数据进行业务过滤
			var filtered:Boolean = false;
			_filters.forEach(function (filter:IAdFilter, index:int, o:Array):void {
				filtered = filtered || filter.filter(ad);
			});
			
			if (filtered) {
				Debugger.log(Debugger.INFO, "[ad]", "广告位[" + type + "]被过滤!");
				return null;
			} else {
				return ad;
			}
		}
		
		/**
		 * 好耶点击统计最后一位可能是“=”播放器默认发出去会带上t参数，这样会发出错误的请求，所以需要格式化一下
		 * 格式化前：***&url=
		 * 格式化后：***&url&
		 */		
		protected function formatUrl(value:String):String {
			if (value.substr(-1, 1) == "=") {
				value = value.slice(0, value.length - 1);
				value = value + "&";
			}
			return value;
		}
		
		/**
		 * 判断节点数据是否有效
		 *  
		 * @param data
		 * @return 
		 */		
		protected function basicValidate(data:Object):Boolean {
			return data.hasOwnProperty("id") && data.hasOwnProperty("custom") && 
				data.custom && data.custom.hasOwnProperty("u") && data.custom["u"];
		}
		
	}
}