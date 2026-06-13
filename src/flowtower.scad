// src/flowtower.scad
// Flow Tower Generator
// Original author: Brad Kartchner
// Version Author: Cameron K. Brooks
// Refactored for best practices

/* [General Parameters] */
// The label to add to the tower
tower_label = "";

// The secondary label to add to the tower
tower_secondary_label = "";

// Text to prefix to the section labels
section_label_prefix = "";

// Text to suffix to the section labels
section_label_suffix = "";

// The starting value
starting_value = 115;

// The ending value
ending_value = 85;

// The amount to change the value between sections
value_change = -5;

// The height of the base
base_height = 0.841;

// The height of each section of the tower
section_size = 8.401;

// The diameter of the holes to create in each section
section_hole_diameter = 4.201;

/* [Advanced Parameters] */
// The font to use for tower text
font = "Arial:style=Bold";

// Should sections be labeled?
label_sections = true;

// The height of the section labels in relation to the height of each section
section_label_height_multiplier = 0.401;

// The height of the tower label in relation to the length of the column
tower_label_height_multiplier = 0.601;

// The height of the secondary label in relation to the height of each section
tower_secondary_label_height_multiplier = 0.401;

// The thickness of walls in the tower
wall_thickness = 0.601;

// The value to use for creating the model preview (lower is faster)
preview_quality_value = 24;

// The value to use for creating the final model render (higher is more detailed)
render_quality_value = 24;

// A small value used to improve rendering in preview mode
iota = 0.001;

/* [Development Parameters] */
// Orient the model for creating a screenshot
orient_for_screenshot = false;

// The viewport distance for the screenshot
screenshot_vpd = 140.00;

// The viewport field of view for the screenshot
screenshot_vpf = 22.50;

// The viewport rotation for the screenshot
screenshot_vpr = [75.00, 0.00, 45.00];

// The viewport translation for the screenshot
screenshot_vpt = [0.00, 0.00, 15.00];

/* [Calculated Parameters] */
// Calculate the rendering quality
$fn = $preview ? preview_quality_value : render_quality_value;

/* [Helper Modules] */

// Generate the base of the tower
module generate_base(base_size, base_height) {
    translate([-base_size / 2, -base_size / 2, 0])
        cube([base_size, base_size, base_height]);
}

// Generate a single section of the tower with a given label
module generate_section(
    label,
    section_size,
    section_hole_diameter,
    wall_thickness,
    font,
    label_depth,
    iota,
    label_sections,
    section_label_prefix,
    section_label_suffix,
    section_label_font_size
) {
    difference() {
        // Create the main body of the section
        translate([-section_size, -section_size, 0])
            cube([section_size, section_size, section_size]);

        // Create the hole in the section
        translate([-section_size - section_size / 2, -section_size / 2, section_size / 2])
            rotate([0, 90, 0])
            cylinder(d = section_hole_diameter, h = section_size * 2);

        // Carve out the label for this section
        if (label_sections)
            generate_section_label(
                label,
                section_size,
                wall_thickness,
                font,
                label_depth,
                iota,
                section_label_prefix,
                section_label_suffix,
                section_label_font_size
            );
    }
}

// Generate the text that will be carved into the square section column
module generate_section_label(
    label,
    section_size,
    wall_thickness,
    font,
    label_depth,
    iota,
    section_label_prefix,
    section_label_suffix,
    section_label_font_size
) {
    full_label = str(section_label_prefix, label, section_label_suffix);
    translate([-section_size / 2, -section_size, section_size / 2])
        rotate([90, 0, 0])
        translate([0, 0, -label_depth])
        linear_extrude(height = label_depth + iota)
            text(
                text = full_label,
                font = font,
                size = section_label_font_size,
                halign = "center",
                valign = "center"
            );
}

// Generate the sloping connector that connects one section to the next
module generate_section_connector(section_size) {
    points = [
        [0, 0],
        [section_size, section_size],
        [section_size, 0],
    ];

    rotate([0, -90, 0])
        linear_extrude(height = section_size)
        polygon(points);
}

// Generate the text that will be carved on the base of the tower
module generate_tower_label(
    tower_label,
    base_size,
    wall_thickness,
    font,
    label_depth,
    iota,
    tower_label_font_size
) {
    width = base_size - wall_thickness * 2;

    translate([base_size / 4, 0, 0])
        rotate([0, 0, 90])
        linear_extrude(height = label_depth + iota)
        resize([width, 0], auto = true)
            text(
                text = tower_label,
                font = font,
                size = tower_label_font_size,
                halign = "center",
                valign = "center"
            );
}

