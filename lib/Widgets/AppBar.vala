/*
* Copyright (c) 2022 Fyra Labs
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

/**
* An AppBar is the header bar of an Window. It usually provides controls to manage the window, as well as optional children for more granular control.
*/
public class He.AppBar : He.Bin {
    private Gtk.Label viewtitle_mini;
    private Gtk.Label viewtitle;
    private Gtk.Label viewsubtitle;
    private Gtk.Box top_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box title_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box subtitle_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box control_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box win_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box win2_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box sub_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
    private Gtk.Box main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    private Gtk.Box labels_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    private Gtk.WindowControls title;
    private Gtk.WindowControls sidetitle;

    /**
    * The flatness of the He.AppBar
    *
    * Deprecated for code use. Will break if set manually!
    */
    [Version (deprecated = true)]
    public bool flat;

    /**
    * The button to go back one view displayed in the AppBar.
    */
    public Gtk.Button back_button = new Gtk.Button ();

    /**
    * The button box in the AppBar, shows below and to the right side of the title, or alongside the window controls, based on scrollers.
    */
    public Gtk.Box btn_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12);

    private Gtk.Stack _stack;
    /**
    * The stack that the AppBar is associated with. This is used to determine the back button's functionality.
    */
    public Gtk.Stack stack {
        get { return this._stack; }
        set {
            this._stack = value;
        }
    }

    private Gtk.ScrolledWindow _scroller;
    private Gtk.Adjustment vadj;
    /**
    * The ScrolledWindow that the AppBar is associated with. This is used to move the view's title to the AppBar and unsetting flatness.
    */
    public Gtk.ScrolledWindow scroller {
        get { return this._scroller; }
        set {
            this._scroller = value;

            if (value != null) {
                vadj = value.get_vadjustment ();
                if (vadj.value != 0) {
                    if (viewtitle_widget != null) {
                        viewtitle_widget.set_visible (false);
                    } else {
                        viewtitle_mini.set_visible (true);
                        viewtitle_mini.label = _viewtitle_label;
                        viewtitle.set_visible (false);
                    }
                    viewsubtitle.set_visible (false);
                    sub_box.set_visible (false);
                    btn_box.unparent ();
                    title_box.append (btn_box);
                    viewtitle_mini.add_css_class ("title");
                    main_box.add_css_class ("appbar");
                    main_box.remove_css_class ("flat-appbar");
                } else {
                    if (viewtitle_widget != null) {
                        viewtitle_widget.set_visible (true);
                    } else {
                        viewtitle_mini.set_visible (false);
                        viewtitle_mini.label = null;
                        viewtitle.set_visible (true);
                    }
                    viewsubtitle.set_visible (true);
                    sub_box.set_visible (true);
                    btn_box.unparent ();
                    sub_box.append (btn_box);
                    viewtitle_mini.remove_css_class ("title");
                    main_box.add_css_class ("flat-appbar");
                    main_box.remove_css_class ("appbar");
                }
                vadj.value_changed.connect ((a) => {
                    if (a.value != 0) {
                        if (viewtitle_widget != null) {
                            viewtitle_widget.set_visible (false);
                        } else {
                            viewtitle_mini.set_visible (true);
                            viewtitle_mini.label = _viewtitle_label;
                            viewtitle.set_visible (false);
                        }
                        viewsubtitle.set_visible (false);
                        sub_box.set_visible (false);
                        btn_box.unparent ();
                        title_box.append (btn_box);
                        viewtitle_mini.add_css_class ("title");
                        main_box.add_css_class ("appbar");
                        main_box.remove_css_class ("flat-appbar");
                    } else {
                        if (viewtitle_widget != null) {
                            viewtitle_widget.set_visible (true);
                        } else {
                            viewtitle_mini.set_visible (false);
                            viewtitle_mini.label = null;
                            viewtitle.set_visible (true);
                        }
                        viewsubtitle.set_visible (true);
                        sub_box.set_visible (true);
                        btn_box.unparent ();
                        sub_box.append (btn_box);
                        viewtitle_mini.remove_css_class ("title");
                        main_box.add_css_class ("flat-appbar");
                        main_box.remove_css_class ("appbar");
                    }
                });
            } else {
                main_box.add_css_class ("flat-appbar");
                main_box.remove_css_class ("appbar");
            }
        }
    }

    private string _viewtitle_label;
    /**
    * The title to the left on the AppBar.
    */
    public string viewtitle_label {
        get { return this._viewtitle_label; }
        set {
            this._viewtitle_label = value;

            if (value != null && _viewtitle_widget == null) {
                viewtitle.label = value;
                labels_box.visible = true;
                main_box.spacing = 6;
                control_box.append (viewtitle_mini);
            } else {
                viewtitle.label = null;
                control_box.remove (viewtitle_mini);
            }
        }
    }

    private Gtk.Widget? _viewtitle_widget;
    /**
    * The title widget to the left on the AppBar. If this is set, the other title (not subtitle) props won't work, and the mini title on collapsed state won't show.
    */
    public Gtk.Widget? viewtitle_widget {
        get { return this._viewtitle_widget; }
        set {
            this._viewtitle_widget = value;

            if (value != null) {
                labels_box.visible = true;
                main_box.spacing = 6;
                labels_box.prepend (value);
            } else {
                labels_box.remove (value);
            }
        }
    }

    private string _viewsubtitle_label;
    /**
    * The subtitle to the left on the AppBar.
    */
    public string viewsubtitle_label {
        get { return this._viewsubtitle_label; }
        set {
            this._viewsubtitle_label = value;

            if (value != null) {
                viewsubtitle.label = value;
                viewsubtitle.visible = true;
                subtitle_box.set_visible (true);
                main_box.spacing = 6;
            } else {
                viewsubtitle.label = null;
                viewsubtitle.visible = false;
            }
        }
    }

    private bool _show_left_title_buttons;
    /**
    * Whether the close, minimize and maximize buttons are shown.
    */
    public bool show_left_title_buttons {
        get {
            return _show_left_title_buttons;
        }
        set {
            _show_left_title_buttons = value;

            if ((sidetitle != null) == value)
                return;

            if (!value) {
                win2_box.remove (sidetitle);
                sidetitle = null;
            } else {
                create_start_window_controls ();
            }

            update_box_visibility (win2_box);
        }
    }
    private bool _show_right_title_buttons;
    /**
    * Whether the close, minimize and maximize buttons are shown.
    */
    public bool show_right_title_buttons {
        get {
            return _show_right_title_buttons;
        }
        set {
            _show_right_title_buttons = value;

            if ((title != null) == value)
                return;

            if (!value) {
                win_box.remove (title);
                title = null;
            } else {
                create_end_window_controls ();
            }

            update_box_visibility (win_box);
        }
    }
    private void update_box_visibility (Gtk.Widget? box) {
      bool has_visible = false;
      Gtk.Widget? child;

      for (child = box.get_first_child ();
           child != null;
           child = child.get_next_sibling ()) {
        if (child.get_visible ()) {
          has_visible = true;
          break;
        }
      }

      box.set_visible (has_visible);
    }


    private string _decoration_layout;
    /**
    * The layout of the window buttons a.k.a. where to put close, maximize, minimize.
    * It is a string in the format "<left>:<right>".
    */
    public string decoration_layout {
        get {
            return _decoration_layout;
        }
        set {
            _decoration_layout = value;
        }
    }

    private bool _show_back;
    /**
    * Whether the back button is shown.
    */
    public bool show_back {
        get {
            return _show_back;
        }
        set {
            _show_back = value;
            back_button.set_visible (value);
        }
    }

    /**
    * Add a child to the AppBar, should only be used in the context of a UI or Blueprint file. There should be no need to use this method in code.
    * Please note that an AppBar should only have at most three children.
    */
    public override void add_child (Gtk.Builder builder, GLib.Object child, string? type) {
        btn_box.prepend ((Gtk.Widget)child);
        ((Gtk.Widget) child).add_css_class ("disclosure-button");
        ((Gtk.Widget) child).remove_css_class ("image-button");
        labels_box.visible = true;
        btn_box.visible = true;
        main_box.spacing = 6;
    }

    /**
    * Append a child to the AppBar.
    * Please note that an AppBar should only have at most three children.
    * @param child The child to append.
    */
    public void append (Gtk.Widget child) {
        btn_box.append (child);
        ((Gtk.Widget) child).add_css_class ("disclosure-button");
        ((Gtk.Widget) child).remove_css_class ("image-button");
        labels_box.visible = true;
        btn_box.visible = true;
        main_box.spacing = 6;
    }

    /**
    * Remove a child from the AppBar.
    * @param child The child to remove.
    *
    * @since 1.0
    */
    public void remove (Gtk.Widget child) {
        btn_box.remove (child);
    }

    private void create_start_window_controls () {
        sidetitle = new Gtk.WindowControls (Gtk.PackType.START);
        sidetitle.side = Gtk.PackType.START;
        sidetitle.valign = Gtk.Align.CENTER;
        sidetitle.decoration_layout = decoration_layout;
        sidetitle.bind_property ("empty", sidetitle, "visible", SYNC_CREATE | INVERT_BOOLEAN);
        sidetitle.bind_property ("decoration-layout", this, "decoration-layout", SYNC_CREATE);
        Signal.connect_swapped (sidetitle, "notify::visible", (Callback)update_box_visibility, win2_box);
        win2_box.prepend (sidetitle);
    }

    private void create_end_window_controls () {
        title = new Gtk.WindowControls (Gtk.PackType.END);
        title.side = Gtk.PackType.END;
        title.valign = Gtk.Align.CENTER;
        title.decoration_layout = decoration_layout;
        title.bind_property ("empty", title, "visible", SYNC_CREATE | INVERT_BOOLEAN);
        title.bind_property ("decoration-layout", this, "decoration-layout", SYNC_CREATE);
        Signal.connect_swapped (title, "notify::visible", (Callback)update_box_visibility, win_box);
        win_box.prepend (title);
    }

    /**
    * Creates a new AppBar.
    */
    public AppBar () {
        base ();
    }

    construct {
        title_box.halign = Gtk.Align.END;
        win_box.halign = Gtk.Align.END;
        win2_box.halign = Gtk.Align.START;
        create_start_window_controls ();
        create_end_window_controls ();

        back_button.set_icon_name ("go-previous-symbolic");
        back_button.set_tooltip_text ("Go Back");
        back_button.add_css_class ("flat");
        back_button.clicked.connect (() => {
            var selected_page = stack.pages.get_selection ();
            stack.pages.select_item (int.max (((int)selected_page.get_nth (0) - 1), 0), true);
        });
        control_box.append (back_button);
        control_box.halign = Gtk.Align.START;
        control_box.hexpand = true;

        viewtitle = new Gtk.Label (null);
        viewtitle.halign = Gtk.Align.START;
        viewtitle.add_css_class ("view-title");
        viewtitle.set_visible (false);

        viewsubtitle = new Gtk.Label (null);
        viewsubtitle.halign = Gtk.Align.START;
        viewsubtitle.valign = Gtk.Align.END;
        viewsubtitle.margin_bottom = 6;
        viewsubtitle.add_css_class ("view-subtitle");
        viewsubtitle.set_visible (false);

        top_box.hexpand = true;
        top_box.append (win2_box);
        top_box.append (control_box);
        top_box.append (title_box);
        top_box.append (win_box);

        subtitle_box.append (viewsubtitle);
        subtitle_box.set_visible (false);

        labels_box.homogeneous = true;
        labels_box.hexpand = true;
        labels_box.visible = false;
        labels_box.append (viewtitle);
        labels_box.append (subtitle_box);
        labels_box.margin_start = 14;

        btn_box.valign = Gtk.Align.END;
        btn_box.margin_end = 14;
        btn_box.set_visible (false);

        // Make title align with other titles if no buttons are added.
        if (btn_box.visible) {
            labels_box.margin_top = 0;
        } else {
            labels_box.margin_top = 6;
        }
        btn_box.notify["visible"].connect (() => {
            if (btn_box.visible) {
                labels_box.margin_top = 0;
            } else {
                labels_box.margin_top = 6;
            }
        });

        sub_box.append (labels_box);
        sub_box.append (btn_box);

        main_box.spacing = 0;
        main_box.append (top_box);
        main_box.append (sub_box);

        var winhandle = new Gtk.WindowHandle ();
        winhandle.set_child (main_box);
        winhandle.set_parent (this);
        winhandle.hexpand = true;

        show_left_title_buttons = true;
        show_right_title_buttons = true;
        show_back = false;
        flat = true;
        main_box.add_css_class ("flat-appbar");

        if (!show_left_title_buttons && !show_right_title_buttons) {
            top_box.margin_top = 36;
        } else {
            top_box.margin_top = 0;
        }
        notify["show-left-title-buttons"].connect (() => {
            if (!show_left_title_buttons && !show_right_title_buttons) {
                top_box.margin_top = 36;
            } else {
                top_box.margin_top = 0;
            }
        });
    }

    static construct {
        set_layout_manager_type (typeof (Gtk.BoxLayout));
    }
}
