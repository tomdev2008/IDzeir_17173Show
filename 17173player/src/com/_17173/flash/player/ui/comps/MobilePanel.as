package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class MobilePanel extends Sprite
	{
		//		private var _mobilePanel:MovieClip = null;
		private var _pic:Pic = null;
		private var _Label1:TextField = null;
		private var _Label2:TextField = null;
		private var _format1:TextFormat = null;
		private var _format2:TextFormat = null;
		private var _closeBtn:MovieClip = null;
		private var _installBtn:MovieClip = null;
		private var _bg:Sprite = null;
		
		public function MobilePanel()
		{
			super();
			
			_bg = new Sprite();
			addChild(_bg);
			
			_pic = new Pic();
			_pic.width = 150;
			_pic.height = 150;
			_pic.content = "http://i3.v.17173cdn.com/upload/vlog/20131021/174230/9324b4dc-6b67-43ea-981c-773345f41017.jpg";
			addChild(_pic);
			
			_format1 = new TextFormat();
			_format1.size = 22;
			_format1.color = 0xfdcd00;
			_format1.font = Util.getDefaultFontNotSysFont();
			_Label1 = new TextField();
			_Label1.selectable = false;
			_Label1.text = "17173手机APP";
			_Label1.autoSize = TextFieldAutoSize.LEFT;
			_Label1.defaultTextFormat = _format1;
			_Label1.setTextFormat(_format1);
			addChild(_Label1);
			
			_format2 = new TextFormat();
			_format2.size = 12;
			_format2.color = 0xb9b9b9;
			_format2.font = Util.getDefaultFontNotSysFont();
			_Label2 = new TextField();
			_Label2.selectable = false;
			_Label2.multiline = true;
			_Label2.htmlText = "轻松一扫，<br>百万视频装进口袋！<br>抽空一看，<br>游戏水平显著提高！";
			_Label2.width = 154;
			_Label2.height = 78;
			_Label2.defaultTextFormat = _format2;
			_Label2.setTextFormat(_format2);
			addChild(_Label2);
			
			_closeBtn = new mobelCloseBtn();
			addChild(_closeBtn);
			
			_closeBtn.addEventListener(MouseEvent.CLICK, closeThis);
			
			_installBtn = new mc_install_btn();
			addChild(_installBtn);
			
			init();
			resize();
		}
		
		private function init():void
		{
			//			_mobilePanel = new mc_mobile_popup();
			//			addChild(_mobilePanel);
			_installBtn.addEventListener(MouseEvent.CLICK, function (e:Event):void {
//				if(Global.settings.isFullScreen)
				if(Context.getContext(ContextEnum.SETTING)["isFullScreen"])
				{
					Context.stage.displayState = StageDisplayState.NORMAL;
				}
				Util.toUrl("http://a.17173.com/");
			});
		}
		
		private function closeThis(evt:MouseEvent):void {
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(true);
			Context.getContext(ContextEnum.UI_MANAGER).closePopup(this);
//			Global.videoManager.togglePlay(true);
//			Global.uiManager.closePopup(this);
		}
		
		public function resize():void
		{
			var w:Number = 460;
			var h:Number = 235;
			if (w > Context.stage.stageWidth) {
				w = Context.stage.stageWidth;
			}
			if (_bg && contains(_bg)) {
				_bg.graphics.clear();
				_bg.graphics.beginFill(0x010a0d, 0.9);
				_bg.graphics.drawRect(0, 0, w, h);
				_bg.graphics.endFill();
			}
			if(_pic && contains(_pic))
			{
				_pic.x = 68;
				_pic.y = 37;
			}
			if(_Label1 && contains(_Label1))
			{
				_Label1.x = 235;
				_Label1.y = 37;
			}
			
			if(_Label2 && contains(_Label2))
			{
				_Label2.x = 235;
				_Label2.y = 75;
			}
			
			if (_closeBtn && contains(_closeBtn)) {
				_closeBtn.x = width - _closeBtn.width;
				_closeBtn.y = 0;
			}
			
			if (_installBtn && contains(_installBtn)) {
				_installBtn.x = 235;
				_installBtn.y = 165;
			}
		}
	}
}