// src/temptower.scad
// Temperature Tower Generator Library
// Original author: Brad Kartchner
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// The label to add to the tower
tower_label = "";

// The label to add to the right column
column_label = "";

// Text to prefix to the section labels
section_label_prefix = "";

// Text to suffix to the section labels
section_label_suffix = "";

// The starting value (temperature or fan speed)
starting_value = 220;

// The ending value (temperature or fan speed)
ending_value = 180;

// The amount to change the value between sections
value_change = -5;

// The height of the base
base_height = 0.801;

// The height of each section of the tower
section_height = 8.001;

/* [Advanced Parameters] */
// The font to use for tower text
font = "Arial:style=Bold";

// Should sections be labeled?
label_sections = true;

// The height of the section labels in relation to the height of each section
section_label_height_multiplier = 0.401;

// The height of the tower label in relation to the height of each section
tower_label_height_multiplier = 0.601;

// The height of the column label in relation to the height of each section
column_label_height_multiplier = 0.301;

// The thickness of walls in the tower
wall_thickness = 0.601;

// The width of the tower as multiples of the section height
tower_width_multiplier = 5.001;

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
screenshot_vpr = [75.00, 0.00, 300.00];

// The viewport translation for the screenshot
screenshot_vpt = [0.00, 0.00, 15.00];

/* [Calculated Parameters] */
// The value to use for creating the model preview (lower is faster)
preview_quality_value = 24;

// The value to use for creating the final model render (higher is more detailed)
render_quality_value = 24;

// Calculate the rendering quality
$fn = $preview ? preview_quality_value : render_quality_value;

/* [Helper Modules] */

// Generate the base of the tower
module generate_temp_base(base_width, base_length, base_height) {
  translate([-base_width / 2, -base_length / 2, 0])
    cube([base_width, base_length, base_height]);
}

// Generate a hollow square column for a section
module generate_temp_section_column(cube_size, cap_size, cap_height, wall_thickness, iota) {
  hollow_size = cube_size - wall_thickness * 3;
  difference() {
    union() {
      translate([-cube_size / 2, -cube_size / 2, 0])
        cube([cube_size, cube_size, cube_size - cap_height]);
      translate([-cap_size / 2, -cap_size / 2, cube_size - cap_height])
        cube([cap_size, cap_size, cap_height]);
    }
    translate([-hollow_size / 2, -hollow_size / 2, -iota])
      cube([hollow_size, hollow_size, cube_size + iota * 2]);
  }
}

// Generate the bridge connecting the two columns at the top of a section
module generate_temp_section_bridge(tower_width, cube_size, bridge_thickness, cap_height) {
  translate([-tower_width / 2 + cube_size, -cube_size / 2, cube_size - bridge_thickness - cap_height])
    cube([tower_width - cube_size * 2, cube_size, bridge_thickness]);
}

// Generate the angled bridge support on the left side of a section
module generate_temp_left_bridge_support(
  tower_width,
  cube_size,
  support_size,
  cap_height,
  bridge_thickness,
  iota
) {
  translate([-tower_width / 2 + cube_size, 0, cube_size - support_size - cap_height - bridge_thickness])
    difference() {
      translate([0, -cube_size / 2, 0])
        cube([support_size, cube_size, support_size]);
      angled_height = sqrt(pow(support_size, 2) * 2);
      translate([0, -cube_size / 2, 0])
        rotate([0, 45, 0])
          translate([-iota, -iota, 0])
            cube([support_size, cube_size + iota * 2, angled_height]);
    }
}

// Generate the curved bridge support on the right side of a section
module generate_temp_right_bridge_support(
  tower_width,
  cube_size,
  support_size,
  cap_height,
  bridge_thickness,
  iota
) {
  translate([tower_width / 2 - cube_size, 0, cube_size - support_size - cap_height - bridge_thickness])
    difference() {
      translate([-support_size, -cube_size / 2, 0])
        cube([support_size, cube_size, support_size]);
      translate([-support_size, 0, 0])
        rotate([90, 0, 0])
          cylinder(r=support_size, cube_size + iota * 2, center=true);
    }
}

// Generate the section label carved into the left column
module generate_temp_section_label(
  label,
  section_label_prefix,
  section_label_suffix,
  tower_width,
  cube_size,
  font,
  section_label_font_size,
  label_depth,
  iota
) {
  full_label = str(section_label_prefix, label, section_label_suffix);
  translate([-tower_width / 2 + cube_size / 2, -cube_size / 2 - iota, cube_size / 2])
    rotate([90, 0, 0])
      translate([0, 0, -label_depth])
        linear_extrude(label_depth + iota)
          text(
            text=full_label,
            font=font,
            size=section_label_font_size,
            halign="center",
            valign="center"
          );
}

// Generate the tower label carved along the left side
module generate_temp_tower_label(
  label,
  tower_width,
  cube_size,
  font,
  tower_label_font_size,
  label_depth,
  iota
) {
  translate([-tower_width / 2 - iota, 0, cube_size / 2])
    rotate([90, -90, -90])
      translate([0, 0, -label_depth])
        linear_extrude(label_depth + iota)
          text(
            text=label,
            font=font,
            size=tower_label_font_size,
            halign="left",
            valign="center"
          );
}

