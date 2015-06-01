package com._17173.flash.player.ui.comps.backRecommend
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class BackRecBottomBar extends Sprite
	{
		private var _bg:Sprite = null;
		private var _leftBtn:DisplayObject = null;
		private var _rightBtn:DisplayObject = null;
		private var _search:MovieClip = null;
		private var _label:TextField = null;
		private var _fontBg:MovieClip = null;
		
		public function BackRecBottomBar(width:Number)
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawRect(0, 0, width, 60);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_leftBtn = new mc_backRec_left();
			addChild(_leftBtn);
			_rightBtn = new mc_backRec_right();
			addChild(_rightBtn);
			
			addSearch();
			
			//			_leftBtn = skinManager.attachSkinByName("backRec_left", this);
			//			_rightBtn = skinManager.attachSkinByName("backRec_right", this);
			//			_search = skinManager.attachSkinByName("backRec_search", this);
			//			_fontBg = skinManager.attachSkinByName("backRec_search_text_bg", this);
			
			init();
			resize();
		}
		
		protected function addSearch():void {
			_search = new mc_backRec_search();
			addChild(_search);
			_fontBg = new mc_backRec_search_text_bg();
			addChild(_fontBg);
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.color = 0x000000;
			titleFormat.size = 16;
			titleFormat.font = Util.getDefaultFontNotSysFont();
			
			_label = new TextField();
			_label.text = "";
			_label.width = 227;
			_label.height = 29;
			_label.type = TextFieldType.INPUT;
			_label.defaultTextFormat = titleFormat;
			_label.setTextFormat(titleFormat);
			addChild(_label);
		}
		
		public function init():void
		{
			if (_search) {
				_search.addEventListener("onSearch", onSearchHandler);
			}
			
			_leftBtn.addEventListener(MouseEvent.CLICK, leftHandler);
			_rightBtn.addEventListener(MouseEvent.CLICK, rightHandler);
			
			if (_label) {
				_label.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				_label.addEventListener(FocusEvent.FOCUS_IN, labelFocusIN);
			}
		}
		
		private function keyDown(evt:KeyboardEvent):void
		{
			switch (evt.keyCode)
			{
				case Keyboard.ENTER:
					if(_label.text != "")
					{
						//						navigateToURL((new URLRequest(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text))), "_blank");
						//						Util.toUrl(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text));
						onSearchHandler(null);
					}
					break;
			}
		}
		
		private function onSearchHandler(evt:Event):void
		{
			if(_label.text != "")
			{
				//				navigateToURL((new URLRequest(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text))), "_blank");
				Util.toUrl(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text));
			}
		}
		
		private function leftHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event("leftEvent"));
		}
		
		private function rightHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event("rightEvent"));
		}
		
		private function labelFocusIN(evt:FocusEvent):void
		{
//			if(Global.settings.isFullScreen)
			if(Context.getContext(ContextEnum.SETTING).isFullScreen)
			{
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function resize():void
		{
			if(_leftBtn && this.contains(_leftBtn))
			{
				_leftBtn.x = 0;
				_leftBtn.y = (_bg.height - _leftBtn.height) / 2;
			}
			
			if(_rightBtn && this.contains(_rightBtn))
			{
				_rightBtn.x = _leftBtn.x + _leftBtn.width + 140;
				_rightBtn.y = (_bg.height - _rightBtn.height) / 2;
			}
			
			if(_search && this.contains(_search))
			{
				_search.x = _bg.width - _search.width - 5;
				_search.y = (_bg.height - _search.height) / 2;
			}
			
			if(_label && this.contains(_label))
			{
				_label.x = _fontBg.x + 1;
				_label.y = _fontBg.y + (_fontBg.height - _label.height) / 2 + 2;
			}
			
			if(_fontBg && this.contains(_fontBg))
			{
				_fontBg.x = _search.x - _fontBg.width;
				_fontBg.y = (_bg.height - _fontBg.height) / 2;
			}
		}
		
		public function resizeSearch(value:Number, xvalue:int):void
		{
			var tempW:Number = (_fontBg ? _fontBg.x : this.width) - xvalue;
			if (tempW > (xvalue + _leftBtn.width * 2 + 150)) {
				_leftBtn.x = (tempW - (_leftBtn.width * 2 + 150)) / 2; 
				_rightBtn.x = _leftBtn.x + _leftBtn.width + 150;
			} else {
				_leftBtn.x = xvalue;
				_rightBtn.x = (_fontBg ? _fontBg.x : this.width) - _rightBtn.width - 5;
			}
			_leftBtn.y = (_bg.height - _leftBtn.height) / 2;
			_rightBtn.y = (_bg.height - _rightBtn.height) / 2;
			
			if(_search && this.contains(_search))
			{
				_search.x = value + xvalue - _search.width - 5;
				_search.y = (_bg.height - _search.height) / 2;
			}
			
			if(_fontBg && this.contains(_fontBg))
			{
				_fontBg.x = _search.x - _fontBg.width;
				_fontBg.y = (_bg.height - _fontBg.height) / 2;
			}
			
			if(_label && this.contains(_label))
			{
				_label.x = _fontBg.x + 1;
				_label.y = _fontBg.y + (_fontBg.height - _label.height) / 2 + 2;
			}
		}
	}
}