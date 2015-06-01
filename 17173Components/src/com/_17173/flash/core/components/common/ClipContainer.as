package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/** 
	 * 剪裁子对象的容器
	 * @author idzeir
	 * 创建时间：2014-1-23  下午2:16:54
	 */
	public class ClipContainer extends SkinComponent
	{
		protected var _mask:Sprite;
		
		/** addChild的父容器,被_mask遮罩*/
		protected var _content:Sprite;
		
		protected var _background:Sprite;
		
		public function ClipContainer(parent:DisplayObjectContainer=null)
		{
			super(parent);
			this.setSkin_Bg(null);
		}		
			
		override protected function onInit():void
		{
			super.onInit();
			_mask=new Sprite();
			_mask.graphics.beginFill(0x000000,0);
			_mask.graphics.drawRect(0,0,10,10);
			_mask.graphics.endFill();
			_mask.mouseEnabled=false;
			super.addChild(_mask);
			
			_content=new Sprite();
			super.addChild(_content);
			_content.mask=_mask;		
			
			_background=new Sprite();
			_background.graphics.beginFill(0x000000,0);
			_background.graphics.drawRect(0,0,10,10);
			_background.graphics.endFill();
			_background.mouseEnabled=false;
			super.addChild(_background);
			
			setSize(100,100);
			this.onResize();
		}
		
		override protected function onDrawRect():void
		{
			super.onDrawRect();
			_mask.width=this._setWidth;
			_mask.height=this._setHeight;
			_background.width=this._setWidth;
			_background.height=this._setHeight;		
		}
		/**
		 * 添加到非content容器中
		 * @param child
		 * @param index
		 * @return 
		 * 
		 */		
		public function addRawChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child,index);
		}
		
		/**
		 * 添加到容器中 被遮罩
		 * @param child
		 * @return 
		 * 
		 */		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			this._content.addChild(child);
			return child;
		}
		
		/**
		 * 添加到容器中 不被遮罩
		 * @param child
		 * @return 
		 * 
		 */		
		public function addRawChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			return child;
		}
		
		/**
		 * 调用addChild时，child将被添加到content里面
		 * @return 
		 * 
		 */		
		public function get content():Sprite
		{
			return _content;
		}
	}
}