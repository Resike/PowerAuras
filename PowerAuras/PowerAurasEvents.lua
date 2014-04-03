local _, ns = ...
local PowaAuras = ns.PowaAuras

local bit = bit
local pairs = pairs
local string = string
local tonumber = tonumber
local wipe = wipe

local C_PetBattles = C_PetBattles
local GetActiveSpecGroup = GetActiveSpecGroup
local GetInstanceInfo = GetInstanceInfo
local GetNumGroupMembers = GetNumGroupMembers
local GetNumShapeshiftForms = GetNumShapeshiftForms
local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetShapeshiftFormInfo = GetShapeshiftFormInfo
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local IsAddOnLoaded = IsAddOnLoaded
local IsInGroup = IsInGroup
local IsInInstance = IsInInstance
local IsInRaid = IsInRaid
local IsMounted = IsMounted
local LoadAddOn = LoadAddOn
local UnitCanAttack = UnitCanAttack
local UnitClass = UnitClass
local UnitGUID = UnitGUID
local UnitInParty = UnitInParty
local UnitInRaid = UnitInRaid
local UnitInVehicle = UnitInVehicle
local UnitIsDead = UnitIsDead
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitIsPVP = UnitIsPVP
local UnitIsUnit = UnitIsUnit
local UnitName = UnitName

local PowaAuras_Frame = CreateFrame("Frame", nil, UIParent)
PowaAuras_Frame:RegisterEvent("ADDON_LOADED")

PowaAuras_Frame:SetScript("OnEvent", function(self, event, ...)
	PowaAuras[event](PowaAuras, ...)
end)

PowaAuras_Frame:SetScript("OnUpdate", function(self, elapsed, ...)
	PowaAuras:OnUpdate(elapsed)
end)

function PowaAuras:ReregisterEvents()
	PowaAuras_Frame:UnregisterAllEvents()
	self:RegisterEvents(PowaAuras_Frame)
end

function PowaAuras:RegisterEvents(frame)
	if self.playerclass == "DRUID" then
		self.Events.UPDATE_SHAPESHIFT_FORM = true
	end
	for event in pairs(self.Events) do
		if self[event] then
			frame:RegisterEvent(event)
		end
	end
end

function PowaAuras:Toggle(enable)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if enable == nil then
		enable = PowaMisc.Disabled
	end
	if enable then
		if not PowaMisc.Disabled then
			return
		end
		if PowaAuras_Frame and not PowaAuras_Frame:IsShown() then
			PowaAuras_Frame:Show()
			self:RegisterEvents(PowaAuras_Frame)
		end
		PowaMisc.Disabled = false
		self:Setup()
		self:DisplayText("Power Auras: "..self.Colors.Green..PowaAuras.Text.Enabled.."|r")
	else
		if PowaMisc.Disabled then
			return
		end
		if PowaAuras_Frame and PowaAuras_Frame:IsShown() then
			PowaAuras_Frame:UnregisterAllEvents()
			PowaAuras_Frame:Hide()
		end
		self:OptionHideAll(true)
		PowaMisc.Disabled = true
		self:DisplayText("Power Auras: "..self.Colors.Red..PowaAuras.Text.Disabled.."|r")
	end
	PowaEnableButton:SetChecked(PowaMisc.Disabled ~= true)
end

