/* NmTimer */

import com.apple.cocoa.foundation.*;
import com.apple.cocoa.application.*;
import java.util.*;

public class NmTimer extends NSObject {

	public NSTextFieldCell years;
	public NSTextFieldCell weeks;
	public NSTextFieldCell days;
	public NSTextFieldCell hours;
	public NSTextFieldCell minutes;
	public NSTextFieldCell seconds;
	
	private NSTimer timer;

    public void testit(Object sender) { /* IBAction */
		updateTimer();
	}
	public void updateTimer()
	{
		//String date = new java.util.Date().toString();
		//display.setStringValue(computeTime());
	}
	
	public void awakeFromNib()
	{
		startTimer();
		setTime();
	}


	public void startTimer()
	{
		timer = new NSTimer(1, this, new NSSelector("check",  new Class[] {this.getClass()}), this, true);
		NSRunLoop.currentRunLoop().addTimerForMode(timer, NSRunLoop.DefaultRunLoopMode);
	}
	
	public void check(NSTimer a)
	{
		setTime();
	}

	public void setTime()
	{
		int yrs;
		int mnths;
		int wks;
		int dys;
		int hrs;
		int mins;
		int secs;
		Calendar now = GregorianCalendar.getInstance();
		GregorianCalendar nm = new GregorianCalendar();
		GregorianCalendar diff = new GregorianCalendar();
		nm.set(2007, 8, 15, 17, 0, 0);
		//Calendar diff = Calendar.getInstance();
		long t = nm.getTime().getTime() - now.getTime().getTime();
		//diff.setTimeInMillis(nm.getTimeInMillis()-now.getTimeInMillis());
		yrs = nm.get(Calendar.YEAR) - now.get(Calendar.YEAR);
		mnths = nm.get(Calendar.MONTH) - now.get(Calendar.MONTH);
		wks =  nm.get(Calendar.WEEK_OF_YEAR) - now.get(Calendar.WEEK_OF_YEAR);
		dys =  nm.get(Calendar.DAY_OF_WEEK) - now.get(Calendar.DAY_OF_WEEK);
		hrs =  nm.get(Calendar.HOUR_OF_DAY) - now.get(Calendar.HOUR_OF_DAY);
		mins = nm.get(Calendar.MINUTE) - now.get(Calendar.MINUTE);
		secs = nm.get(Calendar.SECOND) - now.get(Calendar.SECOND);
		
		if(secs < 0)
		{
			secs += 60;
			mins -= 1;
		}
		
		if(mins < 0)
		{
			mins += 60;
			hrs -= 1;
		}
		
		if(hrs < 0)
		{
			hrs += 24;
			dys -= 1;
		}
		
		if(dys < 0)
		{
			dys += 7;
			wks -= 1;
		}
		
		if(wks < 0)
		{
			wks += 52;
			yrs -= 1;
		}
		
		years.setStringValue(Integer.toString(yrs));
		weeks.setStringValue(Integer.toString(wks));
		days.setStringValue(Integer.toString(dys));
		hours.setStringValue(Integer.toString(hrs));
		minutes.setStringValue(Integer.toString(mins));
		seconds.setStringValue(Integer.toString(secs));

		
	}


}