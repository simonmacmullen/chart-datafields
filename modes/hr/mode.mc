// -*- mode: Javascript;-*-

class Mode extends BaseMode {
    function configure() {
        // label, color, min vertical range, ignore SD
        return ["HR", Graphics.COLOR_RED, 30, null];
    }

    function compute(activityInfo) {
        return activityInfo.currentHeartRate;
    }
}

var mode = new Mode();
