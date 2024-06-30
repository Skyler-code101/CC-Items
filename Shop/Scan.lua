local ir = peripheral.find("informative_registry") or error("No Registry Found")
local item = peripheral.find("item_pedestal") or error("No item pedestal Found")
local monitor = peripheral.find("monitor") or error("No Disply Found")
local rf = peripheral.find("reality_forger")

while true do
    print("Enter Command")
    local promt = read()
    if promt == "Analize Item" then
        monitor.clear()
        print("Analizing Item....")
        local itemname = item.getItemDetail(1).name
        if ir.describe("block",itemname).name ~= "minecraft:air" then
            local Registry = ir.describe("block",itemname)
            local ItemLocal = item.getItemDetail(1)
            monitor.setCursorPos(1,1)
            monitor.write("Block Name : "..Registry.displayName)
            monitor.setCursorPos(1,2)
            monitor.write("   Registry Name : "..item.getItemDetail(1).name)
            monitor.setCursorPos(1,3)
            monitor.write("   Max In A Stack : "..tostring(ItemLocal.maxCount))
            monitor.setCursorPos(1,6)
            monitor.write("Tags")
            local hight = 6
            for index, value in ipairs(ItemLocal.tags) do
                hight = hight +1
                monitor.setCursorPos(1,hight) 
                if type(value) == "table"then
                    monitor.write(textutils.serialise(value))
                else
                    monitor.write(value)
                end  
            end
            hight = 6
            monitor.setCursorPos(20,6)
            monitor.write("NBT Data")
            if ItemLocal.rawNBT ~= nil then
                for index, value in ipairs(ItemLocal.rawNBT) do
                    hight = hight +1
                    monitor.setCursorPos(1,hight) 
                    if type(value) == "table"then
                        monitor.write(textutils.serialise(value))
                    else
                        monitor.write(value)
                    end  
                end
            end
            
            if rf then
                rf.batchForgeRealityPieces({
                    {{{x=0, y=1, z=0}}, {block=item.getItemDetail(1).name}, {playerPassable = true}}
                })
            end
            print("Item Info Displaying")
        else
            local Registry = ir.describe("item",itemname)
            local ItemLocal = item.getItemDetail(1)
            monitor.setCursorPos(1,1)
            monitor.write("Item Name : "..Registry.displayName)
            monitor.setCursorPos(1,2)
            monitor.write("   Registry Name : "..item.getItemDetail(1).name)
            monitor.setCursorPos(1,3)
            monitor.write("   Max In A Stack : "..tostring(ItemLocal.maxCount))
            monitor.setCursorPos(1,6)
            monitor.write("Tags")
            local hight = 6
            for index, value in ipairs(ItemLocal.tags) do
                hight = hight +1
                monitor.setCursorPos(1,hight) 
                if type(value) == "table"then
                    monitor.write(textutils.serialise(value))
                else
                    monitor.write(value)
                end  
            end
            hight = 6
            monitor.setCursorPos(20,6)
            monitor.write("NBT Data")
            if ItemLocal.rawNBT ~= nil then
                for index, value in ipairs(ItemLocal.rawNBT) do
                    hight = hight +1
                    monitor.setCursorPos(1,hight) 
                    if type(value) == "table"then
                        monitor.write(textutils.serialise(value))
                    else
                        monitor.write(value)
                    end  
                end
            end
            print("Item Info Displaying")
            
        end
    end
end