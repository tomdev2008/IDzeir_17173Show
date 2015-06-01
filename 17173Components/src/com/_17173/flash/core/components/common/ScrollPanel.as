package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午4:05:37
	 */
	public class ScrollPanel extends ClipContainer
	{
		protected var _vScrollbar:VScrollBar;
		protected var _hScrollbar:HScrollBar;
		
		/**
		 * 滚动容器 
		 * @param parent 该容器的父容器
		 * 
		 */	
		public function ScrollPanel(parent:DisplayObjectContainer=null)
		{
			super(parent);
		}
		
		override protected function onInit():void
		{
			super.onInit();
			
			this._vScrollbar=new VScrollBar(null,onScroll);
			this._vScrollbar.x=width-_vScrollbar.width;
			this._vScrollbar.y=0;
			this._hScrollbar=new HScrollBar(null,onScroll);
			this._hScrollbar.x=0;
			this._hScrollbar.y=height-this._hScrollbar.height;
			this._vScrollbar.policy="auto";
			this._hScrollbar.policy="auto";
			
			this.addRawChild(_vScrollbar);
			this.addRawChild(_hScrollbar);
			
			this.setSize(100,100);
			_content.addEventListener(Event.ADDED,onAddContent);
			_content.addEventListener(Event.REMOVED,onAddContent);
		}
		
		protected function onAddContent(e:Event):void
		{
			resize();
		}
		
		override public function resize(e:Event=null):void
		{			
			super.resize(e);	
			onDrawRect();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);			
			return child;
		}
		
		override protected function onDrawRect():void
		{
			super.onDrawRect();
			
			var vPercent:Number=(height)/_content.height;
			var hPercent:Number=(width)/_content.width;
			_vScrollbar.x=width-_vScrollbar.width;
			_hScrollbar.y=height-_hScrollbar.height;
			var offsetX:Number=_vScrollbar.visible?0:_vScrollbar.width;
			var offsetY:Number=_hScrollbar.visible?0:_hScrollbar.height;
			
			if(hPercent>=1)
			{
				_vScrollbar.height=height;
				_mask.height=height-_hScrollbar.height+offsetY;
			}else{
				_vScrollbar.height=height-_hScrollbar.height;
				_mask.height=height-_hScrollbar.height+offsetY;
			}
			if(vPercent>=1)
			{
				_hScrollbar.width=width;
				_mask.width=width+offsetX;
			}else{
				_hScrollbar.width=width-_vScrollbar.width;
				_mask.width=width-_vScrollbar.width+offsetX;
			}
			_vScrollbar.setThumbPercent(vPercent);
			_vScrollbar.maximum=Math.max(0,_content.height-height+_hScrollbar.height);
			//_vScrollbar.pageSize=height-_hScrollbar.height;
			
			_hScrollbar.setThumbPercent(hPercent);
			_hScrollbar.maximum=Math.max(0,_content.width-width+_vScrollbar.width);
			//_hScrollbar.pageSize=width-_vScrollbar.width;
			
			_content.x=-_hScrollbar.value;
			_content.y=-_vScrollbar.value;			
		}
		
		protected function onScroll(e:Event):void
		{
			_content.x=-_hScrollbar.value;
			_content.y=-_vScrollbar.value;	
		}
		/**
		 * 垂直滑动区域量 
		 * @return 
		 * 
		 */		
		public function get deltaY():Number
		{
			return this._vScrollbar.maximum-this._vScrollbar.minimum;
		}
		/**
		 * 水平滑动区域量 
		 * @return 
		 * 
		 */
		public function get deltaX():Number
		{
			return this._hScrollbar.maximum-this._hScrollbar.minimum;
		}
		
		/**
		 * 垂直滚动条 
		 * @return 
		 * 
		 */		
		public function get vScrollbar():VScrollBar
		{
			return this._vScrollbar;
		}
		
		/**
		 * 水平滚动条 
		 * @return 
		 * 
		 */		
		public function get hScrollbar():HScrollBar
		{
			return this._hScrollbar;
		}
	}
}