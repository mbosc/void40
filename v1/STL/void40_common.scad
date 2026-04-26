use <psp2000_joystick.scad>;

// VOID40 parametric reconstruction helpers
// Derived from the two STL files in this folder.
// Top: feature-driven reconstruction from inferred primitives.
// Bottom: intentionally simplified, mod-friendly approximation.

$fn = 64;

// ---- Keyboard matrix ----
cols = 12;
rows = 4;
key_pitch = 19.05;

// MX switch plate cutout inferred from the STL:
// - lower relief section: 14.8 x 14.8 for the first 2.0 mm
// - plate section:        14.0 x 14.0 for the next 1.5 mm
switch_cutout_lower = 14.8;
switch_cutout_upper = 14.0;
switch_cutout_relief_height = 2.0;
switch_cutout_plate_height = 1.5;
plate_thickness = switch_cutout_relief_height + switch_cutout_plate_height;

// ---- Top shell ----
top_total_height = 10.0;
outer_corner_radius = 4.0;
wall_thickness = 4.0;

// Distance from the switch-hole envelope to the large upper opening.
// These values were inferred from the STL and rounded to practical CAD values.
matrix_to_opening_margin = [2.595, 2.560];

// Grow the whole case without changing the switch matrix.
// Useful when you want extra side room for mods.
case_extra = [0, 0];

// ---- Top underside reliefs / locating keys ----
underside_relief_slot_width = 2.6;
underside_relief_slot_edge_offset = 3.60;   // slot center from outer edge
underside_relief_slot_end_inset = 5.76;     // slot end inset from each side
underside_relief_height = 2.0;

corner_relief_hole_d = 2.95;
corner_relief_hole_depth = 3.0;
corner_relief_inset = [3.81, 3.77];         // center inset from outer edge

// Four internal mounting / screw features seen in the top STL.
center_mount_hole_d_bottom = 2.95;
center_mount_hole_d_top = 6.00;
center_mount_hole_straight_height = 2.0;
center_mount_hole_flare_height = plate_thickness - center_mount_hole_straight_height;
center_mount_positions = [
    [-2 * key_pitch, -1 * key_pitch],
    [ 2 * key_pitch, -1 * key_pitch],
    [-2 * key_pitch,  1 * key_pitch],
    [ 2 * key_pitch,  1 * key_pitch]
];

// ---- Optional top-side control bump ----
// Partial north-side pod for a PSP-style joystick and four extra buttons.
top_mod_bump_enabled = true;
top_mod_button_indices = [6, 7, 8, 9];   // Y U I O on the 12-column grid
top_mod_controls_y_offset = 12.0;
top_mod_bump_south_overlap = 8.0;
top_mod_bump_lower_margin_x = 16.0;
top_mod_bump_upper_margin_x = 11.0;
top_mod_bump_lower_depth = 35.0;
top_mod_bump_upper_depth = 24.0;
top_mod_bump_lower_corner_r = 6.0;
top_mod_bump_upper_corner_r = 5.0;
// Keep this as a low top-frame extension; control bodies live in the bottom.
top_mod_bump_total_height = top_total_height;
top_mod_access_opening_width_margin = 10.0;
top_mod_joystick_clearance_xy = 0.45;
top_mod_joystick_clearance_z = 0.45;
top_mod_joystick_stick_offset = [1.5, 0];
top_mod_joystick_rotation = 180;
// PSP-2000 faceplate references show a clean round/pill aperture for the
// moving nub, not the full 24 x 18 mm module/contact outline.  Keep this
// separate from the hidden mechanical/body clearance.
top_mod_joystick_aperture_d = 16.5;

// PSP joystick bottom mounting.  Option A: printed self-tapping posts.
bottom_joystick_mount_enabled = true;
bottom_joystick_mount_post_d = 4.8;
// Screw access from the exterior bottom.  The printed hole is clearance;
// the screw bites into / clamps the PSP joystick mounting ring above it.
bottom_joystick_mount_from_bottom = true;
bottom_joystick_mount_through_hole_d = 1.85;
bottom_joystick_mount_counterbore_d = 4.2;
bottom_joystick_mount_counterbore_h = 1.4;
// Legacy top-side blind pilot option, used only when from-bottom mounting is off.
bottom_joystick_mount_pilot_d = 1.45;
bottom_joystick_mount_pilot_depth = 7.0;
// Distance from the assembled top underside plane down to the joystick module's
// underside/flange plane.  This keeps the body below the top plate while the
// cap/nub rises through the circular aperture.
bottom_joystick_flange_below_top = 6.5;
bottom_joystick_body_clearance_xy = 0.60;
bottom_joystick_body_clearance_z = 0.40;
// Broad bearing plinth for the 18 x 18 mm body plus thin contact flange.
// Screws retain it; this solid plinth supports it from the bottom floor and
// locator ribs reduce XY wiggle.
bottom_joystick_support_pad_size = [27.0, 21.0];
bottom_joystick_locator_rib_h = 2.0;
bottom_joystick_locator_rib_w = 1.2;
bottom_joystick_locator_clearance = 0.65;
bottom_joystick_locator_body_size = [18.0, 18.0];

