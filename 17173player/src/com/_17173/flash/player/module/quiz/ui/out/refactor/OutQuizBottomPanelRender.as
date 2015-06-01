package com._17173.flash.player.module.quiz.ui.out.refactor
{
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.data.QuizData;
	
	import flash.display.Sprite;
	
	public class OutQuizBottomPanelRender extends Sprite
	{
		
		protected var _data:QuizData = null;
		protected var _renderClass:Class = null;
		protected var _items:Sprite = null;
		
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		public function OutQuizBottomPanelRender(itemRender:Class)
		{
			super();
			_renderClass = itemRender;
			_items = new Sprite();
			addChild(_items);
		}
		
		public function set data(value:QuizData):void {
			_data = value;
			
			while (_items.numChildren > 0) {
				_items.removeChildAt(0);
			}
			
			createItems();
			
			layoutItems();
		}
		
		protected function createItems():void {
			for each (var d:DealerData in _data.dealders) {
				var dis:OutQuizBottomPanelRenderItem = new _renderClass() as OutQuizBottomPanelRenderItem;
				dis.data = d;
				_items.addChild(dis);
			}
		}
		
		protected function layoutItems():void {
			
		}
		
		protected function layoutContainer():void {
			
		}
		
		public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
			
			layoutContainer();
			layoutItems();
		}
		
	}
}