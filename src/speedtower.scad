// src/speedtower.scad
// Speed Tower Generator Library
// Original author: Brad Kartchner
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// A label to add to the tower
tower_label = "";

// A description to add to the tower
tower_description = "";

// The starting speed value
starting_speed_value = 20;

// The ending speed value
ending_speed_value = 100;

// The amount to change the speed value between sections
speed_value_change = 20;

// The length of each wing of the tower
wing_length = 50.001;

// The thickness of each wing of the tower
wing_thickness = 3.001;

// The height of the base
base_height = 0.841;

// The height of each section of the tower
section_height = 8.401;

// The size of the base font
base_font_size = 2.001;

/* [Advanced Parameters] */
// Should labels be hidden?
hide_labels = false;

// The font to use for tower text
font = "Arial:style=Bold";

// The height of the section labels in relation to the height of each section
section_label_height_multiplier = 0.401;

// The nominal thickness of walls in the model
wall_thickness = 0.4001;

// The height of the section label text as a fraction of the section height
section_font_height_multiplier = 0.333;

// The depth of inscriptions
inscription_depth = 0.201;

// A small value used to improve rendering in preview mode
iota = 0.001;

/* [Development Parameters] */
// Orient the model for creating a screenshot
orient_for_screenshot = false;

// The viewport distance for the screenshot
screenshot_vpd = 200.00;

// The viewport field of view for the screenshot
screenshot_vpf = 22.50;

// The viewport rotation for the screenshot
screenshot_vpr = [60.00, 0.00, 60.00];

// The viewport translation for the screenshot
screenshot_vpt = [17.00, 15.00, 15.00];

/* [Calculated Parameters] */
// The value to use for creating the model preview (lower is faster)
preview_quality_value = 24;

// The value to use for creating the final model render (higher is more detailed)
render_quality_value = 48;

// Calculate the rendering quality
$fn = $preview ? preview_quality_value : render_quality_value;

/* [Helper Modules] */

// Generate a 2D double-headed arrow profile
module generate_speed_double_headed_arrow(dimensions, center = false) {
  width = is_list(dimensions) ? dimensions.x : dimensions;
  length = is_list(dimensions) ? dimensions.y : dimensions;
  y_offset = center ? -length / 2 : 0;
  arrow_width = width;
  arrow_length = arrow_width;
  shaft_width = width / 2;
  arrow_points = [
    [0, 0],
    [arrow_width / 2, arrow_length],
    [-arrow_width / 2, arrow_length],
  ];
  translate([0, y_offset])for (side = [0, 1]) {
    side_y_mir = side;
    side_y_offset = length * side;
    translate([0, side_y_offset])
      mirror([0, side_y_mir]) {
        polygon(arrow_points);
        translate([-(width - shaft_width) / 2, arrow_length])
          square([shaft_width, length / 2 - arrow_length]);
      }
  }
}

// Generate the L-shaped base footprint
module generate_speed_basic_base(wing_length, wing_thickness, base_height, base_extension) {
  width = wing_thickness + base_extension * 2;
  length = wing_length + base_extension * 2;
  x_offset = -base_extension;
  y_offset = -base_extension;
  linear_extrude(base_height) {
    translate([x_offset, y_offset])
      square([width, length]);
    translate([y_offset, x_offset])
      square([length, width]);
  }
}

// Generate a label inscription on the base surface
module generate_speed_base_label(
  label,
  hide_labels,
  inscription_depth,
  wing_length,
  wing_thickness,
  base_height,
  base_extension,
  base_font_size,
  font
) {
  if (!hide_labels) {
    thickness = inscription_depth * 2;
    x_offset = wing_length / 2 - wing_thickness / 2;
    y_offset = -base_extension / 2;
    translate([x_offset, y_offset, base_height])
      translate([0, 0, -thickness / 2])
        linear_extrude(thickness)
          resize([0, base_font_size], auto=true)
            text(label, base_font_size, font, halign="center", valign="center");
  }
}

