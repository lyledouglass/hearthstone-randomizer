-- To use random hearthstone toys gathered through world events.

local AllHearthToyIndex = {} --All the toys
local UsableHearthToyIndex = {} --Usable toys
local RHTIndex = false --Macro index
RHT = {} --Setup for button and timeout frame
local RHTInitialized = false

--Frame to catch events
local frame = CreateFrame("Frame")

-- Setting up a frame to wait and see if the toybox is loaded before getting stones on login.
local timeOut = 10 --Delay for checking stones.
RHT.to = CreateFrame("Frame","RHTO", UIParent)
RHT.to:SetScript("OnUpdate", function (self, elapse)
  if timeOut > 0 then
    timeOut = timeOut - elapse
  else
    if C_ToyBox.GetNumToys() > 0 then
      GetLearnedStones()
      if RHTInitialized then
        SetRandomHearthToy()
        -- Debug output
        if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","RHT Initialized") end
        RHT.to:SetScript("OnUpdate", nil)
      else
        timeOut = 1
      end
    else
      timeOut = 1
    end
  end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Spellcast stopping is the check for if a hearthstone has been used.
frame:RegisterEvent("UNIT_SPELLCAST_STOP")

local function Event(self, event, arg1, arg2, arg3)
  if event == "PLAYER_ENTERING_WORLD" then
    GetMacro()
    frame:UnregisterEvent("PLAYER_ENTERING_WORLD")
  end
  -- When a spell cast stops and it's the player's spell, send the ID to check if it's a stone.
  if event == "UNIT_SPELLCAST_STOP" and arg1 == "player" then
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Spellcast stopped") end
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Spell ID of current spell: " ..arg3) end
    SpellcastUpdate(arg3)
  end
end

frame:SetScript("OnEvent", Event)

-- Generate list of stones in game.
-- [Item ID] = Spell ID
AllHearthToyIndex[166747] = 286353 --Brewfest
AllHearthToyIndex[165802] = 286031 --Noble
AllHearthToyIndex[165670] = 285424 --Peddlefeet
AllHearthToyIndex[165669] = 285362 --Lunar
AllHearthToyIndex[166746] = 286331 --Fire Eater
AllHearthToyIndex[163045] = 278559 --Horseman
AllHearthToyIndex[162973] = 278244 --Greatfather
AllHearthToyIndex[142542] = 231504 --Tome of TP
AllHearthToyIndex[64488]  = 94719  --Innkeeper
AllHearthToyIndex[54452]  = 75136  --Ethereal
AllHearthToyIndex[93672]  = 136508 --Dark Portal
AllHearthToyIndex[168907] = 298068 --Holographic Digitalization
AllHearthToyIndex[172179] = 308742 --Eternal Traveler
AllHearthToyIndex[190237] = 367013 --Broker
AllHearthToyIndex[188952] = 363799 --Dominated
AllHearthToyIndex[200630] = 391042 --Windsage
AllHearthToyIndex[206195] = 412555 --Path of the Naaru
AllHearthToyIndex[182773] = 340200 --Necrolord
AllHearthToyIndex[180290] = 326064 --Night Fae
AllHearthToyIndex[184353] = 345393 --Kyrian
AllHearthToyIndex[183716] = 342122 --Venthyr
AllHearthToyIndex[208704] = 420418 --Deepweller's
AllHearthToyIndex[190196] = 366945 --Enlightened
AllHearthToyIndex[209035] = 422284 --Larodar Flame
AllHearthToyIndex[200630] = 391042 --Windsage
AllHearthToyIndex[193588] = 375357 --Timewalker's
AllHearthToyIndex[212337] = 401802 --Stone of the Hearth - 401802 is the spell ID for the standard hearthstone but its consistently returned for this toy?
AllHearthToyIndex[228940] = 463481 --Notorious Thread's Hearthstone
AllHearthToyIndex[236687] = 1220729 --Explosive Hearthstone
AllHearthToyIndex[235016] = 1217281 --Redeployment Module

-- This is the meat right here.
function SetRandomHearthToy()
  -- Find the macro.
  GetMacro()
  if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Macro got - setting random hearthstone") end
  -- Rebuild the stone list if it's empty.
  if next(UsableHearthToyIndex) == nil then
    GetLearnedStones()
  end
  local itemID, toyName = '',''
  -- Randomly pick one.
  local k = RandomKey(UsableHearthToyIndex)
  if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Random Hearthstone itemId: " ..k) end
  local itemID, toyName = C_ToyBox.GetToyInfo(k)
  if toyName then
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Random Hearthstone toy: " ..toyName) end
    -- Remove it from the list so we don't pick it again.
    RemoveStone(k)
    -- Write the macro.
    GenMacro(itemID, toyName)
  else
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Random Hearthstone toy did not get set") end
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Faulting stones itemID: " ..itemID) end
  end
end

-- Get stones learned and usable by character
function GetLearnedStones()
  -- Get the current setting for the toybox so we can set it back after we're done.
  ToyCollSetting = C_ToyBox.GetCollectedShown()
  ToyUnCollSetting = C_ToyBox.GetUncollectedShown()
  ToyUsableSetting = C_ToyBox.GetUnusableShown()

  C_ToyBox.SetCollectedShown(true) -- List collected toys
  C_ToyBox.SetUncollectedShown(false) -- Don't list uncollected toys
  C_ToyBox.SetUnusableShown(false) -- Don't list unusable toys in the the collection.

  -- Go through all the toys to find the usable stons.
  for i = 1, C_ToyBox.GetNumFilteredToys() do
    -- Go through all the stone to see if this toy is a stone.
    for k in pairs(AllHearthToyIndex) do
      if k == C_ToyBox.GetToyFromIndex(i) then
        UsableHearthToyIndex [k] = 1
        if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Usable Hearthstone found: " ..k) end
      end
    end
  end
   -- Reset the toybox filter
  C_ToyBox.SetCollectedShown(ToyCollSetting)
  C_ToyBox.SetUncollectedShown(ToyUnCollSetting)
  C_ToyBox.SetUnusableShown(ToyUsableSetting)
  if next(UsableHearthToyIndex) then
    RHTInitialized = true
  end
end

-- We use RHT as the macro name, so we need to see if it exists. If it
-- does, we set the index. Else, it the nothing gets passed to GenMacro
-- and it creates a new one.
function GetMacro()
  macroExists = GetMacroIndexByName("RHT")
  if macroExists == 0 then
    RHTIndex = false
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","macroExists is 0, index is null") end
  else
    RHTIndex = macroExists
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Macro is not 0, index is: " .. RHTIndex) end
  end
end

-- Macro writing time.
function GenMacro(itemID, toyName)
  if RHTIndex ~= false then
    EditMacro(RHTIndex, "RHT", "INV_MISC_QUESTIONMARK", "#showtooltip item:" .. itemID .. "\r/cast " .. toyName)
    -- Debug output
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Macro updated") end
  else
    CreateMacro("RHT", "INV_MISC_QUESTIONMARK", "#showtooltip item:" .. itemID .. "\r/cast " .. toyName)
    -- Debug output
    if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Macro created") end
    GetMacro()
  end
end

-- Remove stone from the list so we don't use it again. (Here for debugging)
function RemoveStone(k)
  UsableHearthToyIndex[k] = nil
end

-- Did a stone get used?
function SpellcastUpdate(spellID)
if not InCombatLockdown() then
  for k in pairs(AllHearthToyIndex) do
    if spellID == AllHearthToyIndex[k] then
      if DLAPI then DLAPI.DebugLog("HearthstoneRandomizer","Stone used: " ..k) end
      SetRandomHearthToy()
      break
    end
  end
end
end

-- Code to randomly pick a key from a table.
function RandomKey(t)
    local keys = {}
    for key, value in pairs(t) do
        keys[#keys+1] = key --Store keys in another table.
    end
    index = keys[math.random(1, #keys)]
    return index
end
