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
nh os switch

# Build without switching
nh os build
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
nh home switch
```

## Lint and Format Commands

```bash
# Format Nix files with nixpkgs-fmt
nix fmt

# Check formatting without applying
nix fmt --check

# Lint with statix (Nix anti-patterns)
nix run nixpkgs#statix check .
nix run nixpkgs#statix fix .
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



## Special Considerations

### Security
- Never include secrets or API keys in configuration
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