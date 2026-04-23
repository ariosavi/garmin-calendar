using Toybox.WatchUi as Ui;
using Toybox.Time.Gregorian;
using Toybox.Time;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Math;
using Toybox.Application.Properties;

class CalendarView extends Ui.View {
    // Display properties
    var font = Gfx.FONT_XTINY;
    var lineSpacing = Gfx.getFontHeight(Gfx.FONT_XTINY) + 2;
    var centerY = 60;
    var centerX = 60;
    var xSpacing = 30;

    // Currently displayed month and year in the calendar
    var currentMonthView = 1;
    var currentYearView = 2024;
    var weekStartShift = 0; // Default Sunday

    // Initialization method (called once)
    function initialize() {
        View.initialize();
        loadWeekStartPreference();
        // Initialize calendar based on today's Gregorian date
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        currentMonthView = today.month;
        currentYearView = today.year;
    }

    // Layout setup when the view size is determined
    function onLayout(dc) {
        centerY = (dc.getHeight() / 2) - (lineSpacing / 2) - 70;
        centerX = (dc.getWidth() / 2) - (2 * Gfx.getFontHeight(font));
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() {
        // Reload setting in case user changed it from phone/app settings.
        loadWeekStartPreference();
    }

    // Called to update the display
    function onUpdate(dc) {
        // Ensure latest app setting is reflected whenever the view redraws.
        loadWeekStartPreference();
        font = Gfx.FONT_XTINY;
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Get today's Gregorian date
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var currentMonth = today.month;
        var currentYear = today.year;

        // Calculate header position
        var headerY = 8;
        var headerX = Math.round(dc.getWidth() / 2).toNumber();

        var dateColor = (new CalendarApp()).getDateColor();

        // Draw the month and year as a header at the top of the screen
        if (currentMonthView != currentMonth || currentYearView != currentYear) {
            var gregorianMonthNames = ["Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."];
            var headerText = gregorianMonthNames[currentMonthView - 1] + " " + currentYearView.toString();
            dc.setColor(dateColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(headerX, headerY, font, headerText, Gfx.TEXT_JUSTIFY_CENTER);
        } else {
            // Draw the date string as a header at the top of the screen
            var dateStr = (new CalendarApp()).getGregorianDateStr();
            dc.setColor(dateColor, Gfx.COLOR_TRANSPARENT);
            dc.drawText(headerX, headerY, font, dateStr, Gfx.TEXT_JUSTIFY_CENTER);
        }

        drawMonthTable(dc, currentMonthView, currentYearView, currentMonth, currentYear, today.day);
    }

    // Draws the calendar month table
    public function drawMonthTable(dc, viewMonth, viewYear, currentMonth, currentYear, currentDay) {
        var marginLeft = 15;
        var startX = Math.round(dc.getWidth() / 9.0) + marginLeft;
        
        // Calculate header height and bottom margin for responsive layout
        var headerHeight = 10;
        var bottomMargin = 5;
        var availableHeight = dc.getHeight() - headerHeight - bottomMargin;
        
        // Get number of days in Gregorian month
        var monthDays = get_gregorian_month_days(viewMonth, viewYear);
        
        // Get first weekday of Gregorian month
        var weekDay = get_gregorian_week_day(viewMonth, viewYear);
        
        // Convert Garmin weekday numbering (Sun=1 ... Sat=7) to Sunday-based index (Sun=0 ... Sat=6).
        // weekStartShift: 0=Sun, 1=Mon, 2=Sat
        var firstDayColumn;
        if (weekStartShift == 2) {
            // Saturday start: Sat=0, Sun=1, ... Fri=6
            firstDayColumn = (weekDay % 7);
        } else if (weekStartShift == 1) {
            // Monday start: Mon=0, Tue=1, ... Sun=6
            firstDayColumn = (weekDay + 5) % 7;
        } else {
            // Sunday start: Sun=0, Mon=1, ... Sat=6
            firstDayColumn = (weekDay - 1 + 7) % 7;
        }
        
        var weeksNeeded = Math.ceil((firstDayColumn + monthDays) / 7.0).toNumber();
        var totalHeightNeeded = (weeksNeeded + 1) * lineSpacing;
        
        // Calculate dynamic spacing to fit all content
        var ySpacing = lineSpacing;
        if (totalHeightNeeded > availableHeight) {
            ySpacing = (availableHeight - lineSpacing) / weeksNeeded;
            if (ySpacing < 1) {
                ySpacing = 1;
            }
        }
        
        // Calculate starting Y position to center vertically with available space
        var startY = Math.round((availableHeight - totalHeightNeeded) / 2.0).toNumber();
        if (startY < 5) {
            startY = 5;
        }

        // Draw weekday header
        var weekDayLabelsSun = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
        var weekDayLabelsMon = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        var weekDayLabelsSat = ['S', 'S', 'M', 'T', 'W', 'T', 'F'];
        var labels = weekStartShift == 2 ? weekDayLabelsSat : (weekStartShift == 1 ? weekDayLabelsMon : weekDayLabelsSun);
        
        var xPos = startX;
        for (var i = 0; i < 7; i++) {
            // Set color based on device dimensions
            if (dc.getWidth() == 208 && dc.getHeight() == 208) {
                dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
            }
            dc.drawText(xPos, startY, font, labels[i].toString(), Gfx.TEXT_JUSTIFY_CENTER);
            xPos += Math.round(dc.getWidth() / 9.0) + 1;
        }

        // Draw calendar days
        var dayIterator = 1;
        var yPos = startY + ySpacing;

        while (dayIterator <= monthDays) {
            xPos = startX;
            for (var i = 0; i < 7; i++) {
                if (dayIterator != 1 || firstDayColumn == i) {
                    // Check if this is today's date
                    var isToday = (viewMonth == currentMonth && viewYear == currentYear && dayIterator == currentDay);
                    
                    // Highlight the current day in blue
                    if (isToday) {
                        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
                    } else {
                        // Sunday is red for holiday.
                        var sundayColumn;
                        if (weekStartShift == 2) {
                            sundayColumn = 1;
                        } else if (weekStartShift == 1) {
                            sundayColumn = 6;
                        } else {
                            sundayColumn = 0;
                        }
                        if (i == sundayColumn) {
                            dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
                        } else {
                            dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
                        }
                    }

                    var dateText = dayIterator.toString();
                    dc.drawText(xPos, yPos, font, dateText, Gfx.TEXT_JUSTIFY_CENTER);
                    dayIterator++;
                    if (dayIterator > monthDays) {
                        break;
                    }
                }
                xPos += Math.round(dc.getWidth() / 9.0) + 1;
            }
            yPos += ySpacing;
        }
    }

    public function showPreviousMonth() {
        if (currentMonthView == 1) {
            currentMonthView = 12;
            currentYearView--;
        } else {
            currentMonthView--;
        }
        Ui.requestUpdate();
    }

    public function showNextMonth() {
        if (currentMonthView == 12) {
            currentMonthView = 1;
            currentYearView++;
        } else {
            currentMonthView++;
        }
        Ui.requestUpdate();
    }

    function onHide() {
        // Optional: Clean up resources here if needed
    }

    function loadWeekStartPreference() {
        var weekStartDay = Properties.getValue("weekStartDay");

        if (weekStartDay == 0 || weekStartDay == "0" || weekStartDay == 0.0 || weekStartDay == "Sunday") {
            weekStartShift = 0;
        } else if (weekStartDay == 1 || weekStartDay == "1" || weekStartDay == 1.0 || weekStartDay == "Monday") {
            weekStartShift = 1;
        } else if (weekStartDay == 2 || weekStartDay == "2" || weekStartDay == 2.0 || weekStartDay == "Saturday") {
            weekStartShift = 2;
        } else {
            // Default to Sunday for invalid, unset, or legacy values.
            weekStartShift = 0;
        }
    }
}

// Helper function to get the number of days in a Gregorian month
function get_gregorian_month_days(month, year) {
    var monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    
    // Check for leap year
    var isLeap = false;
    if (year % 400 == 0) {
        isLeap = true;
    } else if (year % 100 == 0) {
        isLeap = false;
    } else if (year % 4 == 0) {
        isLeap = true;
    }
    
    if (month == 2 && isLeap) {
        return 29;
    }
    
    if (month >= 1 && month <= 12) {
        return monthDays[month - 1];
    }
    return 0;
}

// Helper function to calculate the weekday of the first day of the given Gregorian month/year
function get_gregorian_week_day(month, year) {
    var options = {
        :year  => year,
        :month => month,
        :day   => 1
    };
    var date = Gregorian.moment(options);
    var firstDayInfo = Gregorian.info(date, Time.FORMAT_SHORT);
    return firstDayInfo.day_of_week;
}