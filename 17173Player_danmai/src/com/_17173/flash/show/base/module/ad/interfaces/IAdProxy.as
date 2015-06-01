package  com._17173.flash.show.base.module.ad.interfaces
{
	/**
	 * 广告数据加载接口,用于代理广告服务商的数据处理逻辑
	 *  
	 * @author 庆峰
	 */	
	public interface IAdProxy
	{
		
		function resolve(onComplete:Function, onError:Function):void;
		
		function get url():String;
		
	}
}