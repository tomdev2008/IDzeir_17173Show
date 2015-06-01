package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.interfaces.IItemRender;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-18  下午3:14:46
	 */
	public class ChatListTabButton extends Button implements IItemRender
	{
		private var baseLabel:String = "";

		private var totalCache:uint = 0;
		private var _index:uint = 0;

		public function ChatListTabButton()
		{
			super(" ", false);
			setSkin(new TabButtonSkin1_8());
		}

		public function startUp(value:Object):void
		{
			baseLabel = value.label;
			this.label = value.label;
			this._index = value.index;
			this.width = 80;
			this.height = 30;
			this.mouseChildren = false;
			(Context.getContext(CEnum.EVENT) as IEventManager).listen(SEvents.TAB_BUTTON_FLASH, function(index:int):void
				{
					if(_index == index)
					{
						totalCache++;
						label = baseLabel + "<b><font size='10' color='#ff0000'> (" + (totalCache <= 99 ? totalCache : "99+") + ")</font></b>";
					}
				});
			//this._labelTxt.alpha = .7;
		}

		/**
		 * 重写Button 方法 选中状态下跳转到第三帧
		 * @param value
		 *
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			this.label = baseLabel;
			totalCache = 0;
			if(selected)
			{
				this.skinVo.updateSkinState("selected");
			}
			this.scaleY = 1.03;
		}

		override protected function onMouseDown(e:Event):void
		{
			if(this.selected)
			{
				return;
			}
			super.onMouseDown(e);
		}

		override protected function onMouseUp(e:Event):void
		{
			if(this.selected)
			{
				return;
			}
			super.onMouseUp(e);
		}

		override protected function onOver(e:Event):void
		{
			if(this.selected)
			{
				return;
			}
			super.onOver(e);
		}

		override protected function onOut(e:Event):void
		{
			if(this.selected)
			{
				return;
			}
			super.onOut(e);
		}

		public function onMouseOver():void
		{
		}

		public function onMouseOut():void
		{
		}

		public function onSelected():void
		{
			this.selected = true;
			this.buttonMode = false;
			this.scaleY = 1.03;
			this._labelTxt.textColor = 0xFFCC01;
		}

		public function unSelected():void
		{
			this.selected = false;
			this.buttonMode = true;
			this.scaleY = 1;
			this._labelTxt.textColor = 0xd598af;
		}
	}
}