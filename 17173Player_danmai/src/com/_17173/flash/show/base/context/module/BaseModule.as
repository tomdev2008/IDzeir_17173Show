package com._17173.flash.show.base.context.module
{
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 各个模块基类,实现了IModule类.
	 *  
	 * @author shunia-17173
	 */	
	public class BaseModule extends Sprite implements IModule
	{
		
		private var _name:String = null;
		protected var _data:Object = null;
		
		protected var _version:String;
		
		public function BaseModule()
		{
			init();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
		}
		
		public function get version():String
		{
			return _version;
		}
		
		/**
		 * 添加到舞台后调用的方法.
		 *  
		 * @param event
		 */		
		protected function onAdded(event:Event):void {
			//override
			//添加到舞台后统一处理
		}
		
		/**
		 *移除舞台 
		 * @param event
		 * 
		 */		
		protected function onRemove(event:Event):void{
			
		}
		/**
		 * 在构造方法中执行的初始化方法. 
		 */		
		protected function init():void {
			//override
			//构造函数初始化方法
		}

		override public function set name(value:String):void {
			_name = value;
		}
		
		override public function get name():String {
			return _name;
		}
		
		public function set data(value:Object):void
		{
			for(var i:String in value)
			{
				if(this.hasOwnProperty(i))
				{
					if(this[i] is Function)
					{
						//调用的是方法
						var handle:Function = this[i] as Function;
						var pars:* = value[i];
						if(pars)
						{
							if(pars.length>1)
							{
								//多参数
								handle.apply(null,pars);
							}else{
								handle.apply(null,[pars[0]]);
							}
						}else{
							handle.apply();
						}
					}else{
						//调用的是public的属性
						this[i] = value[i][0];
					}
				}
			}
		}

	}
}