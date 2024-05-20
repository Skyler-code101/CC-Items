local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local sp = peripheral.find("speaker")

    local handel = fs.open("Transactions.txt","w")
    if (read() == "y") then
        local RecivedItems = ""
        local AmountRI = ""
        local Items = ""
        local AmountI = ""
        local playername = ""
        print("Enter Recived Items (Not Amount and Split by commas)")
        RecivedItems = read()
        print(RecivedItems.."\n\nAmount Of Recived Items (Split By Commas and in order)")
        AmountRI = read()
        print(RecivedItems.."\n"..AmountRI.."\n\nItems Traded (The Item You Gave To the Customer and Split By Commas)")
        Items = read()
        print(RecivedItems.."\n"..AmountRI.."\n"..Items.."\n\nAmount Of Traded Items (Split By Commas and in order)")
        AmountI = read()
        print("Customer Name")
        playername = read()
        print("Complete the Transaction?")
        if (read() == "y") then
            print("Transaction Complete")
            sp.playSound("entity.player.levelup",3.0)
            handel.write("{\n"..playername.." Transaction\n"..RecivedItems.."\n"..AmountRI.."\n"..Items.."\n"..AmountI.."\n}")
        elseif (read()=="n") then
            print("Canceled")
            sleep(.5)
            os.shutdown()
        else
            os.reboot()
        end
    elseif (read() == "n") then
        os.reboot()
    else
        os.reboot()
    end

