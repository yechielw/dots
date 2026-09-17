# AGENTS.md

Guidance for coding agents working in this repository. These instructions apply to the
entire tree unless a more specific `AGENTS.md` exists below the file being changed.

## Repository purpose and supported targets

This is Yechiel's flake-based NixOS and Home Manager configuration. It uses Snowfall
Lib conventions and the `yechiel` namespace.

The currently configured machine and user are:

- NixOS host: `lenovo-thinkpad-x13` (`x86_64-linux`)
- Home Manager configuration: `yechiel@x86_64-linux`
- Desktop: Hyprland with Home Manager-managed desktop and shell configuration
- Boot/security: Lanzaboote Secure Boot, measured boot, TPM-related configuration,
  fingerprint/IR authentication, and `run0`

The flake advertises `x86_64-linux`, `aarch64-linux`, and `aarch64-darwin` for
system-dependent outputs. Only the NixOS host above is defined; do not claim that a
complete Darwin or aarch64 host configuration exists.

## Flake architecture

- `flake.nix` declares the root inputs and passes them to `outputs.nix`. Home Manager
  is supplied from `inputs.omniflake.flakes.home-manager` before constructing the
  Snowfall flake.
- `outputs.nix` calls `inputs.snowfall-lib.mkFlake`, declares the supported systems and
  `yechiel` namespace, configures channels, and exposes the formatter and formatting
  check built from `treefmt.nix`.
- The `master` channel comes from `inputs.omniflake.flakes.nixpkgs`; the `stable`
  channel comes from the root `stable` input. Both are exposed through the channels
  overlay.
- `base.lib.exposeAvailableModules base` augments Snowfall's conventional module
  outputs with the opt-in modules under `modules/available/`.

The important current outputs are:

- `nixosConfigurations.lenovo-thinkpad-x13`
- `homeConfigurations."yechiel@x86_64-linux"`
- `checks.<system>.git-hooks`
- `devShells.<system>.default`
- `formatter.<system>`
- `packages.<system>.<name>`
- `nixosModules.<name>`, `homeModules.<name>`, and `overlays.<name>`

## Snowfall hierarchy and discovery

Follow the existing hierarchy instead of wiring conventional outputs manually:

| Path | Result | Notes |
| --- | --- | --- |
| `systems/<system>/<host>/default.nix` | A system configuration | Keep host-specific hardware and networking here. |
| `homes/<system>/<user>/default.nix` | A standalone Home Manager configuration | The NixOS host also links Yechiel's home through `snowfallorg.users.yechiel.home.path`. |
| `modules/nixos/<name>/default.nix` | `nixosModules.<name>` | Conventional Snowfall modules are included in NixOS system evaluation. |
| `modules/home/<name>/default.nix` | `homeModules.<name>` | Use for conventional reusable Home Manager modules. |
| `modules/available/{nixos,home,darwin}/<name>/default.nix` | A module exposed by `lib/modules/default.nix` | These modules are opt-in and must be imported explicitly. |
| `packages/<name>/default.nix` | `packages.<system>.<name>` and an overlay entry | Repository packages are available as `pkgs.yechiel.<name>`. |
| `overlays/<name>/default.nix` | `overlays.<name>` | Channel and package-set customizations belong here. |
| `checks/<name>/default.nix` | `checks.<system>.<name>` | Use `checks/`, not `tests/`, for Snowfall-discovered flake checks. |
| `shells/<name>/default.nix` | `devShells.<system>.<name>` | `shells/default/` is the shell entered by plain `nix develop`. |
| `lib/<name>/default.nix` | `lib.yechiel.<name>` | Use for reusable Nix functions and data, not ordinary configuration files. |
| `config/` | No automatic output | Reserve for non-module assets consumed by modules or packages. |

Nested discovered directories produce slash-delimited names. For example,
`modules/available/nixos/users/yechiel/default.nix` is exposed as
`nixosModules."users/yechiel"`.

