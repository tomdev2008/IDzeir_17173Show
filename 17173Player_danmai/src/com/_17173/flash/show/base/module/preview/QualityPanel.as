package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.components.common.RadioGroup;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 分辨率Panel 
	 * @author qiuyue
	 * 
	 */	
	public class QualityPanel extends Sprite
	{
		private var _e:IEventManager = null;
		private var _jsProxy:JSProxy = JSProxy.getInstance();
		
		/**
		 * 分辨率界面 
		 */		
		private var _quality:Quality = null;
		
		/**
		 * 单选控制 
		 */		
		private var _radioGroup:RadioGroup = null;
		private var _whiteFormat:TextFormat = null;
		private var _blackFormat:TextFormat = null;
		private var _qualityHigh:TextField = null;
		private var _qualityMid:TextField = null;
		private var _qualityLow:TextField = null;
		private var _qualityHighInfo:TextField = null;
		private var _qualityMidInfo:TextField = null;
		private var _qualityLowInfo:TextField = null;
		
		private var _btn:Button = null;
		
		private var _index:int = -1;
		
		public function QualityPanel()
		{
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_quality = new Quality();
			this.addChild(_quality);
			_radioGroup = new RadioGroup();
			_radioGroup.pushRadio(_quality.radioButton1, select1);
			_radioGroup.pushRadio(_quality.radioButton2, select2);
			_radioGroup.pushRadio(_quality.radioButton3, select3);
			_whiteFormat = FontUtil.DEFAULT_FORMAT;
			_whiteFormat.color = 0xFFFFFF;
			_whiteFormat.size =14;
			_qualityHigh = new TextField();
			_qualityHigh.defaultTextFormat = _whiteFormat;
			_qualityHigh.x = 37;
			_qualityHigh.y = 37;
			_qualityHigh.selectable = false;
			_qualityHigh.autoSize = TextFieldAutoSize.LEFT;
			_qualityHigh.text = Context.getContext(CEnum.LOCALE).get("qualityHigh", "camModule");
			this.addChild(_qualityHigh);
			_qualityMid = new TextField();
			_qualityMid.defaultTextFormat = _whiteFormat;
			_qualityMid.x = 37;
			_qualityMid.y = 79;
			_qualityMid.selectable = false;
			_qualityMid.autoSize = TextFieldAutoSize.LEFT;
			_qualityMid.text = Context.getContext(CEnum.LOCALE).get("qualityMid", "camModule");
			this.addChild(_qualityMid);
			_qualityLow = new TextField();
			_qualityLow.defaultTextFormat = _whiteFormat;
			_qualityLow.x = 37;
			_qualityLow.y = 125;
			_qualityLow.selectable = false;
			_qualityLow.autoSize = TextFieldAutoSize.LEFT;
			_qualityLow.text = Context.getContext(CEnum.LOCALE).get("qualityLow", "camModule");
			this.addChild(_qualityLow);
			_blackFormat = FontUtil.DEFAULT_FORMAT;
			_blackFormat.color = 0x848484;
			_blackFormat.size = 12;
			_qualityHighInfo = new TextField();
			_qualityHighInfo.defaultTextFormat = _blackFormat;
			_qualityHighInfo.x = 32;
			_qualityHighInfo.y = 58;
			_qualityHighInfo.selectable = false;
			_qualityHighInfo.autoSize = TextFieldAutoSize.LEFT;
			_qualityHighInfo.text = Context.getContext(CEnum.LOCALE).get("qualityHighInfo", "camModule");
			this.addChild(_qualityHighInfo);
			_qualityMidInfo = new TextField();
			_qualityMidInfo.defaultTextFormat = _blackFormat;
			_qualityMidInfo.x = 32;
			_qualityMidInfo.y = 100;
			_qualityMidInfo.selectable = false;
			_qualityMidInfo.autoSize = TextFieldAutoSize.LEFT;
			_qualityMidInfo.text = Context.getContext(CEnum.LOCALE).get("qualityMidInfo", "camModule");
			this.addChild(_qualityMidInfo);
			_qualityLowInfo = new TextField();
			_qualityLowInfo.defaultTextFormat = _blackFormat;
			_qualityLowInfo.x = 32;
			_qualityLowInfo.y = 145;
			_qualityLowInfo.selectable = false;
			_qualityLowInfo.autoSize = TextFieldAutoSize.LEFT;
			_qualityLowInfo.text = Context.getContext(CEnum.LOCALE).get("qualityLowInfo", "camModule");
			this.addChild(_qualityLowInfo);
			
			_btn = new Button(Context.getContext(CEnum.LOCALE).get("upMic", "camModule"));
			this.addChild(_btn);
			_btn.x = 40;
			_btn.y = 185;
			_btn.addEventListener(MouseEvent.CLICK,click);
		}
		
		public function init():void{
			VideoEquipmentManager.getInstance().isSetPluginCamera();
			if(VideoEquipmentManager.getInstance().isPluginSelected){
				_index = 0;
				_quality.radioButton1.gotoAndStop(2);
				_quality.radioButton2.gotoAndStop(1);
				_quality.radioButton3.gotoAndStop(1);
				_radioGroup.radio = _quality.radioButton1;
			}else{
				_index = 1;
				if(VideoEquipmentManager.getInstance().isFlashXDown == 1){
					_quality.radioButton1.mouseEnabled = true;
					_quality.radioButton2.gotoAndStop(2);
				}else{
					_quality.radioButton1.mouseEnabled = false;
					_quality.radioButton2.gotoAndStop(2);
				}
				_quality.radioButton1.gotoAndStop(1);
				_quality.radioButton3.gotoAndStop(1);
				_radioGroup.radio = _quality.radioButton2;
			}
			_e.send(SEvents.CHANGE_CAMERA);
		}
		
		public function update():void{
			if(Context.variables.showData.camInit){
				this.visible = false;
			}else{
				this.visible = true;
			}
		}
		
		private function click(e:MouseEvent):void{
			if(_index != -1){
				VideoEquipmentManager.getInstance().qualityIndex = _index;
				_e.send(SEvents.QUALITYPANEL_CLOSE);
			}
		}
		
		public function popDownLoadProxy():void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var iLocale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var alert:Alert = new Alert(iLocale.get("downTitle", "jsProxy"), iLocale.get("downloadInfo", "jsProxy"), -1, Alert.BTN_OK | Alert.BTN_CANCEL, okFun, cancelFun, iLocale.get("downBtn", "jsProxy"), iLocale.get("downBtnClose", "jsProxy"));
			alert.showCloseBtn = false;
			ui.popupAlertPanel(alert);
		}
		
		private function okFun():void{
			Util.toUrl(VideoEquipmentManager.getInstance().flashXUrl);
			select2();
			_quality.radioButton1.gotoAndStop(1);
			_quality.radioButton2.gotoAndStop(2);
			_radioGroup.radio = _quality.radioButton2;
		}
		
		private function cancelFun():void{
			select2();
			_quality.radioButton1.gotoAndStop(1);
			_quality.radioButton2.gotoAndStop(2);
			_radioGroup.radio = _quality.radioButton2;
		}
		
		/**
		 * 单选1 
		 * 
		 */		
		private function select1():void
		{
			if(VideoEquipmentManager.getInstance().isFlashXDown == 1 && VideoEquipmentManager.getInstance().isFlashX == 0){
				popDownLoadProxy();
			}else{
				_index = 0;
				VideoEquipmentManager.getInstance().isUsePlugin = true;
				_e.send(SEvents.QUALITY_CHANGE);
			}
		}
		/**
		 * 单选2 
		 * 
		 */	
		private function select2():void
		{
			changeCamMode(true);
			_index = 1;
			_e.send(SEvents.QUALITY_CHANGE);
		}
		/**
		 * 单选3 
		 * 
		 */	
		private function select3():void
		{
			changeCamMode(false);
			_index = 2;
			_e.send(SEvents.QUALITY_CHANGE);
		}
		
		private function cancel():void
		{
			
		}
		/**
		 * 更改分辨率 
		 * @param isMid
		 * 
		 */		
		private function changeCamMode(isMid:Boolean):void
		{
			VideoEquipmentManager.getInstance().setQulityMode(isMid);
		}
	}
}