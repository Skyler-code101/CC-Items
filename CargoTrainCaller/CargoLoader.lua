
local loadingStation = peripheral.find("Create_Station")

local meBride = peripheral.find("meBridge")
local chest = peripheral.find("minecraft:chest")

local modem 
local modems = {peripheral.find("modem")}
for k,v in pairs(modems) do
    if v.isWireless() == true then
        modem = v
    end
end
if modem then
	rednet.open(peripheral.getName(modem))
    rednet.host("ZeroCargo", "ZeroLoader")
    modem.open(2707)
	print("Server Up")
end
function received()
    while true do
        local id, message = rednet.receive("ZeroCargo")
        repeat
            sleep(.1)
        until loadingStation.isTrainPresent()
        if message.station ~= nil and message.cargo ~= nil then
            print("request received From "..message.station.."\nrequesting "..textutils.serialise(message.cargo).."\n")
            if fs.exists(fs.combine("stations/",message.station)) then
                local relay = fs.open(fs.combine("stations/",message.station),"r")
                local sched = textutils.unserialise(relay.readAll())
                relay.close()
                loadingStation.setSchedule(sched)
                local FoundItems = {}
                for index, value in pairs(message.cargo.items) do
                    local item = meBride.exportItem(value,"up")
                    if item ~= 0  then
                        FoundItems[index] = {}
                        FoundItems[index].name = value.name
                        FoundItems[index].amountreciveing = item
                    end
                end
                Relay = {}
                if #FoundItems == 0 then
                    Relay.Items = 0
                    Relay.station = message.station
                    Relay.message = "Invalid Amount"
                    rednet.send(id,Relay,"ZeroCargo")
                else
                    Relay.Items = FoundItems
                    Relay.station = message.station
                    Relay.message = "Loading Items"
                    rednet.send(id,Relay,"ZeroCargo")
                    repeat
                        sleep(.1)
                    until #chest.list() == 0
                    sleep(30)
                    Relay.message = "On Its Way"
                    redstone.setOutput("left",true)
                    rednet.send(id,Relay,"ZeroCargo")
                    sleep(.1)
                    redstone.setOutput("left",false)
                    repeat
                        sleep(.1)
                    until loadingStation.isTrainPresent()
                    
                    Relay.message = "Cargo At Yard"
                    rednet.send(id,Relay,"ZeroCargo")
    
                end
                
            else
                Relay = {}
                Relay.station = message.station
                Relay.message = "Record Not Found"
                rednet.send(id,Relay,"ZeroCargo")

            end
        end
    end
end

function testifper()
    while true do
        if chest == nil then
            error("No Chest",1)
        end
        if meBride == nil then
            error("No meBridge",1)
        end
        
        if loadingStation == nil then
            error("No loadingStation",1)
        end
        sleep(.1)
    end
end
parallel.waitForAll(received,testifper)