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

local isValidSpell
local isClear
local SpellDescription
local DamageLow
local DamageHigh
local PowerCost
local DamagePerPowerCost
local DamagePerSecond
local DPSPerPower
--local InSpellID
local TitleString = "Empty";
local ResultString = "Empty";
local DPSResult = "Empty"
local DPSPPResult = "Empty";

--crate a static pop up frame
StaticPopupDialogs["EXAMPLE_HELLOWORLD"] = {
  --text = "%s \n %s \n %s \n %s \n",
  text = "%s",
  button1 = "Neat!",
  button2 = "OK",
  --OnAccept = function()
  --    GreetTheWorld()
  --end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  --sound = "LOOTWINDOWOPENEMPTY",
}

--Override StaticPopup_OnShow()
function StaticPopup_OnShow(self)
	--PlaySound(SOUNDKIT.IG_MAINMENU_OPEN);
	PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP);

	local dialog = StaticPopupDialogs[self.which];
	local OnShow = dialog.OnShow;

	if ( OnShow ) then
		OnShow(self, self.data);
	end
	if ( dialog.hasMoneyInputFrame ) then
		_G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
	end
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", StaticPopup_OnKeyDown);
	end
end

--Override StaticPopup_OnHide()
function StaticPopup_OnHide(self)
	--PlaySound(SOUNDKIT.IG_MAINMENU_CLOSE);

	StaticPopup_CollapseTable();

	local dialog = StaticPopupDialogs[self.which];
	local OnHide = dialog.OnHide;
	if ( OnHide ) then
		OnHide(self, self.data);
	end
	self.extraFrame:Hide();
	if ( dialog.enterClicksFirstButton ) then
		self:SetScript("OnKeyDown", nil);
	end
	if ( self.insertedFrame ) then
		self.insertedFrame:Hide();
		self.insertedFrame:SetParent(nil);
		local text = _G[self:GetName().."Text"];
		_G[self:GetName().."MoneyFrame"]:SetPoint("TOP", text, "BOTTOM", 0, -5);
		_G[self:GetName().."MoneyInputFrame"]:SetPoint("TOP", text, "BOTTOM", 0, -5);
	end
end

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
	
	
	--check validity of gets
	if (DamageLow == nil) then
		--print("Damage Low is Nil") 
		isValidSpell = false;
		return 
	end
	if (DamageHigh == nil) then
		--print("Damage Low is Nil") 
		isValidSpell = false;
		return 
	end
	--Check for strings
	if (tonumber(DamageLow) == nil) then
		--print("Damage Low is Nil") 
		isValidSpell = false;
		return 
	end
	if (tonumber(DamageHigh) == nil) then
		--print("Damage Low is Nil") 
		isValidSpell = false;
		return 
	end
	
	--change cast time from ms to s
	castTime = castTime / 1000.0 
	
	DamagePerPowerCost = (DamageLow + DamageHigh) / (2 * PowerCost);
	DamagePerSecond = (DamageLow + DamageHigh) / (2 * castTime);
	DPSPerPower = ((DamageLow + DamageHigh) / (2 * castTime) ) / PowerCost;
	
	TitleString = (SpellName .. " stats");
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
	isValidSpell = true;
	
	local name, NewSpellID = self:GetSpell()
	core.myFunction(self, NewSpellID)
	
	if (isValidSpell == false) then return end --Quit execute if not valid spell
	
	local finalResultString = (TitleString .. "\n" .. ResultString .. "\n" .. DPSResult .. "\n" .. DPSPPResult)
	
	--StaticPopup_Show ("EXAMPLE_HELLOWORLD", TitleString, ResultString, DPSResult, DPSPPResult)
	StaticPopup_Show ("EXAMPLE_HELLOWORLD", finalResultString)
	--StaticPopupDialogs
		
	--Config.Activate()
end)


GameTooltip:HookScript("OnTooltipCleared", function(self)
	--print("OnTooltipCleared called")
	--Config.Deactivate()
	StaticPopup_Hide ("EXAMPLE_HELLOWORLD")
end)



local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.init);