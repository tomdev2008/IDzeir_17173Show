package  {
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	public class CircleMaskDisplay extends Sprite{
		
		protected var _width:Number = 160;
		protected var _height:Number = 160;
		
		protected var _bitmap:Bitmap = null;
		protected var _mask:Shape = null;
		
		public function CircleMaskDisplay(width:Number = 160, height:Number = 160) {
			// constructor code
			_width = width;
			_height = height;
		}
		
		public function initWithConfig(config:Object):void {
			_width = config.width;
			_height = config.height;
			
			_bitmap = new Bitmap();
			_mask = new Shape();
			_mask.graphics.lineStyle(1, 0xCCCCCC);
			_mask.graphics.beginFill(0xFFFFFF, 1);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.drawCircle(_width / 2, _height / 2, _width < _height ? _width / 2 : _height / 2);
			_mask.graphics.endFill();
		}
		
		public function set image(value:Bitmap):void {
			if (value && value.bitmapData && value.bitmapData.width > 0) {
				show();
				
				var sw:Number = _width / value.bitmapData.width;
				var sh:Number = _height / value.bitmapData.height;
				var s:Number = sw > sh ? sw : sh;
				var m:Matrix = new Matrix();
				m.scale(s, s);
				var bd:BitmapData = new BitmapData(_width, _height);
				bd.draw(value, m);
				_bitmap.bitmapData = bd;
			}
		}
		
		public function get data():BitmapData {
			return _bitmap.bitmapData ? _bitmap.bitmapData : null;
		}
		
		public function show():void {
			addChild(_bitmap);
			addChild(_mask);
		}
		
		public function hide():void {
			_bitmap.bitmapData = null;
			while (numChildren) {
				removeChildAt(0);
			}
		}

	}
	
}
