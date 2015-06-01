package com._17173.flash.player.ad_refactor.haoye
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.PathUtil;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ad_refactor.interfaces.IAdProxy;

	/**
	 * 好耶广告数据加载.
	 *  
	 * @author 庆峰
	 */	
	public class AdHaoyeProxy implements IAdProxy
	{
		/**
		 * 畅游乐园
		 */
		public static const AD_CYLY_URL:String = "http://v.17173.com/uad/cyouu.json";
		/**
		 * 畅游乐园测试
		 */
		public static const AD_CYLY_URL_T:String = "http://v.17173.com/uad/cyouu-t.json";
		/**
		 * 默认广告路径 
		 */		
		private static const AD_HAOYE_PATH:String = "http://17173im.allyes.com/main/s?user=||17173_video&db=17173im&border=0&local=list&t=129";
		/**
		 * 默认广告测试路径 
		 */		
		private static const AD_HAOYE_TEST_PATH:String = "http://17173im.allyes.com/main/s?user=||17173_test_video&db=17173im&border=0&local=list&t=129";
		/**
		 * 频道字典,key是播放器类型,value是广告的渠道号,对应的是请求里的cid的值 
		 */		
		private static var _cidDictionary:Object = null;
		/**
		 * 当前广告加载路径 
		 */		
		protected var _resolvedPath:String = null;
		
		public function AdHaoyeProxy()
		{
			_cidDictionary = {};
			_cidDictionary[PlayerType.F_ZHANEI] = 1;
			_cidDictionary[PlayerType.F_SEO_VIDEO] = 1;
			_cidDictionary[PlayerType.F_SEO_GAME] = 1;
			_cidDictionary[PlayerType.F_ZHANWAI] = 2;
			_cidDictionary[PlayerType.F_CUSTOM] = 3;
			_cidDictionary[PlayerType.S_SHOUYE] = 6;
			_cidDictionary[PlayerType.S_ZHANNEI] = 4;
			_cidDictionary[PlayerType.S_CUSTOM] = 5;
			_cidDictionary[PlayerType.A_OUT] = 7;
			_cidDictionary[PlayerType.A_PAD] = 8;
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
					onComplete(data.root);
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
//			return "http://127.0.0.1:8080/test/ad.json"
//			return "http://v.17173.com/bd/vtest/json.html";//前贴两轮百度
//			return "http://17173im.allyes.com/main/s?user=||17173_video&db=17173im&border=0&local=list&t=129&kv=cid|1";
			// debug = 1
//			_("debug", 1);
			if (_("debug")) {
				// 取url中的adurl参数
				var adurl:String = _("adurl");
				if (adurl) {
					// 有参数且是http链接,则直接返回
					if (PathUtil.isHttp(adurl)) {
						return adurl;
					} else {
						// 如果是相对路径,则在当前播放器地址后面加上广告路径
						return PathUtil.resolve(_("ref"), adurl);
					}
				} else {
					// 如果没有adurl参数或者adurl参数为空,则直接走好耶的测试链接地址
					return AD_HAOYE_TEST_PATH + "&kv=cid|" + _cidDictionary[_("type")];
				}
			}
			return null;
		}
		
		/**
		 * 是否畅游乐园
		 *  
		 * @return 
		 */		
		private function resolveCyly():String {
			return _("adType") == "cyly" ? _("debug") ? AD_CYLY_URL_T : AD_CYLY_URL : null;
		}
		
		/**
		 * 默认根据播放器类型选择广告路径并加上匹配的路径
		 *  
		 * @return 
		 */		
		private function resolveDefault():String {
			var path:String = AD_HAOYE_PATH + "&kv=cid|" + _cidDictionary[_("type")];
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