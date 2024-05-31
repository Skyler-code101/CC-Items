local function run()
    while true do
        shell.run("paymentTerm")
        os.reboot()
    end
end
local function awaitUnlock()
    while true do
        local e = os.pullEventRaw("disk")
        if e == "disk" then
            local fh = fs.open("disk/key","r")
            if fh and fh.readAll() == password then
                break
            end
        end
    end
end

parallel.waitForAny(run,awaitUnlock)
