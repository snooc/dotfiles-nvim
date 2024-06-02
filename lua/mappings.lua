local nmap_leader = function(suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set("n", "<LEADER>" .. suffix, rhs, opts)
end

-- Fuzzy Finding
nmap_leader("f/", '<CMD>Pick history scope="/"<CR>', '"/" History')
nmap_leader("f/", '<CMD>Pick history scope=":"<CR>', '":" History')
nmap_leader("fb", "<CMD>Pick buffers<CR>", "Buffers")
nmap_leader("ff", "<CMD>Pick files<CR>", "Files")
