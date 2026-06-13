# Parameter Reference

Full parameter documentation for every library module in `src/`.

---

## generate_bed_level_pattern

**File:** `src/bedlevelpattern.scad`

Generates a 2D bed levelling test pattern extruded to `line_height`.

```scad
include <src/bedlevelpattern.scad>;
generate_bed_level_pattern(
    bed_level_pattern_type,
    print_area_width,
    print_area_depth,
    line_width,
    line_height,
    fill_percentage
);
```

| Parameter | Default | Description |
|---|---|---|
| `bed_level_pattern_type` | _(required)_ | Pattern name string: `"concentric squares"`, `"spiral squares"`, `"concentric circles"`, `"x in square"`, `"circle in square"`, `"grid"`, `"padded grid"`, `"five circles"` |
| `print_area_width` | _(required)_ | Width of the printable area in mm |
| `print_area_depth` | _(required)_ | Depth of the printable area in mm |
| `line_width` | _(required)_ | Width of each printed line in mm |
| `line_height` | _(required)_ | Layer height / extrusion height in mm |
| `fill_percentage` | _(required)_ | Percentage of print area to fill (50-100) |
| `concentric_ring_count` | `7` | Ring count for concentric/spiral patterns |
| `grid_cell_count` | `4` | Cell count for grid patterns |
| `grid_pad_size` | `10.001` | Pad size for padded grid pattern (mm) |
| `circle_diameter` | `20` | Circle diameter for five circles pattern (mm) |
| `outline_distance` | `5` | Outline offset for five circles pattern (mm) |
| `show_print_area` | `false` | Show print area boundary (debug, `%` modifier) |

---

## generate_flow_tower

**File:** `src/flowtower.scad`

Generates a flow / extrusion multiplier calibration tower. Each section is a
hollow cube with a cylindrical hole through it and a connector ramp to the next.

```scad
include <src/flowtower.scad>;
generate_flow_tower(starting_value = 115, ending_value = 85, value_change = -5);
```

| Parameter | Default | Description |
|---|---|---|
| `tower_label` | `""` | Label inscribed on the base |
| `tower_secondary_label` | `""` | Secondary label inscribed on the base |
| `section_label_prefix` | `""` | Text prepended to each section value |
| `section_label_suffix` | `""` | Text appended to each section value |
| `starting_value` | `115` | First section value |
| `ending_value` | `85` | Last section value |
| `value_change` | `-5` | Step between sections (sign auto-corrected) |
| `base_height` | `0.841` | Height of the flat base in mm |
| `section_size` | `8.401` | Width, depth, and height of each section in mm |
| `section_hole_diameter` | `4.201` | Diameter of the through-hole in each section (mm) |
| `font` | `"Arial:style=Bold"` | Font for all labels |
| `label_sections` | `true` | Carve section value into each section |
| `section_label_height_multiplier` | `0.401` | Section label font size as fraction of section_size |
| `tower_label_height_multiplier` | `0.601` | Tower label font size as fraction of section_size |
| `tower_secondary_label_height_multiplier` | `0.401` | Secondary label font size as fraction of section_size |
| `wall_thickness` | `0.601` | Wall thickness in mm |
| `iota` | `0.001` | Small offset used to avoid z-fighting in preview |

---

## generate_temp_tower

**File:** `src/temptower.scad`

Generates a temperature calibration tower. Each section has two hollow square
columns connected by a bridge with angled/curved supports -- designed to test
bridging at each temperature.

```scad
include <src/temptower.scad>;
generate_temp_tower(starting_value = 220, ending_value = 180, value_change = -5);
```

| Parameter | Default | Description |
|---|---|---|
| `tower_label` | `""` | Label inscribed along the left side of the tower |
| `column_label` | `""` | Label inscribed on the right column |
| `section_label_prefix` | `""` | Text prepended to each section value |
| `section_label_suffix` | `""` | Text appended to each section value |
| `starting_value` | `220` | First section value |
| `ending_value` | `180` | Last section value |
| `value_change` | `-5` | Step between sections (sign auto-corrected) |
| `base_height` | `0.801` | Height of the flat base in mm |
| `section_height` | `8.001` | Height of each section in mm |
| `font` | `"Arial:style=Bold"` | Font for all labels |
| `label_sections` | `true` | Carve section value into each section |
| `section_label_height_multiplier` | `0.401` | Section label font size as fraction of section_height |
| `tower_label_height_multiplier` | `0.601` | Tower label font size as fraction of section_height |
| `column_label_height_multiplier` | `0.301` | Column label font size as fraction of section_height |
| `wall_thickness` | `0.601` | Wall thickness in mm |
| `tower_width_multiplier` | `5.001` | Tower width as a multiple of section_height |
| `iota` | `0.001` | Small offset used to avoid z-fighting in preview |

---

## generate_temp_tower_detailed

**File:** `src/temptower_detailed.scad`

Generates a detailed temperature tower with more complex section geometry:
sloped end pieces, a curved left compartment with spikes, and a right
compartment with conical spikes. Good for testing overhangs, curves, and
fine detail at each temperature.

```scad
include <src/temptower_detailed.scad>;
generate_temp_tower_detailed(starting_value = 220, ending_value = 180, value_change = -5);
```

