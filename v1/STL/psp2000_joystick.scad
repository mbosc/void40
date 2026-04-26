// PSP-2000 style joystick module
// Dimensioned approximation from the provided reference image.
//
// Notes:
// - all units are mm
// - origin is centered on the overall top-view footprint
// - z=0 is the underside of the thin mounting/contact flange
//
// Useful later:
// - use psp2000_joystick() for the part model
// - use psp2000_joystick_envelope() for a solid cavity / keepout volume

$fn = 96;

// ---- measured from the reference image ----
overall_size = [24.0, 18.0];
main_body_size = [18.0, 18.0];
contact_zone_size = [6.0, 14.0];
mount_hole_id = 1.8;
mount_hole_od = 3.0;
flange_thickness = 1.0;  // also used for the contact zone thickness
body_height = 5.0;      // bottom flange to top of main housing
overall_height = 12.0;  // bottom flange to top of thumb cap

// ---- approximated from the same image ----
main_body_chamfer = 2.2;
contact_zone_corner_r = 1.1;
body_side_inset = 0.20;
body_top_inset = 0.65;
mount_ear_bridge_d = 1.75;

// Left contact tab windows from the top view.
contact_window_size = [2.35, 3.15];
contact_window_corner_r = 0.45;
contact_window_offset_x = -1.42;
contact_window_offsets_y = [-3.55, 3.55];

// Side metal terminal rings visible in the side view.
terminal_ring_outer = [2.2, 3.65];
terminal_ring_inner = [1.15, 2.55];
terminal_ring_corner_r = 0.22;
terminal_ring_depth = 0.60;
terminal_ring_base_z = flange_thickness + 0.12;
terminal_ring_offsets_x = [-5.10, 2.10];
terminal_center_tab_offset_x = -1.45;
terminal_center_tab_size = [1.55, 1.45];
terminal_center_tab_depth = 0.50;

shaft_d_base = 6.0;
shaft_d_top = 5.4;
shaft_height = 5.7;
cap_d = 11.8;
cap_entry_d = 10.3;
cap_overlap = 0.25;
cap_height = overall_height - body_height - shaft_height + cap_overlap;
cap_entry_height = 0.40;

// ---- derived placement ----
mount_hole_ir = mount_hole_id / 2;
mount_hole_or = mount_hole_od / 2;

// The overall 24 mm width is taken from the left contact edge to the outermost
// right mounting ear. That means the 18 x 18 body itself sits slightly left of
// the total footprint so the lower-right ear can be flush with the outside.
main_body_right_x = overall_size[0] / 2 - mount_hole_or;
main_body_left_x = main_body_right_x - main_body_size[0];
main_body_center_x = (main_body_left_x + main_body_right_x) / 2;
main_body_top_y = main_body_size[1] / 2;
main_body_bottom_y = -main_body_size[1] / 2;

contact_zone_left_x = -overall_size[0] / 2;
contact_zone_center_x = contact_zone_left_x + contact_zone_size[0] / 2;
contact_zone_bottom_y = main_body_bottom_y;
contact_zone_center_y = contact_zone_bottom_y + contact_zone_size[1] / 2;
contact_window_center_x = contact_zone_center_x + contact_window_offset_x;

// User-corrected ear placement:
// - upper/right ear: the 1.8 mm inner hole is flush to the inside corner of the 18 x 18 body
// - lower/right ear: the outer 3 mm loop touches the body's bottom edge with its
//   lowest point, while the 1.8 mm inner hole stays flush outside on the right side
mount_ear_centers = [
    [main_body_right_x - mount_hole_ir, main_body_top_y - mount_hole_ir],
    [main_body_right_x + mount_hole_ir, main_body_bottom_y + mount_hole_or]
];

mount_ear_bridge_centers = [
    [main_body_right_x - 0.95, main_body_top_y - 1.80],
    [main_body_right_x - 1.20, main_body_bottom_y + 1.20]
];

stick_center = [main_body_center_x, 0];
terminal_ring_attach_y = -main_body_size[1] / 2 + 0.45;
terminal_ring_x_positions = [for (dx = terminal_ring_offsets_x) main_body_center_x + dx];
terminal_center_tab_x = main_body_center_x + terminal_center_tab_offset_x;

