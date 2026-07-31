local M = {
  is_nix = vim.g.nix_info_plugin_name ~= nil,
}

local function plugin_name(spec)
  if type(spec) == 'table' and spec.name then return spec.name end

  local src = type(spec) == 'table' and spec.src or spec
  if type(src) ~= 'string' then return nil end

  local name = src:gsub('/+$', ''):match '([^/]+)$'
  return name and name:gsub('%.git$', '') or nil
end

function M.wrap_vim_pack_add()
  local pack_add = vim.pack.add
  local nix_plugins = {}

  if M.is_nix then
    local ok, nix_info = pcall(require, vim.g.nix_info_plugin_name)
    if ok then
      for _, kind in ipairs { 'start', 'lazy' } do
        for name in pairs(nix_info({}, 'plugins', kind)) do
          nix_plugins[name:lower()] = true
        end
      end
    end
  end

  vim.pack.add = function(specs, opts)
    if not M.is_nix then return pack_add(specs, opts) end

    local missing = {}
    for _, spec in ipairs(specs) do
      local name = plugin_name(spec)
      if not (name and nix_plugins[name:lower()]) then missing[#missing + 1] = spec end
    end

    if #missing > 0 then return pack_add(missing, opts) end
    return {}
  end
end

return M
