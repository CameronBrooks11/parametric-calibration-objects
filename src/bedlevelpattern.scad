// Bed Level Test Patterns Generator
// bedlevelpattern.scad
// Inspired by All3DP article: https://all3dp.com/2/ender-3-pro-bed-leveling-gcode/
// Original author:  Brad Kartchner 
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// The type of bed level pattern to generate
bed_level_pattern_type = "concentric squares"; // Options: ["concentric squares", "spiral squares", "concentric circles", "x in square", "circle in square", "grid", "padded grid", "five circles"]

// The width and depth of the bed print area
print_area_width = 220.001;
print_area_depth = 220.001;

// The width and height of the lines to print
line_width = 0.401;
line_height = 0.301;

// The percentage of the print area to use for the bed level pattern
fill_percentage = 90; // Range: [50:100]

/* [Bed Level Pattern-Specific Parameters] */
// Number of rings or grids for specific patterns
concentric_ring_count = 7;
grid_cell_count = 4;

// Size parameters for specific patterns
grid_pad_size = 10.001;
circle_diameter = 20;
outline_distance = 5;

/* [Advanced Parameters] */
// Quality value (higher numbers mean better quality, lower numbers mean faster rendering)
quality_value = 128;

/* [Development Parameters] */
// Highlight the print area?
show_print_area = false;

// Orient the model for creating a screenshot?
orient_for_screenshot = false;

// Screenshot parameters
screenshot_vpd = 400.00;
screenshot_vpf = 22.50;
screenshot_vpr = [60.00, 0.00, 300.00];
screenshot_vpt = [0.00, -5.00, -16.00];

$fn = quality_value;

/* [Helper Modules] */

// Generalized circle/oval module
module oval(d = 1, r = undef) {
    diameter_x = r == undef ? (is_list(d) ? d[0] : d) : (is_list(r) ? r[0] * 2 : r * 2);
    diameter_y = r == undef ? (is_list(d) ? d[1] : d) : (is_list(r) ? r[1] * 2 : r * 2);
    diameter_circle = max(diameter_x, diameter_y);
    resize([diameter_x, diameter_y]) circle(d = diameter_circle);
}

// Draws an oval outline
module outlined_oval(thickness = 1, d = 1, r = undef) {
    diameter_x = r == undef ? (is_list(d) ? d[0] : d) : (is_list(r) ? r[0] * 2 : r * 2);
    diameter_y = r == undef ? (is_list(d) ? d[1] : d) : (is_list(r) ? r[1] * 2 : r * 2);
    difference() {
        oval(d = [diameter_x, diameter_y]);
        oval(d = [diameter_x - thickness * 2, diameter_y - thickness * 2]);
    }
}

// Draws a rectangular outline
module outlined_square(dimensions = 1, thickness = 1, center = false) {
    width = is_list(dimensions) ? dimensions[0] : dimensions;
    height = is_list(dimensions) ? dimensions[1] : dimensions;
    difference() {
        square([width, height], center = center);
        square([width - thickness * 2, height - thickness * 2], center = center);
    }
}

// Draws a spiral square outline
module outlined_spiral_square(dimensions = 1, ring_count = 1, thickness = 1) {
    width = is_list(dimensions) ? dimensions[0] : dimensions;
    height = is_list(dimensions) ? dimensions[1] : dimensions;
    width_delta = width / ring_count;
    height_delta = height / ring_count;

    for (ring_number = [0 : ring_count - 1]) {
        ring_width = width_delta * (ring_number + 1);
        ring_height = height_delta * (ring_number + 1);
        x1 = -ring_width / 2;
        x2 = x1 + ring_width;
        y1 = -ring_height / 2;
        y2 = y1 + ring_height;
        y3 = y1 - height_delta / 2;

        // Bottom line
        bottom_line_width = ring_width - width_delta / 2;
        if (bottom_line_width > 0)
            translate([x1, y1]) square([bottom_line_width, thickness]);

        // Left line
        left_line_height = ring_height;
        translate([x1, y1]) square([thickness, left_line_height]);

        // Top line
        top_line_width = ring_width;
        translate([x1, y2 - thickness]) square([top_line_width, thickness]);

        // Right line
        right_line_height = ring_height + height_delta / 2;
        if (right_line_height < height)
            translate([x2 - thickness, y3]) square([thickness, right_line_height]);
        else
            translate([x2 - thickness, y1]) square([thickness, height]);
    }
}

