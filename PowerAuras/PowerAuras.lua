--[[
	   _          _           _    _       _        _              _          _      _          _        _            _        _           _        _       _       _       _      
	 _/\\___   __/\\___  ___ /\\  /\\   __/\\___  _/\\___       __/\\__  ___ /\\   _/\\___   __/\\__    /\\__      __/\\___  _/\\_      __/\\__    /\\__   /\\__  _/\\_  __/\\___  
	(_   _ _))(_     _))/   |  \\/  \\ (_  ____))(_   _  ))    (_  ____)/  //\ \\ (_   _  ))(_  ____)  /    \\    (_  ____))(_  _))    (_  ____)  /    \\ /    \\(____))(_  ____)) 
	 /  |))\\  /  _  \\ \:' |   \\   \\ /  ._))   /  |))//      /  _ \\ \:.\\_\ \\ /  |))//  /  _ \\  _\  \_//     /  ||     /  \\      /  _ \\  _\  \_//_\  \_// /  \\  /  ||     
	/:. ___// /:.(_)) \\ \  :   </   ///:. ||___ /:.    \\     /:./_\ \\ \  :.  ///:.    \\ /:./_\ \\// \:.\      /:. ||___ /:.  \\__  /:./_\ \\// \:.\ // \:.\  /:.  \\/:. ||___  
	\_ \\     \  _____//(_   ___^____))\  _____))\___|  //     \  _   //(_   ___))\___|  // \  _   //\\__  /      \  _____))\__  ____))\  _   //\\__  / \\__  /  \__  //\  _____)) 
	  \//      \//        \//           \//           \//       \// \//   \//          \//   \// \//    \\/        \//4.23.25  \//      \// \//    \\/     \\/      \//  \//       

	Power Auras Classic
	Current author/maintainter: Resike
	E-Mail: resike@gmail.com
	All rights reserved.
--]]

local string, find, sub, gmatch, len, tostring, tonumber, math, min, max, floor, sqrt, table, insert, pairs, select = string, find, sub, gmatch, len, tostring, tonumber, math, min, max, floor, sqrt, table, insert, pairs, select

-- Exposed for Saving
PowaMisc =
{
	Disabled = false,
	debug = false,
	OnUpdateLimit = 0,
	AnimationLimit = 0,
	Version = GetAddOnMetadata("PowerAuras", "Version"),
	DefaultTimerTexture = "Original",
	DefaultStacksTexture = "Original",
	TimerRoundUp = true,
	AllowInspections = false,
	UseGTFO = nil,
	UserSetMaxTextures = PowaAuras.TextureCount,
	OverrideMaxTextures = false,
	Locked = true,
	SoundChannel = "Master"
}

PowaGlobalMisc =
{
	PathToSounds = "Interface\\AddOns\\PowerAuras\\Sounds\\",
	PathToAuras = "Interface\\Addons\\PowerAuras\\Custom\\",
	BlockIncomingAuras = false,
	FixExports = false
}

PowaAuras.PowaMiscDefault = PowaAuras:CopyTable(PowaMisc)
PowaAuras.PowaGlobalMiscDefault = PowaAuras:CopyTable(PowaGlobalMisc)

PowaSet = { }
PowaTimer = { }

PowaGlobalSet = { }
PowaGlobalListe = { }
PowaPlayerListe = { }

-- Default Page Names
for i = 1, 5 do
	PowaPlayerListe[i] = PowaAuras.Text.ListePlayer.." "..i
end
for i = 1, 10 do
	PowaGlobalListe[i] = PowaAuras.Text.ListeGlobal.." "..i
end

function PowaAuras:Toggle(enable)
	if (not (self.VariablesLoaded and self.SetupDone)) then
		return
	end
	if (enable == nil) then
		enable = PowaMisc.Disabled
	end
	if enable then
		if (not PowaMisc.Disabled) then
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
		if (PowaMisc.Disabled) then
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

function PowaAuras:OnLoad(frame)
	frame:RegisterEvent("ADDON_LOADED")
	SlashCmdList["POWA"] = PowaAuras_CommanLine
	SLASH_POWA1 = "/pa"
	SLASH_POWA2 = "/powa"
end

function PowaAuras:ReregisterEvents(frame)
	PowaAuras_Frame:UnregisterAllEvents()
	self:RegisterEvents(frame)
end

function PowaAuras:RegisterEvents(frame)
	if (self.playerclass == "DRUID") then
		self.Events.UPDATE_SHAPESHIFT_FORM = true
	end
	for event in pairs(self.Events) do
		if (self[event]) then
			frame:RegisterEvent(event)
		else
			self:DisplayText("Event has no method ", event)
		end
	end
end

function PowaAuras:LoadAuras()
	self.Auras = { }
	self.AuraSequence = { }
	for k, v in pairs(PowaGlobalSet) do
		if (k ~= 0 and v.is_a == nil or not v:is_a(cPowaAura)) then
			self.Auras[k] = self:AuraFactory(v.bufftype, k, v)
		end
	end
	for k, v in pairs(PowaSet) do
		if (k > 0 and k < 121 and not self.Auras[k]) then
			if (v.is_a == nil or not v:is_a(cPowaAura)) then
				self.Auras[k] = self:AuraFactory(v.bufftype, k, v)
			end
		end
	end
	if (self.DebugAura and self.Auras[self.DebugAura]) then
		self.Auras[self.DebugAura].Debug = true
	end
	self:DiscoverLinkedAuras()
	--self.Auras[0] = cPowaAura(0, {off = true})
	if (self.VersionUpgraded) then
		self:UpdateOldAuras()
	end
	self:CalculateAuraSequence()
	-- Copy to Saved Sets
	PowaSet = self.Auras
	for i = 121, 360 do
		PowaGlobalSet[i] = self.Auras[i]
	end
	PowaTimer = { }
end

function PowaAuras:CalculateAuraSequence()
	wipe(self.AuraSequence)
	for id, aura in pairs(self.Auras) do
		table.insert(self.AuraSequence, aura)
	end
end

function PowaAuras:DiscoverLinkedAuras()
	for i = 1, #self.AuraSequence do
		self:DiscoverLinksForAura(self.AuraSequence[i], true)
	end
end

function PowaAuras:DiscoverLinksForAura(aura, ignoreOff)
	if (not aura or (ignoreOff and aura.off) or not aura.multiids or aura.multiids == "" or self.UsedInMultis[aura.id]) then return end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2)
		end
		local id = tonumber(pword)
		if (id) then
			self.UsedInMultis[id] = true
			self:DiscoverLinksForAura(self.Auras[id], false)
		end
	end
end

