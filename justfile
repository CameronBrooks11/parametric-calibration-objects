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
