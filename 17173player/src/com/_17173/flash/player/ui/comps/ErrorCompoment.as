package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerErrors;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ErrorCompoment extends Sprite
	{
		private var _bg:Sprite = null;
		private var _logo:MovieClip = null;
		private var _title:TextField = null;
		private var _con:TextField = null;
		private var _code:TextField = null;
		private var _message:TextField = null;
		private var _textFormat:TextFormat = null;
		private var _container:Sprite = null;
		private var _titleString1:String = "<FONT SIZE='18' COLOR='#FFFFFF'>抱歉，目前无法观看视频，您可以尝试" + "<a href=\'event:refresh\'><u><FONT COLOR='#FDCD00'>刷新</FONT></u></a>" + "操作。</FONT>";
		private var _titleString2:String = "<FONT SIZE='18' COLOR='#FFFFFF'>抱歉，该视频已被删除。</FONT>";
		private var _conString1:String = "<FONT SIZE='14' COLOR='#FFFFFF'>如果问题仍未解决，请" + "<a href=\'event:back\'><u><FONT COLOR='#FDCD00'>反馈</FONT></u></a>" + "给我们</FONT>";
		private var _conString2:String = "<FONT SIZE='14' COLOR='#FFFFFF'>如果有异议，请" + "<a href=\'event:back\'><u><FONT COLOR='#FDCD00'>反馈</FONT></u></a>" + "给我们</FONT>";
		
		public function ErrorCompoment()
		{
			super();
			
			_bg = new Sprite();
			this.addChild(_bg);
			
			_container = new Sprite();
			this.addChild(_container);
			
			_logo = new mc_errorImage();
			_container.addChild(_logo);
			
			_textFormat = new TextFormat();
			_textFormat.font = Util.getDefaultFontNotSysFont();
			_textFormat.color = 0xffffff;
			
			_title = new TextField();
			_title.selectable = false;
			_title.autoSize = TextFieldAutoSize.LEFT;
			_title.defaultTextFormat = _textFormat;
			_title.htmlText = _titleString1;
			_container.addChild(_title);
			
			_con = new TextField();
			_con.selectable = false;
			_con.autoSize = TextFieldAutoSize.LEFT;
			_con.defaultTextFormat = _textFormat;
			_con.htmlText = _conString1;
			_container.addChild(_con);
			
			_code = new TextField();
			_code.selectable = false;
			_code.autoSize = TextFieldAutoSize.LEFT;
			_code.defaultTextFormat = _textFormat;
			_code.text = "";
			_container.addChild(_code);
			
			_message = new TextField();
			_message.selectable = false;
			_message.autoSize = TextFieldAutoSize.LEFT;
			_message.defaultTextFormat = _textFormat;
			_container.addChild(_message);
			
			init();
		}
		
		private function init():void
		{
			_title.addEventListener(TextEvent.LINK, onRefres);
			_con.addEventListener(TextEvent.LINK, onBack);
		}
		
		private function onRefres(evt:TextEvent):void
		{
			if (JSBridge.enabled) {
				JSBridge.addCall("window.location.reload", null, "");
			}
		}
		
		private function onBack(evt:TextEvent):void
		{
//			navigateToURL(new URLRequest("http://help.17173.com/help/wenti.shtml"), "_blank");
			Util.toUrl("http://help.17173.com/help/wenti.shtml");
		}
		
		public function showError(error:PlayerErrors):void
		{
			_code.text = error.id ? "代码:" + error.id : "";
			if (Context.getContext(ContextEnum.SETTING)["debug"]) {
				_message.text = error.error;
			}
			if (error.error == PlayerErrors.VIDEO_DELETE_OR_HIDE) {
				_title.htmlText = _titleString2;
				_con.htmlText = _conString2;
			} else {
				_title.htmlText = _titleString1;
				_con.htmlText = _conString1;
			}
		}
		
		public function resize():void
		{
			if(_bg && this.contains(_bg))
			{
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x000000);
//				_bg.graphics.drawRect(0, 0, Global.uiManager.avalibleVideoWidth, Global.uiManager.avalibleVideoHeight);
				_bg.graphics.drawRect(0, 0, Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth, Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight);
				_bg.graphics.endFill();
				_bg.x = 0;
				_bg.y = 0;
			}
			var tmp:int = 0;
			for (var i:int = 0; i < _container.numChildren; i ++) {
				var child:DisplayObject = _container.getChildAt(i);
				child.x = (_container.width - child.width) / 2;
				child.y = tmp;
				tmp = child.y + child.height + 20;
			}
//			if(_logo && this.contains(_logo))
//			{
//				_logo.x = (_container.width - _logo.width) / 2;
//				_logo.y = 0;
//			}
//			if(_title && this.contains(_title))
//			{
//				_title.x = (_container.width - _title.width) / 2;
//				_title.y = 115;
//			}
//			if(_con && this.contains(_con))
//			{
//				_con.x = (_container.width - _con.width) / 2;
//				_con.y = 160;
//			}
//			if(_code && this.contains(_code))
//			{
//				_code.x = (_container.width - _code.width) / 2;
//				_code.y = 215;
//			}
			if(_container && this.contains(_container))
			{
				_container.x = (_bg.width - _container.width) / 2;
				_container.y = (_bg.height - _container.height) / 2;
			}
		}
	}
}