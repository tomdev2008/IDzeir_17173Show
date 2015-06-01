package com._17173.flash.core.components.base
{
	import com._17173.flash.core.components.common.CompEnum;
	import com._17173.flash.core.components.common.SkinComponent;
	import com._17173.flash.core.components.skin.skinclass.PanelSkin;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class BasePanel extends SkinComponent
	{
		
		/**
		 *标题 
		 */		
		protected var title:DisplayObject = null;
		private var _titleStr:String = null;
	
		private var _showCloseBtn:Boolean = true;
		/**
		 * 父类 
		 */		
		protected var parentContainer:Sprite = null;
		/**
		 *点击后自动到父容器最上层(默认为true),点击面板后，自动提升
		 */		
		public var click2TopChild:Boolean = true;
		/**
		 * 组件内容容器（不包含背景、关闭、标题、分割线） 
		 */		
		protected var _content:Sprite;
		
		public function BasePanel()
		{
			super();
		}
		
		override protected function initSkinVo():void{
			_skinVo = new PanelSkin(this);
		}

		public function get titleStr():String
		{
			return _titleStr;
		}

		public function set titleStr(value:String):void
		{
			_titleStr = value;
			if(title as TextField){
				TextField(title).htmlText = _titleStr;
			}
		}	
		/**
		 * 设置分割线是否可见 
		 * @param bool
		 * 
		 */		
		public function set showLine(bool:Boolean):void
		{
			if(bool){
				_skinVo.updateSkinState("showLine");
			}else{
				_skinVo.updateSkinState("hideLine");
			}
		}
		
		/**
		 * 设置panel的内容  
		 * @param value 为null时清空组件（会保留背景，关闭，按钮，分割线）
		 * 
		 */		
		public function set content(value:DisplayObject):void{
			this._content.removeChildren();
			if(value)this._content.addChild(value);
		}


		/********************************* OVERRIDE ********************************/
		override protected function onInit():void{
			super.onInit();
			_content = new Sprite();			
			initTitle();
			this.addChild(_content);
		}
		
		override protected function onRePosition():void{
			super.onRePosition();
			onRePostionTitle();
		}
		
		override protected function onShow():void{
			super.onShow();
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		override protected function onHide():void{
			super.onHide();
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			
		}
		
		/********************************* OVERRIDE END ********************************/
		/**
		 *初始化标题 
		 * 可控制标题显示内容
		 */		
		protected function initTitle():void{
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_PANEL_COLOR;
			textFormat.font = "Microsoft YaHei,微软雅黑,宋体,Monaco";
			var tmpTitle:TextField = new TextField();
			tmpTitle = new TextField();
			tmpTitle.width = 150;
			tmpTitle.height = 25;
			tmpTitle.mouseEnabled = false;
			tmpTitle.setTextFormat(textFormat);
			tmpTitle.defaultTextFormat = textFormat;
			if(_titleStr!=null){
				tmpTitle.htmlText = _titleStr;
			}
			title = tmpTitle;
			this.addChild(title)
		}
		
		
		/**
		 *更新title位置 
		 * 
		 */		
		protected function onRePostionTitle():void{
			if(title){
				title.x = 10;
				title.y = 10;
				this.addChild(title);
			}
		}
	
		protected function onMouseDown(e:MouseEvent):void{
			if(click2TopChild && this && this.parent){
				this.parent.setChildIndex(this,this.parent.numChildren-1);
			}
		}

		/**
		 *显示/隐藏 关闭按钮 
		 */
		public function get showCloseBtn():Boolean
		{
			return _showCloseBtn;
		}

		/**
		 * @private
		 */
		public function set showCloseBtn(value:Boolean):void
		{
			_showCloseBtn = value;
			if(_showCloseBtn){
				_skinVo.updateSkinState("showClose");
			}else{
				_skinVo.updateSkinState("hideClose");
			}
		}
		
		
		public function onCloseClick(e:MouseEvent):void{
			hide();
		}

		
		/**
		 *更新close 
		 * 
		 */		
		public function setSkin_Close(source:DisplayObject):void{
			skinVo.skin = {"close":source};
		}
		/**
		 *更新line 
		 * 
		 */		
		public function setSkin_line(source:DisplayObject):void{
			skinVo.skin = {"line":source};
		}
	}
}