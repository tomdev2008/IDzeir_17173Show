package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.module.gift.data.GiftData;
	import com._17173.flash.show.model.CEnum;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GiftItem extends Sprite
	{
		private var _giftData:GiftData = null;
		private var _selectMc:MovieClip = null;
		private var _sourceFace:IResourceData = null;
		private var _faceSp:Sprite = null;
		private var _faceBmp:Bitmap = null;
		private var _loadMc:MovieClip = null;
		private const GIFT_WIDTH:int = 49;
		private const GIFT_HEIGHT:int = 49;
		private var _showGroup:Sprite = null;
		public function GiftItem(data:GiftData)
		{
			super();
			drawBg();
			this.mouseChildren = false;
			this.buttonMode = true;
			_giftData = data;
			initSelect();
			initItem();
			initLoad();
			initFace();
			initGroup();
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function initGroup():void
		{
			// TODO Auto Generated method stub
			_showGroup = new Gift_effect_op();
			_showGroup.x = -1;
			_showGroup.y = 2;
			_showGroup.mouseEnabled = false;
			_showGroup.visible = _giftData.showGroup
			this.addChild(_showGroup);
		}
		
		protected function onAddStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
			this.addEventListener(MouseEvent.ROLL_OVER,onOver);
			
		}
		
		protected function onOver(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.addEventListener(MouseEvent.ROLL_OUT,onOut);
			showIcon();
		}
		
		protected function onOut(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			hideIcon();
		}
		
		protected function onRemoveStage(event:Event):void
		{
			// TODO Auto-generated method stub
			this.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveStage);
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
			this.graphics.beginFill(0x111111,.01);
			this.graphics.drawRect(0,0,49,49);
			this.graphics.endFill();
		}
		
		private function initItem():void{
			_faceSp = new Sprite();
			_faceSp.x = 0;
			_faceSp.y = -3;
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
			_selectMc = new Gift_selectBg1();
			_selectMc.mouseEnabled = false;
			_selectMc.mouseChildren = false;
			_selectMc.x = -5;
			_selectMc.y = -1;
			changeSelect(false);
			_selectMc.visible = false;
			this.addChild(_selectMc);
		}
		
		private function initFace():void{
			var iRs:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			iRs.loadResource(_giftData.iconPath,getBitmapCall);
		}
		
		private function getBitmapCall(source:IResourceData):void{
			_sourceFace = source;
			_faceBmp = _sourceFace.newSource as Bitmap;
			if(_faceBmp == null) return ;
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
		
		public function showIcon():void{
			TweenLite.to(_faceSp,.3,{y:-15});
		}
		
		public function hideIcon():void{
			TweenLite.to(_faceSp,.2,{y:-3});
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