local modems = {peripheral.find("modem")}
local monitor = peripheral.find("monitor")
local modem
for k,v in pairs(modems) do
    if v.isWireless() == true then
        modem = v
    end
end
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
local SleepMode = false
local connected = false
local w,h = term.getSize()
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
            SleepMode = message.SleepMode
		    local per = energy/cap
		    percent =  per
		    local nper = nenergy/ncap
		    npercent =  nper
        end
        
        local id = rednet.lookup("ZeroFusion", "576")
        if id then
            connected = true
        else
            connected = false
        end
        
    end
end
local function printdata()
    while true do
            term.clear()
            term.setCursorPos(1,1)
            if (connected) then
                term.setTextColor(colors.green)
                print("Server Online")
            else
                term.setTextColor(colors.red)
                print("Server Dead")
            end
            term.setTextColor(colors.green)
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
		    term.setTextColor(colors.green)
            print("Welcome To ZeroFusion")
            print("Client Mode")
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
            print(string.rep("=",w))
		    term.setTextColor(colors.blue)
            print("Power Held Percentage : ")
		    term.setTextColor(colors.magenta)
            print(" "..string.rep("\143",(w-2)*percent).." ")
            
		    term.setTextColor(colors.blue)
            print("Network Power Percentage :")
		    term.setTextColor(colors.magenta)
            print(" "..string.rep("\143",(w-2)*npercent).." ")

		    term.setTextColor(colors.lightGray)
		    term.setTextColor(colors.lightBlue)
            print("Power Held : "..prettyEnergy(energy).."")
            print("Network Power : "..prettyEnergy(nenergy).."")
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
			if SleepMode == false then
                term.setTextColor(colors.pink)
				print("Core Temp : "..prettyTemp(plasmaTemp).."")
			else
                term.setTextColor(colors.cyan)
				print("IN SLEEP MODE")
			end
		    term.setTextColor(colors.orange)
			print("Deuterium : "..DeuteriumAmt.."mB")
		    term.setTextColor(colors.green)
			print("Tritium : "..TritiumAmt.."mB")
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
		    term.setTextColor(colors.gray)
            term.setCursorPos(1,h)
            term.write("Zero Creates Inc.")
            sleep(.1)
    end
end


print("Client Loaded")
parallel.waitForAll(receivedata,printdata)