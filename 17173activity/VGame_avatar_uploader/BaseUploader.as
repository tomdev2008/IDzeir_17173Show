package  {
	import flash.net.FileReference;
	import flash.events.Event;
	
	public class BaseUploader {
		
		protected var _onSucc:Function = null;
		protected var _onFail:Function = null;
		
		protected var _fr:FileReference = null;
		protected var _filter:Array = null;
		
		public function BaseUploader(filter:Array = null, onSucc:Function = null, onFail:Function = null) {
			// constructor code
			this.filter = filter;
			this.onSucc = onSucc;
			this.onFail = onFail;
			
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT, onSelected);
			_fr.addEventListener(Event.COMPLETE, onCompleted);
		}
		
		public function set filter(value:Array):void {
			if (_filter == null && value != null) _filter = value;
		}
		
		public function set onSucc(value:Function):void {
			_onSucc = value;
		}
		
		public function set onFail(value:Function):void {
			_onFail = value;
		}
		
		public function load(filter:Array = null):void {
			this.filter = filter;
			_fr.cancel();
			_fr.browse(_filter);
		}
		
		protected function onSelected(e:Event):void {
			_fr.load();
		}
		
		protected function onCompleted(e:Event):void {
			if (_onSucc != null) {
				_onSucc.apply(null, _fr.data);
			}
		}
		
		protected function onError(e:Event):void {
			if (_onFail != null) {
				_onFail.apply(null, null);
			}
		}

	}
	
}
