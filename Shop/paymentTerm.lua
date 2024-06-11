local monitor = peripheral.find("monitor")
local ws = http.websocket(myURL)
local lversionfile = fs.open("Version","r")
local gversionfile = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Shop/PaymentVersion.json")
local lfiledata = textutils.unserialise(lversionfile.readAll())
local gfiledata = textutils.unserialise(gversionfile.readAll())
lversionfile.close()

function monitorPinEnter()
    local pin = ""
    monitor.setTextScale(1.8)
    monitor.setCursorPos(1,1)
    monitor.setTextColor(colors.white)
    monitor.write("123 ")
    monitor.setTextColor(colors.red)
    monitor.write("X")
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1,2)
    monitor.write("4560")
    monitor.setCursorPos(1,3)
    monitor.write("789 ")
    monitor.setTextColor(colors.green)
    monitor.write(">")
    monitor.setTextColor(colors.white)
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        if (x == 1 and y == 1) then
            pin = pin.."1"
        elseif (x == 2 and y == 1) then
            pin = pin.."2"
        elseif (x == 3 and y == 1) then
            pin = pin.."3"
        elseif (x == 5 and y == 1) then
            pin = pin:sub(1,-2)
        elseif (x == 1 and y == 2) then
            pin = pin.."4"
        elseif (x == 2 and y == 2) then
            pin = pin.."5"
        elseif (x == 3 and y == 2) then
            pin = pin.."6"
        elseif (x == 4 and y == 2) then
            pin = pin.."0"
        elseif (x == 1 and y == 3) then
            pin = pin.."7"
        elseif (x == 2 and y == 3) then
            pin = pin.."8"
        elseif (x == 3 and y == 3) then
            pin = pin.."9"
        elseif (x == 5 and y == 3) then
            monitor.clear()
            return pin
        end
    end
end
function DisplayMessage(message,color)
    monitor.setTextScale(.5)
    monitor.setCursorPos(1,5)
    monitor.setTextColor(color)
    monitor.write(message)
end
function startup()
    term.clear()
    term.setCursorPos(1,1)
    term.setTextColor(colors.orange)
    print("Welcome To the Payment Panel")
    term.setTextColor(colors.red)
    print("     1 : Account Wizard \n     2 : Payment Device \n     3 : Selling Device")
    term.setTextColor(colors.yellow)
    write("> ")
    term.setTextColor(colors.white)
