local map = vim.api.nvim_set_keymap
local actions=require('telescope.actions')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local make_entry = require('telescope.make_entry')
local conf = require('telescope.config').values

local flatten = vim.tbl_flatten
local filter = vim.tbl_filter

require('telescope').setup {
    defaults = {
        color_devicons = true,
    }
}

local M = {}
M.find_dotfiles = function()
    require'telescope.builtin'.find_files({
        prompt_title = " NVIM Files ",
        cwd = "~/.config/nvim",
    })
end
M.search_dotfiles = function()
    require'telescope.builtin'.live_grep({
        prompt_title = " NVIM Files ",
        cwd = "~/.config/nvim",
        use_regex = true,
    })
end

M.grep_regex = function(opts)
  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local grep_open_files = opts.grep_open_files
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local filelist = {}

  if grep_open_files then
   local bufnrs = filter(function(b)
      if 1 ~= vim.fn.buflisted(b) then return false end
      return true
    end, vim.api.nvim_list_bufs())
    if not next(bufnrs) then return end

    local tele_path = require'telescope.path'
    for _, bufnr in ipairs(bufnrs) do
      local file = vim.api.nvim_buf_get_name(bufnr)
      table.insert(filelist, tele_path.make_relative(file, opts.cwd))
    end
  elseif search_dirs then
    for i, path in ipairs(search_dirs) do
      search_dirs[i] = vim.fn.expand(path)
    end
  end

  local live_grepper = finders.new_job(function(prompt)
      -- TODO: Probably could add some options for smart case and whatever else rg offers.

      if not prompt or prompt == "" then
        return nil
      end

      if string.sub(prompt, -1) == "\\" then
          return nil
      end

      local search_list = {}

      if search_dirs then
        table.insert(search_list, search_dirs)
      elseif os_sep == '\\' then
        table.insert(search_list, '.')
      end

      if grep_open_files then
        search_list = filelist
      end

      return flatten { vimgrep_arguments, prompt, search_list }
    end,
    opts.entry_maker or make_entry.gen_from_vimgrep(opts),
    opts.max_results,
    opts.cwd
  )

  pickers.new(opts, {
    prompt_title = 'Live Grep',
    finder = live_grepper,
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- Telescope mappings
map('n', '<Leader>lm', ":lua require'telescope.builtin'.reloader()<CR>", {silent = true})
map('n', '<Leader>ff', ":lua require'telescope.builtin'.find_files()<CR>", {silent = true})
map('n', '<Leader>fg', ":lua require'telescope.builtin'.live_grep({use_regex = true})<CR>", {silent = true})
map('n', '<Leader>fnf', ":lua require'myconf.plugins.telescope'.find_dotfiles()<CR>", {silent = true})
map('n', '<Leader>fng', ":lua require'myconf.plugins.telescope'.search_dotfiles()<CR>", {silent = true})

return M
