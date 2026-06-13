# Usage

## Include and call

Each module is consumed with `include` followed by a module call. No geometry
is emitted from `include` alone.

```scad
include <src/temptower.scad>;

generate_temp_tower(
    tower_label = "Temp",
    starting_value = 220,
    ending_value = 180,
    value_change = -5,
    section_label_suffix = "C"
);
```

The example files in `examples/` are ready-to-use entry points -- open one in
OpenSCAD, adjust the top-level variables to suit your printer, and render.

## Quality / $fn

All example files set `$fn` via a preview/render split:

```scad
preview_quality_value = 24;   // fast interactive preview
render_quality_value  = 48;   // increase for final STL export

$fn = $preview ? preview_quality_value : render_quality_value;
```

Increase `render_quality_value` (e.g. 128) before exporting a final STL.
The `$fn` variable is intentionally not set inside library modules so callers
retain full control.

## Common parameters

These parameters appear consistently across all tower and model modules:

| Parameter | Typical default | Description |
|---|---|---|
| `font` | `"Arial:style=Bold"` | OpenSCAD font string for all text |
| `wall_thickness` | `0.601` | Wall thickness in mm |
| `base_height` | `0.801` | First-layer base height in mm |
| `iota` | `0.001` | Tiny offset to avoid z-fighting in preview |
| `orient_for_screenshot` | `false` | Snap viewport to preset screenshot angles |

## Viewport parameters

All tower modules accept viewport parameters used when `orient_for_screenshot`
is `true`. These are passed directly to OpenSCAD's `$vpd`, `$vpf`, `$vpr`,
`$vpt` variables and have no effect on the printed geometry.

| Parameter | Description |
|---|---|
| `screenshot_vpd` | Viewport distance |
| `screenshot_vpf` | Field of view |
| `screenshot_vpr` | Rotation `[x, y, z]` |
| `screenshot_vpt` | Translation `[x, y, z]` |
