package com._17173.flash.player.context
{
	import com._17173.flash.core.util.PathUtil;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 广告路径解析类
	 *  
	 * @author 庆峰
	 */	
	public class AdPath
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
		 * 播放器类型 
		 */		
		private var _type:String = null;
		/**
		 * 是否debug状态 
		 */		
		private var _debug:Boolean = false;
		/**
		 * 解出的路径 
		 */		
		private var _resolvedPath:String = null;
		
		public function AdPath(type:String)
		{
			_type = type;
			_debug = _("debug");
			
			initDictionay();
			
			resolve();
		}
		
		/**
		 * 初始化类型与频道号的对应 
		 */		
		private function initDictionay():void {
			_cidDictionary = {};
			_cidDictionary[PlayerType.F_ZHANEI] = 1;
			_cidDictionary[PlayerType.F_ZHANWAI] = 2;
			_cidDictionary[PlayerType.F_CUSTOM] = 3;
			_cidDictionary[PlayerType.S_SHOUYE] = 6;
			_cidDictionary[PlayerType.S_ZHANNEI] = 4;
			_cidDictionary[PlayerType.S_CUSTOM] = 5;
			_cidDictionary[PlayerType.F_SEO_VIDEO] = 1;
			_cidDictionary[PlayerType.F_SEO_GAME] = 1;
			_cidDictionary[PlayerType.A_OUT] = 7;
			_cidDictionary[PlayerType.A_PAD] = 8;
		}
		
		/**
		 * 根据业务逻辑开始解析并得到最终路径 
		 */		
		private function resolve():void {
			var tmpPath:String = resolveDebug();
			if (!tmpPath) tmpPath = resolveCyly();
			if (!tmpPath) tmpPath = resolveDefault();
			
			_resolvedPath = tmpPath;
			Debugger.log(Debugger.INFO, "[ad]", "广告数据地址:" + _resolvedPath);
		}
		
		/**
		 * 是否测试广告
		 *  
		 * @return 
		 */		
		private function resolveDebug():String {
			if (_debug) {
				var adurl:String = _("adurl");
				if (adurl) {
					if (PathUtil.isHttp(adurl)) {
						return adurl;
					} else {
						return PathUtil.resolve(_("ref"), adurl);
					}
				} else {
					return AD_HAOYE_TEST_PATH + "&kv=cid|" + _cidDictionary[_type];
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
			return _("adType") == "cyly" ? _debug ? AD_CYLY_URL_T : AD_CYLY_URL : null;
		}
		
		/**
		 * 默认根据播放器类型选择广告路径并加上匹配的路径
		 *  
		 * @return 
		 */		
		private function resolveDefault():String {
			var cid:String = _cidDictionary[_type];
			var path:String = AD_HAOYE_PATH + "&kv=cid|" + cid;
//			path = "assets/new_video_ad.json";
			return path;
		}
		
		public function get currentPath():String {
			return _resolvedPath;
		}
		
	}
}