// ---- Bottom approximation ----
bottom_floor_thickness = 2.4;
bottom_wall_thickness = 3.0;

// The original bottom is angled front-to-back.
bottom_front_height = 12.0;
bottom_back_height = 19.0;

// Raw extrusion height before the side-profile slope trim.  The control bump
// extends past the original north edge, so this must grow enough for the
// sloped top plane to continue under that bump instead of leaving the rim
// floating above a flat 19 mm wall.
bottom_height = bottom_back_height
    + (top_mod_bump_enabled
        ? max(top_mod_bump_lower_depth - top_mod_bump_south_overlap, 0)
            * (bottom_back_height - bottom_front_height) / outer_size()[1]
        : 0)
    + 0.35;
bottom_rim_height = 1.8;        // locating rim that keys into the top underside reliefs
bottom_rim_embed = 0.05;        // tiny overlap into the body to avoid coincident surfaces
bottom_rim_clearance = 0.20;

bottom_post_d = 8.0;
// The original bottom uses solid posts with top-side blind pilot holes,
// not through-holes / bottom counterbores.
bottom_post_hole_d = 2.95;
bottom_post_hole_depth = 9.25;

// The original bottom's upper perimeter wall leans inward under the lip.
// Approximate that with extra inner support wedges under the upper lip.
bottom_underlip_inner_extension_lower = 0.45;
bottom_underlip_inner_extension_upper = 0.95;

// Corner bolt geometry in the original bottom is mostly perimeter wall,
// with an added inward quarter-cylinder support around each hole.
corner_bolt_enabled = true;
corner_bolt_outer_d = 5.6;
corner_bolt_collar_d = 8.4;
corner_bolt_hole_d = 2.95;
corner_bolt_counterbore_d = 5.8;
corner_bolt_counterbore_h = 2.2;
corner_underlip_gusset_enabled = false;
corner_underlip_gusset_d = 3.0;

// Arduino Pro Micro / controller lodging, inferred from the original bottom STL.
// These are anchored from the left and north case edges so they follow width changes.
controller_support_enabled = true;
controller_window_enabled = true;

controller_window_center_from_left = 42.595;

// The original STL has a two-stage port opening:
// - a larger internal cable cavity
// - a smaller rounded external slot
controller_inner_window_size = [19.78, 5.55];
controller_inner_window_bottom_z = 5.06;
controller_inner_window_center_from_north = 3.25;
controller_inner_window_depth = 2.25;
controller_inner_window_inboard_relief_depth = 0.60;

controller_outer_window_size = [9.60, 3.70];
controller_outer_window_bottom_z = 7.04;
controller_outer_window_center_from_north = 0.90;
controller_outer_window_depth = 1.80;
controller_outer_window_corner_r = 1.85;

controller_platform_height = 6.8;
controller_platform_outer_size = [22.97, 9.10];
controller_platform_outer_left_inset = 31.11;
controller_platform_outer_north_inset = 28.21;
controller_platform_notch_size = [18.58, 6.78];
controller_platform_notch_left_inset = 33.30;
controller_platform_notch_north_inset = 28.21;

controller_block_height = 5.2;
controller_block_size = [10.0, 10.0];
controller_block_left_inset = 37.64;
controller_block_north_inset = 12.28;

// Side-profile slope: the original bottom is lower at the front and taller at the rear.
bottom_side_slope_enabled = true;

// Keep the earlier generic cutout available, but disabled by default now that the
// controller port window is modeled in its proper place.
bottom_cable_cutout_enabled = false;
bottom_cable_cutout_edge = "north"; // "north", "south", "east", "west"
bottom_cable_cutout_width = 14.0;
bottom_cable_cutout_height = 6.0;
bottom_cable_cutout_corner_r = 1.5;
bottom_cable_cutout_bottom_z = 8.0;

function matrix_size() = [
    (cols - 1) * key_pitch + switch_cutout_upper,
    (rows - 1) * key_pitch + switch_cutout_upper
];

function opening_size() = [
    matrix_size()[0] + 2 * (matrix_to_opening_margin[0] + case_extra[0]),
    matrix_size()[1] + 2 * (matrix_to_opening_margin[1] + case_extra[1])
];