module rounded_rect_2d(size = [10, 10], r = 1) {
    if (r <= 0)
        square(size, center = true);
    else
        hull()
            for (sx = [-1, 1])
                for (sy = [-1, 1])
                    translate([
                        sx * max(size[0] / 2 - r, 0),
                        sy * max(size[1] / 2 - r, 0)
                    ])
                        circle(r = r);
}

module chamfer_rect_2d(size = [10, 10], chamfer = 1) {
    sx = size[0] / 2;
    sy = size[1] / 2;
    c = min(chamfer, min(sx, sy));

    polygon([
        [-sx + c, -sy],
        [ sx - c, -sy],
        [ sx, -sy + c],
        [ sx,  sy - c],
        [ sx - c,  sy],
        [-sx + c,  sy],
        [-sx,  sy - c],
        [-sx, -sy + c]
    ]);
}

module main_body_outline_2d() {
    translate([main_body_center_x, 0])
        chamfer_rect_2d(main_body_size, main_body_chamfer);
}

module contact_zone_outline_2d() {
    translate([contact_zone_center_x, contact_zone_center_y])
        rounded_rect_2d(contact_zone_size, contact_zone_corner_r);
}

module raw_flange_2d() {
    union() {
        main_body_outline_2d();
        contact_zone_outline_2d();

        for (i = [0 : len(mount_ear_centers) - 1]) {
            hull() {
                translate(mount_ear_centers[i])
                    circle(d = mount_hole_od);

                translate(mount_ear_bridge_centers[i])
                    circle(d = mount_ear_bridge_d);
            }
        }
    }
}

module mounting_holes_2d() {
    for (p = mount_ear_centers)
        translate(p)
            circle(d = mount_hole_id);
}

module contact_windows_2d() {
    for (dy = contact_window_offsets_y)
        translate([contact_window_center_x, contact_zone_center_y + dy])
            rounded_rect_2d(contact_window_size, contact_window_corner_r);
}

module main_body_2d(delta = 0) {
    offset(delta = delta)
        main_body_outline_2d();
}

module flange_2d(delta = 0) {
    offset(delta = delta)
        raw_flange_2d();
}

module terminal_ring_profile_2d() {
    difference() {
        rounded_rect_2d(terminal_ring_outer, terminal_ring_corner_r);
        rounded_rect_2d(terminal_ring_inner, terminal_ring_corner_r * 0.9);
    }
}

module south_side_terminal_rings() {
    for (x = terminal_ring_x_positions)
        translate([x, terminal_ring_attach_y, terminal_ring_base_z + terminal_ring_outer[1] / 2])
            rotate([90, 0, 0])
                linear_extrude(height = terminal_ring_depth)
                    terminal_ring_profile_2d();

    // Small center tab visible between the two rings in the side reference.
    translate([
        terminal_center_tab_x,
        terminal_ring_attach_y,
        flange_thickness + terminal_center_tab_size[1] / 2
    ])
        rotate([90, 0, 0])
            linear_extrude(height = terminal_center_tab_depth)
                polygon([
                    [-terminal_center_tab_size[0] / 2, -terminal_center_tab_size[1] / 2],
                    [ terminal_center_tab_size[0] / 2, -terminal_center_tab_size[1] / 2],
                    [ terminal_center_tab_size[0] * 0.38,  terminal_center_tab_size[1] / 2],
                    [-terminal_center_tab_size[0] * 0.38,  terminal_center_tab_size[1] / 2]
                ]);
}

module thumb_cap() {
    union() {
        cylinder(h = cap_entry_height, d1 = cap_entry_d, d2 = cap_d);
        translate([0, 0, cap_entry_height])
            cylinder(h = cap_height - cap_entry_height, d = cap_d);
    }
}

function psp2000_joystick_stick_center() = stick_center;
function psp2000_joystick_mount_ear_centers() = mount_ear_centers;
function psp2000_joystick_body_height() = body_height;
function psp2000_joystick_flange_thickness() = flange_thickness;
function psp2000_joystick_overall_height() = overall_height;

