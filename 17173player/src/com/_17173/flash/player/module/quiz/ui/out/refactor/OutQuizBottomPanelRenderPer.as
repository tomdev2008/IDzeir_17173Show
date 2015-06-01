package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.player.module.quiz.data.DealerData;
	
	import flash.display.DisplayObject;
	
	/**
	 * 个人竞猜底栏
	 *  
	 * @author 庆峰
	 */	
	public class OutQuizBottomPanelRenderPer extends OutQuizBottomPanelRender
	{
		
		private var _vs:DisplayObject = null;
		
		public function OutQuizBottomPanelRenderPer(itemRender:Class)
		{
			super(itemRender);
			
			_vs = new out_quiz_vs();
			addChild(_vs);
		}
		
		override protected function createItems():void {
			var left:DealerData = _data.leftDealerData;
			var right:DealerData = _data.rightDealerData;
			
			var l:OutQuizBottomPanelRenderItem = new _renderClass(false) as OutQuizBottomPanelRenderItem;
			l.data = left;
			var r:OutQuizBottomPanelRenderItem = new _renderClass(true) as OutQuizBottomPanelRenderItem;
			r.data = right;
			_items.addChild(l);
			_items.addChild(r);
		}
		
		override protected function layoutItems():void {
			var l:OutQuizBottomPanelRenderItem = _items.getChildAt(0) as OutQuizBottomPanelRenderItem;
			var r:OutQuizBottomPanelRenderItem = _items.getChildAt(1) as OutQuizBottomPanelRenderItem;
			
			var w:Number = (_w - _vs.width - 10) / 2;
			l.resize(w, _h);
			l.x = 5;
			r.resize(w, _h);
			//r.x = _w/2;
			r.x = _w - r.width - 5;
		}
		
		override protected function layoutContainer():void {
			_vs.x = (_w - _vs.width) / 2 + 1;
			_items.x = 0;
			_items.y = (_h - _items.height) / 2;
			_vs.y = (_h - _vs.height) / 2 + 4;
		}
		
	}
}