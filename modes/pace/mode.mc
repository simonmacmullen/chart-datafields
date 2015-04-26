// -*- mode: Javascript;-*-

using Toybox.System as System;

class Mode extends BaseMode {
    function configure() {
        // label, color, min vertical range, ignore SD
        return ["PACE", Graphics.COLOR_BLUE, 60, 1];
    }

    function fmt_num(num) {
        num = -num;
        return (num / 60) + ":" + (num % 60).format("%02d");
    }

    var metres =
        (System.getDeviceSettings().paceUnits == System.UNIT_METRIC) ?
        1000 :
        1609; // Metres in a mile

    function compute(activityInfo) {
        if (activityInfo.currentSpeed == null or
            activityInfo.currentSpeed < 0.5) {
            return null;
        }
        else {
            // NB: array of ints uses much less memory than array of
            // floats - ints stored without pointers?
            // Also negativise pace to flip the chart
            return -(metres / activityInfo.currentSpeed).toNumber();
        }
    }
}

var mode = new Mode();
