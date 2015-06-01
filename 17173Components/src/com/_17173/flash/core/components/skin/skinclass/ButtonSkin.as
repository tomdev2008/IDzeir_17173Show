package com._17173.flash.core.components.skin.skinclass
{
	import com._17173.flash.core.components.interfaces.ISkinComponent;
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class ButtonSkin extends BaseSkinClass
	{
		public function ButtonSkin(skinType:String,skinCpnt:ISkinComponent)
		{
			super(skinType, skinCpnt);
		}
		protected var btnMc:MovieClip = null

		override protected function onUpdateState():void
		{
			// TODO Auto Generated method stub
			super.onUpdateState();
			updateByButtonStatues();
		}


		override protected function onInitAdd():void
		{
			if (skinInfo && skinInfo.hasOwnProperty("button"))
			{
				btnMc = skinInfo["button"];
				this.addSkinUI("button",btnMc);
			}
			updateByButtonStatues();
		}
		
		override protected function onChangeSkin(skin:Object):void{
			super.onChangeSkin(skin);
			if (skin && skin.hasOwnProperty("button"))
			{
				btnMc = skin["button"];
				this.addSkinUI("button",btnMc);
			}
			if(btnMc == null){
				skinComponent.changeRect(0,0);
			}else{
				btnMc.gotoAndStop(1);
				skinComponent.changeRect(btnMc.width,btnMc.height);
			}
		}
		
		private function updateByButtonStatues():void
		{
			if (btnMc == null)
				return;
			var status:String = skinState as String;
			if(status == null){
				status = "out";
			}
			switch (status)
			{
				case "up":
				{
					btnMc.gotoAndStop(2);
					break;
				}
				case "over":
				{
					btnMc.gotoAndStop(2);
					break;
				}
				case "down":
				{
					btnMc.gotoAndStop(3);
					break;
				}
				case "out":
				{
					btnMc.gotoAndStop(1);
					break;
				}
				case "selected":
				{
					btnMc.gotoAndStop(4);
					break;
				}
			}
		}

		override public function resize():void
		{
			if (btnMc)
			{
				var rect:Rectangle = skinComponent.getCompRect();
				if(rect.width != 0 && rect.height != 0){
					btnMc.width = skinComponent.getCompRect().width;
					btnMc.height = skinComponent.getCompRect().height;
				}else{
					skinComponent.changeRect(btnMc.width,btnMc.height);
				}
			}
		}

	}
}
