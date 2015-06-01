package com._17173.flash.show.base.module.bag.view.items
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	/**
	 *背包item 主体
	 * @author yeah
	 */	
	public class BagItemBody extends BagItemPart
	{
		
		/**
		 *左侧按钮 
		 */		
		private var leftBtn:Button;
		
		/**
		 *续费按钮 
		 */		
		private var reNewBtn:Button;
		
		/**
		 *闪烁特效 
		 */		
		private var effect:MovieClip;
		
		/**
		 *按钮容器 
		 */		
		private var btnBar:Sprite;
		
		/**名称*/
		private var nameTF:TextField;
		
		/**说明*/
		private  var descTF:TextField;
		
		
		public function BagItemBody()
		{
			super();
			
			var mc:DisplayObject = new BagItemBar();
			mc.x = 1;
			mc.y = 11;
			this.addChild(mc);
			
			var f:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体", 16, 0xffff99, null, null, null, null, null, TextFormatAlign.CENTER);
			nameTF = new TextField();
			nameTF.mouseEnabled = nameTF.selectable = false;
			nameTF.defaultTextFormat = f;
			nameTF.width = width;
			nameTF.height = 26;
			nameTF.y = 9;
			this.addChild(nameTF);
			
			f.size = 12;
			f.color = 0xc550de
			descTF = new TextField();
			descTF.mouseEnabled = descTF.selectable = false;
			descTF.defaultTextFormat = f;
			descTF.width = width;
			descTF.height = 20;
			descTF.y = 38;
			this.addChild(descTF);
			
			btnBar = new Sprite();
			btnBar.y = 60;
			btnBar.addEventListener(MouseEvent.CLICK, onClick);
			btnBar.mouseChildren = true;
			btnBar.mouseEnabled = false;
			this.addChild(btnBar);
		}
		
		override protected function onRender():void
		{
			nameTF.text = data.name ? data.name : "";
			updateDate();
			updateBtns();
		}
		
		/**
		 *更新有效期 
		 */		
		public function updateDate():void
		{
			if(!data.hasOwnProperty("endTime"))
			{
				data.endTime = "有效期至：";
				if(data.deadLine == null||  data.deadLine == 0)
				{
					data.endTime += "永久使用";
				}
				else
				{
					var date:Date = new Date(data.deadLine * 1000);
					data.endTime += date.fullYear + "-";
					data.endTime += (date.month + 1) + "-";
					data.endTime += date.date + "日";
				}
			}
			descTF.text =  data.endTime;
		}
		
		private var local:ILocale;
		
		/**
		 *更新按钮 
		 */		
		public function updateBtns():void
		{
			if(!local)
			{
				local = Context.getContext(CEnum.LOCALE) as ILocale;
			}
			
			/**更新左侧按钮*/
			showLeftBtn(data.inUse < 2);//2不显示 0 使用 1 使用中
			
			/**更新右侧按钮*/
			//蛋疼 默认靓号id = 0； 默认靓号不显示续费按钮
//			var showRenewBtn:Boolean = true; //暂时定的是全都可以续费
//			showRightBtn(data.deadLine && data.deadLine > 0);		//现在订的是data.deadLine=null ||0都不显示续费按钮 其它情况则显示
			showRightBtn(data.canRenew == 1);	
			
			/**更新按钮跳的位置*/
			btnBar.x = 80 - (btnBar.width >> 1);
		}
		
		
		/**
		 *使用（使用中）按钮 
		 * @param $value
		 */		
		private function showLeftBtn($value:Boolean):void
		{
			if($value)
			{
				var btnLabel:String;
				var skinClass:Class;
				var isUse:Boolean = false;			//true 使用 false 使用中
				if(data.inUse == 0 || data.inUse == null)
				{
					btnLabel = local.get("useBtn","bag");			
					skinClass = BagItemUseBtn;
					isUse = true;
				}
				else
				{
					btnLabel = local.get("useingBtn","bag");
					skinClass = BagItemUsingMC;
					isUse = false;
				}
				
				if(!leftBtn)
				{
					leftBtn = new Button(btnLabel);
					leftBtn.setSkin(new skinClass());
					leftBtn.mouseEnabled = isUse;
				}
				else	if(leftBtn.label != btnLabel)
				{
					leftBtn.mouseEnabled = isUse;
					leftBtn.label = btnLabel;
					leftBtn.setSkin(new skinClass());
				}
				
				if(!leftBtn.parent)
				{
					btnBar.addChild(leftBtn);
				}
			}
			else if(leftBtn && leftBtn.parent)
			{
				leftBtn.parent.removeChild(leftBtn);	
			}
		}
		
		/**
		 *续费按钮 
		 * @param $value
		 */		
		private function showRightBtn($value:Boolean):void
		{
			if($value)			
			{
				if(!reNewBtn)
				{
					reNewBtn = createBtn(new BagItemPayBtn(), btnBar,  local.get("renewBtn","bag"));
				}
				
				reNewBtn.x = (leftBtn && leftBtn.parent) ? (leftBtn.width + 5) : 0;
				
				if(!reNewBtn.parent)
				{
					btnBar.addChild(reNewBtn);
				}
				
				playEeffect(data.expireSoon > 0); //即将过期或者已经过期播放特效
			}
			else
			{
				if(reNewBtn && reNewBtn.parent)
				{
					reNewBtn.parent.removeChild(reNewBtn);
				}
				playEeffect(false);
			}
		}
		
		/**
		 *是否播放特效 
		 * @param $value
		 */		
		private function playEeffect($value:Boolean):void
		{
			if($value)
			{
				if(!effect)
				{
					effect = new XufeiEffect();
				}
				
				effect.x = reNewBtn.x;
				effect.y = reNewBtn.y;
				if(!effect.parent)
				{
					btnBar.addChild(effect);
				}
				effect.play();
			}
			else if(effect && effect.parent)
			{
				effect.stop();
				effect.parent.removeChild(effect);
			}
		}
		
		
		/**
		 *鼠标事件 
		 * @param $e
		 */		
		private function onClick($e:MouseEvent):void
		{
			var btn:Button = $e.target as Button;
			if(!btn) return;
			
			switch(btn)
			{
				case leftBtn:
					(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BAG_MALL_SWITCHPROP, {type:data.firstCategoryId, gId:data.id});
					break;
				case reNewBtn:
					(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.BAG_MALL_BUY, {gId:data.id, timeType:1, buyType:1, toMasterId:0});
					break;
			}
		}
		
		/**
		 * 创建按钮
		 * @param $skin
		 */		
		private function createBtn($skin:DisplayObject, $p:DisplayObjectContainer, $label:String = ""):Button
		{
			var btn:Button = new Button($label);
			btn.setSkin($skin);
			btn.height = 23;
			$p.addChild(btn);
			return btn;
		}
		
		override public function get width():Number
		{
			return 160;
		}
		
		override public function get height():Number
		{
			return 80;
		}
	}
}