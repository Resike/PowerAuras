-- Reset if spec changed or slash command
function PowaAuras:ResetTalentScan(unit)
	if (unit == nil) then
		table.wipe(self.InspectedRoles);
		table.wipe(self.FixRoles);
		return;
	end
	local unitName = UnitName(unit);
	if (unitName == nil) then return; end
	--self:Message("Resetting inspect for ",unitName);
	self.InspectedRoles[unitName] = nil;
	self.FixRoles[unitName] = nil;
end

function PowaAuras:TrimInspected()
	for unitName, _ in pairs(self.InspectedRoles) do
		if (self.GroupNames[unitName] == nil) then
			self.InspectedRoles[unitName] = nil;
			self.FixRoles[unitName] = nil;
		end
	end
	self.InspectsDone = nil;
	self.InspectAgain = GetTime() + self.InspectDelay;
end

-- If timeout after talent tree server request
function PowaAuras:SetRoleUndefined(unit)
	local unitName = UnitName(unit);
	if (unitName == nil) then return; end
	self.InspectedRoles[unitName] = nil;
end

function PowaAuras:ShouldBeInspected(unit)
	if ("focus" == unit or self.GroupUnits[unit]==nil) then
		return false;
	end
	local class = self.GroupUnits[unit].Class;
	if (class=="ROGUE") or (class=="HUNTER") or (class=="MAGE") or (class=="WARLOCK") or (class=="DEATHKNIGHT") then
		return false;
	end
	local name = self.GroupUnits[unit].Name;
	--self:Message("ShouldBeInspected? ",unit, " - ", name);
	if (self.InspectedRoles[name] ~= nil) then
		return false;
	end
	if (not UnitIsConnected(unit)) then
		self.InspectSkipped = true;
		return false;
	end
	if (not CheckInteractDistance(unit, 1)) then
		self.InspectSkipped = true;
		return false;
	end
	return true;
end

function PowaAuras:TryInspectNext()
	self.InspectSkipped = false;
	if (not PowaMisc.AllowInspections) then
		self.NextInspectUnit = nil;
		self.InspectsDone = true;
		return;
	end
	for unit, unitInfo in pairs(self.GroupUnits) do
		if (self:ShouldBeInspected(unit)) then
			if (UnitIsUnit(unit,"player")) then
				self.NextInspectUnit = "player";
				self:InspectRole();
			else
				self.NextInspectTimeOut = GetTime() + self.InspectTimeOut;
				self.NextInspectUnit = unit;
				NotifyInspect(unit);
				--self:Message("Inspect requested for ",unitInfo.Name);
			end
			return;
		end
	end
	self.NextInspectUnit = nil;
	self.InspectsDone = not self.InspectSkipped;
end

function PowaAuras:InspectRole()
	if (self.NextInspectUnit == nil) then
		return;
	end
	local role = self:InspectUnit(self.NextInspectUnit);
	--self:Message("Role=",self.Text.Role[role]);
	return role;
end

function PowaAuras:InspectUnit(unit)
	local isInspect = (unit ~= "player");
	if (isInspect) then
		ClearInspectPlayer();
	end
	self.NextInspectUnit = nil;
	local unitInfo = self.GroupUnits[unit];
	if (unitInfo == nil) then
		--self:Message(" Not Found!");
		return;
	end
	--self:Message("InspectRole: ",unitInfo.Name, " (", unit,")");
	local activeTree = GetInspectSpecialization(unit);
	local null, null, null, null, roleType = GetSpecializationInfoByID(activeTree);
	local role;
	if (roleType=="DAMAGER") then
		if (unitInfo.Class=="DRUID" and activeTree==103) then
			role = "RoleMeleDps"; -- Feral
		elseif (unitInfo.Class=="SHAMAN" and activeTree==263) then
			role = "RoleMeleDps"; -- Enhancement
		elseif (unitInfo.Class=="WARRIOR" or unitInfo.Class=="MONK" or unitInfo.Class=="PALADIN") then
			role = "RoleMeleDps";
		else
			role = "RoleRangeDps";
		end
	elseif (roleType=="HEALER") then
		role = "RoleHealer";
	elseif (roleType=="TANK") then
		role = "RoleTank";
	end
	self.InspectedRoles[unitInfo.Name] = role;
	return role;
end

function PowaAuras:DetermineRole(unit)
	if (unit==nil) then return; end
	local null, class = UnitClass(unit);
	if (class=="ROGUE") then
		return "RoleMeleDps", "Preset";
	elseif (class=="HUNTER") then
		return "RoleRangeDps", "Preset";
	elseif (class=="MAGE") then
		return "RoleRangeDps", "Preset";
	elseif (class=="WARLOCK") then
		return "RoleRangeDps", "Preset";
	end
	local unitName = UnitName(unit);
	if (self.InspectedRoles[unitName] ~= nil) then
		return self.InspectedRoles[unitName], "Inspected";
	end
	if (self.FixRoles[unitName] ~= nil) then
		return self.FixRoles[unitName], "Fixed";
	end
	if (class=="DEATHKNIGHT") then
		local null, null, buffExist = UnitBuff(unit, self.Spells.BUFF_BLOOD_PRESENCE);
		if (buffExist) then
			self.FixRoles[unitName] = "RoleTank";
		else
			self.FixRoles[unitName] = "RoleMeleDps";
		end
		return self.FixRoles[unitName], "Guess";
	elseif (class=="PRIEST") then
		local null, null, buffExist = UnitBuff(unit, self.Spells.SHADOWFORM);
		if (buffExist) then
			self.FixRoles[unitName] = "RoleRangeDps";
			return "RoleRangeDps", "Guess";
		end
		return "RoleHealer", "Guess";
	elseif (class=="WARRIOR") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);
		if (defense > 2) then
			return "RoleTank", "Guess";
		end
		return "RoleMeleDps", "Guess";
	elseif (class=="DRUID") then
		local null, powerType = UnitPowerType(unit);
		if (powerType == "MANA") then
			null, null, tBuffExist = UnitBuff(unit, self.Spells.MOONKIN_FORM);
			if (tBuffExist) then
				self.FixRoles[unitName] = "RoleRangeDps";
				return "RoleRangeDps", "Guess";
			else
				return "RoleHealer", "Guess";
			end
		elseif (powerType == "RAGE") then
			self.FixRoles[unitName] = "RoleTank";
			return "RoleTank", "Guess";
		elseif (powerType == "ENERGY") then
			self.FixRoles[unitName] = "RoleMeleDps";
			return "RoleMeleDps", "Guess";
		end
	elseif (class=="PALADIN") then
		local defense = select(2, UnitDefense(unit)) / UnitLevel(unit);
		if (defense > 2) then
			return "RoleTank", "Guess";
		end
		if (UnitStat(unit, 4) > UnitStat(unit, 1)) then
			return "RoleHealer", "Guess";
		end
		return "RoleMeleDps", "Guess";
	elseif (class=="SHAMAN") then
		if (UnitStat(unit, 2) > UnitStat(unit, 4)) then
			return "RoleMeleDps", "Guess";
		end
		return "RoleHealer", "Guess"; -- Can't tell, assume its a healer
	end
	return nil;
end