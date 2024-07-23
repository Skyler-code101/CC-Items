local commandToRun = settings.get("startup.command_to_run")

if not commandToRun then

    settings.define("startup.command_to_run", {

        description = "Specifies the command to run on startup",

        default = "sgtdboot",

        type = "string"

    })

    settings.set("shell.allow_disk_startup", false)

    settings.set("motd.enable", false)

    settings.save()

    commandToRun = "sgtdboot"

end







local function doRun()

    while true do

        shell.run(commandToRun)

        print("RESTARTING")

        os.startTimer(5)

        local event, side = os.pullEventRaw()

        term.clear()

    end

end

local function doOverride()

    while true do

        local event, side = os.pullEventRaw()

        if event == "disk" then

            local peripheral = peripheral.wrap(side)

            local fh, err = fs.open(fs.combine(peripheral.getMountPath(),"./STGDKey"),"r")

            if fh then

                if fh.readLine() == key then

                    break

                end

            end

        end

    end

end

parallel.waitForAny(doOverride,doRun)

term.clear()

term.setCursorPos(1,1)

term.setBackgroundColor(colors.green)

print("Authentication Key Detected")

term.setBackgroundColor(colors.black)

