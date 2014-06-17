--[[
	   _          _           _    _       _        _              _          _      _          _        _            _        _           _        _       _       _       _      
	 _/\\___   __/\\___  ___ /\\  /\\   __/\\___  _/\\___       __/\\__  ___ /\\   _/\\___   __/\\__    /\\__      __/\\___  _/\\_      __/\\__    /\\__   /\\__  _/\\_  __/\\___  
	(_   _ _))(_     _))/   |  \\/  \\ (_  ____))(_   _  ))    (_  ____)/  //\ \\ (_   _  ))(_  ____)  /    \\    (_  ____))(_  _))    (_  ____)  /    \\ /    \\(____))(_  ____)) 
	 /  |))\\  /  _  \\ \:' |   \\   \\ /  ._))   /  |))//      /  _ \\ \:.\\_\ \\ /  |))//  /  _ \\  _\  \_//     /  ||     /  \\      /  _ \\  _\  \_//_\  \_// /  \\  /  ||     
	/:. ___// /:.(_)) \\ \  :   </   ///:. ||___ /:.    \\     /:./_\ \\ \  :.  ///:.    \\ /:./_\ \\// \:.\      /:. ||___ /:.  \\__  /:./_\ \\// \:.\ // \:.\  /:.  \\/:. ||___  
	\_ \\     \  _____//(_   ___^____))\  _____))\___|  //     \  _   //(_   ___))\___|  // \  _   //\\__  /      \  _____))\__  ____))\  _   //\\__  / \\__  /  \__  //\  _____)) 
	  \//      \//        \//           \//           \//       \// \//   \//          \//   \// \//    \\/        \//4.25.9   \//      \// \//    \\/     \\/      \//  \//       

	Power Auras Classic
	Author: Resike
	E-Mail: resike@gmail.com
	All rights reserved.
--]]

local _, ns = ...
local PowaAuras = ns.PowaAuras

local _G = _G
local format = format
local ipairs = ipairs
local math = math
local pairs = pairs
local pi = math.pi
local pihalf = pi / 2
local select = select
local string = string
local table = table
local tonumber = tonumber
local tostring = tostring
local type = type
local wipe = wipe

local C_PetBattles = C_PetBattles
local CreateFrame = CreateFrame
local GetActionInfo = GetActionInfo
local GetActionTexture = GetActionTexture
local GetCursorPosition = GetCursorPosition
local GetMacroInfo = GetMacroInfo
local GetShapeshiftFormID = GetShapeshiftFormID
local GetSpellCooldown = GetSpellCooldown
local GetSpellInfo = GetSpellInfo
local GetTime = GetTime
local HasAction = HasAction
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsMounted = IsMounted
local IsMouseButtonDown = IsMouseButtonDown
local PlaySound = PlaySound
local PlaySoundFile = PlaySoundFile
local SetPortraitToTexture = SetPortraitToTexture
local UnitInVehicle = UnitInVehicle
local UnitOnTaxi = UnitOnTaxi

local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT

-- Exposed for Saving
PowaMisc =
{
	Disabled = false,
	Debug = false,
	OnUpdateLimit = 0,
	AnimationLimit = 0,
	Version = GetAddOnMetadata("PowerAuras", "Version"),
	DefaultTimerTexture = "Original",
	DefaultStacksTexture = "Original",
	TimerRoundUp = false,
	AllowInspections = false,
	UserSetMaxTextures = PowaAuras.TextureCount,
	OverrideMaxTextures = false,
	Locked = false,
	ScaleLocked = false,
	GroupSize = 1,
	SoundChannel = "Master"
}

