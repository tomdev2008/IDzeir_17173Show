package com._17173.flash.player.ui.comps.grid
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Grid extends Sprite
	{
		
		protected var _data:Array = null;
		protected var _renderer:Class = null;
		/**
		 * 是否根据子项大小进行布局.
		 * 为true时按子项大小进行计算布局.
		 * 为false时按列表项目数进行计算布局.
		 * 暂时不支持false时的布局.
		 */		
		protected var _isSteadyLayout:Boolean = false;
		protected var _itemWidth:Number = 0;
		protected var _itemHeight:Number = 0;
		protected var _maxColumn:int = 0;
		protected var _maxRow:int = 0;
		protected var _horizontalGap:int = 10;
		protected var _verticalGap:int = 10;
		
		protected var _tempColumn:int = 0;
		protected var _tempRow:int = 0;
		protected var _viewDirty:Boolean = false;
		protected var _column:int = 0;
		protected var _row:int = 0;
		/**
		 * 实际占用尺寸 
		 */		
		protected var _actualWidth:Number = 0;
		protected var _actualHeight:Number = 0;
		/**
		 * 实际横纵向格数 
		 */		
		protected var _actualColumn:int = 0;
		protected var _actualRow:int = 0;
		/**
		 * 计算出来的预估尺寸(最大) 
		 */		
		protected var _calcWidth:Number = 0;
		protected var _calcHeight:Number = 0;
		/**
		 * 外部容器尺寸 
		 */		
		protected var _w:Number = 0;
		protected var _h:Number = 0;
		
		public function Grid()
		{
			super();
		}
		
		public function set data(value:Array):void {
			if (_data != value) {
				_data = value;
			}
		}
		
		public function set rendererClass(value:Class):void {
			_renderer = value;
		}
		
		public function set isSteadyLayout(value:Boolean):void {
			_isSteadyLayout = value;
		}
		
		public function set itemWidth(value:Number):void {
			_itemWidth = value;
		}
		
		public function set itemHeight(value:Number):void {
			_itemHeight = value;
		}
		
		public function set maxRow(value:int):void {
			_maxRow = value;
		}
		
		public function set maxColumn(value:int):void {
			_maxColumn = value;
		}
		
		public function set horizontalGap(value:Number):void {
			_horizontalGap = value;
		}
		
		public function set verticalGap(value:Number):void {
			_verticalGap = value;
		}
		
		/**
		 * 触发方法,不调用此方法将不会生成任何子项. 
		 * @param w
		 * @param h
		 */		
		public function resize(w:Number, h:Number):void {
			if (!isValidate()) return;
			
			_w = w;
			_h = h;
			
			calcLayout();
			validateLayout();
			calcSize();
			updateView();
		}
		
		/**
		 * 计算临时的size 
		 */		
		protected function calcLayout():void {
			_tempColumn = _w / _itemWidth;
			_tempRow = _h / _itemHeight;
			_tempColumn = ((_tempColumn * _itemWidth) + (_tempColumn - 1) * _horizontalGap) > _w ? (_tempColumn - 1) : _tempColumn;
			_tempRow = ((_tempRow * _itemHeight) + (_tempRow - 1) * _verticalGap) > _h ? (_tempRow - 1) : _tempRow;
		}
		
		/**
		 * 验证size,防止越界或者不合理 
		 */		
		protected function validateLayout():void {
			if (_tempColumn > _maxColumn) {
				//大于最大列数
				_tempColumn = _maxColumn;
			}
			if (_tempRow > _maxRow) {
				//大于最大行数
				_tempRow = _maxRow;
			}
			//如果同时设置了maxRow和maxColumn,相当于多出来的不显示,少了的话不显示
			if (_tempColumn != _column || _tempRow != _row) {
				_column = _tempColumn;
				_row = _tempRow;
				_viewDirty = true;
			}
		}
		
		/**
		 * 计算预估尺寸 
		 */		
		protected function calcSize():void {
			_calcWidth = _column * (_itemWidth + _horizontalGap) - _horizontalGap;
			_calcHeight = _row * (_itemHeight + _verticalGap) - _verticalGap;
		}
		
		/**
		 * 更新视图 
		 */		
		protected function updateView():void {
			if (!_viewDirty) return;
			clear();
			createChildren();
			updateActualSize();
			
			x = (_w - width) / 2;
			y = (_h - height) / 2;
		}
		
		/**
		 * 数据验证 
		 * @return 
		 */		
		protected function isValidate():Boolean {
			return !(_data == null || _data.length == 0 || _renderer == null);
		}
		
		/**
		 * 清除当前容器里的子项 
		 */		
		public function clear():void {
			while (this.numChildren) {
				var item:IGridItemRenderer = removeChildAt(0) as IGridItemRenderer;
				item.dispose();
			}
		}
		
		/**
		 * 创建自组件 
		 */		
		protected function createChildren():void {
			_actualColumn = 0;
			_actualRow = 0;
			var complete:Boolean = false;
			for (var j:int = 0; j < _row; j ++) {
				var tempC:int = 0;
				if (complete) {
					break;
				}
				for (var i:int = 0; i < _column; i ++) {
					var d:Object = null;
					var index:int = j * _column + i;
					if (_data.length >= (index + 1)) {
						d = _data[index];
					}
					if (d) {
						var item:IGridItemRenderer = new _renderer() as IGridItemRenderer;
						item.data = d;
						item["x"] = i * (_itemWidth + _horizontalGap);
						item["y"] = j * (_itemHeight + _verticalGap);
						item.width = _itemWidth;
						item.height = _itemHeight;
						addChild(item as DisplayObject);
						tempC ++;
						if (_actualColumn < tempC) {
							_actualColumn = tempC;
						}
					} else {
						complete = true;
						break;
					}
				}
				_actualRow ++;
			}
		}
		
		protected function updateActualSize():void {
			_actualWidth = _actualColumn * (_itemWidth + _horizontalGap) - _horizontalGap;
			_actualHeight = _actualRow * (_itemHeight + _verticalGap) - _verticalGap;
		}
		
		/**
		 * 销毁当前grid 
		 */		
		public function dispose():void {
			_data = null;
			_renderer = null;
			clear();
		}
		
		override public function get width():Number {
			return _actualWidth;
		}
		
		override public function get height():Number {
			return _actualHeight;
		}
		
	}
}