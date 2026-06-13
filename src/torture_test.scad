// src/torture_test.scad
// Torture Test Generator Library
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// The thickness of bars in the model
bar_thickness = 5;

// The overall size of the cube
cube_length = 80;

// The thickness of the base
base_thickness = 4;

// The base diameter as a proportion of cube_length
base_scale = 1.1;

/* [Calculated Parameters] */
// The value to use for creating the model preview (lower is faster)
preview_quality_value = 32;

// The value to use for creating the final model render (higher is more detailed)
render_quality_value = 64;

// Calculate the rendering quality
$fn = $preview ? preview_quality_value : render_quality_value;

/* [Helper Modules] */

module generate_torture_bar(bar_thickness, cube_length) {
  rotate([0, 90, 0])
    translate([0, 0, -cube_length / 2])
      cylinder(d=bar_thickness, h=cube_length);
}

module generate_torture_horiz_cube(bar_thickness, cube_length) {
  half_length = cube_length / 2;
  steps = [-half_length, 0, half_length];
  for (s1 = steps) {
    for (s2 = steps) {
      translate([0, s1, s2]) generate_torture_bar(bar_thickness, cube_length);
      translate([s1, s2, 0]) rotate([0, 90, 0]) generate_torture_bar(bar_thickness, cube_length);
      translate([s1, 0, s2]) rotate([0, 0, 90]) generate_torture_bar(bar_thickness, cube_length);
    }
  }
  end_steps = [-half_length, half_length];
  for (s1 = end_steps) {
    for (s2 = end_steps) {
      for (s3 = end_steps) {
        translate([s1, s2, s3]) sphere(d=bar_thickness);
      }
    }
  }
}

module generate_torture_tilted_cube(bar_thickness, cube_length) {
  half_length = cube_length / 2;
  rotate([atan(sqrt(1 / 2)), 0, 0])
    rotate([0, -45, 0])
      translate([half_length, half_length, half_length])
        generate_torture_horiz_cube(bar_thickness, cube_length);
}

module generate_torture_clipped_cube(bar_thickness, cube_length) {
  half_length = cube_length / 2;
  dz = half_length / 2 / sin(90 - atan(sqrt(1 / 2)));
  difference() {
    translate([0, 0, -dz])
      generate_torture_tilted_cube(bar_thickness, cube_length);
    translate([-cube_length, -cube_length, -2 * cube_length])
      cube([2 * cube_length, 2 * cube_length, 2 * cube_length]);
  }
}

/* [Main Model Generation Module] */

// Generates the torture test model
module generate_torture_test(
  bar_thickness = 5,
  cube_length = 80,
  base_thickness = 4,
  base_scale = 1.1
) {
  eps1 = 0.01;
  rotate([0, 0, 90]) {
    translate([0, 0, base_thickness - eps1])
      generate_torture_clipped_cube(bar_thickness, cube_length);
    cylinder(d=cube_length * base_scale, h=base_thickness, $fn=4 * $fn);
  }
}
