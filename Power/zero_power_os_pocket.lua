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
local AlertLocations = {}
local init = 0
function testAlert(location,alt)
	if location == 1 and AlertLocations.one == true then
		if init == 0 then

			return colors.orange
		else
			return colors.red
		end
	elseif location == 2 and AlertLocations.two == true then
		if init == 0 then
			return colors.green
		else
			return colors.red
		end
	elseif location == 3 and AlertLocations.three == true then
		if init == 0 then
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			elseif alt == 2 then
				return colors.magenta
			end
		else
			return colors.red
		end
	elseif location == 4 and AlertLocations.four == true then
		if init == 0 then
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			elseif alt == 2 then
				return colors.magenta
			end
		else
			return colors.red
		end
	elseif location == 5 and AlertLocations.five == true then
		if init == 0 then
			if alt == 1 then
				return colors.cyan
			elseif alt ==0 then
				return colors.pink
			end
		else
			return colors.red
		end
	else
		if location == 1 then
			AlertLocations.one = false
			return colors.orange
		elseif location == 2 then
			AlertLocations.two = false
			return colors.green
		elseif location == 3 then
			AlertLocations.three = false
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			elseif alt == 2 then
				return colors.magenta
			end
		elseif location == 4 then
			AlertLocations.four = false
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			elseif alt == 2 then
				return colors.magenta
			end
		elseif location == 5 then
			AlertLocations.five = false
			if alt == 1 then
				return colors.cyan
			elseif alt ==0 then
				return colors.pink
			end
		end
		
	end
end
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
            AlertLocations = message.debug.alert.locations
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
		    term.setTextColor(testAlert(3,0))
            print("Power Held Percentage : ")
		    term.setTextColor(testAlert(3,2))
            print(" "..string.rep("\143",(w-2)*percent).." ")
            
		    term.setTextColor(testAlert(4,0))
            print("Network Power Percentage :")
		    term.setTextColor(testAlert(4,2))
            print(" "..string.rep("\143",(w-2)*npercent).." ")

		    term.setTextColor(colors.lightGray)
		    term.setTextColor(testAlert(3,1))
            print("Power Held : "..prettyEnergy(energy).."")
		    term.setTextColor(testAlert(4,1))
            print("Network Power : "..prettyEnergy(nenergy).."")
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
			if SleepMode == false then
                term.setTextColor(testAlert(5,0))
				print("Core Temp : "..prettyTemp(plasmaTemp).."")
			else
                term.setTextColor(testAlert(5,1))
				print("IN SLEEP MODE")
			end
		    term.setTextColor(testAlert(1,0))
			print("Deuterium : "..DeuteriumAmt.."mB")
		    term.setTextColor(testAlert(2,0))
			print("Tritium : "..TritiumAmt.."mB")
		    term.setTextColor(colors.lightGray)
            print(string.rep("=",w))
		    term.setTextColor(colors.gray)
            term.setCursorPos(1,h)
            term.write("Zero Creates Inc.")
            sleep(.1)
    end
end


function alertloop()
	while true do
		if init == 0 then
			init = 1
		else
			init = 0
		end
		sleep(.1)
	end
end
print("Client Loaded")
parallel.waitForAll(receivedata,printdata,alertloop)