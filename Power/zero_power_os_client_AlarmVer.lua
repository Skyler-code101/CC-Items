local modem = peripheral.find("modem")
local monitor = peripheral.find("monitor")
if modem then
    rednet.open(peripheral.getName(modem))
end

local energy = 0
local cap = 0
local percent =0
local nenergy = 0
local ncap = 0
local npercent = 0
local plasmaTemp = 0
local DeuteriumAmt = 0
local TritiumAmt = 0
local connected = false
local w,h = monitor.getSize()
local function prettyEnergy(energy)
    if energy > 1000000000000 then
        return string.format("%.2f", energy/1000000000000).." TFE"
    elseif energy > 1000000000 then
        return string.format("%.2f", energy/1000000000).." GFE"
    elseif energy > 1000000 then
        return string.format("%.2f", energy/1000000).." MFE"
    elseif energy > 1000 then
        return string.format("%.2f", energy/1000).." kFE"
    else
        return string.format("%.2f", energy).." FE"
    end
end
local function prettyTemp(energy)
    if energy > 1000000000000 then
        return string.format("%.2f", energy/1000000000000).." Tk"
    elseif energy > 1000000000 then
        return string.format("%.2f", energy/1000000000).." GK"
    elseif energy > 1000000 then
        return string.format("%.2f", energy/1000000).." MK"
    elseif energy > 1000 then
        return string.format("%.2f", energy/1000).." kK"
    else
        return string.format("%.2f", energy).." K"
    end
end

function receivedata()
	while true do
        local id, message = rednet.receive("ZeroFusion",3)
        if message and message.energy then
            energy = message.energy
            cap = message.cap
            percent =message.percent
            nenergy = message.netenergy
            ncap = message.netcap
            npercent = message.netpercent
            plasmaTemp = message.plasmaTemp
            DeuteriumAmt = message.DeuteriumAmt
            TritiumAmt = message.TritiumAmt
		    local per = energy/cap
		    percent =  per*100
		    local nper = nenergy/ncap
		    npercent =  nper*100
        end
        
        local id = rednet.lookup("ZeroFusion", "576")
        if id then
            connected = true
        else
            connected = false
        end
        
    end
end
local linenu = 0
local function monprint(text)

    linenu = linenu + 1
    monitor.setCursorPos(1,linenu)
    monitor.write(text)
end
local function printdata()
    while true do
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
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================") 
		    monitor.setTextColor(colors.green)
            monprint("Hello Welcome To ZeroFusion(ZeroSPTN)")
            monprint("Client Mode")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================") 
            monprint("===========================================================================")
		    monitor.setTextColor(colors.blue)
            monprint("Power Held Percentage : "..tostring(percent).."%")
            monprint("Network Power Percentage : "..tostring(npercent).."%")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================")
		    monitor.setTextColor(colors.lightBlue)
            monprint("Power Held : "..prettyEnergy(energy).."")
            monprint("Network Power : "..prettyEnergy(nenergy).."")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================")
		    monitor.setTextColor(colors.pink)
			monprint("Core Temp : "..prettyTemp(plasmaTemp).."")
		    monitor.setTextColor(colors.orange)
			monprint("Deuterium : "..DeuteriumAmt.."mB")
		    monitor.setTextColor(colors.green)
			monprint("Tritium : "..TritiumAmt.."mB")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================")
		    monitor.setTextColor(colors.gray)
            monitor.setCursorPos(1,h)
            monitor.write("Zero Creates Inc.")
            sleep(.1)
    end
end
function alert()
    local ri = peripheral.find("redstoneIntegrator")
    while true do
        if DeuteriumAmt <= 500 or TritiumAmt <= 500 or plasmaTemp <= 100000000 or percent <= 30 then
            if ri then
                ri.setOutput("back",true)
            end
        else
            if ri then
                ri.setOutput("back",false)
            end
        end
        sleep(.1)
    end
end

print("Client Loaded")
parallel.waitForAll(receivedata,printdata,alert)