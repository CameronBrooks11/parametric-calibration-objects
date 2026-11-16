# Show the recipes
default:
    @just --list

# Render every example, failing on an OpenSCAD warning or an empty model
test:
    #!/usr/bin/env bash
    set -euo pipefail
    mapfile -t files < <(find examples -name '*.scad' | sort)
    [ "${#files[@]}" -gt 0 ] || { echo "no examples found"; exit 1; }
    for f in "${files[@]}"; do
      echo "render $f"
      log=$(openscad --hardwarnings --export-format binstl -o /dev/null "$f" 2>&1) || { echo "$log"; exit 1; }
    done
    echo "rendered ${#files[@]} examples"

# Render the README pictures into images/ (needs ImageMagick)
images:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT
    mkdir -p images
    # shot FILE NAME [OPENSCAD ARGS...]: render one example, trimmed to the model
    shot() {
      local f=$1 n=$2; shift 2
      openscad --render --autocenter --viewall --imgsize=1600,1200 --colorscheme=Tomorrow "$@" -o "$tmp/$n.png" "$f" >/dev/null 2>&1
      magick "$tmp/$n.png" -trim +repage "$tmp/$n.png"
    }
    sheet() {  # sheet OUT COLUMNS NAME=LABEL...
      local out=$1 cols=$2; shift 2
      local args=()
      for p in "$@"; do args+=(-label "${p#*=}" "$tmp/${p%%=*}.png"); done
      magick montage "${args[@]}" -resize 600x600 -geometry +24+24 -tile "${cols}x" \
        -background '#f8f8f8' -pointsize 22 "$out"
      # 128 colours, undithered: a third to a half the size, no visible banding
      magick "$out" -dither None -colors 128 -define png:compression-level=9 "$out"
    }
    t=examples
    shot $t/temptower_examples/temptower_example.scad temp
    shot $t/temptower_examples/temptower_detailed_example.scad temp_detailed
    shot $t/retracttower_examples/retracttower_example.scad retract
    shot $t/flowtower_examples/flowtower_example.scad flow
    shot $t/speedtower_examples/speedtower_example.scad speed
    sheet images/towers.png 5 "temp=Temperature" "temp_detailed=Detailed temperature" \
      "retract=Retraction" "flow=Flow" "speed=Speed"
    b=$t/bedlevelpattern_examples
    for p in concentric_squares spiral_squares concentric_circles x_in_square circle_in_square grid padded_grid five_circles; do
      shot $b/blp_${p}_example.scad $p --camera 0,0,0,0,0,0,0 --projection=ortho
    done
    sheet images/bed-level-patterns.png 4 "concentric_squares=Concentric squares" \
      "spiral_squares=Spiral squares" "concentric_circles=Concentric circles" "x_in_square=X in square" \
      "circle_in_square=Circle in square" "grid=Grid" "padded_grid=Padded grid" "five_circles=Five circles"
    shot $t/xyzcalicube_examples/xyzcalicube_example.scad cube
    shot $t/torture_test_examples/torture_test_example.scad torture
    sheet images/cube-and-torture-test.png 2 "cube=XYZ calibration cube" "torture=Torture test"
