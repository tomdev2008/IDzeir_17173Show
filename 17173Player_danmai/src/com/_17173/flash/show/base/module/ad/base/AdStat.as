package  com._17173.flash.show.base.module.ad.base
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.show.base.module.ad.base.AdShowData;

	public class AdStat
	{
		public function AdStat()
		{
		}
		
		/**
		 * 广告展示统计
		 *  
		 * @param ad
		 */		
		public static function show(ad:AdShowData):void {
			if (!ad) return;
			
			var u:Array = ad.tsc ? ad.tsc.concat(ad.sc) : [ad.sc];
			for each (var url:String in u) {
				if (url) {
					post(url);
				}
			}
		}
		
		/**
		 * 广告点击统计
		 *  
		 * @param ad
		 */		
		public static function click(ad:AdShowData):void {
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
		
	}
}