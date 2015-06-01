package com._17173.flash.player.ui.comps.backRecommendMiddle
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	public class BackRecTopBarMiddle extends Sprite
	{
		private var _title:TextField = null;
		private var _rightbar:ISkinObject = null;
		private var _bg:Sprite = null;
		private var _search:MovieClip = null;
		private var _fontBg:MovieClip = null;
		private var _label:TextField = null;
		
		public function BackRecTopBarMiddle()
		{
			super();
			
			_bg = new Sprite();
			this.addChild(_bg);
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.color = titleColor;
			titleFormat.size = 17;
			titleFormat.font = Util.getDefaultFontNotSysFont();
			
			_title = new TextField();
			_title.text = "";
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.selectable = false;
			_title.defaultTextFormat = titleFormat;
			_title.setTextFormat(titleFormat);
			addChild(_title);
			
			addMoreC();
			
			init();
			resize();
		}
		
		protected function get titleColor():uint {
			return 0xfdcd00;
		}
		
		protected function addMoreC():void {
			_fontBg = new mc_backRec_search_text_bg();
			addChild(_fontBg);
			_fontBg.width = 127;
			
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			format.size = 16;
			format.font = Util.getDefaultFontNotSysFont();
			_label = new TextField();
			_label.text = "";
			_label.width = 227;
			_label.height = 29;
			_label.type = TextFieldType.INPUT;
			_label.defaultTextFormat = format;
			_label.setTextFormat(format);
			addChild(_label);
			
			_search = new mc_backRec_search();
			addChild(_search);
		}
		
		private function init():void
		{
			if (_search) {
				_search.addEventListener("onSearch", onSearchHandler);
			}
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
						Util.toUrl(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text));
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
		
		private function labelFocusIN(evt:FocusEvent):void {
//			if(Global.settings.isFullScreen) {
			if(Context.getContext(ContextEnum.SETTING).isFullScreen) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function setInfo(title:String):void
		{
			_title.text = title;
			resize();
		}
		
		public function resize():void
		{
			if(_bg && this.contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x000000,0.2);
				_bg.graphics.drawRect(0, 0, Context.stage.stageWidth, 40);
				_bg.graphics.endFill();
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
			
			if (_title && contains(_title)) {
				_title.x = 10;
				_title.y = (_bg.height - _title.height) / 2;
				_title.text = Util.formatStringExceed(_title, (_fontBg ? _fontBg.x : _bg.width));
			}
		}
	}
}