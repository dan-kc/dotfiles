P = function(v)
  print(vim.inspect(v))
  return v
end

function ShowHighlightInfo()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end
