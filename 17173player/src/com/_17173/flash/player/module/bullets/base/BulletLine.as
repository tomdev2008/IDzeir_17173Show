package com._17173.flash.player.module.bullets.base
{

	/**
	 * 横向上的弹幕数据类.
	 * 每个弹幕都横向的分布在一个line上.
	 * 弹幕移动的时候如果从左侧移出了某个line,则需要调用getOccupation方法清除occupation
	 * 此时认为此line的isOccupation为false
	 *  
	 * @author shunia-17173
	 */	
	public class BulletLine
	{
		
		private var _line:int = 0;
		private var _occupation:Array = null;
		private var _lineHeight:int;
		
		public function BulletLine()
		{
			_occupation = [];
		}

		public function get line():int
		{
			return _line;
		}

		public function set line(value:int):void
		{
			_line = value;
		}
		
		/**
		 * 此line是否在被占用中 
		 * @return 
		 */		
		public function get isOccupation():Boolean {
			return _occupation && _occupation.length;
		}

		/**
		 * 判断指定的bullet是否在占用当前line 
		 * @param bullet
		 * @return 
		 */		
		public function isBulletOccupationed(bullet:Bullet):Boolean {
			return _occupation && _occupation.indexOf(bullet) != -1;
		}
		
		/**
		 * 将bullet增加到此line中,从而使此line被占用 
		 * @param bullet
		 */		
		public function setOccupation(bullet:Bullet):void {
			if (_occupation.indexOf(bullet) == -1) {
				_occupation.push(bullet);
			}
			calLineHeight();
		}
		/**
		 * 
		 * 
		 */		
		public function get lineHeight():int{
			return _lineHeight;
		}
		
		public function updateLineHeight():void{
			calLineHeight();
		}
		
		private function calLineHeight():void{
			var tmpHeight:int = 0;
			var len:int=  _occupation.length;
			var bull:Bullet;
			for (var i:int = 0; i < len; i++) 
			{
				bull = _occupation[i];
				tmpHeight = Math.max(Math.ceil(bull.height),tmpHeight);
			}
			_lineHeight = tmpHeight;
		}
		
		/**
		 * 去掉指定bullet对此line的占用 
		 * @param bullet
		 */		
		public function getOccupation(bullet:Bullet):void {
			var index:int = _occupation.indexOf(bullet);
			if (index != -1) {
				_occupation.splice(index, 1);
			}
			calLineHeight();
		}

	}
}