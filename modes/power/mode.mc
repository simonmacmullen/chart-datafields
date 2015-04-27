// -*- mode: Javascript;-*-

class Mode extends BaseMode {
    function configure() {
        // label, color, min vertical range, ignore SD
        return ["POWER", Graphics.COLOR_ORANGE, 30, null];
    }

    function compute(activityInfo) {
        return activityInfo.currentPower;
    }
}

var mode = new Mode();
