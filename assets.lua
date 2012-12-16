local function enumerate(dir, tree)
  local files = love.filesystem.enumerate(dir)
  for _,v in ipairs(files) do
    local file = dir .. '/' .. v
    if love.filesystem.isDirectory(file) then
      tree[dir] = enumerate(file, tree)
    elseif love.filesystem.isFile(file) then
      local _,_,name = v:find('(.+)%.png')
      if name ~= nil then
        tree[v] = love.graphics.newImage(file)
      end
    end
  end
  return tree
end

function tprint(tbl)
  for k,v in pairs(tbl) do
    print(tostring(k), tostring(v))
  end
end

tprint(enumerate('/assets', {}))

return enumerate('/assets', {})
