package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.interfaces.IItemRender;

	import flash.events.Event;


	/**
	 * @author idzeir
	 * 创建时间：2014-2-18  下午2:32:42
	 */
	public class UserListTabButton extends Button implements IItemRender
	{
		public function UserListTabButton()
		{
			super(" ", false);
			this.setSkin(new TabButtonBg());
		}

		public function startUp(value:Object):void
		{
			this.label = value.label;
			this.width = 57;
			this.height = 26;
			this.mouseChildren = false;
			this._labelTxt.alpha = .7;
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
		}

		public function unSelected():void
		{
			this.selected = false;
			this.buttonMode = true;
			this.scaleY = 1;
		}
	}
}