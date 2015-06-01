package  {
	
	import flash.display.MovieClip;
	import flash.system.Security;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	
	/* 
	* Main class for the avatar_uploader.
	*/ 
	public class Document extends MovieClip {
		
		//version details, need to be updated with every release
		private static const VR:String = "[头像编辑器]";
		private static const VN:String = "2014.11.20|17:00";
		// logic function delegate
		private var _app:App = null;
		
		public function Document() {
			// default settings
			Security.allowDomain("*");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// context menu for version checking
			var c:ContextMenu = new ContextMenu();
			c.hideBuiltInItems();
			// version context item
			var verItem:ContextMenuItem = new ContextMenuItem(VR + VN, false, false);
			c.customItems = [];
			c.customItems.push(verItem);
			this.contextMenu = c;
			// listen for add to stage event to make sure everything is setted up
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(e:Event):void {
			// init here
			_app = new App(config);
			// logic
			btn_upload.addEventListener(MouseEvent.CLICK, onUpload);
		}
		
		protected function onUpload(e:MouseEvent):void {
			// prevent form user interacitve with stage
			_app.preventInteractive(stage);
			// load assets from user's hard drive
			_app.loadAsset(
				function (image:Bitmap):void {
					// if success, start editing
					img_full.addChild(_app.startEditing(image, function (bm:Bitmap):void {
									  	_app.preview.image = bm;
									  }));
					img_preview.addChild(_app.preview);
					// and clear the prevent-interactive layer
					_app.clearInteractive(stage);
				}, 
				function ():void {
					// if fail, clear prevent-interactive layer
					_app.clearInteractive(stage);
				}
			);
			// save btn listener for save image
			btn_save.addEventListener(MouseEvent.CLICK, function (e:Event):void {
									  	_app.saveImage();
									  });
			// cancel btn listener for clear current image and preview
			btn_cancel.addEventListener(MouseEvent.CLICK, function (e:Event):void {
											_app.cancelImage();
										});
		}
		
		// 
		protected function get config():Object {
			return {
				"editor" : 
					{
						"width" : img_full.width, 
						"height" : img_full.height, 
						"tool" : 
							{
								"width" : 160, 
								"height" : 160, 
								"cursor" : 
								{
									"move" : cursor_move, 
									"drag" : cursor_drag
								}
							}
						
					},
				"preview" : 
					{
						"width" : img_preview.width, 
						"height" : img_preview.height
					}, 
				"uploader" : 
					{
						"filter" : 
							{
								"description" : "图片(jpg, jpeg, png)", 
								"extensions" : ["*.jpg", "*.jpeg", "*.png"]
							}
					}
				};
		}
		
	}
	
}
