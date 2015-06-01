package com._17173.flash.core.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Console;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.debug.DebuggerOutput_default;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	/**
	 * 基础入口类.应作为入口类的基类进行使用.
	 * 负责监听舞台初始化,和js可用性检测.
	 *  
	 * @author shunia-17173
	 */	
	public class StageIniator extends Sprite
	{
		
		/**
		 * 是否检测基础的js可用性 
		 */		
		protected var _allowJSCheck:Boolean = false;
		/**
		 * 逝去的时间 
		 */		
		private var _ellapsedTime:int = 0;
		/**
		 * 基准时间 
		 */		
		private var _baseTime:int = 0;
		
		public function StageIniator(allowJSCheck:Boolean = true)
		{
			_allowJSCheck = allowJSCheck;
			//检测舞台
			if (stage) {
				stageInited();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
		}
		
		/**
		 * 舞台已初始化.
		 *  
		 * @param e
		 */		
		final private function stageInited(e:Event = null):void {
			if (hasEventListener(Event.ADDED_TO_STAGE)) {
				removeEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//预初始化框架
			preInit();
			
			Ticker.tick(200, function ():void {
				//页面加载完成检查
				if (_allowJSCheck) {
					if (ExternalInterface.available == false) {
						//等待js可调用
						var retry:int = 10;
						var interval:uint = setInterval(function ():void {
							clearInterval(interval);
							retry --;
							if (ExternalInterface.available) {
								init();
							} else if (retry == 0) {
								onInitError("JS not avaliable!");
								onInit();
							}
						}, 200);
					} else {
						onInit();
					}
				} else {
					onInit();
				}
			});
		}
		
		protected function onInit():void {
			//全局ref设置,用于指定flash文件的目录
			var ref:String = stage.loaderInfo.loaderURL;
			ref = ref.split("?")[0];
			Context.variables["ref"] = Util.validateStr(ref) ? ref.substring(0, ref.lastIndexOf("/")) : "";
			//url参数获取
			var pageURL:String = Util.refPage;
			var params:Object = Util.parseURLParams(pageURL);
			for (var key:String in params) {
				if (acceptablURLParamsKey.indexOf(key) != -1) {
					Context.variables[key] = params[key];
				}
			}
			Context.variables["debug"] = Context.variables["debug"] == 1;
			init();
		}
		
		/**
		 * 可选列表,用于指示能被接受的url参数
		 *  
		 * @return 
		 */		
		protected function get acceptablURLParamsKey():Array {
			return ["debug"];
		}
		
		private function preInit():void {
			//设置上下文的stage
			Context.stage = stage;
			//计时器启动
			Ticker.init(stage);
			//把flashvars先写入
			try {
				Util.cloneTo(stage.loaderInfo.parameters, Context.variables);
				
			} catch (e:Error) {
				
			}
			//注册基础的管理器
			Context.regContext(EventManager.CONTEXT_NAME, EventManager);
			//控制台输出
			Debugger.output = new DebuggerOutput_default();
			//刷新
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		/**
		 * 启动计时器.
		 *  
		 * @param e
		 */		
		private function onEnterFrame(e:Event):void {
			var t:int = getTimer();
			_ellapsedTime = t - _baseTime;
			_baseTime = t;
		}
		
		/**
		 * 初始化方法. 
		 * 开始初始化业务逻辑.
		 */		
		protected function init():void {
			//override
		}
		
		protected function onInitError(error:String):void {
			trace("StageIniiator onInitError:" + error);
		}
		
	}
}