package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.player.ad_refactor.interfaces.IAdData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;

	public class AdStat
	{
		public static var lastAdID:String = "";
		
		public function AdStat()
		{
		}
		
		/**
		 * 广告展示统计
		 *  
		 * @param ad
		 */		
		public static function show(ad:IAdData):void {
			if (!ad) return;
			
			showToBI(ad);
			var u:Array = ad.tsc ? ad.tsc.concat(ad.sc) : [ad.sc];
			for each (var url:String in u) {
				if (url && !isReplay(ad.id)) {
					post(url);
				}
			}
			lastAdID = ad.id;
		}
		
		/**
		 * 广告点击统计
		 *  
		 * @param ad
		 */		
		public static function click(ad:IAdData):void {
			if (ad && ad.cc) {
				post(ad.cc);
			}
		}
		
		private static function post(url:String):void {
			var l:LoaderProxy = new LoaderProxy();
			var o:LoaderProxyOption = new LoaderProxyOption();
			o.url = url;
			l.load(o);
		}
		
		
		/**
		 * 将统计发给bi
		 */		
		private static function showToBI(ad:IAdData):void {
			var adFlag:String = "";
			//防止显示百度广告的时候好耶的展示统计跟bi的不一样
			if (!ad.cc || ad.cc == "") {
				return;
			}
			switch (ad.id) {
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
				case "76":
					//暂停
					adFlag = "5";
					break;
				case "77":
					//挂角
					adFlag = "6";
					break;
				case "78":
					//下底
					adFlag = "7";
					break;
				case "97":
					//暂停横幅
					adFlag = "9";
					break;
				
			}
			if (adFlag != "") {
				var obj:Object = {};
				obj["ads_code"] = adFlag;
				obj["is_replay"] = isReplay(ad.id) ? "1" : "0";
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_AD_SHOW, obj);
			}
		}
		
		/**
		 * 大前贴和前贴可能会出现视频素材达不到实际配置的秒数,所以会出现自动轮播的情况,因此在统计的时候会做一个区分
		 * @param id  广告id
		 */		
		private static function isReplay(id:String):Boolean {
			if (id == "73" || id == "98" || id == "74" || id == "75") {
				if (lastAdID == id) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}
		
	}
}