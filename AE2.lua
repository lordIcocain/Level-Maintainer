local component = require("component")
local ME = component.me_interface

local AE2 = {}

local inCraft = {}

function AE2.requestItem(name, threshold, count)
    craftables = ME.getCraftables({
        ["label"] = name
    })

    if #craftables >= 1 then
        item = craftables[1].getItemStack()
        if threshold ~= nil then
            itemInSystem = ME.getItemsInNetwork({
                ["label"] = name        
            })
            if (#itemInSystem > 0 and itemInSystem[1]["size"] > threshold) then 
                return 
            end
        end
        if item.label == name then
            if item.size > count then
                count = item.size
            end
            local craft = craftables[1].request(count)

            while craft.isComputing() == true do
                os.sleep(1)
            end
            if craft.hasFailed() then
                print("Failed to request " .. name .. " x " .. count)
                return
            else
                inCraft[name] = craft
                print("Requested " .. name .. " x " .. count)
                return
            end

        end
    end
    return table.unpack({false, name .. " is not craftable!"})
end

function  AE2.checkIfCrafting()
    for name, craft in pairs(inCraft) do
      if craft.isDone() then
        print(name, "is Done!")
        inCraft[name] = nil
      elseif craft.isCanceled() then
        print(name, "is Canceled!")
        inCraft[name] = nil
      end
    end
    return inCraft
end

return AE2