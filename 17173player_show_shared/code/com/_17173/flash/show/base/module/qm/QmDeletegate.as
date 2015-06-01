package com._17173.flash.show.base.module.qm
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class QmDeletegate extends BaseModuleDelegate
	{
		public function QmDeletegate()
		{
			super();
			Debugger.log(Debugger.INFO, "[QM]", "加载质量模块");
		}
		
		
		override protected function  onModuleLoaded():void{
			super.onModuleLoaded();
			//派发进入房间
			_e.send(SEvents.SEND_QM,{"id":"fpv"});
		}
		
	}
}