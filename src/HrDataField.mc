// -*- mode: Javascript;-*-

using Toybox.Graphics;
using Toybox.Sensor as Sensor;
using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

var view;
var model;

class HrDataField extends Ui.DataField {
    var chart;

    function initialize()
    {
        model = new ChartModel();
        chart = new Chart(model);
    }

    function onLayout(dc) {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    function onHide() {
    }

    //! Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        
        var x1 = 10;
        var y1 = 10;
        var x2 = width - 10;
        var y2 = height - 10;
        var axes = false;
        var label_y = 15;

        var flags = getObscurityFlags();

        if (flags == OBSCURE_LEFT) {
            x1 += 15;
        }
        else if (flags == OBSCURE_RIGHT) {
            x2 -= 15;
        }
        else if (flags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            x1 += 15;
            y1 += 25;
            label_y += 15;
        }
        else if (flags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            x2 -= 15;
            y1 += 25;
            label_y += 15;
        }
        else if (flags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            x1 += 15;
            y2 -= 25;
        }
        else if (flags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            x2 -= 15;
            y2 -= 25;
        }
        else if (flags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            x1 += 25;
            x2 -= 25;
            y1 += 20;
        }
        else if (flags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            x1 += 25;
            x2 -= 25;
            y2 -= 20;
        }
        else if (flags == (OBSCURE_TOP | OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
            axes = true;
            x1 += 25;
            x2 -= 25;
            y1 += 25;
            y2 -= 25;
        }
        
        var sz = Graphics.FONT_NUMBER_MEDIUM;
        if (y2 - y1 < 50) {
            sz = Graphics.FONT_NUMBER_MILD;
        }

        chart.draw(dc, x1, y1, x2, y2,
                   Graphics.COLOR_BLACK, Graphics.COLOR_RED,
                   Graphics.COLOR_DK_GRAY, axes);

        text_outline(dc, (x1 + x2) / 2, (y1 + y2) / 2,
                     sz, model.get_current_str());
        text(dc, (x1 + x2) / 2, label_y, Graphics.FONT_TINY, "HR");
    }

    function text_outline(dc, x, y, font, s) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        text(dc, x-1, y, font, s);
        text(dc, x+1, y, font, s);
        text(dc, x, y-1, font, s);
        text(dc, x, y+1, font, s);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        text(dc, x, y, font, s);
    }

    function text(dc, x, y, font, s) {
        dc.drawText(x, y, font, s,
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function compute(activityInfo) {
        var val = activityInfo.currentHeartRate;
        model.new_value(val);
        return val;
    }
}

class HrDataFieldApp extends App.AppBase
{
    function onStart()
    {
        return false;
    }

    function getInitialView()
    {
        return [new HrDataField()];
    }

    function onStop()
    {
        return false;
    }
}
