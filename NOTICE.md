# NOTICE

This repository packages and redistributes upstream software published by the
[git-cliff](https://github.com/orhun/git-cliff) project. The Apache-2.0 license
in [`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `git-cliff` | `ghcr.io/ocx-contrib/git-cliff/git-cliff` | `MIT OR Apache-2.0` |

---

## `git-cliff`

Upstream: <https://github.com/orhun/git-cliff>
Published to `ghcr.io/ocx-contrib/git-cliff/git-cliff`.

| Component | SPDX | Holder |
|---|---|---|
| git-cliff (`git-cliff`, `git-cliff-completions`, `git-cliff-mangen`) | **MIT OR Apache-2.0** | Copyright (c) 2021-2026 git-cliff contributors |

Dual-licensed at the recipient's option — `git-cliff/Cargo.toml` declares
`license = "MIT OR Apache-2.0"` and upstream ships both
[`LICENSE-MIT`](https://github.com/orhun/git-cliff/blob/main/LICENSE-MIT) and
[`LICENSE-APACHE`](https://github.com/orhun/git-cliff/blob/main/LICENSE-APACHE).
(GitHub's license API reports the single id `Apache-2.0`; it picks one and is
not the authority.) Both are permissive: redistribution of the compiled binary
is granted provided the copyright and permission notices are retained.
Upstream's own archives carry `LICENSE-MIT` and `LICENSE-APACHE` alongside the
binaries, and this mirror republishes them unchanged inside the bundle, so both
notices travel with every published artifact. The published binaries statically
link third-party Rust crates under permissive licenses, enumerated in
upstream's `Cargo.lock`.

The git-cliff name is used for catalog identification under nominative fair
use. `git-cliff/logo.png` is upstream's own logo, rescaled to 512×512;
`git-cliff/logo.svg` wraps those same bytes so the vector and raster describe
assets carry one mark. Upstream publishes no vector original.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
