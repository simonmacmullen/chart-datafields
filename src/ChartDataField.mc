// -*- mode: Javascript;-*-

using Toybox.Graphics;
using Toybox.Sensor as Sensor;
using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

var view;
var model;

enum {
    MODE_HR,
    MODE_PACE
}

class ChartDataField extends Ui.DataField {
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
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        var width = dc.getWidth();
        var height = dc.getHeight();

        var block_color;
        var label;
        if (mode == MODE_PACE) {
            block_color = Graphics.COLOR_BLUE;
            label = "PACE";
        }
        else {
            block_color = Graphics.COLOR_RED;
            label = "HR";
        }

        // TODO this is maybe just a tiny bit too ad-hoc
        if (width == 218 && height == 218) {
            // Fenix 3 full screen, copy the widget
            text(dc, 109, 15, Graphics.FONT_TINY, label);
            text(dc, 109, 45, Graphics.FONT_NUMBER_MEDIUM,
                 fmt_num(model.get_current()));
            chart.draw(dc, 23, 75, 195, 172,
                       Graphics.COLOR_BLACK, block_color, true, true);
        }
        else if (width == 205 && height == 148) {
            // Vivoactive, FR920xt, Epix full screen, copy the widget
            text(dc, 70, 25, Graphics.FONT_MEDIUM, label);
            text(dc, 120, 25, Graphics.FONT_NUMBER_MEDIUM,
                 fmt_num(model.get_current()));
            chart.draw(dc, 10, 45, 195, 120,
                       Graphics.COLOR_BLACK, block_color, true, true);
        }
        else {
            // Part of the screen
            var x1 = 10;
            var y1 = 10;
            var x2 = width - 10;
            var y2 = height - 10;
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
            
            var sz = Graphics.FONT_NUMBER_MEDIUM;
            if (y2 - y1 < 55) {
                sz = Graphics.FONT_NUMBER_MILD;
            }

            var fh = dc.getFontHeight(sz);
            if (fh == 26) {
                // Sigh, the font metrics on square vs round watches
                // are not very consistent. This is the square watch
                // case BTW.
                fh += dc.getFontHeight(Graphics.FONT_XTINY);
            }
            
            chart.draw(dc, x1, y1, x2, y2,
                       Graphics.COLOR_BLACK, block_color,
                       false, false);

            var text_center_x = (x1 + x2) / 2;
            var text_center_y = label_y + fh / 2;
            
            text_outline(dc, text_center_x, text_center_y,
                         sz, fmt_num(model.get_current()));
            
            if (model.get_min_max_interesting()) {
                text_outline(dc, text_center_x, text_center_y + fh / 2,
                             Graphics.FONT_XTINY,
                             fmt_num(model.get_min()) + "-" +
                             fmt_num(model.get_max()));
            }
            
            text(dc, (x1 + x2) / 2, label_y, Graphics.FONT_TINY, label);
        }
    }

    function fmt_num(num) {
        if (num == null) {
            return "---";
        }
        else if (mode == MODE_PACE) {
            return num.toLong() + ":" + (num * 60).toLong() % 60;
        }
        else {
            return "" + num;
        }
    }

    function text_outline(dc, x, y, font, s) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        text(dc, x-2, y, font, s);
        text(dc, x+2, y, font, s);
        text(dc, x, y-2, font, s);
        text(dc, x, y+2, font, s);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        text(dc, x, y, font, s);
    }

    function text(dc, x, y, font, s) {
        dc.drawText(x, y, font, s,
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function compute(activityInfo) {
        var val;
        if (mode == MODE_PACE) {
            if (activityInfo.currentSpeed == null or
                activityInfo.currentSpeed < 0.1) {
                val = null;
            }
            else {
                val = 16.666667 / activityInfo.currentSpeed;
            }
        }
        else {
            val = activityInfo.currentHeartRate;
        }
        model.new_value(val);
        return val;
    }
}

class ChartDataFieldApp extends App.AppBase
{
    function onStart()
    {
        return false;
    }

    function getInitialView()
    {
        return [new ChartDataField()];
    }

    function onStop()
    {
        return false;
    }
}
