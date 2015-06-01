package com._17173.framework.core.objpool
{
	import com._17173.framework.core.objpool.ibase.IGenericObjectPool;
	import com._17173.framework.core.objpool.ibase.IObject;

	/** 
	 * @author Cray
	 * @version 创建时间：Oct 25, 2014 10:27:22 PM 
	 **/ 
	public class GenericObjectPool implements IGenericObjectPool
	{
	
		private var _objCollection:Vector.<IObject> = new Vector.<IObject>;
		
		private var _typeCls:Class;
		
		private var _active:Boolean=true;

		
		public function GenericObjectPool(typeCls:Class)
		{
			_typeCls = typeCls;
		}
		
		private  var _maxPoolSize:int = 100;		
		/** 最大对象数量 **/
		public function set maxPoolSize(value:int):void
		{
			_maxPoolSize = value;
		}
		/**
		 * 借出对象
		 * @return 
		 * 
		 */		
		public function borrowObject():IObject
		{
			var io:IObject;
			if(_objCollection.length>0)
				io =  _objCollection.shift();		
			else
				io = new _typeCls();
			return io;
		}
		
		/**
		 * 返回对象
		 * @param obj
		 * 
		 */		
		public function returnObject(obj:IObject):void
		{
			if(_objCollection.length > _maxPoolSize)
			{
				return;
			}
			if(_objCollection.indexOf(obj,0)==-1)
			{
				obj.reset();
				_objCollection.push(obj);
			}
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function borrowObjectVector(value:int):Vector.<IObject>
		{
			if(value==0)return null;
			var reVec:Vector.<IObject> = new Vector.<IObject>;
			var i:int;
			if(value<_objCollection.length)
			{
				for(i=value;i>0;i--)
				{
					if(i<_objCollection.length)
						reVec.push(_objCollection.shift());
					
				}
			}else
			{
				i = value - _objCollection.length;
				for(i; i>0; i--)
				{
					reVec.push(new _typeCls());
				}
				i = _objCollection.length;
				for (i; i>0; i--) {
					reVec.push(_objCollection.pop());
				}
			}
            return reVec;
		}
		/**
		 * 
		 * @param vec
		 * 
		 */
		public function returnObjectVector(vec:Vector.<IObject>):void
		{
			if(_objCollection.length > _maxPoolSize)
			{
				//log
				return;
			}
			for each(var obj:IObject in vec)
			{
				if(_objCollection.indexOf(obj,0)==-1)
				{
					obj.reset();
					_objCollection.push(obj);
				}
			}
		}
		
		/**
		 * 清空对象池 
		 * 对池中每个对象调用dipose() 方法等待GC回收
		 */		
		public function clear():void
		{
			for (var i:int = _objCollection.length-1; i>=0; i--) {
				var obj:IObject = _objCollection.pop();
				obj.dipose();
			}
		}
		/**
		 * 关闭对象池 
		 * 
		 */		
		public function close():void
		{
			this.clear();
			_active = false;
		}
		/**
		 * 是否处于激活状态 
		 * @return 
		 * 
		 */		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			this._active=value;
		}
	}
}