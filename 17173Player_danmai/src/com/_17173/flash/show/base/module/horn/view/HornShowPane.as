package com._17173.flash.show.base.module.horn.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[Event(name="openSendPane", type="flash.events.Event")]
	
	/**
	 *显示广播panel 
	 * @author yexianhui
	 */	
	public class HornShowPane extends Sprite
	{
		
		/**打开发广播面板的按钮*/
		private var _openBtn:HornBtn;
		
		/**
		 *条尺寸 
		 */		
		private var barSize:int;
		
		/**
		 *播放队列 
		 */		
		private var queue:HornShowQueue;
		
		public function HornShowPane()
		{
			super();
			
			queue = new HornShowQueue();
			queue.addEventListener("allowPush", pushFromCache);
			this.addChild(queue);
			
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			
			_openBtn = new HornBtn("<font color='#FBC65D'>" + lc.get("sendHorn", "horn") + "</font>", false, new Point(10, 0));
			_openBtn.setSkin(new HornOpenBtn());
			_openBtn.addEventListener(MouseEvent.CLICK, openSendPane);
			this.addChild(_openBtn);
			
			var labaIcon:HornLabaIcon = new HornLabaIcon();
			labaIcon.mouseEnabled = labaIcon.mouseChildren = false;
			labaIcon.x = 20;
			labaIcon.y = 9;
			_openBtn.addChild(labaIcon);
		}
		
		/**
		 * 把缓存中的加入队列
		 * @param event
		 */		
		private function pushFromCache(event:Event = null):void
		{
			queue.waitCount = _cache.length;
			if(!queue.allowPush || _cache.length == 0) return;
			queue.push(HornShowItem.createItem(_cache.shift()));
//			queue.push(HornShowItem.createItem(_cache[0]));
		}
		
		
		
		/**
		 *打开发广播面板 
		 * @param event
		 */		
		private function openSendPane(event:MouseEvent):void
		{
			this.dispatchEvent(new Event("openSendPane"));
		}
		
		/**
		 *更新背景条 
		 * @param $size
		 * 
		 */		
		public function resize($size:int):void
		{
			barSize = $size - _openBtn.width - 2;
			queue.setSize(barSize, 32);
			_openBtn.x = barSize;
		}
		
		
		//=====================
		/**
		 *消息缓存 
		 */		
		private var _cache:Array = [];
		
		/**
		 *新消息 
		 * @param data 消息
		 * @param type 是否优先显示 0 否 !=0 是
		 * 
		 */			
		public function addMessage(data:*,type:int = 0):void{
			if(type != 0)
			{
				_cache.unshift(data);
			}
			else
			{
				_cache.push(data);
			}
			pushFromCache();
		}
	}
}


//======================================
import com._17173.flash.core.components.common.Button;

import flash.geom.Point;


class HornBtn extends Button
{
	
	/**
	 *label便宜量 
	 */		
	private var _offsetPos:Point;
	
	public function HornBtn(label:String="", isSelected:Boolean=false, offsetPos:Point = null)
	{
		this._offsetPos = offsetPos;
		super(label, isSelected);
	}
	
	override protected function onRePostionLabel():void
	{
		super.onRePostionLabel();
		if(!_labelTxt) return;
		_labelTxt.x += _offsetPos.x;
		_labelTxt.y += _offsetPos.y;
	}
}