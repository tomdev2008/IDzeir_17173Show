package com._17173.flash.core.components.common
{
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-13  下午4:43:53
	 */
	public class Label extends TextField
	{
		private var _maxWidth:Number=80;
		private var _fullText:String="";
		
		private var _color:Number=0xD0CFCF;

		private var _tfArr:Array;
		
		/**
		 * 单行显示文本，超出限制长度自动显示为带"..." 
		 * @param maxW 指定文本显示的最大长度,例如：{maxW:80,label:"helloButton"}
		 * 
		 */	
		public function Label(vars:Object=null):void
		{
			this.autoSize="left";
			if(vars)
			{
				this._maxWidth=vars.maxW?vars.maxW:80;				
				this._color=vars.color?vars.color:0xD0CFCF;
			}
			this.multiline=false;
			this.wordWrap=false;
			this.selectable=false;
			
			
			var tf:TextFormat=new TextFormat("Microsoft YaHei,微软雅黑,宋体",12,this._color,true);
			this.defaultTextFormat=tf;
			text=(vars && vars.label)?vars.label:"";
		}
		
		override public function set defaultTextFormat(format:TextFormat):void
		{
			super.defaultTextFormat = format;
			this.resize();
		}
		
		/**
		 * 开启label鼠标滑入的手型模式
		 */
		public function set buttonMode(bool:Boolean):void
		{
			if(bool)
			{
				super.htmlText = "<a href='event:&%@'>"+super.text+"</a>"
			}else{
				super.text = this.text;
				resize();
			}
		}
		
		override public function set type(value:String):void
		{
			super.type = value;
			if(value=="input")
			{
				this.selectable = true;
				this.autoSize = TextFieldAutoSize.NONE;
				this.width = this._maxWidth;
				this.addEventListener(Event.CHANGE,onChange,false,int.MAX_VALUE);
			}else{
				this.selectable = false;
				this.autoSize = TextFieldAutoSize.LEFT;
				if(this.hasEventListener(Event.CHANGE))
				{
					this.removeEventListener(Event.CHANGE,onChange);
				}
			}
		}
		
		protected function onChange(event:Event):void
		{
			_fullText = super.text;
		}
		
		/**
		 * label显示的最大宽度,超出宽度自动在末尾加"..."
		 * */
		public function set maxWidth(value:Number):void
		{
			_maxWidth=value;
			_maxWidth=Math.max(0,_maxWidth);
			resize();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
			this.maxWidth = value;
		}
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		override public function set text(value:String):void
		{
			_fullText=value;
			super.text=value;
			resize();
		}
		
		override public function get text():String
		{
			return this._fullText;
		}
		
		override public function set htmlText(value:String):void
		{
			//text=value;
			super.htmlText = value;
			this._fullText = super.text;
			resize()
		}
		
		override public function get htmlText():String
		{
			return super.htmlText;
		}
		
		override public function appendText(newText:String):void
		{
			_fullText+=newText;
			super.appendText(newText);
			resize();
		}
		
		protected function resize():void
		{
			_tfArr = this.getTextRuns();
			if (_fullText.length > 0 && super.width > this._maxWidth)
			{
				setText("...")
				var baseWidth:Number = super.textWidth;
				setText("");
				var sz:String = this._fullText;
				do
				{
					setText(super.text + ("..."));
					if (this.width >=  (this._maxWidth - baseWidth))
					{
						break;
					}
					setText(super.text.substring(0, super.text.length - 3) + sz.substr(0, 1));
					sz = sz.substr(1);
				} while (sz.length > 0)
			}
			_tfArr = null;
		}
		
		/**
		 * 给富文本html分段设置样式
		 */
		protected function setText(value:String):void
		{
			super.text = value;
			for each (var i:Object in _tfArr)
			{
				if (i.beginIndex>=value.length)
				{
					return;
				}
				this.setTextFormat(i.textFormat, i.beginIndex, Math.min(i.endIndex,value.length));
			}
		}
	}
}