// Draws a grid
module generate_grid(dimensions = 1, line_width = 1, cell_count = 1) {
    width = (is_list(dimensions) ? dimensions[0] : dimensions) - line_width;
    height = (is_list(dimensions) ? dimensions[1] : dimensions) - line_width;

    // Vertical lines
    section_width = width / cell_count;
    for (section_number = [0 : cell_count]) {
        x_offset = -width / 2 + section_width * section_number;
        grid_line_width = line_width;
        grid_line_height = height + line_width;
        translate([x_offset, 0]) square([grid_line_width, grid_line_height], center = true);
    }

    // Horizontal lines
    section_height = height / cell_count;
    for (section_number = [0 : cell_count]) {
        y_offset = -height / 2 + section_height * section_number;
        grid_line_width = width + line_width;
        grid_line_height = line_width;
        translate([0, y_offset]) square([grid_line_width, grid_line_height], center = true);
    }
}

// Draws an 'X' shape
module x_shape(dimensions = 1, thickness = 1) {
    width = is_list(dimensions) ? dimensions[0] : dimensions;
    height = is_list(dimensions) ? dimensions[1] : dimensions;

    // Calculate the angle and length of the diagonal lines
    angle = atan(height / width);
    length = sqrt(pow(width, 2) + pow(height, 2));

    intersection() {
        // Generate each line in the 'X'
        for (z_rot = [angle, -angle])
            rotate([0, 0, z_rot]) square([length, thickness], center = true);

        // Keep the lines within the requested dimensions
        square([width, height], center = true);
    }
}

// Draws a curved 'X' pattern
module curved_x_pattern(size = 1, thickness = 1, cd = 1, cr = undef) {
    width = is_list(size) ? size[0] : size;
    height = is_list(size) ? size[1] : size;
    corner_radius = cr == undef ? cd / 2 : cr;
    corner_x = width / 2 - corner_radius;
    corner_y = height / 2 - corner_radius;

    module generate_corner(x, y, corner_radius, thickness) {
        difference() {
            translate([x, y]) outlined_oval(r = corner_radius, thickness = thickness);
            polygon(points = [[0, 0], [x + y, 0], [0, x + y]]);
        }
    }

    module generate_side(x, y, corner_radius, thickness) {
        side_radius = y * sqrt(2) - corner_radius + thickness;
        intersection() {
            translate([x + y, 0]) outlined_oval(r = side_radius, thickness = thickness);
            polygon(points = [[0, 0], [x + y, 0], [0, x + y]]);
        }
    }

    // Generate corners
    for (x_mirror = [0, 1])
        for (y_mirror = [0, 1])
            mirror([x_mirror, 0])
                mirror([0, y_mirror])
                    generate_corner(corner_x, corner_y, corner_radius, thickness);

    // Generate sides
    for (x_mirror = [0, 1])
        for (y_mirror = [0, 1]) {
            mirror([x_mirror, 0])
                mirror([0, y_mirror]) {
                    generate_side(corner_x, corner_y, corner_radius, thickness);
                    rotate(90) generate_side(corner_y, corner_x, corner_radius, thickness);
                }
        }
}

/* [Pattern Generation Modules] */

// Generates the concentric squares pattern
module generate_concentric_squares_pattern(width, depth, ring_count, line_width) {
    width_delta = width / ring_count;
    depth_delta = depth / ring_count;

    for (ring_number = [0 : ring_count - 1]) {
        ring_width = width_delta * (ring_number + 1);
        ring_depth = depth_delta * (ring_number + 1);
        outlined_square([ring_width, ring_depth], line_width, center = true);
    }
}

// Generates the spiral squares pattern
module generate_spiral_squares_pattern(width, depth, ring_count, line_width) {
    outlined_spiral_square([width, depth], ring_count, line_width);
}

// Generates the concentric circles pattern
module generate_concentric_circles_pattern(width, depth, ring_count, line_width) {
    width_delta = width / ring_count;
    depth_delta = depth / ring_count;

    for (ring_number = [0 : ring_count - 1]) {
        ring_width = width_delta * (ring_number + 1);
        ring_depth = depth_delta * (ring_number + 1);
        outlined_oval(d = [ring_width, ring_depth], thickness = line_width);
    }
}

