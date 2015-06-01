package com._17173.flash.player.ui.comps.progressbar
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ControlBarProgressTip extends Sprite
	{
		
		private static const w:int = 40;
		private static const h:int = 30;
		private static const sw:int = 10;
		private static const sh:int = 10;
		private static const c:int = 5;
		
		private var _bg:Shape = null;
		private var _tf:TextField = null;
		private var _time:int = 0;
		private var _trueTime:int = 0;
		
		public function ControlBarProgressTip()
		{
			super();
			
			_bg = new Shape();
			var g:Graphics = _bg.graphics;
			g.beginFill(0x474747);
			g.moveTo(c, 0);
			g.lineTo(w - c, 0);
			g.curveTo(w, 0, w, c);
			g.lineTo(w, h - c);
			g.curveTo(w, h, w - c, h);
			g.lineTo((w + sw) / 2, h);
			g.lineTo(w / 2, h + sh);
			g.lineTo((w - sw) / 2, h);
			g.lineTo(c, h);
			g.curveTo(0, h, 0, h - c);
			g.lineTo(0, c);
			g.curveTo(0, 0, c, 0);
			g.endFill();
			addChild(_bg);
			_bg.x = -w / 2;
			_bg.y = -h;
			
			_tf = new TextField();
			_tf.width = _bg.width;
			_tf.height = _bg.height;
			_tf.autoSize = TextFieldAutoSize.CENTER;
			_tf.selectable = false;
			var fm:TextFormat = new TextFormat();
			fm.size = 12;
			fm.color = 0xFFFFFF;
			_tf.defaultTextFormat = fm;
			addChild(_tf);
			_tf.x = (width - _tf.width) / 2 + _bg.x;
			_tf.y = (height - sh - _tf.height) / 2 + _bg.y;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		public function set time(value:int):void {
			_trueTime = value;
			if (value == _time) return;
			_time = value;
			_tf.text = formatTimeString(_time);
			_tf.x = (width - _tf.width) / 2 + _bg.x;
			_tf.y = (height - sh - _tf.height) / 2 + _bg.y;
		}
		
		public function get time():int {
			return _trueTime;
		}
		
		private function formatTimeString(sec:int):String {
			var min:int = sec / 60;
			sec = sec % 60;
			var str:String = "";
			str += min < 10 ? "0" + min : min;
			str += ":";
			str += sec < 10 ? "0" + sec : sec;
			return str;
		}
		
	}
}