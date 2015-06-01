package com._17173.flash.show.base.init
{
	import com._17173.flash.show.base.init.base.BaseInit;
	
	/**
	 * 初始化后的检查.
	 * 如果需要对之前的业务进行判断以作为是否允许最终渲染进入界面的依据的话,可以增加到这里.
	 * 也可以用来检测某些重要的模块是否完成.
	 *  
	 * @author shunia-17173
	 */	
	public class InitComplete extends BaseInit
	{
		public function InitComplete()
		{
			super();
			this._weight = 10;
			_name = "最后的准备";
		}
		
		override public function enter():void {
			super.enter();
			
			complete();
		}
		
	}
}