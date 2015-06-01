package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.display.DisplayObject;

	/**
	 * 广告图片加载器
	 *  
	 * @author 庆峰
	 */	
	public class AdPlayer_Image extends BaseAdPlayer
	{
		
		protected var _time:Number = 0;
		
		public function AdPlayer_Image()
		{
			super();
		}
		
		override protected function init():void {
			super.init();
			
			loadAsset();
		}
		
		protected function loadAsset():void {
			try {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = initLoaderConfig();
				loader.load(option);
			} catch (e:Error) {
				error(null);
			}
		}
		
		protected function initLoaderConfig():LoaderProxyOption {
			var option:LoaderProxyOption = new LoaderProxyOption();
			option.url = Util.trimStr(_data.url);
			option.type = LoaderProxyOption.TYPE_ASSET_LOADER;
			option.format = LoaderProxyOption.FORMAT_IMAGE;
			option.onFault = error;
			option.onSuccess = complete;
			return option;
		}
		
		override protected function complete(result:Object):void {
			preComplete(result);
			
			Ticker.tick(500, updateTime, 0);
			
			super.complete(result);
		}
		
		protected function preComplete(result:Object):void {
			_display = result as DisplayObject;
		}
		
		protected function updateTime():void {
			_time += 500;
		}
		
		override public function getTime():Number {
			return _time;
		}
		
		override protected function error(info:Object):void {
			super.error({"url":_data.url, "type":_data.type, "id":_data.id});
		}
		
		override public function resize(w:int, h:int):void {
			super.resize(w, h);
			
			if (_display) {
				var sc:Number = calcResizeScale();
				_display.scaleX = _display.scaleY = sc;
				_display.width = Math.ceil(_display.width);
				_display.height = Math.ceil(_display.height);
			}
		}
		
		protected function calcResizeScale():Number {
			var vw:int = _display.width;
			var vh:int = _display.height;
			var sw:Number = vw > _w ? _w / vw : 1;
			var sh:Number = vh > _h ? _h / vh : 1;
			return sw > sh ? sh : sw;
		}
		
		override public function dispose():void {
			_time = 0;
			Ticker.stop(updateTime);
			super.dispose();
		}
		
	}
}