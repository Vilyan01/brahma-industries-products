// Magwell Dust Cover Gen 2 for Mil-Spec AR-15/M16/M4 Lower Receivers
// Plug design - retained by the magazine catch, released via mag release button

/* ========== MAGWELL DIMENSIONS ========== */
// Internal dimensions of a mil-spec magwell opening (bottom)
// These are approximate - measure your receiver for best fit
magwell_width  = 23.2;   // side-to-side (mm)
magwell_length = 57.4;   // front-to-back (mm)
magwell_corner_radius = 2.0;

/* ========== FIT & TOLERANCE ========== */
clearance = 0.2;

/* ========== PLUG DIMENSIONS ========== */
plug_height = 30;        // deep enough to reach the magazine catch
plug_wall = 2.0;         // wall thickness

/* ========== MAG CATCH NOTCH ========== */
// Notch on the left side wall for the magazine catch to engage
// Mimics the magazine catch slot on a standard AR magazine
mag_catch_offset_z = 22;   // distance from flange to bottom of notch
mag_catch_offset_y = 5;    // offset from center toward the front
mag_catch_width    = 8.5;  // width of the notch (front-to-back)
mag_catch_depth    = 3.5;  // how deep the notch cuts into the plug wall
mag_catch_height   = 4.0;  // vertical height of the notch

/* ========== FLANGE (LIP) ========== */
flange_overhang = 3.0;   // how far the lip extends beyond the magwell
flange_height   = 3.0;   // thickness of the lip
flange_corner_radius = 3.0;

/* ========== TEXT ========== */
text_string = "Weapons Co.";
text_size   = 6;
text_depth  = 1.0;       // embossed height on bottom face

/* ========== CALCULATED VALUES ========== */
plug_width  = magwell_width  - (2 * clearance);
plug_length = magwell_length - (2 * clearance);

flange_width  = magwell_width  + (2 * flange_overhang);
flange_length = magwell_length + (2 * flange_overhang);

// Rounded rectangle module
module rounded_rect(w, l, h, r) {
    hull() {
        for (x = [r, w - r])
            for (y = [r, l - r])
                translate([x, y, 0])
                    cylinder(h = h, r = r, $fn = 32);
    }
}

// Center a rounded_rect at origin
module centered_rounded_rect(w, l, h, r) {
    translate([-w/2, -l/2, 0])
        rounded_rect(w, l, h, r);
}

// Main plug body (hollow shell with mag catch notch)
module plug() {
    difference() {
        // Hollow plug shell
        difference() {
            centered_rounded_rect(plug_width, plug_length, plug_height, magwell_corner_radius);
            translate([0, 0, -0.1])
                centered_rounded_rect(
                    plug_width - 2 * plug_wall,
                    plug_length - 2 * plug_wall,
                    plug_height + 0.2,
                    max(0.5, magwell_corner_radius - plug_wall)
                );
        }

        // Magazine catch notch - cut into the left wall (+X side)
        translate([
            plug_width / 2 - mag_catch_depth,
            mag_catch_offset_y - mag_catch_width / 2,
            flange_height + mag_catch_offset_z
        ])
            cube([mag_catch_depth + 0.1, mag_catch_width, mag_catch_height]);
    }
}

// Flange / lip
module flange() {
    centered_rounded_rect(flange_width, flange_length, flange_height, flange_corner_radius);
}

// Embossed text on outside bottom face
module bottom_text() {
    translate([0, 0, -text_depth])
        mirror([1, 0, 0])
            rotate([0, 0, 90])
                linear_extrude(height = text_depth)
                    text(text_string, size = text_size,
                         halign = "center", valign = "center",
                         font = "Liberation Sans:style=Bold");
}

// Assemble
module magwell_cover() {
    // Plug extends upward from flange
    translate([0, 0, flange_height])
        plug();

    // Flange sits at the base
    flange();

    // Text on the bottom face
    bottom_text();
}

magwell_cover();
