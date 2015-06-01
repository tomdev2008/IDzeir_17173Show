package
{
	import com._17173.flash.player.business.CustomPlayerParamlize;
	import com._17173.flash.player.business.file.FileCustomerBusinessManager;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.business.file.out.FileCustomerSkinManager;
	import com._17173.flash.player.business.file.out.FileCustomerUIManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;

	public class Player_file_customOut extends Player_file_out
	{
		
		private static const VR:String = "[点播企业]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Player_file_customOut()
		{
			super();
		}
		
		override protected function addContext():void {
			super.addContext();
			
			_(ContextEnum.DATA_RETRIVER, FileCustomerDataRetriver);
			_(ContextEnum.SKIN_MANAGER, FileCustomerSkinManager);
			_(ContextEnum.UI_MANAGER, FileCustomerUIManager);
			_(ContextEnum.BUSINESS_MANAGER, FileCustomerBusinessManager);
		}
		
		override protected function prepareConf():void {
			super.prepareConf();
			
			// 是否允许使用flashvars来控制模块功能
			_("allowModuleParam", CustomPlayerParamlize.acceptFlashvars());
			
			//点播播放器类型
//			Context.variables["type"] = Settings.PLAYER_TYPE_FILE_OUT_CUSTOM;
			_("type", PlayerType.F_CUSTOM);
			_("vr", VR);
			_("vn", VN);
		}
	}
	
}