include <void40_common.scad>;

// Simplified, mod-friendly approximation of `VOID40OP - Bottom.stl`
//
// Intentional differences from the STL:
// - no sculpted/filleted underside
// - simple vertical tray walls
// - parameterized screw posts, cable cutout, and locating rim
//
// Good starting knobs:
// - case_extra = [x, y];
// - bottom_height;
// - bottom_floor_thickness / bottom_wall_thickness;
// - bottom_cable_cutout_*;
// - center_mount_positions for future joystick/controller layouts.
//
// Z=0 is the printable floor of the bottom part.

void40_bottom();
