package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.interfaces.IItemRender;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class ListItemRenderer extends Sprite implements IItemRender
	{
		
		protected var _label:TextField = null;
		protected var _selectDef:Shape;
		protected var _overBg:Shape;
		
		public function ListItemRenderer()
		{
			super();
		}
		
		public function onMouseOver():void
		{
			_overBg.width=_label.width;
			_overBg.height=_label.height;
			_overBg.visible=true;
		}
		
		public function onMouseOut():void
		{
			_overBg.visible=false;
		}
		
		public function onSelected():void
		{
			_selectDef.width=_label.width;
			_selectDef.height=_label.height;
			_selectDef.visible=true;
		}
		
		public function unSelected():void
		{
			_selectDef.visible=false;
		}
		
		public function startUp(value:Object):void
		{
			_label=createTextField(value);
			
			this.addChild(_label);
			
			_selectDef=new Shape();
			_selectDef.graphics.beginFill(0x567343,.8);
			_selectDef.graphics.drawRect(0,0,this.width,this.height);
			_selectDef.graphics.endFill();
			
			_overBg=new Shape();
			_overBg.graphics.beginFill(0xffffff,.3);
			_overBg.graphics.drawRect(0,0,this.width,this.height);
			_overBg.graphics.endFill();
			
			this.addChildAt(_selectDef,0);
			
			this.addChild(_overBg);
			
			_overBg.visible=false;
			_selectDef.visible=false;
		}
		
		/**
		 * 创建文本控件.
		 *  
		 * @param data
		 * @return 
		 */		
		protected function createTextField(data:Object):TextField {
			var l:Object = null;
			if (data is String) {
				l = {"label":data};
			} else if (data.hasOwnProperty("label")) {
				l = data;
			} else {
				l = {};
			}
			return new Label(l);
		}
		
	}
}