// Generate the complete base with all axis labels
module generate_speed_base(
  wing_length,
  wing_thickness,
  base_height,
  base_extension,
  base_font_size,
  font,
  hide_labels,
  inscription_depth,
  tower_label,
  tower_description
) {
  difference() {
    generate_speed_basic_base(wing_length, wing_thickness, base_height, base_extension);

    generate_speed_base_label(
      tower_label, hide_labels, inscription_depth,
      wing_length, wing_thickness, base_height, base_extension, base_font_size, font
    );

    translate([0, wing_length, 0])
      rotate([0, 0, -90])
        generate_speed_base_label(
          tower_description, hide_labels, inscription_depth,
          wing_length, wing_thickness, base_height, base_extension, base_font_size, font
        );

    translate([wing_length, wing_thickness, 0])
      rotate([0, 0, 180])
        generate_speed_base_label(
          "X-AXIS", hide_labels, inscription_depth,
          wing_length, wing_thickness, base_height, base_extension, base_font_size, font
        );

    translate([wing_thickness, wing_thickness, 0])
      rotate([0, 0, 90])
        generate_speed_base_label(
          "Y-AXIS", hide_labels, inscription_depth,
          wing_length, wing_thickness, base_height, base_extension, base_font_size, font
        );
  }
}

// Generate the basic section body (hollow wing shape with inset cap)
module generate_speed_basic_section(wing_length, wing_thickness, section_height, wall_thickness) {
  body_width = wing_thickness;
  body_length = wing_length;
  body_height = section_height - wall_thickness;
  cap_width = body_width - wall_thickness;
  cap_length = body_length - wall_thickness;
  cap_height = wall_thickness;
  cap_x_offset = (body_width - cap_width) / 2;
  cap_y_offset = (body_length - cap_length) / 2;
  cap_z_offset = body_height;
  cube([body_width, body_length, body_height]);
  translate([cap_x_offset, cap_y_offset, cap_z_offset])
    cube([cap_width, cap_length, cap_height]);
}

// Generate the circular front cutout for a section
module generate_speed_section_front_cutout(section_height, wing_length, inscription_depth) {
  diameter = section_height;
  height = inscription_depth * 2;
  translate([0, wing_length / 2, (section_height - 0) / 2])
    rotate([0, 90, 0])
      translate([0, 0, -height / 2])
        cylinder(d=diameter, height);
}

// Generate the rectangular rear cutout for a section
module generate_speed_section_rear_cutout(
  wing_length,
  wing_thickness,
  section_height,
  wall_thickness,
  inscription_depth
) {
  width = wing_length - wall_thickness * 2 - wing_thickness;
  height = section_height - wall_thickness * 3;
  thickness = inscription_depth * 2;
  diameter = section_height;
  translate([wing_thickness, wing_thickness, 0])
    rotate([90, 0, 90])
      translate([0, 0, -thickness / 2])
        linear_extrude(thickness)
          translate([wall_thickness, wall_thickness])
            difference() {
              square([width, height]);
              translate([width / 2, height / 2])
                circle(d=diameter);
            }
}

// Generate the section speed label inscription
module generate_speed_section_label(
  label,
  hide_labels,
  inscription_depth,
  wing_length,
  section_height,
  wall_thickness,
  section_label_font_size,
  font
) {
  if (!hide_labels) {
    thickness = inscription_depth * 2;
    translate([0, wing_length / 2, (section_height - wall_thickness) / 2])
      rotate([90, 0, -90])
        translate([0, 0, -thickness / 2])
          linear_extrude(thickness)
            text(label, section_label_font_size, font, halign="center", valign="center");
  }
}

// Generate a Y-axis section
module generate_speed_y_axis_section(
  label,
  wing_length,
  wing_thickness,
  section_height,
  wall_thickness,
  inscription_depth,
  section_label_font_size,
  font,
  hide_labels
) {
  difference() {
    generate_speed_basic_section(wing_length, wing_thickness, section_height, wall_thickness);
    generate_speed_section_front_cutout(section_height, wing_length, inscription_depth);
    generate_speed_section_rear_cutout(wing_length, wing_thickness, section_height, wall_thickness, inscription_depth);
  }
  generate_speed_section_label(
    label, hide_labels, inscription_depth, wing_length, section_height, wall_thickness, section_label_font_size, font
  );
}

