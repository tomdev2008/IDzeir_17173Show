package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 选择摄像头界面 
	 * @author qiuyue
	 * 
	 */	
	public class SelectorPanel extends Sprite
	{
//		private static const MAX_NUMBER:int = 3;
		
		private var _e:IEventManager = null;
		/**
		 * 摄像头数组 
		 */		
		private var _camArray:Array = null;
		/**
		 * 麦克风数组 
		 */		
		private var _micArray:Array = null;
		/**
		 * 摄像头下拉列表 
		 */		
		private var _camSelect:SelectorDropDownList = null;
		/**
		 * 麦克风下拉列表 
		 */		
		private var _micSelect:SelectorDropDownList = null;
			
		private var _camButton:DropListButton = null;
		private var _micButton:DropListButton = null;
		
		private var _camText:TextField = null;
		private var _format:TextFormat = null;
		private var _liveText:TextField = null;
		/**
		 * 下一步按钮 
		 */		
		private var _button:Button = null;
		
		private var micvector:Vector.<Object> = new Vector.<Object>();
		
		private var camvector:Vector.<Object> = new Vector.<Object>();
		
		private var _locale:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
		
//		6间房直播伴侣(6RoomsCamV9)、呱呱K歌伴侣(17GuaGua Cam)、MVBox(Virtual Cam)、YY伴侣(YY伴侣)、我秀直播伴侣(我秀直播伴侣)、酷狗繁星伴侣(繁星伴奏)、搜狐插件(vshow  vcam)
//		e2eSoft VCam  6RoomsCamV9  vshow_vcam YY伴侣    17GuaGua Cam    Virtual Cam   繁星伴奏    我秀直播伴侣
		
//		private var shieldArray:Array = ["vshow_vcam", "6RoomsCam", "GuaGua", "Virtual Cam", "YY伴侣", "我秀直播", "繁星", "e2eSoft VCam"];
		private var shieldArray:Array = ["vshow_vcam"];
		public function SelectorPanel()
		{
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
			_format = FontUtil.DEFAULT_FORMAT;
			_format.color = 0x4d4d4d;
			_format.size = 14;
			_camText = new TextField();
			_camText.defaultTextFormat = _format;
			_camText.autoSize = TextFieldAutoSize.LEFT;
			_camText.selectable = false;
			_camText.x = 43;
			_camText.y = 21;
			_camText.text = Context.getContext(CEnum.LOCALE).get("camTitle", "camModule");
			this.addChild(_camText);
			_liveText = new TextField();
			_liveText.defaultTextFormat = _format;
			_liveText.autoSize = TextFieldAutoSize.LEFT;
			_liveText.selectable = false;
			_liveText.x = 43;
			_liveText.y = 82;
			_liveText.text = Context.getContext(CEnum.LOCALE).get("liveTitle", "camModule");
			this.addChild(_liveText);
			_button = new Button(Context.getContext(CEnum.LOCALE).get("selectBtn", "camModule"));
			_button.width= 94;
			_button.height = 28;
			_button.x = 88;
			_button.y = 154;
			this.addChild(_button);
			_button.addEventListener(MouseEvent.CLICK,nextClick);
		}
		private function addToStage(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			_camArray = [];
			var array:Array = [];
			try
			{
				array = Camera.names;
				_micArray = Microphone.names;
				var i:int = 0;
				var length:int = array.length;
				for(; i< length; i++){
					var name:String = array[i];
					var isShield:Boolean = true;
					for(var j:int =0 ;j< shieldArray.length; j++){
						var shield:String = shieldArray[j];
						if(name.indexOf(shield) != -1){
							isShield = false;
							break;
						}else{
							continue;
						}
					}
					if(isShield){
						_camArray.push(name);
					}
				}
			} 
			catch(error:Error) 
			{
				(Context.getContext(CEnum.UI) as IUIManager).popupAlert("提示","flash读取摄像头和麦克风时出现错误",-1,Alert.BTN_OK);
			}
		
			initMicPanel();
			initCamPanel();
		}
		/**
		 * 初始化MicPanel
		 * 
		 */		
		private function initMicPanel():void
		{
			if(!_micSelect){
				_micSelect = new SelectorDropDownList("down",Microphone.names.length,SelectItemRender);
			}
			if(!this.contains(_micSelect)){
				_micSelect.x = 45;
				_micSelect.y = 109;
				this.addChild(_micSelect);
				var mic:Microphone = Microphone.getMicrophone();
				micvector = new Vector.<Object>();
				var obj:Object;
				if(_micArray.length > 0){
					for(var j:int = 0;j<_micArray.length;j++){
						if(mic && mic.name == _micArray[j]){
							continue;
						}
//						if(micvector.length >= MAX_NUMBER){
//							break;
//						}else{
							obj = new Object();
							obj.name = _micArray[j];
							micvector.push(obj);
//						}
					}
					if(mic){
						obj = new Object();
						obj.name = mic.name;
						micvector.push(obj);
					}
				}else{
					obj = new Object();
					obj.name = _locale.get("noMic", "camModule");
					micvector.push(obj);
				}
				_micSelect.dataProvider = micvector;
				_micSelect.addEventListener(Event.OPEN, micOpen);
				_micSelect.addEventListener(Event.CLOSE, micClosed);	
				if(micvector.length > 1){
					_micButton = new DropListButton();
					_micButton.addEventListener(MouseEvent.CLICK,micClick);
					_micButton.stop();
					_micButton.x = 207;
					_micButton.y = 120;
					this.addChild(_micButton);
				}
			}
			
		}
		
		private function micClick(e:MouseEvent):void{
			e.stopPropagation();
			if(_micSelect.isOpen){
				_micSelect.close();
			}else{
				_micSelect.open();
			}
		}
		
		/**
		 * 初始化CamPanel
		 * 
		 */		
		private function initCamPanel():void
		{
			if(!_camSelect){
				_camSelect = new SelectorDropDownList("down", Camera.names.length, SelectItemRender);
			}
			if(!this.contains(_camSelect)){
				_camSelect.x = 45;
				_camSelect.y = 47;
				this.addChild(_camSelect);
				
				camvector = new Vector.<Object>();
				var obj:Object;
				if(_camArray.length > 0){
					for(var i:int = 0;i<_camArray.length;i++){
//						if(camvector.length >= MAX_NUMBER){
//							break;
//						}else{
							obj = new Object();
							obj.name = _camArray[i];
							camvector.push(obj);
//						}
					}
				}else{
					obj = new Object();
					obj.name = _locale.get("noCamera", "camModule");
					camvector.push(obj);
				}
				_camSelect.dataProvider = camvector;
				_camSelect.addEventListener(Event.OPEN,camOpen);
				_camSelect.addEventListener(Event.CLOSE,camClosed);
				if(camvector.length > 1){
					_camButton = new DropListButton();
					_camButton.addEventListener(MouseEvent.CLICK,camClick);
					_camButton.stop();
					_camButton.x = 207;
					_camButton.y = 59;
					this.addChild(_camButton);
				}
			}
		}
		
		private function camClick(e:MouseEvent):void{
			e.stopPropagation();
			if(_camSelect.isOpen){
				_camSelect.close();
			}else{
				_camSelect.open();
			}
		}
		/**
		 * 设置Camer
		 * @return 
		 * 
		 */		
		private function setCamer():Boolean
		{
			Debugger.log(Debugger.INFO,"插件推流状态为： "+ VideoEquipmentManager.getInstance().isFlashX);
			var camName:String = _camSelect.selected.name;
			return VideoEquipmentManager.getInstance().setCamera(camName);
		}
		
		/**
		 * 设置Mic 
		 * @return 
		 * 
		 */	
		private function setMic():Boolean
		{
			var micName:String = _micSelect.selected.name;
			return VideoEquipmentManager.getInstance().setMic(micName);
		}
		
		/**
		 * 计算Cam背景 
		 * @param e
		 * 
		 */		
		private function camOpen(e:Event):void
		{
			_camSelect.bg.height = SelectorDropDownList.ITEM_HEIGHT * camvector.length;
		}
		/**
		 * Cam背景关闭 
		 * @param e
		 * 
		 */		
		private function camClosed(e:Event):void
		{
			_camSelect.bg.height = SelectorDropDownList.ITEM_HEIGHT;
		}
		
		/**
		 * 计算Mic背景 
		 * @param e
		 * 
		 */		
		private function micOpen(e:Event):void
		{
			_micSelect.bg.height = SelectorDropDownList.ITEM_HEIGHT * micvector.length;
		}
		/**
		 * Mic背景关闭 
		 * @param e
		 * 
		 */		
		private function micClosed(e:Event):void
		{
			_micSelect.bg.height = SelectorDropDownList.ITEM_HEIGHT;
		}
		/**
		 * 下一步 
		 * @param e
		 * 
		 */		
		private function nextClick(e:MouseEvent):void
		{
 			if(setMic() && setCamer())
			{
				_e.send(SEvents.SELECTPANEL_CLOSE);
			}
			else
			{
				(Context.getContext(CEnum.UI) as UIManager).popupAlert("",Context.getContext(CEnum.LOCALE).get("failSelect", "camModule"),-1,1);
			}
		}
			
		
	}
}