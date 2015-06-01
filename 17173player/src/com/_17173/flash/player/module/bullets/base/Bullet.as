package com._17173.flash.player.module.bullets.base
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.module.bullets.BulletFaceManager;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextLine;
	import flash.utils.getTimer;

	//import 
	
	
	public class Bullet extends Sprite
	{
		protected var _bp:Bitmap = null;
		protected var _data:BulletData = null;
		protected var _lineIndex:int = 0;
		protected var _baseTime:int = 0;
		protected var _tf:TextField = null;
		protected var _format:TextFormat = null;
		protected var _bulletType:String = BulletConfig.BULLETTYPE_NORMAL;
		protected var _line:TextLine = null;
		protected var _block:TextBlock = null;
		protected var _rawContent:String = null;
		
		protected var _d:Boolean = false;
		
		public function Bullet()
		{
			super();
//			_bp = new Bitmap();
//			_bp.smoothing = true;
//			_bp.pixelSnapping = PixelSnapping.ALWAYS;
//			addChild(_bp);
//			_tf = new TextField();
//			_tf.autoSize = TextFieldAutoSize.LEFT;
//			_format = new TextFormat();
//			_format.bold = true;
//			_tf.defaultTextFormat = _format;
//			addChild(_tf);
			_block = new TextBlock();
		}
		
		protected function onAdded(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			var w:int = stage.fullScreenWidth;
			var t:int = w / _data.speed;
			//t = 30;
			//Ticker.anim(t * 1000, this).addProp("x", -this.width).onComplete = function ():void {_d = true;};
     		//TweenLite.to(this, t, {x:-this.width, onComplete:function ():void {_d = true;}, ease:Linear.easeNone});
			//TweenLite.to(this, t, {x:-this.width, onComplete:function ():void {_d = true;}});
			TweenLite.to(this, t, {x:-this.width, onComplete:function ():void {_d = true;},ease:Linear.easeNone});
		}
		
		public function init(data:BulletData):void {
			if (!stage) {
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			} else {
				onAdded(null);
			}
			_data = data;
			_d = false;
			
			if (_line && _line.parent) {
				_line.parent.removeChild(_line);
			}
			var t1:Number = getTimer();
			var des:FontDescription = new FontDescription(Util.getDefaultFontNotSysFont(), "bold");
			var fmt:ElementFormat = new ElementFormat(des);
			fmt.fontSize = data.textSize;
//			fmt.alpha = 0.7;
//			fmt.color = 0xffff00;
			fmt.color = data.textColor;
			_block new TextBlock();
//			var sayString:String = Util.validateStr(data.userName) ? data.userName + ":" + data.content : data.content;
			var userSay:String = "";
			if(Util.validateStr(data.userName)){
				userSay = data.userName + ":";
			}else{
				var nick:String = data.masterNick;
				var toNick:String = data.toMasterNick;
				if(nick && toNick){
					userSay = nick + " 对 " + toNick + "说:";
				}else if(nick){
					userSay = nick + "说:";
				}
			}
			var content:String = data.content;
			_rawContent = data.content;
			_block.content = BulletFaceManager.getInstance().decodeString(userSay,content,fmt);
			_line = _block.createTextLine();
			_line.y = _line.height;
			addChild(_line);
			
//			cacheAsBitmap = true;
			
//			if (_tf == null) {
//				_tf = new TextField();
//				_tf.autoSize = TextFieldAutoSize.LEFT;
//			}
//			var format:TextFormat = new TextFormat();
//			_format.size = data.textSize;
//			_format.color = data.textColor;
////			format.bold = true;
//			_tf.defaultTextFormat = _format;
//			_tf.setTextFormat(_format);
//			_tf.text = Util.validateStr(data.userName) ? data.userName + ":" + data.content : data.content;
			
//			var bd:BitmapData = new BitmapData(_tf.width, _tf.height, true, 0x00FFFFFF);
//			bd.draw(_tf);
//			
//			if (_bp.bitmapData) {
//				_bp.bitmapData.dispose();
//			}
//			_bp.bitmapData = bd;
		}
		
		private function onUpdate():void {
			
		}
		
		public function update():void {
			return;
			var ellaps:int = 0;
			if (_baseTime == 0) {
				_baseTime = getTimer();
			} else {
				var t:int = getTimer();
				ellaps = t - _baseTime;
				_baseTime = t;
			}
			if (!_data.isSteady) {
				this.x -= ellaps * _data.speed / 1000;
			}
		}
		
		public function get isTimeToDisappear():Boolean {
			return _d;
			if (_data) {
				if (_data.isSteady) {
					return (getTimer() - _baseTime) > _data.duration;
				} else {
					return this.x <= -this.width;
				}
			}
			return false;
		}
		
		public function get bulletData():BulletData {
			return _data;
		}

		public function get lineIndex():int {
			return _lineIndex;
		}

		public function set lineIndex(value:int):void {
			_lineIndex = value;
		}
		
		public function get content():String{
			return _rawContent;
		}
	}
}