# Reproduce the Mi Llave locale-handoff patch

This repository is a public source offer for the Mi Llave modifications included
in PATCHES/documenso-v2.18.0-millave.1.patch. It intentionally does not include
an upstream Documenso source mirror or any production configuration.

## Pinned upstream source

- Repository: https://github.com/documenso/documenso
- Release: v2.18.0
- Commit: 389390c884949fe27c240488a3259da3cdba93e0
- Node.js: >=24.0.0
- npm: >=11.17.0, with upstream package-manager pin npm@11.19.1

## Verify and apply

From a fresh clone of this repository and a separate fresh checkout of the
upstream source:

    git clone https://github.com/documenso/documenso.git documenso-upstream
    git -C documenso-upstream checkout 389390c884949fe27c240488a3259da3cdba93e0
    shasum -a 256 -c PATCHES/SHA256SUMS
    git -C documenso-upstream apply --check --whitespace=error-all \
      ../millave-documenso-source/PATCHES/documenso-v2.18.0-millave.1.patch
    git -C documenso-upstream apply --whitespace=error-all \
      ../millave-documenso-source/PATCHES/documenso-v2.18.0-millave.1.patch

Alternatively, run:

    scripts/verify-source.sh ../documenso-upstream

The script checks the upstream commit and patch checksum, then runs only
git apply --check; it does not modify the upstream checkout.

Release `documenso-v2.18.0-millave.1` supersedes `documenso-v2.15.0-millave.2`
by re-pinning the same patch content to upstream release v2.18.0. The
`documenso-v2.15.0-millave.1` and `documenso-v2.15.0-millave.2` patches remain
in this repository for reproducibility of the prior releases.

## Deployment boundary

This is source-disclosure material, not a deployment recipe. It contains no
production keys or customer data. The exact upstream v2.18.0 tree includes
separately licensed material in addition to root-AGPL files. An operator must
confirm the upstream license terms and a permitted Community Edition build path
before building or deploying a modified image. This document makes no legal
determination.
