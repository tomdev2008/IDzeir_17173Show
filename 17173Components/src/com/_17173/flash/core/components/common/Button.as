package com._17173.flash.core.components.common
{
	import com._17173.flash.core.components.skin.SkinType;
	import com._17173.flash.core.components.skin.skinclass.ButtonSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * 通用按钮
	 * @author zhaoqinghao
	 * 
	 */	
	public class Button extends SkinComponent
	{
		private const FONT_NAME:String = "Microsoft YaHei,微软雅黑,宋体,Monaco";
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
			[
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0,
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1]); 
		/**
		 *按钮资源数据
		 */		
		private var _isSelect:Boolean = false;
		protected var _label:String = null;
		protected var _labelTxt:TextField = null;
		private var _selected:Boolean = false;
		private var _disabled:Boolean = false;
		private var _lastClickTime:int = 0;
		private const _downClickLimit:int = 100;
		protected var _leftSpace:int = 10;
		protected var _rightSpage:int = 10;
		protected var _offsetWidth:int = 0;
		/**
		 *按钮 自动过滤点击间隔小于100毫秒操作
		 * @param $label 按钮label
		 * @param $sourceData 按钮资源数据 (置空则使用普通按钮资源)
		 * @param $isSelected 是否可以选中
		 * 
		 */		
		public function Button(label:String = "", isSelected:Boolean = false)
		{
			_label = label;
			_isSelect = isSelected;
			this.mouseChildren = false;
			this.buttonMode = true;
			super();
			_lastClickTime = getTimer();
		}
		/***OVERRIDE BEGIN***************************************************************************************************************************/
		
		override protected function initSkinVo():void{
			_skinVo = new ButtonSkin(SkinType.SKIN_TYPE_BUTTON,this);
		}
		
		
		/***OVERRIDE END***************************************************************************************************************************/
		
		/**
		 *按钮标签 
		 * @return 
		 * 
		 */
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			if(value != _label){
				_label = value;
				if(_labelTxt == null){
					initTextField();
				}
				updateLabel();
				resize();
			}
		}
		/**
		 *按钮是否可用 
		 * @return 
		 * 
		 */
		public function get disabled():Boolean
		{
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			this.mouseEnabled = !value;
			if(_disabled){
				this.filters = [GRAY_FILTER];
			}else{
				this.filters = [];
			}
		}
		/**
		 *按钮是否可以选中 
		 * @return 
		 * 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(!_selected){
				_skinVo.updateSkinState("out");
			}else{
				_skinVo.updateSkinState("selected");
			}
		}
		
		
		/**
		 *更新label位置 
		 * 
		 */		
		protected function onRePostionLabel():void{
			if(_labelTxt){
				_labelTxt.x = (width - (_labelTxt.width))/2 + _offsetWidth/2;
				_labelTxt.y = (height - (_labelTxt.height))/2-1;
			}
		}
		
		protected function onOver(e:Event):void{
			this.addEventListener(MouseEvent.ROLL_OUT,onOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(!_selected){
				_skinVo.updateSkinState("over");
			}else{
				_skinVo.updateSkinState("over");
			}
		}
		
		protected function onOut(e:Event):void{
			this.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			if(!_selected){
				_skinVo.updateSkinState("out");
			}else{
				_skinVo.updateSkinState("selected");
			}
		}
		
		protected function onMouseUp(e:Event):void{
			if(_isSelect){
				_selected = !selected;
			}
			if(!_selected){
				_skinVo.updateSkinState("up");
			}else{
				_skinVo.updateSkinState("up");
			}
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseDown(e:Event):void{
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			if(!_selected){
				_skinVo.updateSkinState("selected");
			}else{
				_skinVo.updateSkinState("out");
			}
		}
		
		/********************************* OVERRIDE ********************************/
		
		
		override protected function onInit():void{
			super.onInit()
			initTextField();
			updateLabel();
		}
		
		override protected function onRePosition():void{
			super.onRePosition();
			onRePostionLabel();
		}
		
		override protected function onShow():void{
			super.onShow();
			this.addEventListener(MouseEvent.ROLL_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onClickCheck,false,int.MAX_VALUE);
		}
		
		override protected function onHide():void{
			super.onHide();
			this.removeEventListener(MouseEvent.ROLL_OVER,onOver);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onClickCheck);
		}
		
		/********************************* OVERRIDE END********************************/
		/**
		 *过滤点击过快 
		 * @param e
		 * 
		 */		
		private function onClickCheck(e:Event):void{
			//检测多次点击时间
			var tmpTime:int = getTimer() - _lastClickTime;
			if(tmpTime < _downClickLimit){
				e.stopImmediatePropagation();
				e.stopPropagation();
			}else{
				_lastClickTime = getTimer();
			}
		}
		/**
		 *初始化文本，计算居中 
		 * 
		 */		
		protected function initTextField():void{
			if(_label == null || _label == "" ){
				return;
			}
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = CompEnum.LABEL_BUTTON_COLOR;
			textFormat.font = FONT_NAME;
			textFormat.size = CompEnum.LABEL_BUTTON_SIZE;
			_labelTxt = new TextField();
			_labelTxt.multiline = false;
			_labelTxt.width = 12;
			_labelTxt.height = 12;
			_labelTxt.setTextFormat(textFormat);
			_labelTxt.defaultTextFormat = textFormat;
			_labelTxt.mouseEnabled = false;
			_labelTxt.selectable = false;
			this.addChild(_labelTxt);
		}
		/**
		 *更新文本位置 
		 * 
		 */		
		private function updateLabel():void{
			if(_labelTxt == null) return;
			_labelTxt.htmlText = _label;
			//计算文本框放置位置
			var tw:int = _labelTxt.textWidth;
			var th:int = _labelTxt.textHeight;
			_labelTxt.width = tw + 4;
			_labelTxt.height = th + 3;
			//文本小于背景，直接算居中位置
			if((width > tw + _leftSpace + _rightSpage + _offsetWidth) && (height >  th + 8)){
				onRePostionLabel();
			}else{
				//宽度小于
				if(width < tw +  _leftSpace + _rightSpage + _offsetWidth){
					width = tw + + _leftSpace + _rightSpage + _offsetWidth;
				}
				//高度小于
				if(height < th + 8){
					height = th + 8;
				}
			}
		}
		
		/**
		 *更新按钮资源  
		 * @param btnClass 资源类
		 * 
		 */		
		public function setSkin(source:DisplayObject):void{
			this.skinVo.skin = {"button":source};
		}
		
	}
}