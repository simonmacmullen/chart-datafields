// -*- mode: Javascript;-*-

class Mode extends BaseMode {
    function configure() {
        // label, color, min vertical range, ignore SD
        return ["CAD", Graphics.COLOR_YELLOW, 10, null];
    }

    function compute(activityInfo) {
        return activityInfo.currentCadence;
    }
}

var mode = new Mode();
