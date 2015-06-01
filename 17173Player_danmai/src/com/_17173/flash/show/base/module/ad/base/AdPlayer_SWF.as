package  com._17173.flash.show.base.module.ad.base
{
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.show.base.module.ad.base.AdPlayer_Image;
	
	import flash.display.Loader;

	/**
	 * SWF加载器
	 *  
	 * @author 庆峰
	 */	
	public class AdPlayer_SWF extends AdPlayer_Image
	{
		
		private var _loader:Loader = null;
		
		public function AdPlayer_SWF()
		{
			super();
		}
		
		override protected function complete(result:Object):void {
			_loader = result as Loader;
			_soundTarget = _loader.content;
			
			super.complete(result);
		}
		
		override public function resize(w:int, h:int):void {
			if(_loader) {
				super.resize(w, h);
			}
		}
		
		override protected function initLoaderConfig():LoaderProxyOption {
			var option:LoaderProxyOption = super.initLoaderConfig();
			option.format = LoaderProxyOption.FORMAT_SWF;
			// 返回loader
			option.useLoader = true;
			return option;
		}
		
		override protected function calcResizeScale():Number {
			var vw:int = _loader.contentLoaderInfo.width;
			var vh:int = _loader.contentLoaderInfo.height;
			var sw:Number = vw > _w ? _w / vw : 1;
			var sh:Number = vh > _h ? _h / vh : 1;
			return sw > sh ? sh : sw;
		}
		
		override public function get width():int {
			return _loader.scaleX * _loader.contentLoaderInfo.width;
		}
		
		override public function get height():int {
			return _loader.scaleX * _loader.contentLoaderInfo.height;
		}
		
		override public function dispose():void {
			if (_loader) {
				_loader.unloadAndStop();
				_loader = null;
			}
			super.dispose();
		}
		
	}
}