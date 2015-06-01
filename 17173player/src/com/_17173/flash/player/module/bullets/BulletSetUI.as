package com._17173.flash.player.module.bullets
{
	import com._17173.flash.player.module.bullets.base.BulletConfig;
	import com._17173.flash.player.module.bullets.base.SelectButton;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 *弹幕设置路径 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BulletSetUI extends Sprite
	{
		
		public function BulletSetUI()
		{
			super();
			init();
		}
		/*********************************************COLOR DEF**************************************************/
		private static const COLOR1:uint = 0xE50012;
		private static const COLOR2:uint = 0xF29600;
		private static const COLOR3:uint = 0xFFD800;
		private static const COLOR4:uint = 0xFFFFFF;
		private static const COLOR5:uint = 0x920883;
		private static const COLOR6:uint = 0xE4007F;
		private static const COLOR7:uint = 0x8DC21F;
		private static const COLOR8:uint = 0x00A0E8;
		private static const COLOR9:uint = 0x000000;
		private static const COLOR10:uint = 0x574B9C;
		private static const COLOR11:uint = 0x006D35;
		private static const COLOR12:uint = 0x0067B6;
		
		/*********************************************COLOR DEF END**********************************************/
		
		private var _closeBtn:DisplayObject = null;
		
		private var _titleLabel:TextField = null;
		
		private var _sizeLabel:TextField = null;
		
		private var _modeLabel:TextField = null;
		
		private var _colorLabel:TextField = null;
		/**
		 *字体颜色 
		 */		
		private var _colors:Array = null;
		/**
		 *字体显示位置 
		 */		
		private var _modes:Array = null;
		/**
		 *字体大小 
		 */		
		private var _sizes:Array = null;
		
		/**
		 *当前选中颜色 
		 */		
		private var _currentColor:SelectColorItem = null;
		/**
		 *当前选中颜色label 
		 */		
		private var _currentColorLabel:TextField = null;
		/**
		 *颜色数组 
		 */		
		private var _colorValues:Array = null;
		/**
		 *背景 
		 */		
		private var _bg:DisplayObject = null;
		
		private function init():void{
			var bg:MovieClip = new mc_bulletsSetBg();
			bg.mouseChildren = bg.mouseEnabled = false;
			this.addChild(bg);
			initLabels();
			initColor();
			initFontSize();
			initModes();
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdd);
		}
		
		
		private function onShow():void{
			addLsn();
		}
		
		private function onHide():void{
			removeLsn();
		}
		
		private function onAdd(e:Event):void{
			onShow()
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		private function onRemove(e:Event):void{
			onHide();
			this.removeEventListener(Event.REMOVED_FROM_STAGE,onRemove);
		}
		
		
		/********************************************初始化*************************************************************/
		
		/**
		 *初始化label 
		 * 
		 */		
		private function initLabels():void
		{
			//title
			_titleLabel = new TextField();
			_titleLabel.x = 8;
			_titleLabel.y = 5;
			_titleLabel.width = 200;
			_titleLabel.textColor = 0x757575;
			_titleLabel.mouseEnabled = false;
			_titleLabel.htmlText = "弹幕模式设置";
			this.addChild(_titleLabel);
			
			var tmp:TextField;
			tmp = new TextField();
			tmp.x = 14;
			tmp.y = 47;
			tmp.textColor = 0xD7D2D2;
			tmp.mouseEnabled = false;
			tmp.width = 200;
			tmp.htmlText = "<font face='Microsoft yahei'>字幕字号：</font>";
			this.addChild(tmp);
			
			tmp = new TextField();
			tmp.x = 14;
			tmp.y = 77;
			tmp.textColor = 0xD7D2D2;
			tmp.mouseEnabled = false;
			tmp.width = 200;
			tmp.htmlText = "<font face='Microsoft yahei'>字幕模式：</font>";
			this.addChild(tmp);
			
			tmp = new TextField();
			tmp.x = 14;
			tmp.y = 111;
			tmp.textColor = 0xD7D2D2;
			tmp.mouseEnabled = false;
			tmp.width = 200;
			tmp.htmlText = "<font face='Microsoft yahei'>字幕颜色：</font>";
			this.addChild(tmp);
			
			_currentColorLabel = new TextField();
			_currentColorLabel.x = 126;
			_currentColorLabel.y = 111;
			_currentColorLabel.textColor = 0xD7D2D2;
			_currentColorLabel.mouseEnabled = false;
			_currentColorLabel.width = 200;
			_currentColorLabel.htmlText = "<font size='14'>#000000</font>";
			this.addChild(_currentColorLabel);
			
			_closeBtn = new mc_setCloseBtn();
			_closeBtn.x = 256;
			_closeBtn.y = 3;
			this.addChild(_closeBtn);
			
		}
		
		private function initFontSize():void{
			_sizes = [];
			var mc:SelectButton = new SelectButton(new mc_font14Btn());
			mc.x = 81;
			mc.y = 45;
			mc.name = "font14";
			this.addChild(mc);
			_sizes[0] = mc;
			
			mc = new SelectButton(new mc_font24Btn());
			mc.x = 109;
			mc.y = 41;
			mc.name = "font24";
			mc.select = true;
			this.addChild(mc);
			_sizes[1] = mc;
			
			mc = new SelectButton(new mc_font36Btn());
			mc.x = 141;
			mc.y = 35;
			mc.name = "font36";
			this.addChild(mc);
			_sizes[2] = mc;
		}
		
		private function initModes():void{
			_modes = [];
			var mc:SelectButton = new SelectButton(new mc_bulletTopBtn());
			mc.x = 81;
			mc.y = 71;
			mc.name = "mode1";
			this.addChild(mc);
			_modes[0] = mc;
			
			mc = new SelectButton(new mc_bulletCenterBtn());
			mc.x = 130;
			mc.y = 71;
			mc.name = "mode2";
			mc.select = true;
			this.addChild(mc);
			_modes[1] = mc;
			
			
			mc = new SelectButton(new mc_bulletBottomBtn());
			mc.x = 179;
			mc.y = 71;
			mc.name = "mode3";
			this.addChild(mc);
			_modes[2] = mc;
		}
		
		private function initColor():void{
			_colors = [];
			_colorValues = 
				[[COLOR1,COLOR2,COLOR3,COLOR4],
				[COLOR5,COLOR6,COLOR7,COLOR8],
				[COLOR9,COLOR10,COLOR11,COLOR12]
				];
			
			_currentColor = new SelectColorItem(mc_bulletColorMc);
			_currentColor.setColor(COLOR4);
			_currentColor.x = 81;
			_currentColor.y = 108;
			_currentColor.mouseEnabled = false;
			this.addChild(_currentColor);
			
			_currentColorLabel.htmlText = "<font size='14'>#"+_currentColor.getColorByString().toUpperCase()+"</font>";
			
			var len:int = _colorValues.length;
			var len1:int = 0;
			var newColor:SelectColorItem;
			var tmpArr:Array;
			var offx:int = 81;
			var offy:int = 142;
			for (var i:int = 0; i < len; i++) 
			{
				tmpArr = _colorValues[i] as Array;
				len1 = tmpArr.length
				for (var j:int = 0; j < tmpArr.length; j++) 
				{
					newColor = new SelectColorItem(mc_bulletColorMc);
					newColor.x = offx + j * (newColor.width+1);
					newColor.y = offy + i * (newColor.height+1);
					newColor.setColor(tmpArr[j]);
					this.addChild(newColor);
					_colors.push(newColor);
				}
				
			}
			
		}
		
		/********************************************初始化 END*************************************************************/
		
		private function onColorSelect(e:Event):void{
			var item:SelectColorItem = e.currentTarget as SelectColorItem;
			var color:uint = item.getColorByNum();
			_currentColor.setColor(color);
			_currentColor.select = true;
			_currentColorLabel.htmlText = "<font size='14'>#"+item.getColorByString().toUpperCase()+"</font>";
			//设置颜色
			BulletConfig.getInstance().bulletFontColor = color;
		}
		
		private function onModeSelect(e:Event):void{
			var ds:SelectButton = e.currentTarget as SelectButton;
			clearSelect(_modes);
			ds.select = true;
			var type:String = ds.name;
			var fontMode:String = "";
			
			switch(type)
			{
				case "mode1":
				{
					fontMode = BulletConfig.BULLETTYPE_FIXURE_TOP;
					break;
				}
				case "mode2":
				{
					fontMode = BulletConfig.BULLETTYPE_NORMAL;
					break;
				}
				case "mode3":
				{
					fontMode = BulletConfig.BULLETTYPE_FIXURE_BOTTOM;
					break;
				}
			}
			BulletConfig.getInstance().bulletFontType = fontMode;
		}
		
		private function onSizeSelect(e:Event):void{
			var ds:SelectButton = e.currentTarget as SelectButton;
			clearSelect(_sizes);
			ds.select = true;
			var type:String = ds.name;
			var fontsize:int = 0;
			switch(type)
			{
				case "font14":
				{
					fontsize = BulletConfig.BULLET_FONTSIZE_14;
					break;
				}
				case "font24":
				{
					fontsize = BulletConfig.BULLET_FONTSIZE_24;
					break;
				}
				case "font36":
				{
					fontsize = BulletConfig.BULLET_FONTSIZE_36;
					break;
				}
			}
			//设置字体
			BulletConfig.getInstance().bulletFontSize = fontsize;
			//设置样式
		}
		
		private function clearSelect(arr:Array):void{
			var len:int = arr.length;
			var btn:SelectButton;
			for (var i:int = 0; i < len; i++) 
			{
				btn = arr[i] as SelectButton;
				btn.select = false;
			}
		}
		
		private function addLsn():void{
			//颜色监听
			var ds:DisplayObject;
			var len:int = _colors.length;
			var i:int = 0;
			for (i = 0; i < len; i++) 
			{
				ds = _colors[i];
				ds.addEventListener(MouseEvent.CLICK,onColorSelect);
			}
			
			len = _modes.length
			for (i = 0; i < len; i++) 
			{
				ds = _modes[i];
				ds.addEventListener(MouseEvent.CLICK,onModeSelect);
			}
			
			len = _sizes.length
			for (i = 0; i < len; i++) 
			{
				ds = _sizes[i];
				ds.addEventListener(MouseEvent.CLICK,onSizeSelect);
			}
			
			_closeBtn.addEventListener(MouseEvent.CLICK,onClose);
		}
		
		private function removeLsn():void{
			var ds:DisplayObject;
			var len:int = _colors.length;
			var i:int = 0;
			for (i = 0; i < len; i++) 
			{
				ds = _colors[i];
				ds.removeEventListener(MouseEvent.CLICK,onColorSelect);
			}
			
			len = _modes.length
			for (i = 0; i < len; i++) 
			{
				ds = _modes[i];
				ds.removeEventListener(MouseEvent.CLICK,onModeSelect);
			}
			
			len = _sizes.length
			for (i = 0; i < len; i++) 
			{
				ds = _sizes[i];
				ds.removeEventListener(MouseEvent.CLICK,onSizeSelect);
			}
			
			_closeBtn.removeEventListener(MouseEvent.CLICK,onClose);
		}
		
		private function onClose(e:MouseEvent):void{
			this.visible = !this.visible;
		}
		
		private function updateToSeting():void{
			
		}
		
	}
}