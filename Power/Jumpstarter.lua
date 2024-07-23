
local monitor =  peripheral.find("monitor")

local laser = peripheral.wrap("bottom")
local ReactorLoader = peripheral.find("minecraft:chest")
local Reactor = peripheral.find("mekanismgenerators:fusion_reactor_frame")
local HohlraumHolder = peripheral.find("minecraft:dropper")

local AvalablePrimes = 0

local Charging = false

local HasHohlraum = false

local LoadingHohlraum = false

local percentTillNextPrime = 0

function findPrimeAmounts()
    while true do
        local erg = laser.getEnergy()/2.5
        if erg >= 500000000 and erg < 1000000000 then
            AvalablePrimes = 1
            
            percentTillNextPrime = (erg-500000000)/500000000
        elseif erg >= 1000000000 and erg < 1500000000 then
            AvalablePrimes = 2
            percentTillNextPrime = (erg-1000000000)/500000000
        elseif erg >= 1500000000 and erg ~= 2000000000 then
            AvalablePrimes = 3
            percentTillNextPrime = (erg-1500000000)/500000000
        elseif erg == 2000000000 then
            AvalablePrimes = 4
            percentTillNextPrime = 1
        else
            AvalablePrimes = 0
            percentTillNextPrime = (erg)/500000000
        end
        Charging = redstone.getOutput("top")
        if Reactor.getItemDetail(1) == nil then
            HasHohlraum = false
        else
            LoadingHohlraum = false
            HasHohlraum = true
        end
        sleep(.1)
    end
end

function visual()
    while true do
        monitor.clear()
        monitor.setTextScale(.5)
        monitor.setCursorPos(1,1)
        monitor.setTextColor(colors.cyan)
        monitor.write("Prime ")
        monitor.setTextColor(colors.blue)
        monitor.write("[]")
        monitor.setCursorPos(1,2)
        monitor.write(tostring(AvalablePrimes).."/4 Ready")
        monitor.setCursorPos(1,4)
        if Charging == true then
            monitor.setTextColor(colors.green)
            monitor.write("Charge ")
        else
            monitor.setTextColor(colors.red)
            monitor.write("Charge ")
        end
        monitor.setTextColor(colors.blue)
        monitor.write("[]")
        monitor.setTextColor(colors.yellow)
        monitor.setCursorPos(1,5)
        monitor.write(string.format("%.0f", percentTillNextPrime*100).."% Primed")
        
        monitor.setCursorPos(1,7)
        if HasHohlraum == false and LoadingHohlraum == false then
            monitor.setTextColor(colors.cyan)
            monitor.write("Load Starter ")
            monitor.setTextColor(colors.blue)
            monitor.write("[]")
        end
        sleep(.1)
    end
end

function touch()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        if y == 1 then
            if x == 7 or x == 8 then
                redstone.setOutput("bottom", true)
                sleep()
                redstone.setOutput("bottom", false)
            end
        elseif y == 4 then
            if x == 8 or x == 9 then
                redstone.setOutput("top", not redstone.getOutput("top"))
            end
        elseif y == 7 then
            if x == 13 or x == 14 then
                LoadingHohlraum = true
                local ValidSlot = 0
                for i = 1, HohlraumHolder.size() do
                    if HohlraumHolder.getItemDetail(i) ~= nil then
                        ValidSlot = i
                        break
                    end
                end
                if ValidSlot ~= 0 then
                    ReactorLoader.pullItems(peripheral.getName(HohlraumHolder), ValidSlot)
                else
                    error("no ValidSlot")
                end
            end
        end
    end
end

parallel.waitForAll(findPrimeAmounts,visual,touch)