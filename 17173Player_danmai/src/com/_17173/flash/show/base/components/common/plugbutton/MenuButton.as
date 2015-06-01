package com._17173.flash.show.base.components.common.plugbutton
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;

	public class MenuButton extends PlugButton
	{
		private var _btnIcon:DisplayObject;
		private var _iconAlign:String = null;
		private var _icon_padding:int = 3;
		/**
		 *菜单按钮 
		 * @param eventType  按钮派发事件
		 * @param label  按钮label
		 * @param btnIcon icon
		 * @param iconAlign icon摆放位置（相对于label）
		 * @param btnOrder 按钮排序（添加到左边栏后的显示位置,默认添加到最后）
		 * @param isSelect 是否可以选中
		 * 
		 */		
		public function MenuButton(eventType:String, label:String="",btnIcon:DisplayObject = null,iconAlign:String = IconAlignType.LEFT, btnOrder:int=-1, isSelect:Boolean = false)
		{
			_btnIcon = btnIcon;
			_iconAlign = iconAlign;
			super(eventType, label,btnOrder, isSelect);
		}
		
		
		public function get icon_padding():int
		{
			return _icon_padding;
		}
		/**
		 *边距设置 
		 * @param value
		 * 
		 */
		public function set icon_padding(value:int):void
		{
			_icon_padding = value;
		}

		private function initSkin():void{
			this.setSkin(new Skin_Btn_menu());	
		}
		/**
		 *初始化icon 
		 * 
		 */		
		private function initIcon():void{
			if(_btnIcon){
				this.addChild(_btnIcon);
			}
		}
		
		override protected function onInit():void{
			super.onInit();
			initIcon();
			initSkin();
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
		
		override protected function onRePostionLabel():void{
			if(_btnIcon == null){
				super.onRePostionLabel();
				return;
			}
			
			var tw:int;
			var th:int;
			switch(_iconAlign)
			{
				case IconAlignType.LEFT:
				{
					_btnIcon.x = _icon_padding;
					_btnIcon.y = int((this.height- _btnIcon.height) / 2)+1;
					_labelTxt.x = _btnIcon.x + _btnIcon.width;
					_labelTxt.y = int((this.height- _labelTxt.height) / 2);
					break;
				}
				case IconAlignType.RIGHT:
				{
					_labelTxt.x = _icon_padding/2;
					_labelTxt.y = int((this.height- _labelTxt.height) / 2);
					_btnIcon.x = _labelTxt.x + _labelTxt.width + 2;
					_btnIcon.y = int((this.height- _btnIcon.height) / 2)+1;
					
					break;
				}
				case IconAlignType.TOP:
				{
					_btnIcon.x = int((this.width - _btnIcon.width)/2);
					_btnIcon.y = _icon_padding;
					_labelTxt.x = int((this.width - _labelTxt.width)/2);
					_labelTxt.y = _btnIcon.y + _btnIcon.height;
					break;
				}
				case IconAlignType.BOTTON:
				{
					_labelTxt.x = int((this.width - _labelTxt.width)/2);
					_labelTxt.y = _icon_padding/2;
					_btnIcon.x = int((this.width - _btnIcon.width)/2);
					_btnIcon.y = _labelTxt.y + _labelTxt.height + 2;
					
					break;
				}
			}
		}
	}
}