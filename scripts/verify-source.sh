#!/usr/bin/env sh
set -eu

EXPECTED_COMMIT='389390c884949fe27c240488a3259da3cdba93e0'
PATCH_PATH='PATCHES/documenso-v2.18.0-millave.1.patch'
SOURCE_DIRECTORY=$1
SCRIPT_DIRECTORY=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
SOURCE_OFFER_DIRECTORY=$(dirname "$SCRIPT_DIRECTORY")

test -e "$SOURCE_DIRECTORY/.git"
test "$(git -C "$SOURCE_DIRECTORY" rev-parse HEAD)" = "$EXPECTED_COMMIT"
(
  cd "$SOURCE_OFFER_DIRECTORY"
  shasum -a 256 -c PATCHES/SHA256SUMS
)
git -C "$SOURCE_DIRECTORY" apply --check --whitespace=error-all "$SOURCE_OFFER_DIRECTORY/$PATCH_PATH"

printf '%s\n' 'Pinned upstream checkout and Mi Llave patch verified.'