function PowaAuras:UpdateOldAuras()
	self:Message("Upgrading old power auras.")
	-- Copy old timer info (should be once only)
	for k, v in pairs(PowaTimer) do
		local aura = self.Auras[k]
		if (aura) then
			aura.Timer = cPowaTimer(aura, v)
			if (PowaSet[k] ~= nil and PowaSet[k].timer ~= nil) then
				aura.Timer.enabled = PowaSet[k].timer
			end
			if (PowaGlobalSet[k] ~= nil and PowaGlobalSet[k].timer ~= nil) then
				aura.Timer.enabled = PowaGlobalSet[k].timer
			end
		end
	end
	local rescaleRatio = UIParent:GetHeight() / 768
	if (not rescaleRatio or rescaleRatio == 0) then
		rescaleRatio = 1
	end
	-- Update for backwards combatiblity
	for i = 1, 360 do
		-- Manage additions
		local aura = self.Auras[i]
		local oldaura = PowaSet[i]
		if (oldaura == nil) then
			oldaura = PowaGlobalSet[i]
		end
		if (aura and oldaura) then
			if (oldaura.combat == 0) then
				aura.combat = 0
			elseif (oldaura.combat == 1) then
				aura.combat = true
			elseif (oldaura.combat == 2) then
				aura.combat = false
			end
			if (oldaura.ignoreResting == true) then
				aura.isResting = true
			elseif (oldaura.ignoreResting == true) then
				aura.isResting = false
			end
			aura.ignoreResting = nil
			if (oldaura.isinraid == true) then
				aura.inRaid = true
			elseif (oldaura.isinraid == false) then
				aura.inRaid = 0
			end
			aura.isinraid = nil
			if (oldaura.isDead == true) then
				aura.isAlive = false
			elseif (oldaura.isDead == false) then
				aura.isAlive = true
			elseif (oldaura.isDead == 0) then
				aura.isAlive = 0
			end
			aura.isDead = nil
			if (aura.buffname == "") then
				self.Auras[i] = nil
			elseif (aura.bufftype == nil) then
				if (oldaura.isdebuff) then
					aura.bufftype = self.BuffTypes.Debuff
				elseif (oldaura.isdebufftype) then
					aura.bufftype = self.BuffTypes.TypeDebuff
				elseif (oldaura.isenchant) then
					aura.bufftype = self.BuffTypes.Enchant
				else
					aura.bufftype = self.BuffTypes.Buff
				end
			-- Update old combo style 1235 => 1/2/3/5
			elseif (aura.bufftype == self.BuffTypes.Combo) then
				if (string.len(aura.buffname) > 1 and string.find(aura.buffname, "/", 1, true) == nil) then
					local newBuffName=string.sub(aura.buffname, 1, 1)
					for i = 2, string.len(aura.buffname) do
						newBuffName = newBuffName.."/"..string.sub(aura.buffname, i, i)
					end
					aura.buffname = newBuffName
				end
			-- Update Spell Alert logic
			elseif (aura.bufftype == self.BuffTypes.SpellAlert) then
				if (PowaSet[i] ~= nil and PowaSet[i].RoleTank == nil) then
					if (aura.target) then
						aura.groupOrSelf = true
					elseif (aura.targetfriend) then
						aura.targetfriend = false
					end
				end
			end
			-- Rescale if required
			if (PowaSet[i] ~= nil and PowaSet[i].RoleTank == nil and math.abs(rescaleRatio - 1.0) > 0.01) then
				if (aura.Timer) then
					aura.Timer.x = aura.Timer.x * rescaleRatio
					aura.Timer.y = aura.Timer.y * rescaleRatio
					aura.Timer.h = aura.Timer.h * rescaleRatio
				end
				if (aura.Stacks) then
					aura.Stacks.x = aura.Stacks.x * rescaleRatio
					aura.Stacks.y = aura.Stacks.y * rescaleRatio
					aura.Stacks.h = aura.Stacks.h * rescaleRatio
				end
			end
			if (PowaSet[i] ~= nil) then
				if (aura.Timer) then
					aura.Timer.x = math.floor(aura.Timer.x + 0.5)
					aura.Timer.y = math.floor(aura.Timer.y + 0.5)
					aura.Timer.h = math.floor(aura.Timer.h * 100 + 0.5) / 100
				end
				if (aura.Stacks) then
					aura.Stacks.x = math.floor(aura.Stacks.x + 0.5)
					aura.Stacks.y = math.floor(aura.Stacks.y + 0.5)
					aura.Stacks.h = math.floor(aura.Stacks.h * 100 + 0.5) / 100
				end
			end
			if (aura.Timer and self:IsNumeric(oldaura.Timer.InvertAuraBelow)) then
				aura.InvertAuraBelow = oldaura.Timer.InvertAuraBelow
			end
		end
	end
end

-- Events
function PowaAuras:FindAllChildren()
	for _, aura in pairs(self.Auras) do
		aura.Children = nil
	end
	for _, aura in pairs(self.Auras) do
		self:FindChildren(aura)
	end
	--[[for _, aura in pairs(self.Auras) do
		if (aura.Children) then
			self:ShowText("Aura "..aura.id.." Children:")
			for childId in pairs(aura.Children) do
				self:ShowText(" "..childId)
			end
		end
	end]]
end

function PowaAuras:FindChildren(aura)
	if (not aura.multiids or aura.multiids == "") then
		return
	end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2)
		end
		local id = tonumber(pword)
		local dependant = self.Auras[id]
		if (dependant) then
			if (not dependant.Children) then
				dependant.Children = { }
			end
			dependant.Children[aura.id] = true
		end
	end
end

function PowaAuras:CustomTexPath(customname)
	--self:ShowText("CustomTexPath ", customname)
	local texpath
	if string.find(customname, ".", 1, true) then
		texpath = PowaGlobalMisc.PathToAuras..customname
	else
		local spellId = select(3, string.find(customname, "%[?(%d+)%]?"))
		if (spellId) then
			texpath = select(3, GetSpellInfo(tonumber(spellId)))
		else
			texpath = select(3, GetSpellInfo(customname))
		end
	end
	if not texpath then
		texpath = ""
	end
	return texpath
end

function PowaAuras:CreateTimerFrame(auraId, index, updatePing)
	local frame = CreateFrame("Frame", nil, UIParent)
	self.TimerFrame[auraId][index] = frame
	local aura = self.Auras[auraId]
	frame:SetFrameStrata(aura.strata)
	frame:Hide()
	frame.texture = frame:CreateTexture(nil,"BACKGROUND")
	frame.texture:SetBlendMode("ADD")
	frame.texture:SetAllPoints(frame)
	frame.texture:SetTexture(aura.Timer:GetTexture())
	if (updatePing) then
		frame.PingAnimationGroup = frame:CreateAnimationGroup("Ping")
		self:AddJumpScaleAndReturn(frame.PingAnimationGroup, 1.1, 1.1, 0.3, 1)
		self:AddBrightenAndReturn(frame.PingAnimationGroup, 1.2, aura.alpha, 0.3, 1)
	end
end

function PowaAuras:CreateTimerFrameIfMissing(auraId, updatePing)
	local aura = self.Auras[auraId]
	if (not self.Frames[auraId] and aura.Timer:IsRelative()) then
		aura.Timer.Showing = false
		return
	end
	if (not self.TimerFrame[auraId]) then
		self.TimerFrame[auraId] = { }
		self:CreateTimerFrame(auraId, 1, updatePing)
		self:CreateTimerFrame(auraId, 2, updatePing)
	end
	self:UpdateOptionsTimer(auraId)
	return self.TimerFrame[auraId][1], self.TimerFrame[auraId][2]
end

function PowaAuras:CreateStacksFrameIfMissing(auraId, updatePing)
	local aura = self.Auras[auraId]
	if (not self.Frames[auraId] and aura.Stacks:IsRelative()) then
		aura.Stacks.Showing = false
		return
	end
	if (not self.StacksFrames[auraId]) then
		local frame = CreateFrame("Frame", nil, UIParent)
		self.StacksFrames[auraId] = frame
		frame:SetFrameStrata(aura.strata)
		frame:Hide()
		frame.texture = frame:CreateTexture(nil, "BACKGROUND")
		frame.texture:SetBlendMode("ADD")
		frame.texture:SetAllPoints(frame)
		frame.texture:SetTexture(aura.Stacks:GetTexture())
		frame.textures = {
			[1] = frame.texture
		}
		if (updatePing) then
			frame.PingAnimationGroup = frame:CreateAnimationGroup("Ping")
			self:AddJumpScaleAndReturn(frame.PingAnimationGroup, 1.1, 1.1, 0.3, 1)
			self:AddBrightenAndReturn(frame.PingAnimationGroup, 1.2, aura.alpha, 0.3, 1)
		end
	end
	self:UpdateOptionsStacks(auraId)
	return self.StacksFrames[auraId]
