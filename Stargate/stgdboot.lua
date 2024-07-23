
local file = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/file.lua").readAll()
local versionpublic = textutils.unserialise(http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/version").readAll())

local versionlocal
if fs.exists("version") == true then
    versionlocal = textutils.unserialise(fs.open("version","r").readAll())
else 
    versionlocal = { version = "0.0.0" }
end
function waitTillUpdate()
    while true do
        local versionpubliccheck = textutils.unserialise(http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/version").readAll())
        local versionlocalcheck = textutils.unserialise(fs.open("version","r").readAll())
        if versionpubliccheck.version ~= versionlocalcheck.version and versionpubliccheck.installable == true then
            os.reboot()
        end
        sleep(.1)
    end
end

function runProgram()
    shell.run("link")
end
if versionpublic.version ~= versionlocal.version and versionpublic.installable == true then
    local localfile = fs.open("link.lua","w")
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

