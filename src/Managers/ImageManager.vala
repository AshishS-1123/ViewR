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

    private File file;
    private Gdk.Pixbuf pixbuf;

    public ImageManager (Window window) {
        Object (
            window: window
        );

        window.event_bus.open_image.connect (on_open_image);
    }

    private void on_open_image (File file) {
        this.file = file;

        create_pixbuf.begin ((obj, res) => {
            try {
                pixbuf = create_pixbuf.end (res);
                print("got pixbuf\n");
            } catch (Error e) {
                warning (e.message);
            }

        });
    }

    public async Gdk.Pixbuf create_pixbuf () throws Error {
        FileInputStream stream;

        try {
            stream = yield file.read_async ();
        } catch (Error e) {
            throw e;
        }

        try {
            pixbuf = yield new Gdk.Pixbuf.from_stream_async (stream);
            return pixbuf;
        } catch (Error e) {
            throw e;
        }
    }
 }