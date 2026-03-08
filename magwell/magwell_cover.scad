// Magwell Dust Cover for Mil-Spec AR-15/M16/M4 Lower Receivers
// Low-profile snap-fit design

/* ========== MAGWELL DIMENSIONS ========== */
// Internal dimensions of a mil-spec magwell opening (bottom)
// These are approximate - measure your receiver for best fit
magwell_width  = 23.2;   // side-to-side (mm)
magwell_length = 57.4;   // front-to-back (mm)
magwell_corner_radius = 2.0; // internal corner radius

/* ========== FIT & TOLERANCE ========== */
clearance = 0.2;

/* ========== PLUG DIMENSIONS ========== */
plug_height = 8;         // low profile - just enough to snap past receiver lip
plug_wall = 2.0;         // wall thickness (solid plug if 0)

/* ========== SNAP RIDGE ========== */
// Outward ridge on plug exterior to catch receiver's magwell lip
snap_ridge_height = 1.5;  // vertical height of ridge
snap_ridge_depth  = 0.4;  // outward protrusion past plug wall
snap_ridge_offset = 5.5;  // distance from flange top to bottom of ridge

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

// Snap ridge on plug exterior to catch receiver's magwell lip
module snap_ridge() {
    translate([0, 0, flange_height + snap_ridge_offset])
        difference() {
            centered_rounded_rect(
                plug_width + 2 * snap_ridge_depth,
                plug_length + 2 * snap_ridge_depth,
                snap_ridge_height,
                magwell_corner_radius + snap_ridge_depth
            );
            translate([0, 0, -0.1])
                centered_rounded_rect(
                    plug_width,
                    plug_length,
                    snap_ridge_height + 0.2,
                    magwell_corner_radius
                );
        }
}

// Flange / lip
module flange() {
    centered_rounded_rect(flange_width, flange_length, flange_height, flange_corner_radius);
}

// Embossed text on the bottom face
module bottom_text() {
    translate([0, 0, -text_depth])
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

    // Snap ridge on plug exterior
    snap_ridge();

    // Flange sits at the base
    flange();

    // Text on the bottom face
    bottom_text();
}

magwell_cover();
