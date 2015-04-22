// -*- mode: Javascript;-*-

class Mode extends BaseMode {
    function configure() {
        return ["CAD", Graphics.COLOR_YELLOW, 10];
    }

    function compute(activityInfo) {
        return activityInfo.currentCadence;
    }
}

var mode = new Mode();