function PowaAuras:ADDON_LOADED(addon)
	if addon == "PowerAuras" then
		PowaAuras_Frame:UnregisterEvent("ADDON_LOADED")
		LoadAddOn("PowerAurasOptions")
		-- Ensure PowaMisc gets any new values
		for k, v in pairs(PowaAuras.PowaMiscDefault) do
			if PowaMisc[k] == nil then
				PowaMisc[k] = v
			end
		end
		-- Remove redundant settings
		for k in pairs(PowaMisc) do
			if PowaAuras.PowaMiscDefault[k] == nil then
				PowaMisc[k] = nil
			end
		end
		for k, v in pairs(PowaAuras.PowaGlobalMiscDefault) do
			if PowaGlobalMisc[k] == nil then
				PowaGlobalMisc[k] = v
			end
		end
		-- Remove redundant settings
		for k in pairs(PowaGlobalMisc) do
			if PowaAuras.PowaGlobalMiscDefault[k] == nil then
				PowaGlobalMisc[k] = nil
			end
		end
		self.MaxTextures = PowaAuras.TextureCount
		local _, _, major, minor, build = string.find(self.Version, self.VersionPattern)
		self.VersionParts = {Major = tonumber(major), Minor = tonumber(minor), Build = tonumber(build)}
		_, _, major, minor, build = string.find(PowaMisc.Version, self.VersionPattern)
		self.PreviousVersionParts = {Major = tonumber(major), Minor = tonumber(minor), Build = tonumber(build)}
		self.VersionUpgraded = self:VersionGreater(self.VersionParts, self.PreviousVersionParts)
		if self.VersionUpgraded then
			self:DisplayText(self.Colors.Purple.."<Power Auras Classic>|r "..self.Colors.Gold..self.Version.."|r - "..self.Text.welcome)
			PowaMisc.Version = self.Version
		end
		_, self.playerclass = UnitClass("player")
		self:LoadAuras()
		if IsAddOnLoaded("PowerAurasOptions") then
			self:OptionsOnLoad()
		else
			self:OptionsDisabled()
		end
		self:FindAllChildren()
		self:CreateEffectLists()
		if not PowaMisc.Disabled then
			self:RegisterEvents(PowaAuras_Frame)
		end
		self.VariablesLoaded = true
		self:Setup()
	end
end

function PowaAuras:OptionsDisabled()
	SlashCmdList["POWA"] = function(msg)
		self:DisplayText("Power Auras Options: "..self.Colors.Red..PowaAuras.Text.Disabled.."|r")
	end
	SLASH_POWA1 = "/pa"
	SLASH_POWA2 = "/powa"
end

function PowaAuras:Setup()
	local spellId = self.GCDSpells[PowaAuras.playerclass]
	if not spellId then
		return false
	end
	self.GCDSpellName = GetSpellInfo(spellId)
	-- Lookup spells by spellId for debuff types
	self.DebuffCatSpells = { }
	for k, v in pairs(self.DebuffTypeSpellIds) do
		local spellName = GetSpellInfo(k)
		if spellName then
			self.DebuffCatSpells[spellName] = v
		end
	end
	if UnitIsDeadOrGhost("player") then
		self.WeAreAlive = false
	end
	self.PvPFlagSet = UnitIsPVP("player")
	self:DetermineRole("player")
	self.WeAreInRaid = IsInRaid()
	self.WeAreInParty = IsInGroup()
	self.WeAreMounted = IsMounted() == 1 and true or self:IsDruidTravelForm()
	self.WeAreInVehicle = UnitInVehicle("player") ~= nil
	self.WeAreInPetBattle = C_PetBattles.IsInBattle()
	self.ActiveTalentGroup = GetActiveSpecGroup()
	self.Instance = self:GetInstanceType()
	self:GetStances()
	self:InitialiseAllAuras()
	self:MemorizeActions()
	self.DoCheck.All = true
	self.SetupDone = true
end

