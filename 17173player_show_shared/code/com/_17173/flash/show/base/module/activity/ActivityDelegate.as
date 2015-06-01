package com._17173.flash.show.base.module.activity
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class ActivityDelegate extends BaseModuleDelegate
	{
		public function ActivityDelegate()
		{
			super();
			initLsn();
			_e.send(SEvents.ACT_SHOW,{type:ActivityType.ZQJ_JSJ});
		}
		
		private function initLsn():void{
			_e.listen(SEvents.ACT_SHOW,function(value:Object):void{
				excute(addAct,value);});
		}
		
		private function addAct(data:Object):void{
			_swf["addItem"](data);
		}
	}
}