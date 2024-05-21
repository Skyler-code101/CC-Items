local display = peripheral.find("monitor")
local printer = peripheral.find("printer")
local sp = peripheral.find("speaker")
local storage = peripheral.wrap("left")
local tran = {}
display.clear()
display.setTextScale(.5)
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
term.setTextColor(colors.green)
print("Complete the Transaction?")
term.setTextColor(colors.lime)
local v = read()
if (v == "y") then
    term.setTextColor(colors.yellow)
    print("Transaction Complete")
    handel.write(textutils.serialise(tran))
    display.clear()
    printer.setCursorPos(1,linenup+1)
    printer.write("Total : "..tran.Charge)
    printer.endPage()
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