function PowaAuras:GetInstanceType()
	local _, instanceType = IsInInstance()
	if instanceType == "pvp" then
		instanceType = "Bg"
	elseif instanceType == "arena" then
		instanceType = "Arena"
	elseif instanceType == "party" or instanceType == "raid" then
		local _, _, instanceDifficulty = GetInstanceInfo()
		-- 5 Man Normal
		if instanceDifficulty == 1 then
			instanceType = "5Man"
		-- 5 Man Heroic
		elseif instanceDifficulty == 2 then
			instanceType = "5ManHeroic"
		-- Challange Mode
		elseif instanceDifficulty == 8 then
			instanceType = "ChallangeMode"
		-- 10 Man / 11 Man
		elseif instanceDifficulty == 3 then
			instanceType = "10Man"
		-- 10 Man Heroic
		elseif instanceDifficulty == 5 then
			instanceType = "10ManHeroic"
		-- 25 Man or 25 Man LFG or 40 Man
		elseif instanceDifficulty == 4 or instanceDifficulty == 7 or instanceDifficulty == 9 then
			instanceType = "25Man"
		-- 25 Man Heroic
		elseif instanceDifficulty == 6 then
			instanceType = "25ManHeroic"
		-- Flexible
		elseif instanceDifficulty == 14 then
			instanceType = "Flexible"
		end
	elseif instanceType == "scenario" then
		local _, _, instanceDifficulty = GetInstanceInfo()
		-- Scenario
		if instanceDifficulty == 12 then
			instanceType = "Scenario"
		-- Scenario Heroic
		elseif instanceDifficulty == 11 then
			instanceType = "ScenarioHeroic"
		end
	else
		instanceType = "None"
	end
	return instanceType
end

function PowaAuras:ACTIVE_TALENT_GROUP_CHANGED(...)
	self.ActiveTalentGroup = GetActiveSpecGroup()
	if self.ModTest then
		return
	end
	self.PendingRescan = GetTime()
end

function PowaAuras:PLAYER_TALENT_UPDATE(...)
	if self.ModTest then
		return
	end
	self.PendingRescan = GetTime()
end

function PowaAuras:PLAYER_UPDATE_RESTING(...)
	if self.ModTest then
		return
	end
	self.DoCheck.All = true
end

function PowaAuras:GROUP_ROSTER_UPDATE(...)
	if not self.ModTest then
		self.DoCheck.RaidBuffs = true
		self.DoCheck.GroupOrSelfBuffs = true
		self.DoCheck.RaidHealth = true
		self.DoCheck.RaidMana = true
		self.DoCheck.UnitMatch = true
		self.DoCheck.CheckIt = true
	end
	local raidCount = GetNumGroupMembers()
	if not IsInRaid() then
		raidCount = 0
	end
	self.WeAreInRaid = IsInRaid()
	self:FillGroup("raid", raidCount)
	if not self.ModTest then
		self.DoCheck.PartyBuffs = true
		self.DoCheck.GroupOrSelfBuffs = true
		self.DoCheck.PartyHealth = true
		self.DoCheck.PartyMana = true
		self.DoCheck.UnitMatch = true
		self.DoCheck.CheckIt = true
	end
	local partyCount = GetNumSubgroupMembers()
	self.WeAreInParty = (partyCount > 0)
	if GetNumGroupMembers() > 0 then
		return
	end
	self:FillGroup("party", partyCount)
end

function PowaAuras:FillGroup(group, count)
	wipe(self.GroupUnits)
	wipe(self.GroupNames)
	for i = 1, count do
		local unit = group..i
		local role, roleType = self:DetermineRole(unit)
		if group == "raid" and UnitIsUnit(unit, "player") then
			unit = "player"
		end
		local _, classname = UnitClass(unit)
		self.GroupUnits[unit] = {Name = UnitName(unit), Class = classname}
		self.GroupNames[self.GroupUnits[unit].Name] = true
	end
	PowaAuras:TrimInspected()
end

function PowaAuras:INSPECT_TALENT_READY()
	self:InspectRole()
end

function PowaAuras:UNIT_HEALTH(...)
	local unit = ...
	self:SetCheckResource("Health", unit)
end

function PowaAuras:UNIT_MAXHEALTH(...)
	local unit = ...
	self:SetCheckResource("Health", unit)
end

function PowaAuras:UNIT_POWER(...)
	local unit, resourceType = ...
	self:CheckPower(unit, resourceType)
end

