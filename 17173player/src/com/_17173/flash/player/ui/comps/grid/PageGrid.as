package com._17173.flash.player.ui.comps.grid
{
	
	/**
	 * 总个数比单页大 
	 * @author shunia-17173
	 */	
	public class PageGrid extends Grid
	{
		
		protected var _currentPage:int = 0;
		protected var _totalPage:int = 0;
		protected var _allowReverse:Boolean = false;
		
		public function PageGrid()
		{
			super();
		}
		
		public function set allowReverse(value:Boolean):void {
			_allowReverse = value;
		}
		
		public function get currentPage():int {
			return _currentPage;
		}
		
		public function prev():void {
			var p:int = _currentPage + 1;
			if (p > (_totalPage - 1)) {
				if (_allowReverse) {
					p = 0;
				} else {
					p = _totalPage - 1;
				}
			}
			if (p != _currentPage) {
				_currentPage = p;
				updatePage();
			}
		}
		
		public function next():void {
			var p:int = _currentPage - 1;
			if (p < 0) {
				if (_allowReverse) {
					p = _totalPage - 1;
				} else {
					p = 0;
				}
			}
			if (p != _currentPage) {
				_currentPage = p;
				updatePage();
			}
		}
		
		protected function updatePage():void {
			resize(_w, _h);
		}
		
		override public function resize(w:Number, h:Number):void {
			if (isValidate()) {
				_totalPage = _data.length / (_maxColumn * _maxRow);
			}
			super.resize(w, h);
		}
		
		override protected function isValidate():Boolean {
			return super.isValidate() && _maxColumn > 0 && _maxRow > 0;
		}
		
	}
}