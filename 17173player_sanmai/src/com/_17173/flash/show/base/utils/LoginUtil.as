package com._17173.flash.show.base.utils
{
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.show.model.SEnum;

	public class LoginUtil
	{
		public function LoginUtil()
		{
		}
		
		/**
		 * 获注册页 
		 * @param mobile 是否手机注册
		 * @param isLogin 是否自动登录
		 * @param autoHome 登录后是否自动返回首页
		 * @return 
		 * 
		 */			
		public static function getRegUrl(mobile:Boolean = true,isLogin:Boolean = true,autoHome:Boolean = true):String{
			var url:String = "";
			var loginType:String = "";
			var islogin:int = int(isLogin)
			if(mobile){
				loginType = "#mobile";
			}
			//自动登录
			url = SEnum.URL_REGISTER  + "?autologin="+islogin;
			//返回首页
			 if(autoHome){
				 url = url+"&callbackurl=" + Base64.encodeStr(SEnum.domain) + ""
			 }
			 //登录锚点
			 url = url + loginType;
			 
			 return url;
		}
	}
}