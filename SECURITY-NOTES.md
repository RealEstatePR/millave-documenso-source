# Security notes

This repository is a source offer. It contains no dependency manifest, no
lockfile, and no vendored dependencies, so it is never itself the subject of a
dependency advisory and there is nothing here for a scanner to patch.

Advisories nonetheless arrive against the dependency graph of the pinned
upstream Documenso release recorded in `SOURCE-MANIFEST.json`. This file
records the assessments made against that pinned release, so a later reader can
see what was checked, what was concluded, and how to re-derive it.

Each entry states the advisory, where the dependency sits in the upstream
graph, whether the vulnerable code is reachable, and the disposition. These are
engineering assessments of the pinned upstream source. They are not legal or
compliance determinations, and they do not describe Mi Llave deployment
configuration.

## CVE-2026-40345 — deepmerge-ts stack exhaustion

- Advisory: `GHSA-ggr8-5vv4-36mx`, published 2026-08-17
- Severity: CVSS 4.0 base 8.2 (high), `CWE-674` uncontrolled recursion
- Impact: availability only (`VC:N/VI:N/VA:H`, `AT:P`)
- Affected: `deepmerge-ts < 8.0.0`; first patched version `8.0.0`
- Assessed: 2026-08-17, against upstream `v2.15.0` at commit
  `c5efd34e95737f98f64c31214cebee80fb598f29`

**Disposition: not reachable. Accepted with tracking. No patch applied.**

### Where the dependency sits

The upstream lockfile resolves `deepmerge-ts` to `7.1.5`, which is affected.
npm does not mark it dev-only, because `packages/prisma` lists `prisma` under
`dependencies` rather than `devDependencies`. Scanners therefore report it as a
production dependency, which is why alerts name it as one.

Of the 2302 packages in that lockfile, exactly one declares `deepmerge-ts`:
`@prisma/config@6.19.3`, which is reached only through `prisma` (the CLI) and
`@prisma/internals` (code generation). `@prisma/client@6.19.0`, the client the
server imports to serve requests, declares no dependencies at all and cannot
reach `deepmerge-ts`.

### Why it is not reachable

The single call site is `loadConfigTsOrJs()` in `@prisma/config`, which passes
`deepmerge` as the `merger` argument to `c12` when loading a
`prisma.config.ts` file from disk. The merged input is an operator-authored
file, not request data. Upstream `v2.15.0` ships no `prisma.config.ts`, and no
upstream application source file imports `deepmerge-ts` or `@prisma/config`.

In the upstream container image the Prisma CLI runs twice, both times before
any request is served: `npx prisma generate` during the image build, and
`npx prisma migrate deploy` at container start from `docker/start.sh`. Control
then passes to `node build/server/main.js`, which handles every request for the
life of the container and never loads `@prisma/config`.

### Verified behaviour

Both versions were installed and exercised directly rather than assessed from
the advisory text alone. Merging two objects under Node's default stack size:

| Input                    | 7.1.5      | 8.0.1      | Expressible in JSON |
| ------------------------ | ---------- | ---------- | ------------------- |
| Self-referential cycle   | RangeError | survives   | no                  |
| Nested depth 1000        | survives   | survives   | yes                 |
| Nested depth 10000       | RangeError | RangeError | yes                 |

Version `8.0.0` adds cycle detection but does not bound recursion depth, so
deeply nested acyclic input still exhausts the stack after the fix. Because
`JSON.parse` cannot express a cycle but parses deep nesting without difficulty,
any code path that merges request bodies should cap input depth rather than
rely on the upgrade alone. No such path exists here.

### Remediation status

The fix is a major version bump with no 7.x backport; `7.1.6`, published
2026-08-11, is still affected. Every published release of `@prisma/config`
through `7.9.1` pins `deepmerge-ts` at exactly `7.1.5` rather than a range, so
`npm audit fix` cannot resolve it and upgrading Prisma does not change it.

Forcing `8.0.0` would require an npm `overrides` entry, placing an untested
major version inside Prisma's config loader and putting the migration and code
generation paths at risk to fix a function that no request can reach. That was
judged the worse trade. The fix should instead be picked up through a routine
Prisma upgrade once `@prisma/config` moves to `deepmerge-ts` 8.x.

### Revisit if

A `prisma.config.ts` is introduced whose contents are not fully
operator-controlled. That is the change that would place external input into
the vulnerable merge and invalidate this assessment.

### Re-derive

From a fresh checkout of the pinned upstream source, as prepared in
[SOURCE-OFFER.md](SOURCE-OFFER.md):

    cd documenso-upstream

    # affected version present in the resolved graph
    grep -n '"node_modules/deepmerge-ts"' -A 1 package-lock.json

    # exactly one requirer, pinned exactly, inside @prisma/config
    grep -n '"deepmerge-ts": "7.1.5"' package-lock.json

    # the runtime client declares no dependencies
    grep -n '"node_modules/@prisma/client"' -A 6 package-lock.json

    # no application source imports it (expect no output)
    grep -rn 'deepmerge\|@prisma/config' apps packages \
      --include='*.ts' --include='*.tsx'

    # no config file for the vulnerable loader to merge (expect no match)
    ls prisma.config.* packages/prisma/prisma.config.*
