// Magwell Dust Cover for Mil-Spec AR-15/M16/M4 Lower Receivers
// Low-profile snap-fit design - wraps around outside of magwell

/* ========== MAGWELL DIMENSIONS ========== */
// External dimensions of the magwell (outside of receiver walls)
// These are approximate - measure your receiver for best fit
magwell_ext_width  = 29.5;   // side-to-side (mm)
magwell_ext_length = 63.5;   // front-to-back (mm)
magwell_ext_corner_radius = 3.0;

/* ========== FIT & TOLERANCE ========== */
clearance = 0.2;

/* ========== COVER SHELL ========== */
cover_wall       = 2.0;      // wall thickness of the cover
cover_height     = 8;        // low profile - just enough to snap past lip
bottom_thickness = 3.0;      // thickness of the closed bottom plate

/* ========== SNAP RIDGE ========== */
// Inward ridge on cover interior to catch receiver's magwell lip
snap_ridge_height = 1.5;     // vertical height of ridge
snap_ridge_depth  = 0.4;     // inward protrusion
snap_ridge_offset = 5.5;     // distance from bottom plate to bottom of ridge

/* ========== TEXT ========== */
text_string = "Weapons Co.";
text_size   = 6;
text_depth  = 1.0;           // embossed height on bottom face

/* ========== CALCULATED VALUES ========== */
cover_int_width  = magwell_ext_width  + 2 * clearance;
cover_int_length = magwell_ext_length + 2 * clearance;
cover_ext_width  = cover_int_width + 2 * cover_wall;
cover_ext_length = cover_int_length + 2 * cover_wall;
cover_ext_corner_radius = magwell_ext_corner_radius + cover_wall + clearance;
cover_int_corner_radius = magwell_ext_corner_radius + clearance;

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

// Cover shell - walls and bottom plate
module cover_shell() {
    difference() {
        // Outer shell
        centered_rounded_rect(cover_ext_width, cover_ext_length,
                              bottom_thickness + cover_height,
                              cover_ext_corner_radius);
        // Inner cavity (open top)
        translate([0, 0, bottom_thickness])
            centered_rounded_rect(cover_int_width, cover_int_length,
                                  cover_height + 0.1,
                                  cover_int_corner_radius);
    }
}

// Snap ridge on inside of cover walls
module snap_ridge() {
    translate([0, 0, bottom_thickness + snap_ridge_offset])
        difference() {
            centered_rounded_rect(
                cover_int_width, cover_int_length,
                snap_ridge_height,
                cover_int_corner_radius);
            translate([0, 0, -0.1])
                centered_rounded_rect(
                    cover_int_width - 2 * snap_ridge_depth,
                    cover_int_length - 2 * snap_ridge_depth,
                    snap_ridge_height + 0.2,
                    max(0.5, cover_int_corner_radius - snap_ridge_depth));
        }
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
    cover_shell();
    snap_ridge();
    bottom_text();
}

magwell_cover();
