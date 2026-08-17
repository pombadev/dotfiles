# system

The half of this machine the dotfiles repo can't hold: **packages, services,
`/etc`, and toolchains**. Configs are still handled by `mero/setup.sh`.

Everything here is generated and replayed by [`mero/bin/archify`](../bin/archify),
which is already on `$PATH`.

## Day to day

```sh
archify diff      # what have I installed/removed since the last snapshot?
archify save      # re-capture the system (asks for sudo, to read /etc)
archify commit    # stage + commit the snapshot into the bare dotfiles repo
cmx push          # publish
```

`archify save --no-etc` skips the `/etc` pass and the sudo prompt.

## On a new machine

Boot the Arch ISO, install a minimal base system with an ordinary user account,
then as that user:

```sh
curl -fsSL https://raw.githubusercontent.com/pombadev/dotfiles/master/mero/system/bootstrap.sh | bash
```

That clones the dotfiles (configs, submodules) and then runs `archify restore`,
which:

1. `pacman -Syu`, then installs every explicitly-installed native package
2. bootstraps `paru` from the AUR, then installs the AUR packages
3. installs flatpaks
4. sets hostname, timezone, locale, keymap, login shell, and user groups
5. enables the system and user units that were enabled here
6. writes back the `/etc` files listed in `etc/FILES.txt`
7. reinstalls rustup toolchains, cargo crates, npm globals, and proto tools

Then reboot.

Use `archify restore --dry-run` first to read the whole plan without touching
anything.

A package that has vanished from the repos won't sink the run: the batch install
falls back to one-at-a-time, and everything that failed is listed at the end.

## What's in here

| File | Contents |
| --- | --- |
| `pkg-native.txt` | `pacman -Qqen` — explicitly installed repo packages |
| `pkg-aur.txt` | `pacman -Qqem` minus `*-debug` build byproducts |
| `pkg-flatpak.txt` | flatpak app ids and their remotes |
| `services-system.txt` | enabled system units |
| `services-user.txt` | enabled `--user` units |
| `identity.env` | hostname, timezone, login shell, group membership |
| `locale.conf`, `locale.gen`, `vconsole.conf` | locale and console keymap |
| `tc-*.txt` | rustup / cargo / npm / proto installs |
| `etc/` | the `/etc` files worth keeping, plus `FILES.txt` (mode + owner) |
| `etc-exclude.txt` | your additions to the `/etc` denylist |
| `MANIFEST.md` | regenerated summary of the above |

Only two kinds of `/etc` file are captured: ones **no package owns** (so nothing
would ever recreate them) and ones a package ships but you've **since edited**.
Secrets, the user database, and hardware-specific files like `fstab` are
excluded by default — see the top of `archify` for the list.

Symlinks under `/etc` are recorded in `etc/SYMLINKS.txt` for reference but are
never recreated automatically.

## What this deliberately doesn't do

- **Partitioning, bootloader, and `fstab`** — those belong to the target
  hardware, not to a snapshot.
- **Secrets** — no SSH private keys, no wifi passwords, no GnuPG keyring.
- **Package versions** — Arch is a rolling release; restore installs current
  versions, not the ones frozen here.
