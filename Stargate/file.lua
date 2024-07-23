


local monitor = peripheral.find("monitor")
local w,h = monitor.getSize()
monitor.clear()
local ci = peripheral.find("advanced_crystal_interface")
local stargateDisallowed = false
local monitortext = {}
if not fs.exists("/DiscordHook.lua") then
    local file = http.get("https://raw.githubusercontent.com/Wendelstein7/DiscordHook-CC/master/DiscordHook.lua")
    local file2 = io.open("/DiscordHook.lua", "w")
    file2:write(file.readAll())
    file2:close()
    file.close()
end

local redstonei = peripheral.find("redstoneIntegrator")
local modems = {peripheral.find("modem")}
local modem

for k,v in pairs(modems) do
    if v.isWireless() == true then
        modem = modems[k]
    end
end
if modem then
    rednet.open(peripheral.getName(modem))
end
local args = {...}

local config = {}

if args[1] == "config" or not fs.exists("/config_stgd.txt") then
    term.setTextColor(colors.green)
    print("Welcome to your STGD (Security Transport Gate Device) Setup Screen")
    term.setTextColor(colors.blue)
    print("Name of this area?")
    term.setTextColor(colors.yellow)
    config.name = read()
    term.setTextColor(colors.blue)
    print("Range? (in blocks)")
    term.setTextColor(colors.yellow)
    config.range = tonumber(read())
    term.setTextColor(colors.blue)
    print("Startup with computer? (y/n)")
    term.setTextColor(colors.lightGray)
    print("Warning Saying y To this Will Lock Your STGD With A Key Provided At Final Setup Input")
    term.setTextColor(colors.yellow)
    config.autostart = read():lower()
    if config.autostart == "y" then
        config.autostart = true
    else
        config.autostart = false
    end
    term.setTextColor(colors.blue)
    print("Owner Name? (ignored by detection, and used for chat)")
    term.setTextColor(colors.yellow)
    config.owner = read()
    term.setTextColor(colors.blue)
    print("Discord Integration? (y/n)")
    term.setTextColor(colors.yellow)
    config.isDiscord = read():lower()
    if config.isDiscord == "y" then
        config.isDiscord = true
        print("Discord Webhook URL")
        config.discordWebhook = read()
    else
        config.isDiscord = false
    end
    term.setTextColor(colors.blue)
    print("Chatbox Integration? (y/n)")
    term.setTextColor(colors.yellow)
    config.isChatbox = read():lower()
    if config.isChatbox == "y" then
        config.isChatbox = true
    else
        config.isChatbox = false
    end
    term.setTextColor(colors.blue)
    print("Address Book Computer ID")
    term.setTextColor(colors.yellow)
    config.address_book_id = tonumber(read())
    
    term.setTextColor(colors.blue)
    print("Startup with computer? (y/n)")
    term.setTextColor(colors.lightGray)
    print("Warning Saying y To this Will Lock Your STGD With A Key Provided At Final Setup Input")
    term.setTextColor(colors.yellow)
    config.autoclosebool = read():lower()
    if config.autoclosebool == "y" then
        config.autoclosebool = true
        term.setTextColor(colors.blue)
        print("Auto Close Time (In Seconds)")
        term.setTextColor(colors.yellow)
        config.autoClose = tonumber(read())
    else
        config.autoclosebool = false
    end
    
    
    term.setTextColor(colors.blue)
    print("Lock stargate When Leaveing? (y/n)")
    term.setTextColor(colors.yellow)
    config.Locked = read():lower()
    if config.Locked == "y" then
        config.Locked = true
    else
        config.Locked = false
    end

    if config.autostart == true then
        print("Unlock Key:")
    local key = read()
    local sufile = fs.open("startup","w")
    sufile.write("local key = '"..key.."'\n"..http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/startup.lua").readAll())
    sufile.close()
    local peripherala = peripheral.find("drive")
    local foundinit = false
    if peripherala.getMountPath() ~= nil then
        print("Found Key Drive")
        foundinit = true
    else
        print("Please Put In A Key Storage Device")
    end
    repeat
        peripherala = peripheral.find("drive")
    until peripherala.getMountPath() ~= nil
    if foundinit == false then
        print("Found Key Drive\nPrinting Key On Drive")
    else
        print("Printing Key On Drive")
    end
    local KeyFile = fs.open(fs.combine(peripherala.getMountPath(),"./STGDKey"),"w")
    KeyFile.write(key)
    KeyFile.close()
    end
    
    local configfile = io.open("/config_stgd.txt","w")
    configfile:write(textutils.serialise(config))
    configfile:close()
    os.reboot()
end

local configfile = io.open("/config_stgd.txt","r")
config = textutils.unserialise(configfile:read("*a"))
configfile:close()

local use_discord
local success, discord_hook

if config.isDiscord then
    local discord = require("DiscordHook")
    success, discord_hook = discord.createWebhook(config.discordWebhook)

    if not success then
        error(discord_hook)
    else
        use_discord = true
    end
end

local use_chatbox
local chatbox

if config.isChatbox then
    chatbox = peripheral.find("chatBox")
    if chatbox then
        use_chatbox = true
    end
end

local function getDate(timeOnly)
    if timeOnly then
        return os.date("%H.%M.%S")
    else
        return os.date("%d/%m %H.%M.%S")
    end
end
local address_cache = {}
local function addressLookupCached(lookup_value)
    if not lookup_value then
        return {name=table.concat(lookup_value, "-")}
    end

    local id_to_send = config.address_book_id
    if type(lookup_value) == "string" then
        if address_cache[lookup_value] then
            return address_cache[lookup_value]
        end
        rednet.send(id_to_send, lookup_value, "jjs_sg_lookup_name")
    elseif type(lookup_value) == "table" then
        if address_cache[(table.concat(lookup_value, "-"))] then
            return address_cache[(table.concat(lookup_value, "-"))]
        end
        rednet.send(id_to_send, lookup_value, "jjs_sg_lookup_address")
    end

    for i1=1, 5 do
        local id, msg, protocol = rednet.receive(nil, 0.075)
        if id == id_to_send then
            if protocol == "jjs_sg_lookup_return" then
                if type(lookup_value) == "string" then
                    address_cache[lookup_value] = msg
                elseif type(lookup_value) == "table" then
                    address_cache[(table.concat(lookup_value, "-"))] = msg
                end
                return msg
            else
                return {name=table.concat(lookup_value, "-")}
            end
        end
    end
    return {name=table.concat(lookup_value, "-")}
end
local chat_queue = {}

local function log(text)
    if use_discord then
        discord_hook.send(text, "STGD - "..(config.name or "Unknown"))
    end
    if use_chatbox then
        chat_queue[#chat_queue+1] = {text=text}
    end
    term.setTextColor(colors.yellow)
    print('['..getDate().."] > "..text)
    term.setTextColor(colors.white)
end
local linenu = 2
local function sendvisual(text)
    local w,h = monitor.getSize()
    if (linenu == h-2) then
        monitor.clear()
        monitor.setCursorPos(1,1)
        monitor.write("STGD Log")
        monitor.setCursorPos(1,2)
        monitor.write(string.rep("=",w))

        linenu = 2
    end
    linenu = linenu + 1
    monitor.setCursorPos(1,linenu)
    monitor.write(text)
end
local function logPlayers(data)
    local discord_text = ""
    for k,v in pairs(data) do
        if v.action == "entry" then
            discord_text = discord_text..":arrow_lower_right: **"..(v.name or "Unknown").."** > "..v.action.."\n"
        elseif v.action == "exit" then
            discord_text = discord_text..":no_entry: **"..(v.name or "Unknown").."** > "..v.action.."\n"
        end
    end

    if use_discord then
        discord_hook.send(discord_text, "STGD: "..(config.name or "Unknown"))
    end

    local chat_text = ""
    local spacing = ""
    if #data > 1 then
        chat_text = chat_text.."\n"
        spacing = "\n  "
    end
    for k,v in pairs(data) do
        if v.action == "entry" then
            chat_text = chat_text..spacing.."\xA7b"..(v.name or "Unknown").." \xA7e> \xA7a"..v.action
        elseif v.action == "exit" then
            chat_text = chat_text..spacing.."\xA7b"..(v.name or "Unknown").." \xA7e> \xA7c"..v.action
        end
    end

    if use_chatbox then
        chat_queue[#chat_queue+1] = {text=chat_text}
    end
    
    for k,v in pairs(data) do
        if v.action == "entry" then
            monitor.setTextColor(colors.lime)
        elseif v.action == "exit" then
            monitor.setTextColor(colors.red)
        end
    
        sendvisual(""..(v.name or "Unknown").." > "..v.action)
        term.setTextColor(colors.white)
    end
end

local function isInsideTable(name, table_to_search)
    for k,v in pairs(table_to_search) do
        if v == name then
            return true
        end
    end
    return false
end

local function tableDifference(table_one, table_two)
    local missing_from_one = {}
    local missing_from_two = {}

    for k,v in pairs(table_one) do
        if not isInsideTable(v, table_two) then
            missing_from_two[#missing_from_two+1] = v
        end
    end

    for k,v in pairs(table_two) do
        if not isInsideTable(v, table_one) then
            missing_from_one[#missing_from_two+1] = v
        end
    end

    return missing_from_one, missing_from_two
end

local function chatManager()
    while true do
        local to_delete = {}
        for k,v in ipairs(chat_queue) do
            local is_sent = chatbox.sendMessageToPlayer(v.text, config.owner, "\xA7bSTGD\xA7f-\xA7d"..(config.name or "Unknown").."\xA7f")
            if is_sent then
                to_delete[#to_delete+1] = k
            end
        end

        for k,v in pairs(to_delete) do
            table.remove(chat_queue, v)
            table.remove(to_delete, k)
        end
        sleep(0.5)
    end
end

local radar = peripheral.find("playerDetector")

local function playerRadar()
    local old_list = {}
    local new_list = {}
    while true do
        old_list = new_list
        new_list = radar.getPlayersInRange(config.range or 100)

        local player_exits, player_entries = tableDifference(new_list, old_list)

        local security_data = {}
        for k,v in ipairs(player_exits) do
            if v ~= config.owner then
                security_data[#security_data+1] = {name=v, action="exit"}
            end
        end
        for k,v in ipairs(player_entries) do
            if v ~= config.owner then
                security_data[#security_data+1] = {name=v, action="entry"}
            end
        end

        if #security_data > 0 then
            logPlayers(security_data)
        end

        sleep(0.5)
    end
end
local function readaddress(address)
    local finished = ""
    for _,v in ipairs(address) do
        finished = finished..v.." "
    end
    return finished
end
local opentime
opentime = 0
local Connectedaddress = "Not Connected"
local connectedaddressname = "Not Connected"
local direction = "Not Connected"
local isIncoming = false
local Chevesengaged = 0
local owneroffline = false
local ownerinRange = false
local function stargatedetect()
    while true do

        local event = {os.pullEvent()}
        if (event[1] == "stargate_incoming_wormhole") then
            if (redstonei ~= nil) then
                redstonei.setOutput("north",false)
            end
            local addresst = addressLookupCached(event[2])
            
            log("Incoming Wormhole From "..addresst.name)
            if (stargateDisallowed or owneroffline ) then
                monitor.setTextColor(colors.lightBlue)
                sendvisual("Denied Incoming Wormhole From")
                monitor.setTextColor(colors.yellow)
                sendvisual(addresst.name)
                repeat
                    sleep()
                until ci.isStargateConnected() and ci.isWormholeOpen()
                ci.disconnectStargate()
            else 
                
                monitor.setTextColor(colors.blue)
                sendvisual("Incoming Wormhole From")
                monitor.setTextColor(colors.yellow)
                sendvisual(addresst.name)
                Connectedaddress = readaddress(event[2])
                connectedaddressname = addresst.name
                direction = 'Incoming'
                if config.autoclosebool == true then
                    local init = config.autoClose
                opentime = init
                repeat
                    sleep()
                until ci.isStargateConnected() and ci.isWormholeOpen()
                repeat
                    opentime = init
                    init = init -1
                    sleep(1)
                until init == 0 or ci.isWormholeOpen()== false
                if ci.isWormholeOpen() == true then
                    ci.disconnectStargate()
                    opentime = 0
                else
                    opentime = 0
                end
                end
                
            end
            
        elseif (event[1] == "stargate_outgoing_wormhole") then
            monitor.setTextColor(colors.blue)
            local addresst = addressLookupCached(event[2])
            monitor.setTextColor(colors.cyan)
            sendvisual("Outgoing Wormhole To ")
            monitor.setTextColor(colors.yellow)
            sendvisual(addresst.name)
            Connectedaddress = readaddress(event[2])
            connectedaddressname = addresst.name
            direction = 'Outgoing'
            if config.autoclosebool == true then
                local init = config.autoClose
            opentime = init
                repeat
                    sleep()
                until ci.isStargateConnected() and ci.isWormholeOpen()
                repeat
                    init = init -1
                    sleep(1)
                    opentime = init
                until init == 0 or ci.isWormholeOpen()== false
                if ci.isWormholeOpen() == true then
                    ci.disconnectStargate()
                    opentime = 0
                else
                    opentime = 0
                end
            end
            
        elseif (event[1] == "stargate_chevron_engaged") then
            if redstonei ~= nil and event[4] == true then
                redstonei.setOutput("north",true)
            end
            isIncoming = event[4]
            opentime = 0
        elseif (event[1] == "stargate_reset" and redstonei ~= nil) then
            redstonei.setOutput("north",false)
            opentime = 0
        elseif (event[1] == "stargate_deconstructing_entity" and event[5] == true) then
            ci.disconnectStargate()
        elseif (event[1] == "stargate_disconnected") then
            Connectedaddress = "Not Connected"
            connectedaddressname = "Not Connected"
            direction = 'Not Connected'
            opentime = 0
        end
    end 
end

local function printoutterm()
	while true do
    term.clear()
    if (ownerinRange == false) then
        term.setTextColor(colors.orange)
        print("Termanal Locked")
    end
    term.setTextColor(colors.green)
    print("Welcome To the STGD (Security Transport Gate Device) \n I Am Your Security Termanal \n \n")
    term.setTextColor(colors.lightBlue)
    
    if Chevesengaged >= 1 then
        if opentime ~= 0 then
            print("Current Address : "..Connectedaddress.."\nCurrent Address Name : "..connectedaddressname.."\nDirection : "..direction.." ("..tostring(opentime)..")".."\n")
        else
            print("Wormhole "..direction.."\nEngaged Chevrons : "..tostring(Chevesengaged).."\n\n")
            opentime = 0
        end 
    else
        print("\n\n\n")
        opentime = 0
    end
    term.setTextColor(colors.blue)
    print("Stargate Lock : "..tostring(stargateDisallowed).."\n")
    term.setTextColor(colors.red)
    print("Discoonnect Stargate \n")
    print("Clear Log ")
    sleep(.1)
    end
    
end
local function keybinds()
    while true do
    	local event = {os.pullEvent()}
        ownerinRange = radar.isPlayerInRange(config.range or 100, config.owner)
        if (ownerinRange) then

            if (event[1] == "mouse_click" and event[4] == 14) then
                if (stargateDisallowed) then
                    stargateDisallowed = false
                else
                    stargateDisallowed = true
                end
            elseif (event[1] == "mouse_click" and event[4] == 16) then
                ci.disconnectStargate()
                opentime = 0
            elseif (event[1] == "mouse_click" and event[4] == 18) then
                monitor.clear()
                monitor.setCursorPos(1,1)
                monitor.setTextColor(colors.green)
                monitor.write("STGD Log")
                monitor.setCursorPos(1,2)
                monitor.setTextColor(colors.lightGray)
                linenu = 2
            end
        end
    end
end
function varUpdate()
    while true do
        Chevesengaged = ci.getChevronsEngaged()
        if isIncoming == true then
            direction = 'Incoming'
        else
            direction = 'Outgoing'
        end
        owneroffline = radar.getPlayerPos(config.owner)['x'] == nil and config.Locked
        sleep(.1)
    end
end
Name = config.name
if config.Locked == nil then
    config.Locked = true
end
if config.autoClose ~= nil then
    config.autoclosebool =true
else
    config.autoclosebool = false
end
function loopmonitor()
    while true do
        monitor.setCursorPos(1,h-2)
        monitor.write(string.rep(" ",w))
        monitor.setCursorPos(1,h-1)
        monitor.write(string.rep(" ",w))
        monitor.setCursorPos(1,h)
        monitor.write(string.rep(" ",w))
        monitor.setCursorPos(1,1)
        monitor.write(string.rep(" ",w))
        monitor.setCursorPos(1,2)
        monitor.write(string.rep(" ",w))
        monitor.setCursorPos(1,1)
        monitor.setTextColor(colors.green)
        monitor.write("STGD Log"..string.rep(" ",w-string.len(Name))..Name)
        monitor.setCursorPos(1,2)
        monitor.setTextColor(colors.lightGray)
        monitor.write(string.rep("=",w))
        if Chevesengaged >= 1 then
            if opentime ~= 0 then
                monitor.setCursorPos(1,h-1)
                monitor.setTextColor(colors.blue)
                monitor.write("Wormhole "..direction.." ("..tostring(opentime)..")")
                monitor.setCursorPos(1,h)
                monitor.setTextColor(colors.blue)
                monitor.write(""..connectedaddressname)
            else
                monitor.setCursorPos(1,h-1)
                monitor.setTextColor(colors.red)
                monitor.write("Wormhole "..direction)
                monitor.setCursorPos(1,h)
                monitor.setTextColor(colors.red)
                monitor.write("Chevrons: "..tostring(Chevesengaged))
            end
        else
            if stargateDisallowed == true then
                monitor.setCursorPos(1,h-1)
                monitor.setTextColor(colors.yellow)
                monitor.write("Denying Incoming Wormholes")
                
            end
        end
        monitor.setCursorPos(1,h-2)
        monitor.setTextColor(colors.lightGray)
        monitor.write(string.rep("=",w))
        sleep(.1)
    end
end
parallel.waitForAll(playerRadar, chatManager,stargatedetect, keybinds, printoutterm,varUpdate,loopmonitor)

-- Helped By JajaSteele
