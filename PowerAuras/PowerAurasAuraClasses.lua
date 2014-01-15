local _, ns = ...
local PowaAuras = ns.PowaAuras

local string, tostring, tonumber, format, table, math, pairs, strtrim, strsplit, select, wipe, _G = string, tostring, tonumber, format, table, math, pairs, strtrim, strsplit, select, wipe, _G

-- PowaAura Classes
function PowaClass(base, ctor)
	local c = { }
	if not ctor and type(base) == "function" then
		ctor = base
		base = nil
	elseif type(base) == "table" then
		for i, v in pairs(base) do
			c[i] = v
		end
		if type(ctor) == "table" then
			for i, v in pairs(ctor) do
				c[i] = v
			end
			ctor = nil
		end
		c._base = base
	end
	c.__index = c
	local mt = { }
	mt.__call = function(class_tbl, ...)
		local obj = { }
		setmetatable(obj, c)
		if ctor then
			ctor(obj, ...)
		end
		return obj
	end
	if ctor then
		c.init = ctor
	else
		if base and base.init then
			c.init = base.init
			ctor = base.init
		end
	end
	c.is_a = function(self, class)
		local m = getmetatable(self)
		while m do
			if m == class then
				return true
			end
			m = m._base
		end
		return false
	end
	setmetatable(c, mt)
	return c
end

-- cPowaAura is the base class and is not instanced directly, the other classes inherit properties and methods from it
cPowaAura = PowaClass(function(aura, id, base)
	for k, v in pairs(cPowaAura.ExportSettings) do
		if base and base[k] ~= nil then
			aura[k] = base[k]
		else
			aura[k] = v
		end
	end
	if base then
		if base.ShowOptions == nil then
			aura.ShowOptions = base.ShowOptions
		end
		if base.CheckBoxes == nil then
			aura.CheckBoxes = base.CheckBoxes
		end
		if base.OptionText == nil then
			aura.OptionText = base.OptionText
		end
		if base.OptionTernary == nil then
			aura.OptionTernary = base.OptionTernary
		end
	end
	aura.id = id
	aura.Showing = false
	aura.Active = false
	aura.HideRequest = false
	aura.Debug = nil
	aura.CurrentText = nil
	if aura.minDuration then
		aura.duration = math.max(aura.duration, aura.minDuration)
	end
	if base then
		local tempForSettings = PowaAuras.AuraClasses[base.bufftype]
		if base.Timer and not aura.isSecondary then
			aura.Timer = cPowaTimer(aura, base.Timer)
		end
		if base.Stacks and not base.isSecondary and tempForSettings:StacksAllowed() then
			aura.Stacks = cPowaStacks(aura, base.Stacks)
		end
	end
	aura:Init()
end)

cPowaAura.ExportSettings =
{
	off = false,
	bufftype = PowaAuras.BuffTypes.Buff,
	buffname = "???",
	texmode = 0,
	wowtex = false,
	model = false,
	modelpath = "",
	modelcategory = 1,
	modelcustom = false,
	modelcustompath = "",
	mz = 0,
	mx = 0,
	my = 0,
	mcd = false,
	mcy = false,
	mcp = false,
	modelanimation = -1,
	customtex = false,
	textaura = false,
	owntex = false,
	roundicons = false,
	realaura = 1,
	texture = 1,
	customname = "",
	aurastext = "",
	aurastextfont = 1,
	icon = "",
	strata = "Low",
	stratalevel = 0,
	texturestrata = "Background",
	texturesublevel = 0,
	blendmode = "Disable",
	secondaryblendmode = "Blend",
	secondarystrata = "Background",
	secondarystratalevel = 0,
	secondarytexturestrata = "Background",
	secondarytexturesublevel = 0,
	timerduration = 0,
	-- Sound Settings
	sound = 0,
	customsound = "",
	soundend = 0,
	customsoundend = "",
	-- Animation Settings
	begin = 0,
	anim1 = 1,
	anim2 = 0,
	speed = 1.00,
	finish = 1,
	isSecondary = false,
	beginSpin = false,
	duration = 0,
	-- Appearance Settings
	alpha = 0.85,
	desaturation = false,
	enablefullrotation = true,
	rotate = 0,
	size = 1,
	torsion = 1,
	symetrie = 0,
	x = 0,
	y = 0,
	randomcolor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0,
	gradient = false,
	gradientstyle = "None",
	gr = 1.0,
	gg = 1.0,
	gb = 1.0,
	inverse = false,
	ignoremaj = true,
	exact = false,
	Extra = false,
	InvertAuraBelow = 0,
	stacks = 0,
	stacksLower = 0,
	stacksOperator = PowaAuras.DefaultOperator,
	threshold = 50,
	thresholdinvert = false,
	mine = false,
	focus = false,
	target = false,
	targetfriend = false,
	raid = false,
	groupOrSelf = false,
	party = false,
	groupany = false,
	optunitn = false,
	unitn = "",
	inRaid = 0,
	inParty = 0,
	ismounted = 0,
	isResting = 0,
	inVehicle = 0,
	inPetBattle = 0,
	combat = 0,
	isAlive = true,
	PvP = 0,
	InstanceScenario = 0,
	InstanceScenarioHeroic = 0,
	Instance5Man = 0,
	Instance5ManHeroic = 0,
	InstanceChallengeMode = 0,
	Instance10Man = 0,
	Instance10ManHeroic = 0,
	Instance25Man = 0,
	Instance25ManHeroic = 0,
	InstanceFlexible = 0,
	InstanceBg = 0,
	InstanceArena = 0,
	RoleTank = 0,
	RoleHealer = 0,
	RoleMeleDps = 0,
	RoleRangeDps = 0,
	spec1 = true,
	spec2 = true,
	gcd = false,
	stance = 0,
	GTFO = 0,
	PowerType = -1,
	multiids = "",
	tooltipCheck = "",
	UseOldAnimations = false,
}

local playerSpells
do
	local iterateFlyout, iterateSlots, iterateTabs
	iterateFlyout = function(state)
		while state.flyoutSlotIdx <= state.numFlyoutSlots do
			local spellId, _, spellKnown, spellName = GetFlyoutSlotInfo(state.flyoutId, state.flyoutSlotIdx)
			state.flyoutSlotIdx = state.flyoutSlotIdx + 1
			if spellKnown then
				return spellId, spellName
			end
		end
		state.slotIdx = state.slotIdx + 1
		state.currentIterator = iterateSlots
		return state:currentIterator()
	end
	iterateSlots = function(state)
		while state.slotIdx <= state.numSlots do
			local spellBookItem = state.slotOffset + state.slotIdx
			local spellName, spellSubtext = GetSpellBookItemName(spellBookItem, BOOKTYPE_SPELL)
			local spellType, spellId = GetSpellBookItemInfo(spellBookItem, BOOKTYPE_SPELL)
			if spellType == "SPELL" and not IsPassiveSpell(spellId) then
				state.slotIdx = state.slotIdx + 1
				return spellId, spellName, spellSubtext
			elseif spellType == "FLYOUT" then
				local _, _, numFlyoutSlots, flyoutKnown = GetFlyoutInfo(spellId)
				if flyoutKnown then
					state.flyoutId = spellId
					state.flyoutSlotIdx = 1
					state.numFlyoutSlots = numFlyoutSlots
					state.currentIterator = iterateFlyout
					return state:currentIterator()
				end
			end
			state.slotIdx = state.slotIdx + 1
		end
		state.tabIdx = state.tabIdx + 1
		state.currentIterator = iterateTabs
		return state:currentIterator()
	end
	iterateTabs = function(state)
		while state.tabIdx <= state.numOfTabs do
			local _, _, slotOffset, numSlots, _, offSpecID = GetSpellTabInfo(state.tabIdx)
			if offSpecID ~= 0 then
				state.tabIdx = state.tabIdx + 1
			else
				state.slotOffset = slotOffset
				state.numSlots = numSlots
				state.slotIdx = 1
				state.currentIterator = iterateSlots
				return state:currentIterator()
			end
		end
		return nil
	end
	local function dispatch(state)
		return state:currentIterator()
	end
	playerSpells = function()
		local state = { }
		state.tabIdx = 1
		state.numOfTabs = GetNumSpellTabs()
		state.currentIterator = iterateTabs
		return dispatch, state
	end
end

local petSpells
do
	local iterateFlyout, iterateSlots, iterateTabs
	iterateFlyout = function(state)
		while state.flyoutSlotIdx <= state.numFlyoutSlots do
			local spellId, _, spellKnown, spellName = GetFlyoutSlotInfo(state.flyoutId, state.flyoutSlotIdx)
			state.flyoutSlotIdx = state.flyoutSlotIdx + 1
			if spellKnown then
				return spellId, spellName
			end
		end
		state.slotIdx = state.slotIdx + 1
		state.currentIterator = iterateSlots
		return state:currentIterator()
	end
	iterateSlots = function(state)
		while state.slotIdx <= state.numSlots do
			local spellBookItem = state.slotOffset + state.slotIdx
			local spellName, spellSubtext = GetSpellBookItemName(spellBookItem, BOOKTYPE_PET)
			local spellType, spellId = GetSpellBookItemInfo(spellBookItem, BOOKTYPE_PET)
			if spellType == "SPELL" and not IsPassiveSpell(spellId) then
				state.slotIdx = state.slotIdx + 1
				return spellId, spellName, spellSubtext
			elseif spellType == "FLYOUT" then
				local _, _, numFlyoutSlots, flyoutKnown = GetFlyoutInfo(spellId)
				if flyoutKnown then
					state.flyoutId = spellId
					state.flyoutSlotIdx = 1
					state.numFlyoutSlots = numFlyoutSlots
					state.currentIterator = iterateFlyout
					return state:currentIterator()
				end
			end
			state.slotIdx = state.slotIdx + 1
		end
		state.tabIdx = state.tabIdx + 1
		state.currentIterator = iterateTabs
		return state:currentIterator()
	end
	iterateTabs = function(state)
		while state.tabIdx <= state.numOfTabs do
			local _, _, slotOffset, numSlots, _, offSpecID = GetSpellTabInfo(state.tabIdx)
			if offSpecID ~= 0 then
				state.tabIdx = state.tabIdx + 1
			else
				state.slotOffset = slotOffset
				state.numSlots = numSlots
				state.slotIdx = 1
				state.currentIterator = iterateSlots
				return state:currentIterator()
			end
		end
		return nil
	end
	local function dispatch(state)
		return state:currentIterator()
	end
	petSpells = function()
		local state = { }
		state.tabIdx = 1
		state.numOfTabs = 1
		state.currentIterator = iterateTabs
		return dispatch, state
	end
end

function cPowaAura:Init()
	self:SetFixedIcon()
end

-- Do not delete this!
function cPowaAura:SetFixedIcon()
	-- Set icon from the class
end

function cPowaAura:Dispose()
	self:Hide()
	PowaAuras:Dispose("Frames", self.id)
	PowaAuras:Dispose("Textures", self.id)
	PowaAuras:Dispose("Models", self.id)
	PowaAuras:Dispose("SecondaryFrames", self.id)
	PowaAuras:Dispose("SecondaryTextures", self.id)
	PowaAuras:Dispose("SecondaryModels", self.id)
	PowaAuras:Dispose("SecondaryAuras", self.id)
end

function cPowaAura:TimerShowing()
	if not self.Timer then
		return false
	end
	return self.Timer.Showing
end

function cPowaAura:StacksShowing()
	if not self.Stacks then
		return false
	end
	return self.Stacks.Showing
end

function cPowaAura:FullTimerAllowed()
	return (self.CanHaveTimer and not self.inverse) or (self.CanHaveTimerOnInverse and self.inverse)
end

function cPowaAura:StacksAllowed()
	return self.CanHaveStacks and not self.inverse
end

function cPowaAura:HideShowTabs()
	if self:StacksAllowed() then
		PowaEditorTab5:Show()
		if not self.Stacks then
			self.Stacks = cPowaStacks(self)
		end
	else
		PowaEditorTab5:Hide()
		if self.Stacks then
			self.Stacks.enabled = false
		end
	end
end

function cPowaAura:DisplayType()
	return self.OptionText.typeText
end

cPowaAura.TooltipOptions = {r = 1.0, g = 1.0, b = 1.0}

function cPowaAura:AddExtraTooltipInfo(tooltip)
	tooltip:SetText("|cffFFFFFF["..(self.id or "?").."] |r"..(self:DisplayType() or "?"), self.TooltipOptions.r, self.TooltipOptions.g, self.TooltipOptions.b, 1)
	if self.TooltipOptions.showBuffName and self.buffname ~= "???" then
		tooltip:AddLine(self.buffname, nil, nil, nil, nil, 1)
	end
	if self.TooltipOptions.stacksColour then
		tooltip:AddLine(PowaAuras.Text.nomStacks..self.stacksOperator..self.stacks, self.TooltipOptions.stacksColour.r, self.TooltipOptions.stacksColour.g, self.TooltipOptions.stacksColour.b, 1)
	end
	if self.TooltipOptions.showThreshold then
		tooltip:AddLine(self.threshold..self.RangeType, self.TooltipOptions.r, self.TooltipOptions.g, self.TooltipOptions.b, 1)
	end
	if self.TooltipOptions.showStance then
		tooltip:AddLine(PowaAuras.PowaStance[self.stance], self.TooltipOptions.r, self.TooltipOptions.g, self.TooltipOptions.b, 1)
	end
	if self.TooltipOptions.showGTFO then
		tooltip:AddLine(PowaAuras.PowaGTFO[self.GTFO], self.TooltipOptions.r, self.TooltipOptions.g, self.TooltipOptions.b, 1)
	end
end

function cPowaAura:CreateFrames()
	local frame = self:GetFrame()
	if frame == nil then
		frame = CreateFrame("Frame", nil, UIParent)
		self:SetFrame(frame)
		frame:SetFrameStrata(self.strata)
		frame:Hide()
		frame.baseL = 256
		frame.baseH = 256
	end
	local model = self:GetModel()
	if model == nil then
		model = CreateFrame("PlayerModel", nil, frame)
		model:SetAllPoints(frame)
		frame.model = model
		self:SetModel(model)
	else
		model:SetAllPoints(frame)
		frame.model = model
		self:SetModel(model)
	end
	local texture = self:GetTexture()
	if texture == nil then
		if self.textaura then
			texture = frame:CreateFontString(nil, "OVERLAY")
			texture:ClearAllPoints()
			texture:SetPoint("CENTER", frame)
			texture:SetFont(STANDARD_TEXT_FONT, 20)
			texture:SetTextColor(self.r, self.g, self.b)
			texture:SetJustifyH("CENTER")
		else
			texture = frame:CreateTexture(nil, "BACKGROUND")
			texture:SetBlendMode("ADD")
			texture:SetAllPoints(frame)
			frame.texture = texture
		end
		self:SetTexture(texture)
	else
		if self.textaura then
			if texture:GetObjectType() == "Texture" then
				texture:SetTexture(nil)
				texture = frame:CreateFontString(nil, "OVERLAY")
				texture:ClearAllPoints()
				texture:SetPoint("CENTER", frame)
				texture:SetFont(STANDARD_TEXT_FONT, 20)
				texture:SetTextColor(self.r, self.g, self.b)
				texture:SetJustifyH("CENTER")
				self:SetTexture(texture)
			end
		else
			if texture:GetObjectType() == "FontString" then
				texture:SetText("")
				texture = frame:CreateTexture(nil, "BACKGROUND")
				texture:SetBlendMode("ADD")
				texture:SetAllPoints(frame)
				frame.texture = texture
				self:SetTexture(texture)
			end
		end
	end
	return frame, model, texture
end

function cPowaAura:Hide(skipEndAnimationStop)
	if self.BeginAnimation and self.BeginAnimation:IsPlaying() then
		self.BeginAnimation:Stop()
	end
	if self.MainAnimation and self.MainAnimation:IsPlaying() then
		self.MainAnimation:Stop()
	end
	if not skipEndAnimationStop and (self.EndAnimation and self.EndAnimation:IsPlaying()) then
		self.EndAnimation:Stop()
	end
	local frame = self:GetFrame()
	if frame then
		frame:Hide()
	end
	if not self.isSecondary then
		if self.Timer and (PowaAuras.ModTest or self.off) then
			self.Timer:Hide()
		end
		if self.Stacks then
			self.Stacks:Hide()
		end
		local frame = PowaAuras.Frames[self.id]
		if frame then
			frame:Hide()
		end
		local secondaryAura = PowaAuras.SecondaryAuras[self.id]
		if secondaryAura then
			secondaryAura:Hide()
		end
	end
	self.Showing = false
end

function cPowaAura:UpdateText(texture)
	if not self.textaura then
		return
	end
	local newText = self:GetAuraText()
	if self.Debug then
		PowaAuras:Message("CurrentText = ", self.CurrentText)
		PowaAuras:Message("newText = ", newText)
	end
	if texture then
		texture:SetText(newText)
		self.CurrentText = newText
	else
		texture = self:GetTexture()
	end
	if self.Debug then
		PowaAuras:Message("texture = ", texture)
	end
end

