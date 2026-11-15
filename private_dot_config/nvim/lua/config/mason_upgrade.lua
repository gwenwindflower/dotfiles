-- Headless entry point: nvim --headless -c "lua require('config.mason_upgrade').run()"
-- Exits Neovim with status 0 on success and 1 on any failure.
local M = {}

local TIMEOUT_MS = 10 * 60 * 1000

local function say(message)
  io.stdout:write(message .. "\n")
end

local function await(start)
  local done, result = false, nil
  start(function(...)
    result = { ... }
    done = true
  end)
  vim.wait(TIMEOUT_MS, function()
    return done
  end, 100)
  return done, result
end

local function outdated_packages(registry)
  local outdated = {}
  for _, pkg in ipairs(registry.get_installed_packages()) do
    local installed = pkg:get_installed_version()
    local latest = pkg:get_latest_version()
    if installed ~= latest and not pkg:is_installing() then
      table.insert(outdated, { pkg = pkg, from = installed or "unknown", to = latest })
    end
  end
  table.sort(outdated, function(a, b)
    return a.pkg.name < b.pkg.name
  end)
  return outdated
end

local function upgrade(outdated)
  local failures = {}
  local pending = #outdated
  for _, entry in ipairs(outdated) do
    entry.pkg:install({ version = entry.to }, function(success, err)
      vim.schedule(function()
        if success then
          say(("upgraded %s %s -> %s"):format(entry.pkg.name, entry.from, entry.to))
        else
          table.insert(failures, entry.pkg.name)
          say(("failed %s: %s"):format(entry.pkg.name, vim.inspect(err)))
        end
        pending = pending - 1
      end)
    end)
  end
  local finished = vim.wait(TIMEOUT_MS, function()
    return pending == 0
  end, 100)
  if not finished then
    say("timed out waiting for Mason installs")
    return false
  end
  return #failures == 0
end

---@param opts? { dry_run?: boolean }
function M.run(opts)
  opts = opts or {}
  local registry = require("mason-registry")

  local updated, result = await(registry.update)
  if not updated or not result[1] then
    say("failed to update Mason registries: " .. vim.inspect(result and result[2]))
    return vim.cmd("cquit 1")
  end

  local outdated = outdated_packages(registry)
  if #outdated == 0 then
    say("all Mason packages are up to date")
    return vim.cmd("qall!")
  end

  if opts.dry_run then
    for _, entry in ipairs(outdated) do
      say(("would upgrade %s %s -> %s"):format(entry.pkg.name, entry.from, entry.to))
    end
    return vim.cmd("qall!")
  end

  vim.cmd(upgrade(outdated) and "qall!" or "cquit 1")
end

return M
