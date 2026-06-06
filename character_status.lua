local characterPage = action_wheel:newPage("Character")

--reveal name stuff
models.model.NameplateAnchor:setParentType("BILLBOARD")
local nameText = models.model.NameplateAnchor:newText("Name")
local inOutOfCharacter = "OOC"
local characterName = "???"
local defaultName = "Steve"
local loadedName = ""

function customNameplateSet()
nameText:setText(inOutOfCharacter.." | "..characterName)
:setScale(0.4)
:setOutline(true)
:setAlignment("CENTER")
:setPos(0,5,0)
end

local statusCount = 0

function pings.icChange()
host:sendChatCommand("nickname set [IC] "..player:getName().." | "..loadedName)
inOutOfCharacter = "IC"
customNameplateSet()
end

function pings.oocChange()
host:sendChatCommand("nickname set [OOC] "..player:getName().." | "..loadedName)
inOutOfCharacter = "OOC"
customNameplateSet()
end

function pings.afkChange()
host:sendChatCommand("nickname set [AFK] "..player:getName().." | "..loadedName)
inOutOfCharacter = "AFK"
customNameplateSet()
end

function statusUp()
statusCount  = statusCount + 1
if statusCount > 2 then
statusCount = 0
end
if statusCount == 0 then
pings.oocChange()
end
if statusCount == 1 then
pings.icChange()
end
if statusCount == 2 then
pings.afkChange()
end
end

function statusDown()
statusCount  = statusCount - 1
log(statusCount)
if statusCount == -1 then
statusCount = 3
end
if statusCount == 0 then
pings.oocChange()
statusCount = 3
end
if statusCount == 1 then
pings.icChange()
end
if statusCount == 2 then
pings.afkChange()
end
end

local action = characterPage:newAction()
	:title("Status")
	:item("minecraft:brown_mushroom")
	:hoverColor(1, 0, 1)
	:setOnLeftClick(statusUp)
	:setOnRightClick(statusDown)
	
function pings.mysteryChange()
characterName = "???"
customNameplateSet()
end

function pings.revealChange()
quickLoad()
if loadedName ~= "" then
defaultName = loadedName
end
characterName = defaultName
customNameplateSet()
end


local action = characterPage:newAction()
	:title("Name Revealed?")
	:item("minecraft:red_mushroom")
	:hoverColor(1, 0, 1)
	:setOnToggle(pings.revealChange)
	:setOnUntoggle(pings.mysteryChange)

customNameplateSet()

--Creating Default Set Commands
function events.chat_send_message(message)
	if not message:find("^%$") then
        return true
    end
	
	local args = {}

    for word in message:gmatch("%S+") do
        table.insert(args, word)
    end

    if args[1] == "$nameplate" then
        if args[2] == "set" and args[3] == "default" then

            local text = table.concat(args, " ", 4)

            print("Setting nameplate to: " .. text)
			saveInfo(text)
        end
		
		
        return nil
    end
end

function saveInfo(nameInput)
config:save("name", nameInput)
end

function loadInfo()
return config:load("name")
end

function quickLoad()
local quickLoadCheck = loadInfo()
	if quickLoadCheck ~= nil then
	loadedName = loadInfo()
	end
end

--Automatically creates the action wheel stuff
local lastPage = ""

function events.entity_init()
	quickLoad()
	
	if action_wheel:getCurrentPage() ~= nil then
	lastPage = action_wheel:getCurrentPage()
	local action = lastPage:newAction()
	:title("Character")
	:item("minecraft:iron_sword")
	:hoverColor(1, 0, 1)
	:setOnLeftClick(characterPageChange)
	
	local action = characterPage:newAction()
	:title("Return")
	:item("minecraft:barrier")
	:hoverColor(1, 0, 1)
	:setOnLeftClick(returnToMain)
	else
	action_wheel:setPage(characterPage)
	end
end	

function characterPageChange()
action_wheel:setPage(characterPage)
end

function returnToMain()
action_wheel:setPage(lastPage)
end
