package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com._17173.flash.show.model.CEnum;
	
	public class GiftItem extends Sprite
	{
		private var _giftData:GiftData = null;
		private var _selectMc:MovieClip = null;
		private var _sourceFace:IResourceData = null;
		private var _faceSp:Sprite = null;
		private var _faceBmp:Bitmap = null;
		private var _loadMc:MovieClip = null;
		private const GIFT_WIDTH:int = 30;
		private const GIFT_HEIGHT:int = 30;
		public function GiftItem(data:GiftData)
		{
			super();
			drawBg();
			this.mouseChildren = false;
			this.buttonMode = true;
			_giftData = data;
			initItem();
			initLoad();
			initSelect();
			initFace();
		}
		public function get giftData():GiftData
		{
			return _giftData;
		}

		public function set giftData(value:GiftData):void
		{
			_giftData = value;
		}

		private function drawBg():void{
			this.graphics.beginFill(0x111111,.05);
			this.graphics.drawRect(0,0,36,36);
			this.graphics.endFill();
		}
		
		private function initItem():void{
			_faceSp = new Sprite();
			_faceSp.x = 3;
			_faceSp.y = 3;
			_faceSp.mouseEnabled = false;
			this.addChild(_faceSp);
			
		}
		private function initLoad():void{
			_loadMc = new MovieClip();
			_loadMc.mouseEnabled = false;
			_loadMc.mouseChildren = false;
			_loadMc.scaleX = GIFT_WIDTH/_loadMc.width;
			_loadMc.scaleY = GIFT_HEIGHT/_loadMc.height;
			_loadMc.x = 2;
			_loadMc.y = 2;
			this.addChild(_loadMc);
		}
		
		private function initSelect():void{
			_selectMc = new gift_itemselect_bg();
			_selectMc.mouseEnabled = false;
			_selectMc.mouseChildren = false;
			_selectMc.x = 1;
			_selectMc.y = 1;
			changeSelect(false);
			this.addChild(_selectMc);
		}
		
		private function initFace():void{
			var iRs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			iRs.loadResource(_giftData.iconPath,getBitmapCall);
		}
		
		private function getBitmapCall(source:IResourceData):void{
			_sourceFace = source;
			_faceBmp = _sourceFace.newSource as Bitmap;
			if(_faceBmp.width > GIFT_WIDTH || _faceBmp.scaleY > GIFT_HEIGHT){
				_faceBmp.scaleX = GIFT_WIDTH/_faceBmp.width;
				_faceBmp.scaleY = GIFT_HEIGHT/_faceBmp.height;
			}
			_faceSp.addChild(_faceBmp);
			_faceBmp.x = (GIFT_WIDTH - _faceBmp.width)/2;
			_faceBmp.y = (GIFT_HEIGHT - _faceBmp.height)/2;
			if(_loadMc){
				_loadMc.visible = false;
			}
		}
		
		/**
		 *改变选中 
		 * @param show
		 * 
		 */		
		public function changeSelect(show:Boolean):void{
			_selectMc.visible = show;
		}
		
	}
}