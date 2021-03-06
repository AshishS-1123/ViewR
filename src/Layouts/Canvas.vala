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

public class ViewR.Layouts.Canvas : Gtk.ScrolledWindow {
    public weak Window window { get; construct; }

    public Canvas (ViewR.Window window) {
        Object (
             window: window
        );

        window.image_manager.image_loaded.connect (on_image_loaded);
    }

    construct {
        hexpand = true;
        vexpand = true;

        // Direct all events to the event manager.
        key_press_event.connect (window.event_manager.key_press_event);
        key_release_event.connect (window.event_manager.key_release_event);

        button_press_event.connect (window.event_manager.button_press_event);
        button_release_event.connect (window.event_manager.button_release_event);
        motion_notify_event.connect (window.event_manager.motion_notify_event);
    }

    private void on_image_loaded () {
        add (window.image_manager.image);
        show_all ();
    }
}
