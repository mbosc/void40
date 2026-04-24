# VOID40 OpenSCAD reconstruction

Files:
- `void40_common.scad` — shared parameters + modules
- `void40_top.scad` — parametric reconstruction of `VOID40OP - Top GRID.stl`
- `void40_bottom.scad` — simplified parametric approximation of `VOID40OP - Bottom.stl`
- `void40_assembly.scad` — quick combined preview

## Coordinate system
- XY origin: center of the switch matrix
- `void40_top.scad`: `z=0` is the printable underside of the top
- `void40_bottom.scad`: `z=0` is the printable floor of the bottom

## Most useful parameters
Edit these in `void40_common.scad`:

- `case_extra = [x, y];`
  - grows the whole case around the existing key matrix
  - both top and bottom follow automatically
- `cols`, `rows`, `key_pitch`
- `center_mount_positions`
- `bottom_height`
- `bottom_floor_thickness`
- `bottom_wall_thickness`
- `bottom_cable_cutout_*`

## Top reconstruction status
The top was rebuilt from inferred primitives:
- rounded outer shell
- open upper window
- stepped MX switch cutouts
- four tapered center mounting holes
- four corner relief holes
- underside locating / relief slots

This is not triangle-for-triangle identical to the STL, but it was checked against the original mesh and matches the major feature stack very closely.

### Validation summary
Compared against `VOID40OP - Top GRID.stl`:
- same overall bounding box (after recentering)
- same switch grid and upper opening layout
- same layer behavior at representative Z slices
- volume difference: about **0.22%**

## Bottom reconstruction status
The bottom is intentionally simplified:
- clean tray geometry
- screw posts aligned to the top's four center mounts
- locating rim keyed to the top underside reliefs
- configurable cable cutout

This is meant as an editable starting point for further mods (joystick, controller space, cable routing, etc.), not as an exact recreation of the sculpted STL underside.

### Included bottom features
The current bottom model now also includes:
- four corner bolt posts / holes
- an Arduino Pro Micro / controller support cradle near the back-left area
- a two-stage rear port opening aligned with that cradle
- an angled side profile, lower at the front and taller at the rear
