package com._17173.flash.player.ui.comps.backRecommend
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class BackRecTopBar extends Sprite
	{
		private var _title:TextField = null;
		private var _more:TextField = null;
		private var _rightbar:MovieClip = null;
		private var _bg:Sprite = null;
		private var _moreUrl:String = "";
		private var _moreC:Sprite = null;
		private var _thisWidth:Number = 0;
		
		public function BackRecTopBar(width:Number)
		{
			super();
			
			_thisWidth = width;
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawRect(0, 0, width, 60);
			_bg.graphics.endFill();
			addChild(_bg);
			
			addRightBar();
			
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
			
			resize();
			init();
		}
		
		protected function get titleColor():uint {
			return 0xfdcd00; 
		}
		
		protected function addMoreC():void
		{
			var format:TextFormat = new TextFormat();
			format.color = 0x5c5c5c;
			format.size = 14;
			format.font = Util.getDefaultFontNotSysFont();
			
			_moreC = new Sprite();
			addChild(_moreC);
			
			_more = new TextField();
			_more.text = "";
			_more.autoSize = TextFieldAutoSize.LEFT;
			_more.selectable = false;
			_more.defaultTextFormat = format;
			_more.setTextFormat(format);
			_moreC.addChild(_more);
		}
		
		protected function addRightBar():void
		{
			_rightbar = new mc_backRec_topRight();
			addChild(_rightbar);
		}
		
		private function init():void
		{
			if (_rightbar) {
				_rightbar.addEventListener("onReplay", onReplay);
				_rightbar.addEventListener("onShare", onShare);
				_rightbar.addEventListener("onTalk", onTalk);
			}
			
			if (_moreC) {
				_moreC.addEventListener(MouseEvent.CLICK, moreClickHandler);
			}
		}
		
		private function moreClickHandler(evt:MouseEvent):void
		{
			var vd:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			var url:String = FileDataRetriver.VIDEO_SERACH_LIST_URL + (vd as FileVideoData).aClass + "/sc/" + (vd as FileVideoData).bClass + "/";
//			var url:String = FileDataRetriver.VIDEO_SERACH_LIST_URL + (Global.videoData as FileVideoData).aClass + "/sc/" + (Global.videoData as FileVideoData).bClass + "/";
			Util.toUrl(url);
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		private function onReplay(evt:Event):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.REPLAY_THE_VIDEO);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//			Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
		}
		
		private function onShare(evt:Event):void
		{
//			Global.eventManager.send(PlayerEvents.UI_SHOW_SHARE);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function onTalk(evt:Event):void
		{
//			Global.eventManager.send(PlayerEvents.UI_SHOW_TALK);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_TALK);
		}
		
		public function setInfo(title:String, moreLabel:String, moreUrl:String):void
		{
			_title.text = title;
//			var tw:Number = (_bg.width - _rightbar.width) * 0.5;
			if(moreLabel != "" && moreUrl != "" && _moreC)
			{
				_more.text = "更多" + moreLabel + "视频";
				_moreUrl = moreUrl;
				_moreC.buttonMode = true;
				_moreC.mouseChildren = false;
			}
			resize();
		}
		
		public function resize():void
		{
			if(_rightbar && contains(_rightbar))
			{
				_rightbar.x = _thisWidth - _rightbar.width - 10;
				_rightbar.y = (_bg.height - _rightbar.height) / 2;
			}
			if (_moreC && contains(_moreC)) {
//				if(_more.width > 140)
//				{
//					_more.text = Util.formatStringExceed(_more, 140);
//				}
				Util.shortenText(_more, 140);
				_moreC.x = _rightbar.x - _moreC.width  - 10;
				_moreC.y = (_bg.height - _moreC.height) / 2;
			}
			if (_title && contains(_title)) {
				_title.x = 10;
				_title.y = (_bg.height - _title.height) / 2;
				var tempWidth:Number = _moreC ? _moreC.width : 0;
				Util.shortenText(_title, (_bg.width - (_moreC ? _moreC.width : 0) - (_rightbar ? _rightbar.width : 0) - 30));
			}
		}
	}
}