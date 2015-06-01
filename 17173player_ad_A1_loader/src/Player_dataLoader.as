package
{
	import com.AdData;
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.debug.DebuggerOutput_console;
	
	import flash.system.Security;
	
	public class Player_dataLoader extends StageIniator
	{
		private var domainName:String = null;
		private var url:String = "http://17173im.allyes.com/main/s?user=||17173_video&db=17173im&border=0&local=list&t=129&kv=cid|2";
		
		public function Player_dataLoader()
		{
			super(true);
		}
		
		override protected function init():void {
//			url = "http://10.6.212.172/newAd16.json";
			super.init();
			var version:String = "0.0.1";
			
			Security.allowDomain("*");
			
			Debugger.source = "扩展前贴数据加载器";
			Debugger.output = new DebuggerOutput_console();
			
			Debugger.log(Debugger.INFO, "版本: " + version);
			
			
			domainName = checkCanShowDaQianTie();
			if (!domainName || domainName == "") {
				Debugger.log(Debugger.INFO, "[扩展前贴数据加载器]未获取到指定参数无法播放");
				noAD();
			} else {
				loadAdData(url, onSuccess, error);
			}
		}
		
		private function noAD():void {
			JSBridge.addCall("onEndA1", null, domainName);
		}
		
		private function onSuccess(data:Object):void {
			Debugger.log(Debugger.INFO, "[扩展前贴数据加载器]开始解析数据");
			var v:Array = parse(data["root"] as Array);
			
			if (v && v.length > 0) {
				var i:int = v.length - 1;
				var t:int = 0;
				var ad:AdData = null;
				for (i; i >= 0; i --) {
					ad = v[i];
					t += ad.time;
					ad.totalTime = t;
				}
				JSBridge.addCall("onStartA1", v, domainName);
			} else {
				Debugger.log(Debugger.INFO, "[扩展前贴数据加载器]数据中没找到可用数据");
				noAD();
			}
		}
		
		private function error(data:Object):void {
			Debugger.log(Debugger.INFO, "[扩展前贴数据加载器]获取到错误数据");
			noAD();
		}
		
		/**
		 * 判断是否有大前贴播放器
		 * 供点播站外播放器播放大前贴使用
		 */		
		private function checkCanShowDaQianTie():String {
			var re:String = null;
			if (stage.loaderInfo.parameters.hasOwnProperty("guid") && stage.loaderInfo.parameters["guid"] != "") {
				re = stage.loaderInfo.parameters["guid"];
			}
			return re;
		}
		
		private function loadAdData(url:String, complete:Function, error:Function):void {
			var loader:LoaderProxy = new LoaderProxy();
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = url;
			option.onSuccess = complete;
			option.onFault = error;
			option.type = LoaderProxyOption.TYPE_FILE_LOADER;
			option.format = LoaderProxyOption.FORMAT_JSON;
			loader.load(option);
		}
		
		private function parse(data:Array):Array {
			var result:Array = [];
			var ad:Object = null;
			
			// 前两个是大前贴
			ad = data[0].chan;
			var temp:Object = createDaqiantie(ad);
			if (temp) {
				result.push(temp);
			}
			
			ad = data[1].chan;
			temp = createDaqiantie(ad);
			if (temp) {
				result.push(temp);
			}
			
			if (result.length > 0) {
				return result;
			} else {
				return null;
			}
		}
		
		protected function createDaqiantie(data:Object):Object {
			if (basicValidate(data) && 
				(data.id == "73" || data.id == "98" || 
					data.id == "66" || data.id == "99")) {
				return createAdData("da_qian_tie", data);
			}
			return null;
		}
		
		/**
		 * 判断节点数据是否有效
		 *  
		 * @param data
		 * @return 
		 */		
		protected function basicValidate(data:Object):Boolean {
			var a:Boolean = data.custom["u"] != "";
			return data.hasOwnProperty("id") && data.hasOwnProperty("custom") && 
				data.custom && data.custom.hasOwnProperty("u") && data.custom["u"] && data.custom["u"] != "";
		}
		
		protected function createAdData(type:String, data:Object):Object {
			var ad:AdData = new AdData();
			
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
			
			return ad;
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
		
	}
}