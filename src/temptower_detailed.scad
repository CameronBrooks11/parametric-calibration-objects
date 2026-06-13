// src/temptower_detailed.scad
// Detailed Temperature Tower Generator Library
// Original author: Brad Kartchner
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// The label to add to the tower
tower_label = "";

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
// The thickness of walls in the tower
wall_thickness = 0.601;

// The font to use for tower text
font = "Arial:style=Bold";

// Should sections be labeled?
label_sections = true;

// The amount to expand the tower base beyond the outline of each section
base_extension = 2.404;

// The angle of the left slope of each section
left_slope_angle = 35;

// The angle of the right slope of each section
right_slope_angle = 45;

// The height of the section labels in relation to the height of each section
section_label_height_multiplier = 0.401;

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

// Generate a sloped triangular end piece with an optional hole
module generate_temp_detailed_slope_end(
  slope_width,
  section_height,
  section_length,
  hole_diameter,
  wall_thickness
) {
  hole_inset = hole_diameter / 2 + wall_thickness * 2;
  hole_height = section_height * 2;
  points = [
    [0, 0],
    [0, section_height],
    [-slope_width, section_height],
  ];
  difference() {
    rotate([90, 0, 0])
      linear_extrude(section_length, center=true)
        polygon(points=points);
    translate([-slope_width + hole_inset, 0, section_height / 2 - hole_height / 2])
      cylinder(d=hole_diameter, hole_height);
  }
}

// Generate the left slope end
module generate_temp_detailed_left_slope_end(
  section_height,
  section_length,
  hole_diameter,
  wall_thickness,
  left_slope_width
) {
  generate_temp_detailed_slope_end(left_slope_width, section_height, section_length, hole_diameter, wall_thickness);
}

// Generate the curved point at the top of the left compartment
module generate_temp_detailed_curved_point(section_height, section_length) {
  height = section_height / 2;
  width = height;
  translate([0, 0, height / 2])
    rotate([90, 0, 0])
      linear_extrude(section_length, center=true)
        intersection() {
          translate([0, -height])
            square([width, height]);
          circle(r=height);
        }
}

// Generate the curved inner wall of the left compartment
module generate_temp_detailed_curved_wall(section_length, left_compartment_width, wall_thickness) {
  width = left_compartment_width / 2 - wall_thickness;
  height = width;
  rotate([90, 0, 0])
    linear_extrude(section_length, center=true)
      difference() {
        translate([-width, 0])
          square([width, height]);
        translate([-width, 0])
          circle(r=width);
      }
}

// Generate the left compartment with curved interior features
module generate_temp_detailed_left_compartment(
  section_height,
  section_length,
  left_compartment_width,
  wall_thickness,
  hole_diameter
) {
  outer_width = left_compartment_width;
  outer_height = section_height;
  inner_width = outer_width - wall_thickness * 3;
  inner_height = outer_height - wall_thickness * 3;
  hole_length = outer_width / 2;

  difference() {
    union() {
      translate([-outer_width, -section_length / 2, 0])
        difference() {
          cube([outer_width, section_length, outer_height]);
          translate([wall_thickness * 2, wall_thickness, wall_thickness * 2])
            cube([inner_width, section_length, inner_height]);
        }
      translate([-inner_width - wall_thickness, 0, section_height / 2 + wall_thickness / 2])
        generate_temp_detailed_curved_point(section_height, section_length);
      translate([-wall_thickness, 0, 0])
        generate_temp_detailed_curved_wall(section_length, left_compartment_width, wall_thickness);
    }
    translate([0, 0, outer_height / 2])
      rotate([0, 90, 0])
        cylinder(d=hole_diameter, h=hole_length, center=true);
  }
}

// Generate the right slope end (mirrored)
module generate_temp_detailed_right_slope_end(
  section_height,
  section_length,
  hole_diameter,
  wall_thickness,
  right_slope_width
) {
  mirror([1, 0, 0])
    generate_temp_detailed_slope_end(right_slope_width, section_height, section_length, hole_diameter, wall_thickness);
}

