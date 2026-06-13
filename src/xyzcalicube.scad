// src/xyzcalicube.scad
// XYZ Calibration Cube Library
// Version Author: Cameron K. Brooks

/* [General Parameters] */
// The size of the calibration cube
cube_size = 20;

/* [Calculated Parameters] */
// The value to use for creating the model preview (lower is faster)
preview_quality_value = 24;

// The value to use for creating the final model render (higher is more detailed)
render_quality_value = 48;

// Calculate the rendering quality
$fn = $preview ? preview_quality_value : render_quality_value;

/* [Main Model Generation Module] */

// Generates the XYZ calibration cube
module generate_xyz_cali_cube(cube_size = 20) {
  s = cube_size;
  // Scale all hard-coded offsets proportionally to cube_size
  sc = s / 20;

  rotate([0, 0, 180])
    difference() {
      cube([s, s, s], center=true);

      // X cut out
      difference() {
        union() {
          translate([0, 9.005 * sc, 0]) rotate([0, 55, 0]) cube([16 * sc, 2.01 * sc, 2 * sc], center=true);
          translate([0, 9.005 * sc, 0]) rotate([0, -55, 0]) cube([16 * sc, 2.01 * sc, 2 * sc], center=true);
        }
        translate([0, 8.5 * sc, 7 * sc]) cube([16 * sc, 3.5 * sc, 2 * sc], center=true);
        translate([0, 8.5 * sc, -7 * sc]) cube([16 * sc, 3.5 * sc, 2 * sc], center=true);
      }

      // Y cut out
      rotate([0, 0, 90])
        difference() {
          union() {
            translate([0, 9.005 * sc, 0]) rotate([0, 55, 0]) cube([16 * sc, 2.01 * sc, 2 * sc], center=true);
            translate([0, 9.005 * sc, 0]) rotate([0, -55, 0]) cube([16 * sc, 2.01 * sc, 2 * sc], center=true);
          }
          translate([0, 8.5 * sc, 7 * sc]) cube([16 * sc, 3.5 * sc, 2 * sc], center=true);
          translate([0, 8.5 * sc, -4 * sc]) cube([16 * sc, 3.5 * sc, 8 * sc], center=true);
        }
      translate([-9 * sc, 0, -2.9 * sc]) cube([2 * sc, 2.45 * sc, 6.2 * sc], center=true);

      // Z cut out
      rotate([90, 0, 0])
        intersection() {
          translate([0, 9.005 * sc, 0]) cube([11 * sc, 2.01 * sc, 12 * sc], center=true);
          union() {
            translate([0, 9.005 * sc, 5 * sc]) cube([11 * sc, 2.01 * sc, 2 * sc], center=true);
            translate([0, 9.005 * sc, -5 * sc]) cube([11 * sc, 2.01 * sc, 2 * sc], center=true);
            translate([0, 9.005 * sc, 0]) rotate([0, 45, 0]) cube([16 * sc, 2.01 * sc, 2 * sc], center=true);
          }
        }
    }
}