function outer_size() = [
    opening_size()[0] + 2 * wall_thickness,
    opening_size()[1] + 2 * wall_thickness
];

function switch_x_positions() = [for (i = [0 : cols - 1]) (i - (cols - 1) / 2) * key_pitch];
function switch_y_positions() = [for (i = [0 : rows - 1]) (i - (rows - 1) / 2) * key_pitch];

function corner_relief_pos() = [
    outer_size()[0] / 2 - corner_relief_inset[0],
    outer_size()[1] / 2 - corner_relief_inset[1]
];

function underside_relief_h_length(clearance = 0) = outer_size()[0] - 2 * underside_relief_slot_end_inset - 2 * clearance;
function underside_relief_v_length(clearance = 0) = outer_size()[1] - 2 * underside_relief_slot_end_inset - 2 * clearance;
function underside_relief_w(clearance = 0) = underside_relief_slot_width - 2 * clearance;

function bottom_inner_size() = [
    outer_size()[0] - 2 * bottom_wall_thickness,
    outer_size()[1] - 2 * bottom_wall_thickness
];

function bottom_inner_corner_radius() = max(outer_corner_radius - bottom_wall_thickness, 0);
function bottom_underlip_inner_size() = [
    outer_size()[0] - 2 * wall_thickness,
    outer_size()[1] - 2 * wall_thickness
];

function left_edge_x() = -outer_size()[0] / 2;
function right_edge_x() = outer_size()[0] / 2;
function south_edge_y() = -outer_size()[1] / 2;
function north_edge_y() = outer_size()[1] / 2;

function x_from_left(inset) = left_edge_x() + inset;
function x_from_right(inset) = right_edge_x() - inset;
function y_from_south(inset) = south_edge_y() + inset;
function y_from_north(inset) = north_edge_y() - inset;

function rect_center_from_left_north(size, left_inset, north_inset) = [
    x_from_left(left_inset + size[0] / 2),
    y_from_north(north_inset + size[1] / 2)
];

function controller_window_center() = [
    x_from_left(controller_window_center_from_left),
    north_edge_y()
];

function top_mod_button_x_positions() = [for (i = top_mod_button_indices) switch_x_positions()[i]];
function top_mod_controls_y() = north_edge_y() + top_mod_controls_y_offset;
function top_mod_joystick_center() = [
    (switch_x_positions()[4] + switch_x_positions()[5]) / 2,
    top_mod_controls_y()
];
function top_mod_all_control_xs() = concat([top_mod_joystick_center()[0]], top_mod_button_x_positions());
function top_mod_control_span_x() = max(top_mod_all_control_xs()) - min(top_mod_all_control_xs());
function top_mod_bump_x_center() = (max(top_mod_all_control_xs()) + min(top_mod_all_control_xs())) / 2;
function top_mod_bump_lower_center() = [
    top_mod_bump_x_center(),
    north_edge_y() + top_mod_bump_lower_depth / 2 - top_mod_bump_south_overlap
];
function top_mod_bump_upper_center() = [
    top_mod_bump_x_center(),
    north_edge_y() + top_mod_bump_upper_depth / 2 - top_mod_bump_south_overlap
];
function top_mod_bump_lower_size() = [
    top_mod_control_span_x() + 2 * top_mod_bump_lower_margin_x,
    top_mod_bump_lower_depth
];
function top_mod_bump_upper_size() = [
    top_mod_control_span_x() + 2 * top_mod_bump_upper_margin_x,
    top_mod_bump_upper_depth
];
function top_mod_bump_inner_lower_size(wall = wall_thickness) = [
    max(top_mod_bump_lower_size()[0] - 2 * wall, 0.01),
    max(top_mod_bump_lower_size()[1] - 2 * wall, 0.01)
];
function top_mod_bump_inner_upper_size(wall = wall_thickness) = [
    max(top_mod_bump_upper_size()[0] - 2 * wall, 0.01),
    max(top_mod_bump_upper_size()[1] - 2 * wall, 0.01)
];
function top_mod_access_opening_width() = max(
    top_mod_bump_upper_size()[0] - 2 * top_mod_access_opening_width_margin,
    8.0
);
function top_mod_joystick_origin_xy() = top_mod_joystick_center() - top_mod_joystick_stick_offset;
function top_mod_joystick_origin_z() = -0.01;
function rotate_2d(p, a) = [
    p[0] * cos(a) - p[1] * sin(a),
    p[0] * sin(a) + p[1] * cos(a)
];
function top_mod_joystick_part_xy(p) =
    top_mod_joystick_center()
    + rotate_2d(p - top_mod_joystick_stick_offset, top_mod_joystick_rotation);
