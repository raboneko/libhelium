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
// Taken from https://github.com/gka/chroma.js/blob/75ea5d8a5480c90ef1c7830003ac63c2d3a15c03/src/io/lab/lab-constants.js

/**
 * Miscellaneous constants for the Lab colorspace
 */
[CCode (gir_namespace = "He", gir_version = "1", cheader_filename = "libhelium-1.h")]
namespace He.Color.LabConstants {
    // Corresponds roughly to RGB brighter/darker
    public const double Kn = 18;

    // D65 standard referent
    public const double Xn = 0.9570855264;
    public const double Yn = 1.0114135331;
    public const double Zn = 1.1190554598;

    public const double t0 = 0.1379310345;  // 4 / 29
    public const double t1 = 0.2068965523;  // 6 / 29
    public const double t2 = 0.1284185508;  // 3  * t1 * t1
    public const double t3 = 0.0088564521;  // t1 * t1 * t1
}

/**
 * Miscellaneous color related functions
 */
[CCode (gir_namespace = "He", gir_version = "1", cheader_filename = "libhelium-1.h")]
namespace He.Color {
  public const RGBColor BLACK = {
      0.0,
      0.0,
      0.0
  };

  public const RGBColor WHITE = {
      255.0,
      255.0,
      255.0
  };
  
  // Colors used for cards or elements atop the bg when Harsh Dark Mode.
  public const RGBColor HARSH_CARD_BLACK = {
      0.0,
      0.0,
      0.0
  };

  // Colors used for cards or elements atop the bg when Medium Dark Mode.
  public const RGBColor CARD_BLACK = {
      18.0,
      18.0,
      18.0
  };
  
  // Colors used for cards or elements atop the bg when Soft Dark Mode.
  public const RGBColor SOFT_CARD_BLACK = {
      36.0,
      36.0,
      36.0
  };

  public const RGBColor CARD_WHITE = {
      255.0,
      255.0,
      255.0
  };

  public const double[] XYZ_TO_CAM16RGB = {
    0.401288, 0.650173, -0.051461,
    -0.250268, 1.204414, 0.045854,
    -0.002079, 0.048952, 0.953127,
  };
  public const double[] SRGB_TO_XYZ = {
    0.41233895, 0.35762064, 0.18051042,
    0.2126, 0.7152, 0.0722,
    0.01932141, 0.11916382, 0.95034478,
  };

  public struct RGBColor {
    public double r;
    public double g;
    public double b;
  }

  public struct XYZColor {
    public double x;
    public double y;
    public double z;
  }

  public struct LABColor {
    public double l;
    public double a;
    public double b;
  }

  public struct LCHColor {
    public double l;
    public double c;
    public double h;
  }

  public struct CAM16Color {
    public double J;
    public double a;
    public double b;
    public double C;
    public double h;
  }

  public struct HCTColor {
    public double h;
    public double c;
    public double t;
    public string a; // Keep RGB rep as string on the struct for easy lookup
  }

  // The following is adapted from:
  // https://github.com/gka/chroma.js/blob/75ea5d8a5480c90ef1c7830003ac63c2d3a15c03/src/io/lab/rgb2lab.js
  // https://github.com/gka/chroma.js/blob/75ea5d8a5480c90ef1c7830003ac63c2d3a15c03/src/io/lab/lab-constants.js
  // https://cs.github.com/gka/chroma.js/blob/cd1b3c0926c7a85cbdc3b1453b3a94006de91a92/src/io/lab/lab2rgb.js#L10

  public double rgb_value_to_xyz(double v) {
    if ((v /= 255) <= 0.04045) return v / 12.92000;
    return Math.pow((v + 0.05500) / 1.05500, 2.40000);
  }

  public double xyz_value_to_lab(double v) {
    if (v > He.Color.LabConstants.t3) return Math.pow(v, 1d / 3d);
    return v / He.Color.LabConstants.t2 + He.Color.LabConstants.t0;
  }

  public XYZColor rgb_to_xyz(RGBColor color) {
    var r = rgb_value_to_xyz(color.r);
    var g = rgb_value_to_xyz(color.g);
    var b = rgb_value_to_xyz(color.b);

    var x = xyz_value_to_lab((0.4124564 * r + 0.3575761 * g + 0.1804375 * b) / He.Color.LabConstants.Xn);
    var y = xyz_value_to_lab((0.2126729 * r + 0.7151522 * g + 0.0721750 * b) / He.Color.LabConstants.Yn);
    var z = xyz_value_to_lab((0.0193339 * r + 0.1191920 * g + 0.9503041 * b) / He.Color.LabConstants.Zn);

    XYZColor result = {
      x,
      y,
      z
    };
    
    return result;
  }

  public LABColor xyz_to_lab (XYZColor color) {
    var l = xyz_value_to_lab(color.x);
    var a = xyz_value_to_lab(color.y);
    var b = xyz_value_to_lab(color.z);

    LABColor result = {
      l,
      a,
      b
    };
    
    return result;
  }

