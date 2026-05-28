CLIFF = "git-cliff.exe" if ocx.platform()["os"] == "windows" else "git-cliff"

r_version = ocx.run(CLIFF, "--version")
expect.ok(r_version)
expect.eq(r_version.exit_code, 0)
expect.contains(r_version.stdout, "git-cliff")

r_help = ocx.run(CLIFF, "--help")
expect.eq(r_help.exit_code, 0)
expect.contains(r_help.stdout, "changelog")
