#!/bin/sh
# Packages this fork into an installable XPI.
#
# There is no build step: the sources are plain ES modules that Thunderbird
# loads as they are. An XPI is just a zip whose manifest.json sits at the
# archive root, which is why this runs from the repo root and zips "." rather
# than zipping the directory from outside.
#
# To ship an update, raise "version" in manifest.json first - Thunderbird only
# treats an install as an upgrade if the version is higher. The format is at
# most 4 dot-separated integers, so keep using upstream's version plus a build
# number, e.g. 4.1.1.2.
set -e
cd "$(dirname "$0")"

version=$(python3 -c 'import json; print(json.load(open("manifest.json"))["version"])')
out="dist/thunderai-taki-${version}.xpi"

mkdir -p dist
rm -f "$out"

# Excluded: version control, CI config, and the docs that only matter to
# someone working on the source. LICENSE and README.md stay in, since the
# GPL wants the license and the "this is a modified version" notice shipped
# with the thing people install.
zip -r -q -FS "$out" . \
  -x '.git/*' '.github/*' '.gitignore' 'claude-spec/*' 'CLAUDE.md' 'dist/*' '*.DS_Store' 'build-xpi.sh'

echo "$out"
