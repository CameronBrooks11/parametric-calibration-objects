// examples/blp_concentric_circles_example.scad

include <../../src/bedlevelpattern.scad>;

// Parameters
bed_level_pattern_type = "concentric circles";
print_area_width = 220.001;
print_area_depth = 220.001;
line_width = 0.401;
line_height = 0.301;
fill_percentage = 90; // Range: [50:100]
concentric_ring_count = 7;
quality_value = 128;

$fn = quality_value;

// Generate the pattern
generate_bed_level_pattern(bed_level_pattern_type, print_area_width, print_area_depth, line_width, line_height,
                           fill_percentage, concentric_ring_count = concentric_ring_count);