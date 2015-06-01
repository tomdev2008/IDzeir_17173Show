package  com._17173.flash.show.base.module.roomset.view
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
	import flash.text.TextFieldType;

	/**
	 *公告编辑 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GongGaoEditPanel extends BasePanel
	{
		
		private var _gonggaoTextInput:DefaultTextField = null;
		private var _gonggaoUrl:DefaultTextField = null;
		private var _submitBtn:Button;
		public function GongGaoEditPanel()
		{
			super();
		}
		
		override protected function onInit():void{
			super.onInit();
			this.width = 230;
			this.height = 220;
			this.mouseEnabled = false;
			this.titleStr = "编辑房间公告";
			
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			//文本背景
			var bg:MovieClip = new Bottom_TextBg();
			bg.width = 208;
			bg.height = 89;
			bg.x = 10;
			bg.y = 45;
			bg.mouseEnabled = false;
			this.addChild(bg);
			
			_gonggaoTextInput = new DefaultTextField(local.get("panel_label_gonggao_d1","bottom"));
			_gonggaoTextInput.x = 12;
			_gonggaoTextInput.y = 47;
			_gonggaoTextInput.type = TextFieldType.INPUT;
			_gonggaoTextInput.width = 200;
			_gonggaoTextInput.alpha = .6;
			_gonggaoTextInput.height = 80;
			_gonggaoTextInput.wordWrap = true;
			this.addChild(_gonggaoTextInput);
			
			
			bg = new Bottom_TextBg();
			bg.width = 208;
			bg.height = 26;
			bg.x = 10;
			bg.y = 145;
			this.addChild(bg);
			
			_gonggaoUrl = new DefaultTextField(local.get("panel_label_gonggao_d2","bottom"));
			_gonggaoUrl.x = 0;
			_gonggaoUrl.x = 12;
			_gonggaoUrl.y = 147;
			_gonggaoUrl.type = TextFieldType.INPUT;
			_gonggaoUrl.width = 200;
			_gonggaoUrl.alpha = .6;
			_gonggaoUrl.height = 25;
			this.addChild(_gonggaoUrl);
			
			_submitBtn = new Button(local.get("btn_submit","components"));
			_submitBtn.x = 131;
			_submitBtn.y = 185;
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
		
		public function updateInfo(cont:String, url:String):void{
			if(cont == null || cont == ""){
				return;
			}
			_gonggaoTextInput.text = cont;
			
			if(url == null || url == ""){
				return;
			}
			_gonggaoUrl.text = url;
		}
		
		
		private function onSubmitClick(e:MouseEvent):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var text:String = _gonggaoTextInput.text;
			var url:String = _gonggaoUrl.text;
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			if(text == local.get("panel_label_gonggao_d1","bottom")){
				ui.popupAlert(local.get("system_title","components"),local.get("panel_label_gonggao_t1","bottom"),Alert.ICON_STATE_FAIL,Alert.BTN_OK);
				return;
			}
			if(url == local.get("panel_label_gonggao_d2","bottom")){
				url = "";
			}
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			//房间公告40限制
			if(text.length > 40){
				ui.popupAlert(local.get("system_title","components"),local.get("panel_label_gonggao_d1","bottom"),Alert.ICON_STATE_FAIL,Alert.BTN_OK);
				return;
			}
			//提交数据
			var data:Object = {};
			data.type = "2";
			data.text = text;
			data.url = url;
			data.result = "json";
			data.roomId = (Context.variables["showData"] as ShowData).roomID;
			server.http.getData(SEnum.FN_SET,data,onSecc);
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