package com._17173.flash.show.base.module.chat
{

	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com.greensock.TweenMax;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 飞屏操作面板
	 * @author idzeir
	 *
	 */
	public class FlyTool extends Sprite
	{
		private var bglayer:Sprite;

		private var tool:VGroup;

		/**
		 * 配置数据
		 */
		private var data:Array;

		/**
		 * 动画移动的目标点
		 */
		private var fixed:Point;

		public function FlyTool()
		{
			super();
			this.visible = false;
			fixed = new Point();

			addChildren();

			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);

			this.addEventListener(MouseEvent.CLICK, sendFlyButonClick);

		}

		/**
		 * 发送飞屏按钮事件
		 * @param event
		 *
		 */
		protected function sendFlyButonClick(event:MouseEvent):void
		{
			event.stopPropagation();
			event.stopImmediatePropagation();
			var but:Button = event.target as Button;
			if (but && but.name.indexOf("sendFly_") == 0)
			{
				if (this.hasEventListener(FlyEvent.FLY_SEND))
				{
					this.dispatchEvent(new FlyEvent(FlyEvent.FLY_SEND, but.name.split("_")[1]));
					disappear();
				}
			}

		}

		protected function onAdded(event:Event):void
		{
			if (visible)
			{
				this.stage.addEventListener(MouseEvent.CLICK, disappear);
			}

		}

		/**
		 * 隐藏飞屏操作面板
		 * @param e
		 *
		 */
		public function disappear(e:MouseEvent = null):void
		{
			this.visible = false;
			if (this.parent)
			{
				this.stage.removeEventListener(MouseEvent.CLICK, disappear);
				this.parent.removeChild(this);
			}

		}

		/**
		 * 初始化ui
		 *
		 */
		protected function addChildren():void
		{
			bglayer = new FlyToolBg1_8();
			this.addChild(bglayer);

			tool = new VGroup();
			tool.align = VGroup.LEFT;
			this.addChild(tool);

		}

		/**
		 * 动画目标点
		 * @param xpos
		 * @param ypos
		 *
		 */
		public function fixedPoint(xpos:Number, ypos:Number):void
		{
			fixed.x = xpos;
			fixed.y = ypos;

		}

		/**
		 * 切换面板显示
		 * @param value 面板的父级容器
		 * @return
		 *
		 */
		public function toggleAppearIn(value:DisplayObjectContainer):Boolean
		{
			this.visible = !this.visible;
			TweenMax.killTweensOf(this);
			if (this.visible)
			{
				value.addChild(this);
				TweenMax.fromTo(this, .5, {alpha: .3, y: fixed.y + 10}, {alpha: 1, y: fixed.y});
			}
			else
			{
				value.removeChild(this);
			}
			return this.visible;

		}

		/**
		 * 更新面板配置信息
		 * @param value
		 *
		 */
		public function updateFromData(value:Array):void
		{
			//重排序
			value.sortOn("flyPrice", Array.NUMERIC);
			tool.removeChildren();
			data = value.concat();
			checkData();

		}

		/**
		 * 初始化样式
		 */
		private function checkData():void
		{
			if (data.length > 0)
			{
				var value:Object = data.shift();
				waitForStyleLoaded(value);
			}
			else
			{
				resizeBglayer();
			}

		}

		/**
		 * 缩放背景大小
		 *
		 */
		private function resizeBglayer():void
		{
			const TOP_LEFT:Number = 20;
			if ((tool.height + 2 * TOP_LEFT) > bglayer.height)
			{
				bglayer.height = tool.height + 2 * TOP_LEFT;
			}
			tool.x = bglayer.width - tool.width >> 1;
			tool.y = bglayer.height - tool.height >> 1;

		}

		/**
		 * 加载样式
		 * @param value
		 *
		 */
		private function waitForStyleLoaded(value:Object):void
		{
			var ires:IResourceManager = (Context.getContext(CEnum.SOURCE) as IResourceManager);
			ires.loadResource(value["flyResPreviewPath"], function(e:IResourceData):void
			{
				tool.addChild(createRow(value, e.newSource));
				checkData();
			});

		}

		/**
		 * 创建一个样式
		 * @param value 样式信息
		 * @param style 样式预览图
		 * @return
		 *
		 */
		protected function createRow(value:Object, style:DisplayObject):HGroup
		{
			var h:HGroup = new HGroup();
			h.gap = 10;
			h.valign = HGroup.MIDDLE;
			var fName:TextField = createLabel();
			fName.text = value["flyName"];
			var fPrice:TextField = createLabel();
			fPrice.text = value["flyPrice"] + "乐币";

			var button:Button = new Button("<font size='12'>发送</font>");
			button.setSkin(new FlySendButBg1_8());
			button.name = "sendFly_" + value["flyId"];
			button.width = 46;
			button.height = 20;

			h.addChild(fName);
			h.addChild(fPrice);
			style.width = 120;
			style.height = 20;
			h.addChild(style);
			h.addChild(button);

			return h;

		}

		/**
		 * 创建文本
		 * @return
		 *
		 */
		private function createLabel():TextField
		{
			var text:TextField = new TextField();
			text.autoSize = TextFieldAutoSize.NONE;
			text.width = 56;
			text.height = 20;
			var tf:TextFormat = new TextFormat(FontUtil.f, null, 0xFFCD5D);
			text.defaultTextFormat = tf;
			text.mouseEnabled = false;
			text.selectable = false;
			return text;

		}
	}
}
