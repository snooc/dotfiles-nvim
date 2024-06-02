local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("n", "<LEADER>" .. suffix, rhs, opts)
end

-- Fuzzy Finding
nmap_leader("f/", '<CMD>Pick history scope="/"<CR>', '"/" History')
nmap_leader("f:", '<CMD>Pick history scope=":"<CR>', '":" History')
nmap_leader("fb", "<CMD>Pick buffers<CR>", "Buffers")
nmap_leader("fB", "<CMD>Pick buf_lines<CR>", "Buffer Lines")
nmap_leader("ff", "<CMD>Pick files<CR>", "Files")
nmap_leader("fgb", "<CMD>Pick git_branches<CR>", "Git Branches")
nmap_leader("fgb", "<CMD>Pick git_commits<CR>", "Git Commits")
nmap_leader("fgh", "<CMD>Pick git_hunks<CR>", "Git Hunks")
nmap_leader("fgf", "<CMD>Pick git_files<CR>", "Git Files")
