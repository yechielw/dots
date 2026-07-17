local flake = '(builtins.getFlake (toString ./.))'
local hostname = vim.fn.hostname()
local home = (vim.env.USER or 'yechiel') .. '@' .. hostname

local function configuration_options(output, name)
  return flake .. '.' .. output .. '.' .. vim.json.encode(name) .. '.options'
end

vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  settings = {
    nixd = {
      nixpkgs = {
        expr = flake .. '.inputs.nixpkgs.legacyPackages.${builtins.currentSystem}',
      },
      formatting = {
        command = { 'nixfmt' },
      },
      options = {
        nixos = {
          expr = configuration_options('nixosConfigurations', hostname),
        },
        home_manager = {
          expr = configuration_options('homeConfigurations', home),
        },
      },
    },
  },
})

vim.lsp.enable('nixd')