function cPowaAura:GetAuraText()
	if not string.find(self.aurastext, "%%") then
		return self.aurastext
	end
	local text
	text = self:SubstituteInText(self.aurastext, "%%t", function() return UnitName("target") end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%f", function() return UnitName("focus") end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%n", function() return self.DisplayValue end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%str", function() return UnitStat("player", 1) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%agl", function() return UnitStat("player", 2) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%sta", function() return UnitStat("player", 3) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%int", function() return UnitStat("player", 4) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%spi", function() return UnitStat("player", 5) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%crt", function() return format("%.2f", GetCritChance()) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%sp", function() return self:SpellPower() end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%ap", function() return UnitAttackPower("player") end, PowaAuras.Text.Unknown)
	local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player")
	text = self:SubstituteInText(text , "%%lowMdmg", function() return math.floor(lowDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%highMdmg", function() return math.ceil(hiDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%avgMdmg", function() return (math.ceil(hiDmg) + math.floor(lowDmg)) / 2 end, PowaAuras.Text.Unknown)
	local lowDmg, hiDmg, offlowDmg, offhiDmg, posBuff, negBuff, percentmod = UnitDamage("player")
	text = self:SubstituteInText(text , "%%offlowMdmg", function() return math.floor(offlowDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%offhighMdmg", function() return math.ceil(offhiDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%avgMdmg", function() return (math.ceil(offhiDmg) + math.floor(offlowDmg)) / 2 end, PowaAuras.Text.Unknown)
	local speed, lowDmg, hiDmg, posBuff, negBuff, percent = UnitRangedDamage("player")
	text = self:SubstituteInText(text , "%%lowRdmg", function() return math.floor(lowDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%highRdmg", function() return math.ceil(hiDmg) end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%avgRdmg", function() return (math.ceil(hiDmg) + math.floor(lowDmg)) / 2 end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%u", function() if self.DisplayUnit == nil then return nil end local name = UnitName(self.DisplayUnit) if name then return name end return self.DisplayUnit end, PowaAuras.Text.Unknown)
	text = self:SubstituteInText(text , "%%u2",	function() if self.DisplayUnit2 == nil then return nil end local name = UnitName(self.DisplayUnit2) if name then return name end return self.DisplayUnit2 end, PowaAuras.Text.Unknown)
	return text
end

function cPowaAura:SpellPower()
	local spellPower = 0
	for i = 1, 7 do
		spellPower = spellPower + GetSpellBonusDamage(i)
	end
	return spellPower
end

function cPowaAura:SubstituteInText(text, old, getNewText, nilText)
	if not string.find(text, old) then
		return text
	end
	local new = getNewText()
	if new == nil then
		return string.gsub(text, old, nilText)
	end
	return string.gsub(text, old, new)
end

function cPowaAura:IsPlayerAura()
	return not self.target and not self.targetfriend and not self.party and not self.raid and not (self.groupOrSelf and (GetNumGroupMembers() > 0)) and not self.focus and not self.optunitn
end

function cPowaAura:ShowTimerDurationSlider()
	return false
end

function cPowaAura:IconIsRequired()
	return self.owntex == true or self.icon == "" or self.icon == nil or self.ForceIconCheck
end

function cPowaAura:SetIcon(texturePath)
	if self.Debug then
		PowaAuras:Message("TexturePath = ", texturePath, " IconIsRequired = ", self:IconIsRequired())
	end
	if texturePath == nil or string.len(texturePath) == 0 or not self:IconIsRequired() then
		return
	end
	if self.Debug then
		PowaAuras:Message("self.icon = ", self.icon)
	end
	if texturePath ~= self.icon then
		if self.owntex then
			local texture = self:GetTexture()
			if texture and texture.SetTexture then
				texture:SetTexture(texturePath)
			end
		end
		if self.Debug then
			PowaAuras:Message("Setting icon to ", texturePath)
		end
		self.icon = texturePath
	end
end

function cPowaAura:SkipTargetChecks()
	return false
end

function cPowaAura:CheckState(giveReason)
	-- Player aura but player is dead
	if self:IsPlayerAura() and ((PowaAuras.WeAreAlive == true and self.isAlive == false) or (PowaAuras.WeAreAlive == false and self.isAlive == true)) then
		if not giveReason then
			return false
		end
		if PowaAuras.WeAreAlive == false then
			return false, PowaAuras.Text.nomReasonPlayerDead
		else
			return false, PowaAuras.Text.nomReasonPlayerAlive
		end
	end
	-- It's not dead it's resting
	if (self.isResting == false and IsResting() == 1 and not PowaAuras.WeAreInCombat) or (self.isResting == true and (IsResting() ~= 1)) then
		if not giveReason then
			return false
		end
		if self.isResting == true then
			return false, PowaAuras.Text.nomReasonNotResting
		end
		return false, PowaAuras.Text.nomReasonResting
	end
	-- Target checks
	if not self.raid and not self.party and not self.groupOrSelf and not self:SkipTargetChecks() then
		-- Check if target exists and is alive
		if self.target or self.targetfriend then
			if UnitName("target") == nil then
				if not giveReason then
					return false
				end
				return false, PowaAuras.Text.nomReasonNoTarget
			end
			if UnitName("target") == UnitName("player") then
				if not giveReason then
					return false
				end
				return false, PowaAuras.Text.nomReasonTargetPlayer
			end
			local targetIsDead = UnitIsDead("target")
			if (targetIsDead and self.isAlive == true) or (not PowaAuras.targetIsDead and self.isAlive == false) then
				if not giveReason then
					return false
				end
				if targetIsDead then
					return false, PowaAuras.Text.nomReasonTargetDead
				end
				return false, PowaAuras.Text.nomReasonTargetAlive
			end
		end
		-- Check if target is an enemy
		if self.target and self.targetfriend == false and UnitIsFriend("player", "target") then
			if not giveReason then
				return false
			end
			return false, PowaAuras.Text.nomReasonTargetFriendly
		end
		-- Check if target is a friend
		if self.target == false and self.targetfriend and not UnitIsFriend("player", "target") then
			if not giveReason then
				return false
			end
			return false, PowaAuras.Text.nomReasonTargetNotFriendly
		end
	end
	if self.bufftype == PowaAuras.BuffTypes.SpellCooldown and self.targetfriend and not UnitExists("pet") then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonNoPet
	end
	-- Party
	if self.party and not (GetNumGroupMembers() > 0) then -- Party check yes, but not in party
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonNotInParty
	end
	-- Focus
	if self.focus and UnitName("focus") == nil then -- Focus check
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonNoFocus
	end
	-- Unit
	if self.optunitn and not ((GetNumSubgroupMembers() > 0 and UnitInParty(self.unitn)) or (IsInRaid() and UnitInRaid(self.unitn)) or UnitIsUnit("pet", self.unitn) or UnitIsUnit("player", self.unitn)) then -- Unitn yes, but not in party/raid or with pet
		if not giveReason then
			return false
		end
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNoCustomUnit, self.unitn)
	end
	-- Raid
	local numrm = GetNumGroupMembers()
	if self.raid and numrm == 0 then -- Raid check yes, but not in raid
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonNotInRaid
	end
	-- Dual spec check
	if (not self.spec2 and PowaAuras.ActiveTalentGroup == 2) or (not self.spec1 and PowaAuras.ActiveTalentGroup == 1) then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonNotForTalentSpec
	end
	-- Combat mode
	if (PowaAuras.WeAreInCombat == true and self.combat == false) or (PowaAuras.WeAreInCombat == false and self.combat == true) then
		if not giveReason then
			return false
		end
		if self.combat == true then
			return false, PowaAuras.Text.nomReasonNotInCombat
		end
		return false, PowaAuras.Text.nomReasonInCombat
	end
	if (PowaAuras.PvPFlagSet == 1 and self.PvP == false) or (PowaAuras.PvPFlagSet ~= 1 and self.PvP == true) then
		if not giveReason then
			return false
		end
		if self.PvP == true then
			return false, PowaAuras.Text.nomReasonPvPFlagNotSet
		end
		return false, PowaAuras.Text.nomReasonPvPFlagSet
	end
	if (PowaAuras.WeAreInRaid == true and self.inRaid == false) or (PowaAuras.WeAreInRaid == false and self.inRaid == true) then
		if not giveReason then
			return false
		end
		if self.inRaid == true then
			return false, PowaAuras.Text.nomReasonNotInRaid
		end
		return false, PowaAuras.Text.nomReasonInRaid
	end
	if (PowaAuras.WeAreInParty == true and self.inParty == false) or (PowaAuras.WeAreInParty == false and self.inParty == true) then
		if not giveReason then
			return false
		end
		if self.inParty == true then
			return false, PowaAuras.Text.nomReasonNotInParty
		end
		return false, PowaAuras.Text.nomReasonInParty
	end
	if (PowaAuras.WeAreMounted == true and self.ismounted == false) or (PowaAuras.WeAreMounted == false and self.ismounted == true) then
		if not giveReason then
			return false
		end
		if self.ismounted == true then
			return false, PowaAuras.Text.nomReasonNotMounted
		end
		return false, PowaAuras.Text.nomReasonMounted
	end
	if (PowaAuras.WeAreInVehicle == true and self.inVehicle == false) or (PowaAuras.WeAreInVehicle == false and self.inVehicle == true) then
		if not giveReason then
			return false
		end
		if self.inVehicle == true then
			return false, PowaAuras.Text.nomReasonNotInVehicle
		end
		return false, PowaAuras.Text.nomReasonInVehicle
	end
	if (PowaAuras.WeAreInPetBattle == true and self.inPetBattle == false) or (PowaAuras.WeAreInPetBattle == false and self.inPetBattle == true) then
		if not giveReason then
			return false
		end
		if self.inPetBattle == true then
			return false, PowaAuras.Text.nomReasonNotInPetBattle
		end
		return false, PowaAuras.Text.nomReasonInPetBattle
	end
	if self:AnyInstanceTypeChecksRequired() then
		local show, reason = self:CheckInstanceType(giveReason)
		if not show then
			return show, reason
		end
	end
	if not giveReason then
		return true
	end
	return true, PowaAuras.Text.nomReasonStateOK
end

function cPowaAura:AnyInstanceTypeChecksRequired()
	return self.InstanceScenario ~= 0 or self.InstanceScenarioHeroic ~= 0 or self.Instance5Man ~= 0 or self.Instance5ManHeroic ~= 0 or self.InstanceChallengeMode ~= 0 or self.Instance10Man ~= 0 or self.Instance10ManHeroic ~= 0 or self.Instance25Man ~= 0 or self.Instance25ManHeroic ~= 0 or self.InstanceFlexible ~= 0 or self.InstanceBg ~= 0 or self.InstanceArena ~= 0
end

function cPowaAura:CheckInstanceType(giveReason)
	if self.Debug then
		PowaAuras:DisplayText("Instance ", PowaAuras.Instance)
	end
	local show, reason, now, noShowReason
	local showTotal = true
	show, now, reason = self:ShouldShowForInstanceType("Scenario", giveReason)
	if now then
		return show, reason
	end
	if show == false then 
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("ScenarioHeroic", giveReason)
	if now then
		return show, reason
	end
	if show == false then 
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("5Man", giveReason)
	if now then
		return show, reason
	end
	if show == false then 
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("5ManHeroic", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("ChallangeMode", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("10Man", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("10ManHeroic", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("25Man", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("25ManHeroic", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("Flexible", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("Bg", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	show, now, reason = self:ShouldShowForInstanceType("Arena", giveReason)
	if now then
		return show, reason
	end
	if show == false then
		showTotal = false
	end
	if showTotal == false then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomNotInInstance
	end
	if not giveReason then
		return true
	end
	return true, PowaAuras.Text.nomReasonStateOK
end

function cPowaAura:ShouldShowForInstanceType(instanceType, giveReason)
	local flag = "Instance"..instanceType
	if self.Debug then
		PowaAuras:DisplayText(PowaAuras.Instance, " ", instanceType, " ", flag, " = ", self[flag])
	end
	if self[flag] == 0 then
		return
	end
	if self[flag] == true then
		if PowaAuras.Instance ~= instanceType then
			if not giveReason then
				return false, false
			end
			return false, false, PowaAuras.Text["nomReasonNotIn"..instanceType.."Instance"]
		end
		if not giveReason then
			return true, true
		end
		return true, true, PowaAuras.Text["nomReasonIn"..instanceType.."Instance"]
	end
	if PowaAuras.Instance == instanceType then
		if not giveReason then
			return false, true
		end
		return false, true, PowaAuras.Text["nomReasonIn"..instanceType.."Instance"]
	end
	if not giveReason then
		return true, false
	end
	return true, false, PowaAuras.Text["nomReasonNotIn"..instanceType.."Instance"]
end

function cPowaAura:ShouldShow(giveReason, reverse)
	self.DisplayValue = nil
	self.DisplayUnit = nil
	self.DisplayUnit2 = nil
	if PowaMisc.Disabled then
		return false, PowaAuras.Text.nomReasonDisabled
	end
	local stateResult, reason = self:CheckState(giveReason)
	if not stateResult then
		self.InactiveDueToState = true
		return stateResult, reason
	end
	self.InactiveDueToState = false
	local result, reason = self:CheckIfShouldShow(giveReason)
	if self.Debug then
		PowaAuras:DisplayText("ShouldShow result = ", result, " inv = ", self.inverse, " rev = ", reverse)
		PowaAuras:DisplayText("reason = ", reason)
	end
	if result == - 1 then
		return result, reason
	end
	if result ~= nil and (self.inverse or reverse) and not (self.inverse and reverse) then
		result = not result
		if giveReason then
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonInverted, reason)
		end
	end
	return result, reason
end

function cPowaAura:Display()
	PowaAuras:Message("Aura Display id = ", self.id)
	for k, v in pairs(self) do
		PowaAuras:Message(" "..tostring(k).." = "..tostring(v))
	end
end

function cPowaAura:GetFrame()
	if self.isSecondary then
		return PowaAuras.SecondaryFrames[self.id]
	end
	return PowaAuras.Frames[self.id]
end

function cPowaAura:GetModel()
	if self.isSecondary then
		return PowaAuras.SecondaryModels[self.id]
	end
	return PowaAuras.Models[self.id]
end

function cPowaAura:GetTexture()
	if self.isSecondary then
		return PowaAuras.SecondaryTextures[self.id]
	end
	return PowaAuras.Textures[self.id]
end

function cPowaAura:SetFrame(frame)
	if self.isSecondary then
		PowaAuras.SecondaryFrames[self.id] = frame
		return
	end
	PowaAuras.Frames[self.id] = frame
end

function cPowaAura:SetModel(model)
	if self.isSecondary then
		PowaAuras.SecondaryModels[self.id] = model
		return
	end
	PowaAuras.Models[self.id] = model
end

function cPowaAura:SetTexture(texture)
	if self.isSecondary then
		PowaAuras.SecondaryTextures[self.id] = texture
		return
	end
	PowaAuras.Textures[self.id] = texture
end

function cPowaAura:GetSpellFromMatch(spellMatch)
	local _, _, spellId = string.find(spellMatch, "%[(%d+)%]")
	if spellId then
		spellId = tonumber(spellId)
		local spellName, rank, spellIcon = GetSpellInfo(spellId)
		if rank then
			spellName = spellName.."("..rank..")"
		end
		return spellName, spellIcon, spellId
	end
	return spellMatch
end

function cPowaAura:SetStacks(text)
	local _, _, curStacksLower, curOperator, curStacks = string.find(text, "(%d*)(%D+)(%d*)")
	if curStacks == nil or curStacks == "" then
		curStacks = "0"
	end
	local stacks = tonumber(curStacks)
	PowaAuras:Debug(stacks)
	if stacks ~= self.stacks then
		if stacks < 0 then
			stacks = 0
		end
		self.stacks = stacks or 0
	end
	if curStacksLower == nil or curStacksLower == "" then
		curStacksLower = "0"
	end
	local stacksLower = tonumber(curStacksLower)
	PowaAuras:Debug(stacksLower)
	if stacksLower ~= self.stacksLower then
		if stacksLower < 0 or stacksLower > stacks then
			stacksLower = 0
		end
		self.stacksLower = stacksLower or 0
	end
	if curOperator ~= self.stacksOperator then
		if not PowaAuras.allowedOperators[curOperator] then
			curOperator = PowaAuras.DefaultOperator
		end
		self.stacksOperator = curOperator
	end
end

function cPowaAura:Trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function cPowaAura:MatchSpell(spellName, spellTexture, spellId, matchString)
	if not spellName or not matchString then
		return false
	end
	if matchString == "*" then
		return true
	end
	if self.Debug then
		PowaAuras:Message("SpellName = ", spellName, " Id = ", spellId)
		PowaAuras:Message("matchString = ", matchString)
	end 
	for pword in string.gmatch(matchString, "[^/]+") do
		pword = self:Trim(pword)
		if string.len(pword) > 0 then
			if self.Debug then
				PowaAuras:Message("Looking for ", pword)
			end
			local _
			local textToSearch
			local textureMatch
			local spellIdMatch
			local matchName
			if string.find(pword, "_") then
				_, _, textToSearch = string.find(spellTexture, "([%w_]*)$")
				matchName = pword
			else
				textToSearch = spellName
				matchName, textureMatch, spellIdMatch = self:GetSpellFromMatch(pword)
			end
			if not matchName then
				PowaAuras:DisplayText(PowaAuras:InsertText(PowaAuras.Text.nomUnknownSpellId, pword))
			else
				if spellIdMatch and spellId then
					if self.Debug then
						PowaAuras:Message("Check Spell Ids match spell = ", spellId, " looking for Id = ", spellIdMatch, " found = ", (spellIdMatch == spellId))
					end
					if spellIdMatch == spellId then
						return true
					end
				end
				if matchName and (not textureMatch or textureMatch == spellTexture) then
					if textToSearch then
						if self.ignoremaj then
							textToSearch = string.upper(textToSearch)
							matchName = string.upper(matchName)
						end
						if self.Debug then
							PowaAuras:Message("matchName = "..tostring(matchName).."<<")
							PowaAuras:Message("search = "..tostring(textToSearch).."<<")
						end
						if self.exact then
							if self.Debug then
								PowaAuras:Message("exact = ", (textToSearch == matchName))
							end
							if textToSearch == matchName then
								return true
							end
						else
							if self.Debug then
								PowaAuras:Message("find = ", string.find(textToSearch, matchName, 1, true))
							end
							if string.find(textToSearch, matchName, 1, true) then
								return true
							end
						end
					end
				end
			end
		end
	end
	return nil
end

function cPowaAura:MatchText(textToSearch, textToFind)
	if textToSearch == nil or textToFind == nil then
		return false
	end
	if textToFind == "*" then
		return true
	end
	if self.Debug then
		PowaAuras:Message("TextToSearch = ", textToSearch," textToFind = ", textToFind)
	end
	if self.ignoremaj then
		textToFind = string.upper(textToFind)
		textToSearch = string.upper(textToSearch)
	end
	if self.Debug then
		PowaAuras:Message("TextToSearch = ", textToSearch," textToFind = ", textToFind, " ignoremaj = ", self.ignoremaj, " exact = ", self.exact)
	end
	for pword in string.gmatch(textToFind, "[^/]+") do
		if self.Debug then
			PowaAuras:Message("pword = ", pword," find = ", string.find(textToSearch, pword, 1, true))
		end
		if self.exact and textToSearch == textToFind then
			return true
		elseif string.find(textToSearch, pword, 1, true) then
			return true
		end
	end
	return nil
end

function cPowaAura:CreateAuraString(keepLink)
	local tempstr = "Version:"..PowaMisc.Version.."; "
	local varpref = ""
	for k, default in pairs(self.ExportSettings) do
		-- This must be ~= nil!
		if self[k] ~= nil then
			local v = self[k]
			-- Multi condition checks not supported for single export.
			if k == "multiids" and not keepLink then
				v = ""
			end
			if k == "icon" and string.find(string.lower(v), string.lower(PowaAuras.IconSource), 1, true) == 1 then
				v = string.sub(v, string.len(PowaAuras.IconSource) + 1)
			end
			tempstr = tempstr..PowaAuras:GetSettingForExport("", k, v, default)
		end
	end
	if self.Timer and self.Timer.enabled then
		tempstr = tempstr..self.Timer:CreateAuraString()
	end
	if self.Stacks and self.Stacks.enabled then
		tempstr = tempstr..self.Stacks:CreateAuraString()
	end
	if tempstr and tempstr ~= "" then
		tempstr = self:Trim(tempstr)
		tempstr = string.sub(tempstr, 1, string.len(tempstr) - 1)
	end
	PowaAuras:Debug("Aura-string length: "..tostring(string.len(tempstr)))
	return tempstr
end

function cPowaAura:GetUnit()
	if self.focus then
		return "focus"
	elseif self.party then
		return "party"
	elseif self.raid then
		return "raid"
	elseif self.groupOrSelf then
		return "groupOrSelf"
	elseif self.optunitn then
		return self.unitn
	elseif self.target or self.targetfriend then
		return "target"
	end
	return "player"
end

function cPowaAura:GetExtendedUnit()
	if (self.raid or self.party or self.groupOrSelf) and (self.target or self.targetfriend) then
		return "target"
	end
	return ""
end

function cPowaAura:CorrectTargetType(unit)
	if not UnitExists(unit) or UnitIsDead(unit) then
		return false, "No target"
	end
	if not self.target and not self.targetfriend then
		return true, "Target Not required"
	end
	if self.target and self.targetfriend then
		return true, "Either Target OK"
	end
	if self.target then
		if UnitCanAttack(unit, "player") then
			return true, "Enemy"
		end
		return false, "Not Attackable"
	end
	if UnitIsFriend(unit, "player") then
		return true, "Friendly"
	end
	return false, "Enemy"
end

function cPowaAura:CheckAllUnits(giveReason)
	local unit = self:GetUnit()
	local postfix = self:GetExtendedUnit()
	if self.Debug then
		PowaAuras:DisplayText("on unit "..unit..postfix)
	end
	local numpm = GetNumSubgroupMembers()
	local numrm = GetNumGroupMembers()
	if not IsInRaid() then
		numrm = 0
	end
	local result
	if unit == "party" or unit == "raid" or unit == "groupOrSelf" then
		if unit == "party" then
			for pm = 1, numpm do
				local groupUnit = "party"..pm..postfix
				result = self:CheckUnit(groupUnit)
				if result then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, groupUnit, self.buffname, self:DisplayType())
				end
			end
		elseif unit == "raid" then
			for rm = 1, numrm do
				local groupUnit = "raid"..rm..postfix
				result = self:CheckUnit(groupUnit)
				if result then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, groupUnit, self.buffname, self:DisplayType())
				end
			end
		elseif unit == "groupOrSelf" then
			if numrm > 0 then
				for rm = 1, numrm do
					local groupUnit = "raid"..rm..postfix
					result = self:CheckUnit(groupUnit)
					if result then
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, groupUnit, self.buffname, self:DisplayType())
					end
				end
			elseif numpm > 0 then
				for pm = 1, numpm do
					local groupUnit = "party"..pm..postfix
					result = self:CheckUnit(groupUnit)
					if result then
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, groupUnit, self.buffname, self:DisplayType())
					end
				end
				local playerUnit = postfix
				if playerUnit == nil or playerUnit == "" then
					playerUnit = "player"
				end
				result = self:CheckUnit(playerUnit)
				if result then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, playerUnit, self.buffname, self:DisplayType())
				end
			else
				local playerUnit = postfix
				if playerUnit == nil or playerUnit == "" then
					playerUnit = "player"
				end
				result = self:CheckUnit(playerUnit)
				if result then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, playerUnit, self.buffname, self:DisplayType())
				end
			end
		end
		if self.target then -- Check any nearby hostiles that may not be targeted
			for unit in pairs(PowaAuras.ExtraUnitEvent) do
				result = self:CheckUnit(unit)
				if result then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, unit, self.buffname, self:DisplayType())
				end
			end
		end
	else
		result = self:CheckUnit(unit..postfix)
		if result then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].MatchReason, unit..postfix, self.buffname, self:DisplayType())
		end
	end
	if not giveReason then
		return false
	end
	if result == nil and PowaAuras.Text.ReasonStat[self.ValueName].NilReason then
		return false, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].NilReason, unit..postfix, self.buffname, self:DisplayType())
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.ReasonStat[self.ValueName].NoMatchReason, unit..postfix, self.buffname, self:DisplayType())
end

