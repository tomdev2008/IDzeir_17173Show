package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-10  下午2:08:36
	 */
	public class Group extends Sprite
	{
		/**
		 * 内部元素容器 
		 */		
		protected var _content:Sprite;
		private var _left:Number = 0;
		private var _top:Number = 0;
		
		public function Group()
		{
			super();
			_content = new Sprite();
			super.addChild(_content);
		}
		/**
		 * 左边距 
		 * @param value
		 * 
		 */		
		public function set left(value:Number):void
		{
			_left = value;
			_content.x = value;
		}
		
		public function get left():Number
		{
			return _left;
		}
		/**
		 * 顶边距 
		 * @param value
		 * 
		 */		
		public function set top(value:Number):void
		{
			_top = value;
			_content.y = value;
		}
		
		public function get top():Number
		{
			return _top;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			_content.addChild(child);	
			rePos();
			return child
		}
		
		public function addRawChildAt(child:DisplayObject,index:int,xpos:Number=0,ypos:Number=0):void
		{
			child.x = xpos;
			child.y = ypos;
			super.addChildAt(child,index);
		}
		
		public function removeRawChild(child:DisplayObject):void
		{
			super.removeChild(child);
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			_content.addChildAt(child,index);
			rePos();
			return child;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			_content.removeChild(child);
			rePos();
			return child;
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			var child:DisplayObject=_content.removeChildAt(index);
			rePos();
			return child;			
		}
		
		override public function removeChildren(beginIndex:int=0, endIndex:int=2147483647):void
		{
			_content.removeChildren();
		}
		
		/**
		 * 排列组件内部元素
		 * */
		protected function rePos():void
		{
			//HGroup、VGroup重写用于排列位置
		}
		
		/**
		 * 容器内部元素占用的最大宽高
		 * */
		protected function get bounds():Object
		{
			var w:Number = 0;
			var h:Number = 0;
			for(var i:uint = 0;i<_content.numChildren;i++)
			{
				var tar:DisplayObject = _content.getChildAt(i);
				w = Math.max(tar.width,w);
				h = Math.max(tar.height,h);
			}
			return {width:w,height:h};
		}
		
		/**
		 * 更新容器的显示
		 */
		public function update():void
		{
			this.rePos();
		}
	}
}