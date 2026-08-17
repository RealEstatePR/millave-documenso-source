# Mi Llave Documenso source offer

This public repository provides the reviewable source patch for Mi Llave's
Documenso locale-handoff change. It is deliberately a small patch-source
repository, not a fork or mirror of Documenso.

The patch applies to the public upstream Documenso release:

- upstream repository: https://github.com/documenso/documenso
- upstream release: v2.15.0
- exact upstream commit: c5efd34e95737f98f64c31214cebee80fb598f29

It adds the top-level, privacy-preserving locale handoff and a visible
source-and-license notice on the signing host. The link uses a no-referrer
policy so a signing-page path is not sent to this repository.

The current source-offer release is `documenso-v2.15.0-millave.2`. It
supersedes `.1` by making the notice identify the Mi Llave modification
scope, GNU AGPL v3 availability, and no-warranty statement more explicitly.

Start with [SOURCE-OFFER.md](SOURCE-OFFER.md). The instructions reproduce and
verify the current patch against the exact upstream commit.

## Dependency advisories

This repository carries no dependency manifest, lockfile, or vendored
dependencies, so dependency advisories never apply to its contents.
Assessments of advisories raised against the pinned upstream dependency graph
are recorded in [SECURITY-NOTES.md](SECURITY-NOTES.md).

## Deliberate exclusions

This repository contains no production configuration, credentials, database
data, documents, recipient information, signing links, cookies, handoff
values, deployment exports, image digests, or build logs.

It also does not copy the upstream source tree. The exact upstream v2.15.0
tree includes separately licensed material outside its root AGPL license.
Keeping this repository to the Mi Llave patch avoids republishing that material.
Before anyone builds or deploys an image, they must independently confirm the
applicable upstream license and deployment terms.
