package com._17173.flash.core.net.loaders.resolver
{
	public class JSONResolver implements IManuallyResolver
	{
		public function JSONResolver()
		{
		}
		
		public function resolve(target:*):*
		{
			try {
				return JSON.parse(target);
			} catch (e:Error) {
				//如果解析错误就返回-1
				return "-1";
			}
		}
	}
}