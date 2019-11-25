#!/bin/sh

TARGET="$1"
VER="$2"

if [ -z "$TARGET" -o -z "$VER" ]; then
  echo "Usage: $0 <target> <ver>"
  echo "Either <target> or <ver> is missing. Exiting."
  exit 1
fi

if ! [ -d "$TARGET" ]; then
  echo "Target directory $TARGET does not exist. Exiting."
  exit 1
fi

# Minify assets
printf "Optimizing assets..."

printf "HTML..."; /scripts/minify -r --type=html --match=\.html -o ${TARGET}/ ${TARGET} || true
printf "CSS..." ; /scripts/minify -r --type=css  --match=\.css  -o ${TARGET}/ ${TARGET} || true
printf "JSON..."; /scripts/minify -r --type=json --match=\.json -o ${TARGET}/ ${TARGET} || true
printf "SVG..." ; /scripts/minify -r --type=svg  --match=\.svg  -o ${TARGET}/ ${TARGET} || true
printf "XML..." ; /scripts/minify -r --type=xml  --match=\.xml  -o ${TARGET}/ ${TARGET} || true

echo "Done"
