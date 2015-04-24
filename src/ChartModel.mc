// -*- mode: Javascript;-*-

using Toybox.Math as Math;
using Toybox.System as System;
using Toybox.Application as App;

class ChartModel {
    var current = null;
    var values_size = 150;
    var values;
    var range_mult;
    var range_mult_count = 0;
    var range_mult_count_not_null = 0;
    var next = 0;

    var min;
    var max;
    var min_i;
    var max_i;
    var mean;
    var sd;

    function initialize() {
        set_range_minutes(2.5);
    }

    function get_values() {
        return values;
    }

    function get_range_minutes() {
        return (values.size() * range_mult / 60);
    }

    function set_range_minutes(range) {
        var new_mult = range * 60 / values_size;
        if (new_mult != range_mult) {
            range_mult = new_mult;
            values = new [values_size];
        }
    }

    function get_current() {
        return current;
    }

    function get_min() {
        return min;
    }

    function get_max() {
        return max;
    }

    function get_min_i() {
        return min_i;
    }

    function get_max_i() {
        return max_i;
    }

    function get_min_max_interesting() {
        return max != 0 and min != max;
    }

    function get_mean() {
        return mean;
    }

    function get_sd() {
        return sd;
    }

    function new_value(new_value) {
        current = new_value;
        if (current != null) {
            next += current;
            range_mult_count_not_null++;
        }
        range_mult_count++;
        if (range_mult_count >= range_mult) {
            for (var i = 1; i < values.size(); i++) {
                values[i-1] = values[i];
            }
            values[values.size() - 1] = range_mult_count_not_null == 0 ?
                null : (next / range_mult_count_not_null);
            next = 0;
            range_mult_count = 0;
            range_mult_count_not_null = 0;
        }

        update_stats();
    }

    function update_stats() {
        min = 999999;
        max = 0;
        min_i = 0;
        max_i = 0;

        var m = 0f;
        var s = 0f;
        var total = 0f;
        var n = 0;

        for (var i = 0; i < values.size(); i++) {
            var item = values[i];
            if (item != null) {
                // Welford
                n++;
                var m2 = m;
                m += (item - m2) / n;
                s += (item - m2) * (item - m);
                total += item;
            }
        }
        if (n == 0) {
            mean = null;
            sd = null;
        }
        else {
            mean = total / n;
            sd = Math.sqrt(s / n);
        }

        for (var i = 0; i < values.size(); i++) {
            var item = values[i];
            if (item != null) {
                if (item < min) {
                    min_i = i;
                    min = item;
                }
                
                if (item > max) {
                    max_i = i;
                    max = item;
                }
            }
        }
    }
}