function PowaAuras:UNIT_MAXPOWER(...)
	local unit, resourceType = ...
	self:CheckPower(unit, resourceType)
end

function PowaAuras:UNIT_POWER_FREQUENT(...)
	local unit, resourceType = ...
	self:CheckPower(unit, resourceType)
end

function PowaAuras:CheckPower(unit, resourceType)
	if resourceType == "MANA" then
		self:SetCheckResource("Mana", unit)
	else
		self:SetCheckResource("Power", unit)
	end
end

function PowaAuras:SetCheckResource(resourceType, unitType)
	if self.ModTest then
		return
	end
	if unitType == "target" then
		self.DoCheck["Target"..resourceType] = true
	elseif unitType == "focus" then
		self.DoCheck["Focus"..resourceType] = true
	elseif "party" == string.sub(unitType, 1, 5) then
		self.DoCheck["Party"..resourceType] = true
		self.DoCheck["NamedUnit"..resourceType] = true
	elseif "raid" == string.sub(unitType, 1, 4) then
		self.DoCheck["Raid"..resourceType] = true
		self.DoCheck["NamedUnit"..resourceType] = true
	elseif unitType == "pet" then
		self.DoCheck["NamedUnit"..resourceType] = true
	elseif unitType == "player" then
		self.DoCheck[resourceType] = true
	end
	self.DoCheck.CheckIt = true
end

function PowaAuras:SpellcastEvent(unit)
	if self.ModTest then
		return
	end
	-- Spell alert handling
	if self.DebugEvents then
		self:DisplayText("SpellcastEvent: ", unit)
	end
	if unit and not UnitIsDead(unit) then
		if UnitIsUnit(unit, "player") then
			self.DoCheck.PlayerSpells = true
			self.DoCheck.GroupOrSelfSpells = true
		end
		if UnitIsUnit(unit, "focus") then
			self.DoCheck.FocusSpells = true
		end
		if UnitIsUnit(unit, "target") then
			self.DoCheck.TargetSpells = true
		end
		if UnitCanAttack(unit, "player") then
			self.DoCheck.Spells = true -- Scan party/raid targets for casting
		else
			if UnitInParty(unit) then
				self.DoCheck.PartySpells = true
				self.DoCheck.GroupOrSelfSpells = true
			end
			if UnitInRaid(UnitInRaid(unit)) then
				self.DoCheck.RaidSpells = true
				self.DoCheck.GroupOrSelfSpells = true
			end
		end
		self.DoCheck.CheckIt = true
	end
end

function PowaAuras:UNIT_SPELLCAST_SUCCEEDED(...)
	if self.ModTest then
		return
	end
	local unit, spell = ...
	self.ExtraUnitEvent[unit] = spell
	self:SpellcastEvent(unit)
	if self.TalentChangeSpells[spell] then
		self:ResetTalentScan(unit)
		self.DoCheck.All = true
	end
	if self.DebugEvents then
		self:DisplayText("UNIT_SPELLCAST_SUCCEEDED ",unit, " ", spell)
	end
	-- Druid shapeshift special case
	if unit == "player" then
		if spell == self.Spells.DRUID_SHIFT_CAT or spell == self.Spells.DRUID_SHIFT_BEAR or spell == self.Spells.DRUID_SHIFT_DIREBEAR or spell == self.Spells.DRUID_SHIFT_MOONKIN then
			self.DoCheck.Mana = true
			self.DoCheck.Power = true
			self.DoCheck.CheckIt = true
		end
		for _, auraId in pairs(self.AurasByType.SpellCooldowns) do
			self.DoCheck.SpellCooldowns = true
			self.DoCheck.CheckIt = true
			self.Pending[auraId] = GetTime() + 0.5 -- Allow 0.5 sec for client to update or time may be wrong
		end
	end
end

