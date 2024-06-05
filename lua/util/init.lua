local M = {}

function M.is_hidden_file(name)
  local visible_hidden = {
    ".env",
    ".github",
    ".gitignore",
    ".helmignore",
    ".makerc",
    ".toolversions",
  }

  for _, v in ipairs(visible_hidden) do
    if name == v then return false end
  end

  return vim.startswith(name, ".")
end

return M
