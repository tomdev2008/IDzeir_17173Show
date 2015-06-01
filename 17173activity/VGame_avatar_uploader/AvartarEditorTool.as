package  {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.events.Event;
	
	public class AvartarEditorTool extends Sprite{
		
		private static const W:Number = 160;
		private static const H:Number = 160;
		
		protected var _hitRect:Rectangle = null;
		protected var _width:Number = 160;
		protected var _height:Number = 160;
		protected var _outWidth:Number = 0;
		protected var _outHeight:Number = 0;
		protected var _moveCursor:Sprite = null;
		protected var _dragCursor:Sprite = null;
		protected var _bg:Sprite = null;
		protected var _showRect:Rectangle = null;
		protected var _drag:DragUtil = null;
		
		public function AvartarEditorTool(outWidth:Number, outHeight:Number, bound:Rectangle) {
			// constructor code
			_hitRect = bound;
			_outWidth = outWidth;
			_outHeight = outHeight;
		}
		
		public function initWithConfig(config:Object):void {
			_moveCursor = config.cursor.move;
			_dragCursor = config.cursor.drag;
			_width = config.width;
			_height = config.height;
			
			init();
		}
		
		protected function init():void {
			calcShowRect();
			
			_bg = new Sprite();
			addChild(_bg);
			
			showCursor();
			
			update();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function calcShowRect():void {
			_showRect = new Rectangle();
			var w:Number = _hitRect.width < _width ? 
				_hitRect.width : W;
			var h:Number = _hitRect.height < _height ? 
				_hitRect.height : H;
			_showRect.width = _showRect.height = int(w < h ? w : h);
			_showRect.x = int(_hitRect.x + (_hitRect.width - _showRect.width) / 2);
			_showRect.y = int(_hitRect.y);
		}
		
		protected function showCursor():void {
			if (_moveCursor) {
				_moveCursor.visible = false;
				addChild(_moveCursor);
			}
			if (_dragCursor) {
				_dragCursor.visible = true;
				addChild(_dragCursor);
			}
		}
		
		protected function onAdded(e:Event):void {
			waitForInput();
		}
		
		protected function waitForInput():void {
			if (!_drag) _drag = new DragUtil(stage);
			_drag.addWatch(_dragCursor, 
						   function (delta:Point, isComplete:Boolean = false):void {
								//trace("drag: " + delta);
								
								if (predict(0, 0, delta.x, delta.y)) {
								_showRect.width += delta.x;
								_showRect.height += delta.y;
								update(isComplete);
							} else if (isComplete) {
								update(isComplete);
							}
						   });
			_drag.addWatch(parent, 
						   function (delta:Point, isComplete:Boolean = false):void {
								//trace("move: " + delta);
								
								if (predict(delta.x, delta.y, 0, 0)) {
									_showRect.x += delta.x;
									_showRect.y += delta.y;
									update(isComplete);
								} else if (isComplete) {
									update(isComplete);
								}
					 		});
								
		}
		
		protected function predict(x:Number, y:Number, width:Number, height:Number):Boolean {
			if (x == 0 && y == 0 && width == 0 && height == 0) return false;
			
			var comp:Rectangle = _showRect.clone();
			comp.x += x;
			comp.y += y;
			comp.width += width;
			comp.height += height;
			
			var inside:Boolean = _hitRect.containsRect(comp);
			return inside;
		}
		
		public function update(notify:Boolean = true):void {
			render();
			//trace("Current preview rect: " + _showRect);
			if (notify) {
				dispatch();
			}
		}
		
		protected function render(pixelPerfect:Boolean = false):void {
			drawLayer();
			_dragCursor.x = _showRect.right + 5;
			_dragCursor.y = _showRect.bottom;
		}
		
		protected function drawLayer():void {
			var g:Graphics = _bg.graphics;
			g.clear();
			g.beginFill(0xFFFFFF, 0.7);
			g.drawRect(0, 0, _outWidth, _outHeight);
			g.lineStyle(1, 0xCCCCCC);
			g.drawRect(_showRect.x, _showRect.y, _showRect.width, _showRect.height);
			g.endFill();
		}
		
		protected function dispatch():void {
			dispatchEvent(new Event("updated"));
		}
		
		public function get currentRect():Rectangle {
			return _showRect.clone();
		}
		
		public function dispose():void {
			if (_moveCursor) {
				removeChild(_moveCursor);
				_moveCursor.visible = false;
				_moveCursor = null;
			}
			if (_dragCursor) {
				removeChild(_dragCursor);
				_dragCursor.visible = false;
				_dragCursor = null;
			}
			
			_drag.dispose();
			_drag = null;
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

	}
	
}
