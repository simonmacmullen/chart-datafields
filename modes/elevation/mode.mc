// -*- mode: Javascript;-*-

using Toybox.System as System;

class Mode extends BaseMode {
    function configure() {
        // label, color, min vertical range, ignore SD
        return ["ELEV", Graphics.COLOR_DK_GREEN, 30, null];
    }

    function get_max_range_minutes() {
        return 240;
    }

    var multiplier =
        (System.getDeviceSettings().elevationUnits == System.UNIT_METRIC) ?
        1.0 :
        3.280; // feet in a meter

    function compute(activityInfo) {
        if (activityInfo.altitude == null) {
            return null;
        }
        else {
            return (activityInfo.altitude * multiplier).toNumber();
        }
    }
}

var mode = new Mode();
