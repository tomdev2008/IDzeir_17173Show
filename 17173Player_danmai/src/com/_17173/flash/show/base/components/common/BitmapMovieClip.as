package com._17173.flash.show.base.components.common
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BitmapMovieClip extends Sprite
	{
		protected var _toW:Number = 0;
		protected var _toH:Number = 0;
		
		protected var _isFix:Boolean = false;
		
		protected var emShape:DisplayObject;
		/**
		 * 序列图动画
		 * @param isFix 是否对后面设置的序列图做拉伸处理
		 * @param fixToW 表情的显示宽
		 * @param fixToH 表情的显示高
		 */
		public function BitmapMovieClip(isFix:Boolean = false,fixToW:Number = 24, fixToH:Number = 24)
		{
			super();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,fixToW,fixToH);
			this.graphics.endFill();
			_toW = fixToW;
			_toH = fixToH;
			_isFix = isFix;
			
			this.addEventListener(Event.REMOVED_FROM_STAGE,function():void
			{
				stop();
			});
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				play();
			})
		}
		
		protected function setFWH(isFix:Boolean = false,fixToW:Number = 24, fixToH:Number = 24):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,fixToW,fixToH);
			this.graphics.endFill();
			_toW = fixToW;
			_toH = fixToH;
			_isFix = isFix;
		}
		
		/**
		 * 指定加载外部资源的地址
		 * 可为图片或者swf文件，swf文件时会转成序列图播放
		 */
		public function set url(value:String):void
		{
			stop();
			var _res:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			
			_res.loadResource(value,function(d:IResourceData):void
			{
				if(value.indexOf(".swf")>0)
				{
					_res.addAnimDatas4Mc(value,d.newSource as MovieClip,false);
					var a:Array = _res.getAnimDatas(value);
					data = a;
				}else{
					data = [(d.newSource as Bitmap).bitmapData];
				}
			});
		}
		
		/**
		 * 设置表情的显示数据
		 * @param value bitmapdata数组
		 */
		public function set data(value:Array):void
		{
			this.removeChildren();
			stop();
			if(value){
				if(value.length == 1)
				{
					emShape = new Bitmap(value[0]);
				}else{
					emShape = new BitmapAnim();
					(emShape as BitmapAnim).autoPlay = true;
					(emShape as BitmapAnim).loop = -1;
					(emShape as BitmapAnim).data = value;
				}
				if(_isFix)
				{
					emShape.width = _toW;
					emShape.height = _toH;
				}else{
					align();
				}
				
				this.addChild(emShape);
			}			
			//this.graphics.clear();
		}
		
		protected function align():void
		{
			if(emShape.width<_toW||emShape.height<_toH)
			{
				emShape.x = (_toW - emShape.width)*.5
				emShape.y = (_toH - emShape.height)*.5
			}
		}
		
		/**
		 * 调到指定帧
		 */
		public function gotoAndStop(value:int):void
		{
			if(emShape&&emShape is BitmapAnim)
			{
				(emShape as BitmapAnim).gotoAndStop(value);
			}
		}
		
		/**
		 * 动态时停止播放
		 */
		public function stop():void
		{
			if(emShape&&emShape is BitmapAnim)
			{
				(emShape as BitmapAnim).stop();
			}
		}
		
		/**
		 * 动态时播放
		 */
		public function play():void
		{
			if(emShape&&emShape is BitmapAnim)
			{
				(emShape as BitmapAnim).play();
			}
		}
		
		/**
		 * 销毁动画
		 */
		public function dispose():void
		{
			if(emShape)
			{
				if(emShape is BitmapAnim)
				{
					(emShape as BitmapAnim).dispose();
				}
			}
		}
	}
}