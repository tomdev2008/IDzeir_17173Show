package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.ClipContainer;
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.components.common.VScrollBar;
	import com._17173.flash.core.components.common.VScrollPanel;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.components.common.Grid9Skin;
	import com._17173.flash.show.base.context.text.GraphicTextOption;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.text.engine.GroupElement;
	
	/**
	 * 送礼记录聊天展示面板 
	 * @author idzeir
	 * 
	 */	
	public class ChatGiftInfoPanel extends ClipContainer
	{
		private const SCROLL_TO_BOTTOM:String = "scrollToBottom";
		private const SCROLL_TO_TOP:String = "scrollToTop";
		private var _scrollType:String = SCROLL_TO_TOP;
		
		private var _textManager:IGraphicTextManager;

		private var _allTxt:GraphicText;
		
		private var _expensiveTxt:GraphicText;
		
		private var _expensivePanel:VScrollPanel;
		
		private var _allPanel:VScrollPanel;

		private var box:VGroup;
		
		/**
		 * 礼物信息面板 
		 */		
		public function ChatGiftInfoPanel()
		{
			super();

			this._scrollType = SCROLL_TO_BOTTOM;

			_textManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
			_allTxt = _textManager.createGraphicText(null, new GraphicTextOption(true, 37)) as GraphicText;
			_allTxt.leading = 7;
			_allTxt.x = 15;
			_allTxt.textWidth = 320;

			_textManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
			_expensiveTxt = _textManager.createGraphicText(null, new GraphicTextOption(true, 37)) as GraphicText;
			_expensiveTxt.leading = 7;
			_expensiveTxt.x = 15;
			_expensiveTxt.maxLines = 50;
			_expensiveTxt.textWidth = 320;

			_expensivePanel = new VScrollPanel();

			var crown:DisplayObject = new Crown1_8();
			crown.y = -10;
			_expensivePanel.addRawChildAt(crown, 0);
			var _ebglayer:DisplayObject = new ChatGiftBglayer1_8();
			_ebglayer.y = -5;
			_expensivePanel.addRawChildAt(_ebglayer, 0);

			_expensivePanel.sliderSkin(new Grid9Skin(Slider_thumb));
			_expensivePanel.addChild(_expensiveTxt);

			_allPanel = new VScrollPanel();
			_allPanel.sliderSkin(new Grid9Skin(Slider_thumb));
			_allPanel.addChild(_allTxt);
			
			_expensivePanel.vScrollbar.bglayerAlpha = _allPanel.vScrollbar.bglayerAlpha = 0;

			box = new VGroup();
			box.top = 10;
			box.gap = 20;
			box.addChild(_expensivePanel);
			box.addChild(_allPanel);
			this.addChild(box);
		}
		
		public function appendElement(ele:GroupElement):void
		{
			_allTxt.addElement(ele);
			_allPanel.resize();
			updateSlider(_allPanel.vScrollbar);
		}
		
		public function addExpensive(ele:GroupElement):void
		{
			_expensiveTxt.addElement(ele);
			_expensivePanel.resize();
			updateSlider(_expensivePanel.vScrollbar);
		}
		
		private function updateSlider(value:VScrollBar):void
		{
			var toNum:Number = 0;
			switch(this._scrollType)
			{
				case SCROLL_TO_TOP:
					toNum = Math.min(value.minimum,value.maximum);
					break;
				case SCROLL_TO_BOTTOM:
					toNum = Math.max(value.minimum,value.maximum);
					break;
			}
			value.value = toNum;
		}
		
		override public function update():void
		{
			super.update();
			_expensivePanel.resize();
			updateSlider(_expensivePanel.vScrollbar);
			_allPanel.resize();
			updateSlider(_allPanel.vScrollbar);
		}

		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h + 25);
			if (_allPanel)
			{
				var _expensiveH:Number = 80;
				this._expensivePanel.setSize(w - 8, _expensiveH);
				this._allPanel.setSize(w - 8, h - _expensiveH - box.gap - box.top);
				_expensivePanel.update();
				_allPanel.update();
				box.update();
			}
		}
	}
}