package com._17173.flash.core.ds
{
	/**
	 * 先进先出队列 
	 * @author shunia-17173
	 */	
	public class Queue
	{
		
		private var _arr:Array = null;
		
		public function Queue()
		{
			_arr = [];
		}
		
		public function add(item:*):void {
			_arr.push(item);
		}
		
		public function pop():* {
			return _arr.shift();
		}
		
		public function get length():int {
			return _arr.length;
		}
		
	}
}