PowaGlobalMisc =
{
	PathToSounds = "Interface\\AddOns\\PowerAuras\\Sounds\\",
	PathToAuras = "Interface\\AddOns\\PowerAuras\\Custom\\",
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

function PowaAuras:VersionGreater(v1, v2)
	if not v2 or not v2.Major or not v2.Minor or not v2.Build then
		return true
	end
	if v1.Major > v2.Major then
		return true
	end
	if v1.Major < v2.Major then
		return false
	end
	if v1.Minor > v2.Minor then
		return true
	end
	if v1.Minor < v2.Minor then
		return false
	end
	if v1.Build > v2.Build then
		return true
	end
	if v1.Build < v2.Build then
		return false
	end
end

function PowaAuras:LoadAuras()
	self.Auras = { }
	self.AuraSequence = { }
	for k, v in pairs(PowaGlobalSet) do
		if k ~= 0 and v.is_a == nil or not v:is_a(cPowaAura) then
			self.Auras[k] = self:AuraFactory(v.bufftype, k, v)
		end
	end
	for k, v in pairs(PowaSet) do
		if k > 0 and k < 121 and not self.Auras[k] then
			if v.is_a == nil or not v:is_a(cPowaAura) then
				self.Auras[k] = self:AuraFactory(v.bufftype, k, v)
			end
		end
	end
	if self.DebugAura and self.Auras[self.DebugAura] then
		self.Auras[self.DebugAura].Debug = true
	end
	self:DiscoverLinkedAuras()
	--self.Auras[0] = cPowaAura(0, {off = true})
	if self.VersionUpgraded then
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
	if not aura or (ignoreOff and aura.off) or not aura.multiids or aura.multiids == "" or self.UsedInMultis[aura.id] then
		return
	end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		if string.sub(pword, 1, 1) == "!" then
			pword = string.sub(pword, 2)
		end
		local id = tonumber(pword)
		if id then
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
		if aura then
			aura.Timer = cPowaTimer(aura, v)
			if PowaSet[k] ~= nil and PowaSet[k].timer ~= nil then
				aura.Timer.enabled = PowaSet[k].timer
			end
			if PowaGlobalSet[k] ~= nil and PowaGlobalSet[k].timer ~= nil then
				aura.Timer.enabled = PowaGlobalSet[k].timer
			end
		end
	end
	local rescaleRatio = UIParent:GetHeight() / 768
	if not rescaleRatio or rescaleRatio == 0 then
		rescaleRatio = 1
	end
	-- Update for backwards combatiblity
	for i = 1, 360 do
		-- Manage additions
		local aura = self.Auras[i]
		local oldaura = PowaSet[i]
		if oldaura == nil then
			oldaura = PowaGlobalSet[i]
		end
		if aura and oldaura then
			if oldaura.combat == 0 then
				aura.combat = 0
			elseif oldaura.combat == 1 then
				aura.combat = true
			elseif oldaura.combat == 2 then
				aura.combat = false
			end
			if oldaura.ignoreResting == true then
				aura.isResting = true
			elseif oldaura.ignoreResting == false then
				aura.isResting = false
			end
			aura.ignoreResting = nil
			if oldaura.isinraid == true then
				aura.inRaid = true
			elseif oldaura.isinraid == false then
				aura.inRaid = 0
			end
			aura.isinraid = nil
			if oldaura.isDead == true then
				aura.isAlive = false
			elseif oldaura.isDead == false then
				aura.isAlive = true
			elseif oldaura.isDead == 0 then
				aura.isAlive = 0
			end
			aura.isDead = nil
			if string.upper(aura.blendmode) == aura.blendmode then
				aura.blendmode = string.lower(aura.blendmode)
				aura.blendmode = string.gsub(aura.blendmode, "^%l", string.upper)
			end
			if string.upper(aura.strata) == aura.strata then
				if aura.strata == "FULLSCREEN_DIALOG" then
					aura.strata = "Fullscreen_Dialog"
				else
					aura.strata = string.lower(aura.strata)
					aura.strata = string.gsub(aura.strata, "^%l", string.upper)
				end
			end
			if string.upper(aura.texturestrata) == aura.texturestrata then
				aura.texturestrata = string.lower(aura.texturestrata)
				aura.texturestrata = string.gsub(aura.texturestrata, "^%l", string.upper)
			end
			if aura.buffname == "" then
				self.Auras[i] = nil
			elseif aura.bufftype == nil then
				if oldaura.isdebuff then
					aura.bufftype = self.BuffTypes.Debuff
				elseif oldaura.isdebufftype then
					aura.bufftype = self.BuffTypes.TypeDebuff
				elseif oldaura.isenchant then
					aura.bufftype = self.BuffTypes.Enchant
				else
					aura.bufftype = self.BuffTypes.Buff
				end
			-- Update old combo style 1235 => 1/2/3/5
			elseif aura.bufftype == self.BuffTypes.Combo then
				if string.len(aura.buffname) > 1 and string.find(aura.buffname, "/", 1, true) == nil then
					local newBuffName=string.sub(aura.buffname, 1, 1)
					for i = 2, string.len(aura.buffname) do
						newBuffName = newBuffName.."/"..string.sub(aura.buffname, i, i)
					end
					aura.buffname = newBuffName
				end
			-- Update Spell Alert logic
			elseif aura.bufftype == self.BuffTypes.SpellAlert then
				if PowaSet[i] ~= nil and PowaSet[i].RoleTank == nil then
					if aura.target then
						aura.groupOrSelf = true
					elseif aura.targetfriend then
						aura.targetfriend = false
					end
				end
			end
			-- Rescale if required
			if PowaSet[i] ~= nil and PowaSet[i].RoleTank == nil and math.abs(rescaleRatio - 1.0) > 0.01 then
				if aura.Timer then
					aura.Timer.x = aura.Timer.x * rescaleRatio
					aura.Timer.y = aura.Timer.y * rescaleRatio
					aura.Timer.h = aura.Timer.h * rescaleRatio
				end
				if aura.Stacks then
					aura.Stacks.x = aura.Stacks.x * rescaleRatio
					aura.Stacks.y = aura.Stacks.y * rescaleRatio
					aura.Stacks.h = aura.Stacks.h * rescaleRatio
				end
			end
			if PowaSet[i] ~= nil then
				if aura.Timer then
					aura.Timer.x = math.floor(aura.Timer.x + 0.5)
					aura.Timer.y = math.floor(aura.Timer.y + 0.5)
					aura.Timer.h = math.floor(aura.Timer.h * 100 + 0.5) / 100
				end
				if aura.Stacks then
					aura.Stacks.x = math.floor(aura.Stacks.x + 0.5)
					aura.Stacks.y = math.floor(aura.Stacks.y + 0.5)
					aura.Stacks.h = math.floor(aura.Stacks.h * 100 + 0.5) / 100
				end
			end
			if aura.Timer and self:IsNumeric(oldaura.Timer.InvertAuraBelow) then
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
end

function PowaAuras:FindChildren(aura)
	if not aura.multiids or aura.multiids == "" then
		return
	end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		if string.sub(pword, 1, 1) == "!" then
			pword = string.sub(pword, 2)
		end
		local id = tonumber(pword)
		local dependant = self.Auras[id]
		if dependant then
			if not dependant.Children then
				dependant.Children = { }
			end
			dependant.Children[aura.id] = true
		end
	end
end

function PowaAuras:CustomTexPath(customname)
	local texpath
	if string.find(customname, ".", 1, true) then
		texpath = PowaGlobalMisc.PathToAuras..customname
	else
		local spellId = select(3, string.find(customname, "%[?(%d+)%]?"))
		if spellId then
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
	frame.texture = frame:CreateTexture(nil, "Background")
	frame.texture:SetBlendMode("Add")
	frame.texture:SetAllPoints(frame)
	frame.texture:SetTexture(aura.Timer:GetTexture())
	if updatePing then
		frame.PingAnimationGroup = frame:CreateAnimationGroup("Ping")
		self:AddJumpScaleAndReturn(frame.PingAnimationGroup, 1.1, 1.1, 0.3, 1)
		self:AddBrightenAndReturn(frame.PingAnimationGroup, 1.2, aura.alpha, 0.3, 1)
	end
end

function PowaAuras:CreateTimerFrameIfMissing(auraId, updatePing)
	local aura = self.Auras[auraId]
	if not self.Frames[auraId] and aura.Timer:IsRelative() then
		aura.Timer.Showing = false
		return
	end
	if not self.TimerFrame[auraId] then
		self.TimerFrame[auraId] = { }
		self:CreateTimerFrame(auraId, 1, updatePing)
		self:CreateTimerFrame(auraId, 2, updatePing)
	end
	self:UpdateOptionsTimer(auraId)
	return self.TimerFrame[auraId][1], self.TimerFrame[auraId][2]
end

function PowaAuras:CreateStacksFrameIfMissing(auraId, updatePing)
	local aura = self.Auras[auraId]
	if not self.Frames[auraId] and aura.Stacks:IsRelative() then
		aura.Stacks.Showing = false
		return
	end
	if not self.StacksFrames[auraId] then
		local frame = CreateFrame("Frame", nil, UIParent)
		self.StacksFrames[auraId] = frame
		frame:SetFrameStrata(aura.strata)
		frame:Hide()
		frame.texture = frame:CreateTexture(nil, "Background")
		frame.texture:SetBlendMode("Add")
		frame.texture:SetAllPoints(frame)
		frame.texture:SetTexture(aura.Stacks:GetTexture())
		frame.textures = {[1] = frame.texture}
		if updatePing then
			frame.PingAnimationGroup = frame:CreateAnimationGroup("Ping")
			self:AddJumpScaleAndReturn(frame.PingAnimationGroup, 1.1, 1.1, 0.3, 1)
			self:AddBrightenAndReturn(frame.PingAnimationGroup, 1.2, aura.alpha, 0.3, 1)
		end
	end
	self:UpdateOptionsStacks(auraId)
	return self.StacksFrames[auraId]
end

function PowaAuras:UpdateOptionsTimer(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local timer = self.Auras[auraId].Timer
	local frame1 = self.TimerFrame[auraId][1]
	frame1:SetAlpha(math.min(timer.a, 0.99))
	frame1:SetWidth(20 * timer.h)
	frame1:SetHeight(20 * timer.h)
	if timer:IsRelative() then
		frame1:SetPoint(self.RelativeToParent[timer.Relative], self.Frames[auraId], timer.Relative, timer.x, timer.y)
	else
		frame1:SetPoint("Center", timer.x, timer.y)
	end
	local frame2 = self.TimerFrame[auraId][2]
	frame2:SetAlpha(timer.a * 0.75)
	frame2:SetWidth(14 * timer.h)
	frame2:SetHeight(14 * timer.h)
	frame2:SetPoint("Left", frame1, "Right", 1, - 1.5)
end

function PowaAuras:UpdateOptionsStacks(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local stacks = self.Auras[auraId].Stacks
	local frame = self.StacksFrames[auraId]
	frame:SetAlpha(math.min(stacks.a, 0.99))
	frame:SetWidth(20 * stacks.h)
	frame:SetHeight(20 * stacks.h)
	if stacks:IsRelative() then
		frame:SetPoint(self.RelativeToParent[stacks.Relative], self.Frames[auraId], stacks.Relative, stacks.x, stacks.y)
	else
		frame:SetPoint("Center", stacks.x, stacks.y)
	end
end

function PowaAuras:CreateEffectLists()
	for k in pairs(self.AurasByType) do
		wipe(self.AurasByType[k])
	end
	self.Events = self:CopyTable(self.AlwaysEvents)
	for id, aura in pairs(self.Auras) do
		if not aura.off or self.UsedInMultis[id] then
			aura:AddEffectAndEvents()
		end
	end
	if PowaMisc.Debug then
		for k in pairs(self.AurasByType) do
			self:DisplayText(k..": "..#self.AurasByType[k])
		end
	end
end

function PowaAuras:InitialiseAllAuras()
	for _, aura in pairs(self.Auras) do
		aura:Init()
	end
	self:RedisplayAuras()
end

function PowaAuras:RedisplayAuras()
	for id, aura in pairs(self.Auras) do
		aura.Active = false
		if aura.Showing then
			aura:Hide()
			if aura.Timer then
				aura.Timer:Hide()
			end
			if aura.Stacks then
				aura.Stacks:Hide()
			end
			aura.Active = true
			aura:CreateFrames()
			self.SecondaryAuras[aura.id] = nil
			self:DisplayAura(aura.id)
		end
	end
end

function PowaAuras:MemorizeActions(actionIndex)
	local imin, imax
	if #self.AurasByType.Actions == 0 then
		return
	end
	-- Scan every changed slots
	if not actionIndex then
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
		if HasAction(i) then
			local type, id, subType, spellID = GetActionInfo(i)
			local name, text
			if type == "macro" then
				name = GetMacroInfo(id)
			end
			if PowaAction_Tooltip then
				PowaAction_Tooltip:SetOwner(UIParent, "Anchor_None")
				PowaAction_Tooltip:SetAction(i)
				text = PowaAction_TooltipTextLeft1:GetText()
				PowaAction_Tooltip:Hide()
			end
			if text then
				for k, v in pairs(self.AurasByType.Actions) do
					local actionAura = self.Auras[v]
					if not actionAura then
						self.AurasByType.Actions[k] = nil -- Aura deleted
					elseif not actionAura.slot then
						if self:MatchString(name, actionAura.buffname, actionAura.ignoremaj) or self:MatchString(text, actionAura.buffname, actionAura.ignoremaj) then
							actionAura.slot = i -- Remember the slot
							-- Remember the texture
							local tempicon
							if actionAura.owntex then
								PowaIconTexture:SetTexture(GetActionTexture(i))
								tempicon = PowaIconTexture:GetTexture()
								if actionAura.icon ~= tempicon then
									actionAura.icon = tempicon
								end
							elseif actionAura.icon == "" then
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
	if not aura or not aura.Children then
		return
	end
	for id in pairs(aura.Children) do
		if not self.Cascade[id] and id ~= originalId then
			self.Cascade[id] = true
			self:AddChildrenToCascade(self.Auras[id], originalId or aura.id)
		end
	end
end

-- Runtime
function PowaAuras:OnUpdate(elapsed)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	self.ChecksTimer = self.ChecksTimer + elapsed
	self.TimerUpdateThrottleTimer = self.TimerUpdateThrottleTimer + elapsed
	self.ThrottleTimer = self.ThrottleTimer + elapsed
	self.InGCD = nil
	if self.GCDSpellName then
		local gcdStart = GetSpellCooldown(self.GCDSpellName)
		if gcdStart then
			self.InGCD = gcdStart > 0
		end
	end
	local checkAura = false
	if PowaMisc.OnUpdateLimit == 0 or self.ThrottleTimer >= PowaMisc.OnUpdateLimit then
		checkAura = true
		self.ThrottleTimer = 0
	end
	if not self.ModTest and checkAura then
		if self.ChecksTimer > (self.NextCheck + PowaMisc.OnUpdateLimit) then
			self.ChecksTimer = 0
			local isMounted = IsMounted() == 1 and true or self:IsDruidTravelForm()
			if isMounted ~= self.WeAreMounted then
				self.DoCheck.All = true
				self.WeAreMounted = isMounted
			end
			local isInVehicle = UnitInVehicle("player") ~= nil
			if isInVehicle ~= self.WeAreInVehicle then
				self.DoCheck.All = true
				self.WeAreInVehicle = isInVehicle
			end
			local isInPetBattle = C_PetBattles.IsInBattle()
			if isInPetBattle ~= self.WeAreInPetBattle then
				self.DoCheck.All = true
				self.WeAreInPetBattle = isInPetBattle
			end
		end
		if self.PendingRescan and GetTime() >= self.PendingRescan then
			self:InitialiseAllAuras()
			self:MemorizeActions()
			self.DoCheck.All = true
			self.PendingRescan = nil
		end
		for id, cd in pairs(self.Pending) do
			if cd and cd > 0 then
				if GetTime() >= cd then
					self.Pending[id] = nil
					if self.Auras[id] then
						self.Auras[id].CooldownOver = true
						self:TestThisEffect(id)
						self.Auras[id].CooldownOver = nil
					end
				end
			else
				self.Pending[id] = nil
			end
		end
		if self.DoCheck.CheckIt or self.DoCheck.All then
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
	if PowaMisc.AnimationLimit > 0 and self.TimerUpdateThrottleTimer < PowaMisc.AnimationLimit then
		skipTimerUpdate = true
	else
		timerElapsed = self.TimerUpdateThrottleTimer
		self.TimerUpdateThrottleTimer = 0
	end
	if PowaMisc.AllowInspections then
		if self.NextInspectUnit then
			if GetTime() > self.NextInspectTimeOut then
				self:SetRoleUndefined(self.NextInspectUnit)
				self.NextInspectUnit = nil
				self.InspectAgain = GetTime() + self.InspectDelay
			end
		elseif not self.InspectsDone and self.InspectAgain and not UnitOnTaxi("player") and GetTime() > self.InspectAgain then
			self:TryInspectNext()
			self.InspectAgain = GetTime() + self.InspectDelay
		end
	end
	for i = 1, #self.AuraSequence do
		local aura = self.AuraSequence[i]
		if aura.Showing or (aura.Timer and aura.Timer.enabled) or aura.InvertAuraBelow > 0 then
			if self:UpdateAura(aura, elapsed) then
				self:UpdateTimer(aura, timerElapsed, skipTimerUpdate)
			end
		end
	end
	for _, aura in pairs(self.SecondaryAuras) do
		if aura.Showing then
			self:UpdateAura(aura, elapsed)
		end
	end
	self.ResetTargetTimers = false
end

function PowaAuras:IsDruidTravelForm()
	if self.playerclass ~= "DRUID" then
		return false
	end
	local id = GetShapeshiftFormID()
	if id == 3 or id == 27 or id == 29 then
		return true
	end
	return false
end

function PowaAuras:NewCheckBuffs()
	for i = 1, #self.AurasByTypeList do
		local auraType = self.AurasByTypeList[i]
		if (self.DoCheck[auraType] or self.DoCheck.All) and #self.AurasByType[auraType] > 0 then
			for j = 1, #self.AurasByType[auraType] do
				local v = self.AurasByType[auraType][j]
				if self.Auras[v] and self.Auras[v].Debug then
					self:DisplayText("TestThisEffect ", v)
				end
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
	if not aura then
		return false, self.Text.nomReasonAuraMissing
	end
	if aura.off then
		if aura.Showing then
			aura:Hide()
		end
		if not giveReason then
			return false
		end
		return false, self.Text.nomReasonAuraOff
	end
	local debugEffectTest = self.DebugCycle or aura.Debug
	if debugEffectTest then
		self:Message("Test Aura for Hide or Show = ", auraId)
		self:Message("Active = ", aura.Active)
		self:Message("Showing = ", aura.Showing)
		self:Message("HideRequest = ", aura.HideRequest)
	end
	-- Prevent crash if class not set-up properly
	if not aura.ShouldShow then
		self:Message("ShouldShow nil! id = ", auraId)
		if not giveReason then
			return false
		end
		return false, self.Text.nomReasonAuraBad
	end
	aura.InactiveDueToMulti = nil
	local shouldShow, reason = aura:ShouldShow(giveReason or debugEffectTest)
	if shouldShow == - 1 then
		if debugEffectTest then
			self:Message("TestThisEffect unchanged")
		end
		return aura.Active, reason
	end
	if shouldShow then
		shouldShow, reason = self:CheckMultiple(aura, reason, giveReason or debugEffectTest)
		if not shouldShow then
			aura.InactiveDueToMulti = true
		end
	elseif aura.Timer and aura.CanHaveTimerOnInverse then
		local multiShouldShow = self:CheckMultiple(aura, reason, giveReason or debugEffectTest)
		if not multiShouldShow then
			aura.InactiveDueToMulti = true
		end
	end
	if debugEffectTest then
		self:Message("shouldShow = ", shouldShow, " because ", reason)
	end
	if shouldShow then
		if not aura.Active then
			if debugEffectTest then
				self:Message("ShowAura ", aura.buffname, " (", auraId, ")", reason)
			end
			self:DisplayAura(auraId)
			if not ignoreCascade then
				self:AddChildrenToCascade(aura)
			end
			aura.Active = true
		end
	else
		local secondaryAura = self.SecondaryAuras[aura.id]
		if aura.Showing then
			if debugEffectTest then
				self:Message("HideAura ", aura.buffname, " (", auraId, ")", reason)
			end
			self:SetAuraHideRequest(aura, secondaryAura)
		end
		if aura.Active then
			if not ignoreCascade then
				self:AddChildrenToCascade(aura)
			end
			aura.Active = false
			if secondaryAura then
				secondaryAura.Active = false
			end
		end
	end
	return shouldShow, reason
end

function PowaAuras:CheckMultiple(aura, reason, giveReason)
	if not aura.multiids or aura.multiids == "" then
		if not giveReason then
			return true
		end
		return true, reason
	end
	if string.find(aura.multiids, "[^0-9/!]") then
		if not giveReason then
			return true
		end
		return true, reason
	end
	for pword in string.gmatch(aura.multiids, "[^/]+") do
		local reverse
		if string.sub(pword, 1, 1) == "!" then
			pword = string.sub(pword, 2)
			reverse = true
		end
		local k = tonumber(pword)
		local linkedAura = self.Auras[k]
		local state
		if linkedAura then
			local result, reason = linkedAura:ShouldShow(giveReason, reverse)
			if not result or (result == - 1 and not linkedAura.Showing and not linkedAura.HideRequest) then
				if not giveReason then
					return false
				end
				return result, reason
			end
		end
	end
	if not giveReason then
		return true
	end
	return true, self:InsertText(self.Text.nomReasonMulti, aura.multiids)
end

function PowaAuras:SetAuraHideRequest(aura, secondaryAura)
	if aura.Debug then
		self:Message("SetAuraHideRequest ", aura.buffname)
	end
	aura.HideRequest = true
	if not aura.InvertTimeHides then
		aura.ForceTimeInvert = nil
	end
	if secondaryAura and secondaryAura.Active then
		secondaryAura.HideRequest = true
	end
end

-- Drag and Drop functions
local function OnKeyUp(frame, key)
	-- Case Sensitive!
	if key ~= "UP" and key ~= "DOWN" and key ~= "LEFT" and key ~= "RIGHT" and key ~= "ENTER" and key ~= "ESCAPE" or not frame.mouseIsOver then
		return
	end
	if key == "ENTER" or key == "ESCAPE" then
		frame.mouseIsOver = nil
		frame:EnableKeyboard(false)
		frame:EnableMouseWheel(false)
		frame:SetScript("OnKeyUp", nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnDragStop", nil)
		frame:SetScript("OnMouseDown", nil)
		frame:SetScript("OnMouseUp", nil)
		frame:SetScript("OnMouseWheel", nil)
		return
	end
	if key == "UP" then
		frame.aura.y = frame.aura.y + 1
	elseif key == "DOWN" then
		frame.aura.y = frame.aura.y - 1
	elseif key == "LEFT" then
		frame.aura.x = frame.aura.x - 1
	elseif key == "RIGHT" then
		frame.aura.x = frame.aura.x + 1
	end
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if secondaryAura then
		secondaryAura.HideRequest = true
	end
	frame:ClearAllPoints()
	frame:SetPoint("Center", frame.aura.x, frame.aura.y)
	if PowaAuras.CurrentAuraId == frame.aura.id and PowaBarConfigFrame:IsVisible() then
		PowaBarAuraCoordXSlider:SetValue(format("%.0f", frame.aura.x))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordXSlider, PowaBarAuraCoordXSliderEditBox, 700, 700, 0)
		PowaBarAuraCoordYSlider:SetValue(format("%.0f", frame.aura.y))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordYSlider, PowaBarAuraCoordYSliderEditBox, 400, 400, 0)
	end
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if secondaryAura then
		PowaAuras:RedisplaySecondaryAura(frame.aura.id)
	end
end

local function OnDragStop(frame)
	if not frame or not frame.isMoving then
		return
	end
	frame.isMoving = false
	frame:StopMovingOrSizing()
	frame.aura.x = math.floor(frame:GetLeft() + (frame:GetWidth() - UIParent:GetWidth()) / 2 + 0.5)
	frame.aura.y = math.floor(frame:GetTop() - (frame:GetHeight() + UIParent:GetHeight()) / 2 + 0.5)
	frame:ClearAllPoints()
	frame:SetPoint("Center", frame.aura.x, frame.aura.y)
	if PowaAuras.CurrentAuraId == frame.aura.id and PowaBarConfigFrame:IsVisible() then
		PowaBarAuraCoordXSlider:SetValue(format("%.0f", frame.aura.x))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordXSlider, PowaBarAuraCoordXSliderEditBox, 700, 700, 0)
		PowaBarAuraCoordYSlider:SetValue(format("%.0f", frame.aura.y))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordYSlider, PowaBarAuraCoordYSliderEditBox, 400, 400, 0)
	end
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if secondaryAura then
		PowaAuras:RedisplaySecondaryAura(frame.aura.id)
	end
end

local function OnDragStart(frame)
	if frame.isMoving then
		return
	end
	if PowaAuras.CurrentAuraId ~= frame.aura.id then
		OnDragStop(PowaAuras.Frames[frame.aura.id])
		local i = frame.aura.id - (PowaAuras.CurrentAuraPage - 1) * 24
		local icon
		if i > 0 and i < 25 then
			icon = _G["PowaIcone"..i]
		end
		PowaAuras:SetCurrent(icon, frame.aura.id)
		PowaMisc.GroupSize = 1
		PowaAuras:InitPage(frame.aura)
	end
	frame.isMoving = true
	frame:StartMoving()
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if secondaryAura then
		secondaryAura.HideRequest = true
	end
end

local function LeftButtonOnUpdate(frame, elapsed)
	frame.aura.x = math.floor(frame:GetLeft() + (frame:GetWidth() - UIParent:GetWidth()) / 2 + 0.5)
	frame.aura.y = math.floor(frame:GetTop() - (frame:GetHeight() + UIParent:GetHeight()) / 2 + 0.5)
	if PowaAuras.CurrentAuraId == frame.aura.id and PowaBarConfigFrame:IsVisible() then
		PowaBarAuraCoordXSlider:SetValue(format("%.0f", frame.aura.x))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordXSlider, PowaBarAuraCoordXSliderEditBox, 700, 700, 0)
		PowaBarAuraCoordYSlider:SetValue(format("%.0f", frame.aura.y))
		PowaAurasOptions.SliderEditBoxSetValues(PowaBarAuraCoordYSlider, PowaBarAuraCoordYSliderEditBox, 400, 400, 0)
	end
