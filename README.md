# parametric-calibration-objects

A library of parametric OpenSCAD calibration objects for 3D printers. Each file
in `src/` is a reusable library module -- no geometry is generated on `include`,
only on an explicit module call. Example entry points live in `examples/`.

## Modules

| Module | File | Description |
|---|---|---|
| `generate_bed_level_pattern(...)` | `src/bedlevelpattern.scad` | Bed levelling test patterns (8 pattern types) |
| `generate_flow_tower(...)` | `src/flowtower.scad` | Flow / extrusion multiplier calibration tower |
| `generate_temp_tower(...)` | `src/temptower.scad` | Temperature calibration tower (bridged style) |
| `generate_temp_tower_detailed(...)` | `src/temptower_detailed.scad` | Temperature tower with detailed section geometry |
| `generate_retract_tower(...)` | `src/retracttower.scad` | Retraction distance calibration tower |
| `generate_speed_tower(...)` | `src/speedtower.scad` | Print speed calibration tower (L-shaped, XY axes) |
| `generate_xyz_cali_cube(...)` | `src/xyzcalicube.scad` | 20 mm XYZ calibration cube |
| `generate_torture_test(...)` | `src/torture_test.scad` | Structural torture test model |

Full parameter reference: [docs/README.md](docs/README.md)

## Usage

Each library module is used with `include` + a module call. Example:

```scad
include <src/temptower.scad>;

generate_temp_tower(
    tower_label = "Temp",
    starting_value = 220,
    ending_value = 180,
    value_change = -5
);
```

Ready-to-use example files for every module are provided in `examples/`:

```
examples/
  bedlevelpattern_examples/   -- bed level pattern examples (8 patterns + showcase)
  flowtower_examples/         -- flow tower example
  retracttower_examples/      -- retraction tower example
  speedtower_examples/        -- speed tower example
  temptower_examples/         -- temperature tower examples (standard + detailed)
  xyzcalicube_example.scad
  torture_test_example.scad
```

## Quality / rendering

All examples set `$fn` based on `$preview`:

```scad
$fn = $preview ? preview_quality_value : render_quality_value;
```

Lower values render faster in preview; increase `render_quality_value` before
exporting for final STL output.

## References

- Inspiration: [All3DP bed levelling article](https://all3dp.com/2/ender-3-pro-bed-leveling-gcode/)
- Tower generator inspiration: [AutoTowersGenerator](https://github.com/kartchnb/AutoTowersGenerator)
- Torture test reference: [Printables model 188769](https://www.printables.com/model/188769-customizable-torture-tes/files)
- Original authors: Brad Kartchner
- Library refactor: Cameron K. Brooks

