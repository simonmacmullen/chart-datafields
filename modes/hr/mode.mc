// -*- mode: Javascript;-*-

class Mode extends BaseMode {
    function configure() {
        return ["HR", Graphics.COLOR_RED, 30];
    }

    function compute(activityInfo) {
        return activityInfo.currentHeartRate;
    }
}

var mode = new Mode();
