package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	/**
	 * 大前贴逻辑代理
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_daqiantie extends BaseAdDelegate
	{
		private var _ns:String = null;
		
		public function AdDelegate_daqiantie()
		{
		}
		
		override protected function init():void {
			Debugger.log(Debugger.INFO, "[ad]", "扩展前贴初始化");
			// 有大前贴则等待js返回大前贴结果
			_(ContextEnum.JS_DELEGATE).listen("onAdA1Begin", onDaqiantieBegin);
			_(ContextEnum.JS_DELEGATE).listen("onA1Complete", onDaqiantieComplete);
			// 向js发送大前贴数据,弹出大前贴层
			_(ContextEnum.JS_DELEGATE).send("onStartA1", _data, ns);
		}
		
		/**
		 * 大前贴开始播放 
		 */		
		protected function onDaqiantieBegin():void {
			// 发送事件隐藏各种元素
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.ADA1_BEGIN);
		}
		
		/**
		 * 大前贴结束 
		 */		
		protected function onDaqiantieComplete():void {
			complete(null);
		}

		/**
		 * 点播站内大前贴需要的domain
		 */		
		public function get ns():String
		{
			return _ns;
		}

		public function set ns(value:String):void
		{
			_ns = value;
		}

		
	}
}