
os.pullEvent = os.pullEventRaw

local w,h = term.getSize()

function printCentered( y,s )
   local x = math.floor((w - string.len(s)) / 2)
   term.setCursorPos(x,y)
   term.clearLine()
   term.write( s )
end

local nOption = 1

local function drawMenu()
   term.clear()
   term.setCursorPos(1,1)
   term.write("Wrench OS Boot Menu // ")
term.setCursorPos(1,2)
shell.run("id")

   term.setCursorPos(w-11,1)
   if nOption == 1 then
   term.write("CraftOS")
elseif nOption == 2 then
   term.write("WrenchOS")
end

end

--GUI
term.clear()
local function drawFrontend()
   printCentered( math.floor(h/2) - 3, "")
   printCentered( math.floor(h/2) - 2, "Boot Menu" )
   printCentered( math.floor(h/2) - 1, "")
   printCentered( math.floor(h/2) + 0, ((nOption == 1) and "[ CraftOS ]") or "CraftOS" )
   printCentered( math.floor(h/2) + 1, ((nOption == 2) and "[ WrenchOS]") or "WrenchOS" )
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

break
end
end
end
term.clear()

--Conditions
if nOption  == 1 then
term.clear()
term.setCursorPos(1,1)
print("CraftOS 1.8")
else
shell.run("boot.lua")
end
