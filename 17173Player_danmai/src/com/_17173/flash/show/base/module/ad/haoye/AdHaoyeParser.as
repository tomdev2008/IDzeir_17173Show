package com._17173.flash.show.base.module.ad.haoye
{
	import com._17173.flash.show.base.module.ad.base.AdShowData;
	import com._17173.flash.show.base.module.ad.base.AdType;
	import com._17173.flash.show.base.module.ad.interfaces.IAdDataParser;
	
	/**
	 * 当前广告逻辑所使用的原始数据过滤器.把数据请求得来的原始数据处理为大前贴,前贴等这些逻辑所需要的数据形式和格式.
	 *  
	 * @author 庆峰
	 */	
	public class AdHaoyeParser implements IAdDataParser
	{
		
		
		public function AdHaoyeParser() {
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
			var d:Array = [];
			var q:Array = [];
			ad = data[0].chan;
			result[AdType.SHOW_RIGHT] = createShow(ad);
			result[AdType.SHOW_RIGHT_B] = createShowB(ad);
			return result;
		}
		
		
		/**
		 * 通过原始数据创建AdData,这里会根据业务逻辑来决定是否创建addata.
		 *  
		 * @param type
		 * @param data
		 * @return 
		 */		
		protected function createAdData(type:String, data:Object):Object {
			var ad:AdShowData  = new AdShowData();
			
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
			return ad;
		}
		
		protected function createShow(data:Object):Object {
			if (basicValidate(data) && 
				(data.id == "110" || data.id == "109")) {
				return createAdData(AdType.SHOW_RIGHT, data);
			}
			return null;
		}
		
		
		protected function createShowB(data:Object):Object {
			if (basicValidate(data) && 
				(data.id == "170" || data.id == "171")) {
				return createAdData(AdType.SHOW_RIGHT_B, data);
			}
			return null;
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