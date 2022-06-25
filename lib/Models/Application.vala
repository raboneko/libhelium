/*
* Copyright (c) 2022 Fyra Labs
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 3 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*/

/**
 * An application.
 */
public class He.Application : Gtk.Application {
  private Gtk.CssProvider light = new Gtk.CssProvider ();
  private Gtk.CssProvider dark = new Gtk.CssProvider ();
  private Gtk.CssProvider accent = new Gtk.CssProvider ();
  private He.Desktop desktop = new He.Desktop ();
  
  private void init_style_providers () {
    // Setup the dark preference theme loading
    light.load_from_resource ("/co/tauos/helium/gtk.css");
    dark.load_from_resource ("/co/tauos/helium/gtk-dark.css");

    if (desktop.prefers_color_scheme == He.Desktop.ColorScheme.DARK) {
      style_provider_set_enabled (dark, true);
      style_provider_set_enabled (light, false);
    } else {
      style_provider_set_enabled (light, true);
      style_provider_set_enabled (dark, false);
    }

    style_provider_set_enabled (accent, true);

    desktop.notify["prefers-color-scheme"].connect (() => {
      if (desktop.prefers_color_scheme == He.Desktop.ColorScheme.DARK) {
        style_provider_set_enabled (dark, true);
        style_provider_set_enabled (light, false);
      } else {
        style_provider_set_enabled (light, true);
        style_provider_set_enabled (dark, false);
      }
    });
  }

  private void init_app_providers () {
    /**
     * Load the custom css of the application (if any.)
     *
     * This is useful for overriding the base theme. For example,
     * to override the default theme of the He.Application, you
     * can create a file called style.css (or style-dark.css) in the 
     * application's data folder, and gresource it. This file will
     * be loaded by the application. The file name is based on the
     * color scheme preference. For example, if the user prefers the
     * dark color scheme, the file name is style-dark.css.
     *
     * @since 1.0
     */
    var base_path = get_resource_base_path ();
    if (base_path == null) {
        return;
    }

    string base_uri = "resource://" + base_path;
    File base_file = File.new_for_uri (base_uri);
    Gtk.CssProvider base_provider = new Gtk.CssProvider ();
    
    if (base_file.get_child ("style-dark.css").query_exists (null)) {
        if (desktop.prefers_color_scheme == He.Desktop.ColorScheme.DARK) {
            init_provider_from_file (base_provider, base_file.get_child ("style-dark.css"));
        } else {
            init_provider_from_file (base_provider, base_file.get_child ("style.css"));
        }
    } else {
        warning ("Dark Styling not found. Proceeding anyway.");
    }
    
    if (base_provider != null) {
        style_provider_set_enabled (base_provider, true);
    }
  }

  private void setup_accent_color () {
    var accent_color = desktop.accent_color;
    warning ("accent color is %s", accent_color);
    var foreground = desktop.foreground;
    warning ("accent foreground is %s", foreground);

    var css = @"
      @define-color accent_bg_color $accent_color;
      @define-color accent_fg_color $foreground;
      @define-color accent_color lighten($accent_color, 1.1);
    ";
    accent.load_from_data (css.data);
    init_style_providers ();
    init_app_providers ();

    desktop.notify["accent-color"].connect (() => {
        var accent_color2 = desktop.accent_color;
        warning ("accent color is changed to %s", accent_color2);
        var foreground2 = desktop.foreground;
        warning ("accent foreground is %s", foreground2);
    
        var css2 = @"
          @define-color accent_bg_color $accent_color2;
          @define-color accent_fg_color $foreground2;
          @define-color accent_color lighten($accent_color2, 1.1);
        ";
        accent.load_from_data (css2.data);
        init_style_providers ();
        init_app_providers ();
    });
  }
  
  private void style_provider_set_enabled (Gtk.CssProvider provider, bool enabled) {
    Gdk.Display display = Gdk.Display.get_default ();

    if (display == null)
      return;

    if (enabled) {
      Gtk.StyleContext.add_provider_for_display (display, provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    } else {
      Gtk.StyleContext.remove_provider_for_display (display, provider);
    }
  }

  private void init_provider_from_file (Gtk.CssProvider provider, File file) {
    if (file.query_exists (null)) {
      provider.load_from_file (file);
    }
  }
  
  protected override void startup () {
    base.startup ();
    He.init ();
    // TODO: Enable when accents are standarized
    setup_accent_color ();
  }

  public Application(string? application_id, ApplicationFlags flags) {
    this.application_id = application_id;
    this.flags = flags;
  }
}
