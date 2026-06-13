// examples/retracttower_examples/retracttower_example.scad

include <../../src/retracttower.scad>;

/* [User Parameters] */

// Set your desired parameters here
tower_label = "";
column_label = "";
section_label_prefix = "";
section_label_suffix = "mm";
starting_value = 1.0;
ending_value = 6.0;
value_change = 1.0;
base_height = 0.801;
section_height = 8.001;
font = "Arial:style=Bold";
label_sections = true;
section_label_height_multiplier = 0.401;
tower_label_height_multiplier = 0.601;
column_label_height_multiplier = 0.301;
column_label_letter_spacing_multiplier = 1.001;
wall_thickness = 0.601;
tower_width_multiplier = 5.001;
iota = 0.001;
orient_for_screenshot = false;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 24;
render_quality_value = 48; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the Retract Tower] */

generate_retract_tower(
  tower_label=tower_label,
  column_label=column_label,
  section_label_prefix=section_label_prefix,
  section_label_suffix=section_label_suffix,
  starting_value=starting_value,
  ending_value=ending_value,
  value_change=value_change,
  base_height=base_height,
  section_height=section_height,
  font=font,
  label_sections=label_sections,
  section_label_height_multiplier=section_label_height_multiplier,
  tower_label_height_multiplier=tower_label_height_multiplier,
  column_label_height_multiplier=column_label_height_multiplier,
  column_label_letter_spacing_multiplier=column_label_letter_spacing_multiplier,
  wall_thickness=wall_thickness,
  tower_width_multiplier=tower_width_multiplier,
  iota=iota,
  orient_for_screenshot=orient_for_screenshot
);
