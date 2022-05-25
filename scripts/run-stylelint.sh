#!/usr/bin/env bash

STYLESHEETS="content/assets/stylesheets/*.scss"
MIXINS_STYLESHEETS="content/assets/stylesheets/mixins/*.scss"
ALL_STYLESHEETS="content/assets/stylesheets/*.scss content/assets/stylesheets/mixins/*.scss"

# Preseve original content in temporary files and then strip YAML frontmatter from stylesheets
for stylesheet in $ALL_STYLESHEETS; do
  cp "$stylesheet" "$stylesheet-tmp"
  tail -n +5 "$stylesheet-tmp" > "$stylesheet"
done

yarn stylelint "$STYLESHEETS"
yarn stylelint "$MIXINS_STYLESHEETS"

# Restore original contents of stylesheets
for stylesheet in $ALL_STYLESHEETS; do
  mv "$stylesheet-tmp" "$stylesheet"
done
