// examples/flowtower_examples/flowtower_example.scad

include <../../src/flowtower.scad>;

/* [User Parameters] */

// Set your desired parameters here
tower_label = "Flow Tower";
tower_secondary_label = "Calibration";
section_label_prefix = "";
section_label_suffix = "%";
starting_value = 115;
ending_value = 85;
value_change = -5;
base_height = 0.841;
section_size = 8.401;
section_hole_diameter = 4.201;
font = "Arial:style=Bold";
label_sections = true;
section_label_height_multiplier = 0.401;
tower_label_height_multiplier = 0.601;
tower_secondary_label_height_multiplier = 0.401;
wall_thickness = 0.601;
iota = 0.001;
orient_for_screenshot = false;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 24;
render_quality_value = 48; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the Flow Tower] */

generate_flow_tower(
  tower_label=tower_label,
  tower_secondary_label=tower_secondary_label,
  section_label_prefix=section_label_prefix,
  section_label_suffix=section_label_suffix,
  starting_value=starting_value,
  ending_value=ending_value,
  value_change=value_change,
  base_height=base_height,
  section_size=section_size,
  section_hole_diameter=section_hole_diameter,
  font=font,
  label_sections=label_sections,
  section_label_height_multiplier=section_label_height_multiplier,
  tower_label_height_multiplier=tower_label_height_multiplier,
  tower_secondary_label_height_multiplier=tower_secondary_label_height_multiplier,
  wall_thickness=wall_thickness,
  iota=iota,
  orient_for_screenshot=orient_for_screenshot
);
