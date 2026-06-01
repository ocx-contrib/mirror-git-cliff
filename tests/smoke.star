# tests/smoke.star — stable across upstream git-cliff releases.
# Asserts the contract (exit code, version shape, file side effect),
# never help/version prose. See ocx.mirror testing-practices.md.

CLIFF = "git-cliff.exe" if ocx.target_platform.os == ocx.os.Windows else "git-cliff"

# Tier 1 + 2: liveness on the composed PATH + version SHAPE (not the vendor
# banner, not the exact version — the digits are the contract).
r_version = ocx.run(CLIFF, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Tier 3: functional behavior on a hermetic invocation — assert the file
# side effect, not prose. `--init <path>` writes the default config and
# needs no git repository, so the result is deterministic across releases.
# (File side effects are the most stable smoke signal.)
r_init = ocx.run(CLIFF, "--init", "cliff.toml")
expect.ok(r_init)
expect.true(ocx.exists("cliff.toml"))

# No Tier 4: metadata.json declares PATH only (proven by Tier 1 liveness).
