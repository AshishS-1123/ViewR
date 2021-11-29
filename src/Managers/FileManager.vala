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
 * The code has been borrowed from Akira.
 */

public class ViewR.Managers.FileManager : Object {
    public weak ViewR.Window window { get; construct; }

    private Gtk.FileChooserNative dialog;
    private Gtk.Image preview_image;

    private const int PREVIEW_SIZE = 300;
    private const int PREVIEW_PADDING = 3;

    public FileManager (ViewR.Window window) {
        Object (
            window: window
        );

        window.event_bus.open_file.connect (launch_open_file_dialog);
    }

    private void launch_open_file_dialog () {
        print("oppen file triggereed\n");
        // Initialize the dialog.
        dialog = new Gtk.FileChooserNative (
            "Choose image file", window, Gtk.FileChooserAction.OPEN, "Select", "Close");

        // Set the preview image in the file chooser dialog.
        preview_image = new Gtk.Image ();
        dialog.preview_widget = preview_image;
        dialog.update_preview.connect (on_update_preview);

        // At a time, we will only deal with one image. So, do not allow multiple files.
        dialog.select_multiple = false;

        dialog.response.connect ((response_id) => on_choose_image_response (dialog, response_id));
        dialog.show ();
    }

    // Respnsible for changing the preview image in FileChooserDialog sidebar.
    private void on_update_preview () {
        string? filename = dialog.get_preview_filename ();
        if (filename == null) {
            dialog.set_preview_widget_active (false);
            return;
        }

        // Read the image format data first.
        int width = 0;
        int height = 0;
        Gdk.PixbufFormat? format = Gdk.Pixbuf.get_file_info (filename, out width, out height);

        if (format == null) {
            dialog.set_preview_widget_active (false);
            return;
        }

        // If the image is too big, resize it.
        Gdk.Pixbuf pixbuf;
        try {
            pixbuf = new Gdk.Pixbuf.from_file_at_scale (filename, PREVIEW_SIZE, PREVIEW_SIZE, true);
        } catch (Error e) {
            dialog.set_preview_widget_active (false);
            return;
        }

        if (pixbuf == null) {
            dialog.set_preview_widget_active (false);
            return;
        }

        pixbuf = pixbuf.apply_embedded_orientation ();

        // Distribute the extra space around the image.
        int extra_space = PREVIEW_SIZE - pixbuf.width;
        int smaller_half = extra_space / 2;
        int larger_half = extra_space - smaller_half;

        // Pad the image manually and avoids rounding errors.
        preview_image.set_margin_start (PREVIEW_PADDING + smaller_half);
        preview_image.set_margin_end (PREVIEW_PADDING + larger_half);

        // Show the preview.
        preview_image.set_from_pixbuf (pixbuf);
        dialog.set_preview_widget_active (true);
    }

    private void on_choose_image_response (Gtk.FileChooserNative dialog, int response_id) {
        switch (response_id) {
            case Gtk.ResponseType.ACCEPT:
            case Gtk.ResponseType.OK:
                File file = dialog.get_files ().nth_data (0);
                window.event_bus.open_image (file);
                break;
        }

        dialog.destroy ();
    }
}

    

    
