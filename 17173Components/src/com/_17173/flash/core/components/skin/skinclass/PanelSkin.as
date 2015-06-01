package com._17173.flash.core.components.skin.skinclass
{
	import com._17173.flash.core.components.base.BaseContainer;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.interfaces.ISkinComponent;
	import com._17173.flash.core.components.skin.SkinType;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class PanelSkin extends BaseSkinClass
	{
		public function PanelSkin(skinCpnt:ISkinComponent)
		{
			super(SkinType.SKIN_TYPE_PANEL, skinCpnt);
		}
		/**
		*关闭按钮
		*/
		protected var closeBtn:Button = null;
		/**
		 *title分割线
		 */
		protected var titleLine:MovieClip = null;

		override protected function onInitAdd():void
		{
			// TODO Auto Generated method stub
			super.onInitAdd();
			initLine();
			initCloseBtn();
		}

		override public function rePostion():void
		{
			// TODO Auto Generated method stub
			super.rePostion();
			onRePostionLine();
			onRePostionCloseBtn();
		}

		override public function resize():void
		{
			// TODO Auto Generated method stub
			super.resize();
		}

		/**
		 *分割线初始化
		 *
		 */
		protected function initLine():void
		{
			if (skinInfo && skinInfo.hasOwnProperty("line"))
			{
				titleLine = skinInfo["line"];
				titleLine.y = 39;
				this.addSkinUI("line",titleLine);
			}
		}

		/**
		 *初始化关闭按钮
		 *
		 */
		protected function initCloseBtn():void
		{
			if (skinInfo && skinInfo.hasOwnProperty("close"))
			{
				closeBtn =new Button();
				closeBtn.setSkin(skinInfo["close"]);
				this.addSkinUI("close",closeBtn);
			}
		}
		

		/**
		 *更新关闭按钮位置
		 *
		 */
		protected function onRePostionCloseBtn():void
		{
			if (closeBtn)
			{
				closeBtn.x = skinComponent.getCompRect().width - closeBtn.width - 10;
				closeBtn.y = 7;
			}
		}

		
		override protected function onChangeSkin(skin:Object):void{
			super.onChangeSkin(skin);
			if (skin && skin.hasOwnProperty("close"))
			{
				closeBtn.setSkin(skin["close"]);
				this.addSkinUI("close",closeBtn);
			}
			if (skin && skin.hasOwnProperty("line"))
			{
				titleLine = skin["line"];
				this.addSkinUI("line",titleLine);
			}
		}
		
		override public function updateSkinState(state:Object):void
		{
			// TODO Auto Generated method stub
			super.updateSkinState(state);
			var type:String = state as String;
			switch (type)
			{
				case "showLine":
				{
					if (titleLine)
					{
						titleLine.visible = true;
					}
					break;
				}
				case "hideLine":
				{
					if (titleLine)
					{
						titleLine.visible = false;
					}
					break;
				}
				case "showClose":
				{
					if (closeBtn)
					{
						closeBtn.visible = false;
					}
					break;
				}
				case "HideClose":
				{
					if (closeBtn)
					{
						closeBtn.visible = false;
					}
					break;
				}
			}

		}

		/**
		 *更新分割线位置
		 *
		 */
		protected function onRePostionLine():void
		{
			if (titleLine)
			{
				titleLine.width = skinComponent.getCompRect().width - 2;
			}
		}


		override public function onShow():void
		{
			if (closeBtn)
			{
				closeBtn.addEventListener(MouseEvent.CLICK, onCloseClick);
			}
		}

		override public function onHide():void
		{
			if (closeBtn)
			{
				closeBtn.removeEventListener(MouseEvent.CLICK, onCloseClick);
			}
		}

		protected function onCloseClick(e:MouseEvent):void
		{
			(skinComponent as BasePanel).onCloseClick(e);
		}


	}
}
