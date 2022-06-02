public class He.SideBar : Gtk.Box, Gtk.Buildable {
    private He.ViewTitle title_label = new He.ViewTitle();
    private He.ViewSubTitle subtitle_label = new He.ViewSubTitle();
    private Gtk.Box titlebox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    private Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);

    public string title {
        get {
            return title_label.label;
        }
        set {
            title_label.label = value;
        }
    }

    public string subtitle {
        get {
            return subtitle_label.label;
        }
        set {
            subtitle_label.label = value;
        }
    }

    public SideBar(string title, string subtitle) {
        this.title = title;
        this.subtitle = subtitle;
    }

    public void add_child (Gtk.Builder builder, GLib.Object child, string? type) {
        if (type == "titlebar") {
            titlebox.append ((Gtk.Widget) child);
        } else {
            box.append ((Gtk.Widget) child);
        }
    }

    construct {
        this.orientation = Gtk.Orientation.VERTICAL;
        this.spacing = 0;
        this.width_request = 200;
        this.hexpand = false;
        this.hexpand_set = true;

        box.margin_start = box.margin_end = 18;
        box.orientation = Gtk.Orientation.VERTICAL;

        this.append (titlebox);
        this.append (title_label);
        this.append (subtitle_label);
        this.append (box);
    }
}
