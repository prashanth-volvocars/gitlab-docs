#!/bin/sh

TARGET="$1"
VER="$2"
MINIFY_FLAGS="--html-keep-document-tags --html-keep-whitespace --recursive"

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

printf "HTML..."; /scripts/minify $MINIFY_FLAGS --type=html --match=\.html -o ${TARGET}/${VER}/ ${TARGET}/${VER} || true
printf "CSS..." ; /scripts/minify $MINIFY_FLAGS --type=css  --match=\.css  -o ${TARGET}/${VER}/ ${TARGET}/${VER} || true
printf "JSON..."; /scripts/minify $MINIFY_FLAGS --type=json --match=\.json -o ${TARGET}/${VER}/ ${TARGET}/${VER} || true
printf "SVG..." ; /scripts/minify $MINIFY_FLAGS --type=svg  --match=\.svg  -o ${TARGET}/${VER}/ ${TARGET}/${VER} || true

echo "Done"