function top_mod_joystick_mount_positions() = [
    for (p = psp2000_joystick_mount_ear_centers())
        top_mod_joystick_part_xy(p)
];
function bottom_joystick_mount_top_z() =
    bottom_top_surface_z(top_mod_controls_y()) - bottom_joystick_flange_below_top;
function bottom_joystick_support_pad_top_z() = bottom_joystick_mount_top_z();
function bottom_joystick_support_pad_base_z() = bottom_floor_thickness;
function bottom_joystick_support_pad_height() =
    max(bottom_joystick_support_pad_top_z() - bottom_joystick_support_pad_base_z(), 0.01);

module rounded_rect_2d(size = [10, 10], r = 0) {
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

module slot_2d(length, width, r = -1) {
    rr = (r < 0) ? width / 2 : r;
    rounded_rect_2d([length, width], rr);
}

module case_outer_2d(clearance = 0) {
    union() {
        offset(delta = clearance)
            rounded_rect_2d(outer_size(), outer_corner_radius);

        if (top_mod_bump_enabled)
            top_mod_bump_footprint_2d(clearance = clearance);
    }
}

module case_inner_2d(wall = wall_thickness, clearance = 0) {
    offset(delta = clearance)
        offset(delta = -wall)
            case_outer_2d();
}

module top_opening_2d() {
    // One rational interior offset from the combined main-rectangle + bump shell.
    // This avoids slivers where the bump and the original top wall meet.
    case_inner_2d(wall = wall_thickness);
}

module perimeter_locating_ring_2d(clearance = 0) {
    outer_inset = underside_relief_slot_edge_offset - underside_relief_slot_width / 2 + clearance;
    inner_inset = underside_relief_slot_edge_offset + underside_relief_slot_width / 2 - clearance;

    if (outer_inset < inner_inset)
        difference() {
            offset(delta = -outer_inset)
                case_outer_2d();
            offset(delta = -inner_inset)
                case_outer_2d();
        }
}

module switch_cutouts_3d() {
    for (x = switch_x_positions())
        for (y = switch_y_positions()) {
            translate([x, y, 0])
                linear_extrude(height = switch_cutout_relief_height)
                    square([switch_cutout_lower, switch_cutout_lower], center = true);

            translate([x, y, switch_cutout_relief_height])
                linear_extrude(height = switch_cutout_plate_height)
                    square([switch_cutout_upper, switch_cutout_upper], center = true);
        }
}

module center_mount_holes_3d() {
    for (p = center_mount_positions) {
        translate([p[0], p[1], 0])
            cylinder(h = center_mount_hole_straight_height, d = center_mount_hole_d_bottom);

        translate([p[0], p[1], center_mount_hole_straight_height])
            cylinder(
                h = center_mount_hole_flare_height,
                d1 = center_mount_hole_d_bottom,
                d2 = center_mount_hole_d_top
            );
    }
}

module corner_relief_holes_3d() {
    pos = corner_relief_pos();
    for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx * pos[0], sy * pos[1], 0])
                cylinder(h = corner_relief_hole_depth, d = corner_relief_hole_d);
}

module underside_relief_slots_2d(clearance = 0) {
    perimeter_locating_ring_2d(clearance = clearance);
}

module top_mod_bump_footprint_2d(clearance = 0) {
    translate(top_mod_bump_lower_center())
        rounded_rect_2d(
            top_mod_bump_lower_size() + [2 * clearance, 2 * clearance],
            top_mod_bump_lower_corner_r + clearance
        );
}

module top_mod_bump_inner_2d(wall = wall_thickness, clearance = 0) {
    translate(top_mod_bump_lower_center())
        rounded_rect_2d(
            top_mod_bump_inner_lower_size(wall) + [2 * clearance, 2 * clearance],
            max(top_mod_bump_lower_corner_r - wall, 0) + clearance
        );
}

module top_mod_bump_outer() {
    if (top_mod_bump_enabled)
        union() {
            // Low plate extension: the controls pass through this into the bottom.
            linear_extrude(height = plate_thickness)
                top_mod_bump_footprint_2d();

            // Perimeter lip/wall only; no high enclosed top-only pod.
            translate([0, 0, plate_thickness])
                linear_extrude(height = top_mod_bump_total_height - plate_thickness)
                    difference() {
                        top_mod_bump_footprint_2d();
                        top_mod_bump_inner_2d();
                    }
        }
}

