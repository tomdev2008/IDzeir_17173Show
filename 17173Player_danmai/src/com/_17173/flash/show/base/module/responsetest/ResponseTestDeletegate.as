package com._17173.flash.show.base.module.responsetest
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	
	public class ResponseTestDeletegate extends BaseModuleDelegate
	{
		public function ResponseTestDeletegate()
		{
			super();
			Debugger.log(Debugger.INFO, "[Response]", "加载响应测试模块");
		}
		
		override protected function  onModuleLoaded():void{
			super.onModuleLoaded();
			
		}
	}
}