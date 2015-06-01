package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Event(name="change_page", type="flash.events.Event")];
	public class GiftPageBar extends Sprite
	{
		
		public static const CHANGE_PAGE:String = "change_page";
		private var _currentPage:int = 0;
		private var _maxPage:int = 0;
		private var _pagebtns:Array;
		public function GiftPageBar()
		{
			super();
			_pagebtns = [];
		}
		
		public function get currentPage():int
		{
			return _currentPage;
		}

		public function set currentPage(value:int):void
		{
			(_pagebtns[_currentPage] as GiftPageButton).selected = false;
			_currentPage = value;
			if(_currentPage >= 0 && _currentPage < _pagebtns.length){
				
			}else{
				_currentPage = 0;
			}
			(_pagebtns[_currentPage] as GiftPageButton).selected = true;
		}

		public function updatePage(pageCount:int):void{
			_maxPage = pageCount;
			init();
		}
		
		private function init():void{
			clearBtns();
			if(_maxPage <= 0){
				return;
			}
			var button:GiftPageButton;
			var len:int = _maxPage;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			for (var i:int = 0; i < len; i++) 
			{
				button = new GiftPageButton(i);
				button.x = i * 18 ;
				button.y = 0;
				ui.registerTip(button,"切换礼物");
				button.addEventListener(MouseEvent.CLICK,onClick);
//				this.addChild(button);
				_pagebtns[_pagebtns.length] = button;
				
			}
			
//			(_pagebtns[0] as GiftPageButton).selected = true;
		}
		
		protected function onClick(event:MouseEvent):void
		{
			var btn:GiftPageButton = event.currentTarget as GiftPageButton;
			var tmpIdx:int = btn.pageIdx;
			if(tmpIdx != _currentPage){
				(_pagebtns[_currentPage] as GiftPageButton).selected = false;
				btn.selected = true;
				_currentPage = tmpIdx;
				this.dispatchEvent(new Event(CHANGE_PAGE));
			}
		}
		
		private function clearBtns():void{
			var len:int = _pagebtns.length;
			var btn:GiftPageButton;
			for (var i:int = 0; i < len; i++) 
			{
				btn = _pagebtns[i] as GiftPageButton;
				if(btn && btn.parent){
					btn.parent.removeChild(btn);
				}
			}
			_pagebtns = [];
		}
		
	}
}