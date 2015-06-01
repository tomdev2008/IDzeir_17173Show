package com._17173.flash.show.base.module.leftbar
{
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.model.SEvents;
	
	public class LeftBarDelegate extends BaseModuleDelegate
	{
		public function LeftBarDelegate()
		{
			super();
			onLsn();
		}
		
		private function onLsn():void{
			_e.listen(SEvents.ADD_BOTTOM_BUTTON, function(value:Object):void{
				excute(onAddButton,value);});
			_e.listen(SEvents.ADD_ACTI_BUTTON, function(value:Object):void{
				excute(onAddButton1,value);});
			_e.listen(SEvents.REMOVE_BOTTOM_BUTTON, onRemoveButton);
		}
		
		private function onAddButton(data:Object):void{
			this.module.data = {"addButton": [data]};
		}
		
		private function onAddButton1(data:Object):void{
			this.module.data = {"addButton": [data,false]};
		}
		
		private function onRemoveButton(data:Object):void
		{
		}
	}
}