package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.show.base.utils.FontUtil;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 *  操作Item，用于OperationPanel
	 * @author qiuyue
	 * 
	 */	
	public class OperationItem extends Sprite
	{
		/**
		 * 鼠标滑动效果
		 */		
		private var _overShape:Shape;
		/**
		 * 点击回调函数 
		 */		
		private var _fun:Function;
		/**
		 * 显示文本 
		 */
		private var _textField:TextField;
		
		/**
		 * 图标 
		 */		
		private var _icon:DisplayObject;
		public function OperationItem()
		{
			super();
			
			_overShape = new Shape();
			this.addChild(_overShape);
			_overShape.graphics.beginFill(0x4709ac,0.5);
			_overShape.graphics.drawRect(0,0,93,26);
			_overShape.visible = false;
			_textField = new TextField();
			this.addChild(_textField);
			var format:TextFormat = FontUtil.DEFAULT_FORMAT;
			format.color = 0xF9F9F9;
			format.size = 12;
			_textField.defaultTextFormat = format;
			_textField.selectable = false;
			_textField.x = 34;
			_textField.y =4;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			this.addEventListener(MouseEvent.CLICK,click);
			this.addEventListener(MouseEvent.MOUSE_OVER,over);
			this.addEventListener(MouseEvent.MOUSE_OUT,out);
		}
		/**
		 *  鼠标点击操作
		 * @param e
		 * 
		 */		
		private function click(e:MouseEvent):void
		{
			e.stopPropagation();
			_fun();
		}
		
		/**
		 * 更新Item
		 * @param icon 图片对象
		 * @param text 文本
		 * @param fun 回调函数
		 * 
		 */		
		public function updateItem(icon:DisplayObject,text:String,fun:Function):void
		{
			if(icon && !this.contains(icon))
			{
				icon.x = 15;
				icon.y = 7;
				if(icon is MovieClip){
					(icon as MovieClip).stop();
				}
				this.addChild(icon);
				_textField.text = text;
				this._fun = fun;
			}
	
		}
		
		/**
		 * 鼠标MOUSEOVER 
		 * @param e
		 * 
		 */		
		private function over(e:MouseEvent):void
		{
			_overShape.visible = true;
		}
		
		/**
		 * 鼠标MOUSEOUT
		 * @param e
		 * 
		 */		
		private function out(e:MouseEvent):void
		{
			_overShape.visible = false;
		}
	}
}