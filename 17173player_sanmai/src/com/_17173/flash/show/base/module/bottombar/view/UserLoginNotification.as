package com._17173.flash.show.base.module.bottombar.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.components.common.AslTextField;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.components.common.data.SourceData_Button;
	import com._17173.flash.show.base.utils.FontUtil;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import com._17173.flash.show.model.CEnum;
	
	public class UserLoginNotification extends Sprite
	{
		private var _uid:String = null;
		private var _nameTF:AslTextField = null;
		private var _tf:TextField = null;
		
		public function UserLoginNotification()
		{
			super();
			
			var bg:DisplayObject = new Bg_Normal();
			bg.width = 180;
			bg.height = 40;
			addChild(bg);
			
			var clsBtn:Button = new Button("",false,new SourceData_Button(new Button_NormalClose()));
			clsBtn.x = width - clsBtn.width - 10;
			clsBtn.y = (height - clsBtn.height) / 2;
			addChild(clsBtn);
			
			_nameTF = new AslTextField(130);
			var fmt:TextFormat = FontUtil.DEFAULT_FORMAT;
			fmt.color = FontUtil.FONT_COLOR_BLUE1;
			_nameTF.defaultTextFormat = fmt;
			_nameTF.x = 3;
			_nameTF.y = 5;
			addChild(_nameTF);
			
			_tf = new TextField();
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.defaultTextFormat = fmt;
			_tf.text = Context.getContext(CEnum.LOCALE).get("login", "common");
			_tf.y = 5;
			addChild(_tf);
			
			alpha = 0;
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			TweenLite.to(this, 1, {"alpha":1, "onComplete":function ():void {
				Ticker.tick(2000, onDelayHide);
			}});
		}
		
		public function set data(value:Object):void {
			_nameTF.text = value.name;
			_tf.x = _nameTF.x + _nameTF.width + 5;
		}
		
		private function onDelayHide():void {
			TweenLite.to(this, 1, {"alpha":0, "onComplete":function ():void {
				
			}});
		}
	}
}