function cPowaAura:CheckStacks(count)
	local operator = self.stacksOperator or PowaAuras.DefaultOperator
	local stacks = self.stacks or 0
	local stacksLower = self.stacksLower or 0
	PowaAuras:Debug("Stack op = ", operator," stacks = ", stacks,"Stack Count = ", count)
	return (operator == "=" and stacks == 0) or (operator == ">=" and count >= stacks) or (operator == "<=" and count <= stacks) or (operator == ">" and count > stacks) or (operator == "<" and count < stacks) or (operator == "=" and count == stacks) or (operator == "-" and count >= stacksLower and count <= stacks) or (operator == "!" and count ~= stacks)
end

function cPowaAura:StacksText()
	local stacksText = self.stacksOperator..tostring(self.stacks)
	if self.stacksOperator == "-" then
		stacksText = tostring(self.stacksLower)..stacksText
	end
	return stacksText
end

function cPowaAura:CheckTimerInvert()
	if PowaAuras.ModTest or self.InvertAuraBelow == nil or self.InvertAuraBelow == 0 or self.InvertTest then
		return
	end
	local timeValue = 0
	if self.Timer.DurationInfo and self.Timer.DurationInfo > 0 then
		timeValue = math.max(self.Timer.DurationInfo - GetTime(), 0)
	end
	if PowaAuras.DebugCycle then
		PowaAuras:DisplayText("Id = ", self.id)
		PowaAuras:DisplayText("TimeValue = ", timeValue)
		PowaAuras:DisplayText("InvertAuraBelow = ", self.InvertAuraBelow)
		PowaAuras:DisplayText("ForceTimeInvert = ", self.ForceTimeInvert)
		PowaAuras:DisplayText("InvertTimeHides = ", self.InvertTimeHides)
	end
	local oldForceTimeInvert = self.ForceTimeInvert
	if timeValue and timeValue > 0 and (not self.InvertTimeHides and timeValue <= self.InvertAuraBelow) or (self.InvertTimeHides and timeValue >= self.InvertAuraBelow) then
		self.ForceTimeInvert = true
	else
		self.ForceTimeInvert = nil
	end
	if oldForceTimeInvert ~= self.ForceTimeInvert then
		self.InvertTest = true -- To prevent infinite loop
		PowaAuras:TestThisEffect(self.id)
		self.InvertTest = nil
	end
end

function cPowaAura:RoleCheckRequired()
	return self.RoleTank ~= 0 or self.RoleHealer ~= 0 or self.RoleMeleDps ~= 0 or self.RoleRangeDps ~= 0
end

function cPowaAura:CheckRole(unit, giveReason)
	local role, source = PowaAuras:DetermineRole(unit)
	local show, reason, noShowReason
	show, reason = self:ShouldShowForRole(role, "RoleTank", giveReason)
	if show then
		return show, reason
	end
	if show ~= nil and noShowReason == nil then
		noShowReason = reason
	end
	show, reason = self:ShouldShowForRole(role, "RoleHealer", giveReason)
	if show then
		return show, reason
	end
	if show ~= nil and noShowReason == nil then
		noShowReason = reason
	end
	show, reason = self:ShouldShowForRole(role, "RoleMeleDps", giveReason)
	if show then
		return show, reason
	end
	if show ~= nil and noShowReason == nil then
		noShowReason = reason
	end
	show, reason = self:ShouldShowForRole(role, "RoleRangeDps", giveReason)
	if show then
		return show, reason
	end
	if show ~= nil and noShowReason == nil then
		noShowReason = reason
	end
	if not giveReason then
		return false
	end
	return false, noShowReason
end

function cPowaAura:ShouldShowForRole(role, flag, giveReason)
	if self[flag] == 0 then
		return
	end
	if role == nil then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonRoleUnknown
	end
	if self[flag] == true then
		if role ~= flag then
			if not giveReason then
				return false
			end
			return false, PowaAuras.Text.nomReasonNotRole[flag]
		end
		if not giveReason then
			return true
		end
		return true, PowaAuras.Text.nomReasonRole[flag]
	end
	if role == flag then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonRole[flag]
	end
	if not giveReason then
		return true
	end
	return true, PowaAuras.Text.nomReasonNotRole[flag]
end

cPowaBuffBase = PowaClass(cPowaAura, {CanHaveTimer = true, CanHaveStacks = true, CanHaveInvertTime = true, InvertTimeHides = true})

function cPowaBuffBase:AddEffectAndEvents()
	PowaAuras.Events.UNIT_AURA = true
	PowaAuras.Events.UNIT_AURASTATE = true
	if not self.target and not self.targetfriend and not self.party and not self.raid and not self.groupOrSelf and not self.focus and not self.optunitn then -- Self buffs
		table.insert(PowaAuras.AurasByType.Buffs, self.id)
	end
	if self.party then -- Party buffs
		table.insert(PowaAuras.AurasByType.PartyBuffs, self.id)
	end
	if self.focus then -- Focus buffs
		table.insert(PowaAuras.AurasByType.FocusBuffs, self.id)
		PowaAuras.Events.PLAYER_FOCUS_CHANGED = true
	end
	if self.raid then -- Raid buffs
		table.insert(PowaAuras.AurasByType.RaidBuffs, self.id)
	end
	if self.groupOrSelf then -- Group or self buffs
		table.insert(PowaAuras.AurasByType.GroupOrSelfBuffs, self.id)
	end
	if self.optunitn then -- Unit buffs
		table.insert(PowaAuras.AurasByType.UnitBuffs, self.id)
	end
	if self.target or self.targetfriend then -- Target buffs
		table.insert(PowaAuras.AurasByType.TargetBuffs, self.id)
		PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	end
end

function cPowaBuffBase:IsPresent(unit, s, giveReason, textToCheck)
	if self.Debug then
		PowaAuras:DisplayText("IsPresent on ", unit," buffid = ", s," type = ", self.buffAuraType)
	end
	local _, auraName, auraTexture, count, expirationTime, caster, auraId
	if string.find(textToCheck, "%\[") or string.find(textToCheck, "%\]") then
		textToCheck = strtrim(textToCheck, "%\[%\]")
	end
	if self.exact and not tonumber(textToCheck) then
		auraName, _, auraTexture, count, _, _, expirationTime, caster, _, _, auraId = UnitAura(unit, textToCheck, nil, self.buffAuraType)
	else
		auraName, _, auraTexture, count, _, _, expirationTime, caster, _, _, auraId = UnitAura(unit, s, self.buffAuraType)
	end
	if auraName == nil then
		return nil
	end
	PowaAuras:Debug("Aura = ", auraName," count = ", count," expirationTime = ", expirationTime," caster = ", caster)
	if self.Debug then
		PowaAuras:DisplayText("Aura = ", auraName," count = ", count," expirationTime = ", expirationTime," caster = ", caster)
	end
	if self.tooltipCheck and string.len(self.tooltipCheck) ~= 0 then
		if not self:CompareAura(unit, s, auraName, auraTexture, auraId, textToCheck) then
			PowaAuras:Debug("CompareAura not found")
			if self.Debug then
				PowaAuras:DisplayText("CompareAura not found")
			end
			self.DisplayValue = textToCheck
			self.DisplayUnit = unit
			return false
		end
	end
	if self.ignoremaj then
		if self.exact then
			if string.upper(auraName) ~= string.upper(textToCheck) and auraId ~= tonumber(textToCheck) then
				return false
			end
		else
			if string.upper(auraName) ~= string.upper(textToCheck) and auraId ~= tonumber(textToCheck) and not string.find(string.upper(auraName), string.upper(textToCheck)) then
				return false
			end
		end
	else
		if self.exact then
			if auraName ~= textToCheck and auraId ~= tonumber(textToCheck) then
				return false
			end
		else
			if auraName ~= textToCheck and auraId ~= tonumber(textToCheck) and not string.find(auraName, textToCheck) then
				return false
			end
		end
	end
	if self.Debug then
		PowaAuras:DisplayText("Present!")
	end
	local isMine = caster ~= nil and UnitExists(caster) and UnitIsUnit("player", caster)
	if self.mine and not isMine then
		if not giveReason then
			return nil
		end
		return nil, PowaAuras.Text.nomReasonBuffPresentNotMine
	end
	if not self:CheckStacks(count) then
		if giveReason then
			return nil, PowaAuras:InsertText(PowaAuras.Text.nomReasonStacksMismatch, count, self:StacksText())
		end
		return nil
	end
	self.DisplayValue = auraName
	self.DisplayUnit = unit
	if self.Stacks then
		self.Stacks:SetStackCount(count)
	end
	if self.Timer then
		self.Timer:SetDurationInfo(expirationTime)
		self:CheckTimerInvert()
		if self.ForceTimeInvert then
			if not giveReason then
				return false
			end
			return false, PowaAuras.Text.nomReasonBuffPresentTimerInvert
		end
	end
	self:UpdateText()
	self:SetIcon(auraTexture)
	if giveReason then
		return true, PowaAuras.Text.nomReasonBuffFound
	end
	return true
end

function cPowaBuffBase:CheckTooltip(text, target, index)
	if not text or string.len(text) == 0 then
		return true
	end
	PowaAuras:Debug("Search in tooltip for ", text)
	PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	PowaAuras_Tooltip:SetUnitAura(target, index, self.buffAuraType)
	for z = 1, PowaAuras_Tooltip:NumLines() do
		local textlinel = _G["PowaAuras_TooltipTextLeft"..z]
		local textl = textlinel:GetText()
		local tooltipText = ""
		if textl then
			tooltipText = tooltipText..textl
		end
		local textliner = _G["PowaAuras_TooltipTextRight"..z]
		local textr = textliner:GetText()
		if textr then
			tooltipText = tooltipText..textr
		end
		if tooltipText ~= "" then
			if string.find(tooltipText, text, 1, true) then
				PowaAuras_Tooltip:Hide()
				return true
			end
		end
	end
	PowaAuras_Tooltip:Hide()
	return false
end

function cPowaBuffBase:CompareAura(target, z, auraName, auraTexture, auraId, textToCheck)
	PowaAuras:Debug("CompareAura", z," ", auraName, auraTexture)
	if self.Debug then
		PowaAuras:DisplayText("CompareAura", z," ", auraName, " ", auraTexture)
	end
	if not self:CheckTooltip(self.tooltipCheck, target, z) then
		return false
	end
	self:SetIcon(auraTexture)
	return true
end

function cPowaBuffBase:CheckAllAuraSlots(target, giveReason)
	if self.Debug then
		PowaAuras:DisplayText("CheckAllAuraSlots for ", target, " reason=", giveReason)
	end
	local present, reason
	if self:RoleCheckRequired() then
		if not PowaAuras.WeAreInRaid and not PowaAuras.WeAreInParty then
			return false, PowaAuras.Text.nomReasonNotInGroup
		end
		present, reason = self:CheckRole(target, giveReason)
		if not present then
			return present, reason
		end
	end
	local startFrom = 1
	if self.CurrentSlot and self.CurrentMatch then
		if self.Debug then
			PowaAuras:DisplayText("Buff for current slot (", self.CurrentSlot, ")")
		end
		present, reason = self:IsPresent(target, self.CurrentSlot, giveReason, self.CurrentMatch)
		if present then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffPresent, target, self.OptionText.typeText, self.buffname)
		end
		startFrom = self.CurrentSlot
		self.CurrentSlot = nil
		self.CurrentMatch = nil
	end
	if not startFrom then
		startFrom = 1
	end
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if self.Debug then
			PowaAuras:DisplayText("Check Auras for >>", pword, "<<")
		end
		for i = startFrom - 1, 1, - 1 do
			if self.Debug then
				PowaAuras:DisplayText("Down (", i, ")")
			end
			present, reason = self:IsPresent(target, i, giveReason, pword)
			if present then
				if self.Debug then
					PowaAuras:DisplayText("Found ", i)
				end
				self.CurrentSlot = i
				self.CurrentMatch = pword
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffPresent, target, self.OptionText.typeText, self.buffname)
			end
		end
		for i = startFrom, 40 do
			if self.Debug then
				PowaAuras:DisplayText("Up (", i, ")")
			end
			present, reason = self:IsPresent(target, i, giveReason, pword)
			if present == nil then
				break
			end
			if present then
				if self.Debug then
					PowaAuras:DisplayText("Found ", i)
				end
				self.CurrentSlot = i
				self.CurrentMatch = pword
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffPresent, target, self.OptionText.typeText, self.buffname)
			end
		end
	end
	if present == nil then
		if not giveReason then
			return false
		end
		if reason then
			return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffFoundButIncomplete, target, self.OptionText.typeText, self.buffname, reason)
		end
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffMissing, target, self.OptionText.typeText, self.buffname)
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonBuffMissing, target, self.OptionText.typeText, self.buffname)
end

function cPowaBuffBase:CheckSingleUnit(group, unit, giveReason)
	if not unit then
		return
	end
	if self.Debug then
		PowaAuras:DisplayText("CheckSingleUnit ", unit)
	end
	local present, reason = self:CheckAllAuraSlots(unit, giveReason)
	if present then
		if self.groupany == true then
			self.CurrentUnit = unit
			if self.Debug then
				PowaAuras:DisplayText("CheckSingleUnit ", unit, " Present!")
			end
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonOneInGroupHasBuff, unit, self.OptionText.typeText, self.buffname)
		end
	elseif self.groupany == false then
		if not giveReason then
			return false
		end
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNotAllInGroupHaveBuff, group, self.OptionText.typeText, self.buffname)
	end
end