// Generate the secondary tower label
module generate_secondary_label(
    tower_secondary_label,
    base_size,
    font,
    label_depth,
    iota,
    tower_secondary_label_font_size
) {
    translate([-base_size / 4, 0, 0])
        rotate([0, 0, 90])
        translate([base_size / 4, 0, 0])
        rotate([0, 0, 90])
        linear_extrude(height = label_depth + iota)
            text(
                text = tower_secondary_label,
                font = font,
                size = tower_secondary_label_font_size,
                halign = "center",
                valign = "center"
            );
}

// Generate the tower by iteratively creating sections
module generate_tower(
    starting_value,
    value_change_corrected,
    section_count,
    section_size,
    section_hole_diameter,
    wall_thickness,
    font,
    label_depth,
    iota,
    label_sections,
    section_label_prefix,
    section_label_suffix,
    section_label_font_size
) {
    for (section = [0 : section_count - 1]) {
        // Determine the value for this section
        value = starting_value + (value_change_corrected * section);

        // Determine the offset of the section
        z_offset = section * section_size;

        // Determine the rotation of the section
        z_rot = -90 * section;

        // Generate the section itself and move it into place
        translate([0, 0, z_offset])
            rotate([0, 0, z_rot]) {
                generate_section(
                    str(value),
                    section_size,
                    section_hole_diameter,
                    wall_thickness,
                    font,
                    label_depth,
                    iota,
                    label_sections,
                    section_label_prefix,
                    section_label_suffix,
                    section_label_font_size
                );
                generate_section_connector(section_size);
            }
    }
}

/* [Main Model Generation Module] */

module generate_flow_tower(
    // General Parameters
    tower_label = "",
    tower_secondary_label = "",
    section_label_prefix = "",
    section_label_suffix = "",
    starting_value = 115,
    ending_value = 85,
    value_change = -5,
    base_height = 0.841,
    section_size = 8.401,
    section_hole_diameter = 4.201,
    // Advanced Parameters
    font = "Arial:style=Bold",
    label_sections = true,
    section_label_height_multiplier = 0.401,
    tower_label_height_multiplier = 0.601,
    tower_secondary_label_height_multiplier = 0.401,
    wall_thickness = 0.601,
    iota = 0.001,
    // Viewport Parameters
    orient_for_screenshot = false,
    screenshot_vpd = 140.00,
    screenshot_vpf = 22.50,
    screenshot_vpr = [75.00, 0.00, 45.00],
    screenshot_vpt = [0.00, 0.00, 15.00]
) {
    /* [Calculated Parameters] */
    // Ensure the value change has the correct sign
    value_change_corrected = ending_value > starting_value
        ? abs(value_change)
        : -abs(value_change);

    // Determine how many sections to generate
    section_count = ceil(abs(ending_value - starting_value) / abs(value_change) + 1);

    // Calculate the amount to expand the base beyond the size of the tower
    base_extension = wall_thickness * 4;

    // Calculate the horizontal size of the base of the tower
    base_size = section_size * 2 + base_extension * 2;

    // Calculate the font sizes
    section_label_font_size = section_size * section_label_height_multiplier;
    tower_label_font_size = section_size * tower_label_height_multiplier;
    tower_secondary_label_font_size = section_size * tower_secondary_label_height_multiplier;

    // Calculate the depth of the labels
    label_depth = wall_thickness / 2;

    /* [Generate the Model] */

    // Add the base
    generate_base(base_size, base_height);

    translate([0, 0, base_height])
        union() {
            // Generate the tower
            generate_tower(
                starting_value,
                value_change_corrected,
                section_count,
                section_size,
                section_hole_diameter,
                wall_thickness,
                font,
                label_depth,
                iota,
                label_sections,
                section_label_prefix,
                section_label_suffix,
                section_label_font_size
            );

            // Generate the tower label
            generate_tower_label(
                tower_label,
                base_size,
                wall_thickness,
                font,
                label_depth,
                iota,
                tower_label_font_size
            );

            // Generate the secondary label
            generate_secondary_label(
                tower_secondary_label,
                base_size,
                font,
                label_depth,
                iota,
                tower_secondary_label_font_size
            );
        }

    /* [Viewport Orientation] */
    $vpd = orient_for_screenshot ? screenshot_vpd : $vpd;
    $vpf = orient_for_screenshot ? screenshot_vpf : $vpf;
    $vpr = orient_for_screenshot ? screenshot_vpr : $vpr;
    $vpt = orient_for_screenshot ? screenshot_vpt : $vpt;
}
