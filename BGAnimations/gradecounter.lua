-- pls don't look at this mess
-- big thank you to LegendaryHawk for helping to improve this mess <3

local t = Def.ActorFrame {}

local fontColor = color("#FFFFFF") -- getMainColor("positive")
local fontZoom = 0.45

local xPos = 100
local xGap = 5

local yPos = 37.5
local yGap = 11.5

-- In-memory storage for grade counts
if GRADECOUNTERSTORAGE == nil then
    GRADECOUNTERSTORAGE = {
        AAAA = 0,
        AAA = 0,
        AA = 0,
        A = 0,
        initialized = false,
        lastProfileName = ""
    }
end

-- the visual in the lower right displaying the values
local function CreateGradeDisplay(tier, index)
    return Def.ActorFrame {
        -- tier display
        LoadFont("Common Normal") .. {
            OnCommand = function(self)
                self:xy(SCREEN_CENTER_X + SCREEN_CENTER_X / 2.5 + xPos + xGap, SCREEN_BOTTOM - yPos + yGap * index):halign(0):valign(1):zoom(fontZoom)
                self:settext(getGradeStrings(tier) .. "")
                self:diffuse(getGradeColor(tier))
            end
        },
        -- numbers display
        LoadFont("Common Normal") .. {
            OnCommand = function(self)
                local valueToDisplay = -1
                if index == 0 then valueToDisplay = GRADECOUNTERSTORAGE.AAAA end
                if index == 1 then valueToDisplay = GRADECOUNTERSTORAGE.AAA end
                if index == 2 then valueToDisplay = GRADECOUNTERSTORAGE.AA end
                if index == 3 then valueToDisplay = GRADECOUNTERSTORAGE.A end

                self:xy(SCREEN_CENTER_X + SCREEN_CENTER_X / 2.5 + xPos, SCREEN_BOTTOM - yPos + yGap * index):halign(1):valign(1):zoom(fontZoom)
                self:diffuse(fontColor)
                self:settext(valueToDisplay)
            end
        }
    }
end

-- code for parsing the xml
-- really dirty but haven't had any problems with it
local function Trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function ParseXML(xml)
    local grades = {}
    local pattern = "<Score.-<Grade>(.-)</Grade>.-</Score>"

    for grade in xml:gmatch(pattern) do
        local trimmedGrade = Trim(grade)
        if trimmedGrade ~= "" then
            grades[#grades + 1] = trimmedGrade
        end
    end

    return grades
end

local function CountGrade(tiers, grades)
    local count = 0
    for _, grade in ipairs(grades) do
        for _, tier in ipairs(tiers) do
            if grade == tier then
                count = count + 1
                break
            end
        end
    end
    return count
end

-- increments the grade count
function GRADECOUNTERSTORAGE:increment(grade)
    if grade == "AAAA" then self.AAAA = self.AAAA + 1 end
    if grade == "AAA" then self.AAA = self.AAA + 1 end
    if grade == "AA" then self.AA = self.AA + 1 end
    if grade == "A" then self.A = self.A + 1 end
end

-- parse the xml and initialize the grade counts
-- make sure we re-check, if we switch profiles in game
function GRADECOUNTERSTORAGE:init()
    local profile            = GetPlayerOrMachineProfile(PLAYER_1)
    local currentProfileName = profile:GetDisplayName()

    if not self.initialized or self.lastProfileName ~= currentProfileName then
        local xmlData = File.Read(PROFILEMAN:GetProfileDir(1) .. "Etterna.xml")
        local grades = ParseXML(xmlData)
		
        self.AAAA = CountGrade({"Tier01", "Tier02", "Tier03", "Tier04"}, grades)
        self.AAA = CountGrade({"Tier05", "Tier06", "Tier07"}, grades)
        self.AA = CountGrade({"Tier08", "Tier09", "Tier10"}, grades)
        self.A = CountGrade({"Tier11", "Tier12", "Tier13"}, grades)

        self.lastProfileName = currentProfileName
        self.initialized = true
    end
end

-- initialize the storage
GRADECOUNTERSTORAGE:init()

-- these actors will read the values from GRADECOUNTERSTORAGE
t[#t + 1] = CreateGradeDisplay("Grade_Tier04", 0)
t[#t + 1] = CreateGradeDisplay("Grade_Tier07", 1)
t[#t + 1] = CreateGradeDisplay("Grade_Tier10", 2)
t[#t + 1] = CreateGradeDisplay("Grade_Tier13", 3)

return t