  public LABColor rgb_to_lab(RGBColor color) {
    var xyz_color = rgb_to_xyz(color);
    var l = 116d * xyz_color.y - 16d;

    LABColor result = {
      l < 0 ? 0 : l,
      500d * (xyz_color.x - xyz_color.y),
      200d * (xyz_color.y - xyz_color.z)
    };

    return result;
  }

  public LCHColor rgb_to_lch(RGBColor color) {
    var lab_color = rgb_to_lab(color);
    
    LCHColor result = {
      lab_color.l,
      lab_color.a,
      lab_color.b
    };

    return result;
  }

  public LABColor lch_to_lab(LCHColor color) {
    var hr = color.h * 6.283185307179586 / 360.0;
    LABColor result = {
      color.l,
      color.c * Math.cos(hr),
      color.c * Math.sin(hr)
    };

    return result;
  }

  public LCHColor lab_to_lch(LABColor color) {
    LCHColor result = {
      color.l,
      Math.hypot(color.a, color.b),
      Math.atan2(color.b,color.a) * 360.0 / 6.283185307179586
    };

    return result;
  }

  public CAM16Color xyz_to_cam16 (XYZColor color) {
    var rC = 0.401288 * color.x + 0.650173 * color.y - 0.051461 * color.z;
    var gC = -0.250268 * color.x + 1.204414 * color.y + 0.045854 * color.z;
    var bC = -0.002079 * color.x + 0.048952 * color.y + 0.953127 * color.z;

    double[] xyz = {95.047, 100.0, 108.883}; // D65
    var rW = xyz[0] * 0.401288 + xyz[1] * 0.650173 + xyz[2] * -0.051461;
    var gW = xyz[0] * -0.250268 + xyz[1] * 1.204414 + xyz[2] * 0.045854;
    var bW = xyz[0] * -0.002079 + xyz[1] * 0.048952 + xyz[2] * 0.953127;

    double[] rgbD = {
      0.8860776488913249 * (100.0 / rW) + 1.0 - 0.8860776488913249,
      0.8860776488913249 * (100.0 / gW) + 1.0 - 0.8860776488913249,
      0.8860776488913249 * (100.0 / bW) + 1.0 - 0.8860776488913249,
    };

    // Discount illuminant
    var rD = rgbD[0] * rC;
    var gD = rgbD[1] * gC;
    var bD = rgbD[2] * bC;

    var rAF = Math.pow(0.5848035714321961 * Math.fabs(rD) / 100.0, 0.42);
    var gAF = Math.pow(0.5848035714321961 * Math.fabs(gD) / 100.0, 0.42);
    var bAF = Math.pow(0.5848035714321961 * Math.fabs(bD) / 100.0, 0.42);
    var rA = signum(rD) * 400.0 * rAF / (rAF + 27.13);
    var gA = signum(gD) * 400.0 * gAF / (gAF + 27.13);
    var bA = signum(bD) * 400.0 * bAF / (bAF + 27.13);

    // redness-greenness
    var a = (11.0 * rA + -12.0 * gA + bA) / 11.0;
    // yellowness-blueness
    var b = (rA + gA - 2.0 * bA) / 9.0;

    // auxiliary components
    var u = (20.0 * rA + 20.0 * gA + 21.0 * bA) / 20.0;
    var p2 = (40.0 * rA + 20.0 * gA + bA) / 20.0;

    // hue
    var hr = Math.atan2(b, a);
    var atanDegrees = hr * 180.0 / Math.PI;
    var h = atanDegrees < 0
        ? atanDegrees + 360.0
        : atanDegrees >= 360
            ? atanDegrees - 360
            : atanDegrees;

    // achromatic response to color
    var ac = p2 * 1.0003040045593807;

    // CAM16 lightness and brightness
    var J = 100.0 * Math.pow(ac / 34.866244046768664, 0.69 * 1.9272135954999579);

    var huePrime = (h < 20.14) ? h + 360 : h;
    var eHue = (1.0 / 4.0) * (Math.cos(huePrime * Math.PI / 180.0 + 2.0) + 3.8);
    var p1 = 50000.0 / 13.0 * eHue * 1 * 1.0003040045593807;
    var t = p1 * Math.sqrt(a * a + b * b) / (u + 0.305);
    var alpha = Math.pow(t, 0.9) *
        Math.pow(
            1.64 - Math.pow(0.29, 0.2),
            0.73);
    // CAM16 chroma
    var C = alpha * Math.sqrt(J / 100.0);

    CAM16Color result = {
      J,
      a,
      b,
      C,
      h
    };
    return result;
  }
  private int signum (double x) {
    return (int)(x > 0) - (int)(x < 0);
  }
  //

