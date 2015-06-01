package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.Button;
	
	public class GiftTypeButton extends Button
	{
		public function GiftTypeButton(giftTypeInfo:Object)
		{
			typeInfo = giftTypeInfo;
			super("",true);
		}
		public var typeInfo:Object;
	}
}