// Generate the right compartment with conical spikes
module generate_temp_detailed_right_compartment(
  section_length,
  right_compartment_width,
  section_height,
  wall_thickness,
  spike_height,
  wide_spike_diameter,
  thin_spike_diameter,
  iota
) {
  outer_width = right_compartment_width;
  outer_height = section_height;
  inner_width = outer_width - wall_thickness * 2;
  inner_height = outer_height - wall_thickness;

  rotate([90, 0, 0])
    linear_extrude(section_length, center=true)
      difference() {
        square([outer_width, outer_height]);
        square([inner_width, inner_height]);
      }

  translate([wide_spike_diameter / 2 + wall_thickness, 0])
    cylinder(h=spike_height, d1=wide_spike_diameter, d2=iota);

  translate([inner_width - thin_spike_diameter / 2 - wall_thickness, 0])
    cylinder(h=spike_height, d1=thin_spike_diameter, d2=iota);
}

// Generate the horizontal inset grooves on the front and back of a section
module generate_temp_detailed_section_inset_cutout(section_width, section_length, wall_thickness, label_depth) {
  width = section_width * 4;
  for (y_mirror = [0, 1])
    mirror([0, y_mirror, 0])
      translate([-width / 2, section_length / 2 - label_depth, 0])
        cube([width, wall_thickness, wall_thickness]);
}

// Generate the label cutout for a section
module generate_temp_detailed_label_cutout(label, section_label_font_size, font, wall_thickness, label_depth) {
  rotate([90, 0, 0])
    translate([0, 0, -label_depth])
      linear_extrude(wall_thickness)
        text(
          text=label,
          size=section_label_font_size,
          font=font,
          halign="center",
          valign="center"
        );
}

// Generate a single section of the detailed tower
module generate_temp_detailed_section(
  label,
  section_height,
  section_length,
  left_slope_width,
  left_compartment_width,
  right_slope_width,
  right_compartment_width,
  wall_thickness,
  hole_diameter,
  spike_height,
  wide_spike_diameter,
  thin_spike_diameter,
  section_width,
  label_depth,
  section_label_font_size,
  font,
  iota,
  label_sections
) {
  difference() {
    union() {
      translate([-left_compartment_width, 0])
        generate_temp_detailed_left_slope_end(
          section_height, section_length, hole_diameter, wall_thickness, left_slope_width
        );
      generate_temp_detailed_left_compartment(
        section_height, section_length, left_compartment_width, wall_thickness, hole_diameter
      );
      translate([right_compartment_width, 0])
        generate_temp_detailed_right_slope_end(
          section_height, section_length, hole_diameter, wall_thickness, right_slope_width
        );
      generate_temp_detailed_right_compartment(
        section_length, right_compartment_width, section_height, wall_thickness,
        spike_height, wide_spike_diameter, thin_spike_diameter, iota
      );
    }
    generate_temp_detailed_section_inset_cutout(section_width, section_length, wall_thickness, label_depth);
    if (label_sections)
      translate([-left_compartment_width / 2, -section_length / 2, section_height / 2])
        generate_temp_detailed_label_cutout(label, section_label_font_size, font, wall_thickness, label_depth);
  }
}

// Generate the tower inscription carved into the base
module generate_temp_detailed_tower_inscription(
  tower_label,
  font,
  section_label_font_size,
  wall_thickness,
  label_depth
) {
  rotate([0, 0, -90])
    translate([0, 0, -label_depth])
      linear_extrude(wall_thickness)
        text(
          text=tower_label,
          font=font,
          size=section_label_font_size,
          halign="center",
          valign="center"
        );
}

