// Any bed level pattern
// All eight patterns in one file: pick one, and set its parameters, in the Customizer.

include <../../src/bedlevelpattern.scad>;

/* [Pattern] */
bed_level_pattern_type = "concentric squares"; // [concentric squares, spiral squares, concentric circles, x in square, circle in square, grid, padded grid, five circles]

/* [Print area] */
print_area_width = 220.001;
print_area_depth = 220.001;
// Share of the print area the pattern covers (%)
fill_percentage = 90; // [50:100]

/* [Lines] */
line_width = 0.401;
line_height = 0.301;

/* [Concentric and spiral patterns] */
concentric_ring_count = 7;

/* [Grid patterns] */
grid_cell_count = 4;
// Side of each pad on the padded grid
grid_pad_size = 10.001;

/* [Five circles] */
circle_diameter = 20;
outline_distance = 5;

/* [Quality] */
quality_value = 128;

$fn = quality_value;

generate_bed_level_pattern(
  bed_level_pattern_type=bed_level_pattern_type, print_area_width=print_area_width,
  print_area_depth=print_area_depth, line_width=line_width, line_height=line_height,
  fill_percentage=fill_percentage, concentric_ring_count=concentric_ring_count,
  grid_cell_count=grid_cell_count, grid_pad_size=grid_pad_size, circle_diameter=circle_diameter,
  outline_distance=outline_distance
);
