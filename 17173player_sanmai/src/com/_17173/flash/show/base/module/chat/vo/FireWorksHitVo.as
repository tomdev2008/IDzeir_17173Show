package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;

	import flash.text.engine.TextElement;

	/**
	 * 中烟花奖励信息
	 * @author idzeir
	 */	
	public class FireWorksHitVo extends BaseChatVo
	{
		private var _hit:HitVo;

		public function FireWorksHitVo()
		{
			super();
		}

		public function set hit(value:Object):void
		{
			_hit = new HitVo(value);
		}

		override protected function initVo():void
		{
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;

			super.initVo();
			this._elems.push(this.timeStamp);

			var textElement:TextElement = new TextElement(" "+_hit.userName+" ",FontUtil.getFormat(0x63acff))
			textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
			textElement.userData = iUser.hasUser(_hit.userId)?iUser.getUser(_hit.userId):new UserData();
			this._elems.push(textElement);

			this._elems.push(new TextElement("点燃了 ",FontUtil.getFormat(0xFF9900)));

			this._elems.push(new TextElement("" + _hit.giftCount,FontUtil.getFormat(0xFFFF00)));

			this._elems.push(new TextElement(" 个 ",FontUtil.getFormat(0xFF9900)));

			this._elems.push(new TextElement(_hit.giftName,FontUtil.getFormat(0xCCCCCC)));

			this._elems.push(new TextElement("，恭喜你获得 ",FontUtil.getFormat(0xFF9900)));

			this._elems.push(new TextElement("" + _hit.inCome,FontUtil.getFormat(0xFFFF00)));

			this._elems.push(new TextElement(" 乐豆",FontUtil.getFormat(0xFF9900)));
		}


		override protected function dispose():void
		{
			super.dispose();
			_hit = null;
		}
	}
}

class HitVo
{
	public var userName:String;
	public var userId:String;
	public var userNo:String;

	public var giftCount:String;
	public var giftName:String;

	public var inCome:String;

	public function HitVo(data:Object)
	{
		//{"userName":obj["userName"],"userId":obj["userId"],"userNo":obj["userNo"],"giftCount":obj["giftCount"],"giftName":obj["giftName"],"inCome":obj["income"]}
		userName = String(data["userName"]);
		userId = String(data["userId"]);
		giftCount = String(data["giftCount"]);
		giftName = String(data["giftName"]);
		userNo = String(data["userNo"]);
		inCome = String(data["inCome"]);
	}
}

