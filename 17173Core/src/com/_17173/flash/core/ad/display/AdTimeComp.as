package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class AdTimeComp extends Sprite
	{
		
		private var _time:int = 0;
		private var _isMute:Boolean = false;
		private var _sound:SoundTransform = null;
		private var _soundUI:Sprite = null;
		
		private var _text:TextField = null;
		private var _btn:MovieClip = null;
		
		private static const text:String = "<FONT COLOR='#FFFFFF'>广告剩余时间: <FONT FACE='{0}' SIZE='18' COLOR='#FDCD00'>{1}</FONT> 秒</FONT>";
		
		public function AdTimeComp()
		{
			super();
			_text = new TextField();
			_text.htmlText = "<FONT COLOR='#FFFFFF'>广告剩余时间:   秒</FONT>";
			_text.selectable = false;
			_text.mouseEnabled = false;
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.x = 4;
			addChild(_text);
			
			_btn = new mc_soundBtn();
			_btn.stop();
			_btn.useHandCursor = true;
			_btn.buttonMode = true;
			_btn.x = _text.x + _text.width + 25;
//			_btn.addEventListener(MouseEvent.CLICK, onMouseClick);
			addChild(_btn);
			var mask:Sprite = new Sprite();
			mask.graphics.clear();
			mask.graphics.beginFill(0xffffff, 0);
			mask.graphics.drawRect(0, 0, _btn.width, _btn.height);
			mask.graphics.endFill();
			mask.x = _btn.x;
			mask.buttonMode = true;
			mask.useHandCursor = true;
			mask.addEventListener(MouseEvent.CLICK, onMouseClick);
			addChild(mask);
			
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick1);
		}
		
		protected function onMouseClick1(event:MouseEvent):void {
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		protected function onMouseClick(event:MouseEvent):void {
			_isMute = !_isMute;
			if (_soundUI) {
				_sound = new SoundTransform();
				_sound.volume = _isMute ? 0 : 1;
				_soundUI.soundTransform = _sound;
			}
			_isMute ? _btn.gotoAndStop(2) : _btn.gotoAndStop(1);
			if (_isMute) {
				this.dispatchEvent(new Event("mute"));
			} else {
				this.dispatchEvent(new Event("notMute"));
			}
		}
		
		public function set time(value:int):void {
			_time = value;
			_text.htmlText = text.replace("{0}", Util.getDefaultFontNotSysFont()).replace("{1}", _time);
			
			graphics.clear();
			graphics.beginFill(0x000000, 0.7);
			graphics.drawRect(0, 0, _btn.x + _btn.width, height);
			graphics.endFill();
		}

		public function set soundUI(value:Sprite):void
		{
			_soundUI = value;
		}
	}
}