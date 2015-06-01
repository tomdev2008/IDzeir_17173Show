package com._17173.flash.show.base.module.userCard
{
	import com._17173.flash.core.components.common.ListItemRenderer;
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.Shape;
	import flash.text.TextFormat;
	
	public class UserCardListItemRenderer extends ListItemRenderer
	{
		private var defualtFormat:TextFormat = FontUtil.DEFAULT_FORMAT;
		private var selectFormat:TextFormat = new TextFormat();
		
		public function UserCardListItemRenderer()
		{
			super();
			defualtFormat.color = "0xCCCCCC";//FontUtil.FONT_COLOR_BLUE1;
			defualtFormat.size = 12;
			defualtFormat.bold = false;
			
			selectFormat.color = "0xDE0086";//FontUtil.FONT_COLOR_VIOLET;
			selectFormat.bold = false;
		}
		
		override public function onMouseOver():void
		{
//			_overBg.width = 158;
			_overBg.height = height;
			_overBg.graphics.clear();
			_overBg.graphics.beginFill(0x4B0059);
			_overBg.graphics.drawRect(-9,0,this.width + 26,this.height);
			_overBg.graphics.endFill();
			_overBg.visible = true;
			_label.setTextFormat(selectFormat);
		}
		
		override public function onMouseOut():void
		{
			super.onMouseOut();
			_label.setTextFormat(defualtFormat);
		}
		
		override public function startUp(value:Object):void
		{
			_label = createTextField(value);
			
			_label.defaultTextFormat = defualtFormat;
			_label.setTextFormat(defualtFormat);
			this.addChild(_label);
			
			_selectDef=new Shape();
			_selectDef.graphics.beginFill(0x567343,.8);
			_selectDef.graphics.drawRect(0,0,this.width,25);
			_selectDef.graphics.endFill();
			
			_overBg=new Shape();
			_overBg.graphics.beginFill(0xffffff,.3);
			_overBg.graphics.drawRect(0,0,this.width,25);
			_overBg.graphics.endFill();
			
			this.addChildAt(_selectDef,0);
			
			this.addChild(_overBg);
			
			this.setChildIndex(_label,this.numChildren-1);
			_overBg.visible=false;
			_selectDef.visible=false;
			_label.y = (25 - _label.height) / 2;
		}
	}
}