package com._17173.flash.show.base.init
{
	import com._17173.flash.show.base.init.base.BaseInit;
	import com._17173.flash.show.base.module.preloader.PreloaderDelegate;
	import com._17173.flash.show.model.PEnum;
	import com._17173.flash.show.model.SEvents;
	
	/**
	 * 初始化Preloader.
	 *  
	 * @author shunia-17173
	 */	
	public class InitPreloader extends BaseInit
	{
		
		public function InitPreloader()
		{
			super();
			
			_name = "Preloader";
			_weight = 20;
		}
		
		override public function enter():void {
			super.enter();
			//监听模块加载完的消息
			_e.listen(SEvents.FW_MODULE_LOADED, onLoadedCheck);
			//手动初始化PreloaderDelegate,以加载Preloader模块
			var preloader:PreloaderDelegate = new PreloaderDelegate();
			preloader.config = {"name":"./Preloader", "autoLoad":true, "autoAdd":false};
			preloader.load();
		}
		
		/**
		 * 加载完成回调.只有Preloader加载完成,才继续下一步.
		 *  
		 * @param data
		 */		
		private function onLoadedCheck(data:Object):void {
			if (data == PEnum.PRELOADER) {
				//如果Preloader加载完成
				//去除监听,并确认此步骤已完成.
				_e.remove(SEvents.FW_MODULE_LOADED, onLoadedCheck);
				//搞定
				complete();
			}
		}
		
	}
}