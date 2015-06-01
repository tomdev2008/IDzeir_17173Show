package com._17173.framework.core.manager
{
	 import flash.display.DisplayObject;

		 /**
		  * @author Cray
		  * @version 1.0
		  * @date Oct 28, 2014 10:54:36 AM
		  */    
	    public class LayoutManager {
	
	        public function LayoutManager(){
	            super();
	        }
			/**
			 * 设置相对位置 
			 * @param object
			 * @param center
			 * @param middle
			 * @param top
			 * @param left
			 * @param bottom
			 * @param right
			 * 
			 */			
			public static function setRelativePosition(object:DisplayObject,width:Number,heigth:Number,center:Number,middle:Number,top:Number,left:Number,bottom:Number,right:Number):void
			{			
				if(center)
				{				
					object.x = center + (width - object.width)/2;	
				}else
				{
					if(left)
						object.x = left;
					else if (right)
						object.x = width - right - object..width; 
					else
						object.x = 0;
				}
				if(middle)
				{
					object.y = middle + (heigth - object.height)/2;	
				}else
				{
					
					if (top) {
						object.y = top;
					} else if (bottom) {
						object.y = heigth - bottom - object.height;
					} else {
						object.y = 0;
					}
				}
			}
													   
			/**
			 * 激活对象，将对象重置到最上层 
			 * @param object
			 * 
			 */			
	        public static function setActive(object:DisplayObject):void{
	            object.parent.setChildIndex(object, (object.parent.numChildren - 1));
	        }
			/**
			 * 设置显示对象位置 
			 * @param object
			 * @param x
			 * @param y
			 * 
			 */			
	        public static function setPosition(object:DisplayObject, x:Number, y:Number):void{
	            object.x = x;
	            object.y = y;
	        }
			/**
			 * 设置显示对象位置和大小 
			 * @param object
			 * @param x
			 * @param y
			 * @param w
			 * @param h
			 * 
			 */			
	        public static function setPositionAndSize(object:DisplayObject, x:Number, y:Number, w:Number, h:Number):void{
	            setPosition(object, x, y);
	            setSize(object, w, h);
	        }
			/**
			 * 设置显示对象大小 
			 * @param object
			 * @param w
			 * @param h
			 * 
			 */			
	        public static function setSize(object:DisplayObject, w:Number, h:Number):void{
	            object.width = w;
	            object.height = h;
	        }
			/**
			 * 缩放显示对象 
			 * @param object
			 * @param size
			 * 
			 */			
	        public static function setScale(object:DisplayObject, size:Number):void{
	            if(object.width > object.height)
	            {
	            	object.scaleX = size/object.width;
	            	object.scaleY = size/object.width;
	            }else
	            {
	            	object.scaleX = size/object.height;
	            	object.scaleY = size/object.height;
	            }
	        }
	    }
	}