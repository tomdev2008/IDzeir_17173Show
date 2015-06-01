package com._17173.flash.show.base.module.responsetest
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.base.module.responsetest.operation.ResponseOperation;
	import com._17173.flash.show.base.module.responsetest.operation.ResponseVo;
	
	public class ResponseTest extends BaseModule
	{
		public function ResponseTest()
		{			
			super();
			checkResponse();
		    //每个
			Ticker.tick(30000,checkResponse,0);
		}
		
		private function checkResponse():void
		{
			var resVO:ResponseVo = new ResponseVo();
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			resVO.userId = user.me.id;
			
			if(user.me.broker)
				resVO.mode = "push";
			else
				resVO.mode = "live";
			//统计响应操作类
			new ResponseOperation(resVO);
		}
	}
}