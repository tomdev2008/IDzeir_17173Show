package com._17173.flash.show.base.module.smileres
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-17  下午2:35:01
	 */
	public class SmilePanel extends BaseModule
	{
		private const SIZE:Number = 33;

		private const ROW:uint = 4;
		private const COL:uint = 8;

		private var top:Number = 12;

		private var smileContainer:Sprite;

		private var _target:* = null;

		private var content:VGroup;

		/**
		 * 表情的页数
		 */
		private var totalPage:uint = 3;
		/**
		 * 表情当前页
		 */
		private var curPage:int = 1;

		private var rightBut:Button;

		private var text:TextField;

		private var leftBut:Button;

		private var _dictionary:Dictionary;

		private var smiles:Vector.<SmileBox> = new Vector.<SmileBox>();

		public function SmilePanel()
		{
			super();
			_version = "0.0.2";
			addChildren();
		}

		private function addChildren():void
		{
			this.graphics.lineStyle(1, 0x9657C3);
			this.graphics.beginFill(0x5F35A3);
			this.graphics.drawRoundRect(0, 0, 300, 180, 3, 3);
			this.graphics.endFill();

			smileContainer = new Sprite();
			var count:uint = 0;
			_dictionary = new Dictionary(true);

			var gp:Vector.<Object> = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.graphicMap;
			totalPage = Math.ceil(gp.length / (ROW * COL))
			for(var i:uint = 0; i < ROW; i++)
			{
				for(var j:uint = 0; j < COL; j++)
				{
					var smileBox:SmileBox = new SmileBox(SIZE);
					smileBox.x = (SIZE + 2) * j;
					smileBox.y = (SIZE + 2) * i;
					smileContainer.addChild(smileBox);
					smiles.push(smileBox);
				}
			}

			this.smileContainer.x = (this.width - this.smileContainer.width) * .5;

			var bottomContainer:Sprite = new Sprite();
			leftBut = new Button("", false);
			leftBut.setSkin(new LeftArrwoBg())
			bottomContainer.addChild(leftBut);

			text = new TextField();
			text.textColor = 0xD0CFCF;
			text.selectable = false;
			text.autoSize = "left";
			var tf:TextFormat = new TextFormat(FontUtil.f, null, null, true);
			text.defaultTextFormat = tf;
			text.text = this.curPage + "/" + this.totalPage;
			bottomContainer.addChild(text);

			rightBut = new Button("", false);
			rightBut.setSkin(new RightArrowBg())
			bottomContainer.addChild(rightBut);

			text.x = leftBut.width + 5;
			rightBut.x = text.x + text.width + 5;

			content = new VGroup();
			content.x = 12;
			content.y = top;
			content.gap = 8;
			content.addChild(this.smileContainer);
			content.addChild(bottomContainer);

			var bottomH:Number = bottomContainer.height;
			leftBut.y = (bottomH - leftBut.height) >> 1;
			text.y = (bottomH - text.height) >> 1;
			rightBut.y = (bottomH - rightBut.height) >> 1;

			bottomContainer.x = (content.width - bottomContainer.width) >> 1;
			bottomContainer.y = (content.height - bottomContainer.height) - 5;

			this.addChild(content);

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
			fileSmileres()
		}

		private function fileSmileres():void
		{
			var gp:Vector.<Object> = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).factory.graphicMap;
			totalPage = Math.ceil(gp.length / (ROW * COL));
			text.text = this.curPage + "/" + this.totalPage;

			for(var i:uint = 0; i < smiles.length; i++)
			{
				var curNum:uint = (this.curPage - 1) * 32 + i;
				(Context.getContext(CEnum.UI) as IUIManager).destroyTip(smiles[i]);

				if(curNum < gp.length)
				{
					_dictionary[curNum] = gp[curNum].tag;
					smiles[i].index = curNum;
					var em:BitmapMovieClip = new BitmapMovieClip(true,24,24);
					em.url = gp[curNum].url;
					smiles[i].addChild(em);
					smiles[i].mouseEnabled = true;
					(Context.getContext(CEnum.UI) as IUIManager).registerTip(smiles[i], gp[curNum].tips)
				}
				else
				{
					smiles[i].mouseEnabled = false;
					smiles[i].removeChildren();
				}
			}
		}

		override protected function onAdded(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			this.visible = false;
			this.alpha = 0;

			this.stage.addEventListener(Event.RESIZE, onResize);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		protected function onResize(event:Event):void
		{
			this.visible = false;
			this.alpha = 0;
			if(_target)
			{
				if(_target)
					stage.removeEventListener(MouseEvent.CLICK, clickHandler);
				_target = null;
			}
		}

		protected function clickHandler(event:MouseEvent):void
		{
			if(!this.getBounds(stage).contains(event.stageX, event.stageY))
			{
				disappear();
				return;
			}
			if(event.target is SmileBox)
			{
				//trace("聊天表情",this._dictionary[(event.target as SmileBox).index]);
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.INSERT_SMILE_TAG, {target: this._target, tag: this._dictionary[(event.target as SmileBox).index]}, this._target);
				return;
			}
			switch(event.target)
			{
				case this.rightBut:
					this.curPage = Math.min(++this.curPage, this.totalPage);
					text.text = this.curPage + "/" + this.totalPage;
					break;
				case this.leftBut:
					this.curPage = Math.max(--this.curPage, 1);
					text.text = this.curPage + "/" + this.totalPage;
					break;
			}
			fileSmileres()
		}

		protected function onRemoved(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			this.removeEventListener(MouseEvent.CLICK, clickHandler);
			this.stage.removeEventListener(Event.RESIZE, onResize);
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}

		public function show(target:Object = null):void
		{
			if(this._target)
			{
				stage.removeEventListener(MouseEvent.CLICK, clickHandler);
				this._target = null;
			}
			this.visible = true;
			this.x = target.x;
			this.y = target.y - 30;
			this.alpha = 0;
			this.curPage = 1;
			text.text = this.curPage + "/" + this.totalPage;
			fileSmileres();
			TweenMax.to(this, .5, {x:target.x, y:target.y, alpha:1, onComplete:onComplete, onCompleteParams:[target.content]});
		}

		private function disappear():void
		{
			TweenMax.to(this, .5, {alpha:0, onComplete:function():void
			{
				visible = false;
				if(_target)
					stage.removeEventListener(MouseEvent.CLICK, clickHandler);
				_target = null
			}});
		}

		private function onComplete(value:*):void
		{
			//trace(this._target);
			if(!this._target)
			{
				stage.addEventListener(MouseEvent.CLICK, this.clickHandler);
				this._target = value;
			}
		}
	}
}

