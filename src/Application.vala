public class ViewR.Application : Gtk.Application {
    public Application () {
        Object (
            application_id: "com.AshishS-1123.ViewR",
            flags: GLib.ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        ViewR.Window window = new ViewR.Window (this);

        add_window (window);
    }
}