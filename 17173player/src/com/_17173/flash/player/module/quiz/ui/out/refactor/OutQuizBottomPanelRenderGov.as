package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.core.components.common.Button;
	
	import flash.display.DisplayObject;

	/**
	 * 官方竞猜底栏
	 *  
	 * @author 庆峰
	 */	
	public class OutQuizBottomPanelRenderGov extends OutQuizBottomPanelRender
	{
		
		private var _l:DisplayObject = null;
		private var _btn:Button = null;
		
		public function OutQuizBottomPanelRenderGov(itemRender:Class)
		{
			super(itemRender);
			
			_l = new outquiz_line();
			addChild(_l);
			
			_btn = new Button();
			_btn.setSkin(new out_quiz_vote());
			addChild(_btn);
		}
		
		override protected function layoutItems():void {
			var tmp:int = 0;
			for (var i:int = 0; i < _items.numChildren; i ++) {
				var c:OutQuizBottomPanelRenderItem = _items.getChildAt(i) as OutQuizBottomPanelRenderItem;
				c.resize(_l.x - 5, _h);
				c.y = tmp;
				tmp += c.height + -3;
			}
		}
		
		override protected function layoutContainer():void {
			_items.x = 5;
			_btn.x = _w - _btn.width -5;
			_btn.y = (_h - _btn.height) / 2;
			_l.height = _h - 8;
			_l.x = _btn.x - _l.width - 5;
			_l.y = 4;
		}
		
	}
}