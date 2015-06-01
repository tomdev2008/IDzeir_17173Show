package com._17173.flash.show.base.context.resource
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class BitmapResourceData extends BaseResourceData implements IResourceData
	{
		/**
		 * bitmap资源数据 会将传入的bitmap绘制到新的source中;
		 * @param bmp 原始数据
		 * @param keyStr 键字符串
		 * 
		 */
		public function BitmapResourceData(source:*,keyStr:String)
		{
			super(source, keyStr);
		}
		/**
		 *装在数据 
		 * @param source
		 * 
		 */		
		override protected function setupSource(source:*):void{
			_resource = source
		}
		
		override public function get source():*{
			return  _resource;
		}
		
		override public function get newSource():*{
			var bit:BitmapData = new BitmapData(_resource.width,_resource.height,true,0x11CCCCCC);
			bit.fillRect(bit.rect,0);
			bit.draw(_resource);
			updateUserTime();
			return new Bitmap(bit);
		}
		
		
		
	}
}