package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 图片控件.
	 * 支持bitmap/bitmapData/url.
	 * 自动缩放居中显示.需要设置该控件的width/height. 
	 * @author shunia-17173
	 */	
	public class Pic extends Sprite
	{
		
		private var _w:Number = 0;
		private var _h:Number = 0;
		private var _isFit:Boolean = true;
		private var _showBorder:Boolean = false;
		private var _borderColor:uint = 0;
		private var _borderThickness:int = 1;
		private var _borderAlpha:Number = 1;
		private var _showBackground:Boolean = false;
		private var _backgroundColor:uint = 0;
		private var _backgroundAlpha:Number = 1;
		
		private var _graphic:Shape = null;
		
		private var _url:String = null;
		private var _loading:MovieClip = null;
		private var _loaded:Boolean = false;
		
		public function Pic()
		{
			super();
			_loading = new mc_picLoading();
			addChild(_loading);
			
			_loaded = false;
			resize();
		}
		
		/**
		 * bitmap/bitmapdata/url 
		 * @param value
		 */		
		public function set content(value:Object):void {
			if (value is Bitmap) {
				addChild(Bitmap(value));
				_loaded = true;
				onContentSet();
			} else if (value is BitmapData) {
				var bp:Bitmap = new Bitmap(BitmapData(value));
				addChild(bp);
				_loaded = true;
				onContentSet();
			} else {
				if (value) {
					_url = value.hasOwnProperty("toString") ? value["toString"]() : String(value);
					loadAssets(_url);
					_loaded = false;
					onContentSet();
				}
			}
		}
		
		public function set isfit(value:Boolean):void {
			_isFit = value;
		}
		
		public function get isfit():Boolean {
			return _isFit;
		}
		
		private function loadAssets(url:String):void {
			if (Util.validateStr(url) && url.indexOf("://") != -1) {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = new LoaderProxyOption(
					url, LoaderProxyOption.FORMAT_IMAGE, LoaderProxyOption.TYPE_ASSET_LOADER, onLoadComplete, onLoadFail
				);
				loader.load(option);
			}
		}
		
		private function onLoadFail(data:Object):void {
			Debugger.tracer("Pic load fail: " + _url);
		}
		
		private function onLoadComplete(data:DisplayObject):void {
			if (data) {
				_loaded = true;
				addChild(data);
				//不自适应的话,用显示对象本身的高宽作为当前高宽
				if (!isfit && (_w <= 0 || _h <= 0)) {
					_w = data.width;
					_h = data.height;
				}
				this.dispatchEvent(new Event("loadComplete"));
				onContentSet();
			}
		}
		
		/**
		 * content已经设置完毕,开始更新高宽 
		 */		
		private function onContentSet():void {
			if (_loaded) {
				_loading.gotoAndStop(0);
				removeChild(_loading);
				_loading = null;
			}
			if(isfit) {
				resize();
			}
			updateGraphic();
		}
		
		public function resize():void {
			if (_w > 0 && _h > 0 && numChildren > 0) {
				if (!_loaded) {
					if (_loading) {
						_loading.x = (_w - _loading.width) / 2;
						_loading.y = (_h - _loading.height) / 2;
					}
				} else {
					for (var i:int = 0; i < numChildren; i ++) {
						var child:DisplayObject = getChildAt(i);
						if (child == _graphic) continue;
						if (child.width > 0 && child.height > 0) {
							child.scaleX = child.scaleY = 1;
							var scaleX:Number = _w / child.width;
							var scaleY:Number = _h / child.height;
							var scale:Number = scaleX < scaleY ? scaleX : scaleY;
							child.scaleX = child.scaleY = scale;
						}
						child.x = (_w - child.width) / 2;
						child.y = (_h - child.height) / 2;
					}
				}
			}
		}
		
		/**
		 * 画边框及背景 
		 */		
		private function updateGraphic():void {
			if (_graphic == null) {
				_graphic = new Shape();
			}
			_graphic.graphics.clear();
			
			if (_showBorder || _showBackground) {
				if (_showBorder) {
					_graphic.graphics.lineStyle(_borderThickness, _borderColor, _borderAlpha);
				}
				var alp:Number = 0;
				if (_showBackground) {
					alp = _backgroundAlpha;
				}
				_graphic.graphics.beginFill(_backgroundColor, alp);
				_graphic.graphics.drawRect(0, 0, _w, _h);
				_graphic.graphics.endFill();
			}
			//始终提到上层
			addChild(_graphic);
		}
		
		override public function set width(value:Number):void {
			_w = value;
			resize();
		}
		
		override public function set height(value:Number):void {
			_h = value;
			resize();
		}
		
		override public function get width():Number {
			return _w;
		}
		
		override public function get height():Number {
			return _h;
		}

		public function get showBorder():Boolean {
			return _showBorder;
		}

		public function set showBorder(value:Boolean):void {
			_showBorder = value;
		}

		public function get borderColor():uint {
			return _borderColor;
		}

		public function set borderColor(value:uint):void {
			_borderColor = value;
		}

		public function get showBackground():Boolean {
			return _showBackground;
		}

		public function set showBackground(value:Boolean):void {
			_showBackground = value;
		}

		public function get backgroundColor():uint {
			return _backgroundColor;
		}

		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
		}

		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}

		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
		}

		public function get borderThickness():int
		{
			return _borderThickness;
		}

		public function set borderThickness(value:int):void
		{
			_borderThickness = value;
		}

		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}

		public function set borderAlpha(value:Number):void
		{
			_borderAlpha = value;
		}
		
	}
}