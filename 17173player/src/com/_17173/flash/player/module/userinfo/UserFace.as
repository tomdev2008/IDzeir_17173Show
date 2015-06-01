package com._17173.flash.player.module.userinfo
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class UserFace extends Sprite
	{
		private var _face:DisplayObject = null;
		private var _defFace:MovieClip = null;
		private const CENTER_URL:String = "http://v.17173.com/live/ucenter/goMpkgAccountLookup.action";
		/**
		 *用户头像
		 *
		 */
		public function UserFace()
		{
			super();
			init();
			this.mouseChildren = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,onFaceClick);
		}

		private function init():void
		{
			var msk:Shape = new Shape();
			msk.graphics.beginFill(0x111111);
			msk.graphics.drawCircle(20, 20, 20);
			msk.graphics.endFill();
			this.mask = msk;
			this.addChild(msk);
			this.mouseChildren = false;
		}

		public function set faceUrl(url:String):void
		{
			if (_face)
				return;
			var picURL:String = url;
			var loader:LoaderProxy = new LoaderProxy();
			var loaderOption:LoaderProxyOption = new LoaderProxyOption(picURL, LoaderProxyOption.FORMAT_IMAGE, LoaderProxyOption.TYPE_ASSET_LOADER, onLoaded);
			loader.load(loaderOption);
		}

		private function onLoaded(data:DisplayObject):void
		{
			//加载图片长宽相等（只计算宽缩放）
			if (_face && this.contains(_face))
			{
				_face.parent.removeChild(_face);
			}
			_face = data;
			var ws:Number = 40 / _face.width;
			var hs:Number = 40 / _face.height;
			_face.scaleX = ws;
			_face.scaleY = hs;
			this.addChild(_face);
		}
		
		
		private function onFaceClick(e:Event):void{
			Util.toUrl(CENTER_URL);
		}
	}
}
