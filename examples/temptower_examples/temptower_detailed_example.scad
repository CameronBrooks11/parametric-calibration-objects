// examples/temptower_examples/temptower_detailed_example.scad

include <../../src/temptower_detailed.scad>;

/* [User Parameters] */

// Set your desired parameters here
tower_label = "Temp Tower";
section_label_prefix = "";
section_label_suffix = "C";
starting_value = 220;
ending_value = 180;
value_change = -5;
base_height = 0.801;
section_height = 8.001;
wall_thickness = 0.601;
font = "Arial:style=Bold";
label_sections = true;
base_extension = 2.404;
left_slope_angle = 35;
right_slope_angle = 45;
section_label_height_multiplier = 0.401;
iota = 0.001;
orient_for_screenshot = false;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 24;
render_quality_value = 48; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the Detailed Temp Tower] */

generate_temp_tower_detailed(
  tower_label=tower_label,
  section_label_prefix=section_label_prefix,
  section_label_suffix=section_label_suffix,
  starting_value=starting_value,
  ending_value=ending_value,
  value_change=value_change,
  base_height=base_height,
  section_height=section_height,
  wall_thickness=wall_thickness,
  font=font,
  label_sections=label_sections,
  base_extension=base_extension,
  left_slope_angle=left_slope_angle,
  right_slope_angle=right_slope_angle,
  section_label_height_multiplier=section_label_height_multiplier,
  iota=iota,
  orient_for_screenshot=orient_for_screenshot
);
