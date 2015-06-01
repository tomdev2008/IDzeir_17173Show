package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerVideoSize;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class TopBar extends Sprite implements ISkinObjectListener
	{
		private var _bg:MovieClip = null;
		protected var _fifty:MovieClip = null;
		protected var _seventyFive:MovieClip = null;
		protected var _hundred:MovieClip = null;
		protected var _full:MovieClip = null;
		protected var _shrink:MovieClip = null;
		private var _title:TextField = null;
		private var _tipLeft:TextField = null;
		private var _tipRight:TextField = null;
		private var _time:Date = null;
		private var _timeText:TextField = null;
		private var _canShow:Boolean = false;
		private var _e:IEventManager;
		
		private var _videoShowScaleIndex:int = 0;
		
		public function TopBar()
		{
			super();
			
			this.visible = false;
			
			_time = new Date();
			
			var format:TextFormat = new TextFormat();
			format.font = Util.getDefaultFontNotSysFont();
			format.color = 0x808080;
			format.size = 12;
			
			var titleFormat:TextFormat = new TextFormat();
			titleFormat.font = Util.getDefaultFontNotSysFont();
			titleFormat.color = 0xFFFFFF;
			titleFormat.size = 16;
			
			_bg = new mc_topbarBack();
			addChild(_bg);
			
			_title = new TextField();
			_title.text = "";
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.defaultTextFormat = titleFormat;
			_title.setTextFormat(titleFormat);
			this.addChild(_title);
			
			_tipLeft = new TextField();
			_tipLeft.text = "画面尺寸";
			_tipLeft.width = 50;
			_tipLeft.height = 18;
			_tipLeft.setTextFormat(format);
			this.addChild(_tipLeft);
			
			
			addFifty();
			_fifty.name = "0";
			
			addSeventyFive();
			_seventyFive.name = "1";
			
			addHundred();
			_hundred.name = "2";
			
			addFull();
			_full.name = "3";
			
			_tipRight = new TextField();
			_tipRight.text = "提示：支持鼠标滚轮缩放";
			_tipRight.autoSize = TextFieldAutoSize.LEFT;
			_tipRight.setTextFormat(format);
			this.addChild(_tipRight);
			
			_timeText = new TextField();
			_timeText.text = _time.hours + " : " +　_time.minutes;
			_timeText.width = 50;
			_timeText.height = 22;
			_timeText.autoSize = TextFieldAutoSize.LEFT;
			_timeText.defaultTextFormat = titleFormat;
			_timeText.setTextFormat(titleFormat);
			this.addChild(_timeText);
			
			addShrink();
			
			init();
		}
		
		protected function addShrink():void {
			_shrink = new mc_topbar_shrink();
			addChild(_shrink);
		}
		
		protected function addFull():void
		{
			_full = new mc_topbar_full();
			addChild(_full);
		}
		
		protected function addHundred():void
		{
			_hundred = new mc_topbar_hundred();
			addChild(_hundred);
		}
		
		protected function addSeventyFive():void
		{
			_seventyFive = new mc_topbar_seventyFive();
			addChild(_seventyFive);
		}
		
		protected function addFifty():void
		{
			_fifty = new mc_topbar_fifty();
			addChild(_fifty);
		}
		
		private function init():void
		{
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_fifty.addEventListener(MouseEvent.CLICK, onFitScaleHandler);
			_seventyFive.addEventListener(MouseEvent.CLICK, onFitScaleHandler);
			_hundred.addEventListener(MouseEvent.CLICK, onFitScaleHandler);
			_full.addEventListener(MouseEvent.CLICK, onFitScaleHandler);
			_shrink.addEventListener(MouseEvent.CLICK, onShrinkHandler);
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.BI_VIDEO_CAN_START, videoCanStart);
		}
		
		private function addToStage(evt:Event):void
		{
			_videoShowScaleIndex = 2;
			updateScale();
			Context.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			Ticker.tick(1000, updateTime, 0);
			resize();
		}
		
		protected function onMouseWheel(event:MouseEvent):void {
			if (!_canShow) {
				return;
			}
			if (event.delta > 0) {
				//上滚
				_videoShowScaleIndex ++;
			} else {
				//下滚
				_videoShowScaleIndex --;
			}
			if (_videoShowScaleIndex > 3) {
				_videoShowScaleIndex = 3;
			} else if (_videoShowScaleIndex < 0) {
				_videoShowScaleIndex = 0;
			} else {
				updateScale();
			}
		}
		
		private function updateScale():void {
//			Global.settings.videoScale = Settings.VIDEO_SCALES[_videoShowScaleIndex];
			Context.getContext(ContextEnum.SETTING)["videoScale"] = PlayerVideoSize.VIDEO_SCALES[_videoShowScaleIndex];
			changeScaleStyle();
		}
		
		private function removeFromStage(evt:Event):void
		{
			Context.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			Ticker.stop(updateTime);
		}
		
		private function updateTime():void
		{
			_time = new Date();
			_timeText.text = _time.hours + " : " +　formatMinutes(_time.minutes);
		}
		
		private function formatMinutes(value:Number):String
		{
			if(value < 10)
			{
				return "0" + value;
			}
			else
			{
				return value.toString();
			}
		}
		
		private function onFitScaleHandler(evt:MouseEvent):void
		{
			_videoShowScaleIndex = int(evt.currentTarget.name);
			updateScale();
		}
		
		private function onShrinkHandler(evt:MouseEvent):void
		{
//			Global.eventManager.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_TOGGLE_FULL_SCREEN, null, null, true);
		}
		
		private function resize():void
		{
			var centerX:Number = (Context.stage.stageWidth - (_tipLeft.width + 22 + _fifty.width + 22 + _seventyFive.width + 22 + _hundred.width + 22 + _full.width + 22 + _tipRight.width))/2;
			if (_bg && contains(_bg)) {
				_bg.width = Context.stage.stageWidth;
			}
			if (_tipLeft && contains(_tipLeft)) {
				_tipLeft.x = centerX;
				_tipLeft.y = (_bg.height - _tipLeft.height) / 2;
			}
			if (_fifty && contains(_fifty)) {
				_fifty.x = _tipLeft.x + _tipLeft.width + 22;
				_fifty.y = (_bg.height - _fifty.height) / 2;
			}
			if (_seventyFive && contains(_seventyFive)) {
				_seventyFive.x = _fifty.x + _fifty.width + 22;
				_seventyFive.y = (_bg.height - _seventyFive.height) / 2;
			}
			if (_hundred && contains(_hundred)) {
				_hundred.x = _seventyFive.x + _seventyFive.width + 22;
				_hundred.y = (_bg.height - _hundred.height) / 2;
			}
			if (_full && contains(_full)) {
				_full.x = _hundred.x + _hundred.width + 22;
				_full.y = (_bg.height - _full.height) / 2;
			}
			if (_tipRight && contains(_tipRight)) {
				_tipRight.x = _full.x + _full.width + 22;
				_tipRight.y = (_bg.height - _tipRight.height) / 2;
			}
//			if(Global.videoData["title"]) {
//				_title.text = HtmlUtil.decodeHtml(Global.videoData["title"]);
//			}
			if((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["title"]) {
				_title.text = HtmlUtil.decodeHtml((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["title"]);
			}
			if(_timeText && contains(_timeText)) {
				_timeText.x = _bg.width - _timeText.width - 50;
				_timeText.y = (_bg.height - _timeText.height) / 2;
			}
			if (_shrink && contains(_shrink)) {
				_shrink.x = _bg.width - _shrink.width - 20;
				_shrink.y = (_bg.height - _shrink.height) / 2;
			}
			if (_title && contains(_title)) {
				_title.x = 25;
				_title.y = (_bg.height - _title.height) / 2;
//				_title.width = centerX - 35;
				Util.shortenText(_title, (_tipLeft.x - 40));
			}
			
			changeScaleStyle();
		}
		
		private function changeScaleStyle():void {
			_fifty["seleted"] = _videoShowScaleIndex == 0;
			_seventyFive["seleted"] = _videoShowScaleIndex == 1;
			_hundred["seleted"] = _videoShowScaleIndex == 2;
			_full["seleted"] = _videoShowScaleIndex == 3;
		}
		
		public function listen(event:String, data:Object):void {
			switch (event) {
				case SkinEvents.SHOW_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":0});
					}
					break;
				case SkinEvents.HIDE_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":-height});
					}
					break;
				case SkinEvents.RESIZE : 
					TweenLite.killTweensOf(this);
					resize();
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
			_fifty.mouseEnabled = false;
			_seventyFive.mouseEnabled = false;
			_hundred.mouseEnabled = false;
			_full.mouseEnabled = false;
		}
		
		private function hideBackRec(data:Object):void {
			_canShow = true;
			_fifty.mouseEnabled = true;
			_seventyFive.mouseEnabled = true;
			_hundred.mouseEnabled = true;
			_full.mouseEnabled = true;
		}
		
		private function videoCanStart(data:Object):void {
			this.visible = true;
		}
		
	}
}