# Documentation Index

parametric-calibration-objects is a library of parametric OpenSCAD modules for
calibrating and benchmarking 3D printers. Each `src/` file is a pure library --
no geometry is generated on `include`, only on an explicit module call.

The library covers three broad categories: calibration towers (temperature,
retraction, flow, speed), bed levelling patterns, and standalone geometry
models. Ready-to-use example files for every module are provided in `examples/`.

## Contents

| Document | Description |
|---|---|
| [usage.md](usage.md) | How to include and call modules, quality settings, common parameters |
| [towers.md](towers.md) | Parameter reference for all five tower generators |
| [bed-level-pattern.md](bed-level-pattern.md) | Parameter reference for the bed level pattern module |
| [utility-models.md](utility-models.md) | Parameter reference for XYZ calibration cube and torture test |