| Parameter | Default | Description |
|---|---|---|
| `tower_label` | `""` | Label inscribed on the base |
| `section_label_prefix` | `""` | Text prepended to each section value |
| `section_label_suffix` | `""` | Text appended to each section value |
| `starting_value` | `220` | First section value |
| `ending_value` | `180` | Last section value |
| `value_change` | `-5` | Step between sections (sign auto-corrected) |
| `base_height` | `0.801` | Height of the flat base in mm |
| `section_height` | `8.001` | Height of each section in mm |
| `wall_thickness` | `0.601` | Wall thickness in mm |
| `font` | `"Arial:style=Bold"` | Font for all labels |
| `label_sections` | `true` | Carve section value into each section |
| `base_extension` | `2.404` | Amount the base extends beyond the section outline (mm) |
| `left_slope_angle` | `35` | Angle of the left slope end (degrees) |
| `right_slope_angle` | `45` | Angle of the right slope end (degrees) |
| `section_label_height_multiplier` | `0.401` | Section label font size as fraction of section_height |
| `iota` | `0.001` | Small offset used to avoid z-fighting in preview |

---

## generate_retract_tower

**File:** `src/retracttower.scad`

Generates a retraction distance calibration tower. Each section has a hollow
square column on the left and a hollow round column on the right.

```scad
include <src/retracttower.scad>;
generate_retract_tower(starting_value = 1.0, ending_value = 6.0, value_change = 1.0);
```

| Parameter | Default | Description |
|---|---|---|
| `tower_label` | `""` | Label inscribed along the left side of the tower |
| `column_label` | `""` | Label wrapped around the right round column |
| `section_label_prefix` | `""` | Text prepended to each section value |
| `section_label_suffix` | `""` | Text appended to each section value |
| `starting_value` | `1.0` | First section value (mm) |
| `ending_value` | `6.0` | Last section value (mm) |
| `value_change` | `1.0` | Step between sections (sign auto-corrected) |
| `base_height` | `0.801` | Height of the flat base in mm |
| `section_height` | `8.001` | Height of each section in mm |
| `font` | `"Arial:style=Bold"` | Font for all labels |
| `label_sections` | `true` | Carve section value into each section |
| `section_label_height_multiplier` | `0.401` | Section label font size as fraction of section_height |
| `tower_label_height_multiplier` | `0.601` | Tower label font size as fraction of section_height |
| `column_label_height_multiplier` | `0.301` | Column label font size as fraction of section_height |
| `column_label_letter_spacing_multiplier` | `1.001` | Letter spacing for the curved column label |
| `wall_thickness` | `0.601` | Wall thickness in mm |
| `tower_width_multiplier` | `5.001` | Tower width as a multiple of section_height |
| `iota` | `0.001` | Small offset used to avoid z-fighting in preview |

---

## generate_speed_tower

**File:** `src/speedtower.scad`

Generates a print speed calibration tower. L-shaped cross-section with one
wing per axis (X and Y), labelled per section, with front circular cutouts and
rear rectangular cutouts to test overhangs and bridging at each speed.

```scad
include <src/speedtower.scad>;
generate_speed_tower(starting_speed_value = 20, ending_speed_value = 100, speed_value_change = 20);
```

| Parameter | Default | Description |
|---|---|---|
| `tower_label` | `""` | Label inscribed on the base |
| `tower_description` | `""` | Secondary label inscribed on the base |
| `starting_speed_value` | `20` | First section speed value (mm/s) |
| `ending_speed_value` | `100` | Last section speed value (mm/s) |
| `speed_value_change` | `20` | Step between sections (sign auto-corrected) |
| `wing_length` | `50.001` | Length of each wing in mm |
| `wing_thickness` | `3.001` | Thickness of each wing in mm |
| `base_height` | `0.841` | Height of the flat base in mm |
| `section_height` | `8.401` | Height of each section in mm |
| `base_font_size` | `2.001` | Font size for base axis labels (mm) |
| `hide_labels` | `false` | Suppress all label inscriptions |
| `font` | `"Arial:style=Bold"` | Font for all labels |
| `section_label_height_multiplier` | `0.401` | Section label font size as fraction of section_height |
| `wall_thickness` | `0.4001` | Wall thickness in mm |
| `section_font_height_multiplier` | `0.333` | Section label height as fraction of section_height |
| `inscription_depth` | `0.201` | Depth of all inscriptions in mm |
| `iota` | `0.001` | Small offset used to avoid z-fighting in preview |

---

## generate_xyz_cali_cube

**File:** `src/xyzcalicube.scad`

Generates a 20 mm XYZ calibration cube with X, Y, Z letters cut into each face.

```scad
include <src/xyzcalicube.scad>;
generate_xyz_cali_cube(cube_size = 20);
```

| Parameter | Default | Description |
|---|---|---|
| `cube_size` | `20` | Side length of the cube in mm |

---

## generate_torture_test

**File:** `src/torture_test.scad`

Generates a structural torture test model: a wire-frame cube tilted on its
corner and clipped flat, mounted on a circular base. Tests overhang, bridging,
and fine geometry.

```scad
include <src/torture_test.scad>;
generate_torture_test();
```

| Parameter | Default | Description |
|---|---|---|
| `bar_thickness` | `5` | Diameter of the wire-frame bars in mm |
| `cube_length` | `80` | Overall size of the cube in mm |
| `base_thickness` | `4` | Thickness of the circular base in mm |
| `base_scale` | `1.1` | Base diameter as a multiple of cube_length |

---

## References

- Bed levelling inspiration: [All3DP article](https://all3dp.com/2/ender-3-pro-bed-leveling-gcode/)
- Tower generator inspiration: [AutoTowersGenerator](https://github.com/kartchnb/AutoTowersGenerator)
- Torture test reference: [Printables model 188769](https://www.printables.com/model/188769-customizable-torture-tes/files)

