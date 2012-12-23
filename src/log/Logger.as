package log
{
	import flash.globalization.NumberFormatter;
	import flash.utils.Timer;

	public class Logger
	{
		public static var showTime:Boolean = true;
		
		public function Logger()
		{
		}
		
		static public function info(str:String):void {
			_printMsg("Info", str);
		}
		
		static public function error(str:String):void {
			_printMsg("Error", str);
		}
		
		static private function _printMsg(msgPrefix:String, str:String):void {
			if (showTime)
				trace(msgPrefix + ": " + _getTimerString() + " " + str);
			else
				trace(msgPrefix + ": " + str);
		}
		
		static private function _getTimerString():String {
			var str:String = "";
			var date:Date = new Date();
			str += date.fullYear;
			str += "/";
			str += (date.month+1 < 10) ? "0" + (date.month+1) : (date.month+1);
			str += "/";
			str += (date.date < 10) ? "0" + date.date : date.date;
						
			str += " ";
			str += (date.hours < 10) ? "0" + date.hours : date.hours;
			str += ":";
			str += (date.minutes < 10) ? "0" + date.minutes : date.minutes;
			str += ":";
			str += (date.seconds < 10) ? "0" + date.seconds : date.seconds;
			
			return str;
		}
	}
}