package
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	
	/**
	 * 上传组件入口类.
	 *  
	 * @author shunia-17173
	 * version 1.0.0
	 */	
	public class Upload extends StageIniator
	{
		private static const YELLOW_WIDTH:int = 772;
		//暂时没用，不要动
//		private var infoText:TextField;
//		private var progressLabel:TextField;
		private var byteArray:ByteArray = new ByteArray();
		private var request:URLRequest = new URLRequest("http://v.17173.com/u/upload"); 
		private var loader:URLLoader = new URLLoader(); 
		private var currentByte:int = 0;
		private var writeLength:int = TYPESIZE;
		private static const TYPESIZE:int = 1024000;
		
		
		private var file:FileReference;
		//滚动条左侧
		private var bgLeft:MovieClip;
		//滚动条中间
		private var bgMiddle:MovieClip;
		//滚动条右侧
		private var bgRight:MovieClip;
		//取消上传按钮
		private var cancelLoad:MovieClip;
		//滚动条中间黄色部分
		private var yellow:MovieClip;
		//名称
		private var nameText:TextField;
		//类型
		private var typeText:TextField;
		//大小
		private var sizeText:TextField;
		//上传速度
		private var loadSpeedText:TextField;
		//上传大小
		private var loadSize:TextField;
		//剩余时间
		private var leftTime:TextField;
		//进度
		private var progress:TextField;
		//失败text
		private var failText:TextField;
		//继续上传
		private var continueUpload:MovieClip;
		
		
		
		
		private var sprite:Sprite;
		private var button:Sprite;
		//是否打开文件选择界面
		private var isBrowse:Boolean = false;
		//时间戳
		private var date:Date;
		//可选播放器类型
		private var typeStr:String = "mp4";
		public function Upload()
		{
			super(true);
			
		}
		
		override protected function init():void {
			super.init();
			
			var ver:String = "1.0.0";
			var c:ContextMenu = new ContextMenu();
			var cst:Array = [];
			var item:ContextMenuItem = new ContextMenuItem("[上传组件]" + ver, false, false);
			cst.push(item);
			c.hideBuiltInItems();
			c.customItems = cst;
			
			this.contextMenu = c;
			
			buildUI();
		}
		
		private function buildUI():void {
			//			trace();
			sprite = new Sprite();
			stage.addChild(sprite);
			
			file = new FileReference();
			file.addEventListener(Event.CANCEL, cancel);
			file.addEventListener(Event.OPEN,open); 
			file.addEventListener(Event.SELECT, onFileSelect); 
			file.addEventListener(ProgressEvent.PROGRESS, progressHandle); 
			file.addEventListener(Event.COMPLETE, completeHandle); 
			file.addEventListener(IOErrorEvent.IO_ERROR,ioerror);
			file.addEventListener(IOErrorEvent.NETWORK_ERROR,neterror);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,upLoadComplete);
			
//			infoText = new TextField();
//			infoText.x = 0;
//			infoText.y = 30;
//			infoText.mouseEnabled = false;
//			infoText.autoSize = TextFieldAutoSize.LEFT;
//			infoText.width = 600;
//			infoText.wordWrap = true;
//			infoText.text = "infoText";
			
			
			
//			progressLabel = new TextField();
//			progressLabel.x = 0;
//			progressLabel.y = 60;
//			progressLabel.autoSize = TextFieldAutoSize.LEFT;
//			progressLabel.text = "progressLabel";
			//			stage.addChild(progressLabel);
			
			
			var textFormat:TextFormat = new TextFormat('SimSun',14,'0x5b5b5b');
			var textFormat2:TextFormat = new TextFormat('SimSun',12,'0x878787');
			var textFormat3:TextFormat = new TextFormat('Microsoft YaHei',24,'0x5b5b5b');
			var textFormat4:TextFormat = new TextFormat('SimSun',12,'0xFF0000');
			
			nameText = new TextField();
//			nameText.maxChars = 26;
			nameText.width = 400;
			nameText.x = 0;
			nameText.y = 0;
//			nameText.autoSize = TextFieldAutoSize.LEFT;
			nameText.defaultTextFormat = textFormat;
			nameText.mouseEnabled = false;
			nameText.text = "";
			
			typeText = new TextField();
			typeText.defaultTextFormat = textFormat;
			typeText.text = "";
			typeText.x = 235;
			typeText.y = 0;
			typeText.mouseEnabled = false;
			typeText.autoSize = TextFieldAutoSize.LEFT;
			
			sizeText = new TextField();
			sizeText.defaultTextFormat = textFormat;
			sizeText.mouseEnabled = false;
			sizeText.text = "";
			sizeText.x = 325;
			sizeText.y = 0;
			sizeText.autoSize = TextFieldAutoSize.LEFT;
			
			
			bgLeft = new BgLeft();
			bgLeft.x = 0;
			bgLeft.y = 29;
			bgMiddle = new BgMiddle();
			bgMiddle.x = 4;
			bgMiddle.y = 29;
			bgMiddle.width = YELLOW_WIDTH;
			bgRight = new BgRight();
			bgRight.x = 776;
			bgRight.y = 29;
			yellow = new Yellow();
			yellow.x = 4;
			yellow.y = 33;
			yellow.width = 1;
			
			progress = new TextField();
			progress.mouseEnabled = false;
			progress.x = 0;
			progress.y = 28;
			progress.defaultTextFormat = textFormat3;
			progress.text = "";
			progress.width = 780;
			progress.autoSize = TextFieldAutoSize.CENTER;
			
			loadSpeedText = new TextField();
			loadSpeedText.mouseEnabled = false;
			loadSpeedText.x = 0;
			loadSpeedText.y = 76;
			loadSpeedText.defaultTextFormat = textFormat2;
			loadSpeedText.text = "";
			loadSpeedText.autoSize = TextFieldAutoSize.LEFT;
			
			loadSize = new TextField();
			loadSize.mouseEnabled = false;
			loadSize.defaultTextFormat = textFormat2;
			loadSize.text = "";
			loadSize.x = 136;
			loadSize.y = 76;
			loadSize.autoSize = TextFieldAutoSize.LEFT;
			
			leftTime = new TextField();
			leftTime.mouseEnabled = false;
			leftTime.defaultTextFormat = textFormat2;
			leftTime.text = "";
			leftTime.x = 295;
			leftTime.y = 76;
			leftTime.autoSize = TextFieldAutoSize.LEFT;
			
			
			failText = new TextField();
			failText.selectable = false;
			failText.defaultTextFormat = textFormat4;
			failText.autoSize = TextFieldAutoSize.LEFT;
			failText.htmlText = "";
			failText.visible = true;
			failText.x = 444;
			failText.y = 76;
			
			
			
			cancelLoad = new CancelUpLoad();
			cancelLoad.x = 800;
			cancelLoad.y = 38;
			cancelLoad.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			cancelLoad.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			cancelLoad.addEventListener(MouseEvent.CLICK,loadCancel);
			cancelLoad.stop();
			
			continueUpload = new ContinueUpload();
			continueUpload.x = 800;
			continueUpload.y = 38;
			continueUpload.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			continueUpload.addEventListener(MouseEvent.MOUSE_OUT,mouseOut);
			continueUpload.addEventListener(MouseEvent.CLICK,conUpload);
			continueUpload.stop();
			continueUpload.visible = false;
			
			
			
			sprite.addChild(nameText);
			sprite.addChild(typeText);
			sprite.addChild(sizeText);
			sprite.addChild(loadSpeedText);
			sprite.addChild(loadSize);
			sprite.addChild(leftTime);
			
			sprite.addChild(bgLeft);
			sprite.addChild(bgRight);
			sprite.addChild(bgMiddle);
			sprite.addChild(cancelLoad);
			sprite.addChild(continueUpload);
			sprite.addChild(yellow);
			sprite.addChild(failText);
			sprite.addChild(progress);
			
			JSBridge.addCall("UploadFileCancel",null,null,UploadFileCancel,true);
			
			sprite.visible = false;
			
			button = new Sprite();
			button.x = 0;
			button.y = 0;
			button.graphics.beginFill(0xFF0000);
			button.graphics.drawRect(0,0,881,88);
			button.graphics.endFill();
			button.addEventListener(MouseEvent.CLICK,onClickBrowserBtn);
			stage.addChild(button);
			button.visible = true;
			button.alpha = 0;
			
			button.buttonMode = true;
			button.useHandCursor = true;
//			Debugger.output = new DebuggerOutput_console();
//			stage.addChild(infoText);
		}
		
		/**
		 * js调as，取消上传时调用 
		 *
		 * 
		 */		
		public function UploadFileCancel():void
		{
//			Debugger.log(Debugger.INFO,"UploadFileCancel");
			button.visible = true;
			sprite.visible = false;
			file.cancel();
		}
		/**
		 * 鼠标移动上按钮时 
		 * @param e
		 * 
		 */		
		private function mouseOver(e:MouseEvent):void
		{
			e.target.gotoAndStop(2);
		}
		/**
		 * 鼠标移出按钮时 
		 * @param e
		 * 
		 */		
		private function mouseOut(e:MouseEvent):void
		{
			e.target.gotoAndStop(1);
		}
		/**
		 * 取消上传 
		 * @param e
		 * 
		 */		
		private function loadCancel(e:MouseEvent):void
		{
//			Debugger.log(Debugger.INFO,"loadCancel");
			isBrowse = false;
			file.cancel();
			JSBridge.addCall("UploadCancel",{Progress:int(yellow.width/YELLOW_WIDTH *100)});
		}
		
		/**
		 * 继续上传
		 * @param e
		 * 
		 */		
		private function conUpload(e:MouseEvent):void
		{
//			Debugger.log(Debugger.INFO,"conUpload");
			isBrowse = false;
			file.cancel();
			JSBridge.addCall("UploadContinue");
		}
		
		/**
		 * IOErrorEvent.IO_ERROR 
		 * @param e
		 * 
		 */		
		private function ioerror(e:Event):void
		{
			//			trace(e);
//			file.cancel();
			failText.htmlText ="网络异常，上传失败";
			failText.visible = true;
		}
		private function neterror(e:Event):void
		{
			//			trace(e);
//			file.cancel();
			failText.htmlText ="网络异常，上传失败";
			failText.visible = true;
		}
		
		/**
		 * 打开选择文件界面
		 * @param e
		 * 
		 */		
		private function onClickBrowserBtn(e:Event = null) : void { 
//			Debugger.log(Debugger.INFO,"onClickBrowserBtn");
			e.stopPropagation();
			file.cancel();
			if(isBrowse == false)
			{
				isBrowse = file.browse(getTypeFilter()); 
			}
		}
		/**
		 * open 
		 * @param e
		 * 
		 */		
		private function open(e:Event) : void {
//			trace("open"+e.target);
		} 
		/**
		 * cancel 
		 * @param e
		 * 
		 */		
		private function cancel(e:Event) : void { 
//			Debugger.log(Debugger.INFO,"cancel");
			isBrowse = false;
//			trace("cancel" + e.target);
		} 
		/**
		 * 可用播放器类型 
		 * @return 
		 * 
		 */		
		private function getTypeFilter() : Array { 
			
			typeStr = stage.loaderInfo.parameters.type;
				
//			typeStr = "mp4|wmv|avi|flv|asf|mpg|mpeg|rm|rmvb|mov|mkv|vob|dat";
//			Debugger.log(Debugger.INFO, "type = "+typeStr);
			
			var array:Array = typeStr.split("|");
			
			var info:String = "";
			for(var i:int = 0;i<array.length;i++)
			{
				if(i < array.length - 1)
				{
					info += "*."+array[i]+";";
				}
				else
				{
					info += "*."+array[i];
				}
			}
			var imagesFilter:FileFilter = new FileFilter("("+info+")", info); 
			return [imagesFilter]; 
			
		} 
		/**
		 * 选择文件 
		 * @param event
		 * 
		 */		
		private function onFileSelect(event : Event) : void {
			try
			{
				var index:int = file.name.lastIndexOf(".");
				var name:String = file.name.slice(0,index);
				var fileType:String = file.name.slice(index+1).toLocaleLowerCase();
				var obj:Object = new Object();
				obj["name"] = name;
//				Debugger.log(Debugger.INFO, "onFileSelect");
				if(typeStr.indexOf(fileType) == -1)
				{
//					Debugger.log(Debugger.INFO, "UploadInvalidFormat");
					obj["code"] = -2;
					obj["type"] = fileType;
					isBrowse = false;
				}else
				{
					if(file.size >= 1024 * 1024 * 1000)
					{
//						Debugger.log(Debugger.INFO, "FileBigSize");
						obj["code"] = -1;
						obj["size"] = file.size;
						isBrowse = false;
					}
					else
					{
//						Debugger.log(Debugger.INFO, "JS UploadStart");
						nameText.text = "名称："+name;
						Util.shortenText(nameText,225);
						typeText.text = "格式："+fileType;
						sizeText.text = "大小："+(file.size/1024000).toFixed(1)+"MB";
						failText.visible =false;
						yellow.width = 1;
						cancelLoad.visible = true;
						continueUpload.visible = false;
						startUpload();
						date = new Date();
						obj["code"] = 1;
						button.visible = false;
						sprite.visible = true;
					}
				}
				JSBridge.addCall("UploadStart",obj);
			} 
			catch(error:Error) 
			{
//				Debugger.log(Debugger.WARNING, "error = "+error, error.message + error.getStackTrace());
			}
			
			
			
			
			
		} 
		/** 
		 *  上传开始
		 * 
		 */	
		private function startUpload() : void { 
			
//			Debugger.log(Debugger.INFO, "startUpload");
			var request : URLRequest = new URLRequest(stage.loaderInfo.parameters.upload_url);
			request.method = URLRequestMethod.POST;
			var urlVars:URLVariables = new URLVariables();
			urlVars.user_id = stage.loaderInfo.parameters.user_id;
			urlVars.tmp_id = stage.loaderInfo.parameters.tempId;
			urlVars.user_port = stage.loaderInfo.parameters.user_port;
			urlVars.user_ip = stage.loaderInfo.parameters.user_ip;
//			Debugger.log(Debugger.INFO, "tempId = "+urlVars.tmp_id  + "user_id = " + urlVars.user_id );
			
			
//			var request : URLRequest = new URLRequest("http://10.59.67.59/upload/video");
//			request.method = URLRequestMethod.POST;
//			var urlVars:URLVariables = new URLVariables();
//			urlVars.user_id = "89460700";
//			urlVars.tmp_id = "52b10f099e2ea342313717";
//			urlVars.user_port = "65147";
//			urlVars.user_ip = "10.6.211.64";
			
//			urlVars.user_id = "123";
//			urlVars.tmp_id = "123";
//			urlVars.user_port = "65147";
//			urlVars.user_ip = "10.6.211.64";
			
			request.data = urlVars;
			file.upload(request); 
		} 
		/**
		 * 进度条 
		 * @param event
		 * 
		 */		
		private function progressHandle(event : ProgressEvent) : void 
		{ 
			var time:Number = int((new Date().getTime() - date.getTime())/1000);
			var load:Number = event.bytesLoaded;
			var speed:int = load/time;
			if(speed > 1024000)
			{
				loadSpeedText.text = "上传速度："+(speed/1024000).toFixed(1)+"MB/S";
			}
			else
			{
				loadSpeedText.text = "上传速度："+(speed/1000).toFixed(1)+"K/S";
			}
			loadSize.text = "已上传："+ (event.bytesLoaded/1024000).toFixed(1)+"MB/"+(event.bytesTotal/1024000).toFixed(1)+"MB"
			leftTime.text = "剩余时间："+Util.getTimerText(int((event.bytesTotal - event.bytesLoaded)/speed));
			
			var number:Number = (event.bytesLoaded / event.bytesTotal * 100);
			
			if(number >= 99.9)
			{
				progress.text = "99.9%";
			}
			else
			{
				progress.text =  number.toFixed(1)+"%";
			}
			yellow.width = int(event.bytesLoaded / event.bytesTotal * YELLOW_WIDTH)
			
			
//			progressLabel.text = "complete " + event.bytesLoaded + " bytes";
			
//			if(event.bytesLoaded / event.bytesTotal * 100 >= 100)
//			{
//				cancelLoad.visible = false;
//			}
			
			
			
//			var fileUploadPercent : uint = event.bytesLoaded / event.bytesTotal * 100; 
//			uploadProgressBar.setProgress(fileUploadPercent, 100); 
//			uploadProgressBar.label = "Complete " + fileUploadPercent + "%"; 
		} 
		/**
		 * 上传完成 
		 * @param e
		 * 
		 */		
		private function upLoadComplete(e:DataEvent):void
		{
			cancelLoad.visible = false;
			continueUpload.visible = true;
			progress.text = "100%";
			var obj:Object = JSON.parse(e.data);
			if(obj.success  =="1")
			{
				yellow.width = YELLOW_WIDTH;
				JSBridge.addCall("UploadSuccess",obj);
			}
			else
			{
				JSBridge.addCall("UploadError",obj);
			}
			failText.htmlText = obj.data.msg;
			failText.visible =true;
			
//			Debugger.log(Debugger.INFO, "UpLoadComplete");
		}
		/**
		 * 上传完成 
		 * @param event
		 * 
		 */		
		private function completeHandle(event : Event = null) : void {
			//			var i:int = file.data.length%1000;		
			//			byteArray = new ByteArray();
			//			if(currentByte+ writeLength > file.data.length)
			//			{
			//				writeLength = file.data.length - currentByte;
			//			}
			//			byteArray.writeBytes(file.data, currentByte,writeLength);
			//			byteArray.writeBytes(file.data,0,1000000);
//			infoText.htmlText = "Upload " + file.name + " Complete!"; 
			//			uploadBtn.enabled = false; 
			//			247391
			//data值就为图片编码数据ByteArray;  
			//			request.data = byteArray;
			//			request.method = URLRequestMethod.POST;  
			//			//传输内容类型必须是下面文件流形式;  
			//			//			request.contentType = "application/octet-stream";  
			//			var str:String = MD5.hash("abcdefg");
			//			trace(str);
			////			var str:String = MD5.hash(file.data.toString());
			//			loader.addEventListener(Event.COMPLETE, completeHandler);  
			//			loader.load(request);
		}
		//		private function completeHandler(e:Event):void{  
		//			currentByte += TYPESIZE;
		//			if(currentByte >= file.data.length)
		//			{
		//				return;
		//			}
		//			completeHandle();
		//		}
		
	}
}