module top_mod_access_opening_3d() {
    if (top_mod_bump_enabled) {
        opening_h = top_mod_bump_total_height - plate_thickness + 0.02;
        translate([
            top_mod_bump_x_center(),
            north_edge_y() + wall_thickness / 2,
            plate_thickness + opening_h / 2 - 0.01
        ])
            cube([
                top_mod_access_opening_width(),
                wall_thickness + 2 * top_mod_bump_south_overlap + 0.5,
                opening_h
            ], center = true);
    }
}

module top_mod_button_cutouts_3d() {
    if (top_mod_bump_enabled)
        for (x = top_mod_button_x_positions()) {
            translate([x, top_mod_controls_y(), 0])
                linear_extrude(height = switch_cutout_relief_height + 0.01)
                    square([switch_cutout_lower, switch_cutout_lower], center = true);

            translate([x, top_mod_controls_y(), switch_cutout_relief_height])
                linear_extrude(height = switch_cutout_plate_height + 0.01)
                    square([switch_cutout_upper, switch_cutout_upper], center = true);
        }
}

module top_mod_joystick_keepout_3d() {
    if (top_mod_bump_enabled)
        translate([
            top_mod_joystick_center()[0],
            top_mod_joystick_center()[1],
            -0.01
        ])
            cylinder(
                h = plate_thickness + 0.03,
                d = top_mod_joystick_aperture_d
            );
}

module top_outer_shell() {
    union() {
        linear_extrude(height = plate_thickness)
            case_outer_2d();

        translate([0, 0, plate_thickness])
            linear_extrude(height = top_total_height - plate_thickness)
                difference() {
                    case_outer_2d();
                    top_opening_2d();
                }
    }
}

module void40_top() {
    difference() {
        top_outer_shell();

        linear_extrude(height = underside_relief_height)
            underside_relief_slots_2d();

        switch_cutouts_3d();
        top_mod_button_cutouts_3d();
        top_mod_joystick_keepout_3d();
        center_mount_holes_3d();
        corner_relief_holes_3d();
    }
}

module bottom_shell() {
    difference() {
        linear_extrude(height = bottom_height)
            case_outer_2d();

        translate([0, 0, bottom_floor_thickness])
            linear_extrude(height = bottom_height - bottom_floor_thickness + 0.01)
                case_inner_2d(wall = wall_thickness);
    }
}

module bottom_mod_bump_shell() {
    if (top_mod_bump_enabled)
        difference() {
            linear_extrude(height = bottom_height)
                top_mod_bump_footprint_2d();

            translate([0, 0, bottom_floor_thickness])
                linear_extrude(height = bottom_height - bottom_floor_thickness + 0.01)
                    top_mod_bump_inner_2d(wall = bottom_wall_thickness);
        }
}

module bottom_mod_access_opening_3d() {
    if (top_mod_bump_enabled)
        translate([
            top_mod_bump_x_center(),
            north_edge_y() + bottom_wall_thickness / 2,
            bottom_height / 2
        ])
            cube([
                top_mod_access_opening_width(),
                bottom_wall_thickness + 2 * top_mod_bump_south_overlap + 0.5,
                bottom_height + 0.02
            ], center = true);
}

module bottom_posts() {
    for (p = center_mount_positions)
        translate([p[0], p[1], bottom_floor_thickness])
            cylinder(h = bottom_height - bottom_floor_thickness, d = bottom_post_d);
}

module bottom_underlip_support() {
    translate([0, 0, bottom_floor_thickness])
        linear_extrude(height = bottom_height - bottom_floor_thickness)
            difference() {
                case_outer_2d();
                case_inner_2d(wall = wall_thickness);
            }
}

module bottom_underlip_inner_extensions() {
    lower = bottom_underlip_inner_extension_lower;
    upper = bottom_underlip_inner_extension_upper;
    z0 = bottom_floor_thickness;
    z1 = bottom_height - 0.01;
    x_span = outer_size()[0] - 2 * wall_thickness;

    union() {
        hull() {
            translate([0, north_edge_y() - wall_thickness - lower / 2, z0])
                cube([x_span, lower, 0.01], center = true);
            translate([0, north_edge_y() - wall_thickness - upper / 2, z1])
                cube([x_span, upper, 0.01], center = true);
        }

        hull() {
            translate([0, south_edge_y() + wall_thickness + lower / 2, z0])
                cube([x_span, lower, 0.01], center = true);
            translate([0, south_edge_y() + wall_thickness + upper / 2, z1])
                cube([x_span, upper, 0.01], center = true);
        }
    }
}

function bottom_top_surface_z(y) = bottom_side_slope_enabled
    ? bottom_mid_height() + tan(bottom_tilt_angle()) * y
    : bottom_height;

