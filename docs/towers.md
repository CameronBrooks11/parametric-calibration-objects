# Tower Module Reference

Parameter reference for all five calibration tower generators.

---

## generate_flow_tower

**File:** `src/flowtower.scad` | **Example:** `examples/flowtower_examples/flowtower_example.scad`

Extrusion multiplier / flow rate calibration tower. Each section is a hollow
cube with a cylindrical through-hole and a connector ramp to the next section.

```scad
include <src/flowtower.scad>;
generate_flow_tower(starting_value = 115, ending_value = 85, value_change = -5);
```

| Parameter                                 | Default              | Description                                             |
| ----------------------------------------- | -------------------- | ------------------------------------------------------- |
| `tower_label`                             | `""`                 | Label inscribed on the base                             |
| `tower_secondary_label`                   | `""`                 | Secondary label inscribed on the base                   |
| `section_label_prefix`                    | `""`                 | Text prepended to each section value                    |
| `section_label_suffix`                    | `""`                 | Text appended to each section value                     |
| `starting_value`                          | `115`                | First section value                                     |
| `ending_value`                            | `85`                 | Last section value                                      |
| `value_change`                            | `-5`                 | Step between sections (sign auto-corrected)             |
| `base_height`                             | `0.841`              | Height of the flat base (mm)                            |
| `section_size`                            | `8.401`              | Width, depth, and height of each section (mm)           |
| `section_hole_diameter`                   | `4.201`              | Diameter of the through-hole per section (mm)           |
| `font`                                    | `"Arial:style=Bold"` | Font for all labels                                     |
| `label_sections`                          | `true`               | Carve value into each section                           |
| `section_label_height_multiplier`         | `0.401`              | Section label font size as fraction of `section_size`   |
| `tower_label_height_multiplier`           | `0.601`              | Tower label font size as fraction of `section_size`     |
| `tower_secondary_label_height_multiplier` | `0.401`              | Secondary label font size as fraction of `section_size` |
| `wall_thickness`                          | `0.601`              | Wall thickness (mm)                                     |
| `iota`                                    | `0.001`              | Z-fighting offset                                       |

---

## generate_temp_tower

**File:** `src/temptower.scad` | **Example:** `examples/temptower_examples/temptower_example.scad`

Temperature calibration tower. Each section has two hollow square columns
bridged at the top with angled and curved supports to test bridging quality.

```scad
include <src/temptower.scad>;
generate_temp_tower(starting_value = 220, ending_value = 180, value_change = -5);
```

| Parameter                         | Default              | Description                                             |
| --------------------------------- | -------------------- | ------------------------------------------------------- |
| `tower_label`                     | `""`                 | Label inscribed along the left side                     |
| `column_label`                    | `""`                 | Label inscribed on the right column face                |
| `section_label_prefix`            | `""`                 | Text prepended to each section value                    |
| `section_label_suffix`            | `""`                 | Text appended to each section value                     |
| `starting_value`                  | `220`                | First section value                                     |
| `ending_value`                    | `180`                | Last section value                                      |
| `value_change`                    | `-5`                 | Step between sections (sign auto-corrected)             |
| `base_height`                     | `0.801`              | Height of the flat base (mm)                            |
| `section_height`                  | `8.001`              | Height of each section (mm)                             |
| `font`                            | `"Arial:style=Bold"` | Font for all labels                                     |
| `label_sections`                  | `true`               | Carve value into each section                           |
| `section_label_height_multiplier` | `0.401`              | Section label font size as fraction of `section_height` |
| `tower_label_height_multiplier`   | `0.601`              | Tower label font size as fraction of `section_height`   |
| `column_label_height_multiplier`  | `0.301`              | Column label font size as fraction of `section_height`  |
| `wall_thickness`                  | `0.601`              | Wall thickness (mm)                                     |
| `tower_width_multiplier`          | `5.001`              | Tower width as multiple of `section_height`             |
| `iota`                            | `0.001`              | Z-fighting offset                                       |

---

## generate_temp_tower_detailed

**File:** `src/temptower_detailed.scad` | **Example:** `examples/temptower_examples/temptower_detailed_example.scad`

Detailed temperature tower with complex section geometry: sloped end pieces, a
curved left compartment, and a right compartment with conical spikes. Tests
overhangs, curves, and fine detail at each temperature.

```scad
include <src/temptower_detailed.scad>;
generate_temp_tower_detailed(starting_value = 220, ending_value = 180, value_change = -5);
```