function cPowaBuffBase:CheckGroup(group, count, giveReason)
	if self.Debug then
		PowaAuras:DisplayText("CheckGroup ", group, " ", count, " ", self.CurrentUnit)
	end
	local show, reason = self:CheckSingleUnit(group, self.CurrentUnit, giveReason)
	if show ~= nil then
		if self.Debug then
			PowaAuras:DisplayText("buff for existing unit (", self.CurrentUnit, ") found")
		end
		return show, reason
	end
	self.CurrentSlot = nil
	if not PowaAuras:TableEmpty(PowaAuras.ChangedUnits.Buffs) and self.groupany == true then
		for unit in pairs(PowaAuras.ChangedUnits.Buffs) do
			if self.Debug then
				PowaAuras:DisplayText("Detected buff change in unit ", unit)
			end
			if unit ~= self.CurrentUnit and string.find(unit, group, 1, true) then
				show, reason = self:CheckSingleUnit(group, unit, giveReason)
				if show ~= nil then
					return show, reason
				end
			end
		end
	else
		for groupId = 1, count do
			local unit = group..groupId
			if unit ~= self.CurrentUnit then
				show, reason = self:CheckSingleUnit(group, unit, giveReason)
				if show ~= nil then
					return show, reason
				end
			end
		end
	end
	if self.groupany == false then
		if not giveReason then
			return true
		end
		return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonAllInGroupHaveBuff, group, self.OptionText.typeText, self.buffname)
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNoOneInGroupHasBuff, group, self.OptionText.typeText, self.buffname)
end

function cPowaBuffBase:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check " .. self.buffAuraType .. " aura")
	if self.Debug then
		PowaAuras:DisplayText("Check " .. self.buffAuraType .. " aura ", self.Id)
	end
	-- Targets
	if self.target or self.targetfriend then
		if self.Debug then
			PowaAuras:DisplayText("Target ", self.target," ", self.targetfriend)
		end
		return self:CheckAllAuraSlots("target", giveReason)
	end
	-- Focus buff
	if self.focus then
		if self.Debug then
			PowaAuras:DisplayText("Focus ", self.focus)
		end
		return self:CheckAllAuraSlots("focus", giveReason)
	end
	-- Unit buff
	if self.optunitn then
		if self.Debug then
			PowaAuras:DisplayText("Named unit ", self.unitn)
		end
		return self:CheckAllAuraSlots(self.unitn, giveReason)
	end
	local numpm = GetNumSubgroupMembers()
	local numrm = GetNumGroupMembers()
	if not IsInRaid() then
		numrm = 0
	end
	-- Raid buff
	if self.raid then
		if self.Debug then
			PowaAuras:DisplayText("Raid ", self.raid)
		end
		return self:CheckGroup("raid", numrm, giveReason)
	end
	-- Party buff
	if self.party then
		if self.Debug then
			PowaAuras:DisplayText("Party ", self.party)
		end
		return self:CheckGroup("party", numpm, giveReason)
	end
	-- Group or Self buff
	if self.groupOrSelf then
		if self.Debug then
			PowaAuras:DisplayText("Group or Self ", numrm, " ", numpm)
		end
		if numrm > 0 then
			return self:CheckGroup("raid", numrm, giveReason) -- Includes player
		end
		if numpm > 0 then
			local presentOnSelf, reason = self:CheckAllAuraSlots("player", giveReason)
			if presentOnSelf and self.groupany then
				if not giveReason then
					return true
				end
				return true, reason
			end
			if not presentOnSelf and not self.groupany then
				if not giveReason then
					return false
				end
				return false, reason
			end
			return self:CheckGroup("party", numpm, giveReason)
		end
		return self:CheckAllAuraSlots("player", giveReason)
	end
	-- Player buff
	if self.Debug then
		PowaAuras:DisplayText("on player")
	end
	PowaAuras:Debug("on player")
	return self:CheckAllAuraSlots("player", giveReason)
end

function cPowaBuffBase:ShowTimerDurationSlider()
	return self.target or self.targetfriend or self.party or self.focus or self.raid or self.optunitn
end

-- Buff
cPowaBuffBase.ShowOptions = {["PowaBarBuffStacks"] = 1, ["PowaGroupAnyButton"] = 1, ["PowaBarTooltipCheck"] = 1}
cPowaBuffBase.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaPartyButton"] = 1, ["PowaFocusButton"] = 1, ["PowaRaidButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaGroupAnyButton"] = 1, ["PowaOptunitnButton"] = 1, ["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1, ["PowaRoleTankButton"] = 1, ["PowaRoleHealerButton"] = 1, ["PowaRoleMeleDpsButton"] = 1, ["PowaRoleRangeDpsButton"] = 1}
cPowaBuff = PowaClass(cPowaBuffBase, {buffAuraType = "HELPFUL", AuraType = "Buff"})
cPowaBuff.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Buff], mineText = PowaAuras.Text.nomMine, mineTooltip = PowaAuras.Text.aideMine, targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaBuff.TooltipOptions = {r = 0.0, g = 1.0, b = 1.0, showBuffName = true, stacksColour = {r = 0.7, g = 1.0, b = 0.7}}

-- Type buff
cPowaTypeBuff = PowaClass(cPowaBuffBase, {buffAuraType = "HELPFUL", AuraType = "Buff Type"})
cPowaTypeBuff.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff3, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.TypeBuff], mineText = PowaAuras.Text.nomDispellable, mineTooltip = PowaAuras.Text.aideDispellable, targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaTypeBuff.ShowOptions = {["PowaGroupAnyButton"] = 1, ["PowaBarTooltipCheck"] = 1}
cPowaTypeBuff.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaPartyButton"] = 1, ["PowaFocusButton"] = 1, ["PowaRaidButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaGroupAnyButton"] = 1, ["PowaOptunitnButton"] = 1, ["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaTypeBuff.TooltipOptions = {r = 0.8, g = 1.0, b = 0.8, showBuffName = true}

function cPowaTypeBuff:IsPresent(target, z)
	local removeable
	if self.mine then
		removeable = 1
	end
	local name, _, texture, count, typeBuff, _, expirationTime, _, _, _, spellId = UnitBuff(target, z, removeable)
	if not name or not spellId then
		return nil
	end
	if self.Debug then
		PowaAuras:Message("TypeBuff = ", name, "Spellid = ", spellId, " IsPresent on ", target," buffid = ", z," removeable = ", removeable)
	end
	self.DisplayUnit = target
	if self.mine and typeBuff == nil then
		self.DisplayValue = name
		return false
	end
	if typeBuff == nil or typeBuff == "" then
		PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		PowaAuras_Tooltip:SetUnitAura(target, z, self.buffAuraType)
		if PowaAuras_Tooltip:NumLines() >= 1 then
			typeBuff = (PowaAuras_TooltipTextRight1 and PowaAuras_TooltipTextRight1:GetText() or "")
		end
		PowaAuras_Tooltip:Hide()
	end
	local typeBuffName
	if typeBuff ~= nil then
		typeBuffName = PowaAuras.Text.DebuffType[typeBuff]
	end
	local typeBuffCatName = PowaAuras.Text.DebuffCatType[PowaAuras.DebuffTypeSpellIds[tonumber(spellId)]]
	if typeBuffName == nil and typeBuffCatName == nil then
		typeBuffName = PowaAuras.Text.aucun
	end
	if self.Debug then
		PowaAuras:Message("typeBuffName = ", typeBuffName, " typeBuffCatName = ", typeBuffCatName," self.buffname = ", self.buffname)
	end
	if self:MatchText(typeBuffName, self.buffname) or self:MatchText(typeBuffCatName, self.buffname) then
		self.DisplayValue = name
		if self.Stacks then
			self.Stacks:SetStackCount(count)
		end
		self:SetIcon(texture)
		if self.Timer then
			self.Timer:SetDurationInfo(expirationTime)
			self:CheckTimerInvert()
			if self.ForceTimeInvert then
				return false
			end
		end
		return true
	end
	self.DisplayValue = self.buffname
	return false
end

-- Debuff
cPowaDebuff = PowaClass(cPowaBuffBase, {buffAuraType = "HARMFUL", AuraType = "Debuff"})
cPowaDebuff.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff2, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Debuff], mineText = PowaAuras.Text.nomMine, mineTooltip = PowaAuras.Text.aideMine, targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaDebuff.TooltipOptions = {r = 1.0, g = 0.8, b = 0.8, showBuffName = true, stacksColour = {r = 1.0, g = 0.7, b = 0.7}}

-- Type debuff
cPowaTypeDebuff = PowaClass(cPowaBuffBase, {buffAuraType = "HARMFUL", AuraType = "Debuff Type"})
cPowaTypeDebuff.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff3, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.TypeDebuff], mineText = PowaAuras.Text.nomDispellable, mineTooltip = PowaAuras.Text.aideDispellable, targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaTypeDebuff.ShowOptions = {["PowaGroupAnyButton"] = 1, ["PowaBarTooltipCheck"] = 1}
cPowaTypeDebuff.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaPartyButton"] = 1, ["PowaFocusButton"] = 1, ["PowaRaidButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaGroupAnyButton"] = 1, ["PowaOptunitnButton"] = 1, ["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaTypeDebuff.TooltipOptions = {r = 0.8, g = 1.0, b = 0.8, showBuffName = true}

function cPowaTypeDebuff:IsPresent(target, z)
	local removeable
	if self.mine then
		removeable = 1
	end
	local name, _, texture, count, typeDebuff, _, expirationTime, _, _, _, spellId = UnitDebuff(target, z, removeable)
	if not name or not spellId then
		return nil
	end
	if self.Debug then
		PowaAuras:Message("TypeDebuff ", name, "Spellid = ", spellId, " IsPresent on ", target," buffid ", z," removeable ", removeable)
	end
	self.DisplayUnit = target
	if self.mine and typeDebuff == nil then
		self.DisplayValue = name
		return false
	end
	if typeDebuff == nil or typeDebuff == "" then
		PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
		PowaAuras_Tooltip:SetUnitAura(target, z, self.buffAuraType)
		if PowaAuras_Tooltip:NumLines() >= 1 then
			typeDebuff = (PowaAuras_TooltipTextRight1 and PowaAuras_TooltipTextRight1:GetText() or "")
		end
		PowaAuras_Tooltip:Hide()
	end
	local typeDebuffName
	if typeDebuff ~= nil then
		typeDebuffName = PowaAuras.Text.DebuffType[typeDebuff]
	end
	local typeDebuffCatName = PowaAuras.Text.DebuffCatType[PowaAuras.DebuffTypeSpellIds[tonumber(spellId)]]
	if typeDebuffName == nil and typeDebuffCatName == nil then
		typeDebuffName = PowaAuras.Text.aucun
	end
	if self.Debug then
		PowaAuras:Message("typeDebuffName ", typeDebuffName, " typeDebuffCatName ", typeDebuffCatName," self.buffname ", self.buffname)
	end
	if self:MatchText(typeDebuffName, self.buffname) or self:MatchText(typeDebuffCatName, self.buffname) then
		self.DisplayValue = name
		if self.Stacks then
			self.Stacks:SetStackCount(count)
		end
		self:SetIcon(texture)
		if self.Timer then
			self.Timer:SetDurationInfo(expirationTime)
			self:CheckTimerInvert()
			if self.ForceTimeInvert then
				return false
			end
		end
		return true
	end
	self.DisplayValue = self.buffname
	return false
end

-- Special spell
cPowaSpecialSpellBase = PowaClass(cPowaBuffBase, {buffAuraType = "HARMFUL", target = true, CanHaveTimer = true, CanHaveTimerOnInverse = false, CanHaveStacks = true, CanHaveInvertTime = true})
cPowaSpecialSpellBase.ShowOptions = {["PowaBarTooltipCheck"] = 1}
cPowaSpecialSpellBase.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaFocusButton"] = 1, ["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}

function cPowaSpecialSpellBase:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check if target/focus for ", self.buffname)
	if self.Debug then
		PowaAuras:DisplayText("Buffname = ", self.buffname, " target = ", self.target, " focus = ", self.focus)
	end
	if self.target or self.focus then
		-- Check self target/focus first
		if self.target and self:CheckUnit("target", "player") then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text["nomReason"..self.AuraType.."Present"], PowaAuras.Text.nomCheckTarget, self.buffname)
		end
		if self.focus and self:CheckUnit("focus", "player") then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text["nomReason"..self.AuraType.."Present"], PowaAuras.Text.nomCheckFocus, self.buffname)
		end
		if not giveReason then
			return false
		end
		return false, PowaAuras:InsertText(PowaAuras.Text["nomReasonNo"..self.AuraType.."Present"], self.buffname)
	end
	if #PowaAuras.ChangedUnits.Targets > 0 then
		if self.Debug then
			PowaAuras:Message(self.AuraType, "TargetCount = ", #PowaAuras.ChangedUnits.Targets)
		end	
		for unit, targetOf in pairs(PowaAuras.ChangedUnits.Targets) do
			if self:CheckUnit(unit, targetOf) then
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text["nomReason"..self.AuraType.."Present"], unit, self.buffname)
			end
		end
		return nil
	end
	-- Scan all raid targets
	local numrm = GetNumGroupMembers()
	if not IsInRaid() then
		numrm = 0
	end
	if numrm > 0 then
		for i = 1, numrm do
			if self:CheckUnit("raid"..i.."target", "raid"..i) then
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text["nomReasonRaidTarget"..self.AuraType.."Present"], i, self.buffname)
			end
		end
	else
		if self:CheckUnit("target", "player") then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text["nomReason"..self.AuraType.."Present"], PowaAuras.Text.nomCheckTarget, self.buffname)
		end
		-- Scan party targets
		local numpm = GetNumSubgroupMembers()
		if numpm > 0 then
			for i = 1, numpm do
				if self:CheckUnit("party"..i.."target", "party"..i) then
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text["nomReasonPartyTarget"..self.AuraType.."Present"], i, self.buffname)
				end
			end
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text["nomReasonNo"..self.AuraType.."Present"], self.buffname)
end

function cPowaSpecialSpellBase:AddEffectAndEvents()
	PowaAuras.Events.UNIT_AURA = true
	PowaAuras.Events.UNIT_AURASTATE = true
	if not self.target and not self.focus then -- Any enemy casts
		table.insert(PowaAuras.AurasByType[self.AuraType.."Spells"], self.id)
		PowaAuras.Events.UNIT_TARGET = true
	end
	if self.target then -- Target casts
		table.insert(PowaAuras.AurasByType[self.AuraType.."TargetSpells"], self.id)
		PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	end
	if self.focus then -- Focus casts
		table.insert(PowaAuras.AurasByType[self.AuraType.."FocusSpells"], self.id)
		PowaAuras.Events.PLAYER_FOCUS_CHANGED = true
	end
end

-- Stealable spell
cPowaStealableSpell = PowaClass(cPowaSpecialSpellBase, {AuraType = "Stealable"})
cPowaStealableSpell.OptionText = {buffNameTooltip = PowaAuras.Text.aideStealableSpells, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.StealableSpell]}
cPowaStealableSpell.TooltipOptions = {r = 0.8, g = 0.8, b = 0.2, showBuffName = true}

function cPowaStealableSpell:CheckUnit(unit, targetOf)
	local show, reason = self:CorrectTargetType(unit)
	if not show then
		if self.Debug then
			PowaAuras:Message("CheckUnit = ", unit, " won't show because unit ", reason)
		end
		return false
	end
	self.DisplayUnit = unit
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if self.Debug then
			PowaAuras:Message("Match = ", pword)
		end
		for i = 1, 40 do
			local auraName, _, auraTexture, count, typeDebuff, _, expirationTime, _, isStealable, _, auraId = UnitAura(unit, i)
			if self.Debug then
				PowaAuras:Message("Slot = ", i, " auraName = ", auraName, " (", auraId, ")" )
			end
			if auraName == nil then
				return nil
			end
			if isStealable and self:CompareAura(unit, i, auraName, auraTexture, auraId, pword) then
				if self.Stacks then
					self.Stacks:SetStackCount(count)
				end
				self.DisplayValue = auraName
				self.DisplayUnit = unit
				self.DisplayUnit2 = targetOf
				self:UpdateText()
				if self.Timer then
					self.Timer:SetDurationInfo(expirationTime)
					self:CheckTimerInvert()
					if self.ForceTimeInvert then
						return false
					end
				end
				return true
			end
		end
	end
	self.DisplayValue = self.buffname
	self:UpdateText()
	return false
end

-- Purgeable Spell
cPowaPurgeableSpell = PowaClass(cPowaSpecialSpellBase, {AuraType = "Purgeable"})
cPowaPurgeableSpell.OptionText = {buffNameTooltip = PowaAuras.Text.aidePurgeableSpells, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.PurgeableSpell]}
cPowaPurgeableSpell.TooltipOptions = {r = 0.2, g = 0.8, b = 0.2, showBuffName = true}

function cPowaPurgeableSpell:CheckUnit(unit, targetOf)
	local show, reason = self:CorrectTargetType(unit)
	if not show then
		if self.Debug then
			PowaAuras:Message("CheckUnit = ", unit, " won't show because unit ", reason)
		end
		return false
	end
	if self.Debug then
		PowaAuras:Message("CheckUnit = ", unit)
	end
	self.DisplayUnit = unit
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if self.Debug then
			PowaAuras:Message("Match = ", pword )
		end
		for i = 1, 40 do
			local auraName, _, auraTexture, count, typeDebuff, _, expirationTime, _, _, _, auraId = UnitAura(unit, i, "HELPFUL")
			if self.Debug then
				PowaAuras:Message("Slot = ", i, " auraName = ", auraName, " typeDebuff = ", typeDebuff, " (", auraId, ")")
			end
			if auraName == nil then
				return nil
			end
			if typeDebuff == "Magic" then
				if auraName and self:CompareAura(unit, i, auraName, auraTexture, auraId, pword) then
					if self.Stacks then
						self.Stacks:SetStackCount(count)
					end
					self.DisplayValue = auraName
					self.DisplayUnit = unit
					self.DisplayUnit2 = targetOf
					self:UpdateText()
					PowaAuras:Debug("CompareAura not found")
					if self.Timer then
						self.Timer:SetDurationInfo(expirationTime)
						self:CheckTimerInvert()
						if self.ForceTimeInvert then
							return false
						end
					end
					return true
				end
			end
		end
	end
	self.DisplayValue = nil
	self.DisplayUnit2 = nil
	return false
end

