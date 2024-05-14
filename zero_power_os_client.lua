local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
if modem then
    rednet.open(peripheral.getName(modem))
end
local percent = 0
local npercent = 0
local energy = 0
local nenergy = 0

function receivedata()
	while true do
        local event = {os.pullEvent("rednet_message")}
            local message = event[3]
            message["p"] = percent
            message["np"] = npercent
            message["e"] = energy
            message["ne"] = nenergy
            print(percent)
    end
end
local linenu = 0
local function monprint(text)
    local w,h = monitor.getSize()
    if (linenu == h-1) then
        monitor.clear()

        linenu = 0
    end
    linenu = linenu + 1
    monitor.setCursorPos(1,linenu)
    monitor.write(text)
end
local function printdata()
    while true do
        if (monitor == nil) then
            term.clear()
            print("Hello Welcome To ZeroSPTD Client Mode\n\n\n")
            print("Power Held Percentage : "..tostring(percent).."%\n")
            print("Network Power Percentage : "..tostring(npercent).."%\n\n")
            print("Power Held : "..tostring(energy).."FE\n")
            print("Network Power : "..tostring(nenergy).."FE\n")
            sleep(.1)
        else
            monitor.clear()
            monprint("Hello Welcome To ZeroSPTD Client Mode")
            monprint("")
            monprint("")
            monprint("Power Held Percentage : "..tostring(percent).."%")
            monprint("Network Power Percentage : "..tostring(npercent).."%")
            monprint("")
            monprint("Power Held : "..tostring(energy).."FE")
            monprint("Network Power : "..tostring(nenergy).."FE")
            sleep(.1)
        end
    end
end



parallel.waitForAll(receivedata)