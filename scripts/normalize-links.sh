#!/bin/sh

TARGET="$1"
VER="$2"

if [ -z "$TARGET" ]; then
  echo "Usage: $0 <target> <version>"
  echo "No target provided. Exiting."
  exit 1
fi

if [ -z "$VER" ]; then
  echo "Usage: $0 <target> <version>"
  echo "No version provided. Exiting."
  exit 1
fi

if ! [ -d "$TARGET/$VER" ]; then
  echo "Target directory $TARGET/$VER does not exist. Exiting."
  exit 1
fi

# Fix relative links for archive
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#="/ce/#/'"$VER"'/ce/#g'
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#="/ee/#/'"$VER"'/ee/#g'
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#="/runner/#/'"$VER"'/runner/#g'
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#="/omnibus/#/'"$VER"'/omnibus/#g'
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#="/assets/#/'"$VER"'/assets/#g'
find ${TARGET} -type f -name '*.html' -print0 | xargs -0 sed -i 's#<a href="/">#<a href="/'"$VER"'/">#g'

# Symlink all README.html to index.html
for i in `find ${TARGET}/${VER} -name README.html`; do ln -sf README.html $(dirname $i)/index.html; done