// Generates the 'X' in square pattern
module generate_x_in_square_pattern(width, depth, line_width) {
    square_width = width;
    square_depth = depth;
    x_width = square_width - line_width * 4;
    x_depth = square_depth - line_width * 4;
    outlined_square([square_width, square_depth], line_width, center = true);
    x_shape([x_width, x_depth], line_width);
}

// Generates the circle in square pattern
module generate_circle_in_square_pattern(width, depth, line_width) {
    square_width = width;
    square_depth = depth;
    circle_width = square_width - line_width * 4;
    circle_depth = square_depth - line_width * 4;
    outlined_square([square_width, square_depth], line_width, center = true);
    outlined_oval(d = [circle_width, circle_depth], thickness = line_width);
}

// Generates the grid pattern
module generate_grid_pattern(width, depth, line_width, cell_count) {
    generate_grid([width, depth], line_width, cell_count);
}

// Generates the padded grid pattern
module generate_padded_grid_pattern(width, depth, line_width, cell_count, pad_size) {
    grid_width = width - pad_size + line_width;
    grid_height = depth - pad_size + line_width;
    generate_grid([grid_width, grid_height], line_width, cell_count);

    // Generate pads at grid intersections
    section_width = (grid_width - line_width) / cell_count;
    section_height = (grid_height - line_width) / cell_count;

    for (i = [0 : cell_count]) {
        x_offset = -(grid_width - line_width) / 2 + section_width * i;
        for (j = [0 : cell_count]) {
            y_offset = -(grid_height - line_width) / 2 + section_height * j;
            translate([x_offset, y_offset]) square([pad_size, pad_size], center = true);
        }
    }
}

// Generates the five circles pattern
module generate_five_circles_pattern(width, height, line_width, circle_diameter, outline_distance) {
    corner_radius = circle_diameter / 2 + outline_distance + line_width;
    corner_x = width / 2 - corner_radius;
    corner_y = height / 2 - corner_radius;

    // Center circle
    circle(d = circle_diameter);

    // Corner circles
    for (x_mirror = [0, 1])
        for (y_mirror = [0, 1])
            mirror([x_mirror, 0])
                mirror([0, y_mirror])
                    translate([corner_x, corner_y]) circle(d = circle_diameter);

    // Curved outline
    curved_x_pattern([width, height], line_width, cr = corner_radius);
}

/* [Main Model Generation Module] */

module generate_model() {
    pattern_width = print_area_width * (fill_percentage / 100);
    pattern_depth = print_area_depth * (fill_percentage / 100);

    linear_extrude(line_height) {
        if (bed_level_pattern_type == "concentric squares") {
            generate_concentric_squares_pattern(pattern_width, pattern_depth, concentric_ring_count, line_width);
        } else if (bed_level_pattern_type == "spiral squares") {
            generate_spiral_squares_pattern(pattern_width, pattern_depth, concentric_ring_count, line_width);
        } else if (bed_level_pattern_type == "concentric circles") {
            generate_concentric_circles_pattern(pattern_width, pattern_depth, concentric_ring_count, line_width);
        } else if (bed_level_pattern_type == "circle in square") {
            generate_circle_in_square_pattern(pattern_width, pattern_depth, line_width);
        } else if (bed_level_pattern_type == "x in square") {
            generate_x_in_square_pattern(pattern_width, pattern_depth, line_width);
        } else if (bed_level_pattern_type == "grid") {
            generate_grid_pattern(pattern_width, pattern_depth, line_width, grid_cell_count);
        } else if (bed_level_pattern_type == "padded grid") {
            generate_padded_grid_pattern(pattern_width, pattern_depth, line_width, grid_cell_count, grid_pad_size);
        } else if (bed_level_pattern_type == "five circles") {
            generate_five_circles_pattern(pattern_width, pattern_depth, line_width, circle_diameter, outline_distance);
        }
    }

    if (show_print_area) {
        %square([print_area_width, print_area_depth], center = true);
    }
}

// Generate the model
generate_model();

// Orient the viewport for screenshot if enabled
$vpd = orient_for_screenshot ? screenshot_vpd : $vpd;
$vpf = orient_for_screenshot ? screenshot_vpf : $vpf;
$vpr = orient_for_screenshot ? screenshot_vpr : $vpr;
$vpt = orient_for_screenshot ? screenshot_vpt : $vpt;
