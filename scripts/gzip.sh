#!/bin/sh

echo "Minify and compress the static assets (HTML, CSS, JS)..."
echo

# Calculate sizes before minifying the static files (HTML, CSS, JS)
SIZE_BEFORE=$(du -sh public/ | awk '{print $1}')

# Minify the assets of the resulting site
./scripts/minify-assets.sh ./ public/

# Calculate sizes after minifying the static files (HTML, CSS, JS)
SIZE_AFTER_MINIFY=$(du -sh public/ | awk '{print $1}')

# Use gzip to compress static content for faster web serving
# https://docs.gitlab.com/ee/user/project/pages/introduction.html#serving-compressed-assets
find public/ -type f \( -iname "*.html" -o -iname "*.js"  -o -iname "*.css"  -o -iname "*.svg" \) -exec gzip --keep --best --force --verbose {} \;

# Calculate sizes after gzipping the static files (HTML, CSS, JS)
SIZE_AFTER_GZIP=$(du -sh public/ | awk '{print $1}')

# Print size results
echo
echo -e "Size before minifying and gzipping ..... $SIZE_BEFORE\nSize after minifying ................... $SIZE_AFTER_MINIFY\nSize after adding gzipped versions ..... $SIZE_AFTER_GZIP"
