#!/bin/sh

TARGET="$1"
VER="$2"
MINIFY_FLAGS="--html-keep-document-tags --html-keep-whitespace --recursive --verbose"

if [ -z "$TARGET" -o -z "$VER" ]; then
  echo "Usage: $0 <target> <ver>"
  echo "Either <target> or <ver> is missing. Exiting."
  exit 1
fi

if ! [ -d "$TARGET" ]; then
  echo "Target directory $TARGET does not exist. Exiting."
  exit 1
fi

# Backwards compatibility
if [ -f /scripts/minify ]
then
  MINIFY_BIN=/scripts/minify
elif hash minify 2>/dev/null
then
  MINIFY_BIN=$(which minify)
elif hash docker 2>/dev/null
then
  MINIFY_BIN="docker run -t -v ${PWD}:/gitlab -w /gitlab --rm tdewolff/minify minify"
else
  echo "  ✖ ERROR: 'minify' not found. Install 'minify' or Docker to proceed." >&2
  exit 1
fi

# Minify assets
printf "Optimizing assets...\n"

printf "HTML..."; $MINIFY_BIN $MINIFY_FLAGS --type=html --match=\.html -o ${TARGET}/${VER}/ ${TARGET}/${VER}/ || true
printf "CSS..." ; $MINIFY_BIN $MINIFY_FLAGS --type=css  --match=\.css  -o ${TARGET}/${VER}/ ${TARGET}/${VER}/ || true
printf "JSON..."; $MINIFY_BIN $MINIFY_FLAGS --type=json --match=\.json -o ${TARGET}/${VER}/ ${TARGET}/${VER}/ || true
printf "SVG..." ; $MINIFY_BIN $MINIFY_FLAGS --type=svg  --match=\.svg  -o ${TARGET}/${VER}/ ${TARGET}/${VER}/ || true

echo "Done"