local promt = read()
if (promt == "1") then
    if (disk.isPresent("right")) then
        term.setTextColor(colors.red)
        print("Welcome To the Account Wizard\n")
        term.setTextColor(colors.yellow)
        write("Account Holder Name> ")
        term.setTextColor(colors.white)
        local datal={}
        datal.status = "create"
        datal.playername = read()
        term.setTextColor(colors.blue)
        print("Enter Account Auth Pin On Screen")
        datal.pin = tonumber(monitorPinEnter())
        print(tostring(datal.pin))
        term.setTextColor(colors.green)
        print("Starting Creation...")
        local startupfile = fs.open("disk/startup","w")
        local datam = {}
        local data = {}
        local event,url,message
        datal.computer = os.getComputerID()
        repeat
            print(datal)
            datam.playername  = datal.playername
            ws.send(textutils.serialise(datal))
            event, url, message = os.pullEvent("websocket_message")
            data = textutils.unserialise(message)
        until (data ~= nil and data.status == "Created" and data.handler == os.getComputerID() and message ~= "ping")
        datam.fulllink = data.fulllink
        local listw = fs.open("disk/ECard/Data","w")
        listw.write(textutils.serialise(datam))
        listw.close()
        startupfile.write(http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Shop/Ecard/ECard.lua").readAll())
        startupfile.close()
        disk.setLabel("right","ECard")
        print("Finished Creation")      
    else 
        print("Please Enter ECard")
    end
elseif (promt == "2") then
    term.setTextColor(colors.green)
print("Loading ECard...")
if (fs.exists("disk/ECard/Data")) then     
    datafile = fs.open("disk/ECard/Data","r")
    data = textutils.unserialise(datafile.readAll())
    print("Loading Bank Acount...")
    local sendstate ={}
    sendstate.computer = os.getComputerID()
    sendstate.status = "lookup"
    sendstate.id = data.fulllink
    local datar = {}
    ws.send(textutils.serialise(sendstate))
    repeat
        event, url, message = os.pullEvent("websocket_message")
        datar = textutils.unserialise(message)

    until (datar.handler == os.getComputerID() and url == myURL)
    if datar.status == "NonExistent" then
        print("unable to find account")
    elseif datar.status == "Reply" then
        local dataw = datar
        term.setTextColor(colors.red)
    print("Name: "..datar.playername)
    term.setTextColor(colors.blue)
    print("Enter Pin On Screen")
    local pin = tonumber(monitorPinEnter())
    print(tostring(pin))
    term.setTextColor(colors.yellow)
    write("Charge Amount > ")
    term.setTextColor(colors.white)
    local charge = tonumber(read())
    sendstate.computer = os.getComputerID()
    sendstate.status = "charge"
    sendstate.id = data.fulllink
    sendstate.charge = charge
    sendstate.pin = pin
    ws.send(textutils.serialise(sendstate))
    term.setTextColor(colors.green)
    print("Processing...")
    repeat
        event, url, message = os.pullEvent("websocket_message")
        datar = textutils.unserialise(message)

    until (datar.handler == os.getComputerID() and url == myURL)
    if datar.status == "ReplyAuth" then
        if datar.ReplyMessage == "Accepted Payment" then
            print("Aproved Payment")
            DisplayMessage("Aproved Payment",colors.green)
        elseif datar.ReplyMessage == "Insufficient Funds" then
            DisplayMessage("Declined",colors.red)
            print("Declined : Insufficient Funds")
        elseif datar.ReplyMessage == "Invalid Pin" then
            
            DisplayMessage("Declined",colors.red)
            print("Declined : Invalid Pin")
        end
    end
    
end
else
    print("Insert ECard")
end
elseif promt == "3" then
    term.setTextColor(colors.green)
    print("Loading ECard...")
    if (fs.exists("disk/ECard/Data")) then     
        datafile = fs.open("disk/ECard/Data","r")
        data = textutils.unserialise(datafile.readAll())
        print("Loading Bank Acount...")
        local sendstate ={}
        sendstate.computer = os.getComputerID()
        sendstate.status = "lookup"
        sendstate.id = data.fulllink
        local datar = {}
        ws.send(textutils.serialise(sendstate))
        repeat
            event, url, message = os.pullEvent("websocket_message")
            datar = textutils.unserialise(message)
    
        until (datar.handler == os.getComputerID() and url == myURL)
        if datar.status == "NonExistent" then
            print("unable to find account")
        elseif datar.status == "Reply" then
            local dataw = datar
            term.setTextColor(colors.red)
        print("Name: "..datar.playername)
        term.setTextColor(colors.yellow)
        write("Enter Pin On Screen")
        local pin = tonumber(monitorPinEnter())
        print(tostring(pin))
        write("Sell Amount > ")
        term.setTextColor(colors.white)
        local charge = tonumber(read())
        sendstate.computer = os.getComputerID()
        sendstate.status = "sell"
        sendstate.id = data.fulllink
        sendstate.charge = charge
        sendstate.pin = pin
        ws.send(textutils.serialise(sendstate))
        term.setTextColor(colors.green)
        print("Processing...")
        repeat
            event, url, message = os.pullEvent("websocket_message")
            datar = textutils.unserialise(message)
    
        until (datar.handler == os.getComputerID() and url == myURL)
        if datar.status == "ReplyAuth" then
            if datar.ReplyMessage == "Accepted Payment" then
                print("Aproved Payment")
                DisplayMessage("Aproved Payment",colors.green)
            elseif datar.ReplyMessage == "InvalidAmt" then
                DisplayMessage("Declined",colors.red)
                print("Declined : Invalid Amount")
            elseif datar.ReplyMessage == "Invalid Pin" then
                
                DisplayMessage("Declined",colors.red)
                print("Declined : Invalid Pin")
            end
        end
        
    end
end
elseif promt == "Version" then
    print("Version: "..lfiledata.version)
elseif promt == "Host" then
    local modem = peripheral.find("modem") or print("No Wired Modem Exists")
    if peripheral.find("modem") then
        parallel.waitForAny(Hostmode)
    end
end

sleep(2)
monitor.clear()
startup()
end
function StopHost()
    while true do
        local event, key, is_held = os.pullEvent("key")
        if key == keys.endPage then
            break
        end
    end
    print("Host Stopped")
end
function Hostmode()
    while true do
        write("Host Port > ")
    local hostport = tonumber(read())
    modem.open(hostport)
    print("Host Open On Port "..tostring(hostport))
    local mode = 0
    local ReplyMessage = {}
    local sendstate = {}
    local loadedcharge = 0
    print()
    while true do
        local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    if mode == 0 then
        if message.functionCall == "SetMode" then
            if message.mode == 1 then
                mode = 1
                print("Mode Changed To Mode 1")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Changed To Mode 1"
                modem.transmit(hostport, 0, ReplyMessage)
            elseif message.mode == 2 then
                mode = 2
                print("Mode Changed To Mode 2")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Changed To Mode 1"
                modem.transmit(hostport, 0, ReplyMessage)
            elseif message.mode == 0 then
                mode = 0
                print("Mode Reset")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Reset"
                modem.transmit(hostport, 0, ReplyMessage)
            end
        elseif message.functionCall == "GetModes" then
            ReplyMessage.functionCall = "Reply"
            ReplyMessage.replyType = "print"
            ReplyMessage.data = "1 : Paying To You\n2 : Paying To Player"
            modem.transmit(hostport, 0, ReplyMessage)
        elseif message.functionCall == "SetCharge" then
            loadedcharge = message.value
            ReplyMessage.functionCall = "Reply"
            ReplyMessage.replyType = "print"
            ReplyMessage.modifyedItem = "Charge"
            ReplyMessage.data = loadedcharge
            print("Set Charge To "..tostring(loadedcharge))
        else
            print("Recived Invaild Function")
        end
    elseif mode == 2  then
        if message.functionCall == "Run" then
            if message.runningFunc == "Exchange" then 
                print("Recived Exchange Command")
                sendstate.computer = os.getComputerID()
                sendstate.status = "sell"
                sendstate.id = message.info.id
                sendstate.charge = loadedcharge
                sendstate.pin = message.info.pin
                ws.send(textutils.serialise(sendstate))
                term.setTextColor(colors.green)
                print("Processing...")
                repeat
                    event, url, message = os.pullEvent("websocket_message")
                    datar = textutils.unserialise(message)
    
                until (datar.handler == os.getComputerID() and url == myURL)
                if datar.status == "ReplyAuth" then
                    if datar.ReplyMessage == "Accepted Payment" then
                        
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = true
                        print("Payment Accepted")
                        modem.transmit(hostport, 0, ReplyMessage)
                    elseif datar.ReplyMessage == "InvalidAmt" then
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = false
                        print("Invalid Amount")
                        modem.transmit(hostport, 0, ReplyMessage)

                    elseif datar.ReplyMessage == "Invalid Pin" then
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = false
                        print("Invalid Pin")
                        modem.transmit(hostport, 0, ReplyMessage)
                    end
                end
            end
        elseif message.functionCall == "SetMode" then
            if message.mode == 1 then
                mode = 1
                print("Mode Changed To Mode 1")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Changed To Mode 1"
                modem.transmit(hostport, 0, ReplyMessage)
            elseif message.mode == 2 then
                mode = 2
                print("Mode Changed To Mode 2")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Changed To Mode 1"
                modem.transmit(hostport, 0, ReplyMessage)
            elseif message.mode == 0 then
                mode = 0
                print("Mode Reset")
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "Mode Reset"
                modem.transmit(hostport, 0, ReplyMessage)
            end
        elseif message.functionCall == "GetModes" then
            ReplyMessage.functionCall = "Reply"
            ReplyMessage.replyType = "print"
            ReplyMessage.data = "1 : Paying To You\n2 : Paying To Player"
            modem.transmit(hostport, 0, ReplyMessage)
        elseif message.functionCall == "SetCharge" then
            loadedcharge = message.value
            ReplyMessage.functionCall = "Reply"
            ReplyMessage.replyType = "print"
            ReplyMessage.modifyedItem = "Charge"
            ReplyMessage.data = loadedcharge
            print("Set Charge To "..tostring(loadedcharge))
        else
            print("Recived Invaild Function")
        end
    elseif mode == 1 then
        if message.functionCall == "Run" then
            if message.runningFunc == "Exchange" then
                print("Recived Exchange Command")
                sendstate.computer = os.getComputerID()
                sendstate.status = "charge"
                sendstate.id = message.info.id
                sendstate.charge = loadedcharge
                sendstate.pin = message.info.pin
                ws.send(textutils.serialise(sendstate))
                term.setTextColor(colors.green)
                print("Processing...")
                repeat
                    event, url, message = os.pullEvent("websocket_message")
                    datar = textutils.unserialise(message)

                until (datar.handler == os.getComputerID() and url == myURL)
                if datar.status == "ReplyAuth" then
                    if datar.ReplyMessage == "Accepted Payment" then
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = true
                        print("Accepted Payment")
                        modem.transmit(hostport, 0, ReplyMessage)
                    elseif datar.ReplyMessage == "Insufficient Funds" then
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = false
                        print("Insufficient Funds")
                        modem.transmit(hostport, 0, ReplyMessage)
                    elseif datar.ReplyMessage == "Invalid Pin" then
                        ReplyMessage.functionCall = "Reply"
                        ReplyMessage.replyType = "Auth"
                        ReplyMessage.data = false
                        print("Invalid Pin")
                        modem.transmit(hostport, 0, ReplyMessage)
                    end
                end
            end
        elseif message.functionCall == "SetMode" then
                if message.mode == 1 then
                    mode = 1
                    print("Mode Changed To Mode 1")
                    ReplyMessage.functionCall = "Reply"
                    ReplyMessage.replyType = "print"
                    ReplyMessage.data = "Mode Changed To Mode 1"
                    modem.transmit(hostport, 0, ReplyMessage)
                elseif message.mode == 2 then
                    mode = 2
                    print("Mode Changed To Mode 2")
                    ReplyMessage.functionCall = "Reply"
                    ReplyMessage.replyType = "print"
                    ReplyMessage.data = "Mode Changed To Mode 1"
                    modem.transmit(hostport, 0, ReplyMessage)
                elseif message.mode == 0 then
                    mode = 0
                    print("Mode Reset")
                    ReplyMessage.functionCall = "Reply"
                    ReplyMessage.replyType = "print"
                    ReplyMessage.data = "Mode Reset"
                    modem.transmit(hostport, 0, ReplyMessage)
                end
            elseif message.functionCall == "GetModes" then
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.data = "1 : Paying To You\n2 : Paying To Player"
                print("Mode Called")
                modem.transmit(hostport, 0, ReplyMessage)
            elseif message.functionCall == "SetCharge" then
                loadedcharge = message.value
                ReplyMessage.functionCall = "Reply"
                ReplyMessage.replyType = "print"
                ReplyMessage.modifyedItem = "Charge"
                ReplyMessage.data = loadedcharge
                print("Set Charge To "..tostring(loadedcharge))
            else
                print("Recived Invaild Function")
            end
        
    end
    end
    end
    
end
if lfiledata.version ~= gfiledata.version then
    term.setTextColor(colors.orange)
    print("Update Found")
    print("Local Version : "..lfiledata.version)
    print("Global Version : "..gfiledata.version)
    print("    Update Change : "..gfiledata.Change)
    term.setTextColor(colors.gray)
    print("Press Enter To Run Update")
    repeat
        local event,key = os.pullEvent("key")
    until event == "key"and key == keys.enter
    
    term.setTextColor(colors.green)
    print("Updating")
    local ptt = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Shop/paymentTerm.lua")
    local url = "local myURL = '"..myURL.."'\n"
    local paymentTerm = fs.open("paymentTerm.lua","w")
    paymentTerm.write(url..ptt.readAll())
    paymentTerm.close()
    local VersionFile = fs.open("Version","w")
    VersionFile.write(textutils.serialise(gfiledata))
    VersionFile.close()
    print("Update Complete")
    sleep(2)
    os.reboot()
else
    startup()
end
