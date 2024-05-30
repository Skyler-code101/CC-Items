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
    rednet.host("zeroSPTN", tostring(os.getComputerID()))
    modem.open(2707)
end
local function rednetcontrol()
	while true do
		local t = {p=percent,np=npercent,e=energy,ne=nenergy}
		local ts = textutils.serialize(t)
		rednet.broadcast(ts,"zeroSPTN")	
		sleep(1)
	end
end
local function monprint(text)

    local w,h = monitor.getSize()
    linenu = linenu + 1
    monitor.setCursorPos(1,linenu)
    monitor.write(text)
end
local function findenergy()
	while true do
            linenu = 0
            monitor.clear()
		    monitor.setTextColor(colors.lightGray)
			monprint("===========================================================================") 
		    monitor.setTextColor(colors.red)
            monprint("Hello Welcome To ZeroSPTN ")
            monprint("Server Mode")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================") 
            monprint("===========================================================================")
		    monitor.setTextColor(colors.blue)
            monprint("Power Held Percentage : "..tostring(percent).."%")
            monprint("Network Power Percentage : "..tostring(npercent).."%")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================")
		    monitor.setTextColor(colors.lightBlue)
            monprint("Power Held : "..tostring(energy).."FE")
            monprint("Network Power : "..tostring(nenergy).."FE")
		    monitor.setTextColor(colors.lightGray)
            monprint("===========================================================================")
            monprint("===========================================================================")
		    monitor.setTextColor(colors.gray)
            monitor.setCursorPos(1,h)
            monitor.write("Zero Creates Inc.")
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
print("Server Up")

parallel.waitForAll(energyload,findenergy,rednetcontrol)