-- This is not really AoE it is periodic damage, could be a DoT or a ground effect damage
cPowaAoE = PowaClass(cPowaAura, {AuraType = "Aoe"})
cPowaAoE.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff4, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.AoE]}
cPowaAoE.ShowOptions = {["PowaBarTooltipCheck"] = 1}
cPowaAoE.CheckBoxes = {["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaAoE.TooltipOptions = {r = 0.6, g = 0.4, b = 1.0, showBuffName = true}

function cPowaAoE:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.COMBAT_LOG_EVENT_UNFILTERED = true
end

function cPowaAoE:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\Spell_fire_meteorstorm")
end

function cPowaAoE:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check AoE")
	for spellId, spell in pairs(PowaAuras.AoeAuraAdded) do
		if self:MatchSpell(spell, PowaAuras.AoeAuraTexture[spellId], spellId, self.buffname) then
			if self.duration > 0 then
				self.TimeToHide = GetTime() + self.duration
			end
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonAoETrigger, spell)
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonAoENoTrigger, self.buffname)
end

-- Enchant
cPowaEnchant = PowaClass(cPowaAura, {AuraType = "Enchants", CanHaveTimer = true, CanHaveTimerOnInverse = true, CanHaveStacks = true, CanHaveInvertTime = true, InvertTimeHides = true})
cPowaEnchant.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff5, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Enchant]}
cPowaEnchant.ShowOptions = {["PowaBarBuffStacks"] = 1}
cPowaEnchant.CheckBoxes = {["PowaIngoreCaseButton"] = 1, ["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaEnchant.TooltipOptions = {r = 1.0, g = 0.8, b = 1.0, showBuffName = true}

function cPowaEnchant:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.UNIT_INVENTORY_CHANGED = true
end

function cPowaEnchant:CheckforEnchant(slot, enchantText, textToFind)
	PowaAuras:Debug("Check enchant ("..enchantText..") active in slot", slot)
	PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	PowaAuras_Tooltip:SetInventoryItem("player", slot)
	for z = 1, PowaAuras_Tooltip:NumLines() do
		local textlinel = _G["PowaAuras_TooltipTextLeft"..z]
		local textl = textlinel:GetText()
		local text = ""
		if textl then
			text = text..textl
		end
		local textliner = _G["PowaAuras_TooltipTextRight"..z]
		local textr = textliner:GetText()
		if textr then
			text = text..textr
		end
		if text ~= "" then
			if self:MatchText(text, textToFind) then
				PowaAuras_Tooltip:Hide()
				return true
			end
		end
	end
	PowaAuras_Tooltip:Hide()
	return false
end

function cPowaEnchant:SetForEnchant(loc, slot, charges, index)
	PowaAuras:Debug(loc,": found ", self.buffname," in the tooltip!")
	if self:CheckStacks(charges) then
		if self:IconIsRequired() then
			self:SetIcon(GetInventoryItemTexture("player", slot))
		end
		if self.Stacks then
			self.Stacks:SetStackCount(charges)
		end
		return true
	end
	return false
end

function cPowaEnchant:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check weapon enchant")
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
	local checkMain = true
	local checkOff = true
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if pword == PowaAuras.Text.mainHand then
			checkMain = true
			checkOff = false
		elseif pword == PowaAuras.Text.offHand then
			checkOff = true
			checkMain = false
		else
			if hasMainHandEnchant and checkMain then
				if self:CheckforEnchant(16, PowaAuras.Text.mainHand, pword) then
					if self:SetForEnchant("MH", 16, mainHandCharges, 1) then
						if self.Stacks then
							self.Stacks:SetStackCount(mainHandCharges)
						end
						PowaAuras.Pending[self.id] = GetTime() + mainHandExpiration / 1000
						if self.Timer then
							self.Timer:SetDurationInfo(PowaAuras.Pending[self.id])
							self:CheckTimerInvert()
							if self.ForceTimeInvert then
								if not giveReason then
									return false
								end
								return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonEnchantMainInvert, self.buffname)
							end
						end
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonEnchantMain, self.buffname)
					end
				end
			end
			if hasOffHandEnchant and checkOff then
				if self:CheckforEnchant(17, PowaAuras.Text.offHand, pword) then
					if self:SetForEnchant("OH", 17, offHandCharges, 2) then
						if self.Stacks then
							self.Stacks:SetStackCount(offHandCharges)
						end
						PowaAuras.Pending[self.id] = GetTime() + offHandExpiration / 1000
						if self.Timer then
							self.Timer:SetDurationInfo(PowaAuras.Pending[self.id])
							self:CheckTimerInvert()
							if self.ForceTimeInvert then
								if not giveReason then
									return false
								end
								return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonEnchantOffInvert, self.buffname)
							end
						end
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonEnchantOff, self.buffname)
					end
				end
			end
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNoEnchant, self.buffname)
end

-- Combo Points
cPowaCombo = PowaClass(cPowaAura, {AuraType = "Combo", CanHaveStacks = true, OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff6, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Combo]}, CheckBoxes = {["PowaIngoreCaseButton"] = 1}})
cPowaCombo.TooltipOptions = {r = 1.0, g = 1.0, b = 0.0, showBuffName = true}

function cPowaCombo:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.UNIT_COMBO_POINTS = true
	PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	if PowaAuras.playerclass == "DRUID" then
		PowaAuras.Events.UPDATE_SHAPESHIFT_FORM = true
	end
end

function cPowaCombo:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\inv_sword_48")
end

function cPowaCombo:CheckIfShouldShow(giveReason)
	if PowaAuras.playerclass ~= "ROGUE" and PowaAuras.playerclass ~= "DRUID" then
		if self.Debug then
			PowaAuras:Message("Class = ", PowaAuras.playerclass)
		end
		if not giveReason then
			return nil
		end
		return nil, PowaAuras.Text.nomReasonNoUseCombo
	end
	PowaAuras:Debug("Check Combos")
	local nCombo = GetComboPoints("player")
	local combo = tostring(nCombo)
	if self:MatchText(combo, self.buffname) then
		if self.Stacks then
			self.Stacks:SetStackCount(nCombo)
		end
		if not giveReason then
			return true
		end
		return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonComboMatch, combo, self.buffname)
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNoComboMatch, combo, self.buffname)
end

-- Action Usable
cPowaActionReady = PowaClass(cPowaAura, {AuraType = "Actions", CanHaveTimer = true, CanHaveTimerOnInverse = true, CooldownAura = true, CanHaveInvertTime = true})
cPowaActionReady.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff7, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.ActionReady], mineText = PowaAuras.Text.nomIgnoreUseable, mineTooltip = PowaAuras.Text.aideIgnoreUseable}
cPowaActionReady.CheckBoxes = {["PowaIngoreCaseButton"] = 1, ["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaActionReady.TooltipOptions = {r = 0.8, g = 0.8, b = 1.0, showBuffName = true}

function cPowaActionReady:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.ACTIONBAR_SLOT_CHANGED = true
	PowaAuras.Events.ACTIONBAR_SHOWGRID = true
	PowaAuras.Events.ACTIONBAR_HIDEGRID = true
	PowaAuras.Events.ACTIONBAR_UPDATE_COOLDOWN = true
	PowaAuras.Events.ACTIONBAR_UPDATE_USABLE = true
	PowaAuras.Events.UPDATE_SHAPESHIFT_FORM = true
end

function cPowaActionReady:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check Action / Button: ", self.slot)
	if not self.slot or self.slot == 0 then
		if not giveReason then
			return false
		end
		return false, PowaAuras.Text.nomReasonActionNotFound
	end
	local cdstart, cdduration, enabled, charges, maxCharges = GetActionCooldown(self.slot)
	if not enabled then
		if self.Timer then
			self.Timer:SetDurationInfo(0)
		end
		if not giveReason then
			return false
		end
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonActionlNotEnabled, self.buffname)
	end
	if not self.mine then
		local usable, noMana = IsUsableAction(self.slot)
		if not usable then
			if not giveReason then
				return false
			end
			return false, PowaAuras.Text.nomReasonActionNotUsable
		end
	end
	-- Ignore if this is just Global Cooldown
	if self.Debug then
		PowaAuras:Message("CooldownOver = ", self.CooldownOver," cdduration = ", cdduration," InGCD = ", PowaAuras.InGCD)
	end
	local globalCD = not self.CooldownOver and (cdduration > 0.2 and cdduration < 1.7) and PowaAuras.InGCD == true
	if self.Debug then
		PowaAuras:Message("globalCD = ", globalCD)
	end
	if globalCD then
		if self.Debug then
			PowaAuras:Message("GCD no change")
		end
		PowaAuras.Pending[self.id] = cdstart + cdduration
		if not giveReason then
			return - 1
		end
		return - 1, PowaAuras:InsertText(PowaAuras.Text.nomReasonGlobalCooldown, self.buffname)
	end
	if cdstart == 0 or self.CooldownOver or charges > 0 then
		if not giveReason then
			return true
		end
		return true, PowaAuras.Text.nomReasonActionReady
	end
	PowaAuras.Pending[self.id] = cdstart + cdduration
	if self.Debug then
		PowaAuras:Message("Set Spell Pending = ", PowaAuras.Pending[self.id])
	end
	local reason = PowaAuras.Text.nomReasonActionNotReady
	if self.Timer then
		self.Timer:SetDurationInfo(cdstart + cdduration)
		self:CheckTimerInvert()
		if self.ForceTimeInvert then
			if not giveReason then
				return true
			end
			return true, PowaAuras.Text.nomReasonActionNotReadyInvert
		end
		if giveReason then
			reason = PowaAuras.Text.nomReasonActionNotUsable
		end
	end
	if not giveReason then
		return false
	end
	return false, reason
end

function cPowaActionReady:ShowTimerDurationSlider()
	return true
end

-- Spell Cooldown
cPowaSpellCooldown = PowaClass(cPowaAura, {AuraType = "SpellCooldowns", CanHaveTimer = true, CanHaveTimerOnInverse = true, CooldownAura = true, CanHaveInvertTime = true})
cPowaSpellCooldown.OptionText = {buffNameTooltip = PowaAuras.Text.aideBuff8, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.SpellCooldown],  mineText = PowaAuras.Text.nomSpellLearned, mineTooltip = PowaAuras.Text.aideSpellLearned, targetFriendText = PowaAuras.Text.nomCheckPet, targetFriendTooltip = PowaAuras.Text.aideCheckPet}
cPowaSpellCooldown.ShowOptions = {["PowaBarTooltipCheck"] = 1}
cPowaSpellCooldown.CheckBoxes = {["PowaIngoreCaseButton"] = 1, ["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaSpellCooldown.TooltipOptions = {r = 1.0, g = 0.6, b = 0.2, showBuffName = true}

function cPowaSpellCooldown:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.SPELL_UPDATE_COOLDOWN = true
end

function cPowaSpellCooldown:SkipTargetChecks()
	return true
end

function cPowaSpellCooldown:CheckIfShouldShow(giveReason)
	if self.Debug then
		PowaAuras:Message("Spell = ", self.buffname)
	end
	local reason
	local _
	local buffname
	if string.find(self.buffname, "%\[") or string.find(self.buffname, "%\]") then
		buffname = strtrim(self.buffname, "%\[%\]")
	else
		buffname = self.buffname
	end
	local spellName, spellIcon, spellId
	spellName, _, spellIcon = GetSpellInfo(buffname)
	local spellLink = GetSpellLink(buffname)
	if spellLink then
		spellId = string.match(spellLink, "spell:(%d+)")
	end
	if not spellName then
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotFound, buffname)
	end
	if self.Debug then
		PowaAuras:Message("spellName = ", spellName," spellId = ", spellId)
		PowaAuras:Message("spellIcon = ", spellIcon)
	end
	if self:IconIsRequired() then
		if not spellIcon then
			_, _, spellIcon = GetSpellInfo(spellName)
		end
		self:SetIcon(spellIcon)
	end
	local cdstart, cdduration, enabled
	if self.targetfriend then
		cdstart, cdduration, enabled = GetSpellCooldown(spellName, BOOKTYPE_PET)
	else
		cdstart, cdduration, enabled = GetSpellCooldown(spellName)
	end
	if self.Debug then
		PowaAuras:Message("cdstart = ", cdstart," duration = ", cdduration, " enabled = ", enabled)
	end
	if not enabled then
		if not self.inverse and self.mine then
			local show = false
			if self.targetfriend then
				for spellId, spellName, spellSubtext in petSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			else
				for spellId, spellName, spellSubtext in playerSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			end
			if show then
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
			else
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
			end
		elseif self.inverse and self.mine then
			local show = true
			if self.targetfriend then
				for spellId, spellName, spellSubtext in petSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			else
				for spellId, spellName, spellSubtext in playerSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			end
			if show then
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
			else
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
			end
		else
			if not giveReason then
				return false
			end
			return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
		end
	elseif enabled ~= 1 then
		if not giveReason then
			return false
		end
		return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotEnabled, spellName)
	end
	local globalCD = not self.CooldownOver and cdduration and cdduration > 0.2 and cdduration < 1.7 and PowaAuras.InGCD == true
	if self.Debug then
		PowaAuras:Message("globalCD = ", globalCD)
	end
	if globalCD then
		PowaAuras.Pending[self.id] = cdstart + cdduration
		if not giveReason then
			return - 1
		end
		return - 1, PowaAuras:InsertText(PowaAuras.Text.nomReasonGlobalCooldown, spellName)
	end
	if cdstart == 0 or self.CooldownOver then
		if not self.inverse and not self.mine then
			local show = false
			if self.targetfriend then
				for spellId, spellName, spellSubtext in petSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			else
				for spellId, spellName, spellSubtext in playerSpells() do
					if self.ignoremaj then
						if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
							show = true
						end
					else
						if spellId == tonumber(buffname) or spellName == buffname then
							show = true
						end
					end
				end
			end
			if show then
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
			else
				return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
			end
		elseif not self.inverse and self.mine then
			local show
			if tonumber(buffname) and tonumber(buffname) % 1 == 0 then
				show = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				end
				if show then
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
				else
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
				end
			else
				show = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				end
				if show then
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
				else
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable.." "..PowaAuras.Text.nomReasonSpellNotLearned, spellName)
				end
			end
		elseif self.inverse and self.mine then
			local show
			if tonumber(buffname) and tonumber(buffname) % 1 == 0 then
				local spellIdFound = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						local spellLink = GetSpellLink(spellId)
						if spellLink then
							local spellID = string.match(spellLink, "spell:(%d+)")
							if tonumber(spellID) == tonumber(buffname) then
								spellIdFound = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						local spellLink = GetSpellLink(spellId)
						if spellLink then
							local spellID = string.match(spellLink, "spell:(%d+)")
							if tonumber(spellID) == tonumber(buffname) then
								spellIdFound = true
							end
						end
					end
				end
				if spellIdFound then
					show = false
					if self.targetfriend then
						for spellId, spellName, spellSubtext in petSpells() do
							if spellId == tonumber(buffname) then
								show = true
							end
						end
					else
						for spellId, spellName, spellSubtext in playerSpells() do
							if spellId == tonumber(buffname) then
								show = true
							end
						end
					end
					if show then
						return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
					else
						return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellOnCooldown.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
					end
				else
					show = true
					if self.targetfriend then
						for spellId, spellName, spellSubtext in petSpells() do
							if spellId == tonumber(buffname) then
								show = false
							end
						end
					else
						for spellId, spellName, spellSubtext in playerSpells() do
							if spellId == tonumber(buffname) then
								show = false
							end
						end
					end
					if show then
						return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotLearned, spellName)
					else
						return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellOnCooldown.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
					end
				end
			else
				show = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				end
				if show then
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
				else
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellOnCooldown.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
				end
			end
		elseif self.inverse and not self.mine then
			local show
			if tonumber(buffname) and tonumber(buffname) % 1 == 0 then
				show = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				end
				if show then
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
				else
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
				end
			else
				show = false
				if self.targetfriend then
					for spellId, spellName, spellSubtext in petSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				else
					for spellId, spellName, spellSubtext in playerSpells() do
						if self.ignoremaj then
							if spellId == tonumber(buffname) or string.upper(spellName) == string.upper(buffname) then
								show = true
							end
						else
							if spellId == tonumber(buffname) or spellName == buffname then
								show = true
							end
						end
					end
				end
				if show then
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
				else
					return show, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
				end
			end
		else
			if self.Debug then
				PowaAuras:Message("Show!")
			end
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellUsable, spellName)
		end
	end
	if cdstart and cdduration then
		PowaAuras.Pending[self.id] = cdstart + cdduration
	end
	if self.Timer then
		self.Timer:SetDurationInfo(PowaAuras.Pending[self.id])
		self:CheckTimerInvert()
		if self.ForceTimeInvert then
			if self.Debug then
				PowaAuras:Message("Show!")
			end
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotReady, spellName)
		end
	end
	if giveReason then
		if not self.inverse and not self.mine then
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
		elseif not self.inverse and self.mine then
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
		elseif self.inverse and self.mine then
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellOnCooldown.." "..PowaAuras.Text.nomReasonSpellLearned, spellName)
		elseif self.inverse and not self.mine then
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotUsable, spellName)
		else
			reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellOnCooldown, spellName)
		end
	end
	if self.Debug then
		PowaAuras:Message("Hide!")
	end
	if not giveReason then
		return false
	end
	return false, reason
end

function cPowaSpellCooldown:ShowTimerDurationSlider()
	return true
end

