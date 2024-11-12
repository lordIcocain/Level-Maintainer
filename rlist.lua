local component = require("component")
local term = require('term')
local serialization = require("serialization")
local ME = component.me_interface

local MaintainerList = {}
local DefaultThreshold = 16000000
local DefaultBatch = 1

local function save()
    local file = io.open("/home/MaintainerList", "w")
    file:write(serialization.serialize(MaintainerList))
    file:close()
end

local function load()
    local file = io.open("/home/MaintainerList", "r")
    if file then
        MaintainerList = serialization.unserialize(file:read("*a")) or {}
        file:close()
    end
end

local function ioAddEdit()
  print('Type N threshold or nothing for 16.000.000')
  io.write('')
  local threshold = tonumber(io.read())

  print('Type N batch or nothing for 1')
  io.write('')
  local batch = tonumber(io.read())

  if threshold == nil then
    threshold = DefaultThreshold
   end
   if batch == nil then
     batch = DefaultBatch
   end
   return {threshold, batch}
end

local function addToList()
  print("Type pattern name or nothing for get whole list")
  print("Liquid craft looks like: 'drop of Water'")
  io.write('')
  local pattern_name = io.read()
  local patterns
  if pattern_name ~= "" then
    patterns = ME.getCraftables({
      ["label"] = pattern_name
    })
    if #patterns == 0 then
      print("Incorrect!")
      return
    end
  else
    patterns = ME.getCraftables()
  end

  print("Select Pattern:")
  local n = 0;
  for int, val in pairs(patterns) do
    n = n + 1
    local item = val.getItemStack()
    if MaintainerList[item.label] ~= nil then
      goto continue
    end
    print("["..int.."] "..item.label)
    if n == 30 or int == #patterns then
      print('Select: or Nothing for next page')
      io.write('')
      local answer = tonumber(io.read())
      term.clear()
      if answer == nil then
        n = 0
        print("Select Pattern:")
      else
        local name = patterns[answer].getItemStack()
        print(name.label)
        MaintainerList[name.label] = ioAddEdit()
        break
      end
    end
    ::continue::
  end
end

local function editList()
  print("Select Pattern:")  
  local n = 0
  local m = 0
  local match = {}
  local size = 0
  for _, _ in pairs(MaintainerList) do
    size = size + 1
  end
  for int, _ in pairs(MaintainerList) do
    n = n + 1
    m = m + 1
    match[m] = int
    print("["..m.."] "..int)
    if n == 30 or n == size then
      print("Select: or Nothing for next page")
      io.write('')
      local answer = tonumber(io.read())
      term.clear()
      if answer == nil then
        n = 0
      else
        print(match[answer])
        print("Current Threshold/batch")
        for _,v in pairs(MaintainerList[match[answer]]) do
          print(v)
        end
        MaintainerList[match[answer]] = ioAddEdit()
        break
      end
    end
  end
end

local function deleteFromList()
  local n = 0
  local size = 0
  local match = {}
  for _, _ in pairs(MaintainerList) do
    size = size + 1
  end
  for int, _ in pairs(MaintainerList) do
    n = n +1
    match[n] = int
    print("["..n.."] "..int)
    if n == 30 or n == size then
      print("Select: or Nothing for next page")
      io.write('')
      MaintainerList[match[tonumber(io.read())]] = nil
      print(match[tonumber(io.read())].." is Deleted!")
    end
  end
end
  
local function run()
  print("Select mode: ")
  print("1 = Add")
  print("2 = Edit")
  print("3 = Delete")
  io.write('')
  local mode = tonumber(io.read())
  if mode == 1 then
    addToList()
  elseif mode == 2 then
    editList()
  elseif mode == 3 then
    deleteFromList()
  end
end

load()
run()
save()         