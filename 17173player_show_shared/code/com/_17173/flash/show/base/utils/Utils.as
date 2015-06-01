package com._17173.flash.show.base.utils
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.components.common.LinkText;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.GraphicTextElement;
	import com._17173.flash.show.base.context.text.GraphicTextElementType;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;

	public class Utils
	{
		public function Utils()
		{
		}
		
		public static const GRAY_FILTER:ColorMatrixFilter = new ColorMatrixFilter(
			[
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0, 
				0.3086, 0.6094, 0.082, 0, 0,
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1]); 
		
		
		public static const GRAY_FILTER1:ColorMatrixFilter = new ColorMatrixFilter(
			[
				0.3086, 0.6094, 0.3, 0, 0, 
				0.3086, 0.6094, 0.3, 0, 0, 
				0.3086, 0.6094, 0.3, 0, 0,
				0, 0, 0, 1, 0, 
				0, 0, 0, 0, 1]); 
		
		/**
		 *获取中心区域文本 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function getCenterMsg(data:Object):DisplayObject{
			var text:DisplayObject;
			if(data!=null){
				var textManager:IGraphicTextManager = Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager;
				var sName:String = data.sName;
				var sNo:String = data.sNo;
				var tName:String = data.tName;
				var tNo:String = data.tNo;
				var gName:String = data.giftName;
				var count:String = data.giftCount;
				var sNameE:GraphicTextElement = textManager.createElement();
				sNameE.content =  sName + "(" + sNo +")";
				sNameE.type = GraphicTextElementType.Element_TEXT;
				sNameE.color = 0xacd7f0;
				
				var sg:GraphicTextElement = textManager.createElement();
				sg.content = " 送给 ";
				sg.type = GraphicTextElementType.Element_TEXT;
				sg.color = 0x3391f0;
				
				var tNameE:GraphicTextElement = textManager.createElement();
				tNameE.content =tName + "(" + tNo +")";
				tNameE.type = GraphicTextElementType.Element_TEXT;
				tNameE.color = 0xacd7f0;
				
				var countE:GraphicTextElement = textManager.createElement();
				countE.content = " "+count;
				countE.type = GraphicTextElementType.Element_TEXT;
				countE.color = 0xf2e632;
				
				var ges:GraphicTextElement = textManager.createElement();
				ges.content = " 个 ";
				ges.type = GraphicTextElementType.Element_TEXT;
				ges.color = 0x3391f0;
				
				var gNameE:GraphicTextElement = textManager.createElement();
				gNameE.content = gName;
				gNameE.type = GraphicTextElementType.Element_TEXT;
				gNameE.color = 0xacd7f0;
				
				text = textManager.createGraphicText([sNameE,sg,tNameE,countE,ges,gNameE]);
			}
			return text;
		}
		
		
		/**
		 *获取中心区域文本 
		 * @param data
		 * @return 
		 * 
		 */		
		public static function getGlobelMsg(data:Object,roomid:String):DisplayObject{
			var msg:LinkText;
			if(data!=null){
				var sName:String = formatToHtml(data.sName);
				var sNo:String = data.sNo;
				var tName:String = formatToHtml(data.tName);
				var tNo:String = data.tNo;
				var gName:String = data.giftName;
				var count:String = data.giftCount;
				var cRid:String = data.roomId;
				//				str = sName + "送给" + tName + count + "个" + gName;
				var str:String = "<font color= '#f2e632'>"
					+ sName + "(" +sNo + ")" +
						"<font color='#f2b3f1'>" + "送给" + "</font>" + 
						tName + "(" + tNo + ")" +
						count + "<font color='#f2b3f1'>个</font>" + 
						gName + "</font>";
				//需要判断是否是自己房间如果是则不加url
//				if(Util.validateStr(data.url) && roomid != cRid){
//					str = "<a href='"+ data.url +"' target='_blank'>" +  str + "</a>";
//				}
				var textFormat:TextFormat = new TextFormat();
				textFormat.size = 12;
				textFormat.align = TextFormatAlign.CENTER;
				textFormat.font = FontUtil.f;
				var text:TextField = new TextField();
				text.autoSize = TextFieldAutoSize.CENTER;
				text.wordWrap = true;
				text.htmlText = str;
				text.selectable = false;
				text.width = 350;
				text.height = 40;
				if(text.height <= 24){
					textFormat.leading = 0;
				}else{
					textFormat.leading = -2;
				}
				text.defaultTextFormat = textFormat;
				text.setTextFormat(textFormat);
				msg = new LinkText(text);
				if(Util.validateStr(data.url) && data.url!=null && roomid != cRid){
					msg.setLink(data.url);
				}
			}
			return msg;
		}
		/**
		 * 服务器JSON转数据时候，做了特殊处理，返回给客户端的数据在web页面上可以自动解析</br>
		 * flash解析不了，该方法就处理这个问题。 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function formatToString(value:String):String
		{
			if(!value)return "";
			var str:String=value;
			str=str.replace(/&rsquo;/ig,"“");
			str=str.replace(/&lt;/ig,"<");
			str=str.replace(/&gt;/ig,">");				
			str=str.replace(/&rdquo;/ig,"\"");
			str=str.replace(/&ldquo;/ig,"\"");
			str=str.replace(/&quot;/ig,"\"");
			str=str.replace(/&amp;/ig,"\&");
			str=str.replace(/\\\"/ig,"\"");
			str=str.replace(/\\\'/ig,"\'");
			str=str.replace(/\\\//ig,"\/");
			str=str.replace(/\\\\/ig,"\\");
			
			return str;
		}
		/**
		 *改变字符串为html格式，用于htmltext显示
		 * @param value
		 * @return 
		 * 
		 */		
		public static function formatToHtml(value:String):String{
			var str:String=value;
			str=str.replace(/\</ig,"&lt;");
			str=str.replace(/\>/ig,"&gt;");
			str=str.replace(/\"/ig,"\\\"");
			str=str.replace(/\'/ig,"\\\'");
			str=str.replace(/\//ig,"\\\/");
			str=str.replace(/\\/ig,"\\\\");
			return str;
		}
		/**
		 * 验证obj对象里面存不存在key值，并且该key的值不为null 
		 * @param obj
		 * @param key
		 * @return 
		 * 
		 */		
		public static function validate(obj:Object,key:String=""):Boolean
		{
			if(obj==null)return false;
			if(!obj.hasOwnProperty(key))return false;
			if(obj[key]==null)return false;
			return true;
		}
		
		/**
		 * 加载外部图片 
		 * @param url 图片地址
		 * @param isFix 是否固定大小，为true时将同步返回图片大小并在加载完成后缩放图片到后面参数大小
		 * @param w 固定大小时候，指定的图片宽
		 * @param h 固定大小时候，指定的图片宽
		 * @return 
		 * 
		 */		
		public static function getURLGraphic(url:String, isFix:Boolean = true, w:Number = 24, h:Number = 24):DisplayObject
		{
			var sprite:Sprite = new Sprite();
			sprite.mouseChildren = false;
			sprite.mouseEnabled = false;
			sprite.buttonMode = true;
			if(isFix)
			{
				sprite.graphics.beginFill(0x000000, 0);
				sprite.graphics.drawRect(0, 0, w, h);
				sprite.graphics.endFill();
			}			
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(url, function(value:IResourceData):void
			{
				sprite.addChild(value.newSource as DisplayObject);
				if(isFix)
				{
					sprite.width = w;
					sprite.height = h;					
					sprite.graphics.clear();
				}
			});
			return sprite;
		}

		/**
		 * 打印二进制数据
		 * @param bytes
		 * @return
		 *
		 */
		public static function printfBytes(bytes:ByteArray):String
		{
			var s:String = "";

			for (var i:uint = 0; i < bytes.length; i++)
			{
				s += bytes[i];
			}

			return s;
		}
		
		/**
		 *检测是否是子级 
		 * @param checkTarget 检测目标
		 * @param parent 父类
		 * @return 
		 * 
		 */		
		public static function checkIsChild(checkTarget:DisplayObject,parent:DisplayObject):Boolean{
			var result:Boolean = false;
			if(checkTarget === parent){
				result = true;
			}else{
				if(checkTarget.parent){
					result = checkIsChild(checkTarget.parent,parent);
				}
			}
			return result;
		}
		
		/**
		 *返回字符串的字符长度 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkStrLength(str:String):int{
			return str.replace(/[^\x00-\xff]/g,"xx").length
		}
		
		/**
		 *  flashVersion
		 * 
		 */		
		public static function getFlashVersion():Array   // flash版本号
		{
			var runtimeVersion : String = Capabilities.version;
			var osArray:Array = runtimeVersion.split(' ');
			
			var osType:String = osArray[0]; 
			var versionArray:Array = osArray[1].split(',');
			
			return versionArray;
		}
	}
}