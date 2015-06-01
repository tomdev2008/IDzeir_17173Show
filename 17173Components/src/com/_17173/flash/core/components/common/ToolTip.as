package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.skin.SkinType;
	import com._17173.flash.core.components.skin.skinclass.BaseSkinClass;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * tooltip 
	 * @author zhaoqinghao
	 * 
	 */	
	public class ToolTip extends SkinComponent
	{
		private const FONT_NAME:String = "Microsoft YaHei,微软雅黑,宋体,Monaco";
		private var _showTextStr:String = "";
		private var _showText:TextField = null;
		public function ToolTip()
		{
			super();
		}
		
		override protected function initSkinVo():void{
			_skinVo = new BaseSkinClass(SkinType.SKIN_TYPE_BASE,this);
		}
		
		/**
		 *显示tip
		 * @param tip
		 * 
		 */		
		public function setTip(tip:String):void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_ALERT_COLOR;
			textFormat.font = FONT_NAME;
			textFormat.size = 12;
			_showTextStr = tip;
			if(_showText == null){
				_showText = new TextField();
				_showText.mouseEnabled = false;
				_showText.x = 10;
				_showText.y = 5;
				_showText.wordWrap = false;
				_showText.multiline = true;
			}
			_showText.setTextFormat(textFormat);
			_showText.defaultTextFormat = textFormat;
			_showText.htmlText = _showTextStr;
			_showText.width = _showText.textWidth + 4;
			_showText.height = _showText.textHeight + 4;
			
			var tw:int = _showText.textWidth + 4;
			var th:int = _showText.textHeight + 4;
			this.width = int(tw + 20);
			this.height = int(th + 10);
			this.addChild(_showText);
		}
	}
}