import com._17173.flash.show.base.components.common.BitmapMovieClip;

import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

class SmileBox extends Sprite
{
	private var size:Number = 33;
	public var index:uint = 0;

	private var _border:Shape;
	
	private var em:BitmapMovieClip;

	public function SmileBox(size:Number)
	{
		this.mouseChildren = false;
		this.buttonMode = true;
		this.size = size;
		this.graphics.lineStyle(1, 0x9657C3, 0);
		this.graphics.beginFill(0x2C1750);
		this.graphics.drawRect(0, 0, size, size);
		this.graphics.endFill();

		this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}

	protected function onAdded(e:Event):void
	{
		this.removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		this.addEventListener(MouseEvent.MOUSE_OUT, overHandler);
	}

	protected function overHandler(e:MouseEvent):void
	{
		switch(e.type)
		{
			case MouseEvent.MOUSE_OVER:
				this.graphics.lineStyle(1, 0x9657C3, 1);
				this.graphics.beginFill(0x2C1750);
				this.graphics.drawRect(0, 0, size - 1, size - 1);
				this.graphics.endFill();
				if(em)
				{
					em.play();
				}
				break;
			case MouseEvent.MOUSE_OUT:
				this.graphics.lineStyle(1, 0x9657C3, 0);
				this.graphics.beginFill(0x2C1750);
				this.graphics.drawRect(0, 0, size, size);
				this.graphics.endFill();
				if(em)
				{					
					em.gotoAndStop(1);
				}
				break;
		}
	}

	protected function onRemove(e:Event):void
	{
		this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		this.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		this.removeEventListener(MouseEvent.MOUSE_OUT, overHandler);
	}

	override public function addChild(child:DisplayObject):DisplayObject
	{
		em = child as BitmapMovieClip;
		this.removeChildren();
		child.width = child.height = 22;
		child.x = (size - child.width) * .5;
		child.y = (size - child.height) * .5
		super.addChild(child);
		if(em)
		{
			em.stop();
		}
		return child
	}
}