end

local function RightButtonOnUpdate(frame, elapsed)
	if not IsMouseButtonDown("RightButton") then
		return
	end
	local aura = PowaAuras.Auras[frame.aura.id]
	if not aura.model and not aura.modelcustom then
		return
	end
	local model = PowaAuras.Models[frame.aura.id]
	local x, y = GetCursorPosition()
	if IsControlKeyDown() then
		local px, py, pz = model:GetPosition()
		aura.mz = format("%.2f", (px + (y - frame.y) / 64))
		if format("%.2f", px) ~= aura.mz then
			model:SetPosition(aura.mz, py, pz)
			local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
			if secondaryAura then
				local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
				secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
			end
			if PowaBarConfigFrame:IsVisible() then
				PowaModelPositionZSlider:SetValue(aura.mz * 100)
				PowaAurasOptions.SliderEditBoxSetValues(PowaModelPositionZSlider, PowaModelPositionZSliderEditBox, 100, 100, 0)
			end
		end
	elseif IsAltKeyDown() then
		local px, py, pz = model:GetPosition()
		aura.mx = format("%.2f", (py + (x - frame.x) / 64))
		aura.my = format("%.2f", (pz + (y - frame.y) / 64))
		if format("%.2f", py) ~= aura.mx or format("%.2f", pz) ~= aura.my then
			model:SetPosition(px, aura.mx, aura.my)
			local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
			if secondaryAura then
				local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
				secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
			end
			if PowaBarConfigFrame:IsVisible() then
				PowaModelPositionXSlider:SetValue(aura.mx * 100)
				PowaAurasOptions.SliderEditBoxSetValues(PowaModelPositionXSlider, PowaModelPositionXSliderEditBox, 50, 50, 0)
				PowaModelPositionYSlider:SetValue(aura.my * 100)
				PowaAurasOptions.SliderEditBoxSetValues(PowaModelPositionYSlider, PowaModelPositionYSliderEditBox, 50, 50, 0)
			end
		end
	else
		if not model.distance or not model.yaw or not model.pitch then
			return
		end
		local pitch = model.pitch + (y - frame.y) * pi / 256
		local limit = false
		if pitch > pihalf - 0.05 or pitch < - pihalf + 0.05 then
			limit = true
		end
		if limit then
			aura.rotate = format("%.0f", math.abs(math.deg(((x - frame.x) / 64 + model:GetFacing())) % 360))
			if aura.rotate ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
				model:SetRotation(math.rad(aura.rotate))
				local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
				if secondaryAura then
					local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
					secondaryModel:SetRotation(math.rad(aura.rotate))
				end
				PowaBarAuraRotateSlider:SetValue(aura.rotate)
				PowaBarAuraRotateSliderEditBox:SetText(format("%.0f", PowaBarAuraRotateSlider:GetValue()).."°")
			end
		else
			local yaw = model.yaw + (x - frame.x) * pi / 256
			PowaAuras:SetOrientation(aura, model, model.distance, yaw, pitch)
			local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
			if secondaryAura then
				local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
				PowaAuras:SetOrientation(secondaryAura, secondaryModel, model.distance, yaw, pitch)
			end
		end
	end
	frame.x, frame.y = x, y
