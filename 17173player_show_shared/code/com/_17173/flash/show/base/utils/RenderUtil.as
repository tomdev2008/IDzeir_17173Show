package com._17173.flash.show.base.utils
{
	import com._17173.flash.show.base.components.common.data.AnimData;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RenderUtil
	{
		
		/**
		 * 将MovieClip转换成Bitmapdata序列
		 *  
		 * @param movie
		 * @return 
		 */		
		public static function movieClipToBitmapdata(movie:MovieClip, colorClip:Boolean = true):Array {
			var movies:Array = null;
			if (movie && movie.totalFrames > 0) {
				movies = [];
				var bd:BitmapData = null;
				var bound:Rectangle = null;
				var p:Point = new Point();
				var drawBd:BitmapData = null;
				var drawRect:Rectangle = null;
				var drawMatrix:Matrix = new Matrix();
				var centerPosX:Number = 0;
				var centerPosY:Number = 0;
				var compareBd:BitmapData = null;
				var compareRect:Rectangle = null;
				var dx:Number = 0;
				var dy:Number = 0;
				var originalRect:Rectangle = null;
				var info:AnimData = null;
				for (var i:int = 1; i <= movie.totalFrames; i ++) {
					drawMatrix.identity();
					movie.gotoAndStop(i);
					bound = movie.getBounds(movie);
					drawMatrix.translate(-bound.x,-bound.y);
//					Debugger.tracer("original: " + bound);
					if (bound.isEmpty()) {
						if (movies.length > 0) {
							info = movies[movies.length - 1].clone();
						} else {
							info = new AnimData();
							info.bd = new BitmapData(1, 1);
						}
					} else {
						bd = new BitmapData(movie.width, movie.height, true, 0x00000000);
//						if (scaleX) {
//							if (compareRect == null) {
//								compareBd = new BitmapData(bound.width, bound.height, true, 0x00000000);
//								compareBd.draw(movie);
//								compareRect = compareBd.getColorBoundsRect(0xFFFFFF, 0x000000, false);
//								compareBd.dispose();
//								compareBd = null;
//							}
//							drawMatrix.scale(-1, 1);
//							drawMatrix.translate(bd.width, 0);
//						}
						bd.draw(movie, drawMatrix);
						if (colorClip) {
							drawRect = bd.getColorBoundsRect(0xFFFFFF, 0x000000, false);
//							Debugger.tracer("color: " + drawRect);
							if (drawRect && !drawRect.isEmpty() && (bd.width != drawRect.width || bd.height != drawRect.height)) {
								drawBd = new BitmapData(drawRect.width, drawRect.height, true, 0x00000000);
								drawBd.copyPixels(bd, drawRect, p);
								bd.dispose();
							}
							//如果按实际区域截取,则需要计算偏移
							originalRect = new Rectangle(-bound.x,-bound.y);
						} else {
							drawRect = bound;
							drawBd = bd;
						}
						if (originalRect == null && drawRect != null) {
							originalRect = drawRect;
							centerPosX = originalRect.x;
							centerPosY = originalRect.y;
						}
						info = new AnimData();
						info.bd = drawBd;
						info.x = drawRect.x - originalRect.x;
						info.y = drawRect.y - originalRect.y;
						if (compareRect != null && !compareRect.isEmpty()) {
							dx = (compareRect.x - originalRect.x) / 2;
							dy = (compareRect.y - originalRect.y) / 2;
							compareRect.setEmpty();
						}
						info.offsetX = centerPosX + dx;
						info.offsetY = centerPosY + dy;
					}
					
					movies.push(info);
				}
				movie.stop();
				movie = null;
			}
			return movies;
		}
		
	}
}