-- Aura States
cPowaAuraStats = PowaClass(cPowaAura, {CanHaveStacks = true, MaxRange = 100, RangeType = "%"})
cPowaAuraStats.OptionText = {targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaAuraStats.ShowOptions = {["PowaBarThresholdSlider"] = 1, ["PowaThresholdInvertButton"] = 1}
cPowaAuraStats.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaPartyButton"] = 1, ["PowaFocusButton"] = 1, ["PowaRaidButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaGroupAnyButton"] = 1, ["PowaOptunitnButton"] = 1, ["PowaInverseButton"] = 1}

function cPowaAuraStats:AddEffectAndEvents()
	if not self.target and not self.targetfriend and not self.party and not self.raid and not self.focus and not self.optunitn then
		table.insert(PowaAuras.AurasByType[self.ValueName], self.id)
	end
	if self.optunitn then
		table.insert(PowaAuras.AurasByType["NamedUnit"..self.ValueName], self.id)
	end
	if self.focus then
		table.insert(PowaAuras.AurasByType["Focus"..self.ValueName], self.id)
		PowaAuras.Events.PLAYER_FOCUS_CHANGED = true
	end
	if self.target or self.targetfriend then
		table.insert(PowaAuras.AurasByType["Target"..self.ValueName], self.id)
		PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	end
	if self.party then
		table.insert(PowaAuras.AurasByType["Party"..self.ValueName], self.id)
	end
	if self.raid then
		table.insert(PowaAuras.AurasByType["Raid"..self.ValueName], self.id)
	end
	if self.ValueName == "Health" then
		PowaAuras.Events.UNIT_HEALTH = true
		PowaAuras.Events.UNIT_MAXHEALTH = true
	else
		PowaAuras.Events.UNIT_POWER = true
		PowaAuras.Events.UNIT_POWER_FREQUENT = true
		PowaAuras.Events.UNIT_MAXPOWER = true
	end
end

function cPowaAuraStats:Init()
	self:SetFixedIcon()
	if not self.PowerType then
		return
	end
	self.MaxRange = PowaAuras.PowerRanges[self.PowerType]
	self.RangeType = PowaAuras.RangeType[self.PowerType]
end

function cPowaAuraStats:CheckUnit(unit)
	PowaAuras:Debug("CheckUnit "..unit)
	if not self:IsCorrectPowerType(unit) then
		return nil
	end
	if UnitIsDeadOrGhost(unit) then
		return false
	end
	local curValue = self:UnitValue(unit)
	if self.Stacks then
		self.Stacks:SetStackCount(curValue)
	end
	self.DisplayValue = curValue
	self.DisplayUnit = unit
	self:UpdateText()
	local maxValue = self:UnitValueMax(unit)
	if curValue == nil or maxValue == nil or maxValue == 0 then
		return false
	end
	if self.Debug then
		PowaAuras:DisplayText("curValue = ", curValue, " maxValue = ", maxValue)
	end
	if self.RangeType == "%" then
		curValue = (curValue / maxValue) * 100
	end
	if self.Stacks then
		self.Stacks:SetStackCount(curValue)
	end
	if self.Debug then
		PowaAuras:DisplayText(curValue..self.RangeType, " threshold = ", self.threshold)
	end
	local thresholdvalidate
	if self.thresholdinvert then
		thresholdvalidate = (curValue >= self.threshold)
	else
		thresholdvalidate = (curValue <= self.threshold)
	end
	if thresholdvalidate then
		return true
	end
	return false
end

function cPowaAuraStats:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check Stat "..self.ValueName)
	return self:CheckAllUnits(giveReason)
end

-- Health
cPowaHealth = PowaClass(cPowaAuraStats, {ValueName = "Health"})
cPowaHealth.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Health]}
cPowaHealth.TooltipOptions = {r = 0.2, g = 1.0, b = 0.2, showThreshold = true}

function cPowaHealth:Init()
	self.PowerType = - 1
	cPowaAuraStats.Init(self)
end

function cPowaHealth:IsCorrectPowerType(unit)
	return true
end

function cPowaHealth:UnitValue(unit)
	return UnitHealth(unit)
end

function cPowaHealth:UnitValueMax(unit)
	return UnitHealthMax(unit)
end

function cPowaHealth:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\inv_alchemy_elixir_05")
end

-- Mana
cPowaMana = PowaClass(cPowaAuraStats, {ValueName = "Mana"})
cPowaMana.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Mana]}
cPowaMana.TooltipOptions = {r = 0.2, g = 0.2, b = 1.0, showThreshold = true}

function cPowaMana:Init()
	if self.PowerType ~= SPELL_POWER_MANA then
		self.PowerType = SPELL_POWER_MANA
	end
	cPowaAuraStats.Init(self)
end

function cPowaMana:IsCorrectPowerType(unit)
	local powerType = UnitPowerType(unit)
	return powerType and powerType == 0
end

function cPowaMana:UnitValue(unit)
	PowaAuras:Debug("Mana UnitValue for ", unit)
	return UnitPower(unit, 0)
end

function cPowaMana:UnitValueMax(unit)
	PowaAuras:Debug("Mana UnitValueMax for ", unit)
	return UnitPowerMax(unit, 0)
end

function cPowaMana:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\inv_alchemy_elixir_02")
end

-- Power
cPowaPowerType = PowaClass(cPowaMana, {ValueName = "Power"})
cPowaPowerType.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.EnergyRagePower]}
cPowaPowerType.TooltipOptions = {r = 1.0, g = 0.4, b = 0.0, showThreshold = true}
cPowaPowerType.ShowOptions = {["PowaBarThresholdSlider"] = 1, ["PowaThresholdInvertButton"] = 1, ["PowaDropDownPowerType"] = 1}

function cPowaPowerType:Init()
	-- Fix for happiness auras
	if self.PowerType == 4 or self.PowerType == - 1 then
		self.PowerType = SPELL_POWER_RAGE
	end
	-- Set the ranges properly
	cPowaAuraStats.Init(self)
end

function cPowaPowerType:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\"..PowaAuras.PowerTypeIcon[self.PowerType])
end

function cPowaPowerType:DisplayType()
	if self.PowerType == - 1 then
		return self.OptionText.typeText
	end
	return PowaAuras.Text.PowerType[self.PowerType]
end

function cPowaPowerType:UnitValue(unit)
	if self.Debug then
		PowaAuras:DisplayText("UnitValue for ", unit, " type = ", self.PowerType)
	end
	local power
	if not self.PowerType or self.PowerType == - 1 then
		power = UnitPower(unit)
	elseif self.PowerType == SPELL_POWER_LUNAR_ECLIPSE then
		power = math.max(- UnitPower(unit, SPELL_POWER_ECLIPSE), 0)
	elseif self.PowerType == SPELL_POWER_SOLAR_ECLIPSE then
		power = math.max(UnitPower(unit, SPELL_POWER_ECLIPSE))
	elseif self.PowerType == SPELL_POWER_BURNING_EMBERS then
		power = UnitPower(unit, self.PowerType, true) / 10
	else
		power = UnitPower(unit, self.PowerType)
	end
	if self.Debug then
		PowaAuras:DisplayText("power = ", power)
	end
	return power
end

function cPowaPowerType:UnitValueMax(unit)
	if self.Debug then
		PowaAuras:DisplayText("UnitValueMax for ", unit, " type = ", self.PowerType)
	end
	local maxpower
	if not self.PowerType or self.PowerType == - 1 then
		maxpower = UnitPowerMax(unit)
	elseif self.PowerType == SPELL_POWER_LUNAR_ECLIPSE or self.PowerType == SPELL_POWER_SOLAR_ECLIPSE then
		maxpower = 100
	else
		maxpower = UnitPowerMax(unit, self.PowerType)
	end
	if self.Debug then
		PowaAuras:DisplayText("maxpower =", maxpower)
	end
	return maxpower
end

function cPowaPowerType:IsCorrectPowerType(unit)
	-- Check for correct secondary resource
	if (self.PowerType == SPELL_POWER_HOLY_POWER and PowaAuras.playerclass == "PALADIN") or (self.PowerType == SPELL_POWER_ALTERNATE_POWER) or (self.PowerType == SPELL_POWER_RUNIC_POWER and PowaAuras.playerclass == "DEATHKNIGHT") or (self.PowerType == SPELL_POWER_CHI and PowaAuras.playerclass == "MONK") or (self.PowerType == SPELL_POWER_SHADOW_ORBS and PowaAuras.playerclass == "PRIEST") or ((self.PowerType == SPELL_POWER_SOUL_SHARDS or self.PowerType == SPELL_POWER_BURNING_EMBERS or self.PowerType == SPELL_POWER_DEMONIC_FURY) and PowaAuras.playerclass == "WARLOCK") or ((self.PowerType == SPELL_POWER_LUNAR_ECLIPSE or self.PowerType == SPELL_POWER_SOLAR_ECLIPSE) and PowaAuras.playerclass == "DRUID") then 
		return true
	end
	local unitPowerType = UnitPowerType(unit)
	if self.Debug then
		PowaAuras:DisplayText("PowerType = ", unitPowerType, " expected = ", self.PowerType)
	end
	if not unitPowerType then
		return false
	end
	if not self.PowerType or self.PowerType == - 1 then
		return unitPowerType > 0
	end
	return unitPowerType == self.PowerType
end

-- Aggro
cPowaAggro = PowaClass(cPowaAura, {ValueName = "Aggro"})
cPowaAggro.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Aggro]}
cPowaAggro.CheckBoxes = {["PowaPartyButton"] = 1, ["PowaRaidButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaInverseButton"] = 1}
cPowaAggro.TooltipOptions = {r = 1.0, g = 0.4, b = 0.2}

function cPowaAggro:AddEffectAndEvents()
	PowaAuras.Events.UNIT_THREAT_SITUATION_UPDATE = true
	-- Self aggro
	if not self.target and not self.targetfriend and not self.party and not self.raid and not self.focus and not self.optunitn then
		table.insert(PowaAuras.AurasByType.Aggro, self.id)
	end
	-- Party aggro
	if self.party then
		table.insert(PowaAuras.AurasByType.PartyAggro, self.id)
	end
	-- Raid aggro
	if self.raid then
		table.insert(PowaAuras.AurasByType.RaidAggro, self.id)
	end
end

function cPowaAggro:CheckUnit(unit)
	return (UnitThreatSituation(unit) or - 1) > 0
end

function cPowaAggro:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\Ability_Warrior_EndlessRage")
end

function cPowaAggro:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check Aggro status")
	return self:CheckAllUnits(giveReason)
end

-- PVP
cPowaPvP = PowaClass(cPowaAura, {ValueName = "PvP"})
cPowaPvP.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.PvP], targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaPvP.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaPartyButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaRaidButton"] = 1}
cPowaPvP.TooltipOptions = {r = 1.0, g = 1.0, b = 0.8}

function cPowaPvP:AddEffectAndEvents()
	-- Self pvp flag
	if not self.target and not self.targetfriend and not self.party and not self.raid and not self.focus and not self.optunitn then
		table.insert(PowaAuras.AurasByType.PvP, self.id)
		PowaAuras.Events.PLAYER_FLAGS_CHANGED = true
		self.CanHaveTimer = true
	end
	-- Target pvp flag
	if self.target or self.targetfriend then
		table.insert(PowaAuras.AurasByType.TargetPvP, self.id)
	end
	-- Party pvp flagged
	if self.party then
		table.insert(PowaAuras.AurasByType.PartyPvP, self.id)
	end
	-- Raid pvp flagged
	if self.raid then
		table.insert(PowaAuras.AurasByType.RaidPvP, self.id)
	end
	PowaAuras.Events.UNIT_FACTION = true
end

function cPowaPvP:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\achievement_arena_2v2_7")
end

function cPowaPvP:CheckUnit(unit)
	if not self:CorrectTargetType(unit) then
		return false
	end
	local isPvP = UnitIsPVP(unit)
	if not isPvP then
		if self.Debug then
			PowaAuras:DisplayText(unit.." PvP flag is off")
		end
		return false
	end
	if self.Debug then
		PowaAuras:DisplayText(unit.." PvP flag is on")
	end
	if self.Timer and UnitIsUnit("player", unit) then
		local duration = GetPVPTimer()
		if self.Debug then
			PowaAuras:DisplayText("PvP flag is on time left =", GetPVPTimer())
		end
		PowaAuras.Pending[self.id] = GetTime() + 1 -- Timer seems not to be ready immediately
		if duration ~= nil and duration > - 1 and duration ~= 301000 then
			self.Timer:SetDurationInfo(GetTime() + duration / 1000)
		else
			self.Timer:SetDurationInfo(0)
		end
	end
	return true
end

function cPowaPvP:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check PvP Flag")
	return self:CheckAllUnits(giveReason)
end

-- Spell Alert
cPowaSpellAlert = PowaClass(cPowaAura, {AuraType = "SpellAlert", CanHaveInvertTime = true, ValueName = "SpellAlert", ForceIconCheck = true})
cPowaSpellAlert.OptionText = {buffNameTooltip = PowaAuras.Text.aideSpells, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.SpellAlert], mineText = PowaAuras.Text.nomCanInterrupt, mineTooltip = PowaAuras.Text.aideCanInterrupt, extraText = PowaAuras.Text.nomOnMe, extraTooltip = PowaAuras.Text.aideOnMe, targetFriendText = PowaAuras.Text.nomCheckFriend, targetFriendTooltip = PowaAuras.Text.aideTargetFriend}
cPowaSpellAlert.CheckBoxes = {["PowaTargetButton"] = 1, ["PowaFocusButton"] = 1, ["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1, ["PowaPartyButton"] = 1, ["PowaGroupOrSelfButton"] = 1, ["PowaRaidButton"] = 1, ["PowaOptunitnButton"] = 1}
cPowaSpellAlert.TooltipOptions = {r = 0.4, g = 0.4, b = 1.0, showBuffName = true}

function cPowaSpellAlert:AddEffectAndEvents()
	PowaAuras.Events.COMBAT_LOG_EVENT_UNFILTERED = true
	PowaAuras.Events.UNIT_SPELLCAST_CHANNEL_START = true
	PowaAuras.Events.UNIT_SPELLCAST_CHANNEL_STOP = true
	PowaAuras.Events.UNIT_SPELLCAST_CHANNEL_UPDATE = true
	PowaAuras.Events.UNIT_SPELLCAST_DELAYED = true
	PowaAuras.Events.UNIT_SPELLCAST_FAILED = true
	PowaAuras.Events.UNIT_SPELLCAST_INTERRUPTED = true
	PowaAuras.Events.UNIT_SPELLCAST_START = true
	PowaAuras.Events.UNIT_SPELLCAST_STOP = true
	-- On Me
	if self.Extra then
		table.insert(PowaAuras.AurasByType.Spells, self.id)
		return
	end
	local player = true
	-- Target casts
	if self.target or self.targetfriend then
		player = false
		-- Raid/party/focus target casts
		if self.party or self.raid or self.groupOrSelf then
			table.insert(PowaAuras.AurasByType.Spells, self.id)
			return
		end
		table.insert(PowaAuras.AurasByType.TargetSpells, self.id)
		PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	end
	-- Focus casts
	if self.focus then
		player = false
		table.insert(PowaAuras.AurasByType.FocusSpells, self.id)
		PowaAuras.Events.PLAYER_FOCUS_CHANGED = true
	end
	-- Party casts
	if self.party then
		player = false
		table.insert(PowaAuras.AurasByType.PartySpells, self.id)
	end
	-- Raid casts
	if self.raid then
		player = false
		table.insert(PowaAuras.AurasByType.RaidSpells, self.id)
	end
	-- Group or self casts
	if self.groupOrSelf then
		player = false
		table.insert(PowaAuras.AurasByType.GroupOrSelfSpells, self.id)
	end
	-- Player casts
	if player then
		table.insert(PowaAuras.AurasByType.PlayerSpells, self.id)
	end
end

function cPowaSpellAlert:SkipTargetChecks()
	return self.Extra
end

function cPowaSpellAlert:CheckSpellName(unit, spellname, spellicon, endtime, spellId)
	if self:MatchSpell(spellname, spellicon, spellId, self.buffname, true) then
		if self.Timer and endtime ~= nil then
			self.Timer:SetDurationInfo(GetTime() + endtime / 1000)
			self:CheckTimerInvert()
			if self.ForceTimeInvert then
				return false
			end
		end
		if self.Debug then
			PowaAuras:DisplayText(unit, " is casting ", spellname, " ", spellicon)
		end
		if spellicon == nil then
			local _
			if spellId ~= nil then
				_, _, spellicon = GetSpellInfo(spellId)
			else
				_, _, spellicon = GetSpellInfo(spellname)
			end
		end
		self:SetIcon(spellicon)
		self.DisplayValue = spellname
		self.DisplayUnit = unit
		self:UpdateText()
		if PowaAuras.ExtraUnitEvent[unit] then
			if self.Debug then
				PowaAuras:DisplayText("Set to Hide in = ", self.duration or 1, "s")
			end
			PowaAuras.Pending[self.id] = GetTime() + (self.duration or 1) -- Instant spells may have no complete event
		end
		return true
	end
	return false
end

function cPowaSpellAlert:CheckUnit(unit)
	if self.Debug then
		PowaAuras:DisplayText("CheckUnit ", unit)
	end
	local isCorrectTarget, targetType = self:CorrectTargetType(unit)
	if not isCorrectTarget then
		if self.Debug then
			PowaAuras:DisplayText("Incorrect target type ", targetType)
		end
		return false
	end
	-- Cast on me check
	if self.Extra then
		if not UnitIsUnit(unit.."target","player") then
			if self.Debug then
				PowaAuras:DisplayText(unit, " is not casting on me")
			end
			return false
		end
	end
	local spellname, spellicon, endtime, notInterruptible
	if PowaAuras.ExtraUnitEvent[unit] then
		spellname = PowaAuras.ExtraUnitEvent[unit]
	else
		local _
		spellname, _, _, spellicon, _, endtime, _, _, notInterruptible = UnitCastingInfo(unit)
		if not spellname then
			spellname, _, _, spellicon, _, endtime, _, notInterruptible = UnitChannelInfo(unit)
		end
	end
	-- Not casting
	if not spellname then
		if self.Debug then
			PowaAuras:DisplayText(unit, " is not casting")
		end
		return false
	end
	if self.Debug then
		PowaAuras:DisplayText(unit, " is casting ", spellname)
		PowaAuras:DisplayText(" mine = ", self.mine, " notInterruptible = ", notInterruptible )
	end
	if (self.mine and (notInterruptible or endtime == nil)) then
		if self.Debug then
			PowaAuras:DisplayText(unit, " is casting ", spellname, " but can't interrupt it")
		end
		return false
	end
	return self:CheckSpellName(unit, spellname, spellicon, endtime)
end

function cPowaSpellAlert:CheckIfShouldShow(giveReason)
	if self.Debug then
		PowaAuras:DisplayText("Check for spell being cast ", self.buffname)
		PowaAuras:DisplayText("Active = ", self.Active, " Pending = ", PowaAuras.Pending[self.id])
	end
	if self.Active and PowaAuras.Pending[self.id] and PowaAuras.Pending[self.id] > GetTime() then
		if not giveReason then
			return true
		end
		return true, PowaAuras.Text.nomReasonAnimationDuration
	end
	if self:IsPlayerAura() then
		for spellName, info in pairs(PowaAuras.CastByMe) do
			if self.Debug then
				PowaAuras:DisplayText("I am casting ", spellName, " on ", info.DestName)
			end
			if self:CheckSpellName("Player", info.SpellName, nil, nil, info.SpellId) then
				if self.duration == 0 then
					PowaAuras.Pending[self.id] = GetTime() + 1
				else
					PowaAuras.Pending[self.id] = GetTime() + self.duration
				end
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonCastingByMe, info.SpellName)
			end
		end
	end
	if self.Extra then
		for casterName, info in pairs(PowaAuras.CastOnMe) do
			if self.Debug then
				PowaAuras:DisplayText(casterName, " casting ", info.SpellName, " hostile = ", info.Hostile)
			end
			if (self.target and info.Hostile > 0) or (self.targetfriendly and not info.Hostile == 0) or (self.focus and info.SourceGUID == UnitGUID("focus")) or (not self.target and not self.targetfriendly and not self.focus) then
				if self.Debug then
					PowaAuras:DisplayText(" correct source, checking spell", info.SpellName)
				end
				if self:CheckSpellName(casterName, info.SpellName, nil, nil, info.SpellId) then
					if self.duration == 0 then
						PowaAuras.Pending[self.id] = GetTime() + 1
					else
						PowaAuras.Pending[self.id] = GetTime() + self.duration
					end
					if not giveReason then
						return true
					end
					return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonCastingOnMe, info.SpellName, info.DestName)
				end
			end
		end
	end
	return self:CheckAllUnits(giveReason)