end

local function MiddleButtonOnUpdate(frame, elapsed)
	if not IsMouseButtonDown("MiddleButton") then
		return
	end
	local aura = PowaAuras.Auras[frame.aura.id]
	if not aura.model and not aura.modelcustom then
		return
	end
	local model = PowaAuras.Models[frame.aura.id]
	local x, y = GetCursorPosition()
	aura.rotate = format("%.0f", math.abs(math.deg(((x - frame.x) / 84 + model:GetFacing())) % 360))
	if aura.rotate ~= format("%.0f", math.abs(math.deg(model:GetFacing()) % 360)) then
		model:SetRotation(math.rad(aura.rotate))
		local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
		if secondaryAura then
			local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
			secondaryModel:SetRotation(math.rad(aura.rotate))
		end
		if PowaBarConfigFrame:IsVisible() then
			PowaBarAuraRotateSlider:SetValue(aura.rotate)
			PowaBarAuraRotateSliderEditBox:SetText(format("%.0f", PowaBarAuraRotateSlider:GetValue()).."°")
		end
	end
	frame.x, frame.y = x, y
end

local function OnMouseDown(frame, button)
	if button == "LeftButton" then
		OnDragStart(frame)
		frame.x, frame.y = GetCursorPosition()
		frame:SetScript("OnUpdate", LeftButtonOnUpdate)
	elseif button == "RightButton" then
		frame.x, frame.y = GetCursorPosition()
		frame:SetScript("OnUpdate", RightButtonOnUpdate)
	elseif button == "MiddleButton" then
		if IsAltKeyDown() then
			local aura = PowaAuras.Auras[frame.aura.id]
			PowaAuras:ResetModel(aura)
		else
			frame.x, frame.y = GetCursorPosition()
			frame:SetScript("OnUpdate", MiddleButtonOnUpdate)
		end
	end
end

local function OnMouseUp(frame, button)
	if button == "LeftButton" then
		OnDragStop(frame)
		frame:SetScript("OnUpdate", nil)
	elseif button == "RightButton" then
		frame:SetScript("OnUpdate", nil)
	elseif button == "MiddleButton" then
		frame:SetScript("OnUpdate", nil)
	end
end

local function OnMouseWheel(frame, delta)
	local aura = PowaAuras.Auras[frame.aura.id]
	if not aura.model and not aura.modelcustom then
		return
	end
	local model = PowaAuras.Models[frame.aura.id]
	if not model.distance or not model.yaw or not model.pitch then
		return
	end
	local zoom = 0.15
	if IsControlKeyDown() then
		zoom = 0.01
	elseif IsAltKeyDown() then
		zoom = 0.5
	end
	local distance = model.distance - delta * zoom
	if distance > 40 then
		distance = 40
	elseif distance < zoom then
		distance = zoom
	end
	PowaAuras:SetOrientation(aura, model, distance, model.yaw, model.pitch)
	local secondaryAura = PowaAuras.SecondaryAuras[frame.aura.id]
	if secondaryAura then
		local secondaryModel = PowaAuras.SecondaryModels[frame.aura.id]
		PowaAuras:SetOrientation(secondaryAura, secondaryModel, distance, model.yaw, model.pitch)
	end
end

local function OnEnter(frame)
	frame.mouseIsOver = true
	frame:EnableKeyboard(true)
	frame:EnableMouseWheel(true)
	frame:SetScript("OnKeyUp", OnKeyUp)
	frame:SetScript("OnDragStart", OnDragStart)
	frame:SetScript("OnDragStop", OnDragStop)
	frame:SetScript("OnMouseDown", OnMouseDown)
	frame:SetScript("OnMouseUp", OnMouseUp)
	frame:SetScript("OnMouseWheel", OnMouseWheel)
end

local function OnLeave(frame)
	frame.mouseIsOver = nil
	OnDragStop(frame)
	frame:EnableKeyboard(false)
	frame:EnableMouseWheel(false)
	frame:SetScript("OnKeyUp", nil)
	frame:SetScript("OnDragStart", nil)
	frame:SetScript("OnDragStop", nil)
	frame:SetScript("OnMouseDown", nil)
	frame:SetScript("OnMouseUp", nil)
	frame:SetScript("OnMouseWheel", nil)
end

function PowaAuras:SetForDragging(aura, frame)
	if not frame or not aura or frame.SetForDragging then
		return
	end
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(false)
	frame:RegisterForDrag("LeftButton")
	frame:SetBackdrop(self.Backdrop)
	frame:SetBackdropColor(0, 0.6, 0, 1)
	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame.SetForDragging = true
end

function PowaAuras:ResetDragging(aura, frame)
	if not frame or not aura or not frame.SetForDragging then
		return
	end
	frame:SetMovable(false)
	frame:EnableMouse(false)
	frame:EnableKeyboard(false)
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

