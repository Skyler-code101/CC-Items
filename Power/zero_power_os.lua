
sleep(.1)

if not fs.exists("/DiscordHook.lua") then
    local file = http.get("https://raw.githubusercontent.com/Wendelstein7/DiscordHook-CC/master/DiscordHook.lua")
    local file2 = io.open("/DiscordHook.lua", "w")
    file2:write(file.readAll())
    file2:close()
    file.close()
end
local use_discord
local success, discord_hook
local discord = require("DiscordHook")
success, discord_hook = discord.createWebhook({inputhere})
if not success then
	error(discord_hook)
else
	use_discord = true
end

local energystorge = peripheral.wrap("back")
local monitor =  {peripheral.find("monitor")}
local networkerg = peripheral.wrap("quantumEntangloporter_9")
local Reactor = peripheral.find("fusionReactorLogicAdapter")
local energy = 10000000000
local cap = 10000000000
local percent = 100
local modems = {peripheral.find("modem")}
local modem
local nenergy = 10000000000
local ncap = 10000000000
local npercent = 100
local plasmaTemp = 1000000000000
local DeuteriumAmt = 1000000000000
local TritiumAmt = 1000000000000
local SleepMode = false
local AlertMode = false
local AlertLocations = {}
AlertLocations.one = false
AlertLocations.two = false
AlertLocations.three = false
AlertLocations.four = false
AlertLocations.five = false

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
        return string.format("%.2f", energy/1000000000000).." TK"
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

for k,v in pairs(modems) do
    if v.isWireless() == true then
        modem = v
    end
end
local init = 0
function testAlert(location,alt)
	if location == 1 and DeuteriumAmt <= 500 then
		AlertLocations.one = true
		if init == 0 then

			return colors.orange
		else
			return colors.red
		end
	elseif location == 2 and TritiumAmt <= 500 then
		AlertLocations.two = true
		if init == 0 then
			return colors.green
		else
			return colors.red
		end
	elseif location == 3 and percent <= 30 then
		AlertLocations.three = true
		if init == 0 then
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			end
		else
			return colors.red
		end
	elseif location == 4 and npercent <= 50 then
		AlertLocations.four = true
		if init == 0 then
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
			end
		else
			return colors.red
		end
	elseif location == 5 and plasmaTemp <= 100000000 then
		AlertLocations.five = true
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
			end
		elseif location == 4 then
			AlertLocations.four = false
			if alt == 1 then
				return colors.lightBlue
			elseif alt ==0 then
				return colors.blue
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
if modem then
	rednet.open(peripheral.getName(modem))
    rednet.host("ZeroFusion", tostring(os.getComputerID()))
    modem.open(2707)
	print("Server Up")
end
function ForceSendRednet()
	local t = {}
		t.energy = energy
		t.netenergy = nenergy
		t.netcap = ncap
		t.cap = cap
		t.percent = percent
		t.netpercent = npercent
		t.plasmaTemp = plasmaTemp
		t.DeuteriumAmt = DeuteriumAmt
		t.TritiumAmt = TritiumAmt
		t.SleepMode = SleepMode
		t.AlertMode = AlertMode
		t.debug = {}
		t.debug.alert = {}
		t.debug.alert.locations = AlertLocations
		rednet.broadcast(t,"ZeroFusion")
end
print("Loading Visual And Backgound Processes")
local function rednetcontrol()
	while true do
		local t = {}
		t.energy = energy
		t.netenergy = nenergy
		t.netcap = ncap
		t.cap = cap
		t.percent = percent
		t.netpercent = npercent
		t.plasmaTemp = plasmaTemp
		t.DeuteriumAmt = DeuteriumAmt
		t.TritiumAmt = TritiumAmt
		t.SleepMode = SleepMode
		t.AlertMode = AlertMode
		t.debug = {}
		t.debug.alert = {}
		t.debug.alert.locations = AlertLocations
		rednet.broadcast(t,"ZeroFusion")
		sleep(.5)
	end
end
local function monprint(text, monitorv)

    local w,h = monitorv.getSize()
    linenu = linenu + 1
    monitorv.setCursorPos(1,linenu)
    monitorv.write(text)
