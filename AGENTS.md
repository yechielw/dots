# AGENTS.md

This file contains guidelines for agentic coding assistants working in this NixOS configuration repository.

## Repository Overview

This is a NixOS flake-based configuration repository containing:
- System configurations for Lenovo ThinkPad X13
- Home-manager configurations
- Desktop environment configurations (Hyprland)
- Various application configurations

## Build Commands

### System Deployment
```bash
# Build and switch to configuration
sudo nixos-rebuild switch --flake .

# Build without switching
sudo nixos-rebuild build --flake .

# Test build (dry run)
sudo nixos-rebuild dry-activate --flake .

# Build for specific host
sudo nixos-rebuild switch --flake .#lenovo-thinkpad-x13
```

### Evaluation
```bash
# Validate flake
nix flake check

# Show available outputs
nix flake show

# Evaluate specific configuration
nix eval .#nixosConfigurations.lenovo-thinkpad-x13.config.system.build.toplevel
```

### Home Manager
```bash
# Build home configuration
home-manager switch --flake .

# Build for specific user
home-manager switch --flake .#yechiel
```

## Lint and Format Commands

```bash
# Format Nix files with nixpkgs-fmt
nix fmt

# Check formatting without applying
nix fmt --check

# Alternative: Use alejandra for formatting
alejandra --check .  # Check formatting
alejandra .          # Apply formatting

# Lint with statix (Nix anti-patterns)
statix check .
statix fix .
```

## Testing

### Single File Testing
There are no traditional unit tests in this configuration repository. Instead:

```bash
# Test specific Nix expression
nix eval -f ./path/to/file.nix

# Test module imports
nix eval --expr 'import ./nix/modules/wm.nix'
```

### Configuration Validation
```bash
# Validate configuration syntax
nix-instantiate --eval --strict -E '(import ./flake.nix).nixosConfigurations.lenovo-thinkpad-x13'

# Check for unused variables
nix eval --expr 'builtins.deepSeq (import ./nix/hosts/lenovo-thinkpad-x13.nix) {}'
```

## Code Style Guidelines

### File Organization
- Configuration files organized by component (`nix/`, `config/`, `legacy/`)
- Host-specific configurations in `nix/hosts/`
- Module definitions in `nix/modules/`
- Application configurations in `config/`

### Nix Language Style

#### Imports
```nix
# Use relative imports for same-repo files
import ./configuration.nix

# Use inputs for external dependencies
import inputs.home-manager.nixosModules.home-manager
```

#### Formatting
- Use 2-space indentation
- Align closing braces/braces with opening
- One space after colon in attribute sets
- Break long lists and attribute sets across multiple lines

#### Function Definition
```nix
{ config, pkgs, ... }:
{
  # Configuration here
}
```

#### Attribute Sets
```nix
# Multi-line for complex structures
services = {
  openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
  };
};

# Single-line for simple structures
networking.hostName = "lenovo-thinkpad-x13";
```

### Naming Conventions
- Use `camelCase` for attribute names (`home-manager`, `window-manager`)
- Use descriptive names for custom modules (`wm.nix`, `hacking.nix`)
- Host configurations use lowercase with hyphens (`lenovo-thinkpad-x13.nix`)

### Error Handling
- Use `assert` for preconditions
- Handle missing dependencies gracefully with optional imports
- Use `lib.mkIf` for conditional configuration
- Validate inputs with type checking

### Comment Style
```nix
# Single-line comments for short explanations
services.openssh.enable = true; # SSH server

# Multi-line comments for complex sections
/*
  Security configuration
  - Disable root login
  - Restrict port access
*/
```

### Module Patterns

#### Basic Module Structure
```nix
{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    myModule.enable = mkEnableOption "Enable my custom module";
  };

  config = mkIf config.myModule.enable {
    # Configuration that gets enabled
  };
}
```

#### Import Statements
```nix
# At top of file, list all imports
{
  config,
  pkgs,
  inputs,
  ...
}:
```

## Special Considerations

### Security
- Never include secrets or API keys in configuration
- Use age/sops for encrypted secrets
- Validate security-sensitive configurations

### Cross-Platform Support
- Support multiple architectures when possible
- Use conditional logic for platform-specific configurations
- Test on different systems when making changes

### Performance
- Avoid expensive operations in configuration evaluation
- Use lazy evaluation patterns
- Cache expensive computations where possible

## Development Workflow

### Making Changes
1. Test configuration evaluation: `nix flake check`
2. Apply formatting: `nix fmt`
3. Validate syntax: `nix-instantiate --eval --strict`
4. Test deployment: `nixos-rebuild dry-activate --flake .`
5. Apply changes: `nixos-rebuild switch --flake .`

### Git Integration
- Configuration is tracked with Git
- Use descriptive commit messages
- Include `flake.lock` updates when changing dependencies

### Dependency Management
- Pin dependencies in `flake.nix` inputs
- Use version constraints where appropriate
- Update dependencies cautiously

## Agent Usage Guidelines

When modifying this repository:

1. **Always validate changes** before committing
2. **Follow existing patterns** - mimic the code style of surrounding files
3. **Test configuration evaluation** - run `nix flake check` after changes
4. **Format code** - use `nix fmt` or `alejandra`
5. **Document changes** in commit messages
6. **Be conservative** with changes to avoid breaking system configuration

### Special Notes for This Repository
- Contains legacy configurations in `legacy/dots/` directory
- Uses experimental Nix features (flakes, nix-command)
- Includes TPM-backed secure boot configuration
- Custom modules for tui/gui environments

---

*This file should be updated when new practices or tools are adopted in the repository.*