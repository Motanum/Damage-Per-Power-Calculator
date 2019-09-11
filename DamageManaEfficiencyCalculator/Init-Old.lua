--[[
---------------------------------
-- Namespaces
---------------------------------
local _, core = ...;
core.Init = {};

local Init = core.Init;

]]

---------------------------------
-- Welcoming Message
---------------------------------
print("Thank you " .. UnitName("Player") .. " for installing the Damage Mana Efficiency Calculator by Motanum!")

local FireballID = 143;


---------------------------------
-- Helpful Dev Code
---------------------------------
SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
SlashCmdList.RELOADUI = ReloadUI;

SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
SlashCmdList.FRAMESTK = function()
	LoadAddOn("Blizzard_DebugTools");
	FrameStackTooltip_Toggle();
end

-- allows using left and right buttons to move through the chat 'edit' box
for i = 1, NUM_CHAT_WINDOWS do
	_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
end

--[[

---------------------------------
-- Project Code Below
---------------------------------
local UIConfig = CreateFrame("Frame", "MUI_BuffFrame", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(240, 120);
UIConfig:SetPoint("TOPLEFT"); -- Doesn't need to be ("CENTER", UIParent, "CENTER")

--Child frames and Region
UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
UIConfig.title:SetFontObject("GameFontHighlight");
UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
UIConfig.title:SetText("Damage-Mana Efficiency Calculator");

--Create Text Frame
local MessageFrame = CreateFrame("Frame",nil,UIConfig)
MessageFrame:SetWidth(1) 
MessageFrame:SetHeight(1) 
MessageFrame:SetAlpha(.90);
MessageFrame:SetPoint("CENTER",0,0) -- ("CENTER",650,-100)
MessageFrame.text = MessageFrame:CreateFontString(nil,"ARTWORK") 
MessageFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
MessageFrame.text:SetPoint("CENTER",0,0)
MessageFrame:Show()

local DamageLow = SpellDescription:match("(%d+)");
local DamageHigh = SpellDescription:match(".-%d+.-([%d%.%,]+)");
local PowerCost = cleanPowerCostTable["cost"];
local DamagePerPowerCost = (DamageLow + DamageHigh) / (2 * PowerCost);

local function mainDamagePerPowerCalc(InSpellID)
--Do Damage Per Power Stuff
local PowerCostTable = GetSpellPowerCost(InSpellID);
local cleanPowerCostTable = PowerCostTable[1];

local SpellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(InSpellID)

SpellDescription = GetSpellDescription(InSpellID)
DamageLow = SpellDescription:match("(%d+)");
DamageHigh = SpellDescription:match(".-%d+.-([%d%.%,]+)");
PowerCost = cleanPowerCostTable["cost"];
DamagePerPowerCost = (DamageLow + DamageHigh) / (2 * PowerCost);

return ResultString = (SpellName .. ": " .. DamagePerPowerCost .. " Dmg/Power");
end

--Display Result
MessageFrame.text:SetText(ResultString);
print(ResultString)

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
    local name, id = self:GetSpell()
    if id then
        -- Work with the spell ID you now have access to
		MessageFrame.text:SetText(mainDamagePerPowerCalc());
    end
end)

--[[
local function 

end

local event = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init)
]]
