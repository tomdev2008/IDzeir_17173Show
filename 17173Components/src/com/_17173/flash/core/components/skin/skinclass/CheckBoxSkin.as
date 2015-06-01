package com._17173.flash.core.components.skin.skinclass
{
	import com._17173.flash.core.components.common.CheckBox;
	import com._17173.flash.core.components.interfaces.ISkinComponent;
	import com._17173.flash.core.components.skin.SkinType;
	
	import flash.geom.Rectangle;
	
	public class CheckBoxSkin extends ButtonSkin
	{
		public function CheckBoxSkin(skinCpnt:ISkinComponent)
		{
			super(SkinType.SKIN_TYPE_CHECKBOX,skinCpnt);
		}
		
		override public function resize():void
		{
			var base:CheckBox = skinComponent as CheckBox;
			(base).boxPostion(new Rectangle(0,0,btnMc.width,base.height));
			btnMc.y = ((base).height - btnMc.height)/2;
		}
		
		public function iconWidth():int{
			return btnMc.width;
		}
	}
}