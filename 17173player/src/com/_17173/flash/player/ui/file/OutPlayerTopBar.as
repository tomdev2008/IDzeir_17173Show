package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
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
	
	public class OutPlayerTopBar extends Sprite implements ISkinObjectListener
	{
		private var _title:TextField = null;
		private var _bg:Sprite = null;
		private var _search:MovieClip = null;
		private var _fontBg:MovieClip = null;
		private var _label:TextField = null;
		private var _canShow:Boolean = false;
		private var _focusIN:Boolean = false;
		private var _videoCanStart:Boolean = false;
		private var _e:IEventManager;
		
		public function OutPlayerTopBar()
		{
			super();
			this.visible = false;
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			
			_bg = new Sprite();
			this.addChild(_bg);
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.color = 0xfdcd00;
			titleFormat.size = 17;
			titleFormat.font = Util.getDefaultFontNotSysFont();
			
			_title = new TextField();
			_title.text = "";
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.selectable = false;
			_title.defaultTextFormat = titleFormat;
			_title.setTextFormat(titleFormat);
			addChild(_title);
			
			_fontBg = new mc_backRec_search_text_bg();
			addChild(_fontBg);
			_fontBg.width = 127;
			
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			format.size = 16;
			format.font = Util.getDefaultFontNotSysFont();
			_label = new TextField();
			_label.text = "";
			_label.width = 128;
			_label.height = 29;
//			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.type = TextFieldType.INPUT;
			_label.defaultTextFormat = format;
			_label.setTextFormat(format);
			addChild(_label);
			
			_search = new mc_backRec_search();
			addChild(_search);
			
			init();
			resize();
		}
		
		private function init():void
		{
			_e.listen(PlayerEvents.BI_PLAYER_INITED, videoInit);
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
			_e.listen(PlayerEvents.BI_GET_VIDEO_INFO, getVideInfo);
			_e.listen(PlayerEvents.UI_TOGGLE_FULL_SCREEN, onFullScreen);
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.BI_VIDEO_CAN_START, videoCanStart);
			_search.addEventListener("onSearch", onSearchHandler);
			_label.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			_label.addEventListener(FocusEvent.FOCUS_IN, labelFocusIN);
			_label.addEventListener(FocusEvent.FOCUS_OUT, labelFocusOut);
		}
		
		private function onFullScreen(data:Object):void {
			TweenLite.to(this, 0.5, {"y":-height});
			this.visible = false;
		}
		
		private function videoInit(data:Object):void {
			_canShow = true;
//			setInfo(Global.videoData["title"]);
			setInfo((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["title"]);
		}
		
		private function onBIInitVideoInfo(data:Object):void {
			_canShow = false;
		}
		
		private function getVideInfo(data:Object):void {
		}
		
		private function keyDown(evt:KeyboardEvent):void
		{
			switch (evt.keyCode)
			{
				case Keyboard.ENTER:
					if(_label.text != "")
					{
						Util.toUrl(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text));
						_label.text = "";
					}
					break;
			}
		}
		
		private function onSearchHandler(evt:Event):void
		{
			if(_label.text != "")
			{
				Util.toUrl(FileDataRetriver.VIDEO_SERACH_RUL + encodeURI(_label.text));
			}
		}
		
		private function labelFocusIN(evt:FocusEvent):void {
//			if(Global.settings.isFullScreen) {
			if(Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
			_focusIN = true;
		}
		
		private function labelFocusOut(evt:FocusEvent):void {
			_focusIN = false;
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
				_title.text = Util.formatStringExceed(_title, _fontBg.x);
			}
		}
		
		public function listen(event:String, data:Object):void {
			if (!_canShow) {
				return;
			}
			switch (event) {
				case SkinEvents.SHOW_FLOW : 
//					if (Global.settings.isFullScreen || !_videoCanStart) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"] || !_videoCanStart) {
						return;
					}
					this.visible = true;
					TweenLite.to(this, 0.5, {"y":0});
					break;
				case SkinEvents.HIDE_FLOW : 
					if (_focusIN) {
						break;
					} else {
						TweenLite.to(this, 0.5, {"y":-height});
						this.visible = false;
						break;
					}
				case SkinEvents.RESIZE : 
//					TweenLite.killTweensOf(this);
//					resize();
					break;
			}
		}
		
		/**
		 * 后推不能显示topbar
		 * @param data
		 * 
		 */		
		private function showBackRec(data:Object):void {
			_canShow = false;
			this.visible = false;
		}
		
		private function hideBackRec(data:Object):void {
			_canShow = true;
		}
		
		protected function videoCanStart(data:Object):void {
			_videoCanStart = true;
		}
		
	}
}