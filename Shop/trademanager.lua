local display = peripheral.find("monitor")

local sp = peripheral.find("speaker")
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
term.setTextColor(colors.green)
print("Customer Name")
term.setTextColor(colors.lime)
playername = read()
display.setCursorPos(1,1)

display.write("Customer Name: "..playername)
handel = fs.open("Transactions/"..playername.."#"..tostring(existsinfile(playername,0))..".txt","w")
term.setTextColor(colors.green)
print("Enter Recived Items (Not Amount and Split by commas AKA Incoming)")
term.setTextColor(colors.lime)

tran.recivedItems = read()
display.setCursorPos(1,2)
display.write(tran.recivedItems)
term.setTextColor(colors.blue)
print("\n"..tran.recivedItems)
term.setTextColor(colors.green)
print("\n\nAmount Of Recived Items (Split By Commas and in order)")
term.setTextColor(colors.lime)
tran.amountRI = read()
display.setCursorPos(1,3)
display.write(tran.amountRI)
term.setTextColor(colors.blue)
print("\n"..tran.recivedItems.."\n"..tran.amountRI)
term.setTextColor(colors.green)
print("\n\nItems Traded (The Item You Gave To the Customer and Split By Commas AKA Outgoing)")
term.setTextColor(colors.lime)
tran.items = read()
display.setCursorPos(1,4)
display.write(tran.items)
term.setTextColor(colors.blue)
print("\n"..tran.recivedItems.."\n"..tran.amountRI.."\n"..tran.items)
term.setTextColor(colors.green)
print("\n\nAmount Of Traded Items (Split By Commas and in order)")
term.setTextColor(colors.lime)
tran.amountI = read()
display.setCursorPos(1,5)
display.write(tran.amountI)
term.setTextColor(colors.green)
print("Complete the Transaction?")
term.setTextColor(colors.lime)
if (read() == "y") then
    term.setTextColor(colors.yellow)
    print("Transaction Complete")
    sp.playSound("entity.player.levelup",3.0)
    handel.write(textutils.serialise(tran))
    display.clear()
    os.reboot()
elseif (read()=="n") then
    term.setTextColor(colors.red)
    print("Canceled")
    display.clear()
    display.write("Order Voided")
    sleep(.5)
    os.shutdown()
else
    os.reboot()
end

