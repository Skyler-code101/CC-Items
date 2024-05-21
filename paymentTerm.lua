function startup()
    term.clear()
    print("Welcome To the Payment Panel\n\n 1 : Account Wizard \n 2 : Payment Device")
local promt = read()
if (promt == "1") then
    if (disk.isPresent("right")) then
        print("Welcome To the Account Wizard\n")
        print("Enter Account Holder Name:")
        datal={}
        datals={}
        datal.playername = read()
        datals.playername = datal.playername
        print("Enter Account Auth Pin:")
        datal.pin = tonumber(read())
        print("Starting Creation...")
        datal.bal = 5
        local function existsinfile()
        data = 0
        repeat
            data = math.random(10000000, 99999999)
        until not fs.exists("Accounts/"..data..".txt")
    
        return data
        
    end
    datal.fulllink = existsinfile()
    datals.fulllink = datal.fulllink
    local file = io.open("Accounts/"..datal.fulllink..".txt","w")
    file:write(textutils.serialise(datal))
    file:close()
    local ECard = io.open("disk/ECard/Data", "w")
    ECard:write(textutils.serialise(datals))
    ECard:close()
    disk.setLabel("right","ECard")
    print("Finished Creation")
    else 
        print("Please Enter ECard")
    end
elseif (promt == "2") then
print("Loading ECard")
if (fs.exists("disk/ECard/Data")) then     
    datafile = io.open("disk/ECard/Data","r")
    data = textutils.unserialise(datafile:read("*a"))
    print("Loading Bank Acount")
    listr = io.open("Accounts/"..data.fulllink..".txt","r")
    datal = textutils.unserialise(listr:read("*a"))
    print("Name: "..data.playername)
    print("Pin:")
    if tonumber(read()) == datal.pin then
        listw = io.open("Accounts/"..data.fulllink..".txt","w")
        print("Balance: "..datal.bal)
        print("Charge Amount:")
        total = tonumber(read())
        if (datal.bal >= total) then
            datal.bal = datal.bal - total
            print("Aproved Payment")
            listw:write(textutils.serialise(datal))
        else
            print("Declined")
        end
        
    end
else
    print("Insert ECard")
end
end
sleep(.5)
startup()
end
function Mainmenu()
    while true do
        local event,ke = os.pullEvent("key")
        if ke == keys.leftCtrl then
            os.reboot()
        end
    end
end
function Lock()
    while true do
        local event, side = os.pullEventRaw()
        if (event == "disk") then
            local fh, err = fs.open("/disk/key","r")
            if fh then
                if fh.readAll() == "Muffin1010#\n" then
                    parallel.waitForAll(startup,Mainmenu)
                end
            end
        end

    end
end
Lock()
