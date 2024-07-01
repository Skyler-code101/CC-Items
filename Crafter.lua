local bridge = peripheral.find("meBridge")
local monitor = peripheral.find("monitor")
local Craftables = {}
local IsCrafting = false
local Crafted = false
function grabCraftables()
    Craftables[#Craftables+1] = {rgname= "mekanismgenerators:hohlraum",dpname="Hohlraum"}
end
function display()
    while true do
        if IsCrafting ==false and Crafted == false then
            local line = 3
            monitor.clear()
            monitor.setTextScale(1)
            monitor.setCursorPos(1,1)
            monitor.write("Crafts")
            monitor.setCursorPos(1,2)
            monitor.write("=========================================================================")
            for index, value in ipairs(Craftables) do
                monitor.setCursorPos(1,line)
                monitor.write(value.dpname)
                line = line +1
            end
        elseif Crafted == true then
            monitor.clear()
            monitor.setTextScale(2)
            monitor.setCursorPos(1,4)
            monitor.write("Crafted Requested Item")
        elseif IsCrafting == true then
            monitor.clear()
            monitor.setTextScale(2)
            monitor.setCursorPos(1,4)
            monitor.write("Crafting Requested Item")
        end
        sleep(.1)
    end
end
function Click()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        y = y-2
        if Craftables[y] then
            Crafting = {}
            Crafting.name = Craftables[y].rgname
            Crafting.count = 1
            bridge.craftItem(Crafting)
            repeat
                
                IsCrafting = true
            until not bridge.isItemCrafting(Crafting)
            IsCrafting = false
            Crafted = true
            bridge.exportItem(Crafting,"front")
            sleep(5)
            Crafted = false
        end
        sleep(.1)
    end
end
parallel.waitForAll(grabCraftables,display,Click)