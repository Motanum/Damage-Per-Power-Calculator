local _, core = ...; -- Namespace

--------------------------------------
-- Custom Slash Command
--------------------------------------
core.commands = {
	["config"] = core.Config.Toggle, -- this is a function (no knowledge of Config object)
	
	["help"] = function()
		print(" ");
		core:Print("List of slash commands:")
		core:Print("|cff00cc66/at config|r - shows config menu");
		core:Print("|cff00cc66/at help|r - shows help info");
		print(" ");
	end,
	
	["example"] = {
		["test"] = function(...)
			core:Print("My Value:", tostringall(...));
		end
	}
};

local function HandleSlashCommands(str)	
	if (#str == 0) then	
		-- User just entered "/at" with no additional args.
		core.commands.help();
		return;		
	end	
	
	local args = {};
	for _, arg in ipairs({ string.split(' ', str) }) do
		if (#arg > 0) then
			table.insert(args, arg);
		end
	end
	
	local path = core.commands; -- required for updating found table.
	
	for id, arg in ipairs(args) do
		if (#arg > 0) then -- if string length is greater than 0.
			arg = arg:lower();			
			if (path[arg]) then
				if (type(path[arg]) == "function") then				
					-- all remaining args passed to our function!
					path[arg](select(id + 1, unpack(args))); 
					return;					
				elseif (type(path[arg]) == "table") then				
					path = path[arg]; -- another sub-table found!
				end
			else
				-- does not exist!
				core.commands.help();
				return;
			end
		end
	end
end

function core:Print(...)
    local hex = select(4, self.Config:GetThemeColor());
    local prefix = string.format("|cff%s%s|r", hex:upper(), "Damage Per Power Calc:");	
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", prefix, ...));
end

-- WARNING: self automatically becomes events frame!
function core:init(event, name)
	if (name ~= "DamageManaEfficiencyCalculator") then return end 

	-- allows using left and right buttons to move through chat 'edit' box
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i.."EditBox"]:SetAltArrowKeyMode(false);
	end
	
	----------------------------------
	-- Register Slash Commands!
	----------------------------------
	SLASH_RELOADUI1 = "/rl"; -- new slash command for reloading UI
	SlashCmdList.RELOADUI = ReloadUI;

	SLASH_FRAMESTK1 = "/fs"; -- new slash command for showing framestack tool
	SlashCmdList.FRAMESTK = function()
		LoadAddOn("Blizzard_DebugTools");
		FrameStackTooltip_Toggle();
	end

	SLASH_AuraTracker1 = "/at";
	SlashCmdList.AuraTracker = HandleSlashCommands;
	
    core:Print("Welcome back", UnitName("player").."!");
end



print("Create Local Variables")

local isClear
local SpellDescription
local DamageLow
local DamageHigh
local PowerCost
local DamagePerPowerCost
local DamagePerSecond
local DPSPerPower
local InSpellID
local ResultString = "Empty";
local DPSResult = "Empty"
local DPSPPResult = "Empty";

print("Create function core:mainDamagePerPowerCalc()")

function core:myFunction(InSpellID)
	--print("myFuncion Called. SpellID: " .. InSpellID)
	--Do Damage Per Power Stuff
	local PowerCostTable = GetSpellPowerCost(InSpellID);
	local cleanPowerCostTable = PowerCostTable[1];

	local SpellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(InSpellID)
	
	SpellDescription = GetSpellDescription(InSpellID)
	DamageLow = SpellDescription:match("(%d+)");
	DamageHigh = SpellDescription:match(".-%d+.-([%d%.%,]+)");
	PowerCost = cleanPowerCostTable["cost"];
	
	--change cast time from ms to s
	castTime = castTime / 1000.0 
	
	DamagePerPowerCost = (DamageLow + DamageHigh) / (2 * PowerCost);
	DamagePerSecond = (DamageLow + DamageHigh) / (2 * castTime);
	DPSPerPower = ((DamageLow + DamageHigh) / (2 * castTime) ) / PowerCost;
	
	print(SpellName .. " stats");
	ResultString = (DamagePerPowerCost .. " Dmg/Power");
	DPSResult = (DamagePerSecond .. " DPS");
	DPSPPResult = (DPSPerPower .. " DPS Per Power");
	
	return true;
end

--https://www.wowinterface.com/forums/showthread.php?t=57396
print("Running script from wowinterface.com")

GameTooltip:HookScript("OnTooltipSetSpell", function(self)
	--print("OnTooltipSetSpell called")
	isClear = false;
	local name, NewSpellID = self:GetSpell()
	if ((NewSpellID == InSpellID)) then return else
		-- Work with the spell ID you now have access to
		InSpellID = NewSpellID
		core.myFunction(self, InSpellID)
		print(ResultString)
		print(DPSResult)
		print(DPSPPResult)
	
		--Config.Activate()
	end
end)


GameTooltip:HookScript("OnTooltipCleared", function(self)
	--print("OnTooltipCleared called")
	--Config.Deactivate()

end)



local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);