module psp2000_joystick_body_envelope(xy_clearance = 0.0, z_clearance = 0.0) {
    // Hidden mechanical keepout for the module body/contact flange only.
    // This intentionally excludes the stick shaft/cap because those are handled
    // by the top faceplate aperture.
    union() {
        linear_extrude(height = flange_thickness + z_clearance)
            flange_2d(delta = xy_clearance);

        translate([0, 0, flange_thickness])
            linear_extrude(height = body_height - flange_thickness + z_clearance)
                main_body_2d(delta = xy_clearance);

        // Side terminal keepout.
        for (x = terminal_ring_x_positions)
            translate([x, terminal_ring_attach_y - terminal_ring_depth + xy_clearance, terminal_ring_base_z])
                cube([
                    terminal_ring_outer[0] + 2 * xy_clearance,
                    terminal_ring_depth + xy_clearance,
                    terminal_ring_outer[1] + z_clearance
                ], center = false);

        translate([
            terminal_center_tab_x - terminal_center_tab_size[0] / 2 - xy_clearance,
            terminal_ring_attach_y - terminal_center_tab_depth + xy_clearance,
            flange_thickness
        ])
            cube([
                terminal_center_tab_size[0] + 2 * xy_clearance,
                terminal_center_tab_depth + xy_clearance,
                terminal_center_tab_size[1] + z_clearance
            ], center = false);
    }
}

module psp2000_joystick() {
    difference() {
        union() {
            // Thin bottom flange. This includes the 1 mm tall contact tab.
            linear_extrude(height = flange_thickness)
                flange_2d();

            // Main joystick housing sits only on the 18 x 18 mm body.
            translate([0, 0, flange_thickness])
                linear_extrude(height = body_height - flange_thickness - 0.8)
                    main_body_2d(delta = -body_side_inset);

            // Upper shoulder seen in the side view.
            translate([0, 0, body_height - 0.8])
                linear_extrude(height = 0.8)
                    main_body_2d(delta = -body_top_inset);

            // Side terminal rings / tabs seen along one border in the reference.
            south_side_terminal_rings();

            // Stick shaft.
            translate([stick_center[0], stick_center[1], body_height])
                cylinder(h = shaft_height, d1 = shaft_d_base, d2 = shaft_d_top);

            // Thumb cap, overlapped slightly into the shaft so the exported
            // mesh is a single stitched solid shell.
            translate([stick_center[0], stick_center[1], body_height + shaft_height - cap_overlap])
                thumb_cap();
        }

        // Mounting holes in the right ears.
        translate([0, 0, -0.01])
            linear_extrude(height = flange_thickness + 0.02)
                mounting_holes_2d();

        // Contact windows in the left 1 mm contact zone.
        translate([0, 0, -0.01])
            linear_extrude(height = flange_thickness + 0.02)
                contact_windows_2d();
    }
}

module psp2000_joystick_envelope(xy_clearance = 0.0, z_clearance = 0.0) {
    // Solid keepout version with the mounting holes and contact windows filled.
    union() {
        linear_extrude(height = flange_thickness + z_clearance)
            flange_2d(delta = xy_clearance);

        translate([0, 0, flange_thickness])
            linear_extrude(height = body_height - flange_thickness + z_clearance)
                main_body_2d(delta = xy_clearance);

        // Side terminal keepout.
        for (x = terminal_ring_x_positions)
            translate([x, terminal_ring_attach_y - terminal_ring_depth + xy_clearance, terminal_ring_base_z])
                cube([
                    terminal_ring_outer[0] + 2 * xy_clearance,
                    terminal_ring_depth + xy_clearance,
                    terminal_ring_outer[1] + z_clearance
                ], center = false);

        translate([
            terminal_center_tab_x - terminal_center_tab_size[0] / 2 - xy_clearance,
            terminal_ring_attach_y - terminal_center_tab_depth + xy_clearance,
            flange_thickness
        ])
            cube([
                terminal_center_tab_size[0] + 2 * xy_clearance,
                terminal_center_tab_depth + xy_clearance,
                terminal_center_tab_size[1] + z_clearance
            ], center = false);

        translate([stick_center[0], stick_center[1], body_height])
            cylinder(h = shaft_height + cap_height + z_clearance, d = cap_d + 2 * xy_clearance);
    }
}

// Default render: the joystick itself.
psp2000_joystick();
