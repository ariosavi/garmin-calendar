import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;

(:glance)
class CalendarApp extends Application.AppBase {
  // Called when the application initializes
  function initialize() {
    AppBase.initialize();
  }

  // Called on application startup
  function onStart(state as Dictionary?) as Void {}

  // Called when the application is exiting
  function onStop(state as Dictionary?) as Void {}

  // Returns the initial view of the application
  function getInitialView() as [Views] or [Views, InputDelegates] {
    var view = new CalendarView();
    var delegate = new CalendarDelegate(view);

    return [
      view,
      delegate
    ];
  }

  // Returns the glance view of the application
  function getGlanceView() {
    return [new CalendarGlanceView()];
  }

  // Returns the current Gregorian date as a string based on the selected format and separator.
  function getGregorianDateStr() {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var monthStr =
      today.month < 10 ? "0" + today.month.toString() : today.month.toString();
    var dayStr =
      today.day < 10 ? "0" + today.day.toString() : today.day.toString();
    var yearStr = today.year.toString();

    var sep = getDateSeparator();
    var format = getDateFormat();

    var dateStr;
    if (format == 1) {
      // European: dd/mm/yyyy
      dateStr = dayStr + sep + monthStr + sep + yearStr;
    } else if (format == 2) {
      // US: mm/dd/yyyy
      dateStr = monthStr + sep + dayStr + sep + yearStr;
    } else {
      // ISO (default): yyyy/mm/dd
      dateStr = yearStr + sep + monthStr + sep + dayStr;
    }
    return dateStr;
  }

  // Returns the user-selected date format.
  // 0 => ISO (yyyy/mm/dd), 1 => European (dd/mm/yyyy), 2 => US (mm/dd/yyyy)
  function getDateFormat() as Number {
    var fmt = Properties.getValue("dateFormat");
    if (fmt == 1 || fmt == "1" || fmt == 1.0) {
      return 1;
    }
    if (fmt == 2 || fmt == "2" || fmt == 2.0) {
      return 2;
    }
    // Default to ISO.
    return 0;
  }

  // Returns the user-selected date separator character.
  // 0 => "/", 1 => "-", 2 => ".", 3 => " "
  function getDateSeparator() as String {
    var sepMode = Properties.getValue("dateSeparator");
    if (sepMode == 1 || sepMode == "1" || sepMode == 1.0) {
      return "-";
    }
    if (sepMode == 2 || sepMode == "2" || sepMode == 2.0) {
      return ".";
    }
    if (sepMode == 3 || sepMode == "3" || sepMode == 3.0) {
      return " ";
    }
    // Default to slash.
    return "/";
  }
}

// Returns the current instance of CalendarApp.
function getApp() as CalendarApp {
  return Application.getApp() as CalendarApp;
}