Adding a file under `modules/available/` does not enable it. Import it explicitly from
the appropriate host or home using `lib.yechiel.nixos`, `lib.yechiel.home`, or
`lib.yechiel.darwin`.

## Omniflake usage

Omniflake provides lazily loaded flakes through several policies. Choose the policy
intentionally and do not mix policies for the same dependency without a reason.

- `inputs.omniflake.flakes.<name>` substitutes Omniflake's foundation inputs, including
  the root-followed `nixpkgs`. Prefer this for normal integrations that should align
  with this repository's package set.
- `inputs.omniflake.pinned.<name>` preserves the dependency's upstream lock graph.
  Use it when compatibility with the exact upstream module or package graph matters.
- `inputs.omniflake.unified.<name>` substitutes every dependency name Omniflake knows.
  Use it only when maximal graph unification is deliberate.
- `inputs.omniflake.flakes."github:<owner>/<repo>"` is the unambiguous qualified form.
  Prefer it when a bare name is unclear or contested. The Git hooks check uses
  `"github:cachix/git-hooks.nix"` for this reason.
- `inputs.omniflake.github.<policy>.<owner>.<repo>` is the owner/repository view of the
  same policies and is useful when discovering available flakes interactively.

Do not add a separate root input merely to duplicate a dependency already intentionally
provided by Omniflake. Add one when the repository needs an independent pin, explicit
follows, or a dependency that must remain visible in the root lock graph. When changing
an input or Omniflake policy, inspect both `flake.nix` and `flake.lock` and confirm that
every lock-file change is intentional.

Current examples include Home Manager, the master Nixpkgs channel, and Git hooks from
`omniflake.flakes`; hardware, boot, desktop, and package integrations commonly use
`omniflake.pinned` to preserve their upstream graphs.

## Repository-specific boundaries

- The installed `pkgs.yechiel.nvim` package is defined by `packages/nvim/default.nix`
  and consumes `config/nvim/`.
- Treat `packages/nvim-new/` and `packages/birdee/` as separate experiments. Do not
  copy changes among the three Neovim packages unless the task calls for it.
- Keep reusable NixOS and Home Manager behavior in the appropriate module tree. Keep
  host-specific hardware and networking in `systems/`.
- Treat `systems/x86_64-linux/lenovo-thinkpad-x13/hardware-configuration.nix` as
  generated hardware state. Change it only for an intentional hardware or filesystem
  update.
- Keep package runtime dependencies in their Nix package or wrapper definitions rather
  than assuming tools exist globally.
- Preserve `system.stateVersion` and `home.stateVersion` unless the user explicitly
  requests and understands a state-version migration.

## Editing conventions

- Follow the surrounding Nix style and keep changes narrowly scoped.
- Prefer normal module option sets. Use `lib.mkDefault`, `lib.mkForce`, or `lib.mkIf`
  only when their priority or conditional behavior is intentional.
- Do not mass-format, reorganize, or clean unrelated files. Report pre-existing
  violations separately.
- Preserve the user's working tree. Before and after a tool that can rewrite files,
  inspect `git status --short` and review both staged and unstaged diffs.
- New files must be known to Git before evaluating the flake because Git-backed flakes
  omit untracked files. Do not commit or push unless explicitly requested.

## Formatting and Git hooks

The flake formatter is the `treefmt-nix` wrapper configured in `treefmt.nix`. It runs
`nixfmt`, `stylua`, `yamlfmt`, and `mdsh`. Format only the touched files when possible:

```console
nix fmt -- path/to/file.nix another/file.nix
```

The authoritative hook definition is `checks/git-hooks/default.nix`. It uses
`cachix/git-hooks.nix` from Omniflake with `prek` and currently enables the treefmt
wrapper, `statix`, `deadnix`, `shellcheck`, and `trufflehog`. Keep formatter selection
in `treefmt.nix` instead of duplicating individual formatter hooks here.

The default shell in `shells/default/default.nix` consumes the check's
`enabledPackages` and `shellHook`, so the hook list must not be duplicated in the shell.
Entering the shell installs the generated hooks and makes `prek` available:

```console
nix develop
nix develop -c prek run --all-files
```

Run the hooks in a sandboxed source copy when checking the repository without rewriting
the working tree:

```console
nix build --no-link .#checks.x86_64-linux.git-hooks
```

`prek` and treefmt can rewrite files when run directly. Record the working tree state
first, then inspect every resulting change. Keep Markdown examples as normal fenced
blocks; add `mdsh` command markers only when generated output is intentional. Do not
edit the ignored `.pre-commit-config.yaml`; the shell hook owns it as a generated
symlink. If a stale regular file from the old Devenv setup blocks installation, move it
aside and re-enter the default shell. Alejandra is not a configured repository check.

## Evaluation and validation

Start with the least expensive check that covers the change, then increase validation
in proportion to risk.

```console
# Inspect all advertised outputs without changing the lock file.
nix flake show --all-systems --no-write-lock-file

# Evaluate checks without building them.
nix flake check --no-build --no-write-lock-file

# Evaluate affected NixOS and Home Manager options.
nix eval --raw \
  .#nixosConfigurations.lenovo-thinkpad-x13.config.networking.hostName
nix eval --raw \
  '.#homeConfigurations."yechiel@x86_64-linux".config.home.stateVersion'
```

For a change that can affect a realized configuration, build the relevant output:

```console
# NixOS configuration
nh os build . --hostname lenovo-thinkpad-x13

# Equivalent direct build without a result symlink
nix build --no-link \
  .#nixosConfigurations.lenovo-thinkpad-x13.config.system.build.toplevel

# Standalone Home Manager configuration
nh home build . --configuration 'yechiel@x86_64-linux'

# Repository package
nix build --no-link .#<package-name>
```

Recommended minimum validation:

- Documentation: inspect the Markdown diff and run the relevant Markdown hook. For this
  file, run `nix develop -c prek run mdsh --files AGENTS.md` and inspect the result.
- Nix module or host/home change: format touched Nix files, run the no-build flake
  check, evaluate the affected option or derivation, and build it when practical.
- Package or wrapper change: format touched Nix files and build the affected package.
- Lua change: run StyLua on touched files and build the package embedding that
  configuration when practical.
- Shell change: run ShellCheck on the touched script and evaluate or build its consumer.
- Flake input/output change: inspect all outputs, run the no-build flake check, and
  build the affected output. Confirm any lock-file diff is intentional.
- Boot, disk, authentication, networking, or security change: require a NixOS build and
  explain deployment and recovery implications before switching.

There is no conventional unit-test suite. Flake evaluation, targeted builds, and the
flake-managed hooks are the test surface. Directly importing a NixOS module with
`nix eval -f` is usually invalid because modules require NixOS module arguments.

If a repository-wide command fails because of an unrelated baseline issue, record the
failure and validate the touched files or outputs separately. Do not broaden a patch
solely to make an unrelated global check green.

## Deployment and safety

Building and evaluating are safe default actions. Switching a configuration mutates
machine or user state and requires an explicit request:

```console
# Deploy NixOS only when explicitly requested.
nh os switch . --hostname lenovo-thinkpad-x13

# Deploy standalone Home Manager only when explicitly requested.
nh home switch . --configuration 'yechiel@x86_64-linux'
```

- Never enroll Secure Boot keys, modify TPM/LUKS slots, change firmware, repartition
  disks, or reboot unless explicitly requested and the exact target is verified.
- Never add passwords, tokens, private keys, `.env` contents, or other secrets. Files
  under `config/certs/` are intentional trust material; verify that additions are
  certificates and never private keys.
- Do not commit, push, update inputs, or deploy merely because validation succeeds.
- For risky system changes, build first and preserve a known-good boot entry or recovery
  path.

## Handoff expectations

Summarize what changed, name relevant files, list checks actually run and their results,
and identify skipped or failed checks. Do not describe a configuration as deployed when
it was only evaluated or built.
