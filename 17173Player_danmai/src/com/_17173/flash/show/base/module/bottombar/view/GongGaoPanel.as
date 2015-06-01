package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *公告 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GongGaoPanel extends BasePanel
	{
		
		private var _showLabel:TextField = null;
		private var _showString:String = null;
		private var _url:String = null;
		public function GongGaoPanel()
		{
			super();
		}
		
		/**
		 * 设置公告信息及连接
		 * @param htmltext 公告文字
		 * @param url 超链接为空则不打开新窗口
		 * 
		 */
		public function updateShowString():void
		{
			var showData:ShowData = Context.variables["showData"] as ShowData;
			var gg:Object = showData.announcement;
			if(gg != null){
				_showString = gg.text;
				_url = gg.link;
			}else{
				var _ilocal:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				_showString = _ilocal.get("defaultNotice","chatPanel");
			}
			updateText();
		}

		override protected function onInit():void{
			super.onInit();
			this.width = 216;
			this.height = 154;
			this.mouseEnabled = false;
			var _ilocal:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			this.titleStr = _ilocal.get("panel_label_gonggao","bottom");
			initShowText();
		}
		
		override protected function onShow():void{
			super.onShow();
			Context.stage.addEventListener(MouseEvent.CLICK,onStageClick);
//			_showLabel.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override protected function onHide():void{
			super.onHide();
			_showLabel.removeEventListener(MouseEvent.CLICK,onClick);
			Context.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		override protected function onUpdate():void{
			updateShowString();
		}
		
		private function initShowText():void{
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = FontUtil.FONT_COLOR_BLUE1;
			textFormat.font = FontUtil.f;
			
			_showLabel = new TextField();
			_showLabel.x = 9;
			_showLabel.y = 47;
			_showLabel.width = 197;
			_showLabel.selectable = false;
			_showLabel.wordWrap = true;
			_showLabel.height = 90;
			_showLabel.defaultTextFormat = textFormat;
			_showLabel.setTextFormat(textFormat);
			this.addChild(_showLabel); 
		}
		
		private function updateText():void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = FontUtil.FONT_COLOR_BLUE1;
			textFormat.font = FontUtil.f;
			if(_showString == null || _showString == ""){
				var _ilocal:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
				_showString = _ilocal.get("defaultNotice","chatPanel");
			}
			if(_url != null && _url != ""){
				_showLabel.mouseEnabled = true;
				textFormat.underline = true;
				textFormat.target = "_blank"
				textFormat.url = _url;
			}else{
				_showLabel.mouseEnabled = false;
				textFormat.underline = false;
				textFormat.url = null;
			}
			_showLabel.text = Utils.formatToString(_showString);
			_showLabel.defaultTextFormat = textFormat;
			_showLabel.setTextFormat(textFormat);
		}
		
		/**
		 *如果点击了屏幕 则关闭 
		 * @param e
		 * 
		 */		
		private function onStageClick(e:Event):void{
			if(!Utils.checkIsChild(e.target as DisplayObject,this)){
				hide();
			}
		}
		
		/**
		 *如果有超链接则打开新窗体 
		 * @param e
		 * 
		 */		
		private function onClick(e:Event):void{
			if(_url){
				navigateToURL(new URLRequest(_url),"_blank");
			}
		}
	}
}