package
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.BaseShowStage;
	import com._17173.flash.show.base.context.authority.Authority;
	import com._17173.flash.show.base.module.animation.entereffect.EnterEffectDelegate;
	import com._17173.flash.show.base.module.animation.sceneeffect.SceneEffectDelegate;
	import com._17173.flash.show.base.module.bottombar.BottomBarDelegate;
	import com._17173.flash.show.base.module.centermessage.CenterMessageDelegate;
	import com._17173.flash.show.base.module.chat.ChatPanelDelegate;
	import com._17173.flash.show.base.module.dingyue.SubscribeDelegate;
	import com._17173.flash.show.base.module.enterRoom.EnterRoomDelegate;
	import com._17173.flash.show.base.module.gift.GiftDelegate;
	import com._17173.flash.show.base.module.lobby.LobbyDelegate;
	import com._17173.flash.show.base.module.login.LoginDelegate;
	import com._17173.flash.show.base.module.open.OpenDelegate;
	import com._17173.flash.show.base.module.preview.PreviewDelegate;
	import com._17173.flash.show.base.module.qm.QmDeletegate;
	import com._17173.flash.show.base.module.scene.SceneDelegate;
	import com._17173.flash.show.base.module.seat.SeatAreaDelegate;
	import com._17173.flash.show.base.module.smileres.SmilePanelDelegate;
	import com._17173.flash.show.base.module.stat.StatDelegate;
	import com._17173.flash.show.base.module.topbar.TopBarDelegate;
	import com._17173.flash.show.base.module.userCard.UserCardDelegate;
	import com._17173.flash.show.base.module.userlist.UserListDelegate;
	import com._17173.flash.show.base.module.video.VideoDelegate;
	import com._17173.flash.show.base.module.video.base.MicManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.PEnum;
	
	/**
	 * 三麦房项目入口类
	 *
	 * @author shunia-17173
	 */
	[SWF(frameRate="24", backgroundColor="0x000000")]
	public class SanmaiMain extends BaseShowStage
	{
		
		public function SanmaiMain()
		{
			super();
		}

		override protected function init():void {
			_version = "三麦房 版本号: beta_0.1.5 201501231000";
			super.init();
		}

		override protected function addContext():void {
			super.addContext();
			
			//注册权限管理
			Context.regContext(CEnum.AUTHORITY, null, Authority);
			//注册麦序管理
			Context.regContext(CEnum.MICMANAGER, null, MicManager);
		}
		
		override protected function get delegates():Object {
			var d:Object = super.delegates;
			d[PEnum.SCENE] = SceneDelegate;
			d[PEnum.LOGIN] = LoginDelegate;
			d[PEnum.PREVIEW_VIDEO] = PreviewDelegate;
			d[PEnum.VIDEO] = VideoDelegate;
			d[PEnum.ENTER_ROOM] = EnterRoomDelegate;
			return d;
		}
			
		override protected function get subDelegates():Object{
			var d:Object = super.subDelegates;
			d[PEnum.TOPBAR] = TopBarDelegate;
			d[PEnum.BOTTOMBAR] = BottomBarDelegate;
			d[PEnum.CENTERMESSAGE] = CenterMessageDelegate;
			d[PEnum.SEATAREA] = SeatAreaDelegate;
			d[PEnum.OPEN_ROOM] = OpenDelegate;
			d[PEnum.GIFT] = GiftDelegate;
			d[PEnum.USER_LIST] = UserListDelegate;
			d[PEnum.CHAT_PANEL] = ChatPanelDelegate;
			d[PEnum.SMILERES_PANEL] = SmilePanelDelegate;
			d[PEnum.USER_CARD] = UserCardDelegate;
			d[PEnum.QUALITY_MONITER] = QmDeletegate;
			d[PEnum.LOBBY] = LobbyDelegate;
			d[PEnum.ST] = StatDelegate;
			d[PEnum.SUBSCRIBE] = SubscribeDelegate;
			d[PEnum.ENTEREFFECT] = EnterEffectDelegate;
			d[PEnum.SCENEEFFECT] = SceneEffectDelegate;
			return d;
		}

	}
}