module bottom_post_holes() {
    for (p = center_mount_positions) {
        hole_floor_z = max(bottom_top_surface_z(p[1]) - bottom_post_hole_depth, bottom_floor_thickness);

        translate([p[0], p[1], hole_floor_z])
            cylinder(h = bottom_height - hole_floor_z + 0.02, d = bottom_post_hole_d);
    }
}

module bottom_joystick_support_pad() {
    if (top_mod_bump_enabled && bottom_joystick_mount_enabled)
        translate([
            top_mod_joystick_center()[0],
            top_mod_joystick_center()[1],
            bottom_joystick_support_pad_base_z()
        ])
            rotate([0, 0, top_mod_joystick_rotation])
                linear_extrude(height = bottom_joystick_support_pad_height())
                    rounded_rect_2d(bottom_joystick_support_pad_size, 2.0);
}

module bottom_joystick_locator_ribs() {
    if (top_mod_bump_enabled && bottom_joystick_mount_enabled) {
        overlap = 0.08;
        rib_h = bottom_joystick_locator_rib_h + overlap;
        rib_z = bottom_joystick_mount_top_z() - overlap;
        sx = bottom_joystick_locator_body_size[0] / 2 + bottom_joystick_locator_clearance;
        sy = bottom_joystick_locator_body_size[1] / 2 + bottom_joystick_locator_clearance;
        rib_len_x = bottom_joystick_locator_body_size[0] * 0.70;
        rib_len_y = bottom_joystick_locator_body_size[1] * 0.70;

        translate([top_mod_joystick_center()[0], top_mod_joystick_center()[1], rib_z])
            rotate([0, 0, top_mod_joystick_rotation])
                union() {
                    for (y = [-sy, sy])
                        translate([0, y, rib_h / 2])
                            cube([
                                rib_len_x,
                                bottom_joystick_locator_rib_w,
                                rib_h
                            ], center = true);

                    for (x = [-sx, sx])
                        translate([x, 0, rib_h / 2])
                            cube([
                                bottom_joystick_locator_rib_w,
                                rib_len_y,
                                rib_h
                            ], center = true);
                }
    }
}

module bottom_joystick_mount_posts() {
    if (top_mod_bump_enabled && bottom_joystick_mount_enabled) {
        post_h = max(bottom_joystick_mount_top_z() - bottom_floor_thickness, 0.01);

        for (p = top_mod_joystick_mount_positions())
            translate([p[0], p[1], bottom_floor_thickness])
                cylinder(h = post_h, d = bottom_joystick_mount_post_d);
    }
}

module bottom_joystick_mount_holes() {
    if (top_mod_bump_enabled && bottom_joystick_mount_enabled) {
        if (bottom_joystick_mount_from_bottom) {
            for (p = top_mod_joystick_mount_positions()) {
                // Through clearance hole from the exterior bottom up to the
                // joystick mounting-ring plane.
                translate([p[0], p[1], -0.01])
                    cylinder(
                        h = bottom_joystick_mount_top_z() + 0.60,
                        d = bottom_joystick_mount_through_hole_d
                    );

                // Underside head relief so the screw head can sit below/near
                // flush with the bottom surface.
                translate([p[0], p[1], -0.01])
                    cylinder(
                        h = bottom_joystick_mount_counterbore_h + 0.02,
                        d = bottom_joystick_mount_counterbore_d
                    );
            }
        } else {
            hole_z0 = max(
                bottom_floor_thickness,
                bottom_joystick_mount_top_z() - bottom_joystick_mount_pilot_depth
            );
            hole_h = bottom_joystick_mount_top_z() - hole_z0 + 0.02;

            for (p = top_mod_joystick_mount_positions())
                translate([p[0], p[1], hole_z0])
                    cylinder(h = hole_h, d = bottom_joystick_mount_pilot_d);
        }
    }
}

module bottom_joystick_debug_model() {
    if (top_mod_bump_enabled && bottom_joystick_mount_enabled)
        translate([
            top_mod_joystick_center()[0],
            top_mod_joystick_center()[1],
            bottom_joystick_mount_top_z()
        ])
            rotate([0, 0, top_mod_joystick_rotation])
                translate([
                    -top_mod_joystick_stick_offset[0],
                    -top_mod_joystick_stick_offset[1],
                    0
                ])
                    psp2000_joystick();
}

