package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-14  下午4:33:22
	 */
	public class InTextBar extends Sprite
	{

		private var _inTxt:TextField;

		private var _e:IEventManager;

		private var _focus:Object;

		private var _originalStr:String = "";

		private var _smileFace:Sprite;
		
		private var _smileDir:uint = 2;

		public function InTextBar(originalStr:String = "")
		{
			super();
			this._originalStr = originalStr;
			this.addChildren();
		}
		
		/**
		 * 表情面板展开方向 1上2下3左4右
		 */
		public function get smileDir():uint
		{
			return _smileDir;
		}

		/**
		 * @private
		 */
		public function set smileDir(value:uint):void
		{
			_smileDir = value;
		}

		public function set inTxt(value:TextField):void
		{
			_inTxt = value;
		}

		public function get smileFace():Sprite
		{
			return _smileFace;
		}

		public function set smileFace(value:Sprite):void
		{
			_smileFace = value;
		}

		public function get inTxt():TextField
		{
			return _inTxt;
		}

		private function addChildren():void
		{
			_e = (Context.getContext(CEnum.EVENT) as IEventManager);
			_e.listen(SEvents.INSERT_SMILE_TAG, onInsertTag,this);
			
			inTxt = new TextField();
			inTxt.width = 270;
			inTxt.height = 26;
			//inTxt.y = 4;
			inTxt.type = "input";
			inTxt.maxChars = 180;
			inTxt.wordWrap = true;
			
			var tf:TextFormat = new TextFormat(FontUtil.f, 14, 0x9F0068);
			tf.leftMargin = 5;
			
			inTxt.defaultTextFormat = tf;
			
			inTxt.text = this._originalStr;
			
			this.addChild(inTxt);
			
			_smileFace = new SmileFace1_8();
			_smileFace.mouseChildren = false;
			_smileFace.buttonMode = true;
			_smileFace.y = (height - _smileFace.height) * .5 + 2;
			_smileFace.x = inTxt.width + 5;
			this.addChild(_smileFace);
			
			this.backgroundColor = 0x1B0537;
			
			inTxt.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			inTxt.addEventListener(FocusEvent.FOCUS_OUT, this.focusHandler);
			smileFace.addEventListener(MouseEvent.CLICK, openSmilePanel);
		}
		
		public function update():void
		{
			_smileFace.x = inTxt.width + 5;
		}
		
		/**
		 * 设置组件背景颜色
		 * @param _color
		 *
		 */
		public function set backgroundColor(_color:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(_color);
			this.graphics.drawRect(0, 0, inTxt.width + smileFace.width + 5, inTxt.height);
			this.graphics.endFill();
		}

		private function onInsertTag(value:*):void
		{
			if (inTxt.text == this._originalStr)
			{
				inTxt.text = "";
			}
			inTxt.replaceText(inTxt.selectionBeginIndex,inTxt.selectionEndIndex,value.tag);
			//inTxt.appendText(value.tag);
			if(stage)stage.focus = inTxt;
		}

		/**
		 * 打开表情面板
		 * @param event
		 *
		 */
		protected function openSmilePanel(event:MouseEvent):void
		{
			var tar:Sprite = event.target as Sprite;
			if(!tar)
			{
				return;
			}

			if(_e)
			{
				var globPos:Point = this.localToGlobal(new Point(tar.x + 50, tar.y + 18));
				_e.send(SEvents.OPEN_SMILE_PANEL, {"content":this, x:globPos.x, y:globPos.y,dir:this._smileDir});
			}
		}

		protected function focusHandler(event:FocusEvent):void
		{
			switch(event.type)
			{
				case FocusEvent.FOCUS_IN:
					if(this._focus && this._focus.hasOwnProperty("focus_in"))
					{
						this._focus["focus_in"]();
					}
					if(this._originalStr == this.inTxt.text)
					{
						this.inTxt.text = "";
					}
					if(GuideManager.runningGuide){
						//引导事件
						_e.send(SEvents.TASK_CHAT_TXT_CHANGE,{"text":this.inTxt.text});
						this.inTxt.text = "很高兴见到你，新人为你打气加油!";
					}
					
					
					break;
				case FocusEvent.FOCUS_OUT:
					if(this._focus && this._focus.hasOwnProperty("focus_out"))
					{
						this._focus["focus_out"]();
					}
					if(this.isEmpty)
					{
						this.inTxt.text = this._originalStr;
					}
					break;
			}
		}

		/**
		 * 返回输入本文长度，表情算一个长度
		 * @return
		 *
		 */
		public function get length():uint
		{
			var _len:uint = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.getTotal(text);
			return _len;
		}

		/**
		 * 默认显示
		 */
		public function set originalStr(value:String):void
		{
			_originalStr = value;
		}

		/**
		 * 注入获取焦点和丢失焦点的处理器value.focus_in和value.focus_out
		 * @param value
		 *
		 */
		public function set focus(value:Object):void
		{
			this._focus = value;
		}

		/**
		 * 输入面板输入的字符串
		 * @return
		 *
		 */
		public function get text():String
		{
			return isEmpty ? "" : inTxt.text;
		}
		
		public function set text(value:String):void
		{
			inTxt.text = value;
			inTxt.setSelection(inTxt.length,inTxt.length);
		}

		/**
		 * 文本有没有输入
		 * @return
		 *
		 */
		public function get isEmpty():Boolean
		{
			var str:String = this.inTxt.text;

			return str == this._originalStr || (str.replace(" ", "") == "");
		}

		/**
		 * 清楚输入的内容
		 *
		 */
		public function clear():void
		{
			inTxt.text = "";
		}
	}
}