
local modem = peripheral.find("modem")
rednet.open(peripheral.getName(modem))
modem.open(2707)

function request()
    while true do
        print("Station Code")
        local station = read()
        print("Cargo")
        items = {}
        repeat
            print("item "..tostring(#items +1))
            print("ID: or Type X To Be Done")
            item = read():lower()
            if item ~= "x" then
                print("Amount:")
                amount = tonumber(read())
                itemarray = {}
                itemarray.name = item
                itemarray.count = amount
                items[#items+1] = itemarray
            end
        until item == "x"
        print("Sending Request")
        Relay = {}
        Relay.station = station
        Relay.cargo = {}
        Relay.cargo.items = items
        rednet.send(620,Relay,"ZeroCargo")
        local id, message
        repeat
            id, message = rednet.receive("ZeroCargo")
            
        until message.station == station
        if message.message ~= "Record Not Found" then
            if message.Items ~= nil then
                print("Request Accepted")
                if message.Items ~= 0 then
                    
                    for key, value in pairs(message.Items) do
                        print("Name: "..value.name.."Amount Avalable:"..value.amountreciveing)
                    end
                    local printed = ""
                    repeat
                        id, message = rednet.receive("ZeroCargo")
                        if printed ~= message.message then
                            printed = message.message
                            print(printed)
                        end
                        sleep(.1)
                    until message.message == "Cargo At Yard"
                    print("Your Cargo Has Arrived")
                else
                    print("Request Denied : Requested Items Are Out Of Stock")
                end
                
    
            end
        else
            print("Invalid Station Code")
        end
        
    end
end
request()