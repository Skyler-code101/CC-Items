local energystorge = peripheral.wrap("right")
local monitor =  peripheral.find("monitor")
local w,h = monitor.getSize()
local networkerg = peripheral.wrap("left")
local energy = 0
local cap = 0
local percent =0
local transferrate =0
local modems = {peripheral.find("modem")}
local modem
local nenergy = 0
local ncap = 0
local npercent = 0

for k,v in pairs(modems) do
    if v.isWireless() == true then
        modem = modems[k]
    end
end
if modem then
	rednet.open(peripheral.getName(modem))
    rednet.host("zeroSPTD", tostring(os.getComputerID()))
    modem.open(2707)
end
local function rednetcontrol()
	while true do
		local t = {p=percent,np=npercent,e=energy,ne=nenergy}

		rednet.broadcast(t,"zeroSPTD")	
		sleep(.1)
	end
end
local function findenergy()
	while true do
		monitor.clear()
		if (percent == 100) then
			monitor.setCursorPos(1 , h/2)
			monitor.write("Power Full")
		elseif (percent == 0) then
			monitor.setCursorPos(1 , h/2)
			monitor.write("ERROR Power Dead")
		else 
			monitor.setCursorPos(1  , h/2)
			monitor.write("Power : "..tostring(percent).."%")
			
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
		local per = energy/cap
		percent =  per*100
		local nper = nenergy/ncap
		npercent =  nper*100
		sleep(.1)
	end
end

parallel.waitForAll(energyload,findenergy,rednetcontrol)