module corner_bolt_posts() {
    if (corner_bolt_enabled) {
        pos = corner_relief_pos();
        for (sx = [-1, 1])
            for (sy = [-1, 1]) {
                cx = sx * pos[0];
                cy = sy * pos[1];

                linear_extrude(height = bottom_height)
                    intersection() {
                        translate([cx, cy])
                            circle(d = corner_bolt_collar_d);

                        translate([
                            cx - sx * corner_bolt_collar_d / 4,
                            cy - sy * corner_bolt_collar_d / 4
                        ])
                            square([corner_bolt_collar_d / 2, corner_bolt_collar_d / 2], center = true);
                    }
            }
    }
}

module corner_bolt_holes() {
    if (corner_bolt_enabled) {
        pos = corner_relief_pos();
        for (sx = [-1, 1])
            for (sy = [-1, 1]) {
                translate([sx * pos[0], sy * pos[1], -0.01])
                    cylinder(h = bottom_height + 0.02, d = corner_bolt_hole_d);

                translate([sx * pos[0], sy * pos[1], -0.01])
                    cylinder(h = corner_bolt_counterbore_h + 0.02, d = corner_bolt_counterbore_d);
            }
    }
}

module corner_underlip_gussets() {
    if (corner_bolt_enabled && corner_underlip_gusset_enabled) {
        pos = corner_relief_pos();
        bar_half = corner_underlip_gusset_d / 2;
        translate([0, 0, bottom_floor_thickness])
            linear_extrude(height = bottom_height - bottom_floor_thickness)
                intersection() {
                    rounded_rect_2d(outer_size(), outer_corner_radius);

                    union() {
                        for (sx = [-1, 1])
                            for (sy = [-1, 1]) {
                                px = sx * pos[0];
                                py = sy * pos[1];
                                wx = sx * (outer_size()[0] / 2 - wall_thickness / 2);
                                wy = sy * (outer_size()[1] / 2 - wall_thickness / 2);

                                translate([px, py])
                                    circle(d = corner_underlip_gusset_d);

                                translate([(px + wx) / 2, py])
                                    square([abs(wx - px) + corner_underlip_gusset_d, corner_underlip_gusset_d], center = true);

                                translate([px, (py + wy) / 2])
                                    square([corner_underlip_gusset_d, abs(wy - py) + corner_underlip_gusset_d], center = true);
                            }
                    }
                }
    }
}

module controller_platform_2d() {
    difference() {
        translate(rect_center_from_left_north(
            controller_platform_outer_size,
            controller_platform_outer_left_inset,
            controller_platform_outer_north_inset
        ))
            square(controller_platform_outer_size, center = true);

        translate(rect_center_from_left_north(
            controller_platform_notch_size,
            controller_platform_notch_left_inset,
            controller_platform_notch_north_inset
        ))
            square(controller_platform_notch_size, center = true);
    }
}

module controller_supports() {
    if (controller_support_enabled) {
        linear_extrude(height = controller_platform_height)
            controller_platform_2d();

        translate([0, 0, 0])
            linear_extrude(height = controller_block_height)
                translate(rect_center_from_left_north(
                    controller_block_size,
                    controller_block_left_inset,
                    controller_block_north_inset
                ))
                    square(controller_block_size, center = true);
    }
}

module controller_large_window_profile_2d() {
    square(controller_inner_window_size, center = true);
}

module controller_outer_window_profile_2d() {
    rounded_rect_2d(
        controller_outer_window_size,
        controller_outer_window_corner_r
    );
}

module controller_window_3d() {
    if (controller_window_enabled)
        union() {
            // Large internal cable cavity.
            translate([
                controller_window_center()[0],
                y_from_north(controller_inner_window_center_from_north),
                controller_inner_window_bottom_z + controller_inner_window_size[1] / 2
            ])
                rotate([90, 0, 0])
                    linear_extrude(height = controller_inner_window_depth, center = true)
                        controller_large_window_profile_2d();

            // Extend the inner cavity slightly farther inward so the
            // under-lip support wall does not leave a thin blocker strip in
            // front of the controller / port window.
            translate([
                controller_window_center()[0],
                y_from_north(
                    controller_inner_window_center_from_north
                    + controller_inner_window_depth / 2
                    + controller_inner_window_inboard_relief_depth / 2
                ),
                controller_inner_window_bottom_z + controller_inner_window_size[1] / 2
            ])
                rotate([90, 0, 0])
                    linear_extrude(height = controller_inner_window_inboard_relief_depth, center = true)
                        controller_large_window_profile_2d();

            // Smaller outer port slot.
            translate([
                controller_window_center()[0],
                y_from_north(controller_outer_window_center_from_north),
                controller_outer_window_bottom_z + controller_outer_window_size[1] / 2
            ])
                rotate([90, 0, 0])
                    linear_extrude(height = controller_outer_window_depth, center = true)
                        controller_outer_window_profile_2d();

