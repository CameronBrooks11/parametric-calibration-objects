// examples/xyzcalicube_example.scad

include <../src/xyzcalicube.scad>;

/* [User Parameters] */

// The size of the calibration cube
cube_size = 20;

/* [Quality Settings] */

// Set the rendering quality
preview_quality_value = 24;
render_quality_value = 48; // Increase for higher detail

$fn = $preview ? preview_quality_value : render_quality_value;

/* [Generate the XYZ Calibration Cube] */

generate_xyz_cali_cube(
    cube_size = cube_size
);
