package com._17173.flash.show.base.module.bag.view.items
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 *背包item head
	 * @author yeah
	 */	
	public class BagItemHead extends BagItemPart
	{
		public function BagItemHead()
		{
			super();
		}
		
		override protected function onRender():void
		{
			super.onRender();
			
			imgWidth = width - PADDING * 2;
			
			if(data.imgPath != null)
			{
				var rsm:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
				if(img)
				{
					img.bitmapData = null;
				}
				rsm.loadResource(data.imgPath, resouceReady);
			}
			else
			{
				var c:* = getNoneHeadClass();
				if(c)
				{
					resouceReady(new c());
				}
			}
		}
		
		/**
		 *头像 
		 */		
		private var img:Bitmap;
		
		/**
		 *资源准备完成 
		 * @param $rs
		 */		
		private function resouceReady($rsd:Object):void
		{
			if(!img)
			{
				img = new Bitmap();
				img.smoothing = true;
				img.x = PADDING;
				img.y = PADDING;
				this.addChildAt(img, 0);
			}
			
			var bmd:BitmapData;
			if($rsd is IResourceData)
			{
				firstCategoryId = -999;
				bmd = ($rsd.newSource as Bitmap).bitmapData;
			}
			else if($rsd is BitmapData)
			{
				bmd = ($rsd as BitmapData);
			}
			
			if(bmd)
			{
				img.bitmapData = bmd;
				img.scaleX = img.scaleY = (imgWidth / bmd.width); 
			}
			
//			img.width = width - PADDING * 2;
//			img.height = 
//			img.x = (width - img.width) >> 1;
//			img.y = (height - img.height) >> 1;
		}
		
		/**
		 *边距 
		 */		
		private static const PADDING:int = 3;
		
		/**
		 *图片宽度 
		 */		
		private var imgWidth:int;
		
		override public function get width():Number
		{
			return 160;
		}
		
		override public function get height():Number
		{
			return 92;
		}
		
		/**
		 *旧的标志 
		 */		
		private var firstCategoryId:int = -999;
		
		/**
		 *获取 默认头像 
		 * @return 
		 */		
		private function getNoneHeadClass():Class
		{
			if(firstCategoryId == data.firstCategoryId) return null;
			firstCategoryId = data.firstCategoryId;
			
			var c:Class;
			switch(data.firstCategoryId)
			{
				case 8:		//无入场特效的id 
					c = NoEffect
					break;
			}
			
			return c;
		}
	}
}