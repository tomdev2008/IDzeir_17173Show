package com._17173.flash.show.base.components.common.plugbutton
{
	import com._17173.flash.core.components.common.Button;

	/**
	 *注入的按钮 
	 * @author zhaoqinghao
	 * 
	 */	
	public class PlugButton extends Button
	{
		private var _eType:String = null;
		private var _order:int = 99;
		/**
		 *注入左边栏的按钮 
		 * @param eventType  按钮触发事件
		 * @param label 按钮label
		 * @param btnOrder 按钮排序
		 * @param isSelect 是否可以选中
		 * 
		 */		
		public function PlugButton(eventType:String,label:String = "",btnOrder:int = -1,isSelect:Boolean = false)
		{
			_order = btnOrder;
			_eType = eventType;
			super(label,isSelect);
		}
		
//		override protected function onShow():void{
//			super.onShow();
//			this.addEventListener(MouseEvent.CLICK,onClick);
//		}
//		
//		override protected function onHide():void{
//			super.onHide();
//			this.removeEventListener(MouseEvent.CLICK,onClick);
//		}

		
//		private function onClick(e:Event):void{
//			Context.getContext(CEnum.EVENT).send(_eType,this);
//		}

		public function get eType():String
		{
			return _eType;
		}

		public function set eType(value:String):void
		{
			_eType = value;
		}

		public function get order():int
		{
			return _order;
		}

		public function set order(value:int):void
		{
			_order = value;
		}

	}
}