package com._17173.flash.show.base.module.roomset.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.DefaultTextField;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	/**
	 *移动观众 
	 * @author zhaoqinghao
	 * 
	 */	
	public class ChangeRoomPanel extends BasePanel
	{
		
		private var _gonggaoTextInput:TextField = null;
		private var _gonggaoUrl:DefaultTextField = null;
		private var _submitBtn:Button;
		public function ChangeRoomPanel()
		{
			super();
			mouseEnabled = false;
		}
		
		override protected function onInit():void{
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			super.onInit();
			this.width = 230;
			this.height = 185;
			this.titleStr = lc.get("move_usertitle","bottom");
			
			//文本背景
			var bg:MovieClip = new Bottom_TextBg();
			bg.width = 208;
			bg.height = 89;
			bg.x = 10;
			bg.y = 45;
			bg.mouseEnabled = false;
			this.addChild(bg);
			
			_gonggaoTextInput = new TextField();
			_gonggaoTextInput.x = 12;
			_gonggaoTextInput.y = 47;
			_gonggaoTextInput.type = TextFieldType.INPUT;
			_gonggaoTextInput.width = 200;
			_gonggaoTextInput.height = 80;
			_gonggaoTextInput.text = lc.get("move_userurl1","bottom");
			_gonggaoTextInput.alpha = 0.6;
			_gonggaoTextInput.wordWrap = true;
			this.addChild(_gonggaoTextInput);
			
			_submitBtn = new Button(lc.get("btn_submit","components"));
			_submitBtn.x = 131;
			_submitBtn.y = 150;
			_submitBtn.width = 85;
			_submitBtn.height = 27;
			this.addChild(_submitBtn);
		}
		
		override protected function onShow():void{
			super.onShow();
			_submitBtn.addEventListener(MouseEvent.CLICK,onSubmitClick);
			Context.stage.addEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		override protected function onHide():void{
			super.onHide();
			_submitBtn.addEventListener(MouseEvent.CLICK,onSubmitClick);
			Context.stage.removeEventListener(MouseEvent.CLICK,onStageClick);
		}
		
		
		private function onSubmitClick(e:MouseEvent):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//提交数据
			var text:String = _gonggaoTextInput.text;
			if(_gonggaoTextInput.text == ""){
				var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
				ui.popupAlert(local.get("system_title","components"),local.get("panel_label_move_url","bottom"),Alert.ICON_STATE_FAIL,Alert.BTN_OK);
				return;
			}
			
			var data:Object = {};
			data.url = text;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.SEND_MOVEUSER,data,onSecc);
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
		
		private function onSecc(obj:Object):void{
			hide();
		}
		
	}
}