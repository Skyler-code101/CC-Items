local file = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/stgd.lua")

local filefunc = file.readAll()

file.close()

if not fs.exists("/DiscordHook.lua") then
    local file = http.get("https://raw.githubusercontent.com/Wendelstein7/DiscordHook-CC/master/DiscordHook.lua")
    local file2 = io.open("/DiscordHook.lua", "w")
    file2:write(file.readAll())
    file2:close()
    file.close()
end
local discord = require("DiscordHook")

local stat, err = pcall(load(filefunc))

if not stat then print(err) end