function PowaAuras:ResetModel(aura)
	local model = self.Models[aura.id]
	model:ClearModel()
	if aura.model then
		if not aura.modelpath or aura.modelpath == "" then
			if not aura.modelcategory or aura.modelcategory == 1 then
				model:SetModel(self.ModelsCreature[aura.texture])
			elseif aura.modelcategory == 2 then
				model:SetModel(self.ModelsEnvironments[aura.texture])
			elseif aura.modelcategory == 3 then
				model:SetModel(self.ModelsInterface[aura.texture])
			elseif aura.modelcategory == 4 then
				model:SetModel(self.ModelsSpells[aura.texture])
			end
		else
			if tonumber(aura.modelpath) then
				model:SetDisplayInfo(aura.modelpath)
			else
				model:SetModel(aura.modelpath)
			end
		end
	elseif aura.modelcustom then
		if string.find(aura.modelcustompath, "%.m2") then
			model:SetModel(aura.modelcustompath)
		else
			model:SetUnit(string.lower(aura.modelcustompath))
		end
	end
	aura.rotate = 0
	model:SetRotation(math.rad(aura.rotate))
	if PowaBarConfigFrame:IsVisible() then
		PowaBarAuraRotateSlider:SetValue(aura.rotate)
		PowaBarAuraRotateSliderEditBox:SetText(format("%.0f", PowaBarAuraRotateSlider:GetValue()).."°")
	end
	aura.mz = 0
	aura.mx = 0
	aura.my = 0
	model:SetPosition(aura.mz, aura.mx, aura.my)
	model:RefreshCamera()
	model:SetCustomCamera(1)
	if PowaBarConfigFrame:IsVisible() then
		PowaModelPositionZSlider:SetMinMaxValues(format("%.0f", (aura.mz * 100) - 10000), format("%.0f", (aura.mz * 100) + 10000))
		PowaModelPositionZSliderLow:SetText(format("%.0f", (aura.mz * 100) - 100))
		PowaModelPositionZSliderHigh:SetText(format("%.0f", (aura.mz * 100) + 100))
		PowaModelPositionZSlider:SetValue(aura.mz * 100)
		PowaModelPositionZSlider:SetMinMaxValues(format("%.0f", (aura.mz * 100) - 100), format("%.0f", (aura.mz * 100) + 100))
		self.SliderEditBoxSetValues(PowaModelPositionZSlider, PowaModelPositionZSliderEditBox, 100, 100, 0)
		PowaModelPositionXSlider:SetMinMaxValues(format("%.0f", (aura.mx * 100) - 10000), format("%.0f", (aura.mx * 100) + 10000))
		PowaModelPositionXSliderLow:SetText(format("%.0f", (aura.mx * 100) - 50))
		PowaModelPositionXSliderHigh:SetText(format("%.0f", (aura.mx * 100) + 50))
		PowaModelPositionXSlider:SetValue(aura.mx * 100)
		PowaModelPositionXSlider:SetMinMaxValues(format("%.0f", (aura.mx * 100) - 50), format("%.0f", (aura.mx * 100) + 50))
		self.SliderEditBoxSetValues(PowaModelPositionXSlider, PowaModelPositionXSliderEditBox, 50, 50, 0)
		PowaModelPositionYSlider:SetMinMaxValues(format("%.0f", (aura.my * 100) - 10000), format("%.0f", (aura.my * 100) + 10000))
		PowaModelPositionYSliderLow:SetText(format("%.0f", (aura.my * 100) - 50))
		PowaModelPositionYSliderHigh:SetText(format("%.0f", (aura.my * 100) + 50))
		PowaModelPositionYSlider:SetValue(aura.my * 100)
		PowaModelPositionYSlider:SetMinMaxValues(format("%.0f", (aura.my * 100) - 50), format("%.0f", (aura.my * 100) + 50))
		self.SliderEditBoxSetValues(PowaModelPositionYSlider, PowaModelPositionYSliderEditBox, 50, 50, 0)
	end
	if model:HasCustomCamera() then
		local x, y, z = model:GetCameraPosition()
		local tx, ty, tz = model:GetCameraTarget()
		model:SetCameraTarget(0, ty, tz)
		aura.mcd = math.sqrt(x * x + y * y + z * z)
		aura.mcy = - math.atan(y / x)
		aura.mcp = - math.atan(z / x)
		self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
	end
	local secondaryAura = self.SecondaryAuras[aura.id]
	if secondaryAura then
		local secondaryModel = self.SecondaryModels[aura.id]
		secondaryModel:ClearModel()
		if aura.model then
			if not aura.modelpath or aura.modelpath == "" then
				if not aura.modelcategory or aura.modelcategory == 1 then
					secondaryModel:SetModel(self.ModelsCreature[aura.texture])
				elseif aura.modelcategory == 2 then
					secondaryModel:SetModel(self.ModelsEnvironments[aura.texture])
				elseif aura.modelcategory == 3 then
					secondaryModel:SetModel(self.ModelsInterface[aura.texture])
				elseif aura.modelcategory == 4 then
					secondaryModel:SetModel(self.ModelsSpells[aura.texture])
				end
			else
				if tonumber(aura.modelpath) then
					secondaryModel:SetDisplayInfo(aura.modelpath)
				else
					secondaryModel:SetModel(aura.modelpath)
				end
			end
		elseif aura.modelcustom then
			if string.find(aura.modelcustompath, "%.m2") then
				secondaryModel:SetModel(aura.modelcustompath)
			else
				secondaryModel:SetUnit(string.lower(aura.modelcustompath))
			end
		end
		secondaryModel:SetRotation(math.rad(aura.rotate))
		secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		secondaryModel:RefreshCamera()
		secondaryModel:SetCustomCamera(1)
		if secondaryModel:HasCustomCamera() then
			local x, y, z = model:GetCameraPosition()
			local tx, ty, tz = secondaryModel:GetCameraTarget()
			secondaryModel:SetCameraTarget(0, ty, tz)
			self:SetOrientation(secondaryAura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
		end
	end
end

function PowaAuras:Reset(aura)
	local model = self.Models[aura.id]
	model:ClearModel()
	if aura.model then
		if tonumber(aura.modelpath) then
			model:SetDisplayInfo(aura.modelpath)
		else
			if not aura.modelcategory or aura.modelcategory == 1 then
				model:SetModel(self.ModelsCreature[aura.texture])
			elseif aura.modelcategory == 2 then
				model:SetModel(self.ModelsEnvironments[aura.texture])
			elseif aura.modelcategory == 3 then
				model:SetModel(self.ModelsInterface[aura.texture])
			elseif aura.modelcategory == 4 then
				model:SetModel(self.ModelsSpells[aura.texture])
			end
		end
	end
	model:SetCustomCamera(1)
	if model:HasCustomCamera() then
		local x, y, z = self:GetBaseCameraTarget(model)
		if y and z then
			model:SetCameraTarget(0, y, z)
		end
		self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
	end
end

function PowaAuras:ResetSecondary(aura)
	local secondaryModel = self.SecondaryModels[aura.id]
	secondaryModel:ClearModel()
	if tonumber(aura.modelpath) then
		secondaryModel:SetDisplayInfo(aura.modelpath)
	else
		if not aura.modelcategory or aura.modelcategory == 1 then
			secondaryModel:SetModel(self.ModelsCreature[aura.texture])
		elseif aura.modelcategory == 2 then
			secondaryModel:SetModel(self.ModelsEnvironments[aura.texture])
		elseif aura.modelcategory == 3 then
			secondaryModel:SetModel(self.ModelsInterface[aura.texture])
		elseif aura.modelcategory == 4 then
			secondaryModel:SetModel(self.ModelsSpells[aura.texture])
		end
	end
	secondaryModel:SetCustomCamera(1)
	if secondaryModel:HasCustomCamera() then
		local x, y, z = self:GetBaseCameraTarget(secondaryModel)
		if y and z then
			secondaryModel:SetCameraTarget(0, y, z)
		end
		self:SetOrientation(aura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
	end
end

function PowaAuras:ResetUnit(aura)
	local model = self.Models[aura.id]
	model:ClearModel()
	if aura.modelcustom then
		if not string.find(aura.modelcustompath, "%.m2") then
			model:SetUnit(string.lower(aura.modelcustompath))
		end
	end
	model:SetCustomCamera(1)
	if model:HasCustomCamera() then
		local x, y, z = self:GetBaseCameraTarget(model)
		if y and z then
			model:SetCameraTarget(0, y, z)
		end
		self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
	end
end

function PowaAuras:ResetSecondaryUnit(aura)
	local secondaryModel = self.SecondaryModels[aura.id]
	secondaryModel:ClearModel()
	if aura.modelcustom then
		if not string.find(aura.modelcustompath, "%.m2") then
			secondaryModel:SetUnit(string.lower(aura.modelcustompath))
		end
	end
	secondaryModel:SetCustomCamera(1)
	if secondaryModel:HasCustomCamera() then
		local x, y, z = self:GetBaseCameraTarget(secondaryModel)
		if y and z then
			secondaryModel:SetCameraTarget(0, y, z)
		end
		self:SetOrientation(aura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
	end
end

function PowaAuras:GetBaseCameraTarget(model)
	local modelfile = model:GetModel()
	if modelfile and modelfile ~= "" then
		local tempmodel = CreateFrame("PlayerModel", nil, UIParent)
		tempmodel:SetModel(modelfile)
		tempmodel:SetCustomCamera(1)
		local x, y, z = tempmodel:GetCameraTarget()
		tempmodel:ClearModel()
		return x, y, z
	end
end

function PowaAuras:UpdatePreviewColor(aura)
	if not aura then
		return
	end
	if AuraTexture then
		if AuraTexture:GetTexture() ~= "Interface\\CharacterFrame\\TempPortrait" and AuraTexture:GetTexture() ~= "Interface\\Icons\\Inv_Misc_QuestionMark" and AuraTexture:GetTexture() ~= "Interface\\Icons\\INV_Scroll_02" and AuraTexture:GetTexture() ~= "Interface\\Icons\\TEMP" then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				AuraTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
			else
				AuraTexture:SetVertexColor(aura.r, aura.g, aura.b)
			end
			if aura.desaturation then
				local shaderSupported = AuraTexture:SetDesaturated(1)
				if shaderSupported then
					AuraTexture:SetDesaturated(1)
				else
					AuraTexture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				AuraTexture:SetDesaturated(nil)
			end
		else
			AuraTexture:SetVertexColor(1, 1, 1)
		end
	end
end

function PowaAuras:UpdatePreviewRandomColor(aura)
	if not aura then
		return
	end
	if AuraTexture then
		if AuraTexture:GetTexture() ~= "Interface\\CharacterFrame\\TempPortrait" and AuraTexture:GetTexture() ~= "Interface\\Icons\\Inv_Misc_QuestionMark" and AuraTexture:GetTexture() ~= "Interface\\Icons\\INV_Scroll_02" and AuraTexture:GetTexture() ~= "Interface\\Icons\\TEMP" then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				AuraTexture:SetGradientAlpha(aura.gradientstyle, aura.r1, aura.r2, aura.r3, 1.0, aura.r4, aura.r5, aura.r6, 1.0)
			else
				AuraTexture:SetVertexColor(aura.r1, aura.r2, aura.r3)
			end
			if aura.desaturation then
				local shaderSupported = AuraTexture:SetDesaturated(1)
				if shaderSupported then
					AuraTexture:SetDesaturated(1)
				else
					AuraTexture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				AuraTexture:SetDesaturated(nil)
			end
		else
			AuraTexture:SetVertexColor(1, 1, 1)
		end
	end
end

function PowaAuras:UpdateColor(aura)
	if not aura then
		return
	end
	if not aura.model and not aura.modelcustom then
		local texture = self.Textures[aura.id]
		if not aura.textaura then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				texture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
			else
				texture:SetVertexColor(aura.r, aura.g, aura.b)
			end
			if aura.desaturation then
				local shaderSupported = texture:SetDesaturated(1)
				if shaderSupported then
					texture:SetDesaturated(1)
				else
					texture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				texture:SetDesaturated(nil)
			end
		else
			texture:SetVertexColor(aura.r, aura.g, aura.b)
		end
	else
		local model = self.Models[aura.id]
		model:SetLight(1, 0, 0, 1, 0, 1, aura.r, aura.g, aura.b, 1, aura.gr, aura.gg, aura.gb)
	end
	self:UpdatePreviewColor(aura)
end

function PowaAuras:UpdateRandomColor(aura)
	if not aura then
		return
	end
	aura.r1 = math.random(20, 100) / 100
	aura.r2 = math.random(20, 100) / 100
	aura.r3 = math.random(20, 100) / 100
	aura.r4 = math.random(20, 100) / 100
	aura.r5 = math.random(20, 100) / 100
	aura.r6 = math.random(20, 100) / 100
	if not aura.model and not aura.modelcustom then
		local texture = self.Textures[aura.id]
		if not aura.textaura then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				texture:SetGradientAlpha(aura.gradientstyle, aura.r1, aura.r2, aura.r3, 1.0, aura.r4, aura.r5, aura.r6, 1.0)
			else
				texture:SetVertexColor(aura.r1, aura.r2, aura.r3)
			end
			if aura.desaturation then
				local shaderSupported = texture:SetDesaturated(1)
				if shaderSupported then
					texture:SetDesaturated(1)
				else
					texture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				texture:SetDesaturated(nil)
			end
		else
			texture:SetVertexColor(aura.r1, aura.r2, aura.r3)
		end
		self:UpdatePreviewRandomColor(aura)
	else
		local model = self.Models[aura.id]
		if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
			model:SetLight(1, 0, 0, 1, 0, 1, aura.r1, aura.r2, aura.r3, 1, aura.r4, aura.r5, aura.r6)
		else
			model:SetLight(1, 0, 0, 1, 0, 1, aura.r1, aura.r2, aura.r3, 1, 1, 1, 1)
		end
	end
end

function PowaAuras:UpdateSecondaryColor(aura)
	if not aura then
		return
	end
	if not aura.model and not aura.modelcustom then
		local secondaryTexture = self.SecondaryTextures[aura.id]
		if not aura.textaura then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				secondaryTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
			else
				secondaryTexture:SetVertexColor(aura.r, aura.g, aura.b)
			end
			if aura.desaturation then
				local shaderSupported = secondaryTexture:SetDesaturated(1)
				if shaderSupported then
					secondaryTexture:SetDesaturated(1)
				else
					secondaryTexture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				secondaryTexture:SetDesaturated(nil)
			end
		else
			secondaryTexture:SetVertexColor(aura.r, aura.g, aura.b)
		end
	else
		local secondaryModel = self.SecondaryModels[aura.id]
		secondaryModel:SetLight(1, 0, 0, 1, 0, 1, aura.r, aura.g, aura.b, 1, aura.gr, aura.gg, aura.gb)
	end
end

function PowaAuras:UpdateSecondaryRandomColor(aura)
	if not aura then
		return
	end
	if not aura.model and not aura.modelcustom then
		local secondaryTexture = self.SecondaryTextures[aura.id]
		if not aura.textaura then
			if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
				secondaryTexture:SetGradientAlpha(aura.gradientstyle, aura.r1, aura.r2, aura.r3, 1.0, aura.r4, aura.r5, aura.r6, 1.0)
			else
				secondaryTexture:SetVertexColor(aura.r1, aura.r2, aura.r3)
			end
			if aura.desaturation then
				local shaderSupported = secondaryTexture:SetDesaturated(1)
				if shaderSupported then
					secondaryTexture:SetDesaturated(1)
				else
					secondaryTexture:SetVertexColor(0.5, 0.5, 0.5)
				end
			else
				secondaryTexture:SetDesaturated(nil)
			end
		else
			secondaryTexture:SetVertexColor(aura.r1, aura.r2, aura.r3)
		end
	else
		local secondaryModel = self.SecondaryModels[aura.id]
		if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
			secondaryModel:SetLight(1, 0, 0, 1, 0, 1, aura.r1, aura.r2, aura.r3, 1, aura.r4, aura.r5, aura.r6)
		else
			secondaryModel:SetLight(1, 0, 0, 1, 0, 1, aura.r1, aura.r2, aura.r3, 1, 1, 1, 1)
		end
	end
end

function PowaAuras:SetOrientation(aura, model, distance, yaw, pitch)
	if model:HasCustomCamera() then
		model.distance, model.yaw, model.pitch = distance, yaw, pitch
		aura.mcd, aura.mcy, aura.mcp = distance, yaw, pitch
		local x = distance * math.cos(yaw) * math.cos(pitch)
		local y = distance * math.sin(- yaw) * math.cos(pitch)
		local z = (distance * math.sin(- pitch))
		model:SetCameraPosition(x, y, z)
	end
end

function PowaAuras:ShowAuraForFirstTime(aura)
	if not aura.UseOldAnimations and aura.EndAnimation and aura.EndAnimation:IsPlaying() then
		aura:Hide()
	end
	aura.EndSoundPlayed = nil
	if not self.ModTest and not aura.StartSoundPlayed then
		aura.StartSoundPlayed = true
		if aura.customsound ~= "" then
			local pathToSound
			if string.find(aura.customsound, "\\") then
				pathToSound = aura.customsound
			else
				pathToSound = PowaGlobalMisc.PathToSounds .. aura.customsound
			end
			PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		elseif aura.sound > 0 then
			if self.Sound[aura.sound] and string.len(self.Sound[aura.sound]) > 0 then
				if string.find(self.Sound[aura.sound], "%.") then
					PlaySoundFile(PowaGlobalMisc.PathToSounds .. self.Sound[aura.sound], PowaMisc.SoundChannel)
				else
					PlaySound(self.Sound[aura.sound], PowaMisc.SoundChannel)
				end
			end
		end
	end
	local frame, model, texture = aura:CreateFrames()
	frame.aura = aura
	self:UpdateAuraVisuals(aura)
	self:ShowSecondaryAuraForFirstTime(aura)
end

function PowaAuras:UpdateAuraVisuals(aura)
	local frame = self.Frames[aura.id]
	local model = self.Models[aura.id]
	local texture = self.Textures[aura.id]
	if self.ModTest and not PowaMisc.Locked then
		self:SetForDragging(aura, frame)
	else
		self:ResetDragging(aura, frame)
	end
	model:SetUnit("none")
	if aura.owntex then
		texture:Show()
		if aura.icon == "" then
			texture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
		else
			texture:SetTexture(aura.icon)
		end
	elseif aura.wowtex then
		texture:Show()
		texture:SetTexture(self.WowTextures[aura.texture])
	elseif aura.customtex then
		texture:Show()
		texture:SetTexture(self:CustomTexPath(aura.customname))
	elseif aura.textaura then
		texture:Show()
		--texture:SetText(aura.aurastext)
		aura:UpdateText(texture)
	elseif aura.model then
		texture:Hide()
		if not aura.modelpath or aura.modelpath == "" then
			if not aura.modelcategory or aura.modelcategory == 1 then
				model:SetModel(self.ModelsCreature[aura.texture])
			elseif aura.modelcategory == 2 then
				model:SetModel(self.ModelsEnvironments[aura.texture])
			elseif aura.modelcategory == 3 then
				model:SetModel(self.ModelsInterface[aura.texture])
			elseif aura.modelcategory == 4 then
				model:SetModel(self.ModelsSpells[aura.texture])
			end
		else
			if tonumber(aura.modelpath) then
				model:SetDisplayInfo(aura.modelpath)
			else
				model:SetModel(aura.modelpath)
			end
		end
		model:SetCustomCamera(1)
		if model:HasCustomCamera() then
			if aura.mcd and aura.mcy and aura.mcp then
				self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
				local x, y, z = self:GetBaseCameraTarget(model)
				if y and z then
					model:SetCameraTarget(0, y, z)
				end
			else
				local x, y, z = model:GetCameraPosition()
				local tx, ty, tz = model:GetCameraTarget()
				if ty and tz then
					model:SetCameraTarget(0, ty, tz)
				end
				local distance = math.sqrt(x * x + y * y + z * z)
				local yaw = - math.atan(y / x)
				local pitch = - math.atan(z / x)
				self:SetOrientation(aura, model, distance, yaw, pitch)
			end
		end
	elseif aura.modelcustom then
		texture:Hide()
		if aura.modelcustompath and aura.modelcustompath ~= "" then
			if string.find(aura.modelcustompath, "%.m2") then
				model:SetModel(aura.modelcustompath)
			else
				model:SetUnit(string.lower(aura.modelcustompath))
			end
			model:SetCustomCamera(1)
			if model:HasCustomCamera() then
				if aura.mcd and aura.mcy and aura.mcp then
					self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
					local x, y, z = self:GetBaseCameraTarget(model)
					if y and z then
						model:SetCameraTarget(0, y, z)
					end
				else
					local x, y, z = model:GetCameraPosition()
					local tx, ty, tz = model:GetCameraTarget()
					if ty and tz then
						model:SetCameraTarget(0, ty, tz)
					end
					local distance = math.sqrt(x * x + y * y + z * z)
					local yaw = - math.atan(y / x)
					local pitch = - math.atan(z / x)
					self:SetOrientation(aura, model, distance, yaw, pitch)
				end
			end
		end
	else
		texture:Show()
		texture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	if aura.randomcolor then
		self:UpdateRandomColor(aura)
	else
		self:UpdateColor(aura)
	end
	if not aura.model and not aura.modelcustom then
		if not aura.textaura then
			texture:SetBlendMode(aura.blendmode)
		else
			texture:SetShadowColor(0.0, 0.0, 0.0, 0.0)
			texture:SetShadowOffset(0, 0)
		end
	end
	frame:SetFrameStrata(aura.strata)
	frame:SetFrameLevel(aura.stratalevel)
	if not aura.model and not aura.modelcustom then
		texture:SetDrawLayer(aura.texturestrata, aura.texturesublevel)
	end
	local height = 256
	local width = 256
	if not aura.textaura and not aura.model and not aura.modelcustom then
		texture:SetRotation(math.rad(aura.rotate))
	elseif aura.model or aura.modelcustom then
		model:SetPosition(aura.mz, aura.mx, aura.my)
		model:SetRotation(math.rad(aura.rotate))
		if aura.modelanimation and aura.modelanimation > - 1 and aura.modelanimation < 802 then
			local elapsed = 0
			model:SetScript("OnUpdate", function(self, elaps)
				elapsed = elapsed + (elaps * 1000)
				model:SetSequenceTime(aura.modelanimation, elapsed)
			end)
		end
	end
	if aura.customtex or aura.wowtex or aura.owntex or (not aura.customtex and not aura.wowtex and not aura.model and not aura.modelcustom and not aura.textaura and not aura.owntex) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
		local x = (math.sqrt(2) - 1) / 2
		if aura.rotate == 0 or aura.rotate == 360 then
			texture:SetTexCoord(ULx + x, ULy + x, LLx + x, LLy - x, URx - x, URy + x, LRx - x, LRy - x)
		elseif aura.rotate == 90 then
			texture:SetTexCoord(ULx - x, ULy + x, LLx + x, LLy + x, URx - x, URy - x, LRx + x, LRy - x)
		elseif aura.rotate == 180 then
			texture:SetTexCoord(ULx - x, ULy - x, LLx - x, LLy + x, URx + x, URy - x, LRx + x, LRy + x)
		elseif aura.rotate == 270 then
			texture:SetTexCoord(ULx + x, ULy - x, LLx - x, LLy - x, URx + x, URy + x, LRx - x, LRy + x)
		end
		if aura.customtex then
			if not string.find(aura.customname, "%.") then
				if aura.roundicons then
					SetPortraitToTexture(texture, texture:GetTexture())
				end
			end
		end
		if aura.owntex then
			if aura.roundicons then
				SetPortraitToTexture(texture, texture:GetTexture())
			end
		end
	end
	if not aura.textaura and not aura.model and not aura.modelcustom then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = texture:GetTexCoord()
		if aura.symetrie == 1 then
			texture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy) -- Inverse X
		elseif aura.symetrie == 2 then
			texture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy) -- Inverse Y
		elseif aura.symetrie == 3 then
			texture:SetTexCoord(LRx, LRy, URx, URy, LLx, LLy, ULx, ULy) -- Inverse XY
		else
			texture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
		end
	end
	if aura.textaura then
		local fontsize = math.min(33, math.max(10, math.floor(frame.baseH / 12.8)))
		local checkfont = texture:SetFont(self.Fonts[aura.aurastextfont], fontsize, "Outline, Monochrome")
		if not checkfont then
			texture:SetFont(STANDARD_TEXT_FONT, fontsize, "Outline, Monochrome")
		end
		frame.baseH = height * aura.size * (2 - aura.torsion)
		if aura.aurastext ~= "" then
			frame.baseL = texture:GetStringWidth() + 5
		else
			frame.baseL = width * aura.size * aura.torsion
		end
	elseif aura.customtex or aura.wowtex or aura.model or aura.modelcustom or aura.owntex or (not aura.customtex and not aura.wowtex and not aura.model and not aura.modelcustom and not aura.textaura and not aura.owntex) then
		if (aura.rotate == 0 or aura.rotate == 90 or aura.rotate == 180 or aura.rotate == 270 or aura.rotate == 360) and not aura.model and not aura.modelcustom then
			frame.baseH = height * aura.size * (2 - aura.torsion)
			frame.baseL = width * aura.size * aura.torsion
		else
			frame.baseH = math.sqrt(2) * height * aura.size * (2 - aura.torsion)
			frame.baseL = math.sqrt(2) * width * aura.size * aura.torsion
		end
	end
	self:InitialiseFrame(aura, frame)
	if aura.duration > 0 then
		aura.TimeToHide = GetTime() + aura.duration
	else
		aura.TimeToHide = nil
	end
	if aura.InvertTimeHides then
		aura.ForceTimeInvert = nil
	end
	if aura.Timer and aura.Timer.enabled then
		if aura.Debug then
			self:Message("Show Timer")
		end
		self:CreateTimerFrameIfMissing(aura.id, aura.Timer.UpdatePing)
		if aura.timerduration then
			aura.Timer.CustomDuration = aura.timerduration
		end
		aura.Timer.Start = GetTime()
	end
	if aura.Stacks and aura.Stacks.enabled then
		self:CreateStacksFrameIfMissing(aura.id, aura.Stacks.UpdatePing)
		aura.Stacks:ShowValue(aura, aura.Stacks.lastShownValue)
	end
	if aura.UseOldAnimations then
		frame.statut = 0
		if aura.begin > 0 then
			frame.beginAnim = 1
		else
			frame.beginAnim = 0
		end
		if aura.begin and aura.begin > 0 then
			aura.animation = self:AnimationBeginFactory(aura.begin, aura, frame)
		else
			aura.animation = self:AnimationMainFactory(aura.anim1, aura, frame)
		end
	elseif not aura.textaura then
		if not aura.BeginAnimation then
			aura.BeginAnimation = self:AddBeginAnimation(aura, frame)
		end
		if not aura.MainAnimation then
			aura.MainAnimation = self:AddMainAnimation(aura, frame)
		end
		if not aura.EndAnimation then
			aura.EndAnimation = self:AddEndAnimation(aura, frame)
		end
	end
	if not aura.UseOldAnimations then
		if aura.BeginAnimation then
			aura.BeginAnimation:Play()
			frame:SetAlpha(0)
		elseif aura.MainAnimation then
			aura.MainAnimation:Play()
		end
	end
	if aura.Debug then
		self:Message("frame:Show()", aura.id, " ", frame)
	end
	frame:Show()
	if aura.model then
		self:Reset(aura)
	elseif aura.modelcustom then
		if aura.modelcustompath and aura.modelcustompath ~= "" then
			if not string.find(aura.modelcustompath, "%.m2") then
				self:ResetUnit(aura)
			end
		end
	end
	aura.Showing = true
	aura.HideRequest = false
end

-- This needs to be a standalone function! 
function PowaAuras:InitialiseFrame(aura, frame)
	frame:SetAlpha(math.min(aura.alpha, 0.99))
	frame:SetPoint("Center", aura.x, aura.y)
	frame:SetWidth(frame.baseL)
	frame:SetHeight(frame.baseH)
end

function PowaAuras:ShowSecondaryAuraForFirstTime(aura)
	if aura.anim2 == 0 then
		local secondaryAura = self.SecondaryAuras[aura.id]
		if secondaryAura then
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
	local secondaryFrame, secondaryModel, secondaryTexture = secondaryAura:CreateFrames()
	self:UpdateSecondaryAuraVisuals(aura)
end

function PowaAuras:UpdateSecondaryAuraVisuals(aura)
	local secondaryFrame = self.SecondaryFrames[aura.id]
	local secondaryModel = self.SecondaryModels[aura.id]
	local secondaryTexture = self.SecondaryTextures[aura.id]
	local secondaryAura = self.SecondaryAuras[aura.id]
	secondaryAura.alpha = aura.alpha * 0.5
	secondaryAura.anim1 = aura.anim2
	if aura.speed > 0.5 then
		secondaryAura.speed = aura.speed - 0.1
	else
		secondaryAura.speed = aura.speed / 2
	end
	local auraId = aura.id
	local frame = self.Frames[auraId]
	local texture = self.Textures[auraId]
	secondaryModel:SetUnit("none")
	if aura.owntex then
		secondaryTexture:Show()
		if aura.icon == "" then
			secondaryTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
		else
			secondaryTexture:SetTexture(aura.icon)
		end
	elseif aura.wowtex then
		secondaryTexture:Show()
		secondaryTexture:SetTexture(self.WowTextures[aura.texture])
	elseif aura.customtex then
		secondaryTexture:Show()
		secondaryTexture:SetTexture(self:CustomTexPath(aura.customname))
	elseif aura.textaura then
		secondaryTexture:Show()
		--secondaryTexture:SetText(aura.aurastext)
		aura:UpdateText(secondaryTexture)
	elseif aura.model then
		secondaryTexture:Hide()
		if not aura.modelpath or aura.modelpath == "" then
			if not aura.modelcategory or aura.modelcategory == 1 then
				secondaryModel:SetModel(self.ModelsCreature[aura.texture])
			elseif aura.modelcategory == 2 then
				secondaryModel:SetModel(self.ModelsEnvironments[aura.texture])
			elseif aura.modelcategory == 3 then
				secondaryModel:SetModel(self.ModelsInterface[aura.texture])
			elseif aura.modelcategory == 4 then
				secondaryModel:SetModel(self.ModelsSpells[aura.texture])
			end
		else
			if tonumber(aura.modelpath) then
				secondaryModel:SetDisplayInfo(aura.modelpath)
			else
				secondaryModel:SetModel(aura.modelpath)
			end
		end
		secondaryModel:SetCustomCamera(1)
		if secondaryModel:HasCustomCamera() then
			if aura.mcd and aura.mcy and aura.mcp then
				self:SetOrientation(secondaryAura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
				local x, y, z = self:GetBaseCameraTarget(secondaryModel)
				if y and z then
					secondaryModel:SetCameraTarget(0, y, z)
				end
			else
				local x, y, z = secondaryModel:GetCameraPosition()
				local tx, ty, tz = secondaryModel:GetCameraTarget()
				secondaryModel:SetCameraTarget(0, ty, tz)
				local distance = math.sqrt(x * x + y * y + z * z)
				local yaw = - math.atan(y / x)
				local pitch = - math.atan(z / x)
				self:SetOrientation(secondaryAura, secondaryModel, distance, yaw, pitch)
			end
		end
	elseif aura.modelcustom then
		secondaryTexture:Hide()
		if aura.modelcustompath and aura.modelcustompath ~= "" then
			if string.find(aura.modelcustompath, "%.m2") then
				secondaryModel:SetModel(aura.modelcustompath)
			else
				secondaryModel:SetUnit(string.lower(aura.modelcustompath))
			end
			secondaryModel:SetCustomCamera(1)
			if secondaryModel:HasCustomCamera() then
				if aura.mcd and aura.mcy and aura.mcp then
					self:SetOrientation(secondaryAura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
					local x, y, z = self:GetBaseCameraTarget(secondaryModel)
					if y and z then
						secondaryModel:SetCameraTarget(0, y, z)
					end
				else
					local x, y, z = secondaryModel:GetCameraPosition()
					local tx, ty, tz = secondaryModel:GetCameraTarget()
					secondaryModel:SetCameraTarget(0, ty, tz)
					local distance = math.sqrt(x * x + y * y + z * z)
					local yaw = - math.atan(y / x)
					local pitch = - math.atan(z / x)
					self:SetOrientation(secondaryAura, secondaryModel, distance, yaw, pitch)
				end
			end
		end
	else
		secondaryTexture:Show()
		secondaryTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	if aura.randomcolor then
		self:UpdateSecondaryRandomColor(aura)
	else
		self:UpdateSecondaryColor(aura)
	end
	if not aura.textaura then
		secondaryTexture:SetBlendMode(aura.secondaryblendmode)
	end
	secondaryFrame:SetFrameStrata(aura.secondarystrata)
	secondaryFrame:SetFrameLevel(aura.secondarystratalevel)
	if not aura.model and not aura.modelcustom then
		secondaryTexture:SetDrawLayer(aura.secondarytexturestrata, aura.secondarytexturesublevel)
	end
	if not aura.textaura and not aura.model and not aura.modelcustom then
		secondaryTexture:SetRotation(math.rad(aura.rotate))
	elseif aura.model or aura.modelcustom then
		secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		secondaryModel:SetRotation(math.rad(aura.rotate))
		if aura.modelanimation and aura.modelanimation > - 1 and aura.modelanimation < 802 then
			local elapsed = 0
			secondaryModel:SetScript("OnUpdate", function(self, elaps)
				elapsed = elapsed + (elaps * 1000)
				secondaryModel:SetSequenceTime(aura.modelanimation, elapsed)
			end)
		end
	end
	if aura.customtex or aura.wowtex or aura.owntex or (not aura.customtex and not aura.wowtex and not aura.model and not aura.modelcustom and not aura.textaura and not aura.owntex) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = secondaryTexture:GetTexCoord()
		local x = (math.sqrt(2) - 1) / 2
		if aura.rotate == 0 or aura.rotate == 360 then
			secondaryTexture:SetTexCoord(ULx + x, ULy + x, LLx + x, LLy - x, URx - x, URy + x, LRx - x, LRy - x)
		elseif aura.rotate == 90 then
			secondaryTexture:SetTexCoord(ULx - x, ULy + x, LLx + x, LLy + x, URx - x, URy - x, LRx + x, LRy - x)
		elseif aura.rotate == 180 then
			secondaryTexture:SetTexCoord(ULx - x, ULy - x, LLx - x, LLy + x, URx + x, URy - x, LRx + x, LRy + x)
		elseif aura.rotate == 270 then
			secondaryTexture:SetTexCoord(ULx + x, ULy - x, LLx - x, LLy - x, URx + x, URy + x, LRx - x, LRy + x)
		end
		if aura.customtex then
			if not string.find(aura.customname, "%.") then
				if aura.roundicons then
					SetPortraitToTexture(secondaryTexture, secondaryTexture:GetTexture())
				end
			end
		end
		if aura.owntex then
			if aura.roundicons then
				SetPortraitToTexture(secondaryTexture, secondaryTexture:GetTexture())
			end
		end
	end
	if not aura.textaura and not aura.model and not aura.modelcustom then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = secondaryTexture:GetTexCoord()
		if aura.symetrie == 1 then
			secondaryTexture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy) -- Inverse X
		elseif aura.symetrie == 2 then
			secondaryTexture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy) -- Inverse Y
		elseif aura.symetrie == 3 then
			secondaryTexture:SetTexCoord(LRx, LRy, URx, URy, LLx, LLy, ULx, ULy) -- Inverse XY
		else
			secondaryTexture:SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy) -- Normal
		end
	end
	if aura.textaura then
		local fontsize = math.min(33, math.max(10, math.floor(frame.baseH / 12.8)))
		local checkfont = secondaryTexture:SetFont(self.Fonts[aura.aurastextfont], fontsize, "Outline, Monochrome")
		if not checkfont then
			secondaryTexture:SetFont(STANDARD_TEXT_FONT, fontsize, "Outline, Monochrome")
		end
	end
	secondaryFrame.baseL = frame.baseL
	secondaryFrame.baseH = frame.baseH
	secondaryFrame:SetPoint("Center", aura.x, aura.y)
	secondaryFrame:SetWidth(secondaryFrame.baseL)
	secondaryFrame:SetHeight(secondaryFrame.baseH)
	if aura.UseOldAnimations then
		secondaryFrame.statut = 1
		if aura.begin > 0 then
			secondaryFrame.beginAnim = 2
		else
			secondaryFrame.beginAnim = 0
		end
		if not aura.begin or aura.begin == 0 then
			secondaryAura.animation = self:AnimationMainFactory(aura.anim2, secondaryAura, secondaryFrame)
		else
			secondaryFrame:SetAlpha(0)
		end
		secondaryFrame:Show()
	elseif not aura.textaura then
		if not secondaryAura.MainAnimation then
			secondaryAura.MainAnimation = self:AddMainAnimation(secondaryAura, secondaryFrame)
		end
		if not aura.BeginAnimation then
			secondaryFrame:Show()
			if secondaryAura.MainAnimation then
				secondaryAura.MainAnimation:Play()
			end
		end
	end
	if aura.model then
		self:ResetSecondary(aura)
	elseif aura.modelcustom then
		if aura.modelcustompath and aura.modelcustompath ~= "" then
			if not string.find(aura.modelcustompath, "%.m2") then
				self:ResetSecondaryUnit(aura)
			end
		end
	end
	secondaryAura.Showing = true
	secondaryAura.HideRequest = false
