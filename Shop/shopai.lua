local display = peripheral.find("monitor")
local redstonei = peripheral.find("redstoneIntegrator")
local ownerdistance = -1
local radar = peripheral.find("playerDetector")
local beingcalled = false
local ownername ="SkylerGaming"
local offlinebreak = 0
local sp = peripheral.find("speaker")
local chatbox = peripheral.find("chatBox")

local function ownerlocation()
    while true do
        if (beingcalled and radar.isPlayerInRange(3, ownername)) then
            ownerdistance = 1
            sp.playSound("block.note_block.bell",3.0)
            sleep(5)
            beingcalled = false

        elseif (beingcalled and radar.getPlayerPos(ownername)['x'] == nil) then
            ownerdistance = 2
        elseif (beingcalled == false) then
            ownerdistance = -1
        elseif (beingcalled and radar.isPlayerInRange(30, ownername))then
            ownerdistance = 3
        else
            ownerdistance = 0
        end
        sleep(.1)
    end
end
local function redstone()
    while true do
        repeat
            sleep()
        until redstonei.getInput("south")
        if (radar.getPlayerPos(ownername)['x'] ~= nil) then
            beingcalled = true
            chatbox.sendMessageToPlayer("A Player Is At Your Store", ownername, "\xA7b\xA7f-\xA7d".."Store".."\xA7f")
        else
            offlinebreak = offlinebreak + 1
        end
        sleep(.1)
    end
end
local function printdisplay()
    while true do
        display.clear()
        display.setCursorPos(4,3)
        if (ownerdistance == -1) then
            display.setTextColor(colors.green)
            display.write("Press Button To Call ShopKeeper")
        elseif (ownerdistance == 0) then
            display.setTextColor(colors.yellow)
            display.write("Shopkeeper Is On Her Way")
        elseif (ownerdistance == 1) then
            display.setTextColor(colors.blue)
            display.write("Shopkeeper Is here")
        elseif (ownerdistance == 2) then
            display.setTextColor(colors.red)
            display.write("Sorry ShopKeeper Is Offline")
        elseif (ownerdistance == 3) then
            display.setTextColor(colors.lightBlue)
            display.write("ShopKeeper Is Close")
        else
            error("something Wrong")
        end
        sleep(.1)
    end
    
end

parallel.waitForAll(ownerlocation,redstone,printdisplay)
