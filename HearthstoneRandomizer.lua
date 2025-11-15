local ADDON = ...
local frame = CreateFrame("Frame", "HearthstoneRandomizerFrame")

-- Create global table for keybinding access
HearthstoneRandomizer = HearthstoneRandomizer or {}

local DEFAULT_IDS = {
  166747, --Brewfest
  165802, --Noble
  165670, --Peddlefeet
  165669, --Lunar
  166746, --Fire Eater
  163045, --Horseman
  162973, --Greatfather
  142542, --Tome of TP
  64488,  --Innkeeper
  54452,  --Ethereal
  93672,  --Dark Portal
  168907, --Holographic Digitalization
  172179, --Eternal Traveler
  190237, --Broker
  188952, --Dominated
  200630, --Windsage
  206195, --Path of the Naaru
  182773, --Necrolord
  180290, --Night Fae
  184353, --Kyrian
  183716, --Venthyr
  208704, --Deepweller's
  190196, --Enlightened
  209035, --Larodar Flame
  200630, --Windsage
  193588, --Timewalker's
  212337, --Stone of the Hearth - 401802 is the spell ID for the standard hearthstone but its consistently returned for this toy?
  228940, --Notorious Thread's Hearthstone
  236687, --Explosive Hearthstone
  235016, --Redeployment Module
  246565, --Cosmic Hearthstone
  245970  --P.O.S.T. Master's Express Hearthstone
}

local available = {}
local MACRO_NAME = "RandomHearth"

-- Utilities
local function isToyOwnedAndUsable(itemID)
    if PlayerHasToy(itemID) then
        if C_ToyBox and C_ToyBox.IsToyUsable and C_ToyBox.IsToyUsable(itemID) == false then
            return false
        end
        return true
    end
    return false
end

local function isItemOwned(itemID)
    return GetItemCount(itemID, true) > 0
end

local function rebuildAvailable()
    wipe(available)
    for _, id in ipairs(DEFAULT_IDS) do
        if isToyOwnedAndUsable(id) or isItemOwned(id) then
            table.insert(available, id)
        end
    end
end

local function pickRandomID()
    if #available == 0 then return nil end
    return available[math.random(1, #available)]
end

-- Macro creation / updating
local function UpdateRandomMacro(itemID)
    if InCombatLockdown() then
        print("|cFFFF0000[HearthstoneRandomizer]|r Cannot update macro in combat!")
        return
    end

    local macroIndex = GetMacroIndexByName(MACRO_NAME)
    local body = "#showtooltip\n/use item:" .. tostring(itemID) .. "\n/rh rand"

    if macroIndex == 0 then
        CreateMacro(MACRO_NAME, "INV_MISC_QUESTIONMARK", body, true)
        print("|cFF00FF00[HearthstoneRandomizer]|r Created macro:", MACRO_NAME)
    else
        EditMacro(macroIndex, MACRO_NAME, "INV_MISC_QUESTIONMARK", body)
        print("|cFF00FF00[HearthstoneRandomizer]|r Updated macro:", MACRO_NAME)
    end
end

local function randomize()
    if InCombatLockdown() then return end
    local id = pickRandomID()
    if not id then return end
    UpdateRandomMacro(id)
    print("|cFF00FF00[HearthstoneRandomizer]|r Randomized to:", id)
end

-- Slash Commands
SLASH_RANDOMHEARTH1 = "/randomhearth"
SLASH_RANDOMHEARTH2 = "/rh"
SlashCmdList["RANDOMHEARTH"] = function(msg)
    msg = (msg or ""):lower()
    if msg == "list" then
        print("[HearthstoneRandomizer] Available hearthstones:")
        for i, id in ipairs(available) do
            print(i .. ". " .. id)
        end
    elseif msg == "rand" or msg == "randomize" then
        randomize()
    else
        print("|cFF00FF00RandomHearth Commands|r:")
        print("/randomhearth list")
        print("/randomhearth rand")
        print("Drag the macro |cFFFFFF00RandomHearth|r to your action bars to use.")
    end
end

function HearthstoneRandomizer:Randomize()
    randomize()
end

-- Event handling for automatic macro update after cast
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")

frame:SetScript("OnEvent", function(self, event, unit, spell)
    if event == "PLAYER_LOGIN" then
        rebuildAvailable()
        local id = pickRandomID()
        if id then
            UpdateRandomMacro(id)
        end
        print("|cFF00FF00[HearthstoneRandomizer]|r Loaded! Drag macro |cFFFFFF00RandomHearth|r to your bars.")
        return
    end

    -- Only respond to player casts
    if unit ~= "player" then return end
    if spell ~= MACRO_NAME then return end

    -- Delay slightly to avoid conflicts
    C_Timer.After(0.1, function()
        randomize()
    end)
end)
