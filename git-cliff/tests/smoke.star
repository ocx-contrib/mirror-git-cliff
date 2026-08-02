# git-cliff/tests/smoke.star — stable across upstream git-cliff releases.
# Asserts the contract (exit code, version shape, file side effect, config
# schema token), never help/version prose. See ocx.mirror testing-practices.md.

CLIFF = "git-cliff.exe" if ocx.target_platform.os == ocx.os.Windows else "git-cliff"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(CLIFF, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior on a hermetic invocation — assert the computed
# side effect, not prose. Bare `--init` writes the default config to
# `cliff.toml` in the cwd (the scratch root) and needs NO git repository, so it
# runs identically in every container leg — none of which ships git.
#
# It takes NO path argument: `--init <name>` selects a BUILT-IN config BY NAME,
# so `--init cliff.toml` exits 1 with `config cliff.toml not found` (measured
# against the real v2.13.1 binary — this file used to make exactly that call).
#
# `[changelog]` is the config schema's root table, not prose: it is the token
# every git-cliff config must carry for the tool to read it back.
r_init = ocx.run(CLIFF, "--init")
expect.ok(r_init)
expect.true(ocx.exists("cliff.toml"))
expect.contains(ocx.read_file("cliff.toml"), "[changelog]")

# No Tier 4: metadata.json declares one bare ${installPath} PATH entry and
# nothing else — Tier 1's liveness is that entry's proof.
