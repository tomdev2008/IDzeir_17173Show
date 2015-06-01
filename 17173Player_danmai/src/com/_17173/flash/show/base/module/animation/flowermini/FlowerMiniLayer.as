package com._17173.flash.show.base.module.animation.flowermini
{
	import com._17173.flash.show.base.module.animation.base.BaseAnimationLayer;
	import com._17173.flash.show.base.module.animation.base.IAnimationPlay;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class FlowerMiniLayer extends BaseAnimationLayer
	{
		/**
		 *当前屏幕所有位图的对象(按显示层级排列)
		 */		
		private var _bmpds:Array = null;
		/**
		 *配置点 
		 */		
		private var _pots:Array = null;
		/**
		 *偏移量设置 
		 */		
		private var _bmdOffset:Array = null;
		/**
		 *左边摆放限制 
		 */		
		private var _leftLimit:int = 6;
		/**
		 *当前动画放置位置（配置点下标） 
		 */		
		private var _currentShowIdx:int = -1;
		private static const SHOW_LIMIT:int = 12; 
		/**
		 *静态花 
		 */		
		private var _staticFlowBitmap:Bitmap = null;
		
		private var _staticFlowSprite:Sprite = null;
		/**
		 *动画层 
		 */		
		private var _staticFlowAmniSprite:Sprite = null;
		/**
		 *添加顺序数组，最多12个 
		 */		
		private var _flowAddOrder:Array;
		private var _isBitmapCeche:Boolean = false;
		public function FlowerMiniLayer()
		{
			super();
			_bmpds = [];
			_flowAddOrder = [];
			_bmdOffset = [];
			initPots();
			if(_isBitmapCeche){
				_staticFlowBitmap = new Bitmap();
				this.addChild(_staticFlowBitmap);
				
			}else{
				_staticFlowSprite = new Sprite();
				this.addChild(_staticFlowSprite);
				_staticFlowSprite.mouseEnabled = false;
				_staticFlowSprite.mouseChildren = false;
				initBmps();
			}
			
			_staticFlowAmniSprite = new Sprite();
			_staticFlowAmniSprite.mouseChildren = _staticFlowAmniSprite.mouseEnabled = false;
			this.addChild(_staticFlowAmniSprite);
		}
		
		private function initBmps():void{
			var len:int = SHOW_LIMIT;
			for (var i:int = 0; i < len; i++) 
			{
				var bit:Bitmap  = new Bitmap();
				_bmpds[i] = bit;
				_staticFlowSprite.addChild(bit);
			}
		}
		
		override public function addAnimation(aData:IAnimationPlay):void
		{
			_currentShowIdx = randGet();
			var tmpPot:Point = _pots[_currentShowIdx] as Point;
			aData.mc.x = tmpPot.x;
			aData.mc.y = tmpPot.y;
			_staticFlowAmniSprite.addChild(aData.mc);
		}
		
		override public function removeAnimation(adata:IAnimationPlay):void
		{
			if(_isBitmapCeche){
				addStaticBmp(adata.mc);
			}else{
				addStaticSprite(adata.mc);
			}
			if(this.contains(adata.mc)){
				_staticFlowAmniSprite.removeChild(adata.mc);
			}
		}
		/**
		 *初始化12个点 
		 * 
		 */		
		private function initPots():void{
			_pots = [new Point(30,18), new Point(141,18), new Point(26,75), new Point(157,76), new Point(80,128), new Point(170,135),
				 new Point(820,11), new Point(930,11), new Point(816,72), new Point(940,67), new Point(800,133), new Point(890,120)
			];
		}
		/**
		 *添加到静态 
		 * 
		 */		
		private function addStaticBmp(mc:MovieClip):void{
			var tmpBmd:BitmapData = new BitmapData(mc.width,mc.height,true,0x00000000);
			var rc:Rectangle = mc.getBounds(mc);
			var aa:Matrix = new Matrix();
			aa.translate(-rc.x,-rc.y);
			tmpBmd.draw(mc,aa);
			_bmpds[_currentShowIdx] = tmpBmd;
			_bmdOffset[_currentShowIdx] = new Point(rc.x,rc.y);;
			_flowAddOrder[_flowAddOrder.length] = _currentShowIdx;
			renderStatic();
		}
		/**
		 *添加到sp 
		 * @param mc
		 * 
		 */		
		private function addStaticSprite(mc:MovieClip):void{
			var tmpBmd:BitmapData = new BitmapData(mc.width,mc.height,true,0x00000000);
			var rc:Rectangle = mc.getBounds(mc);
			var aa:Matrix = new Matrix();
			aa.translate(-rc.x,-rc.y);
			tmpBmd.draw(mc,aa);
			_bmdOffset[_currentShowIdx] = new Point(rc.x,rc.y);;
			_flowAddOrder[_flowAddOrder.length] = _currentShowIdx;
			_bmpds[_currentShowIdx].bitmapData = tmpBmd;
			var tmpPot:Point = _pots[_currentShowIdx];
			var tp:Point = new Point(tmpPot.x + rc.x,tmpPot.y + rc.y);
			renderSprite(_bmpds[_currentShowIdx],tp);
		}
		/**
		 *隐藏动画 
		 * 
		 */	
		public function openEff():void{
			_staticFlowAmniSprite.visible = true;
		}
		/**
		 *隐藏动画 <br>
		 * 只隐藏动画层
		 */		
		public function closeEff():void{
			_staticFlowAmniSprite.visible = true;
		}
		
		/**
		 * 
		 * @param tmpBmd
		 * 
		 */		
		private function renderSprite(bitmap:Bitmap,tmpPot:Point):void{
			bitmap.x = tmpPot.x;
			bitmap.y = tmpPot.y;
		}
		
		/**
		 * 
		 * 绘制
		 */		
		private function renderStatic():void{
			var staticBmd:BitmapData = _staticFlowBitmap.bitmapData;
			var len:int = _bmpds.length;
			var tmpBmd:BitmapData;
			var tmpPot:Point;
			var offsetPot:Point;
			var i:int = 0;
			//判断是重绘左边，还是右边
			i = 0;
			len = SHOW_LIMIT;
			staticBmd = new BitmapData(1077,268,true,0x00ffffff);
			staticBmd.lock();
			for (i; i < len; i++) 
			{
				if(_bmpds[i] !=null){
					tmpBmd = _bmpds[i];
					offsetPot = _bmdOffset[i];
					tmpPot = _pots[i];
					staticBmd.copyPixels(tmpBmd,new Rectangle(0,0, tmpBmd.width, tmpBmd.height),new Point(tmpPot.x + offsetPot.x, tmpPot.y + offsetPot.y),null,null,true);
				}
			}
			staticBmd.unlock();
			_staticFlowBitmap.bitmapData = staticBmd;
		}
		
		/**
		 *随机获取位置 
		 * @return 
		 * 
		 */		
		private function randGet():int{
			var len:int = _pots.length;
			var len1:int = _flowAddOrder.length;
			var tmpIdx:int = -1;
			//如果已经放满了，则取出最早放置的下标;
			if(len1 >= len){
				tmpIdx = _flowAddOrder.shift();
			}else{
				var tmpIdxs:Array = [];
				for (var i:int = 0; i < len; i++) 
				{
					tmpIdx = -1;
					for (var j:int = 0; j < len1; j++) 
					{
						if(i == int(_flowAddOrder[j])){
							tmpIdx = i;
						}
					}
					if(tmpIdx == -1){
						tmpIdxs.push(i);
					}
				}
				var rand:int  = Math.floor(Math.random()*tmpIdxs.length);
				tmpIdx = int(tmpIdxs[rand]);
			}
			return tmpIdx;
		}
		private var extIndx:int;
		/**
		 *已经存在的花放置 
		 * @param mc
		 * 
		 */		
		public function addExtFlow(adata:IAnimationPlay):void{
			extIndx = randGet();
			if(_isBitmapCeche){
				addStaticBmp1(adata.mc);
			}else{
				addStaticSprite1(adata.mc);
			}
		}
		
		/**
		 *直接添加到图片类 
		 * @param mc
		 * 
		 */		
		private function addStaticBmp1(mc:MovieClip):void{
			var tmpBmd:BitmapData = new BitmapData(mc.width,mc.height,true,0x00000000);
			var rc:Rectangle = mc.getBounds(mc);
			var aa:Matrix = new Matrix();
			aa.translate(-rc.x,-rc.y);
			tmpBmd.draw(mc,aa);
			_bmpds[extIndx] = tmpBmd;
			_bmdOffset[extIndx] = new Point(rc.x,rc.y);;
			_flowAddOrder[_flowAddOrder.length] = extIndx;
			renderStatic();
		}
		
		/**
		 *直接添加到sp 
		 * @param mc
		 * 
		 */		
		private function addStaticSprite1(mc:MovieClip):void{
			var tmpBmd:BitmapData = new BitmapData(mc.width,mc.height,true,0x00000000);
			var rc:Rectangle = mc.getBounds(mc);
			var aa:Matrix = new Matrix();
			aa.translate(-rc.x,-rc.y);
			tmpBmd.draw(mc,aa);
			_bmdOffset[extIndx] = new Point(rc.x,rc.y);;
			_flowAddOrder[_flowAddOrder.length] = extIndx;
			var bitmap:Bitmap = new Bitmap(tmpBmd);
			_bmpds[extIndx].bitmapData = tmpBmd;
			var tmpPot:Point = _pots[extIndx];
			var tp:Point = new Point(tmpPot.x + rc.x,tmpPot.y + rc.y);
			renderSprite(_bmpds[extIndx],tp);
		}
	}
}