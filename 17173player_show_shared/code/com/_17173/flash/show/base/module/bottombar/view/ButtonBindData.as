package com._17173.flash.show.base.module.bottombar.view
{
	import flash.display.DisplayObject;
	/**
	 *低栏按钮数据 
	 * @author zhaoqinghao
	 * 
	 */
	public class ButtonBindData
	{
		
		private var _type:String = null;
		private var _label:String = null;
		private var _icon:DisplayObject = null;
		private var _select:Boolean = false;
		private var _order:int = 0;
		private var _btnWidth:int = 87;
		private var _btnHeight:int = 30;
		/**
		 *  设置按钮简单数据
		 * @param clickEventType 点击按钮后发出事件
		 * @param titleStr 按钮label
		 * @param isSelect 可选中按钮
		 * @param showIcon 按钮显示图片,如显示图片请将titleStr传空字符串;
		 * 
		 */		
		public function ButtonBindData(clickEventType:String,labelStr:String = "",buttonOrder:int = -1,isSelect:Boolean = false,showIcon:DisplayObject = null)
		{
			_type = clickEventType;
			_label = labelStr;
			_icon = showIcon;
			_order  = buttonOrder;
			_select = isSelect;
		}
		
		public function get order():int
		{
			return _order;
		}

		public function set order(value:int):void
		{
			_order = value;
		}

		public function get btnHeight():int
		{
			return _btnHeight;
		}

		public function set btnHeight(value:int):void
		{
			if(value < 20) return;
			_btnHeight = value;
		}

		public function get btnWidth():int
		{
			return _btnWidth;
		}

		public function set btnWidth(value:int):void
		{
			if(value < 20) return;
			_btnWidth = value;
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			_select = value;
		}

		public function get icon():DisplayObject
		{
			return _icon;
		}

		public function set icon(value:DisplayObject):void
		{
			_icon = value;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

	}
}