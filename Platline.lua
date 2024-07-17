require("src.RequestCraftingItem")
require("src.Utility")

local items = {
    ["drop of Molten SpaceTime"] = 1,
    ["drop of Raw Stellar Plasma Mixture"] = 1
}

while true do
    local itemsCrafting = checkIfCrafting()

    for k, v in pairs(items) do
        if itemsCrafting[k] ~= true then
            local answer = requestItem(k, v)
            if answer == true then
                print("[" .. os.date("%H:%M:%S") .. "] " .. "Requested " .. v .. "x " .. k)
            else
                print("[" .. os.date("%H:%M:%S") .. "] " .. "Failed to request " .. v .. "x " .. k)
            end
        end

    end
    os.sleep(5)
end