            // Transition between inner cavity and outer slot.
            hull() {
                translate([
                    controller_window_center()[0],
                    y_from_north(controller_inner_window_center_from_north - controller_inner_window_depth / 2),
                    controller_inner_window_bottom_z + controller_inner_window_size[1] / 2
                ])
                    rotate([90, 0, 0])
                        linear_extrude(height = 0.01, center = true)
                            controller_large_window_profile_2d();

                translate([
                    controller_window_center()[0],
                    y_from_north(controller_outer_window_center_from_north + controller_outer_window_depth / 2),
                    controller_outer_window_bottom_z + controller_outer_window_size[1] / 2
                ])
                    rotate([90, 0, 0])
                        linear_extrude(height = 0.01, center = true)
                            controller_outer_window_profile_2d();
            }
        }
}

module bottom_top_slope_cut() {
    if (bottom_side_slope_enabled) {
        cut_size = [outer_size()[0] + 80, outer_size()[1] + 80, max(bottom_front_height, bottom_back_height) + 80];

        translate([0, 0, bottom_mid_height()])
            rotate([bottom_tilt_angle(), 0, 0])
                translate([-cut_size[0] / 2, -cut_size[1] / 2, 0])
                    cube(cut_size);
    }
}

module bottom_locating_rim() {
    translate([0, 0, bottom_mid_height()])
        rotate([bottom_tilt_angle(), 0, 0])
            translate([0, 0, -bottom_rim_embed])
                linear_extrude(height = bottom_rim_height + bottom_rim_embed)
                    underside_relief_slots_2d(clearance = bottom_rim_clearance);
}

module cable_cutout_3d() {
    if (bottom_cable_cutout_enabled) {
        if (bottom_cable_cutout_edge == "north")
            translate([0, outer_size()[1] / 2, bottom_cable_cutout_bottom_z + bottom_cable_cutout_height / 2])
                rotate([90, 0, 0])
                    linear_extrude(height = bottom_wall_thickness + 0.5, center = true)
                        rounded_rect_2d([bottom_cable_cutout_width, bottom_cable_cutout_height], bottom_cable_cutout_corner_r);

        else if (bottom_cable_cutout_edge == "south")
            translate([0, -outer_size()[1] / 2, bottom_cable_cutout_bottom_z + bottom_cable_cutout_height / 2])
                rotate([90, 0, 0])
                    linear_extrude(height = bottom_wall_thickness + 0.5, center = true)
                        rounded_rect_2d([bottom_cable_cutout_width, bottom_cable_cutout_height], bottom_cable_cutout_corner_r);

        else if (bottom_cable_cutout_edge == "east")
            translate([outer_size()[0] / 2, 0, bottom_cable_cutout_bottom_z + bottom_cable_cutout_height / 2])
                rotate([90, 0, 90])
                    linear_extrude(height = bottom_wall_thickness + 0.5, center = true)
                        rounded_rect_2d([bottom_cable_cutout_width, bottom_cable_cutout_height], bottom_cable_cutout_corner_r);

        else if (bottom_cable_cutout_edge == "west")
            translate([-outer_size()[0] / 2, 0, bottom_cable_cutout_bottom_z + bottom_cable_cutout_height / 2])
                rotate([90, 0, 90])
                    linear_extrude(height = bottom_wall_thickness + 0.5, center = true)
                        rounded_rect_2d([bottom_cable_cutout_width, bottom_cable_cutout_height], bottom_cable_cutout_corner_r);
    }
}

module bottom_core() {
    difference() {
        union() {
            bottom_shell();
            corner_underlip_gussets();
            bottom_posts();
            bottom_joystick_support_pad();
            bottom_joystick_locator_ribs();
            bottom_joystick_mount_posts();
            corner_bolt_posts();
            controller_supports();
        }

        bottom_post_holes();
        bottom_joystick_mount_holes();
        corner_bolt_holes();
        controller_window_3d();
        bottom_top_slope_cut();
        cable_cutout_3d();
    }
}

module void40_bottom() {
    union() {
        bottom_core();
        bottom_locating_rim();
    }
}

function bottom_tilt_angle() = atan((bottom_back_height - bottom_front_height) / outer_size()[1]);
function bottom_mid_height() = (bottom_front_height + bottom_back_height) / 2;

module void40_assembly(explode = 2.0) {
    color([0.92, 0.92, 0.92])
        translate([0, 0, bottom_mid_height() + explode])
            rotate([bottom_tilt_angle(), 0, 0])
                void40_top();

    color([0.75, 0.75, 0.78])
        void40_bottom();
}
