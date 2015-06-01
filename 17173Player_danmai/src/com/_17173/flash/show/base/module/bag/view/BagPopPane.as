package com._17173.flash.show.base.module.bag.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * 背包弹窗基类
	 * @author yeah
	 */	
	public class BagPopPane extends Sprite
	{
		public function BagPopPane()
		{
			super();
		}
		
		/**
		 *添加关闭按钮
		 * @param $x
		 * @param $y
		 */		
		protected function addCloseBtn($x:int, $y:int):void
		{
			var btn:Button = new Button();
			btn.setSkin(new BagCloseBtn());
			btn.x = $x;
			btn. y = $y;
			btn.addEventListener(MouseEvent.CLICK, close);
			this.addChild(btn);
		}
		
		/**
		 *附加皮肤 
		 * @param $skin
		 * @param $pos
		 */		
		protected function attachSkin($skin:DisplayObject):void
		{
			this.addChildAt($skin, 0);
		}
		
		private var _isOpen:Boolean = false;
		
		/**
		 *打开状态 
		 * @return 
		 */		
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		
		
		/**
		 *打开面板 
		 */		
		public function open():void
		{
			if(_isOpen) return;
			_isOpen = true;
			(Context.getContext(CEnum.UI) as UIManager).popupAlertPanel(this);
		}
		
		/**
		 *关闭面板 
		 * @param event
		 */		
		public function close(event:MouseEvent = null):void
		{
			if(!_isOpen) return;
			_isOpen = false;
			(Context.getContext(CEnum.UI) as UIManager).removePanel(this);
		}
	}
}