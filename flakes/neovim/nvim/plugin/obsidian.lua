if vim.g.did_load_obsidian_plugin then
  return
end
vim.g.did_load_obsidian_plugin = true

require('obsidian').setup {
  workspaces = {
    {
      name = 'notes',
      path = '~/notes',
    },
  },
  daily_notes = {
    folder = 'journal',
    date_format = '%Y-%m-%d',
    template = nil,
  },
  templates = {
    folder = 'templates',
    date_format = '%Y-%m-%d-%a',
    time_format = '%H:%M',
  },
  new_notes_location = 'notes_subdir',
  note_frontmatter_func = function(note)
    local out = { tags = note.tags } -- This is the only field we want.
    if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
      for k, v in pairs(note.metadata) do
        out[k] = v
      end
    end

    return out
  end,
}
