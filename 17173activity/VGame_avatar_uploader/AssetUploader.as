package  {
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	
	public class AssetUploader extends BaseUploader{
		
		protected var _loader:Loader = null;
		
		public function AssetUploader(filter:Array = null, onSucc:Function = null, onFail:Function = null) {
			super(filter, onSucc, onFail);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssetLoadCompleted);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		override protected function onCompleted(e:Event):void {
			_loader.loadBytes(_fr.data);
		}
		
		protected function onAssetLoadCompleted(e:Event):void {
			if (_onSucc != null) {
				_onSucc.apply(null, [_loader.content]);
			}
		}

	}
	
}
