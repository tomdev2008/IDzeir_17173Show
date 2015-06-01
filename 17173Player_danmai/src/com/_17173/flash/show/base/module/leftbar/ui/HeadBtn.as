package com._17173.flash.show.base.module.leftbar.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	/**
	 *头像按钮 
	 * @author zhaoqinghao
	 * 
	 */	
	public class HeadBtn extends Button
	{
		protected var _head:Sprite;
		protected var _headMask:Shape;
		public function HeadBtn(label:String="", isSelected:Boolean=false)
		{
			super("个人信息", isSelected);
			this.setSkin(new Skin_Btn_menu());
			initSp();
		}
		override protected function initTextField():void{
			super.initTextField();
			if(_labelTxt){
				var tfm:TextFormat = _labelTxt.defaultTextFormat;
				tfm.color = 0xA198B0;
				tfm.size = 10;
				_labelTxt.defaultTextFormat = tfm;
				_labelTxt.setTextFormat(tfm);
			}
		}
		private function initSp():void{
			_head=new Sprite();
			_head.graphics.beginFill(0x000000,0);
			_head.graphics.drawRect(0,0,40,60);
			_head.graphics.endFill();
			_head.x = 4;
			_head.y = 3;
			_head.mouseChildren = false;
			_head.mouseEnabled = false;
			this.addChild(_head);
			_headMask=new Shape();
			_headMask.graphics.beginFill(0x000000);
			_headMask.graphics.drawCircle(17,15,17);
			_headMask.graphics.endFill();
			_headMask.x = 4;
			_headMask.y = 5;
			
		}
		
		public function set user(value:IUserData):void
		{
			_head.removeChildren();
			//if((Context.getContext(CEnum.USER) as IUser).me.id == value.id) Debugger.log(Debugger.INFO, "[userItem]", "自己头像地址:",value.head);
			_head.addChild(Utils.getURLGraphic(value.head, true, 40, 40));
			_head.graphics.clear();
			_head.mask = _headMask;
			_head.addChild(_headMask);
		}
		
		
		override protected function onRePostionLabel():void{
			_labelTxt.y = 42;
			_labelTxt.x = 2;
		}
		
	}
}