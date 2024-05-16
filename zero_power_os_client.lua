local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
if modem then
    rednet.open(peripheral.getName(modem))
end

local percent = ""
local npercent = ""
local energy = ""
local nenergy = ""
local connected = false

function receivedata()
	while true do
        local event = {os.pullEvent("rednet_message")}
        if (event[4] == "zeroSPTN" and event[2] == 491) then
            local message = textutils.unserialize(event[3])
            percent = tostring(message["p"])
            npercent = tostring(message["np"])
            energy = tostring(message["e"])
            nenergy = tostring(message["ne"])
        end
        local id = rednet.lookup("zeroSPTN", "491")
        if id then
            connected = true
        else
            connected = false
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
            
            if (connected) then
		        term.setTextColor(colors.green)
                print("Server Online")
            else
                term.setTextColor(colors.red)
                print("Server Dead")
            end
		    term.setTextColor(colors.green)
            print("Hello Welcome To ZeroSPTN Client Mode\n\n\n")
            term.setTextColor(colors.blue)
            print("Power Held Percentage : "..percent.."%\n")
            print("Network Power Percentage : "..npercent.."%\n\n")
		    term.setTextColor(colors.lightBlue)
            print("Power Held : "..energy.."FE\n")
            print("Network Power : "..nenergy.."FE\n")
            sleep(.1)
        else
            linenu = 0
            monitor.clear()
            if (connected) then
                monitor.setTextColor(colors.green)
                monprint("Server Online")
            else
                monitor.setTextColor(colors.red)
                monprint("Server Dead")
            end
            monitor.setTextColor(colors.green)
		    monitor.setTextColor(colors.gray)
            monprint("===========================================================================") 
		    monitor.setTextColor(colors.green)
            monprint("Hello Welcome To ZeroSPTN")
            monprint("Client Mode")
		    monitor.setTextColor(colors.gray)
            monprint("===========================================================================") 
            monprint("===========================================================================")
		    monitor.setTextColor(colors.blue)
            monprint("Power Held Percentage : "..percent.."%")
            monprint("Network Power Percentage : "..npercent.."%")
		    monitor.setTextColor(colors.gray)
            monprint("===========================================================================")
		    monitor.setTextColor(colors.lightBlue)
            monprint("Power Held : "..energy.."FE")
            monprint("Network Power : "..nenergy.."FE")
		    monitor.setTextColor(colors.gray)
            monprint("===========================================================================")
            monprint("===========================================================================")
            sleep(.1)
        end
    end
end



parallel.waitForAll(receivedata,printdata)