end

function cPowaSpellAlert:ShowTimerDurationSlider()
	return true
end

-- Stance/Seal/Form
cPowaStance = PowaClass(cPowaAura, {AuraType = "Stance"})
cPowaStance.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Stance]}
cPowaStance.ShowOptions = {["PowaDropDownStance"] = 1}
cPowaStance.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaStance.TooltipOptions = {r = 1.0, g = 0.6, b = 0.2, showStance = true}

function cPowaStance:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.ACTIONBAR_UPDATE_COOLDOWN = true
	PowaAuras.Events.ACTIONBAR_UPDATE_USABLE = true
	PowaAuras.Events.UPDATE_SHAPESHIFT_FORM = true
	PowaAuras.Events.UPDATE_SHAPESHIFT_FORMS = true
end

function cPowaStance:CheckIfShouldShow(giveReason)
	PowaAuras:Debug("Check Stance")
	local nStance = GetShapeshiftForm(false)
	if string.find(self.stance, "/") then
		for number in string.gmatch(self.stance, "%d+") do
			if nStance == tonumber(number) then
				if nStance > 0 and self:IconIsRequired() then
					self:SetIcon(GetShapeshiftFormInfo(nStance))
				end
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonStance, nStance, self.stance)
			end
		end
	else
		if nStance == tonumber(self.stance) then
			if nStance > 0 and self:IconIsRequired() then
				self:SetIcon(GetShapeshiftFormInfo(nStance))
			end
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonStance, nStance, self.stance)
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonNoStance, nStance, self.stance)
end

function cPowaStance:SetFixedIcon()
	self.icon = nil
	if self.stance > 0 then
		self:SetIcon(GetShapeshiftFormInfo(self.stance))
	elseif self.stance == 0 then
		self:SetIcon("Interface\\Icons\\warrior_talent_icon_deadlycalm")
	else
		self.icon = ""
	end
end

-- GTFO
cPowaGTFO = PowaClass(cPowaAura, {ValueName = "GTFO Alert"})
cPowaGTFO.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.GTFO]}
cPowaGTFO.CheckBoxes = { }
cPowaGTFO.TooltipOptions = {r = 1.0, g = 0.4, b = 0.2, showGTFO = true}
cPowaGTFO.ShowOptions = {["PowaDropDownGTFO"] = 1}

function cPowaGTFO:AddEffectAndEvents()
	if self.GTFO == 0 then
		table.insert(PowaAuras.AurasByType.GTFOHigh, self.id)
	elseif self.GTFO == 1 then
		table.insert(PowaAuras.AurasByType.GTFOLow, self.id)
	elseif self.GTFO == 2 then
		table.insert(PowaAuras.AurasByType.GTFOFail, self.id)
	elseif self.GTFO == 3 then
		table.insert(PowaAuras.AurasByType.GTFOFriendlyFire, self.id)
	end
end

function cPowaGTFO:SetFixedIcon()
	self.icon = nil
	if self.GTFO == 1 then
		self:SetIcon("Interface\\Icons\\spell_fire_bluefire")
	elseif self.GTFO == 2 then
		self:SetIcon("Interface\\Icons\\ability_suffocate")
	elseif self.GTFO == 3 then
		self:SetIcon("Interface\\Icons\\spell_fire_felflamering")
	else
		self:SetIcon("Interface\\Icons\\spell_fire_fire")
	end
end

function cPowaGTFO:CheckIfShouldShow(giveReason)
	if GTFO then
		if GTFO.ShowAlert then
			return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonGTFOAlerts)
		end
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonGTFOAlerts)
end

-- Totem Aura
cPowaTotems = PowaClass(cPowaAura, {AuraType = "Totems", CanHaveTimer = true, CanHaveInvertTime = true, InvertTimeHides = true})
cPowaTotems.OptionText = {buffNameTooltip = PowaAuras.Text.aideTotems, exactTooltip = PowaAuras.Text.aideExact, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Totems]}
cPowaTotems.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaTotems.TooltipOptions = {r = 1.0, g = 1.0, b = 0.4, showBuffName = true}

function cPowaTotems:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.PLAYER_TOTEM_UPDATE = true
end

function cPowaTotems:CheckIfShouldShow(giveReason)
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if self.Debug then
			PowaAuras:Message("Pword = ", pword)
		end
		local pwordNumber = tonumber(pword)
		if pwordNumber then
			if self.Debug then
				PowaAuras:Message("SlotCheck = ", pwordNumber)
			end
			if self.Debug then
				PowaAuras:Message("SlotCheck Requested = ", pwordNumber)
			end
			local haveTotem, totemName, startTime, duration = GetTotemInfo(pwordNumber)
			if self.Debug then
				PowaAuras:Message("haveTotem = ", haveTotem, " totemName = ", totemName, " startTime = ", startTime, " duration = ", duration)
			end
			if totemName ~= nil and totemName ~= "" then
				if self:IconIsRequired() then
					local _, _, spellIcon = GetSpellInfo(totemName)
					self:SetIcon(spellIcon)
				end
				if self.Timer then
					self.Timer:SetDurationInfo(startTime + duration)
					self:CheckTimerInvert()
					if self.ForceTimeInvert then
						if not giveReason then
							return false
						end
						return false, _G["BINDING_NAME_MULTICASTACTIONBUTTON"..pwordNumber].." found (slot "..pwordNumber..") - "..totemName
					end
				end
				if not giveReason then
					return true
				end
				return true, _G["BINDING_NAME_MULTICASTACTIONBUTTON"..pwordNumber].." found (slot "..pwordNumber..") - "..totemName
			end
		else
			for slot = 1, 4 do
				local haveTotem, totemName, startTime, duration = GetTotemInfo(slot)
				if self:MatchText(totemName, pword) then
					if self:IconIsRequired() then
						local _, _, spellIcon = GetSpellInfo(totemName)
						self:SetIcon(spellIcon)
					end
					if self.Timer then
						self.Timer:SetDurationInfo(startTime + duration)
						self:CheckTimerInvert()
						if self.ForceTimeInvert then
							if not giveReason then
								return false
							end
							return false, totemName.." found"
						end
					end
					if not giveReason then
						return true
					end
					return true, totemName.." found"
				end
			end
		end
	end
	if not giveReason then
		return false
	end
	return false, "Totem not found"
end

-- Pet Aura
cPowaPet = PowaClass(cPowaAura, {AuraType = "Pet", ValueName = "Pet"})
cPowaPet.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Pet]}
cPowaPet.CheckBoxes = {["PowaInverseButton"] = 1}
cPowaPet.TooltipOptions = {r = 0.4, g = 1.0, b = 0.4}

function cPowaPet:Init()
	self:SetFixedIcon()
	if PowaAuras.playerclass == "DEATHKNIGHT" then
		PowaAuras.MasterOfGhouls = (GetSpecialization() == 3)
		self.CanHaveTimerOnInverse = true
		if not PowaAuras.MasterOfGhouls then
			self.CanHaveTimer = true
		end
	elseif PowaAuras.playerclass == "MAGE" then
		self.CanHaveTimerOnInverse = true
	end
end

function cPowaPet:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.UNIT_PET = true
	if self.playerclass == "DEATHKNIGHT" and not self.MasterOfGhouls then
		if self.DebugEvents then
			self:DisplayText("Ghoul")
		end
		PowaAuras.Events.PLAYER_TOTEM_UPDATE = true
	end
end

function cPowaPet:SetFixedIcon()
	self.icon = nil
	if PowaAuras.playerclass == "WARLOCK" then
		self:SetIcon("Interface\\Icons\\Spell_shadow_summonimp")
	elseif PowaAuras.playerclass == "MAGE" then
		self:SetIcon("Interface\\Icons\\Spell_frost_summonwaterelemental_2")
	elseif PowaAuras.playerclass == "DEATHKNIGHT" then
		self:SetIcon("Interface\\Icons\\Spell_shadow_animatedead")
	else
		self:SetIcon("Interface\\Icons\\Ability_hunter_pet_bear")
	end
end

function cPowaPet:CheckIfShouldShow(giveReason)
	if UnitExists("pet") then
		if PowaAuras.playerclass == "MAGE" then
			-- TODO: Get time left for Water Elemental
		end
		if not giveReason then
			return true
		end
		return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetExists)
	end
	if PowaAuras.playerclass == "DEATHKNIGHT" then
		if not PowaAuras.MasterOfGhouls then
			local haveTotem, name, startTime, duration, icon = GetTotemInfo(1)
			if startTime > 0 then
				if self.Timer then
					self.Timer:SetDurationInfo(startTime + duration)
					self:CheckTimerInvert()
					if self.ForceTimeInvert then
						if not giveReason then
							return false
						end
						return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetExists)
					end
				end
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetExists)
			end
		end
		if self.Timer and self.inverse then
			local startTime, duration, enabled = GetSpellCooldown(46584)
			if not enabled then
				if not giveReason then
					return false
				end
				local name = GetSpellInfo(46584)
				return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotEnabled, name)
			end
			self.Timer:SetDurationInfo(startTime + duration)
			self:CheckTimerInvert()
			if self.ForceTimeInvert then
				if not giveReason then
					return false
				end
				return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetExists)
			end
		end
	elseif PowaAuras.playerclass == "MAGE" then
		if self.Timer and self.inverse then
			local startTime, duration, enabled = GetSpellCooldown(31687)
			if not enabled then
				if not giveReason then
					return false
				end
				local name = GetSpellInfo(31687)
				return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonSpellNotEnabled, name)
			end
			self.Timer:SetDurationInfo(startTime + duration)
			self:CheckTimerInvert()
			if self.ForceTimeInvert then
				if not giveReason then
					return false
				end
				return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetExists)
			end
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonPetMissing)
end

-- Runes Aura
cPowaRunes = PowaClass(cPowaAura, {AuraType = "Runes", CanHaveTimerOnInverse = true, CooldownAura = true})
cPowaRunes.OptionText = {buffNameTooltip = PowaAuras.Text.aideRunes, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Runes]}
cPowaRunes.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1}
cPowaRunes.TooltipOptions = {r = 1.0, g = 0.4, b = 1.0, showBuffName = true}
cPowaRunes.runes = {[1] = 0, [2] = 0, [3] = 0, [4] = 0}
cPowaRunes.runeEnd = {[1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0, [6] = 0}
cPowaRunes.timeList = { }
cPowaRunes.runesMissingPlusDeath = {[1] = 0, [2] = 0, [3] = 0}
cPowaRunes.runesMissingIgnoreDeath = {[1] = 0, [2] = 0, [3] = 0}

function cPowaRunes:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.RUNE_POWER_UPDATE = true
	PowaAuras.Events.RUNE_TYPE_UPDATE = true
end

function cPowaRunes:GetRuneState()
	for runeType = 1, 4 do
		self.runes[runeType] = 0
	end
	for slot = 1, 6 do
		local startTime, duration, runeReady = GetRuneCooldown(slot)
		if runeReady then
			local runeType = GetRuneType(slot)
			self.runes[runeType] = self.runes[runeType] + 1
			self.runeEnd[slot] = 0
		elseif self.Timer then
			self.runeEnd[slot] = startTime + duration
		end
	end
end

function cPowaRunes:AddRuneTimeLeft(slot, count)
	if self.Debug then
		PowaAuras:Message("Slot = ", slot, " count = ", count)
	end
	local gaps = 0
	if count == 0 or (self.runeEnd[slot] == 0 and self.runeEnd[slot + 1] == 0) then
		return gaps
	end
	if count == 1 then
		if self.runeEnd[slot] ~= 0 or self.runeEnd[slot + 1] ~= 0 then
			gaps = gaps + 1
		end
		if self.runeEnd[slot] == 0 then
			table.insert(self.timeList, self.runeEnd[slot + 1])
			return gaps
		end
		if self.runeEnd[slot + 1] == 0 then
			table.insert(self.timeList, self.runeEnd[slot])
			return gaps
		end
		table.insert(self.timeList, math.min(self.runeEnd[slot], self.runeEnd[slot + 1]))
		return gaps
	end
	if self.runeEnd[slot] ~= 0 then
		gaps = gaps + 1
	end
	if self.runeEnd[slot + 1] ~= 0 then
		gaps = gaps + 1
	end
	table.insert(self.timeList, self.runeEnd[slot])
	table.insert(self.timeList, self.runeEnd[slot + 1])
	return gaps
end

function cPowaRunes:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\spell_arcane_arcane01")
end

function cPowaRunes:CheckIfShouldShow(giveReason)
	self:GetRuneState()
	local show, reason = self:RunesPresent(giveReason)
	return show, reason
end

function cPowaRunes:RunesPresent(giveReason)
	local match = self.buffname
	if self.ignoremaj then
		match = string.upper(match)
	end
	local minTimeToActivate, deathRunesRequired, deathRunesAvailable
	for pword in string.gmatch(match, "[^/]+") do
		if self.Debug then
			PowaAuras:Message("Pword = ", pword)
		end
		local deathRunesAvailable, deathRunesRequired
		if self.ignoremaj then
			local deathRunes = select(2, string.gsub(pword, "D", "D"))
			self.runesMissingPlusDeath[1] = math.max(select(2, string.gsub(pword, "B", "B")) - self.runes[1], 0)
			self.runesMissingPlusDeath[2] = math.max(select(2, string.gsub(pword, "U", "U")) - self.runes[2], 0)
			self.runesMissingPlusDeath[3] = math.max(select(2, string.gsub(pword, "F", "F")) - self.runes[3], 0)
			deathRunesRequired = self.runesMissingPlusDeath[1] + self.runesMissingPlusDeath[2] + self.runesMissingPlusDeath[3]
			deathRunesAvailable = math.max(self.runes[4] - deathRunes, 0)
			self.runesMissingIgnoreDeath[1] = 0
			self.runesMissingIgnoreDeath[2] = 0
			self.runesMissingIgnoreDeath[3] = 0
			if self.Debug then
				for runeType = 1, 3 do
					PowaAuras:Message("runeType = ", runeType, " runes = ", self.runes[runeType], " Missing +Death = ", self.runesMissingPlusDeath[runeType])
				end
				PowaAuras:Message("deathRunesRequired = ", deathRunesRequired, " deathRunesAvailable = ", deathRunesAvailable)
			end
			if deathRunesAvailable >= deathRunesRequired and self.runes[4] >= deathRunes then
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonRunesReady)
			end
		else
			local deathRunes = select(2, string.gsub(string.upper(pword), "D", "D"))
			self.runesMissingPlusDeath[1] = math.max(select(2, string.gsub(pword, "B", "B")) - self.runes[1], 0)
			self.runesMissingPlusDeath[2] = math.max(select(2, string.gsub(pword, "U", "U")) - self.runes[2], 0)
			self.runesMissingPlusDeath[3] = math.max(select(2, string.gsub(pword, "F", "F")) - self.runes[3], 0)
			deathRunesRequired = self.runesMissingPlusDeath[1] + self.runesMissingPlusDeath[2] + self.runesMissingPlusDeath[3]
			deathRunesAvailable = math.max(self.runes[4] - deathRunes, 0)
			self.runesMissingIgnoreDeath[1] = math.max(select(2, string.gsub(pword, "b", "b")) - self.runes[1], 0)
			self.runesMissingIgnoreDeath[2] = math.max(select(2, string.gsub(pword, "u", "u")) - self.runes[2], 0)
			self.runesMissingIgnoreDeath[3] = math.max(select(2, string.gsub(pword, "f", "f")) - self.runes[3], 0)
			local runeMatches = (self.runesMissingIgnoreDeath[1] + self.runesMissingIgnoreDeath[2] + self.runesMissingIgnoreDeath[3]) == 0
			if self.Debug then
				for runeType = 1, 3 do
					PowaAuras:Message("runeType = ", runeType, " runes = ", self.runes[runeType], " Missing +Death =", self.runesMissingPlusDeath[runeType], " Missing -Death = ", self.runesMissingIgnoreDeath[runeType])
				end
				PowaAuras:Message("deathRunesRequired = ", deathRunesRequired, " deathRunesAvailable = ", deathRunesAvailable, " runeMatches = ", runeMatches, " self.runes[4] = ", self.runes[4], " deathRunes = ", deathRunes)
			end
			if deathRunesAvailable >= deathRunesRequired and self.runes[4] >= deathRunes and runeMatches then
				if not giveReason then
					return true
				end
				return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonRunesReady)
			end
		end
		if self.Debug then
			PowaAuras:Message("self.Timer = ", self.Timer, " self.inverse = ", self.inverse)
		end
		if self.Timer and self.inverse then
			local maxTime = 0
			wipe(self.timeList)
			if self.runesMissingIgnoreDeath[1] > 0 or self.runesMissingIgnoreDeath[2] > 0 or self.runesMissingIgnoreDeath[3] > 0 then
				for runeType = 1, 3 do
					self:AddRuneTimeLeft(runeType * 2 - 1, self.runesMissingIgnoreDeath[runeType])
				end
				if self.Debug then
					PowaAuras:Message("#self.timeList = ", #self.timeList)
				end
				if #self.timeList > 0 then
					table.sort(self.timeList)
					maxTime = self.timeList[#self.timeList]
					if self.Debug then
						PowaAuras:Message("maxTime = ", maxTime)
					end
				end
			end
			wipe(self.timeList)
			local missing = deathRunesRequired - deathRunesAvailable
			if missing > 0 then
				local gaps = 0
				for runeType = 1, 3 do
					gaps = gaps + self:AddRuneTimeLeft(runeType * 2 - 1, self.runesMissingPlusDeath[runeType])
				end
				if self.Debug then
					PowaAuras:Message("#self.timeList = ", #self.timeList, " deathRunesAvailable = ", deathRunesAvailable, " missing = ", missing)
				end
				if #self.timeList > deathRunesAvailable then
					table.sort(self.timeList)
					local endTime = self.timeList[#self.timeList - gaps + missing]
					if self.Debug then
						PowaAuras:Message("endTime = ", endTime)
					end
					if endTime > maxTime then
						maxTime = endTime
						if self.Debug then
							PowaAuras:Message("maxTime = ", maxTime)
						end
					end
				end
			end
			if minTimeToActivate == nil or maxTime < minTimeToActivate then
				minTimeToActivate = maxTime
			end
		end
		
	end
	if self.Timer and minTimeToActivate ~= nil and minTimeToActivate > 0 then
		if self.Debug then
			PowaAuras:Message("minTimeToActivate = ", minTimeToActivate)
		end
		self.Timer:SetDurationInfo(minTimeToActivate)
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonRunesNotReady)
end

-- Equipment Slots Aura
cPowaSlots = PowaClass(cPowaAura, {AuraType = "Slots", ValueName = "Slots", CooldownAura = true, CanHaveTimerOnInverse = true})
cPowaSlots.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Slots]}
cPowaSlots.ShowOptions = {["PowaBarTooltipCheck"] = 1}
cPowaSlots.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaSlots.TooltipOptions = {r = 0.8, g = 0.8, b = 0.2}

function cPowaSlots:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.BAG_UPDATE = true
	PowaAuras.Events.BAG_UPDATE_COOLDOWN = true
	PowaAuras.Events.UNIT_INVENTORY_CHANGED = true
end

function cPowaSlots:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\inv_throwingaxepvp330_08")
end

function cPowaSlots:CheckIfShouldShow(giveReason)
	if self.Debug then
		PowaAuras:Message("Buffname =", self.buffname)
	end
	local reason
	for pword in string.gmatch(self.buffname, "[^/]+") do
		pword = self:Trim(pword)
		if string.len(pword) > 0 then
			local slotId, emptyTexture = GetInventorySlotInfo(pword.."Slot")
			if (slotId) then
				local texture = GetInventoryItemTexture("player", slotId)
				if texture ~= nil then
					local cdstart, cdduration, enabled = GetInventoryItemCooldown("player", slotId)
					if self.Debug then
						PowaAuras:Message("cdstart = ", cdstart," duration = ", cdduration," enabled = ", enabled)
					end
					if enabled == 1 then
						self:SetIcon(texture)
						if cdstart == 0 then
							if self.Debug then
								PowaAuras:Message("Show!")
							end
							if not giveReason then
								return true
							end
							return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotUsable, pword)
						end
						if self.Timer then
							self.Timer:SetDurationInfo(cdstart + cdduration)
							self:CheckTimerInvert()
							if self.ForceTimeInvert then
								if self.Debug then
									PowaAuras:Message("Show!")
								end
								if not giveReason then
									return true
								end
								return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotNotReady, pword)
							end
							if self.Debug then
								PowaAuras:Message("Set DurationInfo =", self.Timer.DurationInfo)
							end
						end
						if giveReason then
							reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotOnCooldown, pword)
						end
					else
						if giveReason then
							reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotNotEnabled, pword)
						end
					end
				else
					self:SetIcon(emptyTexture)
					reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotNone, pword)
				end
			else
				if giveReason then
					reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonSlotNotFound, pword)
				end
			end
		end
	end
	if self.Debug then
		PowaAuras:Message("Hide!")
	end
	if not giveReason then
		return false
	end
	return false, reason
