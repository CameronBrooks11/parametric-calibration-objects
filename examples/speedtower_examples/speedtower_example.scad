// examples/speedtower_examples/speedtower_example.scad

include <../../src/speedtower.scad>;

/* [User Parameters] */

// Set your desired parameters here
tower_label = "Speed Tower";
tower_description = "Calibration";
starting_speed_value = 20;
ending_speed_value = 100;
speed_value_change = 20;
wing_length = 50.001;
wing_thickness = 3.001;
base_height = 0.841;
section_height = 8.401;
base_font_size = 2.001;
hide_labels = false;
font = "Arial:style=Bold";
section_label_height_multiplier = 0.401;
wall_thickness = 0.4001;
section_font_height_multiplier = 0.333;
inscription_depth = 0.201;
iota = 0.001;
orient_for_screenshot = false;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 24;
render_quality_value = 48; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the Speed Tower] */

generate_speed_tower(
  tower_label=tower_label,
  tower_description=tower_description,
  starting_speed_value=starting_speed_value,
  ending_speed_value=ending_speed_value,
  speed_value_change=speed_value_change,
  wing_length=wing_length,
  wing_thickness=wing_thickness,
  base_height=base_height,
  section_height=section_height,
  base_font_size=base_font_size,
  hide_labels=hide_labels,
  font=font,
  section_label_height_multiplier=section_label_height_multiplier,
  wall_thickness=wall_thickness,
  section_font_height_multiplier=section_font_height_multiplier,
  inscription_depth=inscription_depth,
  iota=iota,
  orient_for_screenshot=orient_for_screenshot
);
