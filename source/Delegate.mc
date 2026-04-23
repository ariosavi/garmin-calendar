using Toybox.WatchUi as Ui;

class CalendarDelegate extends Ui.InputDelegate {
    var view as CalendarView;

    function initialize(viewInstance as CalendarView) {
        Ui.InputDelegate.initialize();
        view = viewInstance;
    }
    
    // On swipe up or down, show the next or previous month
    function onSwipe(swipeEvent as Ui.SwipeEvent) {
        if (swipeEvent.getDirection() == Ui.SWIPE_UP) {
            view.showNextMonth();
        } else if (swipeEvent.getDirection() == Ui.SWIPE_DOWN) {
            view.showPreviousMonth();
        } else if (swipeEvent.getDirection() == Ui.SWIPE_RIGHT) {
            // close the view
            Ui.popView(Ui.SLIDE_LEFT);
        }
        return true;
    }

    function onKey(keyEvent as Ui.KeyEvent) {
        if (keyEvent.getKey() == Ui.KEY_UP) {
            view.showPreviousMonth();
        } else if (keyEvent.getKey() == Ui.KEY_DOWN) {
            view.showNextMonth();
        } else if (keyEvent.getKey() == Ui.KEY_ESC) {
            // minimize the view
            Ui.popView(Ui.SLIDE_LEFT);
        }
        return true;
    }
}