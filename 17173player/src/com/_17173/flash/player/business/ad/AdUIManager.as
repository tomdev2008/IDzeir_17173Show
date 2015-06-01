package com._17173.flash.player.business.ad
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.UIManager;
	import com._17173.flash.player.ui.PopupLayer;
	
	public class AdUIManager extends UIManager
	{
		public function AdUIManager()
		{
			super();
		}
		
		override protected function initComponents():void {
			_adLayer = new PopupLayer();
			_adLayer.name = "adpopup";
			_layers[_adLayer.name] = _adLayer;
			Context.stage.addChild(_adLayer);
		}
		
		override public function get avalibleVideoHeight():Number {
			return Context.stage.stageHeight;
		}
		
	}
}