| Parameter                         | Default              | Description                                             |
| --------------------------------- | -------------------- | ------------------------------------------------------- |
| `tower_label`                     | `""`                 | Label inscribed on the base                             |
| `section_label_prefix`            | `""`                 | Text prepended to each section value                    |
| `section_label_suffix`            | `""`                 | Text appended to each section value                     |
| `starting_value`                  | `220`                | First section value                                     |
| `ending_value`                    | `180`                | Last section value                                      |
| `value_change`                    | `-5`                 | Step between sections (sign auto-corrected)             |
| `base_height`                     | `0.801`              | Height of the flat base (mm)                            |
| `section_height`                  | `8.001`              | Height of each section (mm)                             |
| `wall_thickness`                  | `0.601`              | Wall thickness (mm)                                     |
| `font`                            | `"Arial:style=Bold"` | Font for all labels                                     |
| `label_sections`                  | `true`               | Carve value into each section                           |
| `base_extension`                  | `2.404`              | Base overhang beyond section outline (mm)               |
| `left_slope_angle`                | `35`                 | Left slope end angle (degrees)                          |
| `right_slope_angle`               | `45`                 | Right slope end angle (degrees)                         |
| `section_label_height_multiplier` | `0.401`              | Section label font size as fraction of `section_height` |
| `iota`                            | `0.001`              | Z-fighting offset                                       |

---

## generate_retract_tower

**File:** `src/retracttower.scad` | **Example:** `examples/retracttower_examples/retracttower_example.scad`

Retraction distance calibration tower. Each section has a hollow square column
on the left and a hollow round column on the right.

```scad
include <src/retracttower.scad>;
generate_retract_tower(starting_value = 1.0, ending_value = 6.0, value_change = 1.0);
```

| Parameter                                | Default              | Description                                             |
| ---------------------------------------- | -------------------- | ------------------------------------------------------- |
| `tower_label`                            | `""`                 | Label inscribed along the left side                     |
| `column_label`                           | `""`                 | Label wrapped around the right round column             |
| `section_label_prefix`                   | `""`                 | Text prepended to each section value                    |
| `section_label_suffix`                   | `""`                 | Text appended to each section value                     |
| `starting_value`                         | `1.0`                | First section value (mm)                                |
| `ending_value`                           | `6.0`                | Last section value (mm)                                 |
| `value_change`                           | `1.0`                | Step between sections (sign auto-corrected)             |
| `base_height`                            | `0.801`              | Height of the flat base (mm)                            |
| `section_height`                         | `8.001`              | Height of each section (mm)                             |
| `font`                                   | `"Arial:style=Bold"` | Font for all labels                                     |
| `label_sections`                         | `true`               | Carve value into each section                           |
| `section_label_height_multiplier`        | `0.401`              | Section label font size as fraction of `section_height` |
| `tower_label_height_multiplier`          | `0.601`              | Tower label font size as fraction of `section_height`   |
| `column_label_height_multiplier`         | `0.301`              | Column label font size as fraction of `section_height`  |
| `column_label_letter_spacing_multiplier` | `1.001`              | Letter spacing for the curved column label              |
| `wall_thickness`                         | `0.601`              | Wall thickness (mm)                                     |
| `tower_width_multiplier`                 | `5.001`              | Tower width as multiple of `section_height`             |
| `iota`                                   | `0.001`              | Z-fighting offset                                       |

---

## generate_speed_tower

**File:** `src/speedtower.scad` | **Example:** `examples/speedtower_examples/speedtower_example.scad`

Print speed calibration tower with an L-shaped cross-section covering both X
and Y axes. Each section has front circular cutouts and rear rectangular cutouts
to test bridging and overhangs at each speed.

```scad
include <src/speedtower.scad>;
generate_speed_tower(starting_speed_value = 20, ending_speed_value = 100, speed_value_change = 20);
```

| Parameter                        | Default              | Description                                          |
| -------------------------------- | -------------------- | ---------------------------------------------------- |
| `tower_label`                    | `""`                 | Label inscribed on the base                          |
| `tower_description`              | `""`                 | Secondary label inscribed on the base                |
| `starting_speed_value`           | `20`                 | First section speed (mm/s)                           |
| `ending_speed_value`             | `100`                | Last section speed (mm/s)                            |
| `speed_value_change`             | `20`                 | Step between sections (sign auto-corrected)          |
| `wing_length`                    | `50.001`             | Length of each wing (mm)                             |
| `wing_thickness`                 | `3.001`              | Thickness of each wing (mm)                          |
| `base_height`                    | `0.841`              | Height of the flat base (mm)                         |
| `section_height`                 | `8.401`              | Height of each section (mm)                          |
| `base_font_size`                 | `2.001`              | Font size for base axis labels (mm)                  |
| `hide_labels`                    | `false`              | Suppress all label inscriptions                      |
| `font`                           | `"Arial:style=Bold"` | Font for all labels                                  |
| `wall_thickness`                 | `0.4001`             | Wall thickness (mm)                                  |
| `section_font_height_multiplier` | `0.333`              | Section label height as fraction of `section_height` |
| `inscription_depth`              | `0.201`              | Depth of all inscriptions (mm)                       |
| `iota`                           | `0.001`              | Z-fighting offset                                    |
