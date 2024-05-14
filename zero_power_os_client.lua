local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
if modem then
    rednet.open(peripheral.getName(modem))
end

local percent = ""
local npercent = ""
local energy = ""
local nenergy = ""

function receivedata()
	while true do
        local event = {os.pullEvent("rednet_message")}
        if (event[4] == "zeroSPTD" and event[2] == 491) then
            local message = textutils.unserialize(event[3])
            percent = tostring(message["p"])
            npercent = tostring(message["np"])
            energy = tostring(message["e"])
            nenergy = tostring(message["ne"])
        end
    end
end
local linenu = 0
local function monprint(text)

    local w,h = monitor.getSize()
    linenu = linenu + 1
    monitor.setCursorPos(1,linenu)
    monitor.write(text)
end
local function printdata()
    while true do
        if (monitor == nil) then
            term.clear()
		    term.setTextColor(colors.green)
            print("Hello Welcome To ZeroSPTD Client Mode\n\n\n")
            term.setTextColor(colors.blue)
            print("Power Held Percentage : "..percent.."%\n")
            print("Network Power Percentage : "..npercent.."%\n\n")
		    term.setTextColor(colors.lightBlue)
            print("Power Held : "..energy.."FE\n")
            print("Network Power : "..nenergy.."FE\n")
        sleep(.3)
        else
            linenu = 0
            monitor.clear()
		    monitor.setTextColor(colors.green)
            monprint("Hello Welcome To ZeroSPTD ")
            monprint("Client Mode")
            monprint("") 
            monprint("")
		    monitor.setTextColor(colors.blue)
            monprint("Power Held Percentage : "..percent.."%")
            monprint("Network Power Percentage : "..npercent.."%")
		    monitor.setTextColor(colors.lightBlue)
            monprint("")
            monprint("Power Held : "..energy.."FE")
            monprint("Network Power : "..nenergy.."FE")
            
        sleep(.3)
        end
    end
end



parallel.waitForAll(receivedata,printdata)