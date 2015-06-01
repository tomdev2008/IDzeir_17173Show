package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.show.core.components.common.AslTextField;
	import com._17173.flash.show.core.components.common.ListItemRenderer;
	
	import flash.text.TextField;
	
	public class UserCardBaseActionListItemRenderer extends ListItemRenderer
	{
		
		public function UserCardBaseActionListItemRenderer()
		{
			super();
		}
		
		override public function startUp(value:Object):void {
			super.startUp(value);
			
			_label.text = value;
		}
		
		override protected function createTextField(data:Object):TextField {
			return new AslTextField(150);
		}
		
	}
}