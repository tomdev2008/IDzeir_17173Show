package com._17173.flash.show.base.module.seat
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class SeatAreaDelegate extends BaseModuleDelegate
	{
		public function SeatAreaDelegate()
		{
			super();
			_e.listen(SEvents.NORMAL_GIFT_MESSAGE,function(value:Object):void{
				excute(onMsg,value);});
		}
		
		private function onMsg(data:Object):void{
			_swf["addMessage"](data);
		}
		
	}
}