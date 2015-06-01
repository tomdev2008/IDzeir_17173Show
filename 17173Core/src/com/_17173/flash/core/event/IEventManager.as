package com._17173.flash.core.event
{
	public interface IEventManager
	{
		/**
		 * 发送事件.
		 *  
		 * @param type 自定义的消息类型.
		 * @param data 消息附带的数据.
		 * @param target 指定消息发送的对象,用来针对性的进行消息派发.可选.
		 * @param immediately 是否立即发送事件,默认为false.设置该属性为true时,会将当前序列里的所有事件全部进行发送.
		 */		
		function send(type:String, data:Object = null, target:Object = null, immediately:Boolean = false):void;
		/**
		 * 当接收到一个派发时,如果要阻止当前消息继续派发,可以调用这个方法打断此类方法的派发.
		 * 原理是打断消息派发的while循环,来组织后续消息的调用.
		 *  
		 * @param type 要打断的消息类型
		 * 
		 */		
		function cancel(type:String):void;
		/**
		 * 监听一个消息.
		 *  
		 * @param type 消息类型
		 * @param callback 消息监听回调
		 * @param target 消息监听的目标.用于指定消息的派发对象,当指定此参数时,监听回调的回调函数将使用call(target, ...)的方式进行调用.
		 * @param priority 消息派发优先级
		 * @param weakRef 是否使用弱引用,设置为true将定时被清除
		 * 
		 */		
		function listen(type:String, callback:Function, target:Object = null, priority:int = 0, weakRef:Boolean = false):void;
		/**
		 * 移除一个已经添加的监听.
		 *  
		 * @param type 消息类型
		 * @param callback 消息监听回调
		 * @param target 消息监听的目标,具体解释见 @see com._17173.flash.event.EventManager#listen()
		 * 
		 */		
		function remove(type:String, callback:Function, target:Object = null):void
			
	}
}