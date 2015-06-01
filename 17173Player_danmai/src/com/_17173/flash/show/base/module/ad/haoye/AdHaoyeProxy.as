package  com._17173.flash.show.base.module.ad.haoye
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.PathUtil;
	import com._17173.flash.show.base.module.ad.interfaces.IAdProxy;
	import com._17173.flash.show.model.SEnum;

	/**
	 * 好耶广告数据加载.
	 *  
	 * @author 庆峰
	 */	
	public class AdHaoyeProxy implements IAdProxy
	{
		/**
		 * 默认广告路径 
		 */		
		public var  AD_HAOYE_PATH:String = "http://17173im.allyes.com/main/s?user=0001|media_v|showicastv1&db=17173im&border=0&local=yes&t=128";
													 
		/**
		 * 默认广告测试路径 
		 */		
		public var AD_HAOYE_TEST_PATH:String = "http://17173im.allyes.com/main/s?user=0001|media_v|showicast_test&db=17173im&border=0&local=yes&t=128";
		/**
		 * 频道字典,key是播放器类型,value是广告的渠道号,对应的是请求里的cid的值 
		 */		
		private static var _cidDictionary:Object = null;
		
		private static var _type:String = "9";
		/**
		 * 当前广告加载路径 
		 */		
		protected var _resolvedPath:String = null;
		
		public function AdHaoyeProxy()
		{
			_cidDictionary = {};
		}
		
		public function get url():String {
			return _resolvedPath;
		}
		
		public function resolve(onComplete:Function, onError:Function):void {
			// 是否使用了好耶广告测试链接
			var tmpPath:String = resolveDebug();
			// 是否是畅游乐园
//			if (!tmpPath) tmpPath = resolveCyly();
			// 正常解析好耶广告
			if (!tmpPath) tmpPath = resolveDefault();
			// 得出最终的链接
			_resolvedPath = tmpPath;
			if (_resolvedPath) {
				loadAdData(_resolvedPath, function (data:Object):void {
					data=="-1"||onComplete(data.root);
				}, function (error:Object):void {
					onError(error);
				});
			} else {
				onError(_resolvedPath);
			}
		}
		
		/**
		 * 是否测试广告
		 *  
		 * @return 
		 */		
		private function resolveDebug():String {
//			return null;
//			return "http://10.6.212.172/newAd16.json";
			// debug = 1
			if (Context.variables["debug"]) {
				// 取url中的adurl参数
				var adurl:String = "";
				if (adurl) {
					// 有参数且是http链接,则直接返回
					if (PathUtil.isHttp(adurl)) {
						return adurl;
					} else {
						// 如果是相对路径,则在当前播放器地址后面加上广告路径
						return PathUtil.resolve(SEnum.domain, adurl);
					}
				} else {
					// 如果没有adurl参数或者adurl参数为空,则直接走好耶的测试链接地址
					return AD_HAOYE_TEST_PATH + "&kv=cid|" + _type;
				}
			}
			return null;
		}
		
		/**
		 * 默认根据播放器类型选择广告路径并加上匹配的路径
		 *  
		 * @return 
		 */		
		private function resolveDefault():String {
			var path:String = AD_HAOYE_PATH + "&kv=cid|" + _type;
			return path;
		}
		
		/**
		* 加载好耶广告数据,返回的是json
		*  
		* @param url
		* @param complete
		* @param error
		*/		
		protected function loadAdData(url:String, complete:Function, error:Function):void {
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.onSuccess = complete;
			option.onFault = error;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.format = LoaderProxyOption.FORMAT_JSON;
			loader.load(option);
		}
	}
}