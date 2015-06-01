package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-10  下午1:49:34
	 */
	public class VGroup extends Group
	{
		protected var vGap:Number=5;		
		
		protected var _leftmargin:Number=0;
		
		static public const LEFT:String = "left";
		static public const CENTER:String = "center";
		static public const RIGHT:String = "right";
		
		private var _align:String;
		
		public function VGroup()
		{
			super();
			align = LEFT;
		}
		
		/**
		 * 内部元素对齐方式，有效值为 VGroup.LEFT、VGroup.CENTER、VGroup.RIGHT
		 */
		public function get align():String
		{
			return _align;
		}
		
		public function set align(value:String):void
		{
			_align = value;
			rePos();
		}
		/**
		 * 弃用的方法，设置无效
		 */
		public function set leftmargin(value:Number):void
		{
			_leftmargin = value;
			rePos();
		}
		
		override protected function rePos():void
		{
			super.rePos();
			
			var tar:DisplayObject;
			var yPos:Number=0;
			var maxW:Number = this.bounds.width;			
			for(var i:uint = 0;i<_content.numChildren;i++)
			{
				if(tar)
				{
					yPos = tar.y + tar.height + vGap;
				}
				tar=_content.getChildAt(i);
				tar.y = yPos;
				switch(this._align)
				{
					case LEFT:
						tar.x = 0;
						break;
					case CENTER:
						tar.x = (maxW - tar.width)>>1;
						break;
					case RIGHT:
						tar.x = (maxW - tar.width);
						break;
				}
			}
		}
		
		/**
		 * 容器内部元素的垂直间距
		 */
		public function set gap(value:Number):void
		{
			vGap=value;
			rePos();
		}
		
		public function get gap():Number
		{
			return vGap;
		}
	}
}