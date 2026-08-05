# AGENTS.md

Guidance for coding agents working in this repository. These instructions apply to the
entire tree unless a more specific `AGENTS.md` exists below the file being changed.

## Repository purpose

This is Yechiel's flake-based NixOS and Home Manager configuration. It uses
snowfall-lib conventions and the `yechiel` namespace.

The currently configured machine and user are:

- NixOS host: `lenovo-thinkpad-x13` (`x86_64-linux`)
- Home Manager configuration: `yechiel@x86_64-linux`
- Desktop: Hyprland with Home Manager-managed desktop and shell configuration
- Boot/security: Lanzaboote Secure Boot, measured boot, TPM-related configuration,
  fingerprint/IR authentication, and `run0`

The flake advertises `x86_64-linux`, `aarch64-linux`, and `aarch64-darwin` for
system-dependent outputs, but only the NixOS host above is defined. Do not claim that a
complete Darwin or aarch64 host configuration exists.

## Repository map and discovery rules

- `flake.nix` declares inputs. `outputs.nix` constructs and exposes the Snowfall flake.
- `systems/<system>/<host>/default.nix` defines a NixOS host. The current host imports
  its hardware configuration and the selected reusable modules.
- `homes/<system>/<user>/default.nix` defines a standalone Home Manager output. The
  NixOS host also connects that home through `snowfallorg.users.yechiel.home.path`.
- `modules/available/nixos/` and `modules/available/home/` contain opt-in modules.
  `lib/modules/default.nix` discovers them and exposes them through
  `lib.yechiel.nixos` and `lib.yechiel.home`; they are not enabled merely by existing.
  Import new opt-in modules explicitly from the appropriate host or home.
- Nested available modules use slash-delimited output names, for example
  `nixosModules."users/yechiel"`.
- `modules/nixos/` contains conventional Snowfall NixOS modules. These are loaded by
  Snowfall for NixOS systems; currently this contains the shared binary-cache module.
- `packages/<name>/default.nix` is auto-discovered as a package and overlay. Within
  NixOS modules, repository packages are available as `pkgs.yechiel.<name>`.
- `overlays/` contains channel and package-set overlays. `stable` and `master` are
  exposed through the channels overlay.
- `config/` contains files consumed by modules or packages, including Hyprland,
  Neovim, Kitty, Waybar, DMS, certificates, and other application configuration.
- `devenv.nix` is the source of the generated git-hook configuration. Do not edit the
  ignored `.pre-commit-config.yaml` or `.devenv/` state directly.

There are several Neovim experiments. The installed `pkgs.yechiel.nvim` package is
defined by `packages/nvim/default.nix` and uses `config/nvim/`. Treat
`packages/nvim-new/` and `packages/birdee/` as separate packages; do not copy changes
between them unless the task calls for it.

## Editing conventions

- Follow the surrounding Nix style and keep changes narrowly scoped. Prefer normal
  module option sets over broad overrides; use `lib.mkDefault`, `lib.mkForce`, or
  `lib.mkIf` only when their priority or conditional behavior is intentional.
- Keep host-specific hardware and networking details in `systems/`; put reusable
  NixOS or Home Manager behavior in the appropriate module tree.
- Use explicit module imports. Adding a file under `modules/available/` does not enable
  it.
- Preserve `system.stateVersion` and `home.stateVersion` unless the user explicitly
  requests and understands a state-version migration.
- Treat `hardware-configuration.nix` as generated hardware state. Change it only for
  an intentional hardware/filesystem update.
- Keep package runtime dependencies in their Nix wrapper/package definitions rather
  than assuming tools exist globally.
- Update `flake.lock` only for an intentional input change. Review both `flake.nix` and
  `flake.lock` when an input is added, removed, followed, or updated.
- Do not mass-format or clean unrelated files. The tree may contain pre-existing style
  violations or user edits; report them separately.
- Preserve the user's working tree. Before and after tools that can rewrite files,
  inspect `git status --short` and review the diff.

## Formatting and hooks

The flake formatter is `nixpkgs-fmt`:

```bash
# Format selected Nix files
nix fmt -- path/to/file.nix another/file.nix

# Check selected Nix files without rewriting them
nix fmt -- --check path/to/file.nix another/file.nix

# Repository-wide check (may expose unrelated existing violations)
nix fmt -- --check .
```

The development environment defines hooks for Nix formatting, ShellCheck, StyLua,
flake-checker, yamlfmt, mdsh, and TruffleHog:

```bash
devenv test --no-tui
```

`devenv test`/`prek` may rewrite files through formatting hooks. Run it only after
recording the working-tree state, then inspect all changes. Do not keep rewrites outside
the task's scope. `statix` and Alejandra are not configured repository checks.

## Evaluation and validation

Start with the least expensive check that covers the change, then increase validation
in proportion to risk.

```bash
# Inspect outputs without changing the lock file
nix flake show --no-write-lock-file

# Evaluate flake outputs and checks without building them
nix flake check --no-build --no-write-lock-file

# Evaluate a specific affected NixOS option (example)
nix eval --raw \
  .#nixosConfigurations.lenovo-thinkpad-x13.config.networking.hostName

# Evaluate a specific affected Home Manager option (example)
nix eval --raw \
  '.#homeConfigurations."yechiel@x86_64-linux".config.home.stateVersion'
```

For a change that can affect the realized configuration, build the relevant output:

```bash
# NixOS configuration
nh os build . --hostname lenovo-thinkpad-x13

# Equivalent direct Nix build without creating a result symlink
nix build --no-link \
  .#nixosConfigurations.lenovo-thinkpad-x13.config.system.build.toplevel

# Standalone Home Manager configuration
nh home build . --configuration 'yechiel@x86_64-linux'

# A single repository package
nix build --no-link .#<package-name>
```

Use a full `nix flake check --no-write-lock-file` when package/check builds are relevant.
There is no conventional unit-test suite; flake evaluation, targeted builds, and the
devenv hooks are the test surface. Directly importing a NixOS module with `nix eval -f`
is usually not a valid module test because modules require the NixOS module arguments.

Recommended minimum validation by change type:

- Documentation only: inspect the Markdown diff; run the Markdown hook if available.
- Nix module or host/home change: format touched Nix files, run the no-build flake
  check, evaluate the affected derivation, and build it when practical.
- Package/wrapper change: format touched Nix files and build the affected package.
- Lua change: run StyLua on the touched Lua files and build the package that embeds
  that configuration when practical.
- Shell change: run ShellCheck on the touched script and evaluate/build its consumer.
- Flake input/output change: inspect `nix flake show`, run the no-build flake check,
  and build the affected output. Confirm any lock-file diff is intentional.
- Boot, disk, authentication, networking, or security change: require a NixOS build and
  explain deployment/recovery implications before switching.

If a repository-wide command fails because of an unrelated baseline issue, record the
failure and validate the touched files or outputs separately. Do not hide failures and
do not broaden the patch just to make a global check green.

## Deployment and safety

Building and evaluating are safe default agent actions. Switching configurations is a
machine- or user-state mutation and requires an explicit user request:

```bash
# Deploy NixOS only when explicitly requested
nh os switch . --hostname lenovo-thinkpad-x13

# Deploy standalone Home Manager only when explicitly requested
nh home switch . --configuration 'yechiel@x86_64-linux'
```

- Never enroll Secure Boot keys, modify TPM/LUKS slots, change firmware, repartition
  disks, or reboot unless explicitly requested and the exact target has been verified.
- Never add passwords, tokens, private keys, `.env` contents, or other secrets. The
  certificates under `config/certs/` are intentional trust material; review additions
  there carefully and never mistake a private key for a certificate.
- Do not commit, push, update inputs, or deploy merely because validation succeeded.
  Perform those actions only when requested.
- For risky system changes, prefer a build first and preserve a known-good boot entry or
  recovery path.

## Handoff expectations

Summarize what changed, name the relevant files, list the checks actually run and their
results, and call out any checks that were skipped or failed for pre-existing reasons.
Do not describe a configuration as deployed when it was only evaluated or built.
