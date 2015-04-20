// -*- mode: Javascript;-*-

class Mode {
    var block_color = Graphics.COLOR_RED;
    var label = "HR";
    var range_min_size = 30;
    function fmt_num(num) {
        return "" + num;
    }

    function compute(activityInfo) {
        return activityInfo.currentHeartRate;
    }
}

var mode = new Mode();
