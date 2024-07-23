while true do
    local event, username, device = os.pullEvent("playerClick")
    if username == "SkylerGaming" then
        redstone.setOutput("right", not redstone.getOutput("right"))
    end
end