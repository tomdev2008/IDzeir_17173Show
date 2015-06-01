package com._17173.flash.player.ad_refactor
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.haoye.AdHaoyeParser;
	import com._17173.flash.player.ad_refactor.haoye.AdHaoyeProxy;
	import com._17173.flash.player.ad_refactor.interfaces.IAdController;
	import com._17173.flash.player.ad_refactor.interfaces.IAdDataParser;
	import com._17173.flash.player.ad_refactor.interfaces.IAdProxy;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.events.Event;
	
	/**
	 * 广告管理类.目前所有的投放都已经依赖于好耶的结构,但是也提供对其他可能形式的广告类型的扩展性.</br>
	 * </br>
	 * 实现三步时序:</br>
	 * 	1.获取原始广告数据;</br>
	 * 	2.根据原始数据进行根据返回结果分为正确或者错误;</br>
	 * 	3.正确或者错误的结果传递给业务逻辑处理,解析并分发成为各个广告对象或者错误面板. </br>
	 *  
	 * @author 庆峰
	 */	
	public class AdManager_refactor implements IContextItem
	{
		/**
		 * 版本号 
		 */		
		private static const VERSION:String = "1.0.31";
		
		/**
		 * 可替换的解析类.</br>
		 * 假如不再使用好耶提供的数据源,那么可以替换proxy对应的类,用来加载解析比如17173自己服务器的广告数据.</br>
		 * 假如想要在数据交换层(原始数据出来后提交到广告逻辑时)将数据做一次预处理,可以替换data所对应的类.</br>
		 * 假如想要实现不同于现在各个广告间的逻辑或者依赖关系,可以替换controller所对应的类.</br>
		 */		
		private static const CONFIG:Object = {
			"proxy": AdHaoyeProxy, 			// 广告数据源管理
			"parser": AdHaoyeParser, 		// 广告源数据处理和转换
			"controller": AdController		// 广告展现控制逻辑
		};
		private var _extraFilters:Array = null;
		
		/**
		 * 广告逻辑实例,因为可能会有中断重播的可能性,在这里保留引用,以便dispose 
		 */		
		protected var _controller:IAdController = null;
		
		public function AdManager_refactor() {
		}
		
		public function get contextName():String {
			return "adManager";
		}
		
		/**
		 * Context接口类,启动入口
		 *  
		 * @param param
		 */		
		public function startUp(param:Object):void {
			Debugger.log(Debugger.INFO, "[ad]", "版本号:" + VERSION);
			// 额外的过滤器
			_extraFilters = param as Array;
			// 等待通知进行加载
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_START_LOAD_AD_INFO, loadAdData);
		}
		
		/**
		 * 启动广告逻辑,开始加载原始数据 
		 */		
		protected function loadAdData(data:Object = null):void {
			var proxy:IAdProxy = new CONFIG["proxy"]();
			proxy.resolve(onAdDataLoaded, onAdDataError);
			// 输出实际路径
			Debugger.log(Debugger.INFO, "[ad]", "广告初始化: " + proxy.url);
		}
		
		/**
		 * 广告数据加载并解析
		 *  
		 * @param data
		 */		
		protected function onAdDataLoaded(data:Object):void {
			var parser:IAdDataParser = new CONFIG["parser"](_extraFilters);
			renderAd(parser.parse(data as Array));
		}
		
		/**
		 * 广告数据出现错误
		 *  
		 * @param error
		 */		
		private function onAdDataError(error:Object):void {
			renderAd(null);
		}
		
		/**
		 * 启动广告渲染逻辑
		 *  
		 * @param data
		 * @param error
		 */		
		protected function renderAd(data:Object):void {
			// 如果确定要展现了,并且逻辑已经初始化,则先释放
			if (_controller) _controller.dispose();
			// 启动广告逻辑
			if (!_controller) {
				_controller = new CONFIG["controller"]();
				
				_controller.addEventListener("complete", function (e:Event):void {
					Debugger.log(Debugger.INFO, "[ad]", "前贴片广告组播放完毕,启动视频播放逻辑！");
					// 通知广告结束
					_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_AD_COMPLETE);
				});
			}
			_controller.data = data;
			// 广告逻辑监控并反射为业务逻辑,目前因为播放器不可能有多套广告逻辑,所以业务单纯的都写在ecosystem里,不在admanager里做处理
//			_controller.addEventListener("")
		}
		
	}
}