// Generate the column label carved into the front face of the right column
module generate_temp_column_label(
  label,
  tower_width,
  cube_size,
  font,
  column_label_font_size,
  label_depth,
  iota
) {
  translate([tower_width / 2 - cube_size / 2, -cube_size / 2 - iota, cube_size / 2])
    rotate([90, 0, 0])
      translate([0, 0, -label_depth])
        linear_extrude(label_depth + iota)
          text(
            text=label,
            font=font,
            size=column_label_font_size,
            halign="center",
            valign="center"
          );
}

// Generate a single section of the tower
module generate_temp_section(
  label,
  tower_width,
  cube_size,
  cap_size,
  cap_height,
  wall_thickness,
  bridge_thickness,
  support_size,
  font,
  section_label_prefix,
  section_label_suffix,
  section_label_font_size,
  label_depth,
  iota,
  label_sections
) {
  difference() {
    union() {
      for (x_offset = [-tower_width / 2 + cube_size / 2, tower_width / 2 - cube_size / 2])
        translate([x_offset, 0, 0])
          generate_temp_section_column(cube_size, cap_size, cap_height, wall_thickness, iota);
      generate_temp_section_bridge(tower_width, cube_size, bridge_thickness, cap_height);
      generate_temp_left_bridge_support(tower_width, cube_size, support_size, cap_height, bridge_thickness, iota);
      generate_temp_right_bridge_support(tower_width, cube_size, support_size, cap_height, bridge_thickness, iota);
    }
    if (label_sections)
      generate_temp_section_label(
        label,
        section_label_prefix,
        section_label_suffix,
        tower_width,
        cube_size,
        font,
        section_label_font_size,
        label_depth,
        iota
      );
  }
}

// Generate the tower sections by iterating over each value
module generate_temp_tower_sections(
  starting_value,
  value_change_corrected,
  section_count,
  section_height,
  tower_width,
  cube_size,
  cap_size,
  cap_height,
  wall_thickness,
  bridge_thickness,
  support_size,
  font,
  section_label_prefix,
  section_label_suffix,
  section_label_font_size,
  label_depth,
  iota,
  label_sections
) {
  for (section = [0:section_count - 1]) {
    value = starting_value + (value_change_corrected * section);
    z_offset = section * section_height;
    translate([0, 0, z_offset])
      generate_temp_section(
        str(value),
        tower_width,
        cube_size,
        cap_size,
        cap_height,
        wall_thickness,
        bridge_thickness,
        support_size,
        font,
        section_label_prefix,
        section_label_suffix,
        section_label_font_size,
        label_depth,
        iota,
        label_sections
      );
  }
}

/* [Main Model Generation Module] */

// Generates the temperature tower based on provided parameters
module generate_temp_tower(
  // General Parameters
  tower_label = "",
  column_label = "",
  section_label_prefix = "",
  section_label_suffix = "",
  starting_value = 220,
  ending_value = 180,
  value_change = -5,
  base_height = 0.801,
  section_height = 8.001,
  // Advanced Parameters
  font = "Arial:style=Bold",
  label_sections = true,
  section_label_height_multiplier = 0.401,
  tower_label_height_multiplier = 0.601,
  column_label_height_multiplier = 0.301,
  wall_thickness = 0.601,
  tower_width_multiplier = 5.001,
  iota = 0.001,
  // Viewport Parameters
  orient_for_screenshot = false,
  screenshot_vpd = 140.00,
  screenshot_vpf = 22.50,
  screenshot_vpr = [75.00, 0.00, 300.00],
  screenshot_vpt = [0.00, 0.00, 15.00]
) {
  /* [Calculated Parameters] */
  value_change_corrected =
    ending_value > starting_value ? abs(value_change)
    : -abs(value_change);
  section_count = ceil(abs(ending_value - starting_value) / abs(value_change) + 1);
  cube_size = section_height;
  cap_size = cube_size - wall_thickness;
  cap_height = wall_thickness;
  bridge_thickness = wall_thickness;
  support_size = cube_size / 2;
  tower_width = cube_size * tower_width_multiplier;
  base_extension = wall_thickness * 4;
  base_width = tower_width + base_extension * 2;
  base_length = cube_size + base_extension * 2;
  section_label_font_size = cube_size * section_label_height_multiplier;
  tower_label_font_size = cube_size * tower_label_height_multiplier;
  column_label_font_size = cube_size * column_label_height_multiplier;
  label_depth = wall_thickness / 2;

  /* [Generate the Model] */
  generate_temp_base(base_width, base_length, base_height);

  difference() {
    translate([0, 0, base_height])
      generate_temp_tower_sections(
        starting_value,
        value_change_corrected,
        section_count,
        section_height,
        tower_width,
        cube_size,
        cap_size,
        cap_height,
        wall_thickness,
        bridge_thickness,
        support_size,
        font,
        section_label_prefix,
        section_label_suffix,
        section_label_font_size,
        label_depth,
        iota,
        label_sections
      );

    generate_temp_tower_label(
      tower_label,
      tower_width,
      cube_size,
      font,
      tower_label_font_size,
      label_depth,
      iota
    );

    generate_temp_column_label(
      column_label,
      tower_width,
      cube_size,
      font,
      column_label_font_size,
      label_depth,
      iota
    );
  }

  /* [Viewport Orientation] */
  $vpd = orient_for_screenshot ? screenshot_vpd : $vpd;
  $vpf = orient_for_screenshot ? screenshot_vpf : $vpf;
  $vpr = orient_for_screenshot ? screenshot_vpr : $vpr;
  $vpt = orient_for_screenshot ? screenshot_vpt : $vpt;
}
