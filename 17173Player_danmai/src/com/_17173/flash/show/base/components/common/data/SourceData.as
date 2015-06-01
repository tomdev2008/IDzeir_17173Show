package com._17173.flash.show.base.components.common.data
{
	import flash.display.DisplayObject;

	/**
	 *资源数据
	 * @author zhaoqinghao
	 * 
	 */
	public class SourceData
	{
		private var _source:DisplayObject = null;
		private var _size:Object = null;
		/**
		 * ui资源数据，可设置默认资源 ，九宫格，最小宽高 继承后重写默认赋值方法
		 * @param souce 底图资源 
		 * @param size 资源的宽高最小限制{w:最小宽度，h:最小高度};
		 */		
		public function SourceData(souce:DisplayObject = null,size:Object = null)
		{
			_source = souce;
			_size = size;
			if(_source == null){
				//设置默认资源
				_source = getNorSource();
			}
			if(_size == null){
				_size = getNorSize();
			}
		}
		
		protected function getNorSource():DisplayObject{
			return null;
		}
		
		protected function getNorSize():Object{
			//计算最小宽高
			return null;
		}

		
		/**
		 *获取最小宽高 
		 * @return 
		 * 
		 */		
		public function get size():Object
		{
			return _size;
		}
		
		public function set size(value:Object):void
		{
			_size = value;
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get source():DisplayObject
		{
			return _source;
		}

		public function set source(value:DisplayObject):void
		{
			_source = value;
		}

	}
}