end
local function findenergy()
	AV = 1
	while true do
		for index, value in ipairs(monitor) do
			local w,h = value.getSize()
			linenu = 0
            value.clear()
		    value.setTextColor(colors.lightGray)
			monprint("===========================================================================",value) 
		    value.setTextColor(colors.red)
            monprint("Hello Welcome To ZeroFusion(ZeroSPTN) ",value)
            monprint("Server Mode",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value) 
            monprint("===========================================================================",value)
		    value.setTextColor(testAlert(3,0))
            monprint("Power Held Percentage : "..string.format("%.2f", percent).."%",value)
		    value.setTextColor(testAlert(4,0))
            monprint("Network Power Percentage : "..string.format("%.2f", npercent).."%",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
		    value.setTextColor(testAlert(3,1))
            monprint("Power Held : "..prettyEnergy(energy).."",value)
		    value.setTextColor(testAlert(4,1))
            monprint("Network Power : "..prettyEnergy(nenergy).."",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
			if SleepMode == false then
                value.setTextColor(testAlert(5,0))
				monprint("Core Temp : "..prettyTemp(plasmaTemp).."",value)
			else
                value.setTextColor(testAlert(5,1))
				monprint("Core Temp : "..prettyTemp(plasmaTemp).."(Sleep Mode)",value)
			end
		    value.setTextColor(testAlert(1,0))
			monprint("Deuterium : "..DeuteriumAmt.."mB",value)
		    value.setTextColor(testAlert(2,0))
			monprint("Tritium : "..TritiumAmt.."mB",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)

		    value.setTextColor(colors.gray)
            value.setCursorPos(1,h)
            value.write("Zero Creates Inc.")
		end
            
		sleep(.1)
	end
end
local function energyload()
	Reactor.setInjectionRate(20)
	while true do
		energy = energystorge.getEnergy()/2.5
		cap = energystorge.getMaxEnergy()/2.5
		nenergy = networkerg.getEnergy()/2.5
		ncap = networkerg.getMaxEnergy()/2.5
		plasmaTemp = Reactor.getPlasmaTemperature()
		DeuteriumAmt = Reactor.getDeuterium().amount
		TritiumAmt = Reactor.getTritium().amount
		local per = energy/cap
		percent =  per*100
		local nper = nenergy/ncap
		npercent =  nper*100
		if percent == 100 and Reactor.getInjectionRate() == 20 and SleepMode == false then
			Reactor.setInjectionRate(2)
			SleepMode = true
			print("Sleep Mode Activated Due To Power Full")
		elseif percent <= 90 and Reactor.getInjectionRate() == 2 and SleepMode == true then
			Reactor.setInjectionRate(20)
			SleepMode = false
			print("Sleep Mode Deactivated Due To Power Going Below 90%")
		elseif SleepMode == true and Reactor.getInjectionRate() ~= 2 then
			Reactor.setInjectionRate(2)
		end
		sleep(.1)
	end
end
function alert()
	local ri = {peripheral.find("redstoneIntegrator")}
	print("Launched All Processes")
	local alertSent = false
    while true do
		for key, value in pairs(ri) do
			if DeuteriumAmt <= 500 or TritiumAmt <= 500 or percent <= 30 or npercent <= 50 or plasmaTemp <=100000000 then
				value.setOutput("back",true)
				AlertMode = true
			else
				value.setOutput("back",false)
				AlertMode = false
			end
		end
		if DeuteriumAmt <= 500 or TritiumAmt <= 500 or percent <= 30 or npercent <= 50 or plasmaTemp <= 100000000 then
			if alertSent == false then
				if DeuteriumAmt <= 500 then
					discord_hook.send("Deuterium Depleating", "ZeroFusion: Alert")
				end
				if TritiumAmt <= 500 then
					discord_hook.send("Tritium Depleating", "ZeroFusion: Alert")
				end
				if percent <= 30 then
					discord_hook.send("Power In Storage Has Dropped Below 30%", "ZeroFusion: Alert")
				end
				if npercent <= 50 then
					discord_hook.send("Power In Network Has Dropped Below 50%", "ZeroFusion: Alert")
				end
				if plasmaTemp <= 100000000 then
					discord_hook.send("Core Heat Below Natural Level", "ZeroFusion: Alert")
				end
				alertSent = true
				ForceSendRednet()
			end
		else
			alertSent = false
		end

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
print("Loaded, Launching")
parallel.waitForAll(energyload,findenergy,rednetcontrol,alert,alertloop)