// examples/torture_test_example.scad

include <../src/torture_test.scad>;

/* [User Parameters] */

// The thickness of bars in the model
bar_thickness = 5;

// The overall size of the cube
cube_length = 80;

// The thickness of the base
base_thickness = 4;

// The base diameter as a proportion of cube_length
base_scale = 1.1;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 32;
render_quality_value = 64; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the Torture Test] */

generate_torture_test(
  bar_thickness=bar_thickness,
  cube_length=cube_length,
  base_thickness=base_thickness,
  base_scale=base_scale
);
