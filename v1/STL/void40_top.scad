include <void40_common.scad>;

// Parametric reconstruction of `VOID40OP - Top GRID.stl`
//
// Useful parameters to tweak:
// - case_extra = [x, y];
// - cols / rows / key_pitch;
// - center_mount_positions;
// - underside relief and corner relief parameters.
//
// Coordinates are centered on the switch matrix.
// Z=0 is the printable underside of the top part.

void40_top();
