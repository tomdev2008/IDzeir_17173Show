package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.ListItemRenderer;

	import flash.display.Shape;
	import flash.text.TextField;

	public class NumListItemRender extends ListItemRenderer
	{
		private var _bgs:Shape=null;
		private var _txtLabel:TextField;

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

		override public function startUp(value:Object):void
		{

			createText(value.num,value.txt)
			_selectDef=new Shape();
			_selectDef.graphics.beginFill(0x6F0673, 1);
			_selectDef.graphics.drawRect(0, 0, 120, _txtLabel.height);
			_selectDef.graphics.endFill();

			_overBg=new Shape();
			_overBg.graphics.beginFill(0x6F0673, 1);
			_overBg.graphics.drawRect(0, 0, 120, _txtLabel.height);
			_overBg.graphics.endFill();

			_bgs=new Shape();
			_bgs.graphics.beginFill(0x6F0673, .01);
			_bgs.graphics.drawRect(0, 0, 120, _txtLabel.height);
			_bgs.graphics.endFill();
			this.addChildAt(_bgs, 0);
			this.addChildAt(_selectDef, 1);
			this.addChild(_overBg);

			_overBg.visible=false;
			_selectDef.visible=false;

			this.addChild(_label);
			this.addChild(_txtLabel);
		}


		/**
		 *
		 * @param num
		 * @param txt
		 *
		 */
		private function createText(num:String, txt:String):void
		{
			_label=new Label();
			_label.htmlText="<font size='14'>"+num+"</font>";
			_label.x = 5;
			
			_txtLabel=new Label();
			_txtLabel.htmlText = "<font size='14'>"+txt+"</font>";
			_txtLabel.x = 120 - _txtLabel.textWidth-10;
			
		}
	}
}
