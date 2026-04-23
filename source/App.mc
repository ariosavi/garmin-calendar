import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Graphics;
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

  // Returns the current Gregorian date as a string in "year<sep>mm<sep>dd" format.
  function getGregorianDateStr() {
    var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var monthStr =
      today.month < 10 ? "0" + today.month.toString() : today.month.toString();
    var dayStr =
      today.day < 10 ? "0" + today.day.toString() : today.day.toString();

    var sep = getDateSeparator();
    var gregorianStr = today.year.toString() + sep + monthStr + sep + dayStr;
    return gregorianStr;
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

  // Returns the user-selected date color.
  // 0 => COLOR_WHITE, 1 => COLOR_RED, 2 => COLOR_BLUE,
  // 3 => COLOR_GREEN, 4 => COLOR_YELLOW, 5 => COLOR_ORANGE,
  // 6 => COLOR_PURPLE, 7 => COLOR_PINK, 8 => COLOR_CYAN,
  // 9 => COLOR_LT_GRAY
  function getDateColor() as Number {
    var colorMode = Properties.getValue("dateColor");
    if (colorMode == 1 || colorMode == "1" || colorMode == 1.0) {
      return Graphics.COLOR_RED;
    }
    if (colorMode == 2 || colorMode == "2" || colorMode == 2.0) {
      return Graphics.COLOR_BLUE;
    }
    if (colorMode == 3 || colorMode == "3" || colorMode == 3.0) {
      return Graphics.COLOR_GREEN;
    }
    if (colorMode == 4 || colorMode == "4" || colorMode == 4.0) {
      return Graphics.COLOR_YELLOW;
    }
    if (colorMode == 5 || colorMode == "5" || colorMode == 5.0) {
      return Graphics.COLOR_ORANGE;
    }
    if (colorMode == 6 || colorMode == "6" || colorMode == 6.0) {
      return Graphics.COLOR_PURPLE;
    }
    if (colorMode == 7 || colorMode == "7" || colorMode == 7.0) {
      return Graphics.COLOR_PINK;
    }
    if (colorMode == 8 || colorMode == "8" || colorMode == 8.0) {
      return Graphics.COLOR_DK_BLUE;
    }
    if (colorMode == 9 || colorMode == "9" || colorMode == 9.0) {
      return Graphics.COLOR_LT_GRAY;
    }
    // Default to white.
    return Graphics.COLOR_WHITE;
  }
}

// Returns the current instance of CalendarApp.
function getApp() as CalendarApp {
  return Application.getApp() as CalendarApp;
}