end

function PowaAuras:DisplayAura(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[auraId]
	if not aura or aura.off then
		return
	end
	self:ShowAuraForFirstTime(aura)
end

function PowaAuras:RedisplayAura(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[auraId]
	if not aura then
		return
	end
	local showing = aura.Showing
	aura:Hide()
	aura.BeginAnimation = nil
	aura.MainAnimation = nil
	aura.EndAnimation = nil
	aura:CreateFrames()
	self.SecondaryAuras[aura.id] = nil
	if showing then
		self:DisplayAura(aura.id)
	end
end

function PowaAuras:RedisplayAuraVisuals(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[auraId]
	if not aura or aura.off then
		return
	end
	self:UpdateAuraVisuals(aura)
	local secondaryAura = self.SecondaryAuras[auraId]
	if secondaryAura then
		self:UpdateSecondaryAuraVisuals(aura)
	end
end

function PowaAuras:DisplaySecondaryAura(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[auraId]
	if not aura or aura.off then
		return
	end
	self:ShowSecondaryAuraForFirstTime(aura)
end

function PowaAuras:RedisplaySecondaryAura(auraId)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[auraId]
	if not aura then
		return
	end
	local showing = aura.Showing
	self.SecondaryAuras[aura.id] = nil
	if showing then
		self:DisplaySecondaryAura(aura.id)
	end
end

function PowaAuras:UpdateAura(aura, elapsed)
	if not aura then
		return false
	end
	if aura.off then
		if aura.Showing then
			aura:Hide()
		end
		if aura.Timer and aura.Timer.Showing then
			aura.Timer:Hide()
		end
		return false
	end
	if aura.Showing then
		local frame = aura:GetFrame()
		if not frame then
			return false
		end
		if not aura.HideRequest and not aura.isSecondary and not self.ModTest and aura.TimeToHide then
			if GetTime() >= aura.TimeToHide then
				self:SetAuraHideRequest(aura)
				aura.TimeToHide = nil
			end
		end
		if aura.HideRequest then
			if not self.ModTest and not aura.EndSoundPlayed then
				if aura.customsoundend ~= "" then
					local pathToSound
					if string.find(aura.customsoundend, "\\") then
						pathToSound = aura.customsoundend
					else
						pathToSound = PowaGlobalMisc.PathToSounds..aura.customsoundend
					end
					PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
				elseif aura.soundend > 0 then
					if self.Sound[aura.soundend] and string.len(self.Sound[aura.soundend]) > 0 then
						if string.find(self.Sound[aura.soundend], "%.") then
							PlaySoundFile(PowaGlobalMisc.PathToSounds..self.Sound[aura.soundend], PowaMisc.SoundChannel)
						else
							PlaySound(self.Sound[aura.soundend], PowaMisc.SoundChannel)
						end
					end
				end
				aura.StartSoundPlayed = nil
				aura.EndSoundPlayed = true
			end
			if aura.Stacks then
				aura.Stacks:Hide()
			end
			if aura.UseOldAnimations then
				aura.animation = self:AnimationEndFactory(aura.finish, aura, frame)
				if not aura.animation then
					aura:Hide()
				end
			else
				if not aura.EndAnimation then
					aura:Hide()
				else
					if aura.BeginAnimation and aura.BeginAnimation:IsPlaying() then
						aura.BeginAnimation:Stop()
					end
					if aura.MainAnimation and aura.MainAnimation:IsPlaying() then
						aura.MainAnimation:Stop()
					end
					aura.EndAnimation:Play()
				end
			end
		end
		if aura.UseOldAnimations then
			self:UpdateAuraAnimation(aura, elapsed, frame)
		end
		if aura.Active and aura.Stacks and aura.Stacks.enabled then
			if self.ModTest then
				if aura.Stacks.SetStackCount then
					aura.Stacks:SetStackCount(math.random(1, 12))
				end
			end
			aura.Stacks:Update()
		end
	end
	aura.HideRequest = false
	return true
end

function PowaAuras:UpdateTimer(aura, timerElapsed, skipTimerUpdate)
	if not aura.Timer or skipTimerUpdate then
		return
	end
	local timerHide
	if aura.Timer.ShowOnAuraHide and not self.ModTest and not aura.ForceTimeInvert and not aura.InvertTimeHides then
		timerHide = aura.Active
	else
		timerHide = not aura.Active
	end
	if timerHide or aura.InactiveDueToMulti or (aura.InactiveDueToState and not aura.Active) then
		aura.Timer:Hide()
		if aura.ForceTimeInvert then
			aura.Timer:Update(timerElapsed)
		end
	else
		aura.Timer:Update(timerElapsed)
	end
end

function PowaAuras:UpdateAuraAnimation(aura, elapsed, frame)
	if not aura.Showing then
		return
	end
	if not aura.animation or elapsed == 0 then
		return
	end
	if aura.isSecondary then
		local primaryAnimation = self.Auras[aura.id].animation
		if primaryAnimation.IsBegin or primaryAnimation.IsEnd then
			return
		end
	end
	local finished = aura.animation:Update(math.min(elapsed, 0.03))
	if not finished then
		return
	end
	if aura.animation.IsBegin then
		aura.animation = self:AnimationMainFactory(aura.anim1, aura, frame)
		local secondaryAura = self.SecondaryAuras[aura.id]
		if secondaryAura then
			local secondaryAuraFrame = self.SecondaryFrames[aura.id]
			if secondaryAuraFrame then
				secondaryAura.animation = self:AnimationMainFactory(aura.anim2, secondaryAura, secondaryAuraFrame)
			end
		end
		return
	end
	if aura.animation.IsEnd then
		aura:Hide()
	end
end

function PowaAuras_GlobalTrigger(auraType)
	if PowaAuras.AurasByType[auraType] then 
		for index, auraid in ipairs(PowaAuras.AurasByType[auraType]) do
			if PowaAuras.Auras[auraid]:ShouldShow() then
				local shouldShow = PowaAuras:CheckMultiple(PowaAuras.Auras[auraid], "", nil)
				if shouldShow then
					PowaAuras:DisplayAura(auraid)
					if PowaAuras.Auras[auraid].timerduration == 0 then
						PowaAuras.Auras[auraid].HideRequest = true
					end
				end
			end
		end
	end
	return true
end