end

function PowaAuras:CreateEffectLists()
	for k in pairs(self.AurasByType) do
		wipe(self.AurasByType[k])
	end
	self.Events = self:CopyTable(self.AlwaysEvents)
	for id, aura in pairs(self.Auras) do
		if (not aura.off or self.UsedInMultis[id]) then
			aura:AddEffectAndEvents()
		end
	end
	if (PowaMisc.debug == true) then
		for k in pairs(self.AurasByType) do
			self:DisplayText(k..": "..#self.AurasByType[k])
		end
	end
end

function PowaAuras:InitialiseAllAuras()
	for _, aura in pairs(self.Auras) do
		aura:Init()
	end
end

function PowaAuras:MemorizeActions(actionIndex)
	local imin, imax
	if (#self.AurasByType.Actions == 0) then
		return
	end
	-- Scan every changed slots
	if (actionIndex == nil) then
		imin = 1
		imax = 120
		-- Reset all action positions
		for _, v in pairs(self.AurasByType.Actions) do
			self.Auras[v].slot = nil
		end
	else
		imin = actionIndex
		imax = actionIndex
	end
	for i = imin, imax do
		if (HasAction(i)) then
			local type, id, subType, spellID = GetActionInfo(i)
			local name, text
			if (type == "macro") then
				name = GetMacroInfo(id)
			end
			PowaAction_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
			PowaAction_Tooltip:SetAction(i)
			text = PowaAction_TooltipTextLeft1:GetText()
			PowaAction_Tooltip:Hide()
			if (text ~= nil) then
				for k, v in pairs(self.AurasByType.Actions) do
					local actionAura = self.Auras[v]
					if (actionAura == nil) then
						self.AurasByType.Actions[k] = nil -- aura deleted
					elseif (not actionAura.slot) then
						if (self:MatchString(name, actionAura.buffname, actionAura.ignoremaj)
						 or self:MatchString(text, actionAura.buffname, actionAura.ignoremaj)) then
							actionAura.slot = i -- remember the slot
							-- Remember the texture
							local tempicon
							if (actionAura.owntex == true) then
								PowaIconTexture:SetTexture(GetActionTexture(i))
								tempicon = PowaIconTexture:GetTexture()
								if (actionAura.icon ~= tempicon) then
									actionAura.icon = tempicon
								end
							elseif (actionAura.icon == "") then
								PowaIconTexture:SetTexture(GetActionTexture(i))
								actionAura.icon = PowaIconTexture:GetTexture()
							end
						end
					end
				end
			end
		end
	end
end

function PowaAuras:AddChildrenToCascade(aura, originalId)
	if (not aura or not aura.Children) then
		return
	end
	for id in pairs(aura.Children) do
		if (not self.Cascade[id] and id ~= originalId) then
			self.Cascade[id] = true
			self:AddChildrenToCascade(self.Auras[id], originalId or aura.id)
		end
	end
end

-- Runtime
function PowaAuras:OnUpdate(elapsed)
	if (not (self.VariablesLoaded and self.SetupDone)) then
		return
	end
	self.ChecksTimer = self.ChecksTimer + elapsed
	self.TimerUpdateThrottleTimer = self.TimerUpdateThrottleTimer + elapsed
	self.ThrottleTimer = self.ThrottleTimer + elapsed
	self.InGCD = nil
	if (self.GCDSpellName) then
		local gcdStart = GetSpellCooldown(self.GCDSpellName)
		if (gcdStart) then
			self.InGCD = (gcdStart > 0)
		end
	end
	local checkAura = false
	if (PowaMisc.OnUpdateLimit == 0 or self.ThrottleTimer >= PowaMisc.OnUpdateLimit) then
		checkAura = true
		self.ThrottleTimer = 0
	end
	if (not self.ModTest and checkAura) then
		if ((self.ChecksTimer > (self.NextCheck + PowaMisc.OnUpdateLimit))) then
			self.ChecksTimer = 0
			local isMountedNow = (IsMounted() == 1 and true or self:IsDruidTravelForm())
			if (isMountedNow ~= self.WeAreMounted) then
				self.DoCheck.All = true
				self.WeAreMounted = isMountedNow
			end
			local isInVehicledNow = (UnitInVehicle("player") ~= nil)
			if (isInVehicledNow ~= self.WeAreInVehicle) then
				self.DoCheck.All = true
				self.WeAreInVehicle = isInVehicledNow
			end
		end
		if (self.PendingRescan and GetTime() >= self.PendingRescan) then
			self:InitialiseAllAuras()
			self:MemorizeActions()
			self.DoCheck.All = true
			self.PendingRescan = nil
		end
		for id, cd in pairs(self.Pending) do
			if cd and cd > 0 then
				if (GetTime() >= cd) then
					self.Pending[id] = nil
					if (self.Auras[id]) then
						self.Auras[id].CooldownOver = true
						self:TestThisEffect(id)
						self.Auras[id].CooldownOver = nil
					end
				end
			else
				self.Pending[id] = nil
			end
		end
		if (self.DoCheck.CheckIt or self.DoCheck.All) then
			self:NewCheckBuffs()
			self.DoCheck.CheckIt = false
		end
		for k in pairs(self.Cascade) do
			self:TestThisEffect(k, false, true)
		end
		wipe(self.Cascade)
	end
	local skipTimerUpdate = false
	local timerElapsed = 0
	if (PowaMisc.AnimationLimit > 0 and self.TimerUpdateThrottleTimer < PowaMisc.AnimationLimit) then
		skipTimerUpdate = true
	else
		timerElapsed = self.TimerUpdateThrottleTimer
		self.TimerUpdateThrottleTimer = 0
	end
	if (PowaMisc.AllowInspections) then
		if (self.NextInspectUnit ~= nil) then
			if (GetTime() > self.NextInspectTimeOut) then
				self:SetRoleUndefined(self.NextInspectUnit)
				self.NextInspectUnit = nil
				self.InspectAgain = GetTime() + self.InspectDelay
			end
		elseif (not self.InspectsDone
				and self.InspectAgain ~= nil
				and not UnitOnTaxi("player")
				and GetTime() > self.InspectAgain) then
			self:TryInspectNext()
			self.InspectAgain = GetTime() + self.InspectDelay
		end
	end
	for i = 1, #self.AuraSequence do
		local aura = self.AuraSequence[i]
		if (self:UpdateAura(aura, elapsed)) then
			self:UpdateTimer(aura, timerElapsed, skipTimerUpdate)
		end
	end
	for _, aura in pairs(self.SecondaryAuras) do
		self:UpdateAura(aura, elapsed)
	end
	self.ResetTargetTimers = false
end

function PowaAuras:IsDruidTravelForm()
	if (self.playerclass ~= "DRUID") then
		return false
	end
	local nStance = GetShapeshiftForm()
	-- If stance 4 or 6, we're in travel/flight form.
	if(nStance == 4 or nStance == 6) then
		return true
	end
	-- If in stance 5, it's complicated. Moonkin/Tree form take index 5 if learned, but if not learned then flight form is here.
	if(nStance == 5 and select(5, GetTalentInfo(3, 21)) == 0 and select(5, GetTalentInfo(1, 8)) == 0) then
		return true
	end
	-- Otherwise we're not in it.
	return false
end

function PowaAuras:NewCheckBuffs()
	for i = 1, #self.AurasByTypeList do
		local auraType = self.AurasByTypeList[i]
		if ((self.DoCheck[auraType] or self.DoCheck.All) and #self.AurasByType[auraType] > 0) then
			for k, v in pairs(self.AurasByType[auraType]) do
				if (self.Auras[v] and self.Auras[v].Debug) then
					self:DisplayText("TestThisEffect ",v)
				end
				--[[if (self.AuraTypeCount[auraType] == nil) then
					self.AuraTypeCount[auraType] = 0
				end
				--self.AuraTypeCount[auraType] = self.AuraTypeCount[auraType] + 1]]
				self:TestThisEffect(v)
			end
		end
		self.DoCheck[auraType] = false
	end
	self.DoCheck.All = false
	wipe(self.AoeAuraAdded)
	wipe(self.ChangedUnits.Buffs)
	wipe(self.ChangedUnits.Targets)
	wipe(self.ExtraUnitEvent)
	wipe(self.CastOnMe)
	wipe(self.CastByMe)
end

function PowaAuras:TestThisEffect(auraId, giveReason, ignoreCascade)
	local aura = self.Auras[auraId]
	if (not aura) then
		return false, self.Text.nomReasonAuraMissing
	end
	if (aura.off) then
		if (aura.Showing) then
			aura:Hide()
		end
		if (not giveReason) then return false end
		return false, self.Text.nomReasonAuraOff
	end
	local debugEffectTest = PowaAuras.DebugCycle or aura.Debug
	if (debugEffectTest) then
		self:Message("===================================")
		self:Message("Test Aura for Hide or Show= ", auraId)
		self:Message("Active= ", aura.Active)
		self:Message("Showing= ", aura.Showing)
		self:Message("HideRequest= ", aura.HideRequest)
	end
	-- Prevent crash if class not set-up properly
	if (not aura.ShouldShow) then
		self:Message("ShouldShow nil! id= ", auraId)
		if (not giveReason) then
			return false
		end
		return false, self.Text.nomReasonAuraBad
	end
	aura.InactiveDueToMulti = nil
	local shouldShow, reason = aura:ShouldShow(giveReason or debugEffectTest)
	if (shouldShow == - 1) then
		if (debugEffectTest) then
			self:Message("TestThisEffect unchanged")
		end
		return aura.Active, reason
	end
	if (shouldShow == true) then
		shouldShow, reason = self:CheckMultiple(aura, reason, giveReason or debugEffectTest)
		if (not shouldShow) then
			aura.InactiveDueToMulti = true
		end
	elseif (aura.Timer and aura.CanHaveTimerOnInverse) then
		local multiShouldShow = self:CheckMultiple(aura, reason, giveReason or debugEffectTest)
		if (not multiShouldShow) then
			aura.InactiveDueToMulti = true
		end
	end
	if (debugEffectTest) then
		self:Message("shouldShow=", shouldShow, " because ", reason)
	end
	if shouldShow then
		if (not aura.Active) then
			if (debugEffectTest) then
				self:Message("ShowAura ", aura.buffname, " (", auraId,")", reason)
			end
			self:DisplayAura(auraId)
			if (not ignoreCascade) then self:AddChildrenToCascade(aura) end
			aura.Active = true
		end
	else
		local secondaryAura = self.SecondaryAuras[aura.id]
		if (aura.Showing) then
			if (debugEffectTest) then
				self:Message("HideAura ", aura.buffname, " (", auraId,")", reason)
			end
			self:SetAuraHideRequest(aura, secondaryAura)
		end
		if (aura.Active) then
			if (not ignoreCascade) then
				self:AddChildrenToCascade(aura)
			end
			aura.Active = false
			if (secondaryAura) then
				secondaryAura.Active = false
			end
		end
	end
	return shouldShow, reason
end

function PowaAuras:CheckMultiple(aura, reason, giveReason)
	if (not aura.multiids or aura.multiids == "") then
		if (not giveReason) then
			return true
		end
		return true, reason
	end
	if string.find(aura.multiids, "[^0-9/!]") then
		if (not giveReason) then
			return true
		end
		return true, reason
	end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		local reverse
		if (string.sub(pword, 1, 1) == "!") then
			pword = string.sub(pword, 2)
			reverse = true
		end
		local k = tonumber(pword)
		local linkedAura = self.Auras[k]
		local state
		if linkedAura then
			result, reason = linkedAura:ShouldShow(giveReason, reverse)
			if (result == false or (result == - 1 and not linkedAura.Showing and not linkedAura.HideRequest)) then
				if (not giveReason) then
					return false
				end
				return result, reason
			end
		end
	end
	if (not giveReason) then return true end
	return true, self:InsertText(self.Text.nomReasonMulti, aura.multiids)
end

function PowaAuras:SetAuraHideRequest(aura, secondaryAura)
	if (aura.Debug) then
		self:Message("SetAuraHideRequest ", aura.buffname)
	end
	aura.HideRequest = true
	if (not aura.InvertTimeHides) then
		aura.ForceTimeInvert = nil
	end
	if (secondaryAura and secondaryAura.Active) then
		secondaryAura.HideRequest = true
	end
end

-- Drag and Drop functions
local function stopFrameMoving(frame)
	if (frame == nil or not frame.isMoving) then
		return
	end
	frame.isMoving = false
	frame:StopMovingOrSizing()
	frame.aura.x = math.floor(frame:GetLeft() + (frame:GetWidth() - UIParent:GetWidth()) / 2 + 0.5)
	frame.aura.y = math.floor(frame:GetTop() - (frame:GetHeight() + UIParent:GetHeight()) / 2 + 0.5)
	frame:ClearAllPoints()
	frame:SetPoint("CENTER", frame.aura.x, frame.aura.y)
	if (PowaAuras.CurrentAuraId == frame.aura.id) then
		PowaAuras:InitPage(frame.aura)
	end
end

local function stopMove(frame, button)
	if (button ~= "LeftButton") then
		return
	end
	stopFrameMoving(frame)
end

local function startFrameMoving(frame)
	if (frame.isMoving) then
		return
	end
	if (PowaAuras.CurrentAuraId ~= frame.aura.id) then
		stopFrameMoving(PowaAuras.Frames[PowaAuras.CurrentAuraId])
		local i = frame.aura.id - (PowaAuras.CurrentAuraPage - 1) * 24
		local icon
		if (i > 0 and i < 25) then
			icon = getglobal("PowaIcone"..i)
		end
		PowaAuras:SetCurrent(icon, frame.aura.id)
		--PowaAuras:InitPage(frame.aura) -- This seems to mess things up?
	end
	frame.isMoving = true
	frame:StartMoving()
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if (secondaryAura ~= nil) then
		secondaryAura.HideRequest = true
	end
end

local function startMove(frame, button)
	if (button ~= "LeftButton") then
		return
	end
	startFrameMoving(frame)
end

local function keyUp(frame, key)
	if ((key ~= "UP" and key ~= "DOWN" and key ~= "LEFT" and key ~= "RIGHT") or not frame.mouseIsOver) then
		return
	end
	if (key == "UP") then
		frame.aura.y = frame.aura.y + 1
	elseif (key == "DOWN") then
		frame.aura.y = frame.aura.y - 1
	elseif (key == "LEFT") then
		frame.aura.x = frame.aura.x - 1
	elseif (key == "RIGHT") then
		frame.aura.x = frame.aura.x + 1
	end
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if (secondaryAura ~= nil) then
		secondaryAura.HideRequest = true
	end
	if (PowaAuras.CurrentAuraId == frame.aura.id) then
		PowaAuras:InitPage(frame.aura)
	end
	PowaAuras:RedisplayAura(frame.aura.id)
end

local function enterAura(frame)
	frame.mouseIsOver = true
	frame:EnableKeyboard(true)
	frame:SetScript("OnKeyUp", keyUp)
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
	frame:SetScript("OnMouseDown", startMove)
	frame:SetScript("OnMouseUp", stopMove)
end

local function leaveAura(frame)
	frame.mouseIsOver = nil
	stopFrameMoving(frame)
	frame:EnableKeyboard(false)
	frame:SetScript("OnKeyUp", nil)
	frame:SetScript("OnDragStart", nil)
	frame:SetScript("OnDragStop", nil)
	frame:SetScript("OnMouseDown", nil)
	frame:SetScript("OnMouseUp", nil)
	frame:SetScript("OnKeyUp", nil)
end

function PowaAuras:SetForDragging(aura, frame)
	if (frame == nil or aura == nil or frame.SetForDragging) then
		return
	end
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)
	frame:RegisterForDrag("LeftButton")
	frame:SetBackdrop(self.Backdrop)
	frame:SetBackdropColor(0, 0.6, 0, 1)
	frame:SetScript("OnEnter", enterAura)
	frame:SetScript("OnLeave", leaveAura)
	frame.SetForDragging = true
end

function PowaAuras:ResetDragging(aura, frame)
	if (frame == nil or aura == nil or not frame.SetForDragging) then
		return
	end
	frame:SetMovable(false)
	frame:EnableMouse(false)
	frame:EnableKeyboard(false)
	frame:RegisterForDrag()
	frame:SetBackdrop(nil)
	frame:SetScript("OnDragStart", nil)
	frame:SetScript("OnDragStop", nil)
	frame:SetScript("OnMouseDown", nil)
	frame:SetScript("OnMouseUp", nil)
	frame:SetScript("OnKeyUp", nil)
	frame:SetScript("OnHide", nil)
	frame:SetScript("OnEnter", nil)
	frame:SetScript("OnLeave", nil)
	frame.SetForDragging = nil
end

function PowaAuras:ShowAuraForFirstTime(aura)
	local auraId = aura.id
	if (not aura.UseOldAnimations and aura.EndAnimation and aura.EndAnimation:IsPlaying()) then
		aura:Hide()
	end
	aura.EndSoundPlayed = nil
	if (not self.ModTest) then
		if (aura.customsound ~= "") then
			local pathToSound
			if (string.find(aura.customsound, "\\")) then
				pathToSound = aura.customsound
			else
				pathToSound = PowaGlobalMisc.PathToSounds .. aura.customsound
			end
			PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		elseif (aura.sound > 0) then
			if (PowaAuras.Sound[aura.sound] ~= nil and string.len(PowaAuras.Sound[aura.sound]) > 0) then
				if (string.find(PowaAuras.Sound[aura.sound], "%.")) then
					PlaySoundFile(PowaGlobalMisc.PathToSounds .. PowaAuras.Sound[aura.sound], PowaMisc.SoundChannel)
				else
					PlaySound(PowaAuras.Sound[aura.sound], PowaMisc.SoundChannel)
				end
			end
		end
	end
	local frame, model, texture = aura:CreateFrames()
	frame.aura = aura
	if (self.ModTest and not PowaMisc.Locked) then
		self:SetForDragging(aura, frame)
	else
		self:ResetDragging(aura, frame)
	end
	if (aura.owntex == true) then
		model:SetUnit("none")
		texture:Show()
		if (aura.icon == "") then
			texture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
		else
			texture:SetTexture(aura.icon)
		end
	elseif (aura.wowtex == true) then
		model:SetUnit("none")
		texture:Show()
		texture:SetTexture(self.WowTextures[aura.texture])
	elseif (aura.customtex == true) then
		model:SetUnit("none")
		texture:Show()
		texture:SetTexture(self:CustomTexPath(aura.customname))
	elseif (aura.textaura == true) then
		model:SetUnit("none")
		texture:Show()
		texture:SetText(aura.aurastext)
	elseif (aura.model == true) then
		texture:Hide()
		model:SetUnit("none")
		model:SetModel(PowaAurasModels[aura.texture])
	elseif (aura.modelcustom == true) then
		texture:Hide()
		if (aura.modelcustom ~= nil and aura.modelcustom ~= "") then
			if (string.find(aura.modelcustompath, "%.m2")) then
				model:SetUnit("none")
				model:SetModel(aura.modelcustompath)
			else
				model:SetUnit(string.lower(aura.modelcustompath))
			end
		end
	else
		model:SetUnit("none")
		texture:Show()
		texture:SetTexture("Interface\\Addons\\PowerAuras\\Auras\\Aura"..aura.texture..".tga")
	end
	local r1, r2, r3, r4, r5, r6
	if (aura.randomcolor) then
		if (aura.model ~= true and aura.modelcustom ~= true) then
			r1 = random(20, 100) / 100
			r2 = random(20, 100) / 100
			r3 = random(20, 100) / 100
			r4 = random(20, 100) / 100
			r5 = random(20, 100) / 100
			r6 = random(20, 100) / 100
			if (aura.textaura ~= true) then
				if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
					texture:SetGradientAlpha(aura.gradientstyle, r1, r2, r3, 1.0, r4, r5, r6, 1.0)
				else
					texture:SetVertexColor(r1, r2, r3)
				end
				if (aura.desaturation == true) then
					local shaderSupported = texture:SetDesaturated(1)
					if (shaderSupported) then
						texture:SetDesaturated(1)
					else
						if (desaturation) then
							texture:SetVertexColor(0.5, 0.5, 0.5)
						else
							texture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					texture:SetDesaturated(nil)
				end
			else
				texture:SetVertexColor(r1, r2, r3)
			end
			if (AuraTexture:GetTexture() ~= "Interface\\CharacterFrame\\TempPortrait" and AuraTexture:GetTexture() ~= "Interface\\Icons\\Inv_Misc_QuestionMark" and AuraTexture:GetTexture() ~= "Interface\\Icons\\INV_Scroll_02") then
				if (aura.off ~= true) then
					if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
						AuraTexture:SetGradientAlpha(aura.gradientstyle, r1, r2, r3, 1.0, r4, r5, r6, 1.0)
					else
						AuraTexture:SetVertexColor(r1, r2, r3)
					end
					if (aura.desaturation == true) then
						local shaderSupported = AuraTexture:SetDesaturated(1)
						if (shaderSupported) then
							AuraTexture:SetDesaturated(1)
						else
							if (desaturation) then
								AuraTexture:SetVertexColor(0.5, 0.5, 0.5)
							else
								AuraTexture:SetVertexColor(1.0, 1.0, 1.0)
							end
						end
					else
						AuraTexture:SetDesaturated(nil)
					end
				end
			else
				AuraTexture:SetVertexColor(1, 1, 1)
			end
		end
	else
		if (aura.model ~= true and aura.modelcustom ~= true) then
			if (aura.textaura ~= true) then
				if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
					texture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
				else
					texture:SetVertexColor(aura.r, aura.g, aura.b)
				end
				if (aura.desaturation == true) then
					local shaderSupported = texture:SetDesaturated(1)
					if (shaderSupported) then
						texture:SetDesaturated(1)
					else
						if (desaturation) then
							texture:SetVertexColor(0.5, 0.5, 0.5)
						else
							texture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					texture:SetDesaturated(nil)
				end
			else
				texture:SetVertexColor(aura.r, aura.g, aura.b)
			end
			if (AuraTexture:GetTexture() ~= "Interface\\CharacterFrame\\TempPortrait" and AuraTexture:GetTexture() ~= "Interface\\Icons\\Inv_Misc_QuestionMark" and AuraTexture:GetTexture() ~= "Interface\\Icons\\INV_Scroll_02") then
				if (aura.off ~= true) then
					if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
						AuraTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
					else
						AuraTexture:SetVertexColor(aura.r, aura.g, aura.b)
					end
					if (aura.desaturation == true) then
						local shaderSupported = AuraTexture:SetDesaturated(1)
						if (shaderSupported) then
							AuraTexture:SetDesaturated(1)
						else
							if (desaturation) then
								AuraTexture:SetVertexColor(0.5, 0.5, 0.5)
							else
								AuraTexture:SetVertexColor(1.0, 1.0, 1.0)
							end
						end
					else
						AuraTexture:SetDesaturated(nil)
					end
				end
			else
				AuraTexture:SetVertexColor(1, 1, 1)
			end
		end
	end
	if (aura.model ~= true and aura.modelcustom ~= true) then
		if (aura.textaura ~= true) then
			texture:SetBlendMode(aura.blendmode)
		else
			texture:SetShadowColor(0.0, 0.0, 0.0, 0.0)
			texture:SetShadowOffset(0, 0)
		end
	end
	frame:SetFrameStrata(aura.strata)
	frame:SetFrameLevel(aura.stratalevel)
	if (aura.model ~= true and aura.modelcustom ~= true) then
		texture:SetDrawLayer(aura.texturestrata, aura.texturesublevel)
	end
	local height = 256
	local width = 256
	if (aura.textaura ~= true and aura.model ~= true and aura.modelcustom ~= true) then
		texture:SetRotation(math.rad(aura.rotate))
	elseif (aura.model == true or aura.modelcustom == true) then
		model:SetPosition(aura.mz, aura.mx, aura.my)
		model:SetRotation(math.rad(aura.rotate))
		if (aura.modelanimation > - 1 and aura.modelanimation ~= nil and aura.modelanimation < 802) then
			local elapsed = 0
			model:SetScript("OnUpdate", function(self, elaps)
				elapsed = elapsed + (elaps * 1000)
				model:SetSequenceTime(aura.modelanimation, elapsed)
			end)
		end
	end
	if (aura.customtex == true) or (aura.wowtex == true) or (aura.owntex == true) or ((aura.customtex ~= true) and (aura.wowtex ~= true) and (aura.model ~= true) and (aura.modelcustom ~= true) and (aura.textaura ~= true) and (aura.owntex ~= true)) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
		local x = (math.sqrt(2) - 1) / 2
		if (aura.rotate == 0) or (aura.rotate == 360) then
			texture:SetTexCoord(ULx + x, ULy + x, LLx + x, LLy - x, URx - x, URy + x, LRx - x, LRy - x)
		elseif (aura.rotate == 90) then
			texture:SetTexCoord(ULx - x, ULy + x, LLx + x, LLy + x, URx - x, URy - x, LRx + x, LRy - x)
		elseif (aura.rotate == 180) then
			texture:SetTexCoord(ULx - x, ULy - x, LLx - x, LLy + x, URx + x, URy - x, LRx + x, LRy + x)
		elseif (aura.rotate == 270) then
			texture:SetTexCoord(ULx + x, ULy - x, LLx - x, LLy - x, URx + x, URy + x, LRx - x, LRy + x)
		end
		if (aura.customtex == true) then
			if string.find(aura.customname, "%.") then
				-- Do nothing
			else
				if (aura.roundicons == true) then
					SetPortraitToTexture(texture, texture:GetTexture())
				end
			end
		end
		if (aura.owntex == true) then
			if (aura.roundicons == true) then
				SetPortraitToTexture(texture, texture:GetTexture())
			end
		end
	end
	if (aura.textaura ~= true and aura.model ~= true and aura.modelcustom ~= true) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
		if (aura.symetrie == 1) then
			texture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy) -- Inverse X
		elseif (aura.symetrie == 2) then
			texture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy) -- Inverse Y
		elseif (aura.symetrie == 3) then
			texture:SetTexCoord(LRx, LRy, URx, URy, LLx, LLy, ULx, ULy) -- Inverse XY
		else
			texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
		end
	end
	if (aura.textaura == true) then
		local fontsize = math.min(33, math.max(10, math.floor(frame.baseH / 12.8)))
		local checkfont = texture:SetFont(self.Fonts[aura.aurastextfont], fontsize, "OUTLINE, MONOCHROME")
		if not checkfont then
			texture:SetFont(STANDARD_TEXT_FONT, fontsize, "OUTLINE, MONOCHROME")
		end
		frame.baseH = height * aura.size * (2 - aura.torsion)
		frame.baseL = texture:GetStringWidth() + 5
	elseif (aura.customtex == true) or (aura.wowtex == true) or (aura.model == true) or (aura.modelcustom == true) or (aura.owntex == true) or ((aura.customtex ~= true) and (aura.wowtex ~= true) and (aura.model ~= true) and (aura.modelcustom ~= true) and (aura.textaura ~= true) and (aura.owntex ~= true)) then
		if ((aura.rotate == 0) or (aura.rotate == 90) or (aura.rotate == 180) or (aura.rotate == 270) or (aura.rotate == 360)) and (aura.model ~= true) and (aura.modelcustom ~= true) then
			frame.baseH = height * aura.size * (2 - aura.torsion)
			frame.baseL = width * aura.size * aura.torsion
		else
			frame.baseH = math.sqrt(2) * height * aura.size * (2 - aura.torsion)
			frame.baseL = math.sqrt(2) * width * aura.size * aura.torsion
		end
	end
	PowaAuras:InitialiseFrame(aura, frame)
	if (aura.duration > 0) then
		aura.TimeToHide = GetTime() + aura.duration
	else
		aura.TimeToHide = nil
	end
	if (aura.InvertTimeHides) then
		aura.ForceTimeInvert = nil
	end
	if (aura.Timer and aura.Timer.enabled) then
		if (aura.Debug) then
			self:Message("Show Timer")
		end
		PowaAuras:CreateTimerFrameIfMissing(aura.id, aura.Timer.UpdatePing)
		if (aura.timerduration) then
			aura.Timer.CustomDuration = aura.timerduration
		end
		aura.Timer.Start = GetTime()
	end
	if (aura.Stacks and aura.Stacks.enabled) then
		PowaAuras:CreateStacksFrameIfMissing(aura.id, aura.Stacks.UpdatePing)
		aura.Stacks:ShowValue(aura, aura.Stacks.lastShownValue)
	end
	if (aura.UseOldAnimations) then
		frame.statut = 0
		if (aura.begin > 0) then
			frame.beginAnim = 1
		else
			frame.beginAnim = 0
		end
		if (aura.begin and aura.begin > 0) then
			aura.animation = self:AnimationBeginFactory(aura.begin, aura, frame)
		else
			aura.animation = self:AnimationMainFactory(aura.anim1, aura, frame)
		end
	elseif (aura.textaura ~= true) then
		if (not aura.BeginAnimation) then
			aura.BeginAnimation = self:AddBeginAnimation(aura, frame)
		end
		if (not aura.MainAnimation) then
			aura.MainAnimation = self:AddMainAnimation(aura, frame)
		end
		if (not aura.EndAnimation) then
			aura.EndAnimation = self:AddEndAnimation(aura, frame)
		end
	end
	if (not aura.UseOldAnimations) then
		if (aura.BeginAnimation) then
			aura.BeginAnimation:Play()
			frame:SetAlpha(0)
		elseif (aura.MainAnimation) then
			aura.MainAnimation:Play()
		end
	end
	if (aura.Debug) then
		self:Message("frame:Show()", aura.id, " ", frame)
	end
	frame:Show()
	aura.Showing = true
	aura.HideRequest = false
	self:ShowSecondaryAuraForFirstTime(aura, r1, r2, r3, r4, r5, r6)