// Generate an X-axis section (rotated 90 degrees)
module generate_speed_x_axis_section(
  label,
  wing_length,
  wing_thickness,
  section_height,
  wall_thickness,
  inscription_depth,
  section_label_font_size,
  font,
  hide_labels
) {
  rotate([0, 0, -90]) {
    mirror([1, 0, 0])
      difference() {
        generate_speed_basic_section(wing_length, wing_thickness, section_height, wall_thickness);
        generate_speed_section_front_cutout(section_height, wing_length, inscription_depth);
        generate_speed_section_rear_cutout(wing_length, wing_thickness, section_height, wall_thickness, inscription_depth);
      }
    translate([0, wing_length, 0])
      rotate([0, 0, 180])
        generate_speed_section_label(
          label, hide_labels, inscription_depth, wing_length, section_height, wall_thickness, section_label_font_size, font
        );
  }
}

// Generate all tower sections by iterating over each speed value
module generate_speed_tower_sections(
  starting_speed_value,
  speed_value_change_corrected,
  section_count,
  section_height,
  wing_length,
  wing_thickness,
  wall_thickness,
  inscription_depth,
  section_label_font_size,
  font,
  hide_labels
) {
  for (section_number = [0:section_count - 1]) {
    value = starting_speed_value + (speed_value_change_corrected * section_number);
    label = str(value);
    z_offset = section_number * section_height;
    translate([0, 0, z_offset]) {
      generate_speed_x_axis_section(
        label, wing_length, wing_thickness, section_height, wall_thickness,
        inscription_depth, section_label_font_size, font, hide_labels
      );
      generate_speed_y_axis_section(
        label, wing_length, wing_thickness, section_height, wall_thickness,
        inscription_depth, section_label_font_size, font, hide_labels
      );
    }
  }
}

/* [Main Model Generation Module] */

// Generates the speed tower based on provided parameters
module generate_speed_tower(
  // General Parameters
  tower_label = "",
  tower_description = "",
  starting_speed_value = 20,
  ending_speed_value = 100,
  speed_value_change = 20,
  wing_length = 50.001,
  wing_thickness = 3.001,
  base_height = 0.841,
  section_height = 8.401,
  base_font_size = 2.001,
  // Advanced Parameters
  hide_labels = false,
  font = "Arial:style=Bold",
  section_label_height_multiplier = 0.401,
  wall_thickness = 0.4001,
  section_font_height_multiplier = 0.333,
  inscription_depth = 0.201,
  iota = 0.001,
  // Viewport Parameters
  orient_for_screenshot = false,
  screenshot_vpd = 200.00,
  screenshot_vpf = 22.50,
  screenshot_vpr = [60.00, 0.00, 60.00],
  screenshot_vpt = [17.00, 15.00, 15.00]
) {
  /* [Calculated Parameters] */
  speed_value_change_corrected =
    ending_speed_value > starting_speed_value ? abs(speed_value_change)
    : -abs(speed_value_change);
  section_count = ceil(abs(ending_speed_value - starting_speed_value) / abs(speed_value_change) + 1);
  base_extension = base_font_size + wall_thickness * 2;
  section_label_font_size = (section_height - wall_thickness) * section_font_height_multiplier;

  /* [Generate the Model] */
  translate([-wing_length / 2, -wing_length / 2, 0]) {
    generate_speed_base(
      wing_length, wing_thickness, base_height, base_extension,
      base_font_size, font, hide_labels, inscription_depth,
      tower_label, tower_description
    );

    translate([0, 0, base_height])
      generate_speed_tower_sections(
        starting_speed_value,
        speed_value_change_corrected,
        section_count,
        section_height,
        wing_length,
        wing_thickness,
        wall_thickness,
        inscription_depth,
        section_label_font_size,
        font,
        hide_labels
      );
  }

  /* [Viewport Orientation] */
  $vpd = orient_for_screenshot ? screenshot_vpd : $vpd;
  $vpf = orient_for_screenshot ? screenshot_vpf : $vpf;
  $vpr = orient_for_screenshot ? screenshot_vpr : $vpr;
  $vpt = orient_for_screenshot ? screenshot_vpt : $vpt;
}
