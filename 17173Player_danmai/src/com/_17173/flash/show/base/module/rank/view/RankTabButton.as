package com._17173.flash.show.base.module.rank.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.interfaces.IItemRender;
	
	import flash.events.Event;
	
	/**
	 *排行榜 tab button 
	 * @author Administrator
	 */	
	public class RankTabButton extends Button implements IItemRender
	{
		public function RankTabButton(label:String="", isSelected:Boolean=false)
		{
			super(label, isSelected);
			this.setSkin(new RankTabBtn());
			width = 145;
		}
		
		public function startUp(value:Object):void
		{
			this.label = value.label;
			this.mouseChildren = false;
		}
		/**
		 * 重写Button 方法 选中状态下跳转到第三帧
		 * @param value
		 *
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			if(selected)
			{
				this.skinVo.updateSkinState("selected");
			}
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
			this._labelTxt.textColor = 0xFFCC01;
		}
		
		public function unSelected():void
		{
			this.selected = false;
			this.buttonMode = true;
			this._labelTxt.textColor = 0xD598AF;
		}
	}
}