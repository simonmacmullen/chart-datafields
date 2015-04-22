// -*- mode: Javascript;-*-

using Toybox.System as System;

class Mode extends BaseMode {
    function configure() {
        return ["SPEED", Graphics.COLOR_BLUE, 60];
    }

    function fmt_num(num) {
        return (num.toFloat() / 1000).format("%.1f");
    }

    // We internally store 1000 * speed as an int, to save
    // memory. Therefore in metres / hour, or millimiles / hour
    var multiplier =
        (System.getDeviceSettings().paceUnits == System.UNIT_METRIC) ?
        3600: // Metres per hour
        5792; // Millimiles per hour, e.g. seconds per hour * miles per km

    function compute(activityInfo) {
        if (activityInfo.currentSpeed == null or
            activityInfo.currentSpeed < 0.5) {
            return null;
        }
        else {
            // NB: array of ints uses much less memory than array of
            // floats - ints stored without pointers?
            return (activityInfo.currentSpeed * multiplier).toNumber();
        }
    }
}

var mode = new Mode();
