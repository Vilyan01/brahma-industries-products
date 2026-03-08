// Magwell Dust Cover for Mil-Spec AR-15/M16/M4 Lower Receivers
// Parametric design - measure your specific receiver and adjust as needed

/* ========== MAGWELL DIMENSIONS ========== */
// Internal dimensions of a mil-spec magwell opening (bottom)
// These are approximate - measure your receiver for best fit
magwell_width  = 23.2;   // side-to-side (mm)
magwell_length = 57.4;   // front-to-back (mm)
magwell_corner_radius = 2.0; // internal corner radius

/* ========== FIT & TOLERANCE ========== */
// Clearance between plug and magwell walls (per side)
// Start with 0.2mm, increase if too tight, decrease if too loose
clearance = 0.2;

/* ========== PLUG DIMENSIONS ========== */
plug_height = 20;        // how far the plug inserts into the magwell
plug_wall = 2.0;         // wall thickness (solid plug if 0)

/* ========== FLANGE (LIP) ========== */
flange_overhang = 3.0;   // how far the lip extends beyond the magwell
flange_height   = 4.0;   // thickness of the lip
flange_corner_radius = 3.0;

/* ========== PULL TAB ========== */
tab_width  = 20;
tab_length = 12;
tab_height = 3.0;
tab_corner_radius = 2.0;

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

// Main plug body (hollow shell)
module plug() {
    if (plug_wall > 0 && plug_wall < min(plug_width, plug_length) / 2) {
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
    } else {
        // Solid plug
        centered_rounded_rect(plug_width, plug_length, plug_height, magwell_corner_radius);
    }
}

// Flange / lip
module flange() {
    centered_rounded_rect(flange_width, flange_length, flange_height, flange_corner_radius);
}

// Pull tab on the bottom of the flange
module pull_tab() {
    translate([0, 0, -tab_height])
        centered_rounded_rect(tab_width, tab_length, tab_height, tab_corner_radius);
}

// Assemble
module magwell_cover() {
    // Plug extends upward from flange
    translate([0, 0, flange_height])
        plug();

    // Flange sits at the base
    flange();

    // Pull tab hangs below the flange
    pull_tab();
}

magwell_cover();
