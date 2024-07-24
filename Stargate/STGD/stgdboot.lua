
local file = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/STGD/file.lua").readAll()
local versionpublic = textutils.unserialise(http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/STGD/version").readAll())

local versionlocal
if fs.exists("version") == true then
    local versiontemp = fs.open("version","r")
    versionlocal = textutils.unserialise(versiontemp.readAll())
    versiontemp.close()
else 
    versionlocal = { version = "0.0.0" }
end
function waitTillUpdate()
    while true do
        local versionpubliccheckfile = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/STGD/version")
        local versionpubliccheck = textutils.unserialise(versionpubliccheckfile.readAll())
        versionpubliccheckfile.close()
        local versionlocalcheckfile = fs.open("version","r")
        local versionlocalcheck = textutils.unserialise(versionlocalcheckfile.readAll())
        versionlocalcheckfile.close()
        if versionpubliccheck.version ~= versionlocalcheck.version and versionpubliccheck.installable == true then
            os.reboot()
        end
        sleep(.1)
    end
end

function runProgram()
    shell.run("Storage/stgd.lua")
end
if versionpublic.version ~= versionlocal.version and versionpublic.installable == true then
    local localfile = fs.open("Storage/stgd.lua","w")
    localfile.write(file)
    localfile.close()
    local localversionwrite = fs.open("version","w")
    localversionwrite.write(textutils.serialize(versionpublic))
    localversionwrite.close()
    print("Updated")
    sleep(.5)
    parallel.waitForAny(waitTillUpdate,runProgram)
else
    print("Up to Date")
    parallel.waitForAny(waitTillUpdate,runProgram)
end

