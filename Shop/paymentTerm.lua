local monitor = peripheral.find("monitor")
local myURL = "wss://server-link-sgujurney-235d845ea187.herokuapp.com"
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
    print("Welcome To the Payment Panel\n\n 1 : Account Wizard \n 2 : Payment Device")
local promt = read()
if (promt == "1") then
    if (disk.isPresent("right")) then
        print("Welcome To the Account Wizard\n")
        print("Enter Account Holder Name:")
        local datal={}
        datal.status = "create"
        datal.playername = read()
        print("Enter Account Auth Pin:")
        datal.pin = tonumber(monitorPinEnter())
        print(tostring(datal.pin))
        print("Starting Creation...")
        datal.bal = 5
        local Ecardos = fs.open("ECard.lua","r")
        local startupfile = fs.open("disk/startup","w")
        local id = math.random(10000000, 99999999)
        local datam = {}
        local data = {}
        local event,url,message
        datal.computer = os.getComputerID()
        repeat
            print(datal)
            datal.fulllink = id
            datam.fulllink = datal.fulllink
            datam.playername  = datal.playername
            ws.send(textutils.serialise(datal))
            event, url, message = os.pullEvent("websocket_message")
            data = textutils.unserialise(message) or nil
            if data ~= nil then
                if data[status] == "Already made" then 
                    id = math.random(10000000, 99999999)
                end
            end
        until (data ~= nil and data.status == "Created" and data.handler == os.getComputerID() and message ~= "ping")
        local listw = fs.open("disk/ECard/Data","w")
        listw.write(textutils.serialise(datam))
        listw.close()
        startupfile.write(Ecardos.readAll())
        startupfile.close()
        Ecardos.close()
        disk.setLabel("right","ECard")
        print("Finished Creation")      
    else 
        print("Please Enter ECard")
    end
elseif (promt == "2") then
print("Loading ECard")
if (fs.exists("disk/ECard/Data")) then     
    datafile = fs.open("disk/ECard/Data","r")
    data = textutils.unserialise(datafile.readAll())
    print("Loading Bank Acount")
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
    print("Name: "..datar.playername)
    print("Pin:")
    local pin = tonumber(monitorPinEnter())
    print(tostring(pin))
    if pin == datar.pin then
        
        print("Balance: "..datar.bal)
        print("Charge Amount:")
        total = tonumber(read())
        if (datar.bal >= total and total >= 0) then
            datar.bal = datar.bal - total
            datar.status = "change"
            datar.fulllink = sendstate.id
            datar.computer = os.getComputerID()
            ws.send(textutils.serialise(datar))
            print("Aproved Payment")
            DisplayMessage("Aproved Payment",colors.green)
        else
            DisplayMessage("Declined",colors.red)
            print("Declined : Insufficient Funds")
        end

    else
        DisplayMessage("Declined",colors.red)
        print("Declined : Invalid Pin")
    end
    end
    
else
    print("Insert ECard")
end
end
sleep(1)
monitor.clear()
startup()
end
startup()
