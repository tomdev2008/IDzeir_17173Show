package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.base.BasePanel;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	

	/**
	 *ZAlert弹出框 
	 * <br><li>包含 标题、提示文字、确定（可选）、取消（可选）</li>
	 * @author zhaoqinghao
	 * 
	 */	
	public class Alert extends BasePanel
	{
		public static const BTN_OK:int = 1;
		public static const BTN_CANCEL:int = 2;
		public static const ICON_STATE_SUCC:int = 1;
		public static const ICON_STATE_FAIL:int = 2;
		
		private var _showText:TextField = null;
		private var _okBtn:Button = null;
		private var _cancelBtn:Button = null;

		private var _okCallback:Function = null;
		private var _cancelCallback:Function = null;
		private var _showTextStr:String = null;
		private var _showIcon:DisplayObject = null;
		private var _showIconType:int = 0;
		private var _btnType:int = 0;
		private var _okLabel:String = null;
		private var _cancalLabel:String = null;
		/**
		 *显示文本是否自动居中 
		 */		
		private var _ShowTextAutoCenter:Boolean = false;
		/**
		 *显示Alert 
		 * @param title 标题
		 * @param showText 显示文字
		 * @param iconType 按钮显示状态 -1=不显示 1=正确,2=错误
		 * @param btnType 按钮显示状态 -1=不显示,1=OK,2=Cancel，3=OK|Canel （默认显示OK按钮）；
		 * @param okCallFunction 点击确定回调函数
		 * @param cancelCallFunction 点击取消回调函数
		 * @param okLabel 确定按钮label
		 * @param cancelLabel 取消按钮label
		 */	
		public function Alert(title:String,showHtmlText:String,iconType:int = -1,$btnType:int = -1,okCallFunction:Function = null,cancelCallFunction:Function = null,okLabel:String = null,cancelLabel:String = null)
		{
			titleStr = title;
			_showTextStr = showHtmlText;
			_btnType = $btnType;
			_showIconType = iconType;
			_okCallback = okCallFunction;
			_cancelCallback = cancelCallFunction;
			_okLabel = okLabel;
			_cancalLabel = _cancalLabel;
			this.width = 300;
			this.height = 200;
			super();
		}
		
		override protected function onInit():void{
			super.onInit();
			if(_showIconType!=-1){
				initIcon();
			}
			
			if(_btnType != -1){
				initBtn();
			}
			
			initShowText();
			updateShowTextPosition();
			updateBtnPosition();
		}
		
		override protected function onShow():void{
			super.onShow();
			if(_okBtn){
				_okBtn.addEventListener(MouseEvent.CLICK,onOkClick);
			}
			if(_cancelBtn){
				_cancelBtn.addEventListener(MouseEvent.CLICK,onCancelClick);
			}
		}
		
		override protected function onHide():void{
			super.onHide();
			if(_okBtn){
				_okBtn.removeEventListener(MouseEvent.CLICK,onOkClick);
			}
			if(_cancelBtn){
				_cancelBtn.removeEventListener(MouseEvent.CLICK,onCancelClick);
			}
		}
		
		override protected function onResize(e:Event=null):void{
			super.onResize(e);
		
		}
		
		override public function onCloseClick(e:MouseEvent):void{
			super.onCloseClick(e);
			if(_cancelCallback!=null){
				_cancelCallback();
			}
		}
		
		/**
		 *强制刷新 
		 * @param $imperativeUpdate
		 * 
		 */		
		override protected function onUpdate():void{
		}
		/**
		 *显示icon 
		 * 
		 */		
		private function initIcon():void{
			if(_showIconType == ICON_STATE_SUCC){
				_showIcon = new ICON_OK();
			}else if(_showIconType == ICON_STATE_FAIL){
				_showIcon = new ICON_FAIL();
			}
			if(_showIcon){
				_showIcon.x = 62;
				_showIcon.y = 85;
				DisplayObjectContainer(_showIcon).mouseEnabled = false;
				this.addChild(_showIcon);
			}
		}
		/**
		 *显示btn 
		 * 
		 */		
		private function initBtn():void{
			if(_btnType == BTN_OK){
				_okBtn = new Button(_okLabel?_okLabel:"确 定");
				this.addChild(_okBtn);
			}else if(_btnType == BTN_CANCEL){
				_cancelBtn = new Button(_cancalLabel?_cancalLabel:"取 消");
				this.addChild(_cancelBtn);
			}else if(_btnType == (BTN_OK|BTN_CANCEL)){
				_okBtn = new Button(_okLabel?_okLabel:"确 定");
				_cancelBtn = new Button(_cancalLabel?_cancalLabel:"取 消");
				_okBtn.x = (this.width - (_okBtn.width + 10 + _cancelBtn.width))/2;
				_okBtn.y = 146;
				this.addChild(_okBtn);
				this.addChild(_cancelBtn);
			}
			updateBtnPosition();
		}
		/**
		 *重置按钮位置 
		 * 
		 */		
		private function updateBtnPosition():void{
			var ty:int = this.height - 20;
			if(_btnType == BTN_OK){
				_okBtn.x = (this.width - _okBtn.width)/2;
				_okBtn.y = ty - _okBtn.height;
			}else if(_btnType == BTN_CANCEL){
				_cancelBtn.x = (this.width - _cancelBtn.width)/2;
				_cancelBtn.y = ty - _cancelBtn.height;
			}else if(_btnType == (BTN_OK|BTN_CANCEL)){
				_okBtn.x = (this.width - (_okBtn.width + 10 + _cancelBtn.width))/2;
				_okBtn.y = ty - _okBtn.height;
				_cancelBtn.x = _okBtn.x + _okBtn.width + 10;
				_cancelBtn.y = ty - _cancelBtn.height;
			}
		}
		/**
		 *显示文本 
		 * 
		 */		
		private function initShowText():void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_BUTTON_COLOR;
			//textFormat.font = FontUtil.f;
			_showText = new TextField();
			_showText.x = 89;
			_showText.y = 87;
			_showText.defaultTextFormat = textFormat;
			_showText.setTextFormat(textFormat)
			_showText.htmlText = _showTextStr;
			_showText.textColor = CompEnum.LABEL_ALERT_COLOR;
			_showText.multiline = false;
			_showText.mouseEnabled = false;
			this.addChild(_showText);
		}
		
		private function updateShowTextPosition():void{
			var tw:int = 0;
			//如果有icon则就散icon宽+x+30；
			if(_showIcon){
				tw =_showIcon.width + _showIcon.x + 30; 
			}else{//否则左右空出60
				tw = 60;
			}
			tw += _showText.textWidth + 10;
			if(tw  > this.width){
				this.width = tw;
			}
			
			//设置位置
			_showText.width = _showText.textWidth + 10;
			_showText.height = _showText.textHeight+4
			if(_showIcon){
				_showText.x = _showIcon.width + _showIcon.x + 2;
			}else{
				_showText.x = (this.width - _showText.width)/2
			}
		}
		
		private function onOkClick(e:MouseEvent):void{
			if(_okCallback!=null){
				_okCallback();
			}
			hide();
		}
		
		private function onCancelClick(e:MouseEvent):void{
			if(_cancelCallback!=null){
				_cancelCallback();
			}
			hide();
		}
		/**
		 *显示文本是否自动居中  
		 * @return 
		 * 
		 */		
		public function get ShowTextAutoCenter():Boolean
		{
			return _ShowTextAutoCenter;
		}
		
		public function set ShowTextAutoCenter(value:Boolean):void
		{
			if(value != _ShowTextAutoCenter){
				_ShowTextAutoCenter = value;
				updateShowTextPosition();
			}
		}
		
		public function setSkin_ok(source:DisplayObject):void{
			_okBtn.setSkin(source);
		}
		
		public function setSkin_cancel(source:DisplayObject):void{
			_cancelBtn.setSkin(source);
		}
		
	}
}