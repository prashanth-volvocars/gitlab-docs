for FILE in $(git ls-files ./$1/*.png ./$1/**/*.gif ./$1/**/*.jpg ./$1/**/*.md); do
    git grep $(basename "$FILE") > /dev/null || echo "Unlinked file: $FILE"
done
