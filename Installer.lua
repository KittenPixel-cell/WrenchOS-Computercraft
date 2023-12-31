os.pullEvent = os.pullEventRaw

local w,h = term.getSize()

function printCentered( y,s )
   local x = math.floor((w - string.len(s)) / 2)
   term.setCursorPos(x,y)
   term.clearLine()
   term.write( s )
end

local nOption = 1

local function getFile(name)
    local file, second = http.get(rootPath .. name .. "?" .. os.epoch('utc'))
    local content
    if file then
        content = file.readAll()
    end
    return content, second
end

local function downloadFile(name)
    local content = getFile(name)
    local file = fs.open(name, "w")
    file.write(content)
    file.close()
    return true
end

local function drawMenu()
   term.clear()
   term.setCursorPos(1,1)
   term.write("Wrench OS Install Menu // ")
term.setCursorPos(1,2)

   term.setCursorPos(w-11,1)
   if nOption == 1 then
   term.write("Install")
elseif nOption == 2 then
   term.write("Cancel")
end

end

--GUI
term.clear()
local function drawFrontend()
   printCentered( math.floor(h/2) - 3, "")
   printCentered( math.floor(h/2) - 2, "Install Menu" )
   printCentered( math.floor(h/2) - 1, "")
   printCentered( math.floor(h/2) + 0, ((nOption == 1) and "[ Install  ]") or "Install" )
   printCentered( math.floor(h/2) + 1, ((nOption == 2) and "[ Cancel   ]") or "Cancel" )
   printCentered( math.floor(h/2) + 4, "")
end

--Display
drawMenu()
drawFrontend()

while true do
 local e,p = os.pullEvent()
 if e == "key" then
  local key = p
  if key == 17 or key == 200 then

   if nOption > 1 then
    nOption = nOption - 1
    drawMenu()
    drawFrontend()
   end
  elseif key == 31 or key == 208 then
  if nOption < 4 then
  nOption = nOption + 1
  drawMenu()
  drawFrontend()
end
elseif key == 28 then
    --End should not be here!!
break
end --End should be here!!
end
end
term.clear()

local function getInstallationInformation(tag)
   rootPath = "https://github.com/KittenPixel-cell/WrenchOS-Computercraft/" .. tag or "main"
   print("Fetching installation information...")
   local inst, err = getFile("/inst/installation.lua")
   if not inst then
       printError(("Could not fetch installation information for branch %s."):format(tag))
       return
   else
       instData = textutils.unserialize(inst)
   end
   if not instData then
       error("Error parsing installing information")
   end
   return instData
end

--Conditions
if nOption  == 1 then
print(("Setup will create %d directories and will install %d files."):format(#getInstallationInformation("main").directories, #getInstallationInformation("main").files))
write("Confirm? Y/n ")
local ready = read()
if string.lower(ready) == "n" then
   print("Installation canceled.")
else
   print("Creating directories...")
        for i, v in pairs(getInstallationInformation("main").directories) do
            print(("Creating: %s"):format(v))
            fs.makeDir(v)
        end
   term.clear()

   print("Downloading files...")
   for i, v in pairs(getInstallationInformation("main").files) do
       print(("Downloading: %s"):format(v))
       downloadFile(v)
   end

   print("Installation complete")
   local sha256 = require("/lib/sha256")

   print("Please set a username and password")
   write("Username: ")
   local username = read()
   write("Password: ")
   local password = sha256(read(" "))
   local data = {
       {
           name = username,
           passwordHash = password,
           homeDir = "/home/" .. username
       }
   }

   local file = fs.open("/etc/accounts.cfg", "w")
   file.write(textutils.serialize(data))
   file.close()

   print("Set information")
   write("Restart now? Y/n ")
   local rsn = read()
   if string.lower(rsn) ~= "n" then
       os.reboot()
   end
end

else
term.clear()
print("Install Canceled Rebooting...")
os.reboot()
end
