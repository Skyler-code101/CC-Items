local monitor = peripheral.find("monitor")
local ws = http.websocket(myURL)
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
    term.setTextColor(colors.red)
    print("Welcome To the Payment Panel\n\n     1 : Account Wizard \n     2 : Payment Device \n     3 : Selling Device")
    term.setTextColor(colors.yellow)
    write("> ")
local promt = read()
if (promt == "1") then
    if (disk.isPresent("right")) then
        term.setTextColor(colors.red)
        print("Welcome To the Account Wizard\n")
        term.setTextColor(colors.yellow)
        write("Account Holder Name> ")
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
        write("Pin > ")
        local pin = tonumber(monitorPinEnter())
        print(tostring(pin))
        write("Sell Amount > ")
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
elseif promt == "Update" then
    print("updating")
    local ptt = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Shop/paymentTerm.lua")
    local url = "local myURL = '"..myURL.."'\n"
    local paymentTerm = fs.open("paymentTerm.lua","w")
    paymentTerm.write(url..ptt.readAll())
    paymentTerm.close()
    print("Update Complete")
    sleep(2)
    os.reboot()
end
sleep(2)
monitor.clear()
startup()
end


parallel.waitForAny(startup)
