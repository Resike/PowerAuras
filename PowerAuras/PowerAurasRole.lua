local _, ns = ...
local PowaAuras = ns.PowaAuras

local pairs, table = pairs, table

-- Reset if spec changed or slash command
function PowaAuras:ResetTalentScan(unit)
	if not unit then
		table.wipe(self.InspectedRoles)
		table.wipe(self.FixRoles)
		return
	end
	local unitName = UnitName(unit)
	if not unitName then
		return
	end
	self.InspectedRoles[unitName] = nil
	self.FixRoles[unitName] = nil
end

function PowaAuras:TrimInspected()
	for unitName, _ in pairs(self.InspectedRoles) do
		if not self.GroupNames[unitName] then
			self.InspectedRoles[unitName] = nil
			self.FixRoles[unitName] = nil
		end
	end
	self.InspectsDone = nil
	self.InspectAgain = GetTime() + self.InspectDelay
end

-- If timeout after talent tree server request
function PowaAuras:SetRoleUndefined(unit)
	local unitName = UnitName(unit)
	if not unitName then
		return
	end
	self.InspectedRoles[unitName] = nil
end

function PowaAuras:ShouldBeInspected(unit)
	if unit == "focus" or not self.GroupUnits[unit] then
		return false
	end
	local class = self.GroupUnits[unit].Class
	if class == "ROGUE" or class == "HUNTER" or class == "MAGE" or class == "WARLOCK" then
		return false
	end
	local name = self.GroupUnits[unit].Name
	if self.InspectedRoles[name] then
		return false
	end
	if not UnitIsConnected(unit) then
		self.InspectSkipped = true
		return false
	end
	if not CheckInteractDistance(unit, 1) then
		self.InspectSkipped = true
		return false
	end
	return true
end

function PowaAuras:TryInspectNext()
	self.InspectSkipped = false
	if not PowaMisc.AllowInspections then
		self.NextInspectUnit = nil
		self.InspectsDone = true
		return
	end
	for unit, unitInfo in pairs(self.GroupUnits) do
		if self:ShouldBeInspected(unit) then
			if UnitIsUnit(unit,"player") then
				self.NextInspectUnit = "player"
				self:InspectRole()
			else
				self.NextInspectTimeOut = GetTime() + self.InspectTimeOut
				self.NextInspectUnit = unit
				NotifyInspect(unit)
			end
			return
		end
	end
	self.NextInspectUnit = nil
	self.InspectsDone = not self.InspectSkipped
end

function PowaAuras:InspectRole()
	if not self.NextInspectUnit then
		return
	end
	local role = self:InspectUnit(self.NextInspectUnit)
	return role
end

function PowaAuras:InspectUnit(unit)
	local isInspect = (unit ~= "player")
	if isInspect then
		ClearInspectPlayer()
	end
	self.NextInspectUnit = nil
	local unitInfo = self.GroupUnits[unit]
	if not unitInfo then
		return
	end
	local activeTree = GetInspectSpecialization(unit)
	local _, _, _, _, roleType = GetSpecializationInfoByID(activeTree)
	local role
	if roleType == "DAMAGER" then
		if unitInfo.Class == "DRUID" and activeTree == 103 then
			role = "RoleMeleDps" -- Feral
		elseif unitInfo.Class == "SHAMAN" and activeTree == 263 then
			role = "RoleMeleDps" -- Enhancement
		elseif unitInfo.Class == "WARRIOR" or unitInfo.Class == "MONK" or unitInfo.Class == "PALADIN" then
			role = "RoleMeleDps"
		else
			role = "RoleRangeDps"
		end
	elseif roleType == "HEALER" then
		role = "RoleHealer"
	elseif roleType == "TANK" then
		role = "RoleTank"
	end
	self.InspectedRoles[unitInfo.Name] = role
	return role
end

function PowaAuras:DetermineRole(unit)
	if not unit then
		return
	end
	local _, class = UnitClass(unit)
	if class == "ROGUE" then
		return "RoleMeleDps", "Preset"
	elseif class == "HUNTER" then
		return "RoleRangeDps", "Preset"
	elseif class == "MAGE" then
		return "RoleRangeDps", "Preset"
	elseif class == "WARLOCK" then
		return "RoleRangeDps", "Preset"
	end
	local unitName = UnitName(unit)
	if self.InspectedRoles[unitName] then
		return self.InspectedRoles[unitName], "Inspected"
	end
	if self.FixRoles[unitName] then
		return self.FixRoles[unitName], "Fixed"
	end
	if class == "DEATHKNIGHT" then
		return "RoleMeleDps", "Guess"
	elseif class == "PRIEST" then
		local _, _, buffExist = UnitBuff(unit, self.Spells.SHADOWFORM)
		if buffExist then
			self.FixRoles[unitName] = "RoleRangeDps"
			return "RoleRangeDps", "Guess"
		end
		return "RoleHealer", "Guess"
	elseif class == "WARRIOR" then
		return "RoleMeleDps", "Guess"
	elseif class == "DRUID" then
		local _, powerType = UnitPowerType(unit)
		if powerType == "MANA" then
			local _, _, buffExist = UnitBuff(unit, self.Spells.MOONKIN_FORM)
			if buffExist then
				self.FixRoles[unitName] = "RoleRangeDps"
				return "RoleRangeDps", "Guess"
			else
				return "RoleHealer", "Guess"
			end
		elseif powerType == "RAGE" then
			self.FixRoles[unitName] = "RoleTank"
			return "RoleTank", "Guess"
		elseif powerType == "ENERGY" then
			self.FixRoles[unitName] = "RoleMeleDps"
			return "RoleMeleDps", "Guess"
		end
	elseif class == "PALADIN" then
		if UnitStat(unit, 4) > UnitStat(unit, 1) then
			return "RoleHealer", "Guess"
		end
		return "RoleMeleDps", "Guess"
	elseif class == "SHAMAN" then
		if UnitStat(unit, 2) > UnitStat(unit, 4) then
			return "RoleMeleDps", "Guess"
		end
		return "RoleHealer", "Guess"
	end
	return nil
end