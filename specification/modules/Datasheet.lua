local Datasheet = {}

local function join(sep, table)
  local s = ""
  for i=1,#table do
    if i > 1 then
      s = s .. sep
    end
    s = s .. tostring(table[i])
  end
  return s
end

local function createAnchorString(str)
  return str:gsub("[%W]", "-"):lower()
end

local function flattenString(string)
  local indent
  return string:gsub("[^\n]+", function(line)
    if indent == nil then
      indent = line:match("%s+")
    end
    return line:sub(#indent + 1)
  end)
end

function Datasheet.Chapter(title)
  return function (contents) 
    return {
      title = tostring(title) or error("requires title"),
      contents = flattenString(tostring(contents) or error("requires contents!")),
    }
  end
end

function Datasheet.ImplementChapter(title, implementor)
  return {
    title = tostring(title) or error("requires title"),
    implementor = implementor or error("requires implementor"),
  }
end


function Datasheet.renderMarkdown(datasheet, emitter)
  assert(datasheet, "requires datasheet")
  assert(emitter, "requires emitter")

  function emit(...)
    emitter(join("", table.pack(...)))
  end

  function emitln(...)
    emit(...)
    emit("\n")
  end

  if datasheet.full_path then
    emitln("<!-- This file was autogenerated from ", datasheet.full_path, "-->")
  end

  emitln("# ", datasheet.name)
  emitln()
  if datasheet.brief then
    emitln(datasheet.brief)
    emitln()
  end

  if #datasheet > 0 then

    for i=1,#datasheet do
      local chapter = datasheet[i]

      emitln("- [", chapter.title, "](#", createAnchorString(chapter.title), ")")
    end
    emitln()
  end

  for i=1,#datasheet do
    local chapter = datasheet[i]
    emitln("## ", chapter.title)
    emitln()
    if chapter.contents then
      emitln(chapter.contents)
    elseif chapter.implementor then
      emitln(chapter.implementor(datasheet, chapter))
    end

  end

end


local mt = { }
function mt.__call(self, datasheet)
  assert(datasheet, "Datasheet requires at least one argument!")
  local function hasField(n)
    assert(datasheet[n], "Datasheet requires field " .. n )
  end

  hasField "id"
  hasField "name"
  
  return datasheet
end

setmetatable(Datasheet, mt)

return Datasheet