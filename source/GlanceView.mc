import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

(:glance)
class CalendarGlanceView extends WatchUi.GlanceView {
  var gregorianText as String?;

  function initialize() {
    GlanceView.initialize();
  }

  function onLayout(dc as Graphics.Dc) as Void {
    gregorianText = getApp().getGregorianDateStr();
  }

  function onUpdate(dc as Graphics.Dc) as Void {
    var mediumTextHeight = Graphics.getFontHeight(Graphics.FONT_MEDIUM);

    if (gregorianText != null) {
      var startY = (dc.getHeight() - mediumTextHeight) / 2;

      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      dc.drawText(
          0,
          startY,
          Graphics.FONT_MEDIUM,
          getApp().getGregorianDateStr(),
          Graphics.TEXT_JUSTIFY_LEFT
      );
    }
  }
}