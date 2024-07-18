
sleep(.1)


local energystorge = peripheral.wrap("back")
local monitor =  {peripheral.find("monitor")}
local networkerg = peripheral.wrap("quantumEntangloporter_9")
local Reactor = peripheral.find("fusionReactorLogicAdapter")
local energy = 0
local cap = 0
local percent =0
local transferrate =0
local modems = {peripheral.find("modem")}
local modem
local nenergy = 0
local ncap = 0
local npercent = 0
local plasmaTemp = 0
local DeuteriumAmt = 0
local TritiumAmt = 0
local SleepMode = false
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
if modem then
	rednet.open(peripheral.getName(modem))
    rednet.host("ZeroFusion", tostring(os.getComputerID()))
    modem.open(2707)
	print("Server Up")
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
		rednet.broadcast(t,"ZeroFusion")	
		sleep(1)
	end
end
local function monprint(text, monitorv)

    local w,h = monitorv.getSize()
    linenu = linenu + 1
    monitorv.setCursorPos(1,linenu)
    monitorv.write(text)
end
local function findenergy()
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
		    value.setTextColor(colors.blue)
            monprint("Power Held Percentage : "..string.format("%.2f", percent).."%",value)
            monprint("Network Power Percentage : "..string.format("%.2f", npercent).."%",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
		    value.setTextColor(colors.lightBlue)
            monprint("Power Held : "..prettyEnergy(energy).."",value)
            monprint("Network Power : "..prettyEnergy(nenergy).."",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
			if SleepMode == false then
                value.setTextColor(colors.pink)
				monprint("Core Temp : "..prettyTemp(plasmaTemp).."",value)
			else
                value.setTextColor(colors.cyan)
				monprint("IN SLEEP MODE CORE HEAT REDUSED",value)
			end
		    value.setTextColor(colors.orange)
			monprint("Deuterium : "..DeuteriumAmt.."mB",value)
		    value.setTextColor(colors.green)
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
    while true do
		for key, value in pairs(ri) do
			if DeuteriumAmt <= 500 or TritiumAmt <= 500 or percent <= 30 or plasmaTemp <= 100000000 then
				value.setOutput("back",true)
			else
				value.setOutput("back",false)
			end
		end
		
        sleep(.1)
    end
end
print("Loaded, Launching")
parallel.waitForAll(energyload,findenergy,rednetcontrol,alert)