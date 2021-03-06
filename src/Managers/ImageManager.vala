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

public class ViewR.Managers.ImageManager : Object {
    public weak Window window { get; construct; }
    public Layouts.Canvas canvas;

    private File file;
    public Gtk.Image image;
    private Gdk.Pixbuf original_pixbuf;

    public double scale;

    private const double ZOOM_MAX_THRESH = 3.0;
    private const double ZOOM_MIN_THRESH = -3.0;

    public signal void image_loaded ();

    public ImageManager (Window window) {
        Object (
            window: window
        );

        scale = 1;

        window.event_bus.open_image.connect (on_open_image);
        window.event_bus.zoom.connect (on_zoom);

        if (window != null && window.main_window != null && window.main_window.canvas != null) {
            canvas = window.main_window.canvas;
        }
    }

    private void on_open_image (File file) {
        this.file = file;
        var timer = new Timer ();

        create_pixbuf.begin ((obj, res) => {
            try {
                // Read the image from given file.
                original_pixbuf = create_pixbuf.end (res);
                image = new Gtk.Image.from_pixbuf (original_pixbuf);

                timer.stop ();
                print ("Read image in %f seconds.\n", timer.elapsed ());

                zoom_to_fit ();
                image_loaded ();
            } catch (Error e) {
                warning (e.message);
            }
        });

        if (window != null && window.main_window != null && window.main_window.canvas != null) {
            canvas = window.main_window.canvas;
        }
    }

    private async Gdk.Pixbuf create_pixbuf () throws Error {
        FileInputStream stream;

        try {
            stream = yield file.read_async ();
        } catch (Error e) {
            throw e;
        }

        try {
            var pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream);
            return pixbuf;
        } catch (Error e) {
            throw e;
        }
    }

    private void on_zoom (double new_scale) {
        if (new_scale > ZOOM_MAX_THRESH || new_scale < ZOOM_MIN_THRESH) {
            return;
        }

        int new_width = (int) (original_pixbuf.width * new_scale);
        int new_height = (int) (original_pixbuf.height * new_scale);

        var scaled_pix = original_pixbuf.scale_simple (new_width, new_height, Gdk.InterpType.BILINEAR);
        image.pixbuf = scaled_pix;

        Gtk.Allocation allocation;
        canvas.get_allocation (out allocation);
        double width = allocation.width;
        double height = allocation.height;

        canvas.vadjustment.set_value (
            (canvas.vadjustment.value + width / 2.0) + (new_scale / scale) - width / 2.0
        );

        canvas.hadjustment.set_value (
            (canvas.hadjustment.value + height / 2.0) + (new_scale / scale) - height / 2.0
        );

        scale = new_scale;
    }

    private void zoom_to_fit () {

    }
}
