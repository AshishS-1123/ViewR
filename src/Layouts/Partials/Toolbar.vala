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

public class ViewR.Layouts.Partials.Toolbar : Gtk.Box {
    public weak Window window { get; construct; }

    private Widgets.ToolbarButton open_file;
    private Widgets.ToolbarButton color_picker;

    public Toolbar (ViewR.Window window) {
        Object (
             window: window
        );
    }

    construct {
        orientation = Gtk.Orientation.VERTICAL;
        spacing = 10;
        valign = Gtk.Align.CENTER;
        vexpand = true;

        open_file = new Widgets.ToolbarButton ("Open File", "open.png");
        color_picker = new Widgets.ToolbarButton ("Pick Color", "eyedropper.png");

        open_file.clicked.connect (open_file_handler);
        color_picker.clicked.connect (color_picker_handler);

        pack_start (open_file);
        pack_start (color_picker);
    }

    private void open_file_handler () {
        window.event_bus.open_file ();
    }

    private void color_picker_handler () {
        // TODO
    }
}
