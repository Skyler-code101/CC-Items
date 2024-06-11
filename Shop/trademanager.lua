local display = peripheral.find("monitor")
local printer = peripheral.find("printer")
local sp = peripheral.find("speaker")
local storage = peripheral.find("sophisticatedstorage:barrel")
local tran = {}
display.clear()
display.setTextScale(.5)

local PayTerm = peripheral.find("modem")
local diskdrive = peripheral.find("drive")
local function existsinfile(playername,prime)
    value = prime
    repeat
        value = value+1
    until not fs.exists("Transactions/"..playername.."#"..value..".txt")
    return value
    
end



local playername = ""
local linenu = 2
local linenup = 1
local function list(item,amount)
    if (linenu == 9) then
        display.clear()
        display.setCursorPos(1,1)
        display.write("Customer Name: "..playername)
        linenu = 2
    else
        linenu = linenu+1
    end
    linenup = linenup+1
    display.setCursorPos(1,linenu)
    display.write(amount.." | "..item)
    printer.setCursorPos(1,linenup)
    printer.write(amount.." | "..item)
end
function Entry()
local itemMap = {}
for slot,v in pairs(storage.list()) do
    local item = itemMap[v["name"]] or {count=0,displayName=storage.getItemDetail(slot)["displayName"]}
    item.count = item.count + v["count"]
    itemMap[v.name] = item
end
for id, data in pairs(itemMap) do
    
    print(data["count"].." | "..data["displayName"])
end
print("Is This Correct?")
if (read() == "y") then
    for id, data in pairs(itemMap) do
        list(data["displayName"],data["count"])
    end
    return "done" 
else 
    Entry()
end
end
term.setTextColor(colors.green)
print("Customer Name")
term.setTextColor(colors.lime)
playername = read()
display.setCursorPos(1,1)
printer.newPage()
display.write("Customer Name: "..playername)
printer.setCursorPos(1,1)
printer.write("Customer Name: "..playername)
handel = fs.open("Transactions/"..playername.."#"..tostring(existsinfile(playername,0))..".txt","w")
Entry()
term.setTextColor(colors.blue)
term.setTextColor(colors.green)
print("Amount To Charge")
term.setTextColor(colors.lime)
tran.Charge = read()
display.setCursorPos(1,10)
display.write("Total Charge: "..tran.Charge)
local pin
local messagetosend = {}
if diskdrive and PayTerm then
    if fs.exists("disk/ECard/Data") then
        messagetosend.functionCall = "SetCharge"
        messagetosend.value = tran.Charge
        PayTerm.transmit(93,0,messagetosend)
        local ecard =fs.open("disk/ECard/Data","r")
        local data = textutils.unserialise(ecard.readAll())
        print("Card Found Enter Pin")
        pin = tonumber(read())
        messagetosend = {}
        messagetosend.functionCall = "Run"
        messagetosend.runningFunc = "Exchange"
        messagetosend.info.pin = pin
        messagetosend.info.id = data.fulllink
    end
end
term.setTextColor(colors.green)
print("Complete the Transaction?")
term.setTextColor(colors.lime)
local v = read()
if (v == "y") then
    term.setTextColor(colors.yellow)
    if diskdrive and PayTerm then
    while true do
        PayTerm.transmit(93,0,messagetosend)
        repeat
            local event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
            local msgtocompare = {}
            msgtocompare.functionCall = "Reply"
            msgtocompare.replyType = "Auth"
        until channel == 93 and message.functionCall == msgtocompare.functionCall and message.replyType == msgtocompare.replyType
        if message.data == true then
            print("Transaction Complete")
            handel.write(textutils.serialise(tran))
            display.clear()
            printer.setCursorPos(1,linenup+1)
            printer.write("Total : "..tran.Charge)
            printer.endPage()
            break
        else
            print("Declined")
            display.clear()
            printer.setCursorPos(1,linenup+1)
            printer.write("Card Declined")
            print("Try new Pin?")
            if read() == "y" then
                print("Enter Correct Pin")
                pin = tonumber(read())
                messagetosend.info.pin = pin
            else
                print("Payment Canceled")
                display.clear()
                printer.setCursorPos(1,linenup+1)
                printer.write("Payment Canceled After Card Declined")
                printer.endPage()
            end
        end
    end
    else 
        print("No Payment Term Connected Please Connect a Payment Term")
        print("Recipt Printing")
        print("Recipt Printed")
        handel.write(textutils.serialise(tran))
        display.clear()
        printer.setCursorPos(1,linenup+1)
        printer.write("Total : "..tran.Charge)
        printer.endPage()
end
    
    sleep(.5)
    os.reboot()
elseif (v=="n") then
    term.setTextColor(colors.red)
    print("Canceled")
    display.clear()
    display.write("Order Voided")
    printer.setCursorPos(1,linenup+1)
    printer.write("Order Voided")
    printer.endPage()
    sleep(.5)
    os.reboot()
else
    printer.endPage()
    os.reboot()
end

