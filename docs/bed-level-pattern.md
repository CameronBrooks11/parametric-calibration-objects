# Bed Level Pattern Reference

**File:** `src/bedlevelpattern.scad` | **Examples:** `examples/bedlevelpattern_examples/`

Generates a 2D bed levelling test pattern, extruded to `line_height`. Eight
pattern types are supported; select by passing the pattern name string.

```scad
include <src/bedlevelpattern.scad>;

generate_bed_level_pattern(
    bed_level_pattern_type = "concentric squares",
    print_area_width = 220,
    print_area_depth = 220,
    line_width = 0.4,
    line_height = 0.3,
    fill_percentage = 90
);
```

## Parameters

| Parameter                | Default      | Description                                       |
| ------------------------ | ------------ | ------------------------------------------------- |
| `bed_level_pattern_type` | _(required)_ | Pattern name -- see table below                   |
| `print_area_width`       | _(required)_ | Width of the printable area (mm)                  |
| `print_area_depth`       | _(required)_ | Depth of the printable area (mm)                  |
| `line_width`             | _(required)_ | Printed line width (mm)                           |
| `line_height`            | _(required)_ | Layer / extrusion height (mm)                     |
| `fill_percentage`        | _(required)_ | Percentage of print area to use (50-100)          |
| `concentric_ring_count`  | `7`          | Ring count for concentric and spiral patterns     |
| `grid_cell_count`        | `4`          | Cell count for grid patterns                      |
| `grid_pad_size`          | `10.001`     | Pad size for the padded grid pattern (mm)         |
| `circle_diameter`        | `20`         | Circle diameter for the five circles pattern (mm) |
| `outline_distance`       | `5`          | Outline offset for the five circles pattern (mm)  |
| `show_print_area`        | `false`      | Overlay print area boundary (debug, `%` modifier) |

## Pattern types

| Value                  | Pattern                        | Pattern-specific parameter            |
| ---------------------- | ------------------------------ | ------------------------------------- |
| `"concentric squares"` | Nested squares                 | `concentric_ring_count`               |
| `"spiral squares"`     | Outward spiral of squares      | `concentric_ring_count`               |
| `"concentric circles"` | Nested circles                 | `concentric_ring_count`               |
| `"x in square"`        | X shape inside a border square | --                                    |
| `"circle in square"`   | Circle inside a border square  | --                                    |
| `"grid"`               | Uniform grid                   | `grid_cell_count`                     |
| `"padded grid"`        | Grid with padded corner pads   | `grid_cell_count`, `grid_pad_size`    |
| `"five circles"`       | Center + four corner circles   | `circle_diameter`, `outline_distance` |

The showcase example (`blp_showcase_example.scad`) accepts a numeric index
(0-7) or a name string and maps it to the correct pattern, making it easy to
cycle through all types.