// Generate the base of the tower with an inscribed label
module generate_temp_detailed_base(
  base_width,
  base_length,
  base_height,
  tower_label,
  font,
  section_label_font_size,
  left_slope_width,
  wall_thickness,
  label_depth
) {
  difference() {
    linear_extrude(base_height)
      square([base_width, base_length], center=true);
    translate([-base_width / 2 + left_slope_width / 2, 0, base_height])
      generate_temp_detailed_tower_inscription(
        tower_label, font, section_label_font_size, wall_thickness, label_depth
      );
  }
}

// Generate all tower sections by iterating over each value
module generate_temp_detailed_tower_sections(
  starting_value,
  value_change_corrected,
  section_count,
  section_height,
  section_length,
  left_slope_width,
  left_compartment_width,
  right_slope_width,
  right_compartment_width,
  wall_thickness,
  hole_diameter,
  spike_height,
  wide_spike_diameter,
  thin_spike_diameter,
  section_width,
  label_depth,
  section_label_font_size,
  font,
  iota,
  label_sections
) {
  for (section = [0:section_count - 1]) {
    value = starting_value + (value_change_corrected * section);
    z_offset = section * section_height;
    translate([0, 0, z_offset])
      generate_temp_detailed_section(
        str(value),
        section_height,
        section_length,
        left_slope_width,
        left_compartment_width,
        right_slope_width,
        right_compartment_width,
        wall_thickness,
        hole_diameter,
        spike_height,
        wide_spike_diameter,
        thin_spike_diameter,
        section_width,
        label_depth,
        section_label_font_size,
        font,
        iota,
        label_sections
      );
  }
}

/* [Main Model Generation Module] */

// Generates the detailed temperature tower based on provided parameters
module generate_temp_tower_detailed(
  // General Parameters
  tower_label = "",
  section_label_prefix = "",
  section_label_suffix = "",
  starting_value = 220,
  ending_value = 180,
  value_change = -5,
  base_height = 0.801,
  section_height = 8.001,
  // Advanced Parameters
  wall_thickness = 0.601,
  font = "Arial:style=Bold",
  label_sections = true,
  base_extension = 2.404,
  left_slope_angle = 35,
  right_slope_angle = 45,
  section_label_height_multiplier = 0.401,
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
  section_length = section_height;
  left_slope_width = section_height / tan(left_slope_angle);
  left_compartment_width = section_height * 2;
  right_slope_width = section_height / tan(right_slope_angle);
  section_width = (left_compartment_width + left_slope_width) * 2;
  right_compartment_width = section_width / 2 - right_slope_width;
  spike_height = section_height - wall_thickness * 2;
  wide_spike_diameter = section_length * 0.75;
  thin_spike_diameter = section_length * 0.50;
  hole_diameter = section_length / 4;
  base_width = section_width + base_extension * 2;
  base_length = section_length + base_extension * 2;
  section_label_font_size = section_height * section_label_height_multiplier;
  label_depth = wall_thickness / 2;

  /* [Generate the Model] */
  generate_temp_detailed_base(
    base_width,
    base_length,
    base_height,
    tower_label,
    font,
    section_label_font_size,
    left_slope_width,
    wall_thickness,
    label_depth
  );

  translate([0, 0, base_height])
    generate_temp_detailed_tower_sections(
      starting_value,
      value_change_corrected,
      section_count,
      section_height,
      section_length,
      left_slope_width,
      left_compartment_width,
      right_slope_width,
      right_compartment_width,
      wall_thickness,
      hole_diameter,
      spike_height,
      wide_spike_diameter,
      thin_spike_diameter,
      section_width,
      label_depth,
      section_label_font_size,
      font,
      iota,
      label_sections
    );

  /* [Viewport Orientation] */
  $vpd = orient_for_screenshot ? screenshot_vpd : $vpd;
  $vpf = orient_for_screenshot ? screenshot_vpf : $vpf;
  $vpr = orient_for_screenshot ? screenshot_vpr : $vpr;
  $vpt = orient_for_screenshot ? screenshot_vpt : $vpt;
}
