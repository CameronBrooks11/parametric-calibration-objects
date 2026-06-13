# Utility Model Reference

---

## generate_xyz_cali_cube

**File:** `src/xyzcalicube.scad` | **Example:** `examples/xyzcalicube_example.scad`

A 20 mm XYZ calibration cube with X, Y, and Z letters cut into the corresponding
faces. Useful for verifying dimensional accuracy and axis orientation.

```scad
include <src/xyzcalicube.scad>;
generate_xyz_cali_cube(cube_size = 20);
```

| Parameter   | Default | Description                  |
| ----------- | ------- | ---------------------------- |
| `cube_size` | `20`    | Side length of the cube (mm) |

Note: letter geometry is scaled proportionally to `cube_size` from the 20 mm
reference design. For best results use the default 20 mm.

---

## generate_torture_test

**File:** `src/torture_test.scad` | **Example:** `examples/torture_test_example.scad`

A structural torture test model: a wire-frame cube tilted onto its corner,
clipped to a flat base plane, and mounted on a circular platform. Tests
overhangs, bridging, fine struts, and unsupported geometry simultaneously.

```scad
include <src/torture_test.scad>;
generate_torture_test();
```

| Parameter        | Default | Description                                  |
| ---------------- | ------- | -------------------------------------------- |
| `bar_thickness`  | `5`     | Diameter of the wire-frame bars (mm)         |
| `cube_length`    | `80`    | Overall bounding size of the cube (mm)       |
| `base_thickness` | `4`     | Thickness of the circular base (mm)          |
| `base_scale`     | `1.1`   | Base diameter as a multiple of `cube_length` |

Reference: [Printables model 188769](https://www.printables.com/model/188769-customizable-torture-tes/files)