function PowaAuras:UNIT_SPELLCAST_START(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_CHANNEL_START(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_DELAYED(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_CHANNEL_UPDATE(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_STOP(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_FAILED(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_INTERRUPTED(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:UNIT_SPELLCAST_CHANNEL_STOP(...)
	local unit = ...
	PowaAuras:SpellcastEvent(unit)
end

function PowaAuras:RUNE_POWER_UPDATE(...)
	if self.ModTest then
		return
	end
	self.DoCheck.Runes = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:RUNE_TYPE_UPDATE(...)
	if self.ModTest then
		return
	end
	local slot = ...
	if self.DebugEvents then
		self:DisplayText("RUNE_TYPE_UPDATE slot = ", slot, " class = ", self.playerclass)
	end
	self.DoCheck.Runes = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:PLAYER_FOCUS_CHANGED(...)
	if self.ModTest then
		return
	end
	self.DoCheck.FocusBuffs = true
	self.DoCheck.FocusHealth = true
	self.DoCheck.FocusMana = true
	self.DoCheck.FocusPower = true
	self.DoCheck.FocusSpells = true
	self.DoCheck.StealableFocusSpells = true
	self.DoCheck.PurgeableFocusSpells = true
	self.DoCheck.UnitMatch = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:BuffsChanged(unit)
	if self.ModTest then
		return
	end
	self.ChangedUnits.Buffs[unit] = true
	self.DoCheck.UnitBuffs = true
	if unit == "target" then
		self.DoCheck.TargetBuffs = true
		self.DoCheck.StealableTargetSpells = true
		self.DoCheck.PurgeableTargetSpells = true
	elseif unit == "focus" then
		self.DoCheck.FocusBuffs = true
		self.DoCheck.StealableFocusSpells = true
		self.DoCheck.PurgeableFocusSpells = true
	elseif string.sub(unit, 1, 5) == "party" then
		self.DoCheck.PartyBuffs = true
		self.DoCheck.GroupOrSelfBuffs = true
	elseif string.sub(unit, 1, 4) == "raid" then
		self.DoCheck.RaidBuffs = true
		self.DoCheck.GroupOrSelfBuffs = true
	elseif unit == "player" then
		self.DoCheck.Buffs = true
		self.DoCheck.GroupOrSelfBuffs = true
	end
	if UnitCanAttack(unit, "player") then
		self.DoCheck.StealableSpells = true
		self.DoCheck.PurgeableSpells = true
	end
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_AURA(...)
	local unit = ...
	self:BuffsChanged(unit)
end

function PowaAuras:UNIT_AURASTATE(...)
	local unit = ...
	self:BuffsChanged(unit)
end

function PowaAuras:PLAYER_DEAD(...)
	if not self.ModTest then
		self.DoCheck.All = true
	end
	self.WeAreMounted = false
	self.WeAreInVehicle = false
	self.WeAreAlive = false
end

function PowaAuras:PLAYER_ALIVE(...)
	if not UnitIsDeadOrGhost("player") then
		self.WeAreAlive = true
		if not self.ModTest then
			self.DoCheck.All = true
		end
	end
end

function PowaAuras:PLAYER_UNGHOST(...)
	if not UnitIsDeadOrGhost("player") then
		self.WeAreAlive = true
		if not self.ModTest then
			self.DoCheck.All = true
		end
	end
end

function PowaAuras:PLAYER_TARGET_CHANGED(...)
	if self.ModTest then
		return
	end
	self.DoCheck.TargetBuffs = true
	self.DoCheck.TargetHealth = true
	self.DoCheck.TargetMana = true
	self.DoCheck.TargetPower = true
	self.ResetTargetTimers = true
	self.DoCheck.Actions = true
	self.DoCheck.StealableTargetSpells = true
	self.DoCheck.PurgeableTargetSpells = true
	self.DoCheck.Combo = true
	self.DoCheck.UnitMatch = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_TARGET(...)
	local unit = ...
	local target = unit.."target"
	if self.DebugEvents then
		self:DisplayText("UNIT_TARGET ", unit)
	end
	if not self.ModTest then
		self.DoCheck.UnitMatch = true
		for existingTarget in pairs(PowaAuras.ChangedUnits.Targets) do
			if UnitIsUnit(target, existingTarget) then
				return
			end
		end
		self.ChangedUnits.Targets[target] = unit
		if UnitCanAttack(target, "player") then
			self.DoCheck.StealableSpells = true
			self.DoCheck.PurgeableSpells = true
		end
		self.DoCheck.CheckIt = true
	end
end

function PowaAuras:PLAYER_REGEN_DISABLED(...)
	self.WeAreInCombat = true
	if self.ModTest then
		return
	end
	self.DoCheck.All = true
end

function PowaAuras:PLAYER_REGEN_ENABLED(...)
	self.WeAreInCombat = false
	if self.ModTest then
		return
	end
	self.DoCheck.All = true
end

function PowaAuras:ZONE_CHANGED_NEW_AREA()
	local instanceType = self:GetInstanceType()
	if self.Instance == instanceType then
		return
	end
	self.Instance = instanceType
	if self.ModTest then
		return
	end
	if self.DebugEvents then
		self:DisplayText("ZONE_CHANGED_NEW_AREA ", self.InInstance, " - ", self.InstanceType)
	end
	self.DoCheck.All = true
end

function PowaAuras:PLAYER_DIFFICULTY_CHANGED()
	local instanceType = self:GetInstanceType()
	if self.Instance == instanceType then
		return
	end
	self.Instance = instanceType
	if self.ModTest then
		return
	end
	if self.DebugEvents then
		self:DisplayText("PLAYER_DIFFICULTY_CHANGED ", self.InInstance, " - ", self.InstanceType)
	end
	self.DoCheck.All = true
end

function PowaAuras:UNIT_COMBO_POINTS(...)
	if self.ModTest then
		return
	end
	local unit = ...
	if unit ~= "player" then
		return
	end
	self.DoCheck.Combo = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_PET(...)
	if self.ModTest then
		return
	end
	local unit = ...
	if unit ~= "player" then
		return
	end
	self.DoCheck.Pet = true
	self.DoCheck.UnitMatch = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:PLAYER_TOTEM_UPDATE(...)
	if self.ModTest then
		return
	end
	local slot = ...
	if self.DebugEvents then
		self:DisplayText("PLAYER_TOTEM_UPDATE slot = ", slot, " class = ", self.playerclass)
	end
	if self.playerclass == "SHAMAN" or self.playerclass == "DRUID" then
		self.DoCheck.All = true
	elseif self.playerclass == "DEATHKNIGHT" and not self.MasterOfGhouls then
		if self.DebugEvents then
			self:DisplayText("Ghoul (temp version)")
		end
		self.DoCheck.Pet = true
	end
end

function PowaAuras:VehicleCheck(unit, entered)
	if unit ~= "player" then
		return
	end
	if not self.ModTest then
		self.DoCheck.All = true
	end
	self.WeAreInVehicle = entered
end

function PowaAuras:UNIT_ENTERED_VEHICLE(...)
	local unit = ...
	self:VehicleCheck(unit, true)
end

function PowaAuras:UNIT_EXITED_VEHICLE(...)
	local unit = ...
	self:VehicleCheck(unit, false)
end

function PowaAuras:PLAYER_FLAGS_CHANGED(...)
	local unit = ...
	if self.DebugEvents then
		self:DisplayText("PLAYER_FLAGS_CHANGED unit = ",unit)
	end
	self:FlagsChanged(unit)
end

function PowaAuras:UNIT_FACTION(...)
	local unit = ...
	if self.DebugEvents then
		self:DisplayText("UNIT_FACTION unit = ",unit)
	end
	self:FlagsChanged(unit)
end

function PowaAuras:FlagsChanged(unit)
	if unit == "player" then
		local flag = UnitIsPVP("player")
		if flag ~= self.PvPFlagSet then
			self.PvPFlagSet = flag
			if not self.ModTest then
				self.DoCheck.All = true
			end
		end
		return
	end
	if not self.ModTest then
		if unit == "target" then
			self.DoCheck.TargetPvP = true
		end
		for i = 1, GetNumSubgroupMembers() do
			if unit == "party"..i then
				self.DoCheck.PartyPvP = true
				break
			end
		end
		for i = 1, GetNumGroupMembers() do
			if unit == "raid"..i then
				self.DoCheck.RaidPvP = true
				break
			end
		end
		self.DoCheck.CheckIt = true
	end
end

function PowaAuras.StringStarts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function PowaAuras.StringEnds(String, End)
	return End == '' or string.sub(String, - string.len(End)) == End
end

function PowaAuras:COMBAT_LOG_EVENT_UNFILTERED(...)
	if self.ModTest then
		return
	end
	-- Args
	local _
	local timestamp, event, casterHidden, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, spellType
	if self.WoWBuild >= 40200 then
		timestamp, event, casterHidden, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, spellId, spellName, _, spellType = ...
	elseif self.WoWBuild >= 40100 then
		timestamp, event, casterHidden, sourceGUID, sourceName, sourceFlags2, destGUID, destName, destFlags, spellId, spellName, _, spellType = ...
	else
		timestamp, event, sourceGUID, sourceName, sourceFlags2, destGUID, destName, destFlags, spellId, spellName, _, spellType = ...
	end
	if not spellName then
		return
	end
	if sourceGUID == UnitGUID("player") and event == "SPELL_CAST_SUCCESS" then
		self.CastByMe[spellName] = {SpellName = spellName, SpellId = spellId, DestGUID = destGUID, DestName = destName, Hostile = bit.band(destFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)}
		self.DoCheck.PlayerSpells = true
		self.DoCheck.GroupOrSelfSpells = true
	end
	if destGUID == UnitGUID("player") then
		if PowaAuras.StringStarts(event,"SPELL_") and sourceName then
			self.CastOnMe[sourceName] = {SpellName = spellName, SpellId = spellId, SourceGUID = sourceGUID, Hostile = bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE)}
			self.DoCheck.Spells = true -- Scan party/raid targets for casting
			self.DoCheck.CheckIt = true
			return
		end
		if event == "ENVIRONMENTAL_DAMAGE" then
			if spellId ~= "FALLING" then
				self.AoeAuraAdded[0] = spellId
				self.DoCheck.Aoe = true
				self.DoCheck.CheckIt = true
			end
			return
		end
		if event == "SPELL_PERIODIC_DAMAGE" or event == "SPELL_DAMAGE" or ((event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") and spellType == "DEBUFF") then
			self.AoeAuraAdded[spellId] = spellName
			if not self.AoeAuraTexture[spellName] then
				local _, _, icon = GetSpellInfo(spellId)
				self.AoeAuraTexture[spellId] = icon
			end
			self.DoCheck.Aoe = true
			self.DoCheck.CheckIt = true
			return
		end
	end
end

function PowaAuras:ACTIONBAR_SLOT_CHANGED(...)
	local actionIndex = ...
	self:MemorizeActions(actionIndex)
	self.DoCheck.Actions = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:ACTIONBAR_SHOWGRID(...)
	local actionIndex = ...
	self:MemorizeActions(actionIndex)
	self.DoCheck.Actions = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:ACTIONBAR_HIDEGRID(...)
	local actionIndex = ...
	self:MemorizeActions(actionIndex)
	self.DoCheck.Actions = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UPDATE_SHAPESHIFT_FORMS(...)
	self:GetStances()
	if self.ModTest then
		return
	end
	self.DoCheck.Stance = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:GetStances()
	if self.playerclass == "WARLOCK" then -- Fix for Warlock metamorphosis
		local _, name = GetShapeshiftFormInfo(1)
		self.PowaStance[2] = name
		return
	end
	if self.playerclass == "ROGUE" then -- Fix for shadow dance (which is apparently at index 3)
		local _, name = GetShapeshiftFormInfo(1)
		self.PowaStance[1] = name
		name = GetShapeshiftFormInfo(3)
		self.PowaStance[3] = name
		return
	end
	for i = 1, GetNumShapeshiftForms() do
		local _, name = GetShapeshiftFormInfo(i)
		self.PowaStance[i] = name
	end
end

function PowaAuras:ACTIONBAR_UPDATE_COOLDOWN(...)
	if self.ModTest then
		return
	end
	self.DoCheck.Actions = true
	self.DoCheck.Stance = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:ACTIONBAR_UPDATE_USABLE(...)
	if self.ModTest then
		return
	end
	self.DoCheck.Actions = true
	self.DoCheck.Stance = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:SPELL_UPDATE_COOLDOWN(...)
	if self.ModTest then
		return
	end
	self.DoCheck.SpellCooldowns = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:SPELL_UPDATE_CHARGES(...)
	if self.ModTest then
		return
	end
	self.DoCheck.Actions = true
	self.DoCheck.SpellCooldowns = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UPDATE_SHAPESHIFT_FORM(...)
	if self.ModTest then
		return
	end
	self.DoCheck.Stance = true
	self.DoCheck.Actions = true
	self.DoCheck.Combo = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_INVENTORY_CHANGED(...)
	if self.ModTest then
		return
	end
	local unit = ...
	if unit == "player" then
		if self.DebugEvents then
			self:DisplayText("UNIT_INVENTORY_CHANGED ", unit)
		end
		self.DoCheck.Items = true
		self.DoCheck.Slots = true
		for _, auraId in pairs(self.AurasByType.Enchants) do
			if self.DebugEvents then
				self:DisplayText("Pending set for Enchants ", auraId)
			end
			self.Pending[auraId] = GetTime() + 0.25 -- Allow time for client to update or timer will be wrong
		end
		self.DoCheck.CheckIt = true
	end
end

function PowaAuras:BAG_UPDATE_COOLDOWN()
	if self.ModTest then
		return
	end
	self.DoCheck.Items = true
	self.DoCheck.Slots = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:BAG_UPDATE()
	if self.ModTest then
		return
	end
	self.DoCheck.Items = true
	self.DoCheck.Slots = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:MINIMAP_UPDATE_TRACKING()
	if self.ModTest then
		return
	end
	self.DoCheck.Tracking = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_THREAT_SITUATION_UPDATE(...)
	if self.ModTest then
		return
	end
	local unit = ...
	if self.DebugEvents then
		self:DisplayText("UNIT_THREAT_SITUATION_UPDATE ", unit)
	end
	if unit == "player" then
		self.DoCheck.Aggro = true
		self.DoCheck.CheckIt = true
		return
	end
	if UnitInParty(unit) then
		self.DoCheck.PartyAggro = true
		self.DoCheck.CheckIt = true
	end
	if UnitInRaid(unit) then
		self.DoCheck.RaidAggro = true
		self.DoCheck.CheckIt = true
	end
end

-- Enables the boss1-boss4 units.
function PowaAuras:INSTANCE_ENCOUNTER_ENGAGE_UNIT()
	if self.ModTest then
		return
	end
	self.DoCheck.UnitMatch = true
	self.DoCheck.CheckIt = true
end

function PowaAuras:UNIT_NAME_UPDATE()
	if self.ModTest then
		return
	end
	self.DoCheck.UnitMatch = true
	self.DoCheck.CheckIt = true
end

-- Fires when the pet action bar is updated, we use this to see what stance is selected.
function PowaAuras:PET_BAR_UPDATE()
	if self.ModTest then
		return
	end
	self.DoCheck.PetStance = true
	self.DoCheck.CheckIt = true
end