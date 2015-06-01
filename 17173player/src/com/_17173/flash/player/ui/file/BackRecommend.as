package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.comps.backRecommend.BackRecBottomBar;
	import com._17173.flash.player.ui.comps.backRecommend.BackRecCenter;
	import com._17173.flash.player.ui.comps.backRecommend.BackRecTopBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BackRecommend extends Sprite
	{
		private var _bg:Sprite = null;
		protected var _topbar:BackRecTopBar = null;
		private var _centerbar:BackRecCenter = null;
		protected var _bottompBar:BackRecBottomBar = null;
		private var _moreInfo:Array;
		private var _currentPage:int = 1;
		private var _totalPage:int = 1;
		private var _canShowNum:int = 1;
		private var _thisWidth:Number = 0;
		private var _thisHeight:Number = 0;
		
		public function BackRecommend(width:Number, height:Number)
		{
			super();
			
			this._thisHeight = height;
			this._thisWidth = width;
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,0);
//			_bg.graphics.beginFill(0xff00ff);
			_bg.graphics.drawRect(0, 0, width, height);
			_bg.graphics.endFill();
			addChild(_bg);
			
			addTopBar();
			
			addBottomBar();
			
			addCenter();
			init();
			resize();
		}
		
		protected function addTopBar():void {
			_topbar = new BackRecTopBar(width);
			_topbar.resize();
			addChild(_topbar);
		}
		
		protected function addBottomBar():void {
			_bottompBar = new BackRecBottomBar(width);
			addChild(_bottompBar);
		}
		
		protected function addCenter():void
		{
			_centerbar = new BackRecCenter(_thisWidth, _thisHeight - (_topbar ? _topbar.height : 0) - _bottompBar.height);
			addChild(_centerbar);
		}
		
		private function init():void
		{
			_bottompBar.addEventListener("leftEvent", leftHandler);
			_bottompBar.addEventListener("rightEvent", rightHandler);
		}
		
		private function leftHandler(evt:Event):void
		{
			_currentPage --;
			if(_currentPage <= 0)
			{
				_currentPage = _totalPage;
			}
			changePage();
		}
		
		private function rightHandler(evt:Event):void
		{
			_currentPage ++;
			if(_currentPage > _totalPage)
			{
				_currentPage = 1;
			}
			changePage();
		}
		
		public function setMoreInfo(moreInfo:Array, moreLabel:String, moreUrl:String):void
		{
			_moreInfo = moreInfo;
			if (_topbar) {
				_topbar.setInfo(((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data as FileVideoData).title, moreLabel, moreUrl);
			}
			initPage();
			changePage();
		}
		
		protected function initPage():void
		{
			_canShowNum = _centerbar.getTotalNum(_moreInfo.length);
			_totalPage = Math.ceil(_moreInfo.length / _canShowNum);
		}
		
		protected function changePage():void
		{
			this.removeChild(_centerbar);
			addCenter();
			initPage();
			resize();
			var startNum:int = _canShowNum * (_currentPage - 1);
			var tempArr:Array = new Array();
			var total:int = (startNum + _canShowNum)  > _moreInfo.length ? _moreInfo.length : (startNum + _canShowNum);
			for(var i:int = startNum; i < total; i++)
			{
				tempArr.push(_moreInfo[i]);
			}
			_centerbar.setTotalNum(tempArr.length);
			_centerbar.setInfo(tempArr);
			resize();
		}
		
		public function resize():void
		{
			if(_topbar && this.contains(_topbar))
			{
				_topbar.x = 2;
				_topbar.y = 0;
			}
			if(_centerbar && this.contains(_centerbar))
			{
				_centerbar.x = (_bg.width - _centerbar.width) / 2;
				_centerbar.y = (_bg.height - _centerbar.height) / 2 + (_topbar ? _topbar.height : 0) / 2 - _bottompBar.height / 2 ;
			}
			if(_bottompBar && this.contains(_bottompBar))
			{
				_bottompBar.x = 0;
				_bottompBar.y = this.height - _bottompBar.height;
				if(_centerbar.width > 0)
				{
					_bottompBar.resizeSearch(_centerbar.width, _centerbar.x);
				}
			}
		}
	}
}