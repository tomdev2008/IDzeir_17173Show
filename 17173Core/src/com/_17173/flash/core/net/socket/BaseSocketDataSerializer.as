package com._17173.flash.core.net.socket
{
	import com._17173.flash.core.util.SimpleObjectPool;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;

	/**
	 * 数据解析类,当Server有数据返回或发送时,都需要调用特定的Serializer类,
	 * 使用其中的deserialize进行数据解析以提供给需要的地方的逻辑调用,
	 * 使用其中的serialize进行数据封装以将请求的数据封装为字节流提交给Server.
	 * @author Shunia
	 * 
	 */	
	public class BaseSocketDataSerializer
	{
		/**
		 * 一个请求方法可能会有多处进行了监听,用字典对其进行保存. 
		 */		
		protected var _registeredFunctions:Dictionary;
		/**
		 * 假设请求数据的回调方法使用了弱引用,则将其保存在这个数组中,用来清除引用. 
		 */		
		protected var _weakRefs:Array;
		/**
		 * 已注册监听的方法数. 
		 */		
		private var _registeredFunctionsNum:int = 0;
		
		public function BaseSocketDataSerializer()
		{
			_registeredFunctions = new Dictionary();
			_registeredFunctionsNum = 0;
			_weakRefs = [];
		}
		
		/**
		 * 请求的ID,需与后端约定,进行定义. 
		 * @return 
		 * 
		 */		
		public function get id():int {
			return 100000;
		}
		
		/**
		 * 当需要接受此接口的数据回调时,需要将监听函数注册进来. 
		 * @param func	数据到达后回调的方法.
		 * @param useWeakRefrence	当任意一次数据到达后,此方法的引用将会被删除.
		 * 
		 */		
		public function registerListener(func:Function, useWeakRefrence:Boolean = false):void {
			_registeredFunctions[func] = func;
			_registeredFunctionsNum ++;
			//如果是弱引用,放入弱引用数组中以便清除
			if (useWeakRefrence) {
				_weakRefs.push(func);
			}
		}
		
		public function removeListener(func:Function):void {
			if (_registeredFunctions[func]) {
				delete _registeredFunctions[func];
				_registeredFunctionsNum --;
			}
		}
		
		/**
		 * 解析Server发来的字节流数据为正常的数据格式,并回调给各个注册函数. 
		 * @param socket
		 */		
		public function deserialize(socket:IDataInput):void {
			if (_registeredFunctionsNum > 0) {
				var data:Object = readData(socket);
				for each (var func:Function in _registeredFunctions) {
					func(data);
				}
//				SimpleObjectPool.getPool(Object).returnObject(data);
//				for (var key:* in data) {
//					delete data[key];
//				}
				clearWeakRef();
			}
		}
		
		/**
		 * 解析Server数据的逻辑,需被覆写. 
		 * @param socket
		 * @return 
		 * 
		 */		
		protected function readData(socket:IDataInput):Object {
			//should be override
			return null;
		}
		
		/**
		 * 清除弱引用. 
		 * 
		 */		
		protected function clearWeakRef():void {
			for each (var func:Function in _weakRefs) {
				removeListener(func);
			}
			_weakRefs = [];
		}
		
		/**
		 * 将需要处理的数据封装成字节流. 
		 * @param socket
		 * @param data
		 * 
		 */		
		public function serialize(data:Array):ByteArray {
			return writeData(data);
		}
		
		/**
		 * 封装数据为字节流,需覆写. 
		 * @param socket
		 * @param data
		 * 
		 */		
		protected function writeData(data:Array):ByteArray {
			return null;
		}
		
		protected function get object():Object {
			return SimpleObjectPool.getPool(Object).getObject() as Object;
		}
		
		protected function get byteArray():ByteArray {
			return SimpleObjectPool.getPool(ByteArray).getObject() as ByteArray;
		}
		
	}
}