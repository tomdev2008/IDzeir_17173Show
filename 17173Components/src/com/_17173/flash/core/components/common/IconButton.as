package com._17173.flash.core.components.common
{
	
	import flash.display.DisplayObject;

	/**
	 *带icon的按钮 
	 * @author zhaoqinghao
	 * 
	 */	
	public class IconButton extends Button
	{
		/**
		 *Icon 
		 */		
		protected var _icon:DisplayObject = null;
		protected var _iconSpace:int = 2;
		/**
		 *带iconbutton  默认是左右排列 依次为ICON Label(如不需显示label，传空字符串)
		 * @param iconSource  icon资源
		 * @param label label
		 * @param isSelected 是否可以选中
		 * @param source  按钮底图
		 * 
		 */		
		public function IconButton(iconSource:DisplayObject, label:String="", isSelected:Boolean=false)
		{
			_icon = iconSource
			super(label, isSelected);
		}
		
		/**
		 * icon和显示文本之间的间距
		 */
		public function get iconSpace():int
		{
			return _iconSpace;
		}

		public function set iconSpace(value:int):void
		{
			if(_iconSpace != value){
				_iconSpace = value;
				resize();
			}
			
		}

		override protected function onInit():void{
			super.onInit();
			onInitIcon();
		}
		override protected function onRePosition():void{
			super.onRePosition();
			onRePostionIcon();
		}
		
		protected function onRePostionIcon():void{
			if(_icon){
				//如果labe存在则吧icon放在label前
				if(_labelTxt){
					_icon.x = _labelTxt.x - _icon.width - _iconSpace;
				}else
				{
					_icon.x = (this.width - _icon.height)/2
				}
				_icon.y = (height - _icon.height)/2
			}
		}
		
		protected function onInitIcon():void{
			if(_icon){
				this.addChild(_icon);
				_offsetWidth = _icon.width +  _iconSpace;
			}
		}
		/**
		 *更换icon 
		 * @param newIcon
		 * 
		 */		
		public function changeIcon(newIcon:DisplayObject):void{
			if(_icon && this.contains(_icon)){
				this.removeChild(_icon);
			}
			_icon = newIcon;
			this.addChild(_icon);
			resize();
		}
	}
}