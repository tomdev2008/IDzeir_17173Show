package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.VScrollPanel;
	import com._17173.flash.core.components.interfaces.IOutputTxt;
	import com._17173.flash.show.base.components.common.Grid9Skin;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.engine.TextLine;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-24  下午4:38:53
	 */
	public class ChatMsgPanel extends VScrollPanel
	{
		private var _lock:Boolean = false;

		public var _iText:IOutputTxt

		private var old:Number;
		
		private const SCROLL_TO_BOTTOM:String = "scrollToBottom";
		private const SCROLL_TO_TOP:String = "scrollToTop";
		
		private var _scrollType:String = SCROLL_TO_TOP;

		public function ChatMsgPanel(parent:DisplayObjectContainer = null)
		{
			super(parent);
			this._scrollType = SCROLL_TO_BOTTOM;
			this.sliderSkin(new Grid9Skin(Slider_thumb));
			this.vScrollbar.bglayerAlpha = 0;
		}

		override public function resize(e:Event = null):void
		{
			super.resize(e);
			if(!this._lock && !_iText.locked)
			{
				updateSlider();				
			}
		}
		/**
		 * 添加textline时才会触发
		 */
		override protected function onAddContent(e:Event):void
		{
			if(e.target is TextLine)
			{				
				super.onAddContent(e);
			}
		}
		
		override public function update():void
		{
			this.resize();
		}
		
		private function updateSlider():void
		{
			var toNum:Number = 0;
			switch(this._scrollType)
			{
				case SCROLL_TO_TOP:
					toNum = Math.min(this._vScrollbar.minimum,this._vScrollbar.maximum);
					break;
				case SCROLL_TO_BOTTOM:
					toNum = Math.max(this._vScrollbar.minimum,this._vScrollbar.maximum);
					break;
			}
			this._vScrollbar.value = toNum;
		}	

		/**
		 * 聊天消息容器是否自动滚动
		 * @param bool
		 *
		 */
		public function set lock(bool:Boolean):void
		{
			_lock = bool;
			if(!bool)
			{
				this.resize();
			}
		}

		public function get lock():Boolean
		{
			return this._lock;
		}
	}
}