/*
 * BSD 2-Clause License
 * 
 * Copyright (c) 2021, Ashish Shevale
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Authored by: Ashish Shevale <shevaleashish@gmail.com>
 */

public class ViewR.Window : Gtk.ApplicationWindow {
    public GLib.Settings settings;
    public Layouts.MainWindow main_window;

    public Window (Gtk.Application app) {
        Object (
            application: app
        );
    }

    construct {
        main_window = new ViewR.Layouts.MainWindow (this);

        set_title ("ViewR");
        set_border_width (10);
        /*
        We're going to use set_position during the first ever launch
        after that, we will use gsettings to remember the last position
        of the window and the size of the window.
        */
        set_resizable (true);

        // Lets pull some settings from our gschema file
        settings = new GLib.Settings ("com.AshishS-1123.ViewR");

        if (settings.get_boolean ("first-run")) {
            settings.set_boolean ("first-run", false);
            set_default_size (640, 480);
            set_position (Gtk.WindowPosition.CENTER);
        } else {
            // Let's move the window to the last position saved in gsettings
            move(settings.get_int("pos-x"), settings.get_int("pos-y"));
            // Let's resize the window to the last size saved in gsettings
            resize(settings.get_int("window-width"), settings.get_int("window-height"));
        }

        delete_event.connect (e => {
            return before_destroy ();
        });

        add (main_window);

        show_all ();
    }

    public bool before_destroy () {
        int width, height, x, y;
        get_size (out width, out height);
        get_position (out x, out y);

        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);
        settings.set_int ("pos-x", x);
        settings.set_int ("pos-y", y);

        return false;
    }
}