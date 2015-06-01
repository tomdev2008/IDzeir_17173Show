package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class AdTimeComp extends Sprite
	{
		
		private static const MUTE:SoundTransform = new SoundTransform(0);
		private static const UNMUTE:SoundTransform = new SoundTransform(1);
		private var _currentSound:SoundTransform = null;
		private var _soundTarget:Object = null;
		private var _time:int = 0;
		
		private var _text:TextField = null;
		private var _btn:MovieClip = null;
		private var _btnSp:Sprite = null;
		
		private static const text:String = "<FONT COLOR='#FFFFFF'>广告剩余时间: <FONT FACE='{0}' SIZE='18' COLOR='#FDCD00'>{1}</FONT> 秒</FONT>";
		
		public function AdTimeComp()
		{
			super();
			this.mouseChildren = false;
			this.useHandCursor = true;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onMute);
			// 默认有声音
			_currentSound = UNMUTE;
			// 创建界面
			initUI();
		}
		
		public function set soundUI(value:Object):void
		{
			_soundTarget = value && value.hasOwnProperty("soundTransform") ? value : null;
			applySound();
		}
		
		protected function initUI():void {
			_text = new TextField();
			_text.htmlText = "<FONT COLOR='#FFFFFF'>广告剩余时间:   秒</FONT>";
			_text.autoSize = TextFieldAutoSize.LEFT;
			addChild(_text);
			
			_btn = new mc_soundBtn();
			_btn.stop();
			_btnSp = new Sprite();
			_btnSp.addChild(_btn);
			_btnSp.x = _text.x + _text.width + 25;
			addChild(_btnSp);
		}
		
		protected function onMute(e:MouseEvent):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			var isMute:Boolean = _currentSound == UNMUTE;
			_currentSound = isMute ? MUTE : UNMUTE;
			_btn.gotoAndStop(isMute ? 2 : 1);
			
			applySound();
		}
		
		protected function applySound():void {
			if (_soundTarget) {
				_soundTarget.soundTransform = _currentSound;
			}
		}
		
		public function set time(value:int):void {
			_time = value;
			_text.htmlText = text.replace("{0}", Util.getDefaultFontNotSysFont()).replace("{1}", _time);
			
			graphics.clear();
			graphics.beginFill(0x000000, 0.7);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}
		
		public function dispose():void {
			_soundTarget = null;
			_currentSound = null;
		}
	}
}