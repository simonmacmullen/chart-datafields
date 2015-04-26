// -*- mode: Javascript;-*-

using Toybox.Graphics;
using Toybox.Sensor as Sensor;
using Toybox.System as System;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;

var view;
var model;

class ChartDataField extends Ui.DataField {
    var chart;
    var block_color;
    var label;
    var range_min_size;

    function initialize()
    {
        model = new ChartModel();
        model.set_range_minutes(7.5);
        model.set_range_expand(true);
        chart = new Chart(model);
        var items = mode.configure();
        label             = items[0];
        block_color       = items[1];
        range_min_size    = items[2];
        model.set_ignore_sd(items[3]);
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

        // TODO this is maybe just a tiny bit too ad-hoc
        if (width == 218 && height == 218) {
            // Fenix 3 full screen, copy the widget
            text(dc, 109, 15, Graphics.FONT_TINY, label);
            text(dc, 109, 45, Graphics.FONT_NUMBER_MEDIUM,
                 fmt_num(model.get_current()));
            text(dc, 109, 192, Graphics.FONT_XTINY, model.get_range_label());
            chart.draw(dc, [23, 75, 195, 172],
                       Graphics.COLOR_BLACK, block_color,
                       range_min_size, true, true, false, mode);
        }
        else if (width == 205 && height == 148) {
            // Vivoactive, FR920xt, Epix full screen, copy the widget
            text(dc, 60, 25, Graphics.FONT_MEDIUM, label);
            text(dc, 120, 25, Graphics.FONT_NUMBER_MEDIUM,
                 fmt_num(model.get_current()));
            text(dc, 102, 135, Graphics.FONT_XTINY, model.get_range_label());
            chart.draw(dc, [10, 45, 195, 120],
                       Graphics.COLOR_BLACK, block_color,
                       range_min_size, true, true, false, mode);
        }
        else {
            // Part of the screen
            var x1 = 5;
            var y1 = 20;
            var x2 = width - 5;
            var y2 = height - 5;
            var label_y = 10;

            var flags = getObscurityFlags();
            if (flags == OBSCURE_LEFT) {
                x1 += 5;
            }
            else if (flags == OBSCURE_RIGHT) {
                x2 -= 5;
            }
            else if (flags == (OBSCURE_TOP | OBSCURE_LEFT)) {
                x1 += 15;
                y1 += 20;
                label_y += 20;
            }
            else if (flags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
                x2 -= 15;
                y1 += 20;
                label_y += 20;
            }
            else if (flags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
                x1 += 15;
                y1 -= 15;
                y2 -= 35;
                label_y = y2 + 10;
            }
            else if (flags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
                x2 -= 15;
                y1 -= 15;
                y2 -= 35;
                label_y = y2 + 10;
            }
            else if (flags == (OBSCURE_TOP | OBSCURE_LEFT | OBSCURE_RIGHT)) {
                if (y2 - y1 > 50) { // 2 field
                    x1 += 15;
                    x2 -= 15;
                    y1 += 10;
                    label_y += 5;
                }
                else { // 3/4 field
                    x1 += 30;
                    x2 -= 30;
                }
            }
            else if (flags == (OBSCURE_BOTTOM | OBSCURE_LEFT | OBSCURE_RIGHT)) {
                if (y2 - y1 > 50) { // 2 field
                    x1 += 15;
                    x2 -= 15;
                    y1 -= 15;
                    y2 -= 30;
                    label_y = y2 + 15;
                }
                else { // 3/4 field
                    x1 += 30;
                    x2 -= 30;
                    y1 -= 15;
                    y2 -= 20;
                    label_y = y2 + 10;
                }
            }
        
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
            text(dc, (x1 + x2) / 2, label_y, Graphics.FONT_TINY, label);
    
            var sz = Graphics.FONT_NUMBER_MEDIUM;
            if (x2 - x1 > 100) {
                var s = fmt_num(model.get_current());
                x2 -= (dc.getTextWidthInPixels(s, sz) + 5);
                dc.drawText(x2 + 5, (y1 + y2) / 2, sz, s,
                            Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            }
            
            chart.draw(dc, [x1, y1, x2, y2],
                       Graphics.COLOR_BLACK, block_color, 0,
                       true, false, true, mode);
        }
    }

    function fmt_num(num) {
        if (num == null) {
            return "---";
        }
        else {
            return mode.fmt_num(num);
        }
    }

    function text(dc, x, y, font, s) {
        dc.drawText(x, y, font, s,
                    Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function compute(activityInfo) {
        var val = mode.compute(activityInfo);
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
