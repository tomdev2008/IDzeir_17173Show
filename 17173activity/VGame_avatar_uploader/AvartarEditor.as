package  {
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.display.Graphics;
	import fl.transitions.TweenEvent;
	
	public class AvartarEditor extends Sprite{
		
		protected var _original:Bitmap = null;
		protected var _onUpdate:Function = null;
		protected var _width:Number = 300;
		protected var _height:Number = 300;
		
		// main part to construct the editor
		protected var _avartar:Bitmap = null;
		protected var _tool:AvartarEditorTool = null;
		
		protected var _avartarRect:Rectangle = new Rectangle();
		protected var _config:Object = null;
		
		public function AvartarEditor(width:Number = 300, height:Number = 300, avartar:Bitmap = null, onUpdate:Function = null) {
			// constructor code
			this.width = width;
			this.height = height;
			this.avartar = avartar;
			this.onUpdate = onUpdate;
		}
		
		public function initWithConfig(config:Object):void {
			_config = config;
			this.width = _config.width;
			this.height = _config.height;
		}
		
		override public function set width(value:Number):void {
			_width = value;
		}
		
		override public function get width():Number {
			return _width;
		}
		
		override public function set height(value:Number):void {
			_height = value;
		}
		
		override public function get height():Number {
			return _height;
		}
		
		public function set avartar(value:Bitmap):void {
			if (value != null) _original = value;
		}
		
		public function set onUpdate(value:Function):void {
			if (value != null) _onUpdate = value;
		}
		
		public function edit(avartar:Bitmap = null, onUpdate:Function = null):void {
			this.avartar = avartar;
			this.onUpdate = onUpdate;
			
			if (_original == null) {
				trace("No available assets for editing!");
				return;
			}
			
			trace("Start editing!");
			init();
		}
		
		protected function init():void {
			// reset everything needs to
			reset();
			// draw a default background to indicate the rectangle of this editor
			drawBG();
			// create and add avartar
			createAvartar();
			// anim
			animToShow(
					   function ():void {
						   _tool = new AvartarEditorTool(_width, _height, _avartarRect);
						   _tool.initWithConfig(_config.tool);
						   addChild(_tool);
						   _tool.addEventListener("updated", onToolUpdate);
						   
						   _tool.update(true);
					   }
					   );
		}
		
		protected function onToolUpdate(e:Object):void {
			var r:Rectangle = _tool.currentRect;
			r.x -= _avartarRect.x;
			r.y -= _avartarRect.y;
			// simple pixel perfect
			r.x = int(r.x / _avartar.scaleX);
			r.y = int(r.y / _avartar.scaleY);
			r.width = int(r.width / _avartar.scaleX);
			r.height = int(r.height / _avartar.scaleY);
			
			var resultBD:BitmapData = new BitmapData(r.width, r.height);
			resultBD.copyPixels(_avartar.bitmapData, r, new Point());
			if (_onUpdate != null) {
				_onUpdate.apply(null, [new Bitmap(resultBD)]);
			}
		}
		
		protected function drawBG():void {
			var g:Graphics = graphics;
			g.clear();
			g.lineStyle(1, 0xCCCCCC);
			g.beginFill(0xF9F9F9, 1);
			g.drawRect(0, 0, _width, _height); // to show border
			g.endFill();
		}
		
		protected function createAvartar():void {
			calculateAvartarRect();
			_avartar = new Bitmap();
			_avartar.bitmapData = _original.bitmapData;
			_avartar.scaleX = _avartar.scaleY = _avartarRect.width / _original.bitmapData.width;
			_avartar.x = _avartarRect.x;
			_avartar.y = _avartarRect.y;
			_avartar.width = int(_avartar.width);
			_avartar.height = int(_avartar.height);
			addChild(_avartar);
		}
		
		protected function calculateAvartarRect():Rectangle {
			_avartarRect.setEmpty();
			
			var sw:Number = _width / _original.bitmapData.width;
			var sh:Number = _height / _original.bitmapData.height;
			var s:Number = sw < sh ? sw : sh;
			var w:Number = _original.bitmapData.width * s;
			var h:Number = _original.bitmapData.height * s;
			
			_avartarRect.width = w;
			_avartarRect.height = h;
			_avartarRect.x = (_width - w) / 2;
			_avartarRect.y = (_height - h) / 2;
			
			return _avartarRect;
		}
		
		protected function animToShow(onComplete:Function):void {
			_avartar.alpha = 0;
			var t:Tween = new Tween(_avartar, "alpha", None.easeIn, 0, 1, 5);
			t.addEventListener(TweenEvent.MOTION_FINISH, function (e:TweenEvent):void {
							   	if (onComplete != null) {
									onComplete.apply(null, null);
								}
							   });
			t.start();
		}
		
		public function reset():void {
			if (_avartar) {
				if (_avartar.bitmapData) {
					_avartar.bitmapData.dispose();
					_avartar.bitmapData = null;
				}
				if (_avartar.parent) {
					_avartar.parent.removeChild(_avartar);
				}
				_avartar = null;
			}
			if (_tool) {
				_tool.dispose();
				removeChild(_tool);
				_tool = null;
			}
		}

	}
	
}
