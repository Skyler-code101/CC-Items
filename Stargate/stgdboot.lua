
local file = http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/file.lua").readAll()
local versionpublic = textutils.unserialise(http.get("https://github.com/Skyler-code101/CC-Items/raw/main/Stargate/version"))

local versionlocal = textutils.unserialise(fs.open("version","r").readAll())


if versionpublic.version ~= versionlocal.version then
    local localfile = fs.open("link.lua","w")
    localfile.write(file)
    localfile.close()
    local localversionwrite = fs.open("version","w")
    localversionwrite.write(textutils.serialize(versionpublic))
    localversionwrite.close()
    print("Updated")
    sleep(.5)
    shell.run("link")
else
    print("Up to Date")
    shell.run("link")
end