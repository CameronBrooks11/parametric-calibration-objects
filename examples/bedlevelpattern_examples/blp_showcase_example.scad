// examples/bedlevelpattern_examples/blp_showcase_example.scad

include <../../src/bedlevelpattern.scad>;

/* [Pattern Selection] */

// List of available patterns:
// 0: "concentric squares"
// 1: "spiral squares"
// 2: "concentric circles"
// 3: "x in square"
// 4: "circle in square"
// 5: "grid"
// 6: "padded grid"
// 7: "five circles"

// Select the pattern type by setting this variable:
// You can use either a string or a number (0-7)
selected_pattern_type = 0; // Change this to any number from 0 to 7 or the pattern name as a string
//selected_pattern_type = "concentric squares"; 

/* [Common Parameters] */

print_area_width = 220.001;
print_area_depth = 220.001;
line_width = 0.401;
line_height = 0.301;
fill_percentage = 90; // Range: [50:100]
quality_value = 128;

$fn = quality_value;

/* [Pattern Mapping] */

// Mapping of numbers to pattern names
pattern_names = [
  "concentric squares", // 0
  "spiral squares", // 1
  "concentric circles", // 2
  "x in square", // 3
  "circle in square", // 4
  "grid", // 5
  "padded grid", // 6
  "five circles", // 7
];

/* [Determine the Pattern Name] */

// If selected_pattern_type is a number between 0 and 7, map it to the pattern name
// Else, assume it's a string and use it directly
bed_level_pattern_type =
  is_num(selected_pattern_type) ? pattern_names[ (selected_pattern_type >= 0 && selected_pattern_type <= 7) ? selected_pattern_type : 0]
  : selected_pattern_type;

/* [Pattern-Specific Parameters Initialization] */

// Initialize pattern-specific parameters with default values
concentric_ring_count = 7;
grid_cell_count = 4;
grid_pad_size = 10.001;
circle_diameter = 20;
outline_distance = 5;

/* [Pattern-Specific Parameters Configuration] */

// Adjust pattern-specific parameters based on the selected pattern
if (
  bed_level_pattern_type == "concentric squares" || bed_level_pattern_type == "spiral squares" || bed_level_pattern_type == "concentric circles"
) {
  // These patterns use concentric_ring_count
  concentric_ring_count = 7; // Adjust this value if needed
}

if (bed_level_pattern_type == "grid" || bed_level_pattern_type == "padded grid") {
  // These patterns use grid_cell_count
  grid_cell_count = 4; // Adjust this value if needed
}

if (bed_level_pattern_type == "padded grid") {
  // Padded grid uses grid_pad_size
  grid_pad_size = 10.001; // Adjust this value if needed
}

if (bed_level_pattern_type == "five circles") {
  // Five circles pattern uses circle_diameter and outline_distance
  circle_diameter = 20; // Adjust this value if needed
  outline_distance = 5; // Adjust this value if needed
}

/* [Generate the Pattern] */

generate_bed_level_pattern(
  bed_level_pattern_type=bed_level_pattern_type, print_area_width=print_area_width,
  print_area_depth=print_area_depth, line_width=line_width, line_height=line_height,
  fill_percentage=fill_percentage,
  // Pass pattern-specific parameters
  concentric_ring_count=concentric_ring_count, grid_cell_count=grid_cell_count,
  grid_pad_size=grid_pad_size, circle_diameter=circle_diameter,
  outline_distance=outline_distance
);
