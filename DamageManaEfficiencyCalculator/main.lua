--message('Thank you for trying the Damage Mana Efficiency Calculator by Motaunm!')

SLASH_RELOADUI1 = "/rl" -- For quicker reloading
SlashCmdList.RELOADUI = ReloadUI

--[[
SLASH_FRAMESTK1 = "/fs" -- For quicker acces to frame stack
SlashCmdList.FRAMESTK = function()
	LoadAddOn('Blizzard_DebugTools')
	FrameStackToolTip_Toggle()
end

-- to be able to use the left and right arrows in the edit box
-- without rotating your character!
for i = 1, NUM_CHAT_WINDOWS do
	_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false)
end
------------------------------------------------------------------------------------
]]

--print("Thank you " .. UnitName("Player") .. " for installing the Damage Mana Efficiency Calculator by Motanum!")

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

---------------------------------
-- Project Code Below
---------------------------------
local UIConfig = CreateFrame("Frame", "MUI_BuffFrame", UIParent, "BasicFrameTemplateWithInset");
UIConfig:SetSize(260, 360);
UIConfig:SetPoint("CENTER"); -- Doesn't need to be ("CENTER", UIParent, "CENTER")