  public HCTColor cam16_and_lch_to_hct(CAM16Color color, LCHColor tone) {
    HCTColor result = {
      color.h,
      color.C,
      tone.l
    };

    // Now, we're not just gonna accept what comes to us via CAM16 and LCH,
    // because it generates bad HCT colors. So we're gonna test the color and
    // fix it for UI usage.

    // Test color for bad props
    // A hue between 90 and 111 is body deject-colored so we can't use it.
    // A tone more than 70 is unsuitable for UI as it's too light.
    bool hueNotPass = Math.round(result.h) >= 90.0 && Math.round(result.h) <= 111.0;
    bool toneNotPass = Math.round(result.t) <= 70.0;

    if (result.h < 0) { result.h = result.h + 360.0; }

    if (hueNotPass && toneNotPass) {
      print("THIS IS YOUR HCT VALUES FIXED:\n%f / %f / %f\n".printf(result.h, result.c, 70.0));
      return {Math.round(result.h), Math.round(result.c), 70.0, result.a}; // Fix color for UI, based on Psychology
    } else {
      print("THIS IS YOUR HCT VALUES THAT PASSED:\n%f / %f / %f\n".printf(result.h, result.c, result.t));
      return {Math.round(result.h), Math.round(result.c), Math.round(result.t), result.a};
    }
  }
  public string hct_to_hex (HCTColor a) {
    return a.a;
  }
  public HCTColor hct_blend (HCTColor a, HCTColor b) {
    var diff_deg = diff_deg(a.h, b.h);
    var rot_deg = Math.fmin(diff_deg * 0.5, 15.0);
    var output = sanitize_degrees (a.h + rot_deg * rot_dir(a.h, b.h));
    return {output, a.c, a.t};
  }
  public double sanitize_degrees (double degrees) {
    degrees = degrees % 360.0;
    if (degrees < 0) {
      degrees = degrees + 360.0;
    }
    return degrees;
  }
  public double rot_dir(double from, double to) {
    var increasingDifference = sanitize_degrees (to - from);
    return increasingDifference <= 180.0 ? 1.0 : -1.0;
  }
  public double diff_deg(double a, double b) {
    return 180.0 - Math.fabs(Math.fabs(a - b) - 180.0);
  }

  int xyz_value_to_rgb_value(double value) {
    return (int) (255 * (value <= 0.00304 ? 12.92 * value : 1.05500 * Math.pow(value, 1 / 2.4) - 0.05500));
  }

  double lab_value_to_xyz_value(double value) {
    return value > He.Color.LabConstants.t1 ? value * value * value : He.Color.LabConstants.t2 * (value - He.Color.LabConstants.t0);
  }

  public RGBColor lab_to_rgb(LABColor color) {
    var y = (color.l + 16) / 116;
    var x = (bool) Math.isnan(color.a) ? y : y + color.a / 500;
    var z = (bool) Math.isnan(color.b) ? y : y - color.b / 200;

    y = He.Color.LabConstants.Yn * lab_value_to_xyz_value(y);
    x = He.Color.LabConstants.Xn * lab_value_to_xyz_value(x);
    z = He.Color.LabConstants.Zn * lab_value_to_xyz_value(z);

    var r = xyz_value_to_rgb_value(3.2404542 * x - 1.5371385 * y - 0.4985314 * z);  // D65 -> sRGB
    var g = xyz_value_to_rgb_value(-0.9692660 * x + 1.8760108 * y + 0.0415560 * z);
    var b = xyz_value_to_rgb_value(0.0556434 * x - 0.2040259 * y + 1.0572252 * z);

    RGBColor result = {
      r.clamp(0, 255),
      g.clamp(0, 255),
      b.clamp(0, 255)
    };

    return result;
  }

  // Adapted from https://cs.github.com/Ogeon/palette/blob/d4cae1e2510205f7626e880389e5e18b45913bd4/palette/src/xyz.rs#L259
  public XYZColor lab_to_xyz(LABColor color) {
    // Recip call shows performance benefits in benchmarks for this function
    var y = (color.l + 16.0) * (1 / 116.0);
    var x = y + (color.a * 1 / 500.0);
    var z = y - (color.b * 1 / 200.0);

    // D65 white point
    XYZColor result = {
      convert(x) * 0.95047,
      convert(y) * 1.00000,
      convert(z) * 1.08883
    };

    return result;
  }

  double convert(double value) {
    var epsilon = 6.0 / 29.0;
    var kappa = 108.0 / 841.0;
    var delta = 4.0 / 29.0;
    return value > epsilon ? Math.pow(value, 3) : (value - delta) * kappa;
  }

  public LCHColor hct_to_lch(HCTColor color) {
    LCHColor lch_color_derived = {
      color.t,
      color.c,
      color.h
    };
    
    return lch_color_derived;
  }

  private string hexcode (double r, double g, double b) {
    return "#" + "%02x%02x%02x".printf (
        (uint)r,
        (uint)g,
        (uint)b
    );
  }

  public Gdk.RGBA to_gdk_rgba (RGBColor color) {
    Gdk.RGBA result = {
      (float)color.r / 255.0f,
      (float)color.g / 255.0f,
      (float)color.b / 255.0f,
      1.0f
    };

    return result;
  }

  public RGBColor from_gdk_rgba (Gdk.RGBA color) {
    RGBColor result = {
      color.red * 255,
      color.green * 255,
      color.blue * 255,
    };

    return result;
  }

  public RGBColor from_hex (string color) {
    RGBColor result = {
      uint.parse(color.substring(1, 2), 16),
      uint.parse(color.substring(3, 2), 16),
      uint.parse(color.substring(5, 2), 16),
    };

    return result;
  }
}
