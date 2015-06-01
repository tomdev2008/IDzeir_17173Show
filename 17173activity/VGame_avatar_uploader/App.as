package  {
	import flash.display.DisplayObjectContainer;
	import flash.net.FileFilter;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	public class App {
		
		private var _uploader:AssetUploader = null;
		private var _editor:AvartarEditor = null;
		private var _preview:CircleMaskDisplay = null;
		
		public function App(config:Object) {
			_uploader = new AssetUploader(
										  [new FileFilter(
												config.uploader.filter.description, 
												config.uploader.filter.extensions.join(";")
											)
										  ]
										 );
			_editor = new AvartarEditor();
			_editor.initWithConfig(config.editor);
			_preview = new CircleMaskDisplay();
			_preview.initWithConfig(config.preview);
		}
		
		public function loadAsset(onSucc:Function = null, 
								  onFail:Function = null):void {
			_uploader.onSucc = onSucc;
			_uploader.onFail = onFail;
			_uploader.load();
		}
		
		public function startEditing(asset:Bitmap, onUpdate:Function = null):DisplayObject{
			_editor.avartar = asset;
			_editor.onUpdate = onUpdate;
			_editor.edit();
			return _editor;
		}
		
		public function get preview():CircleMaskDisplay {
			return _preview;
		}
		
		public function preventInteractive(target:DisplayObjectContainer):void {
			var rect:Rectangle = target.getBounds(target);
			var shape:Shape = new Shape();
			shape.name = "__interactive_mask";
			shape.graphics.beginFill(0, 0);
			shape.graphics.drawRect(0, 0, rect.width, rect.height);
			shape.graphics.endFill();
			target.addChild(shape);
		}
		
		public function clearInteractive(target:DisplayObjectContainer):void {
			var shape:DisplayObject = target.getChildByName("__interactive_mask");
			if (shape) {
				target.removeChild(shape);
			}
		}
		
		public function saveImage():void {
			if (_preview.data) {
				
			}
		}
		
		public function cancelImage():void {
			_preview.hide();
			_editor.reset();
			if (_preview.parent) {
				_preview.parent.removeChild(_preview);
			}
			if (_editor.parent) {
				_editor.parent.removeChild(_editor);
			}
		}

	}
	
}
