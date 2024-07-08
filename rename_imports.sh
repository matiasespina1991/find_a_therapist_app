#!/bin/bash


if [ -z "$1" ]; then
  echo "Usage: ./rename_imports.sh new_package_name"
  exit 1
fi

NEW_PACKAGE_NAME=$1

grep -rl 'package:template_app' . | while read -r file; do
  sed -i '' "s/package:find_a_therapist_app/package:${NEW_PACKAGE_NAME}/g" "$file"
done

echo "All occurrences of 'package:find_a_therapist_app' have been replaced with 'package:${NEW_PACKAGE_NAME}'."
