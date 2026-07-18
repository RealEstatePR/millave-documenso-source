# Reproduce the Mi Llave locale-handoff patch

This repository is a public source offer for the Mi Llave modifications included
in PATCHES/documenso-v2.15.0-millave.2.patch. It intentionally does not include
an upstream Documenso source mirror or any production configuration.

## Pinned upstream source

- Repository: https://github.com/documenso/documenso
- Release: v2.15.0
- Commit: c5efd34e95737f98f64c31214cebee80fb598f29
- Node.js: >=22.0.0
- npm: >=11.11.0, with upstream package-manager pin npm@11.11.0

## Verify and apply

From a fresh clone of this repository and a separate fresh checkout of the
upstream source:

    git clone https://github.com/documenso/documenso.git documenso-upstream
    git -C documenso-upstream checkout c5efd34e95737f98f64c31214cebee80fb598f29
    shasum -a 256 -c PATCHES/SHA256SUMS
    git -C documenso-upstream apply --check --whitespace=error-all \
      ../millave-documenso-source/PATCHES/documenso-v2.15.0-millave.2.patch
    git -C documenso-upstream apply --whitespace=error-all \
      ../millave-documenso-source/PATCHES/documenso-v2.15.0-millave.2.patch

Alternatively, run:

    scripts/verify-source.sh ../documenso-upstream

The script checks the upstream commit and patch checksum, then runs only
git apply --check; it does not modify the upstream checkout.

Release `documenso-v2.15.0-millave.2` supersedes `.1` with a
compact host-visible notice that identifies Mi Llave's modification scope,
GNU AGPL v3 availability, and its no-warranty statement. The `.1`
patch remains in this repository for reproducibility of the prior release.

## Deployment boundary

This is source-disclosure material, not a deployment recipe. It contains no
production keys or customer data. The exact upstream v2.15.0 tree includes
separately licensed material in addition to root-AGPL files. An operator must
confirm the upstream license terms and a permitted Community Edition build path
before building or deploying a modified image. This document makes no legal
determination.
