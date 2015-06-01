package com._17173.flash.show.base.module.centermessage
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class CenterMessageDelegate extends BaseModuleDelegate
	{
		protected var moduleLoaded:Boolean = false;
		protected var cacheMsg:Array = null;
		private var _giftArray:Array = [];
		public function CenterMessageDelegate()
		{
			super();
			cacheMsg = [];
			_e.listen(SEvents.CENTER_MESSAGE,function(value:Object):void{
				excute(addMessage,value);});
		}
		
		private function addMessage(data:Object):void{
				this.module.data = {"addMessage":[data]};
		}
	}
}