end

-- Named Items Aura
cPowaItems = PowaClass(cPowaAura, {AuraType = "Items", ValueName = "Items", CanHaveStacks = true, CooldownAura = true, CanHaveTimerOnInverse = true})
cPowaItems.OptionText = { buffNameTooltip = PowaAuras.Text.aideItems, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Items], mineText = PowaAuras.Text.nomIgnoreItemUseable, mineTooltip = PowaAuras.Text.aideIgnoreItemUseable, extraText = PowaAuras.Text.nomCarried, extraTooltip = PowaAuras.Text.aideCarried}
cPowaItems.ShowOptions = {["PowaBarTooltipCheck"] = 1, ["PowaBarBuffStacks"] = 1}
cPowaItems.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaItems.TooltipOptions = {r = 0.8, g = 0.8, b = 0.0}

function cPowaItems:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.BAG_UPDATE = true
	PowaAuras.Events.BAG_UPDATE_COOLDOWN = true
	PowaAuras.Events.UNIT_INVENTORY_CHANGED = true
end

function cPowaItems:ItemLinkIsNamedItem(itemLink, itemName)
	if not itemLink then
		return false
	end
	local itemLinkName = GetItemInfo(itemLink)
	if itemLinkName == itemName then
		--self.lastSlot = slot
		--self.lastBag = bag
		return true
	end
	return false
end

function cPowaItems:IsItemInBag(itemName)
	if self.Debug then
		PowaAuras:Message("itemName = ", itemName)
	end
	if self.lastBag and self.lastSlot then
		local itemLink = GetContainerItemLink(self.lastBag, self.lastSlot)
		if (self:ItemLinkIsNamedItem(itemLink, itemName)) then
			return true
		end
	end
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if self:ItemLinkIsNamedItem(itemLink, itemName) then
				self.lastSlot = slot
				self.lastBag = bag
				return true
			end
		end
	end
	self.lastSlot = nil
	self.lastBag = nil
	return false
end

function cPowaItems:CheckIfShouldShow(giveReason)
	if self.Debug then
		PowaAuras:Message("Buffname=", self.buffname)
	end
	local reason
	for pword in string.gmatch(self.buffname, "[^/]+") do
		pword = self:Trim(pword)
		if string.len(pword) > 0 then
			local item
			local _, _, itemId = string.find(pword, "%[(%d+)%]")
			if itemId then
				item = tonumber(itemId)
			else
				item = pword
			end
			if self.Debug then
				PowaAuras:Message("Looking for item = ", item)
			end
			local itemName, itemLink, _, _, _, _, _, _, _, itemTexture = GetItemInfo(item)
			if self.Debug then
				local itemStackCount = GetItemCount(itemName)
				PowaAuras:Message("itemName = ", itemName," itemStackCount = ", itemStackCount," itemTexture = ", itemTexture)
			end
			if itemName then
				if self:IconIsRequired() then
					self:SetIcon(itemTexture)
				end
				local isEquipped = IsEquippedItem(itemName)
				local isBagged = self:IsItemInBag(itemName)
				if self.Debug then
					PowaAuras:Message("isEquipped = ", isEquipped," isBagged = ", isBagged)
				end
				if not isEquipped and not isBagged then
					if not giveReason then
						return false
					end
					return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotOnPlayer, itemName)
				end
				local itemStackCount = GetItemCount(itemName)
				if not self:CheckStacks(itemStackCount) then
					if giveReason then
						return nil, PowaAuras:InsertText(PowaAuras.Text.nomReasonStacksMismatch, itemStackCount, self:StacksText())
					end
					return nil
				end
				if self.Stacks then
					self.Stacks:SetStackCount(itemStackCount)
				end
				if self.mine or self.Extra then
					if self.mine then
						if isEquipped then
							if not giveReason then
								return true
							end
							return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemEquipped, itemName)
						end
					end
					if not self.Extra then
						if not giveReason then
							return false
						end
						return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotEquipped, itemName)
					end
					if isBagged then
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemInBags, itemName)
					end
					if not giveReason then
						return false
					end
					if not self.mine then
						return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotInBags, itemName)
					end
					return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotOnPlayer, itemName)
				end
				local _, _, itemId = string.find(itemLink, "item:(%d+):(%d+):(%d+):(%d+)")
				if self.Debug then
					PowaAuras:Message("itemLink = ", itemLink," itemName = ", itemName," itemId = ", itemId)
				end
				local cdstart, cdduration, enabled
				if itemId then
					cdstart, cdduration, enabled = GetItemCooldown(tonumber(itemId))
					if self.Debug then
						PowaAuras:Message("cdstart = ", cdstart," duration = ", cdduration," enabled = ", enabled)
					end
				end
				if itemId and enabled then
					if cdstart == 0 then
						if self.Debug then
							PowaAuras:Message("Show!")
						end
						if not giveReason then
							return true
						end
						return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemUsable, itemName)
					end
					PowaAuras.Pending[self.id] = cdstart + cdduration
					if self.Timer then
						self.Timer:SetDurationInfo(cdstart + cdduration)
						self:CheckTimerInvert()
						if self.ForceTimeInvert then
							if self.Debug then
								PowaAuras:Message("Show!")
							end
							if not giveReason then
								return true
							end
							return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotReady, itemName)
						end
						if self.Debug then
							PowaAuras:Message("Set DurationInfo = ", self.Timer.DurationInfo)
						end
					end
					if giveReason then
						reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonItemOnCooldown, itemName)
					end
				else
					if giveReason then
						reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotEnabled, itemName)
					end
				end
			else
				if giveReason then
					reason = PowaAuras:InsertText(PowaAuras.Text.nomReasonItemNotFound, pword)
				end
			end
		end
	end
	if self.Debug then
		PowaAuras:Message("Hide!")
	end
	if not giveReason then
		return false
	end
	return false, reason
end

-- Tracking Aura
cPowaTracking = PowaClass(cPowaAura, {AuraType = "Tracking", ValueName = "Tracking"})
cPowaTracking.OptionText = {buffNameTooltip = PowaAuras.Text.aideTracking, typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Tracking], exactTooltip = PowaAuras.Text.aideExact}
cPowaTracking.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaIngoreCaseButton"] = 1, ["PowaOwntexButton"] = 1}
cPowaTracking.TooltipOptions = {r = 0.4, g = 1.0, b = 0.4}

function cPowaTracking:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.MINIMAP_UPDATE_TRACKING = true
end

function cPowaTracking:CheckIfShouldShow(giveReason)
	local count = GetNumTrackingTypes()
	local name, texture, active
	for i = 1, count do
		if active then
			local _
			_, texture, _ = GetTrackingInfo(i)
		else
			name, texture, active = GetTrackingInfo(i)
		end
		if self:MatchText(name, self.buffname) then
			self:SetIcon(texture)
			break
		end
		if active and not self.inverse then
			break
		end
	end
	if active then
		if self:MatchText(name, self.buffname) then
			if not giveReason then
				return true
			end
			return true, PowaAuras:InsertText(PowaAuras.Text.nomTrackingSet, name)
		end
	end
	if not giveReason then
		return false
	end
	return false, PowaAuras:InsertText(PowaAuras.Text.nomReasonTrackingMissing, self.buffname)
end

-- Static Aura
cPowaStatic = PowaClass(cPowaAura, {AuraType = "Static", ValueName = "Static"})
cPowaStatic.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.Static]}
cPowaStatic.CheckBoxes = { }
cPowaStatic.TooltipOptions = {r = 0.4, g = 0.4, b = 0.4}

function cPowaStatic:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
end

function cPowaStatic:CheckIfShouldShow(giveReason)
	return true, PowaAuras:InsertText(PowaAuras.Text.nomReasonStatic)
end

function cPowaStatic:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\Spell_frost_frozencore")
end

-- Unit Match Aura
cPowaUnitMatch = PowaClass(cPowaAura, { AuraType = "UnitMatch", ValueName = "Unit Check"})
cPowaUnitMatch.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.UnitMatch], buffNameTooltip = PowaAuras.Text.aideUnitMatch}
cPowaUnitMatch.TooltipOptions = {r = 0.4, g = 0.6, b = 0.8}
cPowaUnitMatch.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaRoleTankButton"] = 1, ["PowaRoleHealerButton"] = 1, ["PowaRoleMeleDpsButton"] = 1, ["PowaRoleRangeDpsButton"] = 1}

function cPowaUnitMatch:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.UNIT_TARGET = true
	PowaAuras.Events.INSTANCE_ENCOUNTER_ENGAGE_UNIT = true
	PowaAuras.Events.PLAYER_TARGET_CHANGED = true
	PowaAuras.Events.PLAYER_FOCUS_CHANGED = true
	PowaAuras.Events.UNIT_NAME_UPDATE = true
end

function cPowaUnitMatch:CheckIfShouldShow(giveReason)
	local unit1, unit2 = strsplit("/", self.buffname)
	if not unit1 or unit1 == "" then
		unit1 = "player"
	end
	if not unit2 or unit2 == "" then
		unit2 = "player"
	end
	local result = false
	if unit2 == "*" then
		result = UnitExists(unit1) and true or false
	else
		result = UnitIsUnit(unit1, unit2) and true or false
		if not result then
			result = UnitName(unit1) == unit2 and true or (UnitName(unit2) == unit1 and true or false)
		end
	end
	if not giveReason then
		return result, ""
	else
		return result, PowaAuras:InsertText((result and PowaAuras.Text.nomReasonUnitMatch or PowaAuras.Text.nomReasonNoUnitMatch), unit1, unit2)
	end
end

function cPowaUnitMatch:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\Spell_Misc_EmotionAngry")
end

-- Pet Stance Aura
cPowaPetStance = PowaClass(cPowaAura, { AuraType = "PetStance", ValueName = "Pet Stance"})
cPowaPetStance.OptionText = {typeText = PowaAuras.Text.AuraType[PowaAuras.BuffTypes.PetStance], buffNameTooltip = PowaAuras.Text.aidePetStance}
cPowaPetStance.TooltipOptions = {r = 0.8, g = 0.6, b = 0.4}
cPowaPetStance.CheckBoxes = {["PowaInverseButton"] = 1, ["PowaOwntexButton"] = 1}

function cPowaPetStance:AddEffectAndEvents()
	table.insert(PowaAuras.AurasByType[self.AuraType], self.id)
	PowaAuras.Events.PET_BAR_UPDATE = true
end

function cPowaPetStance:CheckIfShouldShow(giveReason)
	if not UnitExists("pet") or not HasPetSpells() then
		return false, PowaAuras.Text.nomReasonNoPet
	end
	local allowAssist, allowDefensive, allowPassive, stance = false, false, false, ""
	for pword in string.gmatch(self.buffname, "[^/]+") do
		if pword == "1" then
			allowAssist = true
		elseif pword == "2" then
			allowDefensive = true
		elseif pword == "3" then
			allowPassive = true
		end
	end
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name, _, _, isToken, isActive = GetPetActionInfo(i)
		if isToken and isActive then
			if name == "PET_MODE_ASSIST" then
				stance = name
				if(allowAssist) then
					return true, (giveReason and PowaAuras:InsertText(PowaAuras.Text.nomReasonPetStance, _G[stance]) or "")
				end
			elseif name == "PET_MODE_DEFENSIVE" then
				stance = name
				if allowDefensive then
					return true, (giveReason and PowaAuras:InsertText(PowaAuras.Text.nomReasonPetStance, _G[stance]) or "")
				end
			elseif name == "PET_MODE_PASSIVE" then
				stance = name
				if allowPassive then
					return true, (giveReason and PowaAuras:InsertText(PowaAuras.Text.nomReasonPetStance, _G[stance]) or "")
				end
			end
		end
	end
	return false, (giveReason and PowaAuras:InsertText(PowaAuras.Text.nomReasonPetStance, _G[stance]) or "")
end

function cPowaPetStance:SetFixedIcon()
	self.icon = nil
	self:SetIcon("Interface\\Icons\\ABILITY_HUNTER_SICKEM")
end

-- Concrete Classes
PowaAuras.AuraClasses =
{
	[PowaAuras.BuffTypes.Buff] = cPowaBuff,
	[PowaAuras.BuffTypes.Debuff] = cPowaDebuff,
	[PowaAuras.BuffTypes.TypeDebuff] = cPowaTypeDebuff,
	[PowaAuras.BuffTypes.AoE] = cPowaAoE,
	[PowaAuras.BuffTypes.Enchant] = cPowaEnchant,
	[PowaAuras.BuffTypes.Combo] = cPowaCombo,
	[PowaAuras.BuffTypes.ActionReady] = cPowaActionReady,
	[PowaAuras.BuffTypes.Health] = cPowaHealth,
	[PowaAuras.BuffTypes.Mana] = cPowaMana,
	[PowaAuras.BuffTypes.EnergyRagePower] = cPowaPowerType,
	[PowaAuras.BuffTypes.Aggro] = cPowaAggro,
	[PowaAuras.BuffTypes.PvP] = cPowaPvP,
	[PowaAuras.BuffTypes.SpellAlert] = cPowaSpellAlert,
	[PowaAuras.BuffTypes.Stance] = cPowaStance,
	[PowaAuras.BuffTypes.SpellCooldown] = cPowaSpellCooldown,
	[PowaAuras.BuffTypes.StealableSpell] = cPowaStealableSpell,
	[PowaAuras.BuffTypes.PurgeableSpell] = cPowaPurgeableSpell,
	[PowaAuras.BuffTypes.GTFO] = cPowaGTFO,
	[PowaAuras.BuffTypes.Totems] = cPowaTotems,
	[PowaAuras.BuffTypes.Pet] = cPowaPet,
	[PowaAuras.BuffTypes.Runes] = cPowaRunes,
	[PowaAuras.BuffTypes.Slots] = cPowaSlots,
	[PowaAuras.BuffTypes.Items] = cPowaItems,
	[PowaAuras.BuffTypes.Tracking] = cPowaTracking,
	[PowaAuras.BuffTypes.TypeBuff] = cPowaTypeBuff,
	[PowaAuras.BuffTypes.Static] = cPowaStatic,
	[PowaAuras.BuffTypes.UnitMatch] = cPowaUnitMatch,
	[PowaAuras.BuffTypes.PetStance] = cPowaPetStance
}

-- Instance concrete class based on type
function PowaAuras:AuraFactory(auraType, id, base)
	local class = self.AuraClasses[auraType]
	if class then
		if base == nil then
			base = { }
		end
		base.bufftype = auraType
		base.Debug = nil
		return class(id, base)
	end
	self:Message("AuraFactory unknown type ("..tostring(auraType)..") id = "..tostring(id))
	return nil
end

function PowaAuras:Dispose(tableName, key, key2)
	local t = self[tableName]
	if not t or not t[key] then
		return
	end
	if key2 then
		if not t[key][key2] then
			return
		end
		t = t[key]
		key = key2
	end
	if t[key].Hide then
		t[key]:Hide()
	end
	t[key] = nil
end