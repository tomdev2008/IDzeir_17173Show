package com._17173.flash.show.base.module.guidetask.vo
{
	

	public class GuideTaskVO
	{
		public static var taskId:String;
		public static var taskStatus:String;// "OPEN" | "CLOSE" | "DONE" | "GIVE_UP" | "UNDONE",
		public static var finalAward:String;// "YES" | "ON",
		public static var masterTaskList:Array;

		public static var chatHeight:Number;
		public function GuideTaskVO()
		{
		}
		
		public static function analysis(value:Object):void
		{
			if("taskId" in value)
				taskId = value.taskId;
				if("taskStatus" in value)
					taskStatus = value.taskStatus;
					if("finalAward" in value)
						finalAward = value.finalAward;
						if("masterTaskList" in value)
							masterTaskList = value.masterTaskList as Array;
		}
	}
}