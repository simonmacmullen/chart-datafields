// -*- mode: Javascript;-*-

using Toybox.System as System;

class Mode {
    var block_color = Graphics.COLOR_BLUE;
    var label = "PACE";
    var range_min_size = 60;
    var metres = (System.getDeviceSettings().paceUnits == System.UNIT_METRIC) ?
        1000 :
        1609; // Metres in a mile

    function fmt_num(num) {
        return (num / 60) + ":" + (num % 60).format("%02d");
    }

    function compute(activityInfo) {
        if (activityInfo.currentSpeed == null or
            activityInfo.currentSpeed < 0.5) {
            return null;
        }
        else {
            // NB: array of ints uses much less memory than array of
            // floats - ints stored without pointers?
            return (metres / activityInfo.currentSpeed).toNumber();
        }
    }
}

var mode = new Mode();
