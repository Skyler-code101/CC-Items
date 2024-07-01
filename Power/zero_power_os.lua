local energystorge = peripheral.wrap("back")
local monitor =  {peripheral.find("monitor")}
local networkerg = peripheral.wrap("left")
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
        modem = modems[k]
    end
end
if modem then
	rednet.open(peripheral.getName(modem))
    rednet.host("ZeroFusion", tostring(os.getComputerID()))
    modem.open(2707)
end
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
            monprint("Power Held Percentage : "..tostring(percent).."%",value)
            monprint("Network Power Percentage : "..tostring(npercent).."%",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
		    value.setTextColor(colors.lightBlue)
            monprint("Power Held : "..prettyEnergy(energy).."",value)
            monprint("Network Power : "..prettyEnergy(nenergy).."",value)
		    value.setTextColor(colors.lightGray)
            monprint("===========================================================================",value)
		    value.setTextColor(colors.pink)
			monprint("Core Temp : "..prettyTemp(plasmaTemp).."",value)
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
	while true do
		energy = energystorge.getEnergy()
		cap = energystorge.getMaxEnergy()
		nenergy = networkerg.getEnergy()
		ncap = networkerg.getMaxEnergy()
		plasmaTemp = Reactor.getPlasmaTemperature()
		DeuteriumAmt = Reactor.getDeuterium().amount
		TritiumAmt = Reactor.getTritium().amount
		local per = energy/cap
		percent =  per*100
		local nper = nenergy/ncap
		npercent =  nper*100
		sleep(.1)
	end
end
function alert()
	local ri = {peripheral.find("redstoneIntegrator")}
    while true do
		for key, value in pairs(ri) do
			if DeuteriumAmt <= 500 or TritiumAmt <= 500 or plasmaTemp <= 100000000 or percent <= 30 then
				value.setOutput("back",true)
			else
				value.setOutput("back",false)
			end
		end
		
        sleep(.1)
    end
end
print("Server Up")

parallel.waitForAll(energyload,findenergy,rednetcontrol,alert)