end

function PowaAuras:InitialiseFrame(aura, frame)
	frame:SetAlpha(math.min(aura.alpha, 0.99))
	frame:SetPoint("CENTER", aura.x, aura.y)
	frame:SetWidth(frame.baseL)
	frame:SetHeight(frame.baseH)
end

function PowaAuras:ShowSecondaryAuraForFirstTime(aura, r1, r2, r3, r4, r5, r6)
	if (aura.anim2 == 0) then
		local secondaryAura = self.SecondaryAuras[aura.id]
		if (secondaryAura) then
			secondaryAura:Hide()
		end
		self.SecondaryAuras[aura.id] = nil
		self.SecondaryFrames[aura.id] = nil
		self.SecondaryTextures[aura.id] = nil
		return
	end
	local secondaryAura = self:AuraFactory(aura.bufftype, aura.id, aura)
	self.SecondaryAuras[aura.id] = secondaryAura
	secondaryAura.isSecondary = true
	secondaryAura.alpha = aura.alpha * 0.5
	secondaryAura.anim1 = aura.anim2
	if (aura.speed > 0.5) then
		secondaryAura.speed = aura.speed - 0.1
	else
		secondaryAura.speed = aura.speed / 2
	end
	local auraId = aura.id
	local frame = self.Frames[auraId]
	local texture = self.Textures[auraId]
	local secondaryFrame, secondaryModel, secondaryTexture = secondaryAura:CreateFrames()
	if (aura.owntex == true) then
		secondaryModel:SetUnit("none")
		secondaryTexture:Show()
		secondaryTexture:SetTexture(aura.icon)
	elseif (aura.wowtex == true) then
		secondaryModel:SetUnit("none")
		secondaryTexture:Show()
		secondaryTexture:SetTexture(self.WowTextures[aura.texture])
	elseif (aura.customtex == true) then
		secondaryModel:SetUnit("none")
		secondaryTexture:Show()
		secondaryTexture:SetTexture(self:CustomTexPath(aura.customname))
	elseif (aura.textaura == true) then
		secondaryModel:SetUnit("none")
		secondaryTexture:Show()
		secondaryTexture:SetText(aura.aurastext)
	elseif (aura.model == true) then
		secondaryModel:SetUnit("none")
		secondaryTexture:Hide()
		secondaryModel:SetModel(PowaAurasModels[aura.texture])
	elseif (aura.modelcustom == true) then
		secondaryTexture:Hide()
		if (aura.modelcustom ~= nil and aura.modelcustom ~= "") then
			if (string.find(aura.modelcustompath, "%.m2")) then
				secondaryModel:SetUnit("none")
				secondaryModel:SetModel(aura.modelcustompath)
			else
				secondaryModel:SetUnit(string.lower(aura.modelcustompath))
			end
		end
	else
		secondaryModel:SetUnit("none")
		secondaryTexture:Show()
		secondaryTexture:SetTexture("Interface\\Addons\\PowerAuras\\Auras\\Aura"..aura.texture..".tga")
	end
	if (aura.randomcolor) then
		if (aura.model ~= true and aura.modelcustom ~= true) then
			if (aura.textaura ~= true) then
				if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
					secondaryTexture:SetGradientAlpha(aura.gradientstyle, r1, r2, r3, 1.0, r4, r5, r6, 1.0)
				else
					secondaryTexture:SetVertexColor(r1, r2, r3)
				end
				if (aura.desaturation == true) then
					local shaderSupported = secondaryTexture:SetDesaturated(1)
					if (shaderSupported) then
						secondaryTexture:SetDesaturated(1)
					else
						if (desaturation) then
							secondaryTexture:SetVertexColor(0.5, 0.5, 0.5)
						else
							secondaryTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					secondaryTexture:SetDesaturated(nil)
				end
			else
				secondaryTexture:SetVertexColor(r1, r2, r3)
			end
		end
	else
		if (aura.model ~= true and aura.modelcustom ~= true) then
			if (aura.textaura ~= true) then
				if (aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical") then
					secondaryTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
				else
					secondaryTexture:SetVertexColor(aura.r, aura.g, aura.b)
				end
				if (aura.desaturation == true) then
					local shaderSupported = secondaryTexture:SetDesaturated(1)
					if (shaderSupported) then
						secondaryTexture:SetDesaturated(1)
					else
						if (desaturation) then
							secondaryTexture:SetVertexColor(0.5, 0.5, 0.5)
						else
							secondaryTexture:SetVertexColor(1.0, 1.0, 1.0)
						end
					end
				else
					secondaryTexture:SetDesaturated(nil)
				end
			else
				secondaryTexture:SetVertexColor(aura.r, aura.g, aura.b)
			end
		end
	end
	if (aura.textaura ~= true) then
		if (secondaryAura.anim1 == PowaAuras.AnimationTypes.Growing) or (secondaryAura.anim1 == PowaAuras.AnimationTypes.Shrinking) or (secondaryAura.anim1 == PowaAuras.AnimationTypes.WaterDrop) or (secondaryAura.anim1 == PowaAuras.AnimationTypes.Electric) then
			secondaryTexture:SetBlendMode("BLEND")
		else
			secondaryTexture:SetBlendMode("ADD")
		end
	end
	secondaryFrame:SetFrameStrata("BACKGROUND")
	secondaryFrame:SetFrameLevel(aura.stratalevel)
	if (aura.model ~= true and aura.modelcustom ~= true) then
		secondaryTexture:SetDrawLayer("BACKGROUND", aura.texturesublevel)
	end
	if (aura.textaura ~= true and aura.model ~= true and aura.modelcustom ~= true) then
		secondaryTexture:SetRotation(math.rad(aura.rotate))
	elseif (aura.model == true or aura.modelcustom == true) then
		secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		secondaryModel:SetRotation(math.rad(aura.rotate))
		if (aura.modelanimation > - 1 and aura.modelanimation ~= nil and aura.modelanimation < 802) then
			local elapsed = 0
			secondaryModel:SetScript("OnUpdate", function(self, elaps)
				elapsed = elapsed + (elaps * 1000)
				secondaryModel:SetSequenceTime(aura.modelanimation, elapsed)
			end)
		end
	end
	if (aura.customtex == true) or (aura.wowtex == true) or (aura.owntex == true) or ((aura.customtex ~= true) and (aura.wowtex ~= true) and (aura.model ~= true) and (aura.modelcustom ~= true) and (aura.textaura ~= true) and (aura.owntex ~= true)) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = secondaryTexture:GetTexCoord()
		local x = (math.sqrt(2) - 1) / 2
		if (aura.rotate == 0) or (aura.rotate == 360) then
			secondaryTexture:SetTexCoord(ULx + x, ULy + x, LLx + x, LLy - x, URx - x, URy + x, LRx - x, LRy - x)
		elseif (aura.rotate == 90) then
			secondaryTexture:SetTexCoord(ULx - x, ULy + x, LLx + x, LLy + x, URx - x, URy - x, LRx + x, LRy - x)
		elseif (aura.rotate == 180) then
			secondaryTexture:SetTexCoord(ULx - x, ULy - x, LLx - x, LLy + x, URx + x, URy - x, LRx + x, LRy + x)
		elseif (aura.rotate == 270) then
			secondaryTexture:SetTexCoord(ULx + x, ULy - x, LLx - x, LLy - x, URx + x, URy + x, LRx - x, LRy + x)
		end
		if (aura.customtex == true) then
			if string.find(aura.customname, "%.") then
				-- Do nothing
			else
				if (aura.roundicons == true) then
					SetPortraitToTexture(texture, texture:GetTexture())
				end
			end
		end
		if (aura.owntex == true) then
			if (aura.roundicons == true) then
				SetPortraitToTexture(texture, texture:GetTexture())
			end
		end
	end
	if (aura.textaura ~= true and aura.model ~= true and aura.modelcustom ~= true) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = secondaryTexture:GetTexCoord()
		if (aura.symetrie == 1) then
			secondaryTexture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy) -- Inverse X
		elseif (aura.symetrie == 2) then
			secondaryTexture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy) -- Inverse Y
		elseif (aura.symetrie == 3) then
			secondaryTexture:SetTexCoord(LRx, LRy, URx, URy, LLx, LLy, ULx, ULy) -- Inverse XY
		else
			secondaryTexture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
		end
	end
	secondaryFrame.baseL = frame.baseL
	secondaryFrame.baseH = frame.baseH
	secondaryFrame:SetPoint("CENTER", aura.x, aura.y)
	secondaryFrame:SetWidth(secondaryFrame.baseL)
	secondaryFrame:SetHeight(secondaryFrame.baseH)
	if (aura.UseOldAnimations) then
		secondaryFrame.statut = 1
		if (aura.begin > 0) then
			secondaryFrame.beginAnim = 2
		else
			secondaryFrame.beginAnim = 0
		end
		if (not aura.begin or aura.begin == 0) then
			secondaryAura.animation = self:AnimationMainFactory(aura.anim2, secondaryAura, secondaryFrame)
		else
			secondaryFrame:SetAlpha(0.0)
		end
		secondaryFrame:Show()
	elseif (aura.textaura ~= true) then
		if (not secondaryAura.MainAnimation) then
			secondaryAura.MainAnimation = self:AddMainAnimation(secondaryAura, secondaryFrame)
		end
		if (not aura.BeginAnimation) then
			secondaryFrame:Show()
			if (secondaryAura.MainAnimation) then
				secondaryAura.MainAnimation:Play()
			end
		end
	end
	secondaryAura.Showing = true
	secondaryAura.HideRequest = false
end

function PowaAuras:DisplayAura(auraId)
	if (not (self.VariablesLoaded and self.SetupDone)) then return end
	local aura = self.Auras[auraId]
	if (aura == nil or aura.off) then return end
	self:ShowAuraForFirstTime(aura)
end

function PowaAuras:UpdateAura(aura, elapsed)
	if (aura == nil) then
		return false
	end
	if (aura.off) then
		if (aura.Showing) then
			aura:Hide()
		end
		if (aura.Timer and aura.Timer.Showing) then
			aura.Timer:Hide()
		end
		return false
	end
	if (aura.Showing) then
		local frame = aura:GetFrame()
		if (frame == nil) then
			self:ShowText("UpdateAura: Don't show, frame missing")
			return false
		end
		if (not aura.HideRequest and not aura.isSecondary and not self.ModTest and aura.TimeToHide) then
			if (GetTime() >= aura.TimeToHide) then
				self:SetAuraHideRequest(aura)
				aura.TimeToHide = nil
			end
		end
		if (aura.HideRequest) then
			if (self.ModTest == false and not aura.EndSoundPlayed) then
				if (aura.customsoundend ~= "") then
					if (aura.Debug) then
						self:Message("Playing Custom end sound ", aura.customsoundend)
					end
					local pathToSound
					if (string.find(aura.customsoundend, "\\")) then
						pathToSound = aura.customsoundend
					else
						pathToSound = PowaGlobalMisc.PathToSounds..aura.customsoundend
					end
					PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
				elseif (aura.soundend > 0) then
					if (PowaAuras.Sound[aura.soundend] ~= nil and string.len(PowaAuras.Sound[aura.soundend]) > 0) then
						if (aura.Debug) then
							self:Message("Playing end sound ", PowaAuras.Sound[aura.soundend])
						end
						if (string.find(PowaAuras.Sound[aura.soundend], "%.")) then
							PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAuras.Sound[aura.soundend], PowaMisc.SoundChannel)
						else
							PlaySound(PowaAuras.Sound[aura.soundend], PowaMisc.SoundChannel)
						end
					end
				end
				aura.EndSoundPlayed = true
			end
			if (aura.Stacks) then
				aura.Stacks:Hide()
			end
			if (aura.Debug) then
				self:Message("Hide Requested for ", aura.id)
			end
			if (aura.UseOldAnimations) then
				aura.animation = self:AnimationEndFactory(aura.finish, aura, frame)
				if (not aura.animation) then
					aura:Hide()
				end
			else
				if (not aura.EndAnimation) then
					aura:Hide()
				else
					if (aura.Debug) then
						self:Message("Stop current animations ", aura.id)
					end
					if (aura.BeginAnimation and aura.BeginAnimation:IsPlaying()) then
						aura.BeginAnimation:Stop()
					end
					if (aura.MainAnimation and aura.MainAnimation:IsPlaying()) then
						aura.MainAnimation:Stop()
					end
					if (aura.Debug) then
						self:Message("Play end animation ", aura.id)
					end
					aura.EndAnimation:Play()
				end
			end
		end
		if (aura.UseOldAnimations) then
			self:UpdateAuraAnimation(aura, elapsed, frame)
		end
		if (aura.Active and aura.Stacks and aura.Stacks.enabled) then
			if (self.ModTest) then
				if (aura.Stacks.SetStackCount) then
					aura.Stacks:SetStackCount(random(1, 12))
				else
					self:Message("aura.Stacks:SetStackCount nil!! ", aura.id)
				end
			end
			aura.Stacks:Update()
		end
	end
	aura.HideRequest = false
	return true
end

function PowaAuras:UpdateTimer(aura, timerElapsed, skipTimerUpdate)
	if (not aura.Timer or skipTimerUpdate) then
		return
	end
	if (PowaAuras.DebugCycle) then
		self:DisplayText("aura.Timer id=", aura.id)
		self:DisplayText("ShowOnAuraHide=", aura.Timer.ShowOnAuraHide)
		self:DisplayText("ForceTimeInvert=", aura.ForceTimeInvert)
		self:DisplayText("InvertTimeHides=", aura.InvertTimeHides)
		self:DisplayText("ModTest=", self.ModTest)
		self:DisplayText("aura.Active=", aura.Active)
	end
	local timerHide
	if (aura.Timer.ShowOnAuraHide and not self.ModTest and (not aura.ForceTimeInvert and not aura.InvertTimeHides) ) then
		timerHide = aura.Active
	else
		timerHide = not aura.Active
	end
	if (PowaAuras.DebugCycle) then
		self:Message("timerHide=", timerHide)
		self:Message("InactiveDueToState=", aura.InactiveDueToState)
	end
	if (timerHide or (aura.InactiveDueToState and not aura.Active) or aura.InactiveDueToMulti) then
		aura.Timer:Hide()
		if (aura.ForceTimeInvert) then
			aura.Timer:Update(timerElapsed)
		end
	else
		aura.Timer:Update(timerElapsed)
	end
end

function PowaAuras:UpdateAuraAnimation(aura, elapsed, frame)
	if (not aura.Showing) then
		return
	end
	if (not aura.animation or elapsed == 0) then
		return
	end
	if (aura.isSecondary) then
		primaryAnimation = PowaAuras.Auras[aura.id].animation
		if (primaryAnimation.IsBegin or primaryAnimation.IsEnd) then
			return
		end
	end
	local finished = aura.animation:Update(math.min(elapsed, 0.03))
	if (not finished) then
		return
	end
	if (aura.animation.IsBegin) then
		aura.animation = self:AnimationMainFactory(aura.anim1, aura, frame)
		local secondaryAura = self.SecondaryAuras[aura.id]
		if (secondaryAura) then
			local secondaryAuraFrame = self.SecondaryFrames[aura.id]
			if (secondaryAuraFrame) then
				secondaryAura.animation = self:AnimationMainFactory(aura.anim2, secondaryAura, secondaryAuraFrame)
			end
		end
		return
	end
	if (aura.animation.IsEnd) then
		aura:Hide()
	end
end