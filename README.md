# mirror-git-cliff

OCX mirror for [git-cliff](https://github.com/orhun/git-cliff). One repository,
one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [git-cliff](https://github.com/orhun/git-cliff) | [`git-cliff/mirror.yml`](git-cliff/mirror.yml) | `ghcr.io/ocx-contrib/git-cliff/git-cliff` | `ocx.sh/git-cliff/git-cliff` | `MIT OR Apache-2.0` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

> This repository previously published the same upstream to the flat coordinate
> `ocx.sh/git-cliff`. `git-cliff/git-cliff` is the grouped successor. Upstream's
> owner is the personal handle `orhun`, so the tool names itself rather than
> borrowing a person's account name — and `git/cliff` is not an option, because
> a namespace is an ownership boundary and `git` belongs to the Git project.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
git-cliff/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all.

## Platforms

`git-cliff` publishes six platform entries: both Linux arches, both macOS
arches and both Windows arches. Upstream ships a `-gnu` **and** a `-musl` Linux
build per arch; this mirror carries **only the musl one**, which is fully
static — no `PT_INTERP`, no `DT_NEEDED` (the x86_64 build is a static-PIE,
which `file` reports as "static-pie linked" and which is still static). The
`-gnu` builds are dynamic and pull in a non-base `libgcc_s.so.1`, so they buy
nothing the static build does not already cover.

`os.features` states what an artifact requires *of the host*, so both Linux
keys are **bare**: tagging them `+libc.musl` would be a false requirement that
hid them from every glibc host. The `alpine:3.20` container leg in
`mirror-base.yml` is what turns that claim into evidence; the measurement
itself is recorded above the `assets:` block in `git-cliff/mirror.yml`.

The version floor of `2.12.0` is a deliberate backfill window, not a
completeness constraint — v2.9.x already ships all six platform assets.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `git-cliff/mirror.yml` | hand | yes — see below |
| `git-cliff/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `git-cliff/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec git-cliff/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

Upstream's tarball wraps everything in one `git-cliff-<version>/` directory,
which `strip_components: 1` removes — so the executables land *at* the content
root and the bundle's only PATH entry is a bare `${installPath}`. `bin_scan`
only looks *below* an `${installPath}/<dir>` entry, so `auto`/`verify` is
rejected at spec load with exit 65:

```
bin_scan is enabled but metadata.json declares no interface-visible
${installPath}/<dir> PATH entry — the verification would inspect no file and
pass green whatever the archive contains.
```

`mirror-base.yml` therefore sets `bin_scan: off` and `git-cliff/metadata.json`
hand-lists all three executables upstream ships on that PATH entry —
`git-cliff`, `git-cliff-completions`, `git-cliff-mangen` — the blessed shape
for this asset type.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope; each
package's redistribution license is recorded in [`NOTICE.md`](NOTICE.md).
