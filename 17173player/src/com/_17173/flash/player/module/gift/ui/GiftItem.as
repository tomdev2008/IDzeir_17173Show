package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 礼物展示ui,类似于按钮的状态,鼠标滑过会显示GiftTip
	 *  
	 * @author shunia-17173
	 */	
	public class GiftItem extends Sprite
	{
		
		private var _giftBtn:DisplayObject = null;
		private var _pic:Sprite = null;
		private var _gift:Object = null;
		
		public function GiftItem() {
			super();
			
			_giftBtn = new mc_giftItemBtn();
			addChild(_giftBtn);
			
			_pic = new Sprite();
			_pic.mouseChildren = false;
			_pic.mouseEnabled = false;
			addChild(_pic);
			
			addEventListener(MouseEvent.ROLL_OVER, showGiftTip);
			addEventListener(MouseEvent.ROLL_OUT, hideGiftTip);
		}
		
		protected function hideGiftTip(event:MouseEvent):void {
			dispatchEvent(new Event("hideGiftTip", true));
		}
		
		protected function showGiftTip(event:MouseEvent):void {
			dispatchEvent(new Event("showGiftTip", true));
		}
		
		public function set gift(value:Object):void {
			if (value) {
				_gift = value;
				name = _gift.giftId;
				var picURL:String = _gift.smallPic;
				var loader:LoaderProxy = new LoaderProxy();
				var loaderOption:LoaderProxyOption = new LoaderProxyOption(
					picURL, LoaderProxyOption.FORMAT_IMAGE, LoaderProxyOption.TYPE_ASSET_LOADER, onLoaded);
				loader.load(loaderOption);
			}
		}
		
		public function get gift():Object {
			return _gift;
		}
		
		private function onLoaded(data:DisplayObject):void {
			if (data) {
				_pic.addChild(data);
				
				resize();
			}
		}
		
		
		private function resize():void {
			var scX:Number = _giftBtn.width / _pic.width;
			var scY:Number = _giftBtn.height / _pic.height;
			var sc:Number = scX < scY ? scX : scY;
			_pic.scaleX = _pic.scaleY = sc;
			_pic.x = (width - _pic.width) / 2;
			_pic.y = 0;
		}

	}
}