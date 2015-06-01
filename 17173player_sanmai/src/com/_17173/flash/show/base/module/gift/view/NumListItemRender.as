package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.ListItemRenderer;
	
	import flash.display.Shape;

	public class NumListItemRender extends ListItemRenderer
	{
		private var _bgs:Shape = null;
		public function NumListItemRender()
		{
			super();
		}
		
		override public function onMouseOver():void
		{
			_overBg.visible=true;
		}
		
		override public function onMouseOut():void
		{
			_overBg.visible=false;
		}
		
		override public function onSelected():void
		{
			_selectDef.visible=false;
		}
		
		override public function startUp(value:Object):void{
			_label=createTextField(value);
			
			this.addChild(_label);
			
			_selectDef=new Shape();
			_selectDef.graphics.beginFill(0x567343,.8);
			_selectDef.graphics.drawRect(0,0,40,this.height);
			_selectDef.graphics.endFill();
			
			_overBg=new Shape();
			_overBg.graphics.beginFill(0xffffff,.3);
			_overBg.graphics.drawRect(0,0,40,this.height);
			_overBg.graphics.endFill();
			
			_bgs = new Shape();
			_bgs.graphics.beginFill(0x2F025F,.8);
			_bgs.graphics.drawRect(0,0,40,this.height);
			_bgs.graphics.endFill();
			this.addChildAt(_bgs,0);
			this.addChildAt(_selectDef,1);
			this.addChild(_overBg);
			
			_overBg.visible=false;
			_selectDef.visible=false;
			
		}
	}
}