local PowaAurasOptions = PowaAurasOptions

local _G = _G
local date = date
local format = format
local ipairs = ipairs
local math = math
local pairs = pairs
local pcall = pcall
local pi = math.pi
local sort = sort
local string = string
local strsplit = strsplit
local strtrim = strtrim
local table = table
local tinsert = tinsert
local tremove = tremove
local tonumber = tonumber
local tostring = tostring
local type = type

local CloseDropDownMenus = CloseDropDownMenus
local CreateFrame = CreateFrame
local GetAddOnMetadata = GetAddOnMetadata
local GetCursorPosition = GetCursorPosition
local GetInventoryItemTexture = GetInventoryItemTexture
local GetInventorySlotInfo = GetInventorySlotInfo
local GetRealmName = GetRealmName
local GetTime = GetTime
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsControlKeyDown = IsControlKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local PlaySound = PlaySound
local PlaySoundFile = PlaySoundFile
local UnitAura = UnitAura
local UnitExists = UnitExists
local UnitName = UnitName

local UIParent = UIParent

local GRAY_FONT_COLOR = GRAY_FONT_COLOR
local HIGHLIGHT_FONT_COLOR = HIGHLIGHT_FONT_COLOR
local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR

if InterfaceOptionsFrame then
	InterfaceOptionsFrame:HookScript("OnShow", function(self)
		for i, v in pairs(UISpecialFrames) do
			if v == "PowaOptionsFrame" then
				tremove(UISpecialFrames, i)
			end
		end
	end)
	InterfaceOptionsFrame:HookScript("OnHide", function(self)
		tinsert(UISpecialFrames, "PowaOptionsFrame")
	end)
end

-- Main Options
function PowaAurasOptions:OptionsOnLoad()
	SlashCmdList["PowerAuras"] = function(msg)
		PowaAurasOptions:SlashCommands(msg)
	end
	SLASH_PowerAuras1 = "/pa"
	SLASH_PowerAuras2 = "/powa"
	PowaAuras_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")
	for i = 1, 5 do
		_G["PowaOptionsList"..i]:SetText(PowaPlayerListe[i])
	end
	for i = 1, 10 do
		_G["PowaOptionsList"..i + 5]:SetText(PowaGlobalListe[i])
	end
	self.Comms:Register()
	PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
	PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
	PowaAurasOptions:SetLockButtonText()
	local day = tonumber(date("%d"))
	local month = tonumber(date("%m"))
	if (day == 1 and month == 1) or (day == 1 and month == 4) or (day == 25 and month == 12) or (day == 31 and month == 12) then
		PowaOptionsFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 200,
			edgeSize = 32, 
			insets = {left = 10, right = 10, top = 10, bottom = 10}
		})
		PowaOptionsHeaderTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Header")
		local dragon = PowaOptionsFrame:CreateTexture(nil, "Overlay")
		dragon:SetSize(48, 48)
		dragon:SetPoint("LEFT", PowaOptionsHeaderTexture, "LEFT", 0, - 2)
		dragon:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon")
		PowaBarConfigFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 200,
			edgeSize = 32, 
			insets = {left = 10, right = 10, top = 10, bottom = 10}
		})
		PowaHeaderTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Header")
		PowaFontSelectorFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 200,
			edgeSize = 32, 
			insets = {left = 10, right = 10, top = 10, bottom = 10}
		})
		PowaFontHeaderTexture:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Gold-Header")
		PowaEquipmentSlotsFrame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
			tile = true,
			tileSize = 200,
			edgeSize = 16, 
			insets = {left = 4, right = 4, top = 4, bottom = 4}
		})
	end
end

function PowaAurasOptions:ResetPositions()
	PowaBarConfigFrame:ClearAllPoints()
	PowaBarConfigFrame:SetPoint("Center", "UIParent", "Center", 0, 50)
	PowaOptionsFrame:ClearAllPoints()
	PowaOptionsFrame:SetPoint("Center", "UIParent", "Center", 0, 50)
end

function PowaAurasOptions:UpdateMainOption(hideAll)
	PowaOptionsHeader:SetText("Power Auras "..self.Version)
	PowaMainHideAllButton:SetText(self.Text.nomHide)
	PowaMainTestButton:SetText(self.Text.nomTest)
	PowaEditButton:SetText(self.Text.nomEdit)
	PowaOptionsRename:SetText(self.Text.nomRename)
	PowaEnableButton:SetChecked(PowaMisc.Disabled ~= true)
	PowaDebugButton:SetChecked(PowaMisc.Debug == true)
	PowaTimerRoundingButton:SetChecked(PowaMisc.TimerRoundUp == true)
	PowaAllowInspectionsButton:SetChecked(PowaMisc.AllowInspections == true)
	PowaOptionsTextureCount:SetValue(self.MaxTextures)
	-- Attach the icons
	for i = 1, 24 do
		local k = ((self.CurrentAuraPage - 1) * 24) + i
		local aura = self.Auras[k]
		local icon = _G["PowaIcone"..i]
		-- Icon
		icon.aura = aura
		if aura == nil then
			icon:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
			icon:SetText("")
			icon:SetAlpha(0.33)
		else
			if aura.buffname == "" or aura.buffname == " " then
				self:DeleteAura(aura)
				icon:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
			elseif aura.icon == "" then
				icon:SetNormalTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
			else
				icon:SetNormalTexture(aura.icon)
			end
			if aura.buffname ~= "" and aura.buffname ~= " " and aura.off then
				icon:SetText("OFF")
			else
				icon:SetText("")
			end
			-- Highlighting the current aura icon
			if self.CurrentAuraId == k then -- The current button
				if aura == nil or aura.buffname == "" or aura.buffname == " " then
					PowaSelected:Hide()
				else
					PowaSelected:SetPoint("CENTER", "PowaIcone"..i, "CENTER")
					PowaSelected:Show()
				end
			end
			-- Descrease alpha for non-visible auras
			if not aura.Showing then
				icon:SetAlpha(0.33)
			else
				if hideAll then
					icon:SetAlpha(0.33)
				else
					icon:SetAlpha(1.0)
				end
			end
		end
	end
	-- Select the current list
	_G["PowaOptionsList"..self.CurrentAuraPage]:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
	_G["PowaOptionsList"..self.CurrentAuraPage]:LockHighlight()
end

local function ReverseTable(t)
	if type(t) ~= "table" then
		return
	end
	local r = { }
	for k, v in pairs(t) do
		r[v] = k
	end
	return r
end

--[[local function GetTableNumber(t, s)
	if type(t) ~= "table" then
		return
	end
	for k, v in pairs(t) do
		if v == s then
			return k
		end
	end
	return false
end

local function GetTableNumberAll(t, s)
	if type(t) ~= "table" then
		return
	end
	local r = { }
	for k, v in pairs(t) do
		if v == s then
			table.insert(r, k)
		end
	end
	if not r[1] then
		return nil
	end
	return r
end]]

function PowaAurasOptions:IconClick(owner, button)
	if self.MoveEffect > 0 then -- Move mode
		return
	end
	if ColorPickerFrame:IsVisible() then
		return
	end
	local aura = owner.aura
	if not aura or aura.buffname == "" or aura.buffname == " " then
		return
	end
	if IsShiftKeyDown() then
		if aura.off then
			aura.off = false
			owner:SetText("")
		else
			aura.off = true
			owner:SetText("OFF")
			owner:SetAlpha(0.33)
		end
	elseif IsControlKeyDown() then
		local show, reason = self:TestThisEffect(aura.id, true)
		if show then
			self:Message(self:InsertText(self.Text.nomReasonShouldShow, reason))
		else
			self:Message(self:InsertText(self.Text.nomReasonWontShow, reason))
		end
	elseif IsAltKeyDown() then
		if button == "RightButton" then
			self:IconOnMouseWheel(1)
		else
			self:IconOnMouseWheel(0)
		end
	elseif self.CurrentAuraId == aura.id then
		if button == "RightButton" then
			if not aura.off then
				if not aura.Showing then
					owner:SetAlpha(1.0)
				end
			end
			self:EditorShow()
		else
			if not aura.off then
				if not aura.Showing then
					owner:SetAlpha(1.0)
				else
					owner:SetAlpha(0.33)
				end
				PowaAurasOptions:OptionTest()
			end
		end
	elseif self.CurrentAuraId ~= aura.id then
		self:SetCurrent(owner, aura.id)
		PowaMisc.GroupSize = 1
		if button == "RightButton" then
			if not aura.off then
				if not aura.Showing then
					owner:SetAlpha(1.0)
				end
			end
			PowaBarConfigFrame:Hide()
			self:EditorShow()
		else
			if PowaBarConfigFrame:IsVisible() then
				self:InitPage(aura)
				local aura = self.Auras[self.CurrentAuraId]
				if aura.bufftype == self.BuffTypes.Slots then
					if not PowaEquipmentSlotsFrame:IsVisible() then
						PowaEquipmentSlotsFrame:Show()
					end
				else
					if PowaEquipmentSlotsFrame:IsVisible() then
						PowaEquipmentSlotsFrame:Hide()
					end
				end
			end
			PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
		end
		if PowaFontSelectorFrame:IsVisible() then
			PowaFontSelectorFrame:Hide()
		end
	end
end

function PowaAurasOptions:SetCurrent(icon, auraId)
	self.CurrentAuraId = auraId
	if not icon then
		return
	end
	PowaSelected:SetPoint("Center", icon, "Center")
	PowaSelected:Show()
end

function PowaAurasOptions:IconEntered(owner)
	local iconID = owner:GetID()
	local k = ((self.CurrentAuraPage - 1) * 24) + iconID
	local aura = self.Auras[k]
	if self.MoveEffect > 0 then
		return
	elseif aura == nil then
		-- If not active
	elseif aura.buffname == "" or aura.buffname == " " then
		-- If no name
	else
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		aura:AddExtraTooltipInfo(GameTooltip)
		if aura.party then
			GameTooltip:AddLine("("..self.Text.nomCheckParty..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.exact then
			GameTooltip:AddLine("("..self.Text.nomExact..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.mine then
			if aura.bufftype == self.BuffTypes.thenActionReady then
				GameTooltip:AddLine("("..self.Text.nomIgnoreUseable..")", 1.0, 0.2, 0.2, 1)
			elseif aura.bufftype == self.BuffTypes.Buff or aura.bufftype == self.BuffTypes.Debuff then
				GameTooltip:AddLine("("..self.Text.nomMine..")", 1.0, 0.2, 0.2, 1)
			elseif aura.bufftype == self.BuffTypes.TypeBuff or aura.bufftype == self.BuffTypes.TypeDebuff then
				GameTooltip:AddLine("("..self.Text.nomDispellable..")", 1.0, 0.2, 0.2, 1)
			elseif aura.bufftype == self.BuffTypes.Items then
				GameTooltip:AddLine("("..self.Text.nomIgnoreItemUseable..")", 1.0, 0.2, 0.2, 1)
			elseif aura.bufftype == self.BuffTypes.SpellCooldown then
				GameTooltip:AddLine("("..self.Text.nomSpellLearned..")", 1.0, 0.2, 0.2, 1)
			elseif aura.bufftype == self.BuffTypes.SpellAlert then
				GameTooltip:AddLine("("..self.Text.nomCanInterrupt..")", 1.0, 0.2, 0.2, 1)
			end
		end
		if aura.focus then
			GameTooltip:AddLine("("..self.Text.nomCheckFocus..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.raid then
			GameTooltip:AddLine("("..self.Text.nomCheckRaid..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.groupOrSelf then
			GameTooltip:AddLine("("..self.Text.nomCheckGroupOrSelf..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.optunitn then
			GameTooltip:AddLine("("..self.Text.nomCheckOptunitn..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.target then
			GameTooltip:AddLine("("..self.Text.nomCheckTarget..")", 1.0, 0.2, 0.2, 1)
		end
		if aura.targetfriend then
			if aura.bufftype == self.BuffTypes.SpellCooldown then
				GameTooltip:AddLine("("..self.Text.nomPetCooldown..")", 0.2, 1.0, 0.2, 1)
			else
				GameTooltip:AddLine("("..self.Text.nomCheckFriend..")", 0.2, 1.0, 0.2, 1)
			end
		end
		GameTooltip:AddLine(self.Text.aideEffectTooltip, 1.0, 1.0, 1.0, 1)
		GameTooltip:AddLine(self.Text.aideEffectTooltip3, 1.0, 1.0, 1.0, 1)
		GameTooltip:AddLine(self.Text.aideEffectTooltip2, 1.0, 1.0, 1.0, 1)
		GameTooltip:Show()
	end
end

function PowaAurasOptions:MainListClick(owner)
	local listID = owner:GetID()
	if self.MoveEffect == 1 then
		-- Copy the aura
		self:BeginCopyEffect(self.CurrentAuraId, listID)
		return
	elseif self.MoveEffect == 2 then
		-- Move the aura
		self:BeginMoveEffect(self.CurrentAuraId, listID)
		return
	end
	if IsShiftKeyDown() then
		local min = ((listID - 1) * 24) + 1
		local max = min + 23
		local allEnabled = true
		local offText = "OFF"
		for i = min, max do
			local aura = self.Auras[i]
			if aura and aura.off then
				allEnabled = false
				offText = ""
				break
			end
		end
		for i = min, max do
			local aura = self.Auras[i]
			if aura then
				local auraIcon = _G["PowaIcone"..(i - min + 1)]
				aura.off = allEnabled
				if self.CurrentAuraPage == listID then
					auraIcon:SetText(offText)
					auraIcon:SetAlpha(0.33)
				end
			end
			self.SecondaryAuras[i] = nil
		end
		self.DoCheck.All = true
		PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
		return
	end
	if self.CurrentAuraPage ~= listID then
		_G["PowaOptionsList"..self.CurrentAuraPage]:SetHighlightTexture("")
		_G["PowaOptionsList"..self.CurrentAuraPage]:UnlockHighlight()
		PowaMisc.GroupSize = 1
		PowaSelected:Hide()
		self.CurrentAuraPage = listID
		self.CurrentAuraId = ((self.CurrentAuraPage - 1) * 24) + 1
		local aura = self.Auras[self.CurrentAuraId]
		if aura ~= nil and aura.buffname ~= "" and aura.buffname ~= " " then
			if PowaBarConfigFrame:IsVisible() then
				self:InitPage(aura)
			end
		else
			if PowaBarConfigFrame:IsVisible() then
				self:EditorClose()
			end
		end
		-- Set text for rename
		local currentText = _G["PowaOptionsList"..self.CurrentAuraPage]:GetText()
		if not currentText then
			currentText = ""
		end
		PowaOptionsRenameEditBox:SetText(currentText)
		self:UpdateMainOption()
	end
	PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
end

function PowaAurasOptions:MainListEntered(owner)
	local listID = owner:GetID()
	if self.CurrentAuraPage ~= listID then
		if self.MoveEffect > 0 then
			_G["PowaOptionsList"..listID]:SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight")
		else
			_G["PowaOptionsList"..listID]:SetHighlightTexture("")
			_G["PowaOptionsList"..listID]:UnlockHighlight()
		end
	end
	if self.MoveEffect == 1 then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.Text.aideCopy, nil, nil, nil, nil, 1)
		GameTooltip:Show()
	elseif self.MoveEffect == 2 then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.Text.aideMove, nil, nil, nil, nil, 1)
		GameTooltip:Show()
	end
end

function PowaAurasOptions:OptionRename()
	PowaOptionsRename:Hide()
	PowaOptionsRenameEditBox:Show()
	local currentText = _G["PowaOptionsList"..self.CurrentAuraPage]:GetText()
	if currentText == nil then
		currentText = ""
	end
	PowaOptionsRenameEditBox:SetText( currentText )
end

function PowaAurasOptions:OptionRenameEdited()
	PowaOptionsRename:Show()
	PowaOptionsRenameEditBox:Hide()
	_G["PowaOptionsList"..self.CurrentAuraPage]:SetText( PowaOptionsRenameEditBox:GetText() )
	if self.CurrentAuraPage > 5 then
		PowaGlobalListe[self.CurrentAuraPage - 5] = PowaOptionsRenameEditBox:GetText()
	else
		PowaPlayerListe[self.CurrentAuraPage] = PowaOptionsRenameEditBox:GetText()
	end
	PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
end

function PowaAurasOptions:TriageIcons(nPage)
	local min = ((nPage - 1) * 24) + 1
	local max = min + 23
	-- Hide any auras on this page
	for i = min, max do
		local aura = self.Auras[i]
		if aura then
			aura:Hide()
		end
		self.SecondaryAuras[i] = nil
	end
	local a = min
	for i = min, max do
		if self.Auras[i] then
			if i ~= a then
				self:ReindexAura(i, a)
			end
			if i > a then
				self.Auras[i] = nil
			end
			a = a + 1
		end
	end
	-- Keep global auras in step
	for i = 121, 360 do
		if self.Auras[i] then
			PowaGlobalSet[i] = self.Auras[i]
		else
			PowaGlobalSet[i] = nil
		end
	end
end

function PowaAurasOptions:ReindexAura(oldId, newId)
	self.Auras[newId] = self.Auras[oldId]
	self.Auras[newId].id = newId
	if self.Auras[newId].Timer then
		self.Auras[newId].Timer.id = newId
	end
	if self.Auras[newId].Stacks then
		self.Auras[newId].Stacks.id = newId
	end
	-- Update any multi-id references
	for i = 1, 360 do
		local aura = self.Auras[i]
		if aura then
			if aura.multiids and aura.multiids ~= "" then
				local newMultiids = ""
				local sep = ""
				for multiId in string.gmatch(aura.multiids, "[^/]+") do
					if tonumber(multiId) == oldId then
						newMultiids = newMultiids..sep..tostring(newId)
					else
						newMultiids = newMultiids..sep..multiId
					end
					sep = "/"
				end
				aura.multiids = newMultiids
			end
		end
	end
end

function PowaAurasOptions:DeleteAura(aura)
	if not aura then
		return
	end
	aura:Hide()
	if aura.Timer then
		aura.Timer:Dispose()
	end
	if aura.Stacks then
		aura.Stacks:Dispose()
	end
	aura:Dispose()
	PowaSelected:Hide()
	if PowaBarConfigFrame:IsVisible() then
		PowaBarConfigFrame:Hide()
	end
	if ColorPickerFrame:IsVisible() then
		ColorPickerFrame:Hide()
	end
	if PowaFontSelectorFrame:IsVisible() then
		PowaFontSelectorFrame:Hide()
	end
	self.Auras[aura.id] = nil
	if aura.id > 120 then
		PowaGlobalSet[aura.id] = nil
	end
end

function PowaAurasOptions:OptionDeleteEffect(auraId)
	if not IsControlKeyDown() then
		return
	end
	local currentAuraId = self.CurrentAuraId
	self:DeleteAura(self.Auras[auraId])
	self:TriageIcons(self.CurrentAuraPage)
	PowaMisc.GroupSize = 1
	self:CalculateAuraSequence()
	if currentAuraId == self:GetNextFreeSlot() then
		self.CurrentAuraId = self:GetNextFreeSlot() - 1
	end
	self:UpdateMainOption()
end

function PowaAurasOptions:GetNextFreeSlot(page)
	if not page then
		page = self.CurrentAuraPage
	end
	local min = ((page - 1) * 24) + 1
	local max = min + 23
	for i = min, max do
		if self.Auras[i] == nil or self.Auras[i].buffname == "" or self.Auras[i].buffname == " " then
			return i
		end
	end
	return nil
end

function PowaAurasOptions:OptionNewEffect()
	local i = self:GetNextFreeSlot()
	if not i then
		self:Message("All aura slots filled.")
		return
	end
	self.CurrentAuraId = i
	self.CurrentAuraPage = self.CurrentAuraPage
	local aura = self:AuraFactory(self.BuffTypes.Buff, i)
	aura:Init()
	self.Auras[i] = aura
	if i > 120 then
		PowaGlobalSet[i] = aura
	end
	self:CalculateAuraSequence()
	aura.Active = true
	aura:CreateFrames()
	self.SecondaryAuras[i] = nil
	self:DisplayAura(i)
	self:UpdateMainOption()
	if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
		PowaBarAuraTextureSlider:SetValue(1)
	end
	self:InitPage(aura)
	if ColorPickerFrame:IsVisible() then
		ColorPickerFrame:Hide()
	end
	if PowaFontSelectorFrame:IsVisible() then
		PowaFontSelectorFrame:Hide()
	end
	if PowaEquipmentSlotsFrame:IsVisible() then
		PowaEquipmentSlotsFrame:Hide()
	end
	if not PowaBarConfigFrame:IsVisible() then
		PowaBarConfigFrame:Show()
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel)
	end
end

function PowaAurasOptions:ExtractImportValue(valueType, value)
	if string.sub(valueType, 1, 2) == "st" then
		return value
	end
	if value == "false" then
		return false
	elseif value == "true" then
		return true
	end
	return tonumber(value)
end

function PowaAurasOptions:ImportAura(aurastring, auraId, offset)
	local aura = cPowaAura(auraId)
	local trimmed = string.gsub(aurastring, ";%s*", ";")
	local settings = {strsplit(";", trimmed)}
	local importAuraSettings = { }
	local importTimerSettings = { }
	local importStacksSettings = { }
	local hasTimerSettings = false
	local hasStacksSettings = false
	local oldSpellAlertLogic = true
	local hasTypePrefix = false
	if not string.find(aurastring, "Version:", 1, true) then
		hasTypePrefix = true
	else
		hasTypePrefix = string.find(aurastring, "Version:st", 1, true)
	end
	if hasTypePrefix then
		for _, val in ipairs(settings) do
			local key, var = strsplit(":", val)
			local varType = string.sub(var, 1, 2)
			var = string.sub(var, 3)
			if key == "Version" then
				local _, _, major, minor, build = string.find(var, self.VersionPattern)
				if self:VersionGreater({Major = tonumber(major), Minor = tonumber(minor), Build = tonumber(build)}, {Major = 3, Minor = 0, Build = 0}) then
					oldSpellAlertLogic = false
				end
			elseif string.sub(key, 1, 6) == "timer." then
				local key = string.sub(key, 7)
				if key == "InvertAuraBelow" then
					if self:IsNumeric(var) then
						importAuraSettings[key] = self:ExtractImportValue(varType, var)
					end
				else
					importTimerSettings[key] = self:ExtractImportValue(varType, var)
					hasTimerSettings = true
				end
			elseif string.sub(key, 1, 7) == "stacks." then
				importStacksSettings[string.sub(key, 8)] = self:ExtractImportValue(varType, var)
				hasStacksSettings = true
			else
				importAuraSettings[key] = self:ExtractImportValue(varType, var)
			end
		end
	else
		for _, val in ipairs(settings) do
			local key, var = strsplit(":", val)
			oldSpellAlertLogic = false
			if key == "Version" then
				-- Do nothing
			elseif string.sub(key, 1, 6) == "timer." then
				key = string.sub(key,7)
				if cPowaTimer.ExportSettings[key] ~= nil then
					importTimerSettings[key] = self:ExtractImportValue(type(cPowaTimer.ExportSettings[key]), var)
					hasTimerSettings = true
				end
			elseif string.sub(key, 1, 7) == "stacks." then
				key = string.sub(key, 8)
				if cPowaStacks.ExportSettings[key] ~= nil then
					importStacksSettings[key] = self:ExtractImportValue(type(cPowaStacks.ExportSettings[key]), var)
					hasStacksSettings = true
				end
			else
				if cPowaAura.ExportSettings[key] ~= nil then
					importAuraSettings[key] = self:ExtractImportValue(type(cPowaAura.ExportSettings[key]), var)
				end
			end
		end
	end
	for k, v in pairs(aura) do
		if importAuraSettings[k] ~= nil then
			local varType = type(v)
			if k == "combat" then
				if importAuraSettings[k] == 0 then
					aura[k] = 0
				elseif importAuraSettings[k] == 1 then
					aura[k] = true
				elseif importAuraSettings[k] == 2 then
					aura[k] = false
				else
					aura[k] = importAuraSettings[k]
				end
			elseif k == "isResting" then
				if importAuraSettings.ignoreResting == true then
					aura[k] = true
				elseif importAuraSettings.ignoreResting == false then
					aura[k] = 0
				else
					aura[k] = importAuraSettings[k]
				end
			elseif k == "inRaid" then
				if importAuraSettings.isinraid == true then
					aura[k] = true
				elseif importAuraSettings.isinraid == false then
					aura[k] = 0
				else
					aura[k] = importAuraSettings[k]
				end
			elseif k == "multiids" and offset then
				local newMultiids = ""
				local sep = ""
				for multiId in string.gmatch(importAuraSettings[k], "[^/]+") do
					multiId = cPowaAura:Trim(multiId)
					local negate = ""
					if string.sub(multiId, 1, 1) == "!" then
						multiId = string.sub(multiId, 2)
						negate = "!"
					end
					local multiIdNumber = tonumber(multiId)
					if multiIdNumber then
						newMultiids = newMultiids..sep..negate..tostring(offset + multiIdNumber)
						sep = "/"
					end
				end
				aura[k] = newMultiids
			elseif k == "icon" then
				if string.find(string.lower(importAuraSettings[k]), string.lower(PowaAurasOptions.IconSource), 1, true) == 1 then
					if importAuraSettings[k] == "" then
						aura[k] = "Interface\\Icons\\Inv_Misc_QuestionMark"
					else
						aura[k] = importAuraSettings[k]
					end
				else
					if importAuraSettings[k] == "" then
						aura[k] = "Interface\\Icons\\Inv_Misc_QuestionMark"
					else
						aura[k] = PowaAurasOptions.IconSource..importAuraSettings[k]
					end
				end
			elseif varType == "string" or varType == "boolean" or varType == "number" and k ~= "id" then
				aura[k] = importAuraSettings[k]
			end
		end
	end
	if aura.bufftype == self.BuffTypes.Combo then -- Backwards compatability
		if string.len(aura.buffname) > 1 and string.find(aura.buffname, "/", 1, true) == nil then
			local newBuffName = string.sub(aura.buffname, 1, 1)
			for i = 2, string.len(aura.buffname) do
				newBuffName = newBuffName.."/"..string.sub(aura.buffname, i, i)
			end
			aura.buffname = newBuffName
		end
	elseif aura.bufftype == self.BuffTypes.SpellAlert then
		if oldSpellAlertLogic then
			if aura.target then
				aura.groupOrSelf = true
			elseif aura.targetfriend then
				aura.targetfriend = false
			end
		end
	end
	if importAuraSettings.timer then -- Backwards compatability
		aura.Timer = cPowaTimer(aura)
	end
	if hasTimerSettings then
		aura.Timer = cPowaTimer(aura, importTimerSettings)
	end
	if hasStacksSettings then
		aura.Stacks = cPowaStacks(aura, importStacksSettings)
	end
	return self:AuraFactory(aura.bufftype, auraId, aura)
end

function PowaAurasOptions:CreateNewAuraFromImport(auraId, importString, updateLink)
	if importString == nil or importString == "" then
		return
	end
	self.Auras[auraId] = self:ImportAura(importString, auraId, updateLink)
	self.Auras[auraId]:Init()
	self:CalculateAuraSequence()
	if auraId > 120 then
		PowaGlobalSet[auraId] = self.Auras[auraId]
	end
end

function PowaAurasOptions:CreateNewAuraSetFromImport(importString)
	if not importString or importString == "" then
		return
	end
	local min = ((self.CurrentAuraPage - 1) * 24) + 1
	local max = min + 23
	for i = min, max do
		if self.Auras[i] then
			self:DeleteAura(self.Auras[i])
		end
	end
	local auraId = min
	local offset
	local setName
	for k, v in string.gmatch(importString, "([^\n=@]+)=([^@]+)@") do
		if k == "Set" then
			setName = v
		else
			if not offset then
				local _, _, oldAuraId = string.find(k, "(%d+)")
				if self:IsNumeric(oldAuraId) then
					offset = min - oldAuraId
				end
			end
			self.Auras[auraId] = self:ImportAura(v, auraId, offset)
			if auraId > 120 then
				PowaGlobalSet[auraId] = self.Auras[auraId]
			end
			auraId = auraId + 1
		end
	end
	if setName then
		local nameFound = false
		for i = 1, 5 do
			if (PowaPlayerListe[i] == setName) then
				nameFound = true
			end
		end
		for i = 1, 10 do
			if (PowaGlobalListe[i] == setName) then
				nameFound = true
			end
		end
		if not nameFound then
			_G["PowaOptionsList"..self.CurrentAuraPage]:SetText( setName )
			if self.CurrentAuraPage > 5 then
				PowaGlobalListe[self.CurrentAuraPage - 5] = setName
			else
				PowaPlayerListe[self.CurrentAuraPage] = setName
			end
		end
	end
	self:CalculateAuraSequence()
	self:UpdateMainOption()
end

function PowaAurasOptions:OptionImportEffect()
	local i = self:GetNextFreeSlot()
	if not i then
		self:Message("All aura slots filled.")
		return
	end
	self.ImportAuraId = i
	StaticPopup_Show("POWERAURAS_IMPORT_AURA")
end

function PowaAurasOptions:CreateAuraSetString()
	local setString = "Set="
	if self.CurrentAuraPage > 5 then
		setString = setString..PowaGlobalListe[self.CurrentAuraPage - 5]
	else
		setString = setString..PowaPlayerListe[self.CurrentAuraPage]
	end
	setString = setString.."@"
	local min = ((self.CurrentAuraPage - 1) * 24) + 1
	local max = min + 23
	for i = min, max do
		if self.Auras[i] ~= nil and self.Auras[i].buffname ~= "" and self.Auras[i].buffname ~= " " then
			setString = setString.."\nAura["..tostring(i).."]="..self.Auras[i]:CreateAuraString(true).."@"
		end
	end
	return setString
end

function PowaAurasOptions:OptionImportSet()
	StaticPopup_Show("POWERAURAS_IMPORT_AURA_SET")
end

function PowaAurasOptions:ImportAuraDialogInit()
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA"] = {
		text = self.Text.aideImport,
		button1 = self.Text.ImportDialogAccept,
		button2 = self.Text.ImportDialogCancel,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAurasOptions:CreateNewAuraFromImport(PowaAurasOptions.ImportAuraId, self.editBox:GetText())
			self:Hide()
		end,
		OnShow = function(self)
			self.editBox:SetFocus()
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow()
			self.editBox:SetText("")
			--PowaAurasOptions:DisplayAura(PowaAurasOptions.CurrentAuraId)
			PowaAurasOptions:UpdateMainOption()
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			PowaAurasOptions:CreateNewAuraFromImport(PowaAurasOptions.ImportAuraId, parent.editBox:GetText())
			parent:Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA_SET"] = {
		text = self.Text.aideImportSet,
		button1 = self.Text.ImportDialogAccept,
		button2 = self.Text.ImportDialogCancel,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize * 24,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAurasOptions:CreateNewAuraSetFromImport(self.editBox:GetText())
			self:Hide()
		end,
		OnShow = function(self)
			self.editBox:SetFocus()
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow()
			self.editBox:SetText("")
			--PowaAurasOptions:DisplayAura(PowaAurasOptions.CurrentAuraId)
			PowaAurasOptions:UpdateMainOption()
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent()
			PowaAurasOptions:CreateNewAuraSetFromImport(parent.editBox:GetText())
			parent:Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	}
end

-- Export Dialog
function PowaAurasOptions:OptionExportEffect()
	if self.Auras[self.CurrentAuraId] then
		PowaAuraExportDialogCopyBox:SetText(PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]:CreateAuraString())
		PowaAuraExportDialog.sendType = 1
		StaticPopupSpecial_Show(PowaAuraExportDialog)
	end
end

function PowaAurasOptions:OptionExportSet()
	PowaAuraExportDialogCopyBox:SetText(PowaAurasOptions:CreateAuraSetString())
	PowaAuraExportDialog.sendType = 2
	StaticPopupSpecial_Show(PowaAuraExportDialog)
end

function PowaAurasOptions:SetDialogTimeout(dialog, timeout)
	if dialog.statusTimeoutLength == timeout then
		if timeout == 0 then
			dialog:SetScript("OnUpdate", nil)
		end
		return
	end
	dialog.statusTimeoutLength = timeout
	dialog.statusTimeout = GetTime() + timeout
	if dialog.statusTimeoutLength > 0 then
		dialog:SetScript("OnUpdate", function(dialog)
			if dialog.statusTimeout <= GetTime() then
				dialog.errorReason = 3
				dialog:SetStatus(3)
			elseif dialog.UpdateTimerDisplay then
				dialog:UpdateTimerDisplay()
			end
		end)
	else
		dialog:SetScript("OnUpdate", nil)
	end
end

function PowaAurasOptions:ExportDialogInit(self)
	self.exclusive = 1
	self.whileDead = 1
	self.hideOnEscape = 1
	self.timeout = 0
	self.errorReason = 1
	self.sendDisplay = ""
	self.sendStatus = 1
	self.sendString = nil
	self.sendTo = nil
	self.sendType = nil
	self.statusTimeout = 0
	self.statusTimeoutLength = 0
	self.AcceptButton = PowaAuraExportDialogSendButton
	self.CancelButton = PowaAuraExportDialogCancelButton
	self.Title = PowaAuraExportDialogSendTitle
	self.EditBox = PowaAuraExportDialogSendBox
	PowaAuraExportDialogTopTitle:SetText(PowaAurasOptions.Text.ExportDialogTopTitle)
	PowaAuraExportDialogCopyTitle:SetText(PowaAurasOptions.Text.ExportDialogCopyTitle)
	PowaAuraExportDialogMidTitle:SetText(PowaAurasOptions.Text.ExportDialogMidTitle)
	PowaAuraExportDialogSendTitle:SetText(PowaAurasOptions.Text.ExportDialogSendTitle1)
	PowaAuraExportDialogSendButton:SetText(PowaAurasOptions.Text.ExportDialogSendButton1)
	PowaAuraExportDialogCancelButton:SetText(PowaAurasOptions.Text.ExportDialogCancelButton)
	self.SetStatus = function(self, status)
		if not PowaAurasOptions.Comms:IsRegistered() then
			status = 6
		end
		self.sendStatus = status or self.sendStatus or 1
		if self.sendStatus == 1 then
			self.Title:SetText(PowaAurasOptions.Text.ExportDialogSendTitle1)
			self.AcceptButton:SetText(PowaAurasOptions.Text.ExportDialogSendButton1)
			self.CancelButton:Enable()
			self.EditBox:Show()
			PowaAurasOptions:SetDialogTimeout(self, 0)
		elseif self.sendStatus >= 2 then
			self.AcceptButton:SetText(PowaAurasOptions.Text.ExportDialogSendButton2)
			self.EditBox:Hide()
			self.AcceptButton:Disable()
			self.CancelButton:Disable()
			if self.sendStatus == 2 then
				PowaAurasOptions:SetDialogTimeout(self, 30)
				self.Title:SetText(format(PowaAurasOptions.Text.ExportDialogSendTitle2, self.sendDisplay, (self.statusTimeout - GetTime())))
			elseif self.sendStatus == 3 then
				local errstring = PowaAurasOptions.Text.ExportDialogSendTitle3c -- Defaults to timeout message
				if self.errorReason == 1 then
					errstring = PowaAurasOptions.Text.ExportDialogSendTitle3a -- In combat
				elseif self.errorReason == 2 then
					errstring = PowaAurasOptions.Text.ExportDialogSendTitle3b -- Autodeclining offers
				elseif self.errorReason == 4 then
					errstring = PowaAurasOptions.Text.ExportDialogSendTitle3d -- Busy with another request
				elseif self.errorReason == 5 then
					errstring = PowaAurasOptions.Text.ExportDialogSendTitle3e -- Declined offer
				end
				self.Title:SetText(format(errstring, self.sendDisplay))
				self.AcceptButton:Enable()
				self.CancelButton:Enable()
				PowaAurasOptions:SetDialogTimeout(self, 0)
			elseif self.sendStatus == 4 then
				self.Title:SetText(PowaAurasOptions.Text.ExportDialogSendTitle4)
				PowaAurasOptions:SetDialogTimeout(self, 10)
			elseif self.sendStatus == 5 then
				self.Title:SetText(PowaAurasOptions.Text.ExportDialogSendTitle5)
				PowaAurasOptions:SetDialogTimeout(self, 0)
				self.AcceptButton:Enable()
				self.CancelButton:Enable()
			elseif self.sendStatus == 6 then
				self.Title:SetText(PowaAurasOptions.Text.aideCommsRegisterFailure)
				self.CancelButton:Enable()
				PowaAurasOptions:SetDialogTimeout(self, 0)
			end
		end
	end
	self.UpdateTimerDisplay = function(self)
		if self.sendStatus == 2 then
			self.Title:SetText(format(PowaAurasOptions.Text.ExportDialogSendTitle2, self.sendDisplay, (self.statusTimeout - GetTime())))
		end
	end
	self.OnShow = function(self)
		self:SetStatus()
		self.sendString = PowaAuraExportDialogCopyBox:GetText()
		PowaAuraExportDialogCopyBox:HighlightText()
		PowaAuraExportDialogCopyBox:SetFocus()
	end
	self.OnAccept = function(self)
		self.sendTo = self.EditBox:GetText()
		if not string.find(self.sendTo, "-") then
			local realm = string.gsub(GetRealmName(), "%s+", "")
			self.sendTo = self.sendTo.."-"..realm
		end
		self.sendDisplay = self.sendTo
		if self.sendStatus == 1 then
			self:SetStatus(2)
			PowaComms:SendAddonMessage("EXPORT_REQUEST", self.sendType, self.sendTo)
		else
			self:SetStatus(1)
		end
	end
	self.OnCancel = function(self)
		StaticPopupSpecial_Hide(self)
	end
	PowaComms:AddHandler("EXPORT_REJECT", function(_, data, from)
		if PowaAuraExportDialog.sendTo == from then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: EXPORT_REJECT from "..from)
			end
			PowaAuraExportDialog.sendTo = nil
			PowaAuraExportDialog.errorReason = tonumber((data or 1), 10)
			PowaAuraExportDialog:SetStatus(3)
		end
	end)
	PowaComms:AddHandler("EXPORT_ACCEPT", function(_, _, from)
		if PowaAuraExportDialog.sendTo == from then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: EXPORT_ACCEPT from "..from)
			end
			PowaAuraExportDialog:SetStatus(4)
			PowaComms:SendAddonMessage("EXPORT_DATA", PowaAuraExportDialog.sendString, from)
			PowaAuraExportDialog:SetStatus(5)
		end
	end)
end

-- Cross-Client Import Dialog
function PowaAurasOptions:PlayerImportDialogInit(self)
	self.exclusive = 1
	self.whileDead = 1
	self.hideOnEscape = 1
	self.timeout = 0
	self.errorReason = 1
	self.receiveDisplay = ""
	self.receiveFrom = nil
	self.receiveStatus = 1
	self.receiveString = nil
	self.receiveType = nil
	self.statusTimeout = 0
	self.statusTimeoutLength = 0
	self.AcceptButton = PowaAuraPlayerImportDialogAcceptButton
	self.CancelButton = PowaAuraPlayerImportDialogCancelButton
	self.Title = PowaAuraPlayerImportDialogDescTitle
	self.Warning = PowaAuraPlayerImportDialogWarningTitle
	PowaAuraPlayerImportDialogTopTitle:SetText(PowaAurasOptions.Text.PlayerImportDialogTopTitle)
	PowaAuraPlayerImportDialogDescTitle:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle1)
	PowaAuraPlayerImportDialogWarningTitle:SetText(PowaAurasOptions.Text.PlayerImportDialogWarningTitle)
	PowaAuraPlayerImportDialogAcceptButton:SetText(PowaAurasOptions.Text.PlayerImportDialogAcceptButton1)
	PowaAuraPlayerImportDialogCancelButton:SetText(PowaAurasOptions.Text.PlayerImportDialogCancelButton1)
	self.SetStatus = function(self, status)
		self.receiveStatus = status or self.receiveStatus or 1
		if self.receiveStatus == 1 then
			self.AcceptButton:Enable()
			self.CancelButton:Enable()
			self.CancelButton:SetText(PowaAurasOptions.Text.PlayerImportDialogCancelButton1)
			self.AcceptButton:SetText(PowaAurasOptions.Text.PlayerImportDialogAcceptButton1)
			self.Title:SetText(format(PowaAurasOptions.Text.PlayerImportDialogDescTitle1, self.receiveDisplay))
			PowaAurasOptions:SetDialogTimeout(self, 25)
			self.Warning:Hide()
		elseif self.receiveStatus >= 2 then
			self.AcceptButton:Disable()
			self.CancelButton:Disable()
			self.CancelButton:SetText(PowaAurasOptions.Text.ExportDialogCancelButton)
			self.Warning:Hide()
			if self.receiveStatus == 2 then
				self.Title:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle2)
				PowaAurasOptions:SetDialogTimeout(self, 10)
			elseif self.receiveStatus == 3 then
				self.Title:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle3)
				self.CancelButton:Enable()
				PowaAurasOptions:SetDialogTimeout(self, 0)
			elseif self.receiveStatus == 4 then
				self.Title:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle4)
				for i = 1, 15 do
					_G["PowaOptionsList"..i.."Glow"]:SetVertexColor(0.5, 0.5, 0.5)
					_G["PowaOptionsList"..i.."Glow"]:Show()
				end
				if self.receiveType == 2 then
					self.Warning:Show()
				end
				self.AcceptButton:SetText(PowaAurasOptions.Text.PlayerImportDialogAcceptButton2)
				PowaAurasOptions:SetDialogTimeout(self, 0)
				self.AcceptButton:Enable()
				self.CancelButton:Enable()
				PowaOptionsFrame:Show()
			elseif self.receiveStatus == 5 then
				self.Title:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle5)
				for i = 1, 15 do
					_G["PowaOptionsList"..i.."Glow"]:Hide()
				end
				self.AcceptButton:SetText(PowaAurasOptions.Text.PlayerImportDialogAcceptButton2)
				PowaAurasOptions:SetDialogTimeout(self, 0)
				self.AcceptButton:Disable()
				self.CancelButton:Enable()
			elseif self.receiveStatus == 6 then
				self.Title:SetText(PowaAurasOptions.Text.PlayerImportDialogDescTitle6)
				self.AcceptButton:SetText(PowaAurasOptions.Text.PlayerImportDialogAcceptButton2)
				self.CancelButton:SetText(PowaAurasOptions.Text.ExportDialogSendButton2)
				PowaAurasOptions:SetDialogTimeout(self, 0)
				self.AcceptButton:Disable()
				self.CancelButton:Enable()
			end
		end
	end
	self.OnShow = function(self)
		self:SetStatus()
	end
	self.OnHide = function(self)
		if self.receiveStatus == 1 and self.receiveFrom then
			PowaComms:SendAddonMessage("EXPORT_REJECT", 5, self.receiveFrom)
		end
		self.receiveFrom = nil
		self.receiveDisplay = ""
		self.receiveString = nil
	end
	self.OnAccept = function(self)
		if self.receiveStatus == 1 and self.receiveFrom then
			PowaComms:SendAddonMessage("EXPORT_ACCEPT", "", self.receiveFrom)
			self:SetStatus(2)
		elseif self.receiveStatus == 4 and self.receiveFrom then
			if self.receiveType == 1 then
				local i = PowaAurasOptions:GetNextFreeSlot()
				if not i then
					self:SetStatus(6)
					return
				end
				PowaAurasOptions:CreateNewAuraFromImport(i, PowaAuraPlayerImportDialog.receiveString)
				PowaAurasOptions:UpdateMainOption()
			elseif self.receiveType == 2 then
				PowaAurasOptions:CreateNewAuraSetFromImport(PowaAuraPlayerImportDialog.receiveString)
			end
			self:SetStatus(5)
		end
	end
	self.OnCancel = function(self)
		if self.receiveStatus == 6 then
			self:SetStatus(4)
			return
		end
		StaticPopupSpecial_Hide(self)
	end
	PowaComms:AddHandler("EXPORT_REQUEST", function(_, data, from)
		if PowaAuraPlayerImportDialog.receiveFrom then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: Rejected EXPORT_REQUEST - Busy.")
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 4, from)
			return
		end
		if InCombatLockdown() then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: Rejected EXPORT_REQUEST - In combat.")
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 1, from)
			return
		end
		if PowaGlobalMisc.BlockIncomingAuras == true then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: Rejected EXPORT_REQUEST - BlockIncomingAuras = true.")
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 2, from)
			return
		end
		PowaAuraPlayerImportDialog:SetPoint("Center")
		PowaAuraPlayerImportDialog:SetStatus(1)
		PowaAuraPlayerImportDialog.receiveFrom = from
		PowaAuraPlayerImportDialog.receiveDisplay = from
		PowaAuraPlayerImportDialog.receiveType = tonumber(data, 10)
		StaticPopupSpecial_Show(PowaAuraPlayerImportDialog)
	end)
	PowaComms:AddHandler("EXPORT_DATA", function(_, data, from)
		if PowaAuraPlayerImportDialog.receiveFrom == from then
			if PowaMisc.Debug then
				PowaAurasOptions:ShowText("Comms: Receiving EXPORT_DATA")
			end
			PowaAuraPlayerImportDialog:SetStatus(4)
			PowaAuraPlayerImportDialog.receiveString = data
		end
	end)
end

function PowaAurasOptions:DisableMoveMode()
	PowaOptionsMove:UnlockHighlight()
	PowaOptionsCopy:UnlockHighlight()
	self.MoveEffect = 0
	for i = 1, 15 do
		_G["PowaOptionsList"..i.."Glow"]:Hide()
	end
	PowaOptionsMove:Enable()
	PowaOptionsCopy:Enable()
	PowaOptionsRename:Enable()
	PowaEditButton:Enable()
	PowaMainTestButton:Enable()
	PowaMainHideAllButton:Enable()
	PowaOptionsSelectorNew:Enable()
	PowaOptionsSelectorDelete:Enable()
end

function PowaAurasOptions:OptionMoveEffect(isMove)
	if not self.Auras[self.CurrentAuraId] or self.Auras[self.CurrentAuraId].buffname == "" or self.Auras[self.CurrentAuraId].buffname == " " then
		return
	end
	-- Set glow for lists
	if self.MoveEffect == 0 then
		if isMove then
			self.MoveEffect = 2
			PowaOptionsMove:LockHighlight()
			PowaOptionsCopy:Disable()
		else
			self.MoveEffect = 1
			PowaOptionsCopy:LockHighlight()
			PowaOptionsMove:Disable()
		end
		for i = 1, 15 do
			_G["PowaOptionsList"..i.."Glow"]:SetVertexColor(0.5, 0.5, 0.5)
			_G["PowaOptionsList"..i.."Glow"]:Show()
		end
		PowaOptionsRename:Disable()
		PowaEditButton:Disable()
		PowaMainTestButton:Disable()
		PowaMainHideAllButton:Disable()
		PowaOptionsSelectorNew:Disable()
		PowaOptionsSelectorDelete:Disable()
	else
		self:DisableMoveMode()
	end
end

function PowaAurasOptions:BeginMoveEffect(Pfrom, ToPage)
	local i = self:GetNextFreeSlot(ToPage)
	if not i then
		self:Message("All aura slots filled.")
		return
	end
	local currentAuraId = self.CurrentAuraId
	self:DoCopyEffect(Pfrom, i, true)
	self:TriageIcons(self.CurrentAuraPage)
	self:CalculateAuraSequence()
	--self.CurrentAuraId = ((self.CurrentAuraPage - 1) * 24) + 1
	self:DisableMoveMode()
	if currentAuraId == self:GetNextFreeSlot() then
		self.CurrentAuraId = self:GetNextFreeSlot() - 1
	end
	self:UpdateMainOption()
	PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
end

function PowaAurasOptions:BeginCopyEffect(Pfrom, ToPage)
	local i = self:GetNextFreeSlot(ToPage)
	if not i then
		self:Message("All aura slots filled.")
		return
	end
	self:DoCopyEffect(Pfrom, i, false)
	self.CurrentAuraId = i
	self:DisableMoveMode()
	self:UpdateMainOption()
	PlaySound("igCharacterInfoTab", PowaMisc.SoundChannel)
end

function PowaAurasOptions:DoCopyEffect(idFrom, idTo, isMove)
	self.Auras[idTo] = self:AuraFactory(self.Auras[idFrom].bufftype, idTo, self.Auras[idFrom])
	self.Auras[idTo]:Init()
	if self.Auras[idFrom].Timer then
		self.Auras[idTo].Timer = cPowaTimer(self.Auras[idTo], self.Auras[idFrom].Timer)
	end
	if self.Auras[idFrom].Stacks then
		self.Auras[idTo].Stacks = cPowaStacks(self.Auras[idTo], self.Auras[idFrom].Stacks)
	end
	if idTo > 120 then
		PowaGlobalSet[idTo] = self.Auras[idTo]
	end
	if isMove then
		self:DeleteAura(self.Auras[idFrom])
		self:TriageIcons(self.CurrentAuraPage)
	end
	PowaMisc.GroupSize = 1
	self:CalculateAuraSequence()
	self:UpdateMainOption()
end

function PowaAurasOptions:MainOptionShow()
	if not InterfaceOptionsFrame:IsShown() then
		tinsert(UISpecialFrames, "PowaOptionsFrame")
	end
	if PowaOptionsFrame:IsVisible() then
		self:MainOptionClose()
	else
		local aura = self.Auras[self.CurrentAuraId]
		if not aura then
			PowaSelected:Hide()
		end
		self:OptionHideAll()
		self.ModTest = true
		self:UpdateMainOption()
		PowaOptionsFrame:Show()
		self:UpdateMainOption(true)
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel)
		if PowaMisc.Disabled then
			self:DisplayText("Power Auras: "..self.Colors.Red..PowaAurasOptions.Text.Disabled.."|r")
		end
	end
end

function PowaAurasOptions:MainOptionClose()
	for i, v in pairs(UISpecialFrames) do
		if v == "PowaOptionsFrame" then
			tremove(UISpecialFrames, i)
		end
	end
	self:DisableMoveMode()
	self.ModTest = false
	if ColorPickerFrame:IsVisible() then
		self.CancelColor()
		ColorPickerFrame:Hide()
	end
	PowaFontSelectorFrame:Hide()
	PowaBarConfigFrame:Hide()
	PowaOptionsFrame:Hide()
	PlaySound("TalentScreenClose", PowaMisc.SoundChannel)
	self:OptionHideAll()
	self:FindAllChildren()
	self:CreateEffectLists()
	self.DoCheck.All = true
	self:NewCheckBuffs()
	self:MemorizeActions()
	self:ReregisterEvents()
end

-- Main Options
function PowaAurasOptions:UpdateTimerOptions()
	local aura = self.Auras[self.CurrentAuraId]
	if not aura then
		return
	end
	if not aura.Timer then
		aura.Timer = cPowaTimer(aura)
	end
	local timer = aura.Timer
	if timer then
		PowaShowTimerButton:SetChecked(timer.enabled)
		PowaTimerAlphaSlider:SetValue(timer.a)
		PowaTimerSizeSlider:SetValue(timer.h)
		-- Timer Postion X Slider
		PowaTimerCoordXSlider:SetMinMaxValues(format("%.0f", timer.x - 10000), format("%.0f", timer.x + 10000))
		PowaTimerCoordXSliderLow:SetText(format("%.0f", timer.x - 700))
		PowaTimerCoordXSliderHigh:SetText(format("%.0f", timer.x + 700))
		PowaTimerCoordXSlider:SetValue(format("%.0f", timer.x))
		PowaTimerCoordXSlider:SetMinMaxValues(format("%.0f", timer.x - 700), format("%.0f", timer.x + 700))
		-- Timer Postion Y Slider
		PowaTimerCoordYSlider:SetMinMaxValues(format("%.0f", timer.y - 10000), format("%.0f", timer.y + 10000))
		PowaTimerCoordYSliderLow:SetText(format("%.0f", timer.y - 400))
		PowaTimerCoordYSliderHigh:SetText(format("%.0f", timer.y + 400))
		PowaTimerCoordYSlider:SetValue(format("%.0f", timer.y))
		PowaTimerCoordYSlider:SetMinMaxValues(format("%.0f", timer.y - 400), format("%.0f", timer.y + 400))
		PowaBuffTimerCentsButton:SetChecked(timer.cents)
		PowaBuffTimerLeadingZerosButton:SetChecked(timer.HideLeadingZeros)
		PowaBuffTimerTransparentButton:SetChecked(timer.Transparent)
		if aura:FullTimerAllowed() then
			-- Show full timer options
			PowaBuffTimerUpdatePingButton:SetChecked(timer.UpdatePing)
			self:EnableCheckBox("PowaBuffTimerUpdatePingButton")
			PowaBuffTimerActivationTime:Enable()
		else
			-- Show cut-down timer options
			PowaBuffTimerUpdatePingButton:SetChecked(false)
			self:DisableCheckBox("PowaBuffTimerUpdatePingButton")
			timer.ShowActivation = true
			PowaBuffTimerActivationTime:Disable()
		end
		PowaBuffTimerActivationTime:SetChecked(timer.ShowActivation)
		PowaBuffTimer99:SetChecked(timer.Seconds99)
		PowaBuffTimerUseOwnColorButton:SetChecked(timer.UseOwnColor)
		PowaTimerColorNormalTexture:SetVertexColor(timer.r, timer.g, timer.b)
		--Lib_UIDropDownMenu_SetSelectedName(PowaDropDownTimerTexture, timer.Texture)
		--Lib_UIDropDownMenu_SetSelectedValue(PowaBuffTimerRelative, timer.Relative)
		PowaDropDownTimerTextureText:SetText(timer.Texture)
		PowaBuffTimerRelativeText:SetText(PowaAurasOptions.Text.Relative[timer.Relative])
		PowaTimerInvertAuraSlider:SetValue(aura.InvertAuraBelow)
		if aura.InvertTimeHides then
			PowaTimerInvertAuraSliderText:SetText(self.Text.nomTimerHideAura)
			PowaTimerInvertAuraSlider.aide = PowaAurasOptions.Text.aidePowaTimerHideAuraSlider
		else
			PowaTimerInvertAuraSliderText:SetText(self.Text.nomTimerInvertAura)
			PowaTimerInvertAuraSlider.aide = PowaAurasOptions.Text.aidePowaTimerInvertAuraSlider
		end
	end
end

function PowaAurasOptions:UpdateStacksOptions()
	local stacks = self.Auras[self.CurrentAuraId].Stacks
	if not stacks then
		return
	end
	PowaShowStacksButton:SetChecked(stacks.enabled)
	PowaStacksAlphaSlider:SetValue(stacks.a)
	PowaStacksSizeSlider:SetValue(stacks.h)
	-- Stacks Postion X Slider
	PowaStacksCoordXSlider:SetMinMaxValues(format("%.0f", stacks.x - 10000), format("%.0f", stacks.x + 10000))
	PowaStacksCoordXSliderLow:SetText(format("%.0f", stacks.x - 700))
	PowaStacksCoordXSliderHigh:SetText(format("%.0f", stacks.x + 700))
	PowaStacksCoordXSlider:SetValue(stacks.x)
	PowaStacksCoordXSlider:SetMinMaxValues(format("%.0f", stacks.x - 700), format("%.0f", stacks.x + 700))
	-- Stacks Postion Y Slider
	PowaStacksCoordYSlider:SetMinMaxValues(format("%.0f", stacks.y - 10000), format("%.0f", stacks.y + 10000))
	PowaStacksCoordYSliderLow:SetText(format("%.0f", stacks.y - 400))
	PowaStacksCoordYSliderHigh:SetText(format("%.0f", stacks.y + 400))
	PowaStacksCoordYSlider:SetValue(format("%.0f", stacks.y))
	PowaStacksCoordYSlider:SetMinMaxValues(format("%.0f", stacks.y - 400), format("%.0f", stacks.y + 400))
	PowaBuffStacksTransparentButton:SetChecked(stacks.Transparent)
	PowaBuffStacksUpdatePingButton:SetChecked(stacks.UpdatePing)
	PowaBuffStacksLegacySizing:SetChecked(stacks.LegacySizing)
	PowaBuffStacksUseOwnColorButton:SetChecked(stacks.UseOwnColor)
	PowaStacksColorNormalTexture:SetVertexColor(stacks.r, stacks.g, stacks.b)
	--Lib_UIDropDownMenu_SetSelectedName(PowaDropDownStacksTexture, stacks.Texture)
	--Lib_UIDropDownMenu_SetSelectedValue(PowaBuffStacksRelative, stacks.Relative)
	PowaDropDownStacksTextureText:SetText(stacks.Texture)
	PowaBuffStacksRelativeText:SetText(PowaAurasOptions.Text.Relative[stacks.Relative])
end

function PowaAurasOptions:SetOptionText(aura)
	PowaDropDownBuffTypeText:SetText(aura.OptionText.typeText)
	PowaRoundIconsButtonText:SetTextColor(0.5, 0.8, 0.9)
	if aura.OptionText.buffNameTooltip then
		PowaBarBuffName:Show()
		PowaBarBuffName.aide = aura.OptionText.buffNameTooltip
	else
		self:DisableTextfield("PowaBarBuffName")
	end
	if aura.OptionText.exactTooltip then
		self:EnableCheckBox("PowaExactButton")
		PowaExactButton.aide = aura.OptionText.exactTooltip
	else
		self:DisableCheckBox("PowaExactButton")
	end
	if aura.OptionText.mineText then
		self:EnableCheckBox("PowaMineButton")
		PowaMineButtonText:SetText(aura.OptionText.mineText)
		PowaMineButton.tooltipText = aura.OptionText.mineTooltip
	else
		PowaMineButton:SetChecked(false)
		self:DisableCheckBox("PowaMineButton")
	end
	if aura.OptionText.extraText then
		self:ShowCheckBox("PowaExtraButton")
		PowaExtraButtonText:SetText(aura.OptionText.extraText)
		PowaExtraButton.tooltipText = aura.OptionText.extraTooltip
	else
		PowaExtraButton:SetChecked(false)
		self:HideCheckBox("PowaExtraButton")
	end
	if aura.OptionText.targetFriendText then
		self:EnableCheckBox("PowaTargetFriendButton")
		PowaTargetFriendButtonText:SetText(aura.OptionText.targetFriendText)
		PowaTargetFriendButtonText:SetTextColor(0.2, 1.0, 0.2)
		PowaTargetFriendButton.tooltipText = aura.OptionText.targetFriendTooltip
	else
		PowaTargetFriendButton:SetChecked(false)
		self:DisableCheckBox("PowaTargetFriendButton")
	end
end

function PowaAurasOptions:ShowOptions(optionsToShow)
	for i = 1, #self.OptionHideables do
		local v = self.OptionHideables[i]
		if optionsToShow and optionsToShow[v] then
			_G[v]:Show()
		else
			_G[v]:Hide()
		end
	end
end

function PowaAurasOptions:EnableCheckBoxes(checkBoxesToEnable)
	for i = 1, #self.OptionCheckBoxes do
		local v = self.OptionCheckBoxes[i]
		if checkBoxesToEnable and checkBoxesToEnable[v] then
			self:EnableCheckBox(v, self.SetColors[v])
		else
			_G[v]:SetChecked(false)
			self:DisableCheckBox(v)
		end
	end
end

function PowaAurasOptions:EnableTernary(ternariesToEnable)
	for i = 1, #self.OptionTernary do
		local v = self.OptionTernary[i]
		if not ternariesToEnable or not ternariesToEnable[v] then
			self:DisableTernary(_G[v])
		end
	end
end

function PowaAurasOptions:SetupOptionsForAuraType(aura)
	self:SetOptionText(aura)
	self:ShowOptions(aura.ShowOptions)
	self:EnableCheckBoxes(aura.CheckBoxes)
	self:EnableTernary(aura.Ternary)
	if aura:ShowTimerDurationSlider() then
		PowaTimerDurationSlider:Show()
	else
		PowaTimerDurationSlider:Hide()
	end
	if aura.CanHaveInvertTime then
		PowaTimerInvertAuraSlider:Show()
	else
		PowaTimerInvertAuraSlider:Hide()
	end
end

function PowaAurasOptions:InitPage(aura)
	if not aura then
		aura = self.Auras[self.CurrentAuraId]
	end
	if PowaMisc.GroupSize > 1 then
		PowaAurasOptions:IconOnMouseWheel(nil)
	end
	-- Dropdowns
	--[[Lib_UIDropDownMenu_SetSelectedName(PowaStrataDropDown, aura.strata)
	Lib_UIDropDownMenu_SetSelectedName(PowaTextureStrataDropDown, aura.texturestrata)
	Lib_UIDropDownMenu_SetSelectedName(PowaBlendModeDropDown, aura.blendmode)
	Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryBlendModeDropDown, aura.secondaryblendmode)
	Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryStrataDropDown, aura.secondarystrata)
	Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryTextureStrataDropDown, aura.secondarytexturestrata)
	Lib_UIDropDownMenu_SetSelectedName(PowaGradientStyleDropDown, aura.gradientstyle)
	Lib_UIDropDownMenu_SetSelectedName(PowaModelCategoryDropDown, self.ModelCategoryList[aura.modelcategory])]]
	PowaStrataDropDownText:SetText(aura.strata)
	PowaTextureStrataDropDownText:SetText(aura.texturestrata)
	PowaBlendModeDropDownText:SetText(aura.blendmode)
	PowaSecondaryBlendModeDropDownText:SetText(aura.secondaryblendmode)
	PowaSecondaryStrataDropDownText:SetText(aura.secondarystrata)
	PowaSecondaryTextureStrataDropDownText:SetText(aura.secondarytexturestrata)
	PowaGradientStyleDropDownText:SetText(aura.gradientstyle)
	PowaModelCategoryDropDownText:SetText(self.ModelCategoryList[aura.modelcategory])
	PowaDropDownAnim1Text:SetText(self.Anim[aura.anim1])
	PowaDropDownAnim2Text:SetText(self.Anim[aura.anim2])
	PowaDropDownAnimBeginText:SetText(self.BeginAnimDisplay[aura.begin])
	PowaDropDownAnimEndText:SetText(self.EndAnimDisplay[aura.finish])
	PowaDropDownPowerTypeText:SetText(self.Text.PowerType[aura.PowerType])
	if not aura.modelcategory or aura.modelcategory == 1 then
		Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
		PowaModelTextureDropDownText:SetText(tostring(aura.modelpath))
	end
	if aura.sound < 30 then
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, aura.sound)
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, 30)
		PowaDropDownSoundText:SetText(self.Sound[aura.sound])
		PowaDropDownSound2Text:SetText(self.Sound[30])
	else
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, 0)
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, aura.sound)
		PowaDropDownSoundText:SetText(self.Sound[0])
		PowaDropDownSound2Text:SetText(self.Sound[aura.sound])
	end
	if aura.soundend < 30 then
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, aura.soundend)
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, 30)
		PowaDropDownSoundEndText:SetText(self.Sound[aura.soundend])
		PowaDropDownSound2EndText:SetText(self.Sound[30])
	else
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, 0)
		--Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, aura.soundend)
		PowaDropDownSoundEndText:SetText(self.Sound[0])
		PowaDropDownSound2EndText:SetText(self.Sound[aura.soundend])
	end
	PowaBarCustomSound.aide = self.Text.aideCustomSound
	PowaBarCustomSoundEnd.aide = self.Text.aideCustomSoundEnd
	PowaDropDownStanceText:SetText(self.PowaStance[aura.stance])
	PowaDropDownGTFOText:SetText(self.PowaGTFO[aura.GTFO])
	PowaBarBuffStacks.aide = self.Text.aideStacks
	PowaOwntexButton:SetChecked(aura.owntex)
	PowaRoundIconsButton:SetChecked(aura.roundicons)
	PowaWowTextureButton:SetChecked(aura.wowtex)
	PowaModelsButton:SetChecked(aura.model)
	PowaCustomModelsButton:SetChecked(aura.modelcustom)
	PowaCustomTextureButton:SetChecked(aura.customtex)
	PowaTextAuraButton:SetChecked(aura.textaura)
	PowaRandomColorButton:SetChecked(aura.randomcolor)
	PowaShowSpinAtBeginning:SetChecked(aura.beginSpin)
	PowaOldAnimation:SetChecked(aura.UseOldAnimations)
	if PowaOldAnimation:GetChecked() == true then
		PowaShowSpinAtBeginning:Hide()
	else
		PowaShowSpinAtBeginning:Show()
	end
	PowaIngoreCaseButton:SetChecked(aura.ignoremaj)
	PowaInverseButton:SetChecked(aura.inverse)
	PowaTargetButton:SetChecked(aura.target)
	PowaTargetFriendButton:SetChecked(aura.targetfriend)
	PowaPartyButton:SetChecked(aura.party)
	PowaFocusButton:SetChecked(aura.focus)
	PowaRaidButton:SetChecked(aura.raid)
	PowaGroupOrSelfButton:SetChecked(aura.groupOrSelf)
	PowaGroupAnyButton:SetChecked(aura.groupany)
	PowaOptunitnButton:SetChecked(aura.optunitn)
	PowaExactButton:SetChecked(aura.exact)
	PowaMineButton:SetChecked(aura.mine)
	PowaThresholdInvertButton:SetChecked(aura.thresholdinvert)
	PowaExtraButton:SetChecked(aura.Extra)
	PowaDesaturateButton:SetChecked(aura.desaturation)
	PowaEnableFullRotationButton:SetChecked(aura.enablefullrotation)
	-- Ternary Logic
	self:TernarySetState(PowaInCombatButton, aura.combat)
	self:TernarySetState(PowaIsInRaidButton, aura.inRaid)
	self:TernarySetState(PowaIsInPartyButton, aura.inParty)
	self:TernarySetState(PowaRestingButton, aura.isResting)
	self:TernarySetState(PowaIsMountedButton, aura.ismounted)
	self:TernarySetState(PowaInVehicleButton, aura.inVehicle)
	self:TernarySetState(PowaInPetBattleButton, aura.inPetBattle)
	self:TernarySetState(PowaIsAliveButton, aura.isAlive)
	self:TernarySetState(PowaPvPButton, aura.PvP)
	self:TernarySetState(PowaScenarioInstanceButton, aura.InstanceScenario)
	self:TernarySetState(PowaScenarioHeroicInstanceButton, aura.InstanceScenarioHeroic)
	self:TernarySetState(Powa5ManInstanceButton, aura.Instance5Man)
	self:TernarySetState(Powa5ManHeroicInstanceButton, aura.Instance5ManHeroic)
	self:TernarySetState(PowaChallangeModeInstanceButton, aura.InstanceChallengeMode)
	self:TernarySetState(Powa10ManInstanceButton, aura.Instance10Man)
	self:TernarySetState(Powa10ManHeroicInstanceButton, aura.Instance10ManHeroic)
	self:TernarySetState(Powa25ManInstanceButton, aura.Instance25Man)
	self:TernarySetState(Powa25ManHeroicInstanceButton, aura.Instance25ManHeroic)
	self:TernarySetState(PowaRoleTankButton, aura.RoleTank)
	self:TernarySetState(PowaRoleHealerButton, aura.RoleHealer)
	self:TernarySetState(PowaRoleMeleDpsButton, aura.RoleMeleDps)
	self:TernarySetState(PowaRoleRangeDpsButton, aura.RoleRangeDps)
	self:TernarySetState(PowaBgInstanceButton, aura.InstanceBg)
	self:TernarySetState(PowaArenaInstanceButton, aura.InstanceArena)
	PowaTimerDurationSlider:SetValue(aura.timerduration)
	self:SetThresholdSlider(aura)
	-- Dual specs
	PowaTalentGroup1Button:SetChecked(aura.spec1)
	PowaTalentGroup2Button:SetChecked(aura.spec2)
	PowaAuraDebugButton:SetChecked(aura.Debug)
	aura:HideShowTabs()
	self:SetupOptionsForAuraType(aura)
	-- Page changes
	if PowaBarConfigFrameEditor4:IsVisible() and not PowaEditorTab4:IsVisible() then
		PanelTemplates_SelectTab(PowaEditorTab1)
		PanelTemplates_DeselectTab(PowaEditorTab2)
		PanelTemplates_DeselectTab(PowaEditorTab4)
		PowaBarConfigFrameEditor1:Show()
		PowaBarConfigFrameEditor2:Hide()
		PowaBarConfigFrameEditor4:Hide()
	end
	-- Sliders
	PowaFrameStrataLevelSlider:SetValue(aura.stratalevel)
	PowaTextureStrataSublevelSlider:SetValue(aura.texturesublevel)
	PowaBarAuraAlphaSlider:SetValue(format("%.0f", aura.alpha * 100))
	PowaBarAuraRotateSlider:SetValue(format("%.0f", aura.rotate))
	if aura.enablefullrotation then
		PowaBarAuraRotateSlider:SetValueStep(1)
	else
		PowaBarAuraRotateSlider:SetValueStep(90)
	end
	-- Model Position Z Slider
	PowaModelPositionZSlider:SetMinMaxValues(format("%.0f", (aura.mz * 100) - 10000), format("%.0f", (aura.mz * 100) + 10000))
	PowaModelPositionZSliderLow:SetText(format("%.0f", (aura.mz * 100) - 100))
	PowaModelPositionZSliderHigh:SetText(format("%.0f", (aura.mz * 100) + 100))
	PowaModelPositionZSlider:SetValue(format("%.0f", aura.mz * 100))
	PowaModelPositionZSlider:SetMinMaxValues(format("%.0f", (aura.mz * 100) - 100), format("%.0f", (aura.mz * 100) + 100))
	-- Model Position X Slider
	PowaModelPositionXSlider:SetMinMaxValues(format("%.0f", (aura.mx * 100) - 10000), format("%.0f", (aura.mx * 100) + 10000))
	PowaModelPositionXSliderLow:SetText(format("%.0f", (aura.mx * 100) - 50))
	PowaModelPositionXSliderHigh:SetText(format("%.0f", (aura.mx * 100) + 50))
	PowaModelPositionXSlider:SetValue(format("%.0f", aura.mx * 100))
	PowaModelPositionXSlider:SetMinMaxValues(format("%.0f", (aura.mx * 100) - 50), format("%.0f", (aura.mx * 100) + 50))
	-- Model Position Y Slider
	PowaModelPositionYSlider:SetMinMaxValues(format("%.0f", (aura.my * 100) - 10000), format("%.0f", (aura.my * 100) + 10000))
	PowaModelPositionYSliderLow:SetText(format("%.0f", (aura.my * 100) - 50))
	PowaModelPositionYSliderHigh:SetText(format("%.0f", (aura.my * 100) + 50))
	PowaModelPositionYSlider:SetValue(format("%.0f", aura.my * 100))
	PowaModelPositionYSlider:SetMinMaxValues(format("%.0f", (aura.my * 100) - 50), format("%.0f", (aura.my * 100) + 50))
	-- Texture Size Slider
	PowaBarAuraSizeSlider:SetMinMaxValues(1, format("%.0f", (aura.size * 100) + 10000))
	PowaBarAuraSizeSliderLow:SetText("1%")
	PowaBarAuraSizeSliderHigh:SetText(format("%.0f", ((aura.size * 100) + 100)).."%")
	PowaBarAuraSizeSlider:SetValue(format("%.0f", aura.size * 100))
	PowaBarAuraSizeSlider:SetMinMaxValues(1, format("%.0f", (aura.size * 100) + 100))
	-- Texture Position X Slider
	PowaBarAuraCoordXSlider:SetMinMaxValues(format("%.0f", aura.x - 10000), format("%.0f", aura.x + 10000))
	PowaBarAuraCoordXSliderLow:SetText(format("%.0f", aura.x - 700))
	PowaBarAuraCoordXSliderHigh:SetText(format("%.0f", aura.x + 700))
	PowaBarAuraCoordXSlider:SetValue(format("%.0f", aura.x))
	PowaBarAuraCoordXSlider:SetMinMaxValues(format("%.0f", aura.x - 700), format("%.0f", aura.x + 700))
	-- Texture Position Y Slider
	PowaBarAuraCoordYSlider:SetMinMaxValues(format("%.0f", aura.y - 10000), format("%.0f", aura.y + 10000))
	PowaBarAuraCoordYSliderLow:SetText(format("%.0f", aura.y - 400))
	PowaBarAuraCoordYSliderHigh:SetText(format("%.0f", aura.y + 400))
	PowaBarAuraCoordYSlider:SetValue(format("%.0f", aura.y))
	PowaBarAuraCoordYSlider:SetMinMaxValues(format("%.0f", aura.y - 400), format("%.0f", aura.y + 400))
	PowaBarAuraAnimSpeedSlider:SetValue(format("%.0f", aura.speed * 100))
	PowaBarAuraDurationSlider:SetValue(format("%.2f", aura.duration))
	PowaBarAuraSymSlider:SetValue(format("%.0f", aura.symetrie))
	PowaBarAnimationSlider:SetValue(format("%.0f", aura.modelanimation))
	PowaBarAuraDeformSlider:SetValue(format("%.2f", aura.torsion))
	PowaBarBuffName:SetText(aura.buffname)
	PowaBarMultiID:SetText(aura.multiids)
	PowaBarTooltipCheck:SetText(aura.tooltipCheck)
	PowaBarCustomSound:SetText(aura.customsound)
	PowaBarCustomSoundEnd:SetText(aura.customsoundend)
	PowaBarUnitn:SetText(aura.unitn)
	PowaBarBuffStacks:SetText(aura:StacksText())
	-- Timer Update
	self:UpdateTimerOptions()
	-- Stacks Update
	self:UpdateStacksOptions()
	if aura.optunitn then
		self:EnableTextfield("PowaBarUnitn")
	elseif aura.optunitn == false then
		self:DisableTextfield("PowaBarUnitn")
	end
	if not aura.icon or aura.icon == "" then
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
	else
		PowaIconTexture:SetTexture(aura.icon)
	end
	local checkTexture
	if aura.owntex then
		checkTexture = AuraTexture:SetTexture(PowaIconTexture:GetTexture())
		PowaBarAuraTextureSlider:Show()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelTextureDropDown:Hide()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSlider:SetValue(aura.texture)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
	elseif aura.wowtex then
		PowaBarAuraTextureSlider:Show()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelTextureDropDown:Hide()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAnimationSlider:Hide()
		if PowaBarAuraTextureSlider:GetValue() > #self.WowTextures then
			PowaBarAuraTextureSlider:SetValue(aura.texture)
			PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures)
		else
			PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures)
			PowaBarAuraTextureSlider:SetValue(aura.texture)
		end
		PowaBarAuraTextureSliderHigh:SetText(#self.WowTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		checkTexture = AuraTexture:SetTexture(self.WowTextures[aura.texture])
	elseif aura.model then
		PowaModelPositionZSlider:Show()
		PowaModelPositionXSlider:Show()
		PowaModelPositionYSlider:Show()
		PowaBarAuraTextureSlider:Show()
		PowaBarAnimationSlider:Show()
		PowaBlendModeDropDown:Hide()
		PowaTextureStrataDropDown:Hide()
		PowaTextureStrataSublevelSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAuraSymSlider:Hide()
		PowaGradientStyleDropDown:Hide()
		PowaModelCategoryDropDown:Show()
		PowaModelTextureDropDown:Show()
		PowaRandomColorButton:Hide()
		PowaDesaturateButton:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomModel)
		local MaxModels
		local ModelCategory
		if not aura.modelcategory or aura.modelcategory == 1 then
			ModelCategory = self.ModelsCreature
			MaxModels = #self.ModelsCreature
		elseif aura.modelcategory == 2 then
			ModelCategory = self.ModelsEnvironments
			MaxModels = #self.ModelsEnvironments
		elseif aura.modelcategory == 3 then
			ModelCategory = self.ModelsInterface
			MaxModels = #self.ModelsInterface
		elseif aura.modelcategory == 4 then
			ModelCategory = self.ModelsSpells
			MaxModels = #self.ModelsSpells
		end
		if not aura.modelpath or aura.modelpath == "" then
			if PowaBarAuraTextureSlider:GetValue() > MaxModels then
				PowaBarAuraTextureSlider:SetValue(aura.texture)
				PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
			else
				PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
				PowaBarAuraTextureSlider:SetValue(aura.texture)
			end
		else
			--[[if tonumber(aura.modelpath) then
				aura.texture = GetTableNumber(ModelCategory, self.ModelsDisplayInfo[tonumber(aura.modelpath)])
			else
				aura.texture = GetTableNumber(ModelCategory, aura.modelpath)
			end
			if not aura.texture then
				local model = PowaAurasOptions.Models[aura.id]
				local displayID = GetTableNumberAll(self.ModelsDisplayInfo, string.lower(model:GetModel()))
				if displayID then
					sort(displayID)
					aura.modelpath = displayID[1]
				else
					aura.modelpath = string.lower(model:GetModel())
				end
				aura.texture = GetTableNumber(ModelCategory, self.ModelsDisplayInfo[tonumber(aura.modelpath)])
				Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
				PowaModelTextureDropDownText:SetText(tostring(aura.modelpath))
			end
			if not aura.texture then
				local model = PowaAurasOptions.Models[aura.id]
				aura.modelpath = string.lower(model:GetModel())
				aura.texture = GetTableNumber(ModelCategory, aura.modelpath)
			end]]
			if PowaBarAuraTextureSlider:GetValue() > MaxModels then
				PowaBarAuraTextureSlider:SetValue(aura.texture)
				PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
			else
				PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
				PowaBarAuraTextureSlider:SetValue(aura.texture)
			end
		end
		PowaBarAuraTextureSliderHigh:SetText(MaxModels)
		self.ModelTextureList = { }
		if not aura.modelcategory or aura.modelcategory == 1 then
			local model = self.Models[aura.id]
			local displayID
			if model then
				displayID = self:GetTableNumberAll(self.ModelsDisplayInfo, model:GetModel())
				if displayID then
					for i = 1, #displayID do
						tinsert(self.ModelTextureList, displayID[i])
					end
					sort(self.ModelTextureList)
				end
			end
			if not displayID then
				PowaModelTextureDropDown:Hide()
			elseif #self.ModelTextureList < 2 then
				PowaModelTextureDropDown:Show()
				Lib_UIDropDownMenu_DisableDropDown(PowaModelTextureDropDown)
			else
				PowaModelTextureDropDown:Show()
				Lib_UIDropDownMenu_EnableDropDown(PowaModelTextureDropDown)
			end
		else
			PowaModelTextureDropDown:Hide()
		end
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	elseif aura.modelcustom then
		PowaModelPositionZSlider:Show()
		PowaModelPositionXSlider:Show()
		PowaModelPositionYSlider:Show()
		PowaBarAnimationSlider:Show()
		PowaBarCustomModelsEditBox:SetText(aura.modelcustompath)
		PowaBlendModeDropDown:Hide()
		PowaTextureStrataDropDown:Hide()
		PowaTextureStrataSublevelSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarAuraTextureSlider:Hide()
		PowaBarCustomModelsEditBox:Show()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAuraSymSlider:Hide()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	elseif aura.customtex then
		PowaBarAuraTextureSlider:Hide()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarAurasText:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaFontButton:Hide()
		PowaBarCustomTexName:Show()
		PowaBarCustomTexName:SetText(aura.customname)
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		checkTexture = AuraTexture:SetTexture(self:CustomTexPath(aura.customname))
	elseif aura.textaura then
		PowaBarAuraTextureSlider:Hide()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAurasText:Show()
		PowaFontButton:Show()
		PowaBarAurasText:SetText(aura.aurastext)
		PowaBarAnimationSlider:Hide()
		--PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\INV_Scroll_02")
	else
		PowaBarAuraTextureSlider:Show()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAnimationSlider:Hide()
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(aura.texture)
			PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		else
			PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
			PowaBarAuraTextureSlider:SetValue(aura.texture)
		end
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		checkTexture = AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture..".tga")
	end
	if not checkTexture then
		AuraTexture:SetTexture("Interface\\CharacterFrame\\TempPortrait.tga")
	end
	if aura.randomcolor then
		self:UpdatePreviewRandomColor(aura)
	else
		self:UpdatePreviewColor(aura)
	end
	PowaColorNormalTexture:SetVertexColor(aura.r, aura.g, aura.b)
	PowaGradientColorNormalTexture:SetVertexColor(aura.gr, aura.gg, aura.gb)
	PowaColor_SwatchBg.r = aura.r
	PowaColor_SwatchBg.g = aura.g
	PowaColor_SwatchBg.b = aura.b
	PowaGradientColor_SwatchBg.r = aura.gr
	PowaGradientColor_SwatchBg.g = aura.gg
	PowaGradientColor_SwatchBg.b = aura.gb
	if PowaMisc.GroupSize == 1 then
		PowaHeader:SetText(self.Text.nomEffectEditor.." ("..aura.id..")")
	else
		PowaHeader:SetText(self.Text.nomEffectEditor.." ("..aura.id.." - "..aura.id + (PowaMisc.GroupSize - 1)..")")
	end
end

-- Don't change this!
function PowaAurasOptions:SetThresholdSlider(aura)
	if not aura.MaxRange then
		return
	end
	local min, max = PowaBarThresholdSlider:GetMinMaxValues()
	if max > aura.MaxRange then
		if aura.PowerType == SPELL_POWER_BURNING_EMBERS then
			PowaBarThresholdSlider:SetValueStep(0.1)
			PowaBarThresholdSlider:SetValue(aura.threshold)
			PowaBarThresholdSlider:SetMinMaxValues(0, aura.MaxRange)
			PowaBarThresholdSliderLow:SetText("0.0"..aura.RangeType)
			PowaBarThresholdSliderHigh:SetText(aura.MaxRange..".0"..aura.RangeType)
			PowaBarThresholdSliderEditBox:SetText(format("%.1f", (PowaBarThresholdSlider:GetValue()))..aura.RangeType)
		else
			PowaBarThresholdSlider:SetValue(aura.threshold)
			PowaBarThresholdSlider:SetValueStep(1)
			PowaBarThresholdSlider:SetMinMaxValues(0, aura.MaxRange)
			PowaBarThresholdSliderLow:SetText("0"..aura.RangeType)
			PowaBarThresholdSliderHigh:SetText(aura.MaxRange..aura.RangeType)
			PowaBarThresholdSliderEditBox:SetText(format("%.0f", (PowaBarThresholdSlider:GetValue()))..aura.RangeType)
		end
	else
		if aura.PowerType == SPELL_POWER_BURNING_EMBERS then
			PowaBarThresholdSlider:SetValueStep(0.1)
			PowaBarThresholdSlider:SetMinMaxValues(0, aura.MaxRange)
			PowaBarThresholdSlider:SetValue(aura.threshold)
			PowaBarThresholdSliderLow:SetText("0"..aura.RangeType)
			PowaBarThresholdSliderHigh:SetText(aura.MaxRange..aura.RangeType)
			PowaBarThresholdSliderEditBox:SetText(format("%.1f", (PowaBarThresholdSlider:GetValue()))..aura.RangeType)
		else
			PowaBarThresholdSlider:SetMinMaxValues(0, aura.MaxRange)
			PowaBarThresholdSlider:SetValue(aura.threshold)
			PowaBarThresholdSlider:SetValueStep(1)
			PowaBarThresholdSliderLow:SetText("0"..aura.RangeType)
			PowaBarThresholdSliderHigh:SetText(aura.MaxRange..aura.RangeType)
			PowaBarThresholdSliderEditBox:SetText(format("%.0f", (PowaBarThresholdSlider:GetValue()))..aura.RangeType)
		end
	end
end

-- Sliders Changed
function PowaAurasOptions:BarAuraTextureSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value == 0 or not value then
		value = 1
		self:SetValue(value)
	end
	local checkTexture
	local aura = self.Auras[self.CurrentAuraId]
	if aura.owntex then
		checkTexture = AuraTexture:SetTexture(aura.icon)
	elseif aura.wowtex then
		checkTexture = AuraTexture:SetTexture(self.WowTextures[value])
	elseif aura.model then
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	elseif aura.modelcustom then
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	elseif aura.customtex then
		checkTexture = AuraTexture:SetTexture(self:CustomTexPath(aura.customname))
	elseif aura.textaura then
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\INV_Scroll_02")
	else
		checkTexture = AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..value..".tga")
	end
	if not checkTexture then
		if aura.owntex then
			AuraTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
		else
			AuraTexture:SetTexture("Interface\\CharacterFrame\\TempPortrait.tga")
		end
	end
	if aura.textaura or AuraTexture:GetTexture() == "Interface\\CharacterFrame\\TempPortrait" or AuraTexture:GetTexture() == "Interface\\Icons\\TEMP" then
		AuraTexture:SetVertexColor(1, 1, 1)
	else
		if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
			AuraTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
		else
			AuraTexture:SetVertexColor(aura.r, aura.g, aura.b)
		end
	end
	if value ~= aura.texture then
		aura.texture = value
		CloseDropDownMenus()
		local model = self.Models[self.CurrentAuraId]
		local texture = self.Textures[self.CurrentAuraId]
		local displayID
		if aura.wowtex then
			texture:SetTexture(self.WowTextures[aura.texture])
		elseif aura.owntex then
			local checkTexture = texture:SetTexture(aura.icon)
			if not checkTexture then
				texture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
			else
				texture:SetTexture(aura.icon)
			end
		elseif aura.model then
			self.ModelTextureList = { }
			if not aura.modelcategory or aura.modelcategory == 1 then
				aura.modelpath = self.ModelsCreature[aura.texture]
				displayID = self:GetTableNumberAll(self.ModelsDisplayInfo, aura.modelpath)
				if displayID then
					for i = 1, #displayID do
						tinsert(self.ModelTextureList, displayID[i])
					end
					sort(self.ModelTextureList)
				end
				if displayID then
					aura.modelpath = tonumber(self.ModelTextureList[1])
					self:ResetModel(aura)
					model:SetDisplayInfo(aura.modelpath)
				else
					self:ResetModel(aura)
					model:SetModel(aura.modelpath)
				end
				if not displayID then
					PowaModelTextureDropDown:Hide()
				elseif #self.ModelTextureList < 2 then
					PowaModelTextureDropDown:Show()
					Lib_UIDropDownMenu_DisableDropDown(PowaModelTextureDropDown)
				else
					PowaModelTextureDropDown:Show()
					Lib_UIDropDownMenu_EnableDropDown(PowaModelTextureDropDown)
				end
				Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
				PowaModelTextureDropDownText:SetText(tostring(aura.modelpath))
			elseif aura.modelcategory == 2 then
				aura.modelpath = self.ModelsEnvironments[aura.texture]
				model:SetModel(self.ModelsEnvironments[aura.texture])
				PowaModelTextureDropDown:Hide()
			elseif aura.modelcategory == 3 then
				aura.modelpath = self.ModelsInterface[aura.texture]
				model:SetModel(self.ModelsInterface[aura.texture])
				PowaModelTextureDropDown:Hide()
			elseif aura.modelcategory == 4 then
				aura.modelpath = self.ModelsSpells[aura.texture]
				model:SetModel(self.ModelsSpells[aura.texture])
				PowaModelTextureDropDown:Hide()
			end
			model:SetCustomCamera(1)
			if model:HasCustomCamera() then
				if aura.mcd and aura.mcy and aura.mcp then
					self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
					local x, y, z = model:GetCameraTarget()
					model:SetCameraTarget(0, y, z)
				end
			end
		else
			texture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
		end
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			local secondaryModel = self.SecondaryModels[self.CurrentAuraId]
			local secondaryTexture = self.SecondaryTextures[self.CurrentAuraId]
			if aura.wowtex then
				secondaryTexture:SetTexture(self.WowTextures[aura.texture])
			elseif aura.model then
				if displayID then
					secondaryModel:SetDisplayInfo(aura.modelpath)
				else
					secondaryModel:SetModel(aura.modelpath)
				end
				secondaryModel:SetCustomCamera(1)
				if secondaryModel:HasCustomCamera() then
					if aura.mcd and aura.mcy and aura.mcp then
						self:SetOrientation(secondaryAura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
						local x, y, z = secondaryModel:GetCameraTarget()
						secondaryModel:SetCameraTarget(0, y, z)
					end
				end
			else
				secondaryTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
			end
		end
	end
end

function PowaAurasOptions:FrameStrataLevelSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.stratalevel then
		aura.stratalevel = value
		local frame = self.Frames[self.CurrentAuraId]
		frame:SetFrameLevel(aura.stratalevel)
	end
end

function PowaAurasOptions:TextureStrataSublevelSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.texturesublevel then
		aura.texturesublevel = value
		local texture = self.Textures[self.CurrentAuraId]
		texture:SetDrawLayer(aura.texturestrata, aura.texturesublevel)
	end
end

function PowaAurasOptions:ModelPositionZSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value / 100 ~= self.Auras[self.CurrentAuraId].mz then
		self.Auras[self.CurrentAuraId].mz = value / 100
		local aura = self.Auras[self.CurrentAuraId]
		local model = self.Models[self.CurrentAuraId]
		model:SetPosition(aura.mz, aura.mx, aura.my)
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			local secondaryModel = self.SecondaryModels[self.CurrentAuraId]
			secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		end
	end
end

function PowaAurasOptions:ModelPositionXSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value / 100 ~= self.Auras[self.CurrentAuraId].mx then
		self.Auras[self.CurrentAuraId].mx = value / 100
		local aura = self.Auras[self.CurrentAuraId]
		local model = self.Models[self.CurrentAuraId]
		model:SetPosition(aura.mz, aura.mx, aura.my)
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			local secondaryModel = self.SecondaryModels[self.CurrentAuraId]
			secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		end
	end
end

function PowaAurasOptions:ModelPositionYSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value / 100 ~= self.Auras[self.CurrentAuraId].my then
		self.Auras[self.CurrentAuraId].my = value / 100
		local aura = self.Auras[self.CurrentAuraId]
		local model = self.Models[self.CurrentAuraId]
		model:SetPosition(aura.mz, aura.mx, aura.my)
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			local secondaryModel = self.SecondaryModels[self.CurrentAuraId]
			secondaryModel:SetPosition(aura.mz, aura.mx, aura.my)
		end
	end
end

function PowaAurasOptions:BarAuraAlphaSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if PowaMisc.GroupSize == 1 then
		if value / 100 ~= aura.alpha then
			aura.alpha = value / 100
			local frame = self.Frames[self.CurrentAuraId]
			frame:SetAlpha(math.min(aura.alpha, 0.99))
			--self:UpdateSecondaryAuraVisuals(aura)
		end
	else
		if value / 100 ~= aura.alpha then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] ~= nil then
					relativepos[i] = self.Auras[i].alpha
				end
			end
			for i = min, max do
				if self.Auras[i] ~= nil then
					if i == min then
						self.Auras[i].alpha = value / 100
					else
						if relativepos[min] < relativepos[i] then
							self.Auras[i].alpha = (value / 100) + (relativepos[i] - relativepos[min])
						else
							self.Auras[i].alpha = (value / 100) + (relativepos[min] - relativepos[i])
						end
					end
					local frame = self.Frames[i]
					frame:SetAlpha(math.min(aura.alpha, 0.99))
					--self:UpdateSecondaryAuraVisuals(self.Auras[i])
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:BarAuraSizeSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if aura.textaura then
		if PowaMisc.GroupSize == 1 then
			if value / 100 ~= aura.size then
				if (value / 100) < 1.61 then
					aura.size = value / 100
					self:UpdateAuraVisuals(aura)
					local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
					if secondaryAura then
						self:UpdateSecondaryAuraVisuals(aura)
					end
					--self:RedisplayAura(self.CurrentAuraId)
				end
			end
		else
			if value / 100 ~= aura.size then
				local min = self.CurrentAuraId
				local max = min + (PowaMisc.GroupSize - 1)
				local relativepos = { }
				for i = min, max do
					if self.Auras[i] ~= nil then
						relativepos[i] = self.Auras[i].size
					end
				end
				for i = min, max do
					if self.Auras[i] ~= nil then
						if i == min then
							self.Auras[i].size = value / 100
						else
							if relativepos[min] < relativepos[i] then
								self.Auras[i].size = (value / 100) + (relativepos[i] - relativepos[min])
							else
								self.Auras[i].size = (value / 100) + (relativepos[min] - relativepos[i])
							end
						end
						self:UpdateAuraVisuals(self.Auras[i])
						local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
						if secondaryAura then
							self:UpdateSecondaryAuraVisuals(self.Auras[i])
						end
						--self:RedisplayAura(i)
					end
				end
				PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
			end
		end
	else
		if PowaMisc.GroupSize == 1 then
			if value / 100 ~= aura.size then
				aura.size = value / 100
				self:UpdateAuraVisuals(aura)
				local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
				if secondaryAura then
					self:UpdateSecondaryAuraVisuals(aura)
				end
				--self:RedisplayAura(self.CurrentAuraId)
			end
		else
			if value / 100 ~= aura.size then
				local min = self.CurrentAuraId
				local max = min + (PowaMisc.GroupSize - 1)
				local relativepos = { }
				for i = min, max do
					if self.Auras[i] ~= nil then
						relativepos[i] = self.Auras[i].size
					end
				end
				for i = min, max do
					if self.Auras[i] ~= nil then
						if i == min then
							self.Auras[i].size = value / 100
						else
							if relativepos[min] < relativepos[i] then
								self.Auras[i].size = (value / 100) + (relativepos[i] - relativepos[min])
							else
								self.Auras[i].size = (value / 100) + (relativepos[min] - relativepos[i])
							end
						end
						self:UpdateAuraVisuals(self.Auras[i])
						local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
						if secondaryAura then
							self:UpdateSecondaryAuraVisuals(self.Auras[i])
						end
						--self:RedisplayAura(i)
					end
				end
				PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
			end
		end
	end
end

function PowaAurasOptions:BarAuraCoordXSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if PowaMisc.GroupSize == 1 then
		if value ~= aura.x then
			aura.x = value
			self:RedisplayAura(self.CurrentAuraId)
		end
	else
		if value ~= aura.x then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] then
					relativepos[i] = self.Auras[i].x
				end
			end
			for i = min, max do
				if self.Auras[i] then
					if i == min then
						self.Auras[i].x = value
					else
						self.Auras[i].x = value + (relativepos[i] - relativepos[min])
					end
					self:RedisplayAura(i)
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
end

function PowaAurasOptions:BarAuraCoordYSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if PowaMisc.GroupSize == 1 then
		if value ~= aura.y then
			aura.y = value
			self:RedisplayAura(self.CurrentAuraId)
		end
	else
		if value ~= aura.y then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] then
					relativepos[i] = self.Auras[i].y
				end
			end
			for i = min, max do
				if self.Auras[i] then
					if i == min then
						self.Auras[i].y = value
					else
						self.Auras[i].y = value + (relativepos[i] - relativepos[min])
					end
					self:RedisplayAura(i)
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
end

function PowaAurasOptions:SecondaryFrameStrataLevelSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.secondarystratalevel then
		aura.secondarystratalevel = value
		local secondaryFrame = self.SecondaryFrames[self.CurrentAuraId]
		if secondaryFrame then
			secondaryFrame:SetFrameLevel(aura.secondarystratalevel)
		end
	end
end

function PowaAurasOptions:SecondaryTextureStrataSublevelSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.secondarytexturesublevel then
		aura.secondarytexturesublevel = value
		local secondaryTexture = self.SecondaryTextures[self.CurrentAuraId]
		if secondaryTexture then
			secondaryTexture:SetDrawLayer(aura.secondarytexturestrata, aura.secondarytexturesublevel)
		end
	end
end

function PowaAurasOptions:BarAuraAnimSpeedSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value / 100 ~= aura.speed then
		aura.speed = value / 100
		self:RedisplayAura(self.CurrentAuraId)
	end
end

function PowaAurasOptions:BarAuraAnimDurationSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.duration then
		aura.duration = value
		--self:RedisplayAura(self.CurrentAuraId)
	end
end

function PowaAurasOptions:BarAuraSymSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value == 0 then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": "..self.Text.aucune)
		--AuraTexture:SetTexCoord(0, 1, 0, 1)
	elseif value == 1 then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": X")
		--AuraTexture:SetTexCoord(1, 0, 0, 1)
	elseif value == 2 then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": Y")
		--AuraTexture:SetTexCoord(0, 1, 1, 0)
	elseif value == 3 then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": XY")
		--AuraTexture:SetTexCoord(1, 0, 1, 0)
	end
	if PowaMisc.GroupSize == 1 then
		if value ~= self.Auras[self.CurrentAuraId].symetrie then
			self.Auras[self.CurrentAuraId].symetrie = value
			self:RedisplayAura(self.CurrentAuraId)
		end
	else
		if value ~= self.Auras[self.CurrentAuraId].symetrie then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] then
					relativepos[i] = self.Auras[i].symetrie
				end
			end
			for i = min, max do
				if self.Auras[i] then
					if i == min then
						self.Auras[i].symetrie = value
					else
						if relativepos[min] < relativepos[i] then
							self.Auras[i].symetrie = value + (relativepos[i] - relativepos[min])
						else
							self.Auras[i].symetrie = value + (relativepos[min] - relativepos[i])
						end
					end
					self:RedisplayAura(i)
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
end

function PowaAurasOptions:BarAnimationSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if value == - 1 then
		PowaBarAnimationSliderText:SetText("Animation: Default")
	else
		PowaBarAnimationSliderText:SetText("Animation: "..value)
	end
	if value ~= self.Auras[self.CurrentAuraId].modelanimation then
		self.Auras[self.CurrentAuraId].modelanimation = value
		self:RedisplayAura(self.CurrentAuraId)
	end
end

function PowaAurasOptions:BarAuraRotateSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	--[[if self.Auras[self.CurrentAuraId].textaura ~= true then
		AuraTexture:SetPoint("CENTER")
		AuraTexture:SetRotation(math.rad(value))
	end]]
	local aura = self.Auras[self.CurrentAuraId]
	if PowaMisc.GroupSize == 1 then
		if value ~= aura.rotate then
			aura.rotate = value
			if not aura.textaura and not aura.model and not aura.modelcustom then
				self:RedisplayAuraVisuals(self.CurrentAuraId)
			elseif aura.model or aura.modelcustom then
				local model = self.Models[self.CurrentAuraId]
				model:SetRotation(math.rad(aura.rotate))
				local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
				if secondaryAura then
					local secondaryModel = self.SecondaryModels[self.CurrentAuraId]
					secondaryModel:SetRotation(math.rad(aura.rotate))
				end
			end
		end
	else
		if value ~= aura.rotate then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] then
					relativepos[i] = self.Auras[i].rotate
				end
			end
			for i = min, max do
				if self.Auras[i] then
					if i == min then
						self.Auras[i].rotate = value
					else
						if relativepos[min] < relativepos[i] then
							self.Auras[i].rotate = value + (relativepos[i] - relativepos[min])
						else
							self.Auras[i].rotate = value + (relativepos[min] - relativepos[i])
						end
					end
					if not self.Auras[i].textaura and not self.Auras[i].model and not self.Auras[i].modelcustom then
						self:RedisplayAuraVisuals(i)
					elseif self.Auras[i].model or self.Auras[i].modelcustom then
						local model = self.Models[i]
						model:SetRotation(math.rad(aura.rotate))
						local secondaryAura = self.SecondaryAuras[i]
						if secondaryAura then
							local secondaryModel = self.SecondaryModels[i]
							secondaryModel:SetRotation(math.rad(aura.rotate))
						end
					end
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
end

function PowaAurasOptions:BarAuraDeformSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	if PowaMisc.GroupSize == 1 then
		if value ~= self.Auras[self.CurrentAuraId].torsion then
			self.Auras[self.CurrentAuraId].torsion = value
			self:RedisplayAura(self.CurrentAuraId)
		end
	else
		if value ~= self.Auras[self.CurrentAuraId].torsion then
			local min = self.CurrentAuraId
			local max = min + (PowaMisc.GroupSize - 1)
			local relativepos = { }
			for i = min, max do
				if self.Auras[i] then
					relativepos[i] = self.Auras[i].torsion
				end
			end
			for i = min, max do
				if self.Auras[i] then
					if i == min then
						self.Auras[i].torsion = value
					else
						if relativepos[min] < relativepos[i] then
							self.Auras[i].torsion = value + (relativepos[i] - relativepos[min])
						else
							self.Auras[i].torsion = value + (relativepos[min] - relativepos[i])
						end
					end
					self:RedisplayAura(i)
				end
			end
			PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
		end
	end
end

function PowaAurasOptions:BarThresholdSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	-- Don't use ~= checker!
	local aura = self.Auras[self.CurrentAuraId]
	if aura.PowerType == SPELL_POWER_BURNING_EMBERS then
		aura.threshold = tonumber(format("%.1f", value))
		PowaBarThresholdSliderEditBox:SetText(format("%.1f", value)..aura.RangeType)
	else
		aura.threshold = value
		PowaBarThresholdSliderEditBox:SetText(format("%.0f", value)..aura.RangeType)
	end
end

-- Need some revamp here
function PowaAurasOptions:TextChanged()
	local oldText = PowaBarBuffName:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldText ~= aura.buffname then
		aura.buffname = PowaBarBuffName:GetText()
		aura.icon = ""
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
	end
end

function PowaAurasOptions:MultiIDChanged()
	local oldText = PowaBarMultiID:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldText ~= aura.multiids then
		aura.multiids = PowaBarMultiID:GetText()
		self:FindAllChildren()
	end
end

function PowaAurasOptions:TooltipCheckChanged()
	local oldText = PowaBarTooltipCheck:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldText ~= aura.tooltipCheck then
		aura.tooltipCheck = PowaBarTooltipCheck:GetText()
	end
end

function PowaAurasOptions:StacksTextChanged()
	local aura = self.Auras[self.CurrentAuraId]
	aura:SetStacks(PowaBarBuffStacks:GetText())
end

function PowaAurasOptions:UnitnTextChanged()
	local oldUnitnText = PowaBarUnitn:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldUnitnText ~= aura.unitn then
		aura.unitn = PowaBarUnitn:GetText()
	end
end

function PowaAurasOptions:CustomTextChanged()
	local aura = self.Auras[self.CurrentAuraId]
	local editboxtext = PowaBarCustomTexName:GetText()
	if string.find(editboxtext, "%\\") then
		editboxtext = strtrim(editboxtext, "%\\")
	end
	if string.find(editboxtext, "%/") then
		editboxtext = strtrim(editboxtext, "%/")
	end
	while string.find(editboxtext, "%\\\\") do
		editboxtext = string.gsub(editboxtext, "%\\\\", "%\\")
	end
	while string.find(editboxtext, "%//") do
		editboxtext = string.gsub(editboxtext, "%//", "%\\")
	end
	aura.customname = editboxtext
	if string.find(aura.customname, "%.") or not aura.customname or aura.customname == "" then
		aura.enablefullrotation = true
	else
		aura.enablefullrotation = false
		if aura.rotate ~= 0 and aura.rotate ~= 90 and aura.rotate ~= 180 and aura.rotate ~= 270 and aura.rotate ~= 360 then
			PowaBarAuraRotateSlider:SetValue(0)
		end
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:CustomModelsChanged()
	local aura = self.Auras[self.CurrentAuraId]
	local model = self.Models[self.CurrentAuraId]
	local texture = self.Textures[self.CurrentAuraId]
	local editboxtext = PowaBarCustomModelsEditBox:GetText()
	if string.find(editboxtext, "%\\") then
		editboxtext = strtrim(editboxtext, "%\\")
	end
	if string.find(editboxtext, "%/") then
		editboxtext = strtrim(editboxtext, "%/")
	end
	while string.find(editboxtext, "%\\") do
		editboxtext = string.gsub(editboxtext, "%\\", "%/")
	end
	while string.find(editboxtext, "%//") do
		editboxtext = string.gsub(editboxtext, "%//", "%/")
	end
	aura.modelcustompath = editboxtext
	self:ResetModel(aura)
	if aura.modelcustompath and aura.modelcustompath ~= "" then
		if string.find(aura.modelcustompath, "%.m2") then
			model:SetModel(aura.modelcustompath)
		else
			model:SetUnit(string.lower(aura.modelcustompath))
		end
	end
	model:SetCustomCamera(1)
	if model:HasCustomCamera() then
		if aura.mcd and aura.mcy and aura.mcp then
			self:SetOrientation(aura, model, aura.mcd, aura.mcy, aura.mcp)
			local x, y, z = model:GetCameraTarget()
			model:SetCameraTarget(0, y, z)
		end
	end
	local secondaryAura = self.SecondaryAuras[aura.id]
	if secondaryAura then
		local secondaryModel = self.SecondaryModels[aura.id]
		secondaryModel:SetCustomCamera(1)
		if secondaryModel:HasCustomCamera() then
			if aura.mcd and aura.mcy and aura.mcp then
				self:SetOrientation(secondaryAura, secondaryModel, aura.mcd, aura.mcy, aura.mcp)
				local x, y, z = secondaryModel:GetCameraTarget()
				secondaryModel:SetCameraTarget(0, y, z)
			end
		end
	end
end

function PowaAurasOptions:AurasTextChanged()
	local aura = self.Auras[self.CurrentAuraId]
	aura.aurastext = PowaBarAurasText:GetText()
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:CustomSoundTextChanged(force)
	local oldCustomSound = PowaBarCustomSound:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldCustomSound ~= aura.customsound or force then
		aura.customsound = oldCustomSound
		if aura.customsound ~= "" then
			aura.sound = 0
			PowaDropDownSoundText:SetText(self.Sound[0])
			PowaDropDownSound2Text:SetText(self.Sound[30])
			PowaDropDownSoundButton:Disable()
			PowaDropDownSound2Button:Disable()
			local pathToSound
			if string.find(aura.customsound, "\\") or string.find(aura.customsound, "/") then
				pathToSound = aura.customsound
			else
				pathToSound = PowaGlobalMisc.PathToSounds..aura.customsound
			end
			local played = PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		else
			PowaDropDownSoundButton:Enable()
			PowaDropDownSound2Button:Enable()
		end
	end
end

function PowaAurasOptions:CustomSoundEndTextChanged(force)
	local oldCustomSound = PowaBarCustomSoundEnd:GetText()
	local aura = self.Auras[self.CurrentAuraId]
	if oldCustomSound ~= aura.customsoundend or force then
		aura.customsoundend = oldCustomSound
		if aura.customsoundend ~= "" then
			aura.soundend = 0
			PowaDropDownSoundEndText:SetText(self.Sound[0])
			PowaDropDownSound2EndText:SetText(self.Sound[30])
			PowaDropDownSoundEndButton:Disable()
			PowaDropDownSound2EndButton:Disable()
			local pathToSound
			if string.find(aura.customsoundend, "\\") or string.find(aura.customsoundend, "/") then
				pathToSound = aura.customsoundend
			else
				pathToSound = PowaGlobalMisc.PathToSounds..aura.customsoundend
			end
			local played = PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		else
			PowaDropDownSoundEndButton:Enable()
			PowaDropDownSound2EndButton:Enable()
		end
	end
end

function PowaAurasOptions:InverseChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaInverseButton:GetChecked() then
		aura.inverse = true
	else
		aura.inverse = false
	end
	if self.Auras[self.CurrentAuraId].Stacks and self.Auras[self.CurrentAuraId].Stacks.enabled == true then
		self.Auras[self.CurrentAuraId].Stacks:Dispose()
	end
	self:RebuildAura(self.CurrentAuraId)
	aura:HideShowTabs()
end

function PowaAurasOptions:IgnoreMajChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaIngoreCaseButton:GetChecked() then
		aura.ignoremaj = true
	else
		aura.ignoremaj = false
	end
end

function PowaAurasOptions:ExactChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaExactButton:GetChecked() then
		aura.exact = true
	else
		aura.exact = false
	end
end

function PowaAurasOptions:RandomColorChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaRandomColorButton:GetChecked() then
		aura.randomcolor = true
		self:UpdateRandomColor(aura)
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			self:UpdateSecondaryRandomColor(aura)
		end
	else
		aura.randomcolor = false
		self:UpdateColor(aura)
		local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
		if secondaryAura then
			self:UpdateSecondaryColor(aura)
		end
	end
end

function PowaAurasOptions:ThresholdInvertChecked(owner)
	local aura = self.Auras[self.CurrentAuraId]
	if PowaThresholdInvertButton:GetChecked() then
		aura.thresholdinvert = true
	else
		aura.thresholdinvert = false
	end
end

function PowaAurasOptions:OwntexChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaOwntexButton:GetChecked() then
		aura.owntex = true
		aura.model = false
		aura.modelcustom = false
		aura.wowtex = false
		aura.customtex = false
		aura.textaura = false
		aura.enablefullrotation = false
		PowaWowTextureButton:SetChecked(false)
		PowaModelsButton:SetChecked(false)
		PowaCustomTextureButton:SetChecked(false)
		PowaTextAuraButton:SetChecked(false)
		PowaCustomModelsButton:SetChecked(false)
		if aura.rotate ~= 0 and aura.rotate ~= 90 and aura.rotate ~= 180 and aura.rotate ~= 270 and aura.rotate ~= 360 then
			PowaBarAuraRotateSlider:SetValue(0)
		end
		if not PowaBarAuraTextureSlider:IsVisible() then
			PowaBarAuraTextureSlider:Show()
		end
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		local checkTexture = AuraTexture:SetTexture(PowaIconTexture:GetTexture())
		if not checkTexture then
			AuraTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
		end
	else
		aura.owntex = false
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:WowTexturesChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaWowTextureButton:GetChecked() then
		aura.wowtex = true
		aura.model = false
		aura.modelcustom = false
		aura.owntex = false
		aura.customtex = false
		aura.textaura = false
		if PowaBarAuraTextureSlider:GetValue() > #self.WowTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures)
		PowaBarAuraTextureSliderHigh:SetText(#self.WowTextures)
		PowaOwntexButton:SetChecked(false)
		PowaModelsButton:SetChecked(false)
		PowaCustomTextureButton:SetChecked(false)
		PowaTextAuraButton:SetChecked(false)
		PowaCustomModelsButton:SetChecked(false)
		PowaBarAuraTextureSlider:Show()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelTextureDropDown:Hide()
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture(self.WowTextures[aura.texture])
	else
		aura.wowtex = false
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:ModelsChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaModelsButton:GetChecked() then
		aura.model = true
		aura.modelcustom = false
		aura.wowtex = false
		aura.owntex = false
		aura.customtex = false
		aura.textaura = false
		self:ResetModel(aura)
		local MaxModels
		if not aura.modelcategory or aura.modelcategory == 1 then
			MaxModels = #self.ModelsCreature
		elseif aura.modelcategory == 2 then
			MaxModels = #self.ModelsEnvironments
		elseif aura.modelcategory == 3 then
			MaxModels = #self.ModelsInterface
		elseif aura.modelcategory == 4 then
			MaxModels = #self.ModelsSpells
		end
		if PowaBarAuraTextureSlider:GetValue() > MaxModels then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
		PowaBarAuraTextureSliderHigh:SetText(MaxModels)
		self.ModelTextureList = { }
		if not aura.modelcategory or aura.modelcategory == 1 then
			aura.modelpath = self.ModelsCreature[aura.texture]
			local displayID = self:GetTableNumberAll(self.ModelsDisplayInfo, aura.modelpath)
			if displayID then
				for i = 1, #displayID do
					tinsert(self.ModelTextureList, displayID[i])
				end
				sort(self.ModelTextureList)
			end
			if displayID then
				aura.modelpath = self.ModelTextureList[1]
			end
			PowaModelTextureDropDown:Show()
			if not displayID then
				PowaModelTextureDropDown:Hide()
			elseif #self.ModelTextureList < 2 then
				PowaModelTextureDropDown:Show()
				Lib_UIDropDownMenu_DisableDropDown(PowaModelTextureDropDown)
			else
				PowaModelTextureDropDown:Show()
				Lib_UIDropDownMenu_EnableDropDown(PowaModelTextureDropDown)
			end
			Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
			PowaModelTextureDropDownText:SetText(tostring(aura.modelpath))
		elseif aura.modelcategory == 2 then
			aura.modelpath = self.ModelsEnvironments[aura.texture]
		elseif aura.modelcategory == 3 then
			aura.modelpath = self.ModelsInterface[aura.texture]
		elseif aura.modelcategory == 4 then
			aura.modelpath = self.ModelsSpells[aura.texture]
		end
		PowaWowTextureButton:SetChecked(false)
		PowaOwntexButton:SetChecked(false)
		PowaCustomTextureButton:SetChecked(false)
		PowaTextAuraButton:SetChecked(false)
		PowaCustomModelsButton:SetChecked(false)
		PowaModelPositionZSlider:Show()
		PowaModelPositionXSlider:Show()
		PowaModelPositionYSlider:Show()
		PowaBarAuraTextureSlider:Show()
		PowaBarAnimationSlider:Show()
		PowaModelCategoryDropDown:Show()
		PowaBlendModeDropDown:Hide()
		PowaTextureStrataDropDown:Hide()
		PowaTextureStrataSublevelSlider:Hide()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		PowaBarAuraSymSlider:Hide()
		PowaGradientStyleDropDown:Hide()
		PowaRandomColorButton:Hide()
		PowaDesaturateButton:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomModel)
		AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	else
		aura.model = false
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:CustomModelsChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaCustomModelsButton:GetChecked() then
		aura.modelcustom = true
		aura.model = false
		aura.customtex = false
		aura.owntex = false
		aura.wowtex = false
		aura.textaura = false
		self:ResetModel(aura)
		PowaModelPositionZSlider:Show()
		PowaModelPositionXSlider:Show()
		PowaModelPositionYSlider:Show()
		PowaBarAuraTextureSlider:Hide()
		PowaBarCustomModelsEditBox:Show()
		PowaBarAnimationSlider:Show()
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:SetText(aura.modelcustompath)
		PowaOwntexButton:SetChecked(false)
		PowaModelsButton:SetChecked(false)
		PowaWowTextureButton:SetChecked(false)
		PowaTextAuraButton:SetChecked(false)
		PowaCustomTextureButton:SetChecked(false)
		PowaBarAurasText:Hide()
		PowaBlendModeDropDown:Hide()
		PowaTextureStrataDropDown:Hide()
		PowaTextureStrataSublevelSlider:Hide()
		PowaBarAuraSymSlider:Hide()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaFontButton:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\Icons\\TEMP")
	else
		aura.modelcustom = false
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAuraTextureSlider:Show()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:CustomTexturesChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaCustomTextureButton:GetChecked() then
		aura.customtex = true
		aura.model = false
		aura.modelcustom = false
		aura.owntex = false
		aura.wowtex = false
		aura.textaura = false
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarAuraTextureSlider:Hide()
		PowaBarCustomTexName:Show()
		PowaBarCustomTexName:SetText(self.Auras[aura.id].customname)
		PowaOwntexButton:SetChecked(false)
		PowaModelsButton:SetChecked(false)
		PowaWowTextureButton:SetChecked(false)
		PowaTextAuraButton:SetChecked(false)
		PowaCustomModelsButton:SetChecked(false)
		PowaBarAurasText:Hide()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaFontButton:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		local checkTexture = AuraTexture:SetTexture(self:CustomTexPath(aura.customname))
		if not checkTexture then
			AuraTexture:SetTexture("Interface\\CharacterFrame\\TempPortrait")
		end
	else
		aura.customtex = false
		PowaBarAuraTextureSlider:Show()
		PowaBarCustomTexName:Hide()
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:TextAuraChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaTextAuraButton:GetChecked() then
		aura.textaura = true
		aura.model = false
		aura.modelcustom = false
		aura.owntex = false
		aura.wowtex = false
		aura.customtex = false
		PowaModelPositionZSlider:Hide()
		PowaModelPositionXSlider:Hide()
		PowaModelPositionYSlider:Hide()
		PowaBarAuraTextureSlider:Hide()
		PowaBlendModeDropDown:Show()
		PowaTextureStrataDropDown:Show()
		PowaTextureStrataSublevelSlider:Show()
		PowaBarAuraSymSlider:Show()
		PowaGradientStyleDropDown:Show()
		PowaModelCategoryDropDown:Hide()
		PowaModelTextureDropDown:Hide()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaRandomColorButton:Show()
		PowaDesaturateButton:Show()
		PowaBarAurasText:Show()
		PowaFontButton:Show()
		PowaBarAurasText:SetText(aura.aurastext)
		PowaOwntexButton:SetChecked(false)
		PowaWowTextureButton:SetChecked(false)
		PowaModelsButton:SetChecked(false)
		PowaCustomTextureButton:SetChecked(false)
		PowaCustomModelsButton:SetChecked(false)
		PowaBarCustomTexName:Hide()
		PowaBarCustomModelsEditBox:Hide()
		PowaBarAnimationSlider:Hide()
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\Icons\\INV_Scroll_02")
	else
		aura.textaura = false
		PowaBarAuraTextureSlider:Show()
		PowaBarAurasText:Hide()
		PowaFontButton:Hide()
		if PowaBarAuraTextureSlider:GetValue() > self.MaxTextures then
			aura.texture = 1
			PowaBarAuraTextureSlider:SetValue(1)
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures)
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures)
		PowaBarAuraTextureSliderText:SetText(PowaAurasOptions.Text.nomTexture)
		AuraTexture:SetTexture("Interface\\AddOns\\PowerAuras\\Auras\\Aura"..aura.texture)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:DesaturationChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaDesaturateButton:GetChecked() then
		aura.desaturation = true
	else
		aura.desaturation = false
	end
	if not aura.model and not aura.custommodel then
		self:RedisplayAura(self.CurrentAuraId)
	end
end

function PowaAurasOptions:EnableFullRotationChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaEnableFullRotationButton:GetChecked() then
		aura.enablefullrotation = true
		PowaBarAuraRotateSlider:SetValueStep(1)
	else
		aura.enablefullrotation = false
		if aura.rotate ~= 0 and aura.rotate ~= 90 and aura.rotate ~= 180 and aura.rotate ~= 270 and aura.rotate ~= 360 then
			PowaBarAuraRotateSlider:SetValue(0)
		end
		PowaBarAuraRotateSlider:SetValueStep(90)
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:RoundIconsChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaRoundIconsButton:GetChecked() then
		aura.roundicons = true
	else
		aura.roundicons = false
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:TargetChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaTargetButton:GetChecked() then
		aura.target = true
	else
		aura.target = false
	end
	self:InitPage()
end

function PowaAurasOptions:TargetFriendChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaTargetFriendButton:GetChecked() then
		aura.targetfriend = true
	else
		aura.targetfriend = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:PartyChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaPartyButton:GetChecked() then
		aura.party = true
	else
		aura.party = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:GroupOrSelfChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaGroupOrSelfButton:GetChecked() then
		aura.groupOrSelf = true
	else
		aura.groupOrSelf = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:FocusChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaFocusButton:GetChecked() then
		aura.focus = true
	else
		aura.focus = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:RaidChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaRaidButton:GetChecked() then
		aura.raid = true
	else
		aura.raid = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:GroupAnyChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaGroupAnyButton:GetChecked() then
		aura.groupany = true
	else
		aura.groupany = false
	end
	self:InitPage(aura)
end

function PowaAurasOptions:OptunitnChecked()
	local aura = self.Auras[self.CurrentAuraId]
	if PowaOptunitnButton:GetChecked() then
		aura.optunitn = true
		PowaBarUnitn:Show()
		PowaBarUnitn:SetText(aura.unitn)
	else
		aura.optunitn = false
		PowaBarUnitn:Hide()
	end
end

-- Dropdown Menus
function PowaAurasOptions.DropDownMenu_Initialize(owner)
	local info
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	local name = owner:GetName()
	if not aura then
		aura = PowaAurasOptions:AuraFactory(PowaAurasOptions.BuffTypes.Buff, 0)
	end
	if name == "PowaStrataDropDown" then
		for i = 1, #PowaAurasOptions.StrataList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.StrataList[i]
			info.func = function(self)
				local strata = PowaAurasOptions.StrataList[i]
				if aura.strata ~= strata then
					aura.strata = strata
					local frame = PowaAurasOptions.Frames[PowaAurasOptions.CurrentAuraId]
					frame:SetFrameStrata(aura.strata)
					Lib_UIDropDownMenu_SetSelectedName(PowaStrataDropDown, strata)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaStrataDropDown, aura.strata)
	elseif name == "PowaTextureStrataDropDown" then
		for i = 1, #PowaAurasOptions.TextureStrataList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TextureStrataList[i]
			info.func = function(self)
				local texturestrata = PowaAurasOptions.TextureStrataList[i]
				local AuraID = PowaAurasOptions.CurrentAuraId
				if aura.texturestrata ~= texturestrata then
					aura.texturestrata = texturestrata
					local texture = PowaAurasOptions.Textures[PowaAurasOptions.CurrentAuraId]
					texture:SetDrawLayer(aura.texturestrata, aura.texturesublevel)
					Lib_UIDropDownMenu_SetSelectedName(PowaTextureStrataDropDown, texturestrata)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaTextureStrataDropDown, aura.texturestrata)
	elseif name == "PowaBlendModeDropDown" then
		for i = 1, #PowaAurasOptions.BlendModeList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.BlendModeList[i]
			info.func = function(self)
				local blendmode = PowaAurasOptions.BlendModeList[i]
				if aura.blendmode ~= blendmode then
					aura.blendmode = blendmode
					local texture = PowaAurasOptions.Textures[PowaAurasOptions.CurrentAuraId]
					texture:SetBlendMode(aura.blendmode)
					Lib_UIDropDownMenu_SetSelectedName(PowaBlendModeDropDown, blendmode)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaBlendModeDropDown, aura.blendmode)
	elseif name == "PowaSecondaryStrataDropDown" then
		for i = 1, #PowaAurasOptions.StrataList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.StrataList[i]
			info.func = function(self)
				local secondarystrata = PowaAurasOptions.StrataList[i]
				if aura.secondarystrata ~= secondarystrata then
					aura.secondarystrata = secondarystrata
					local secondaryFrame = PowaAurasOptions.SecondaryFrames[PowaAurasOptions.CurrentAuraId]
					if secondaryFrame then
						secondaryFrame:SetFrameStrata(aura.secondarystrata)
					end
					Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryStrataDropDown, secondarystrata)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryStrataDropDown, aura.secondarystrata)
	elseif name == "PowaSecondaryTextureStrataDropDown" then
		for i = 1, #PowaAurasOptions.TextureStrataList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TextureStrataList[i]
			info.func = function(self)
				local secondarytexturestrata = PowaAurasOptions.TextureStrataList[i]
				if aura.secondarytexturestrata ~= secondarytexturestrata then
					aura.secondarytexturestrata = secondarytexturestrata
					local secondaryTexture = PowaAurasOptions.SecondaryTextures[PowaAurasOptions.CurrentAuraId]
					if secondaryTexture then
						secondaryTexture:SetDrawLayer(aura.secondarytexturestrata, aura.secondarytexturesublevel)
					end
					Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryTextureStrataDropDown, secondarytexturestrata)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryTextureStrataDropDown, aura.secondarytexturestrata)
	elseif name == "PowaSecondaryBlendModeDropDown" then
		for i = 1, #PowaAurasOptions.BlendModeList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.BlendModeList[i]
			info.func = function(self)
				local secondaryblendmode = PowaAurasOptions.BlendModeList[i]
				if aura.secondaryblendmode ~= secondaryblendmode then
					aura.secondaryblendmode = secondaryblendmode
					local secondaryTexture = PowaAurasOptions.SecondaryTextures[PowaAurasOptions.CurrentAuraId]
					if secondaryTexture then
						secondaryTexture:SetBlendMode(aura.secondaryblendmode)
					end
					Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryBlendModeDropDown, secondaryblendmode)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaSecondaryBlendModeDropDown, aura.secondaryblendmode)
	elseif name == "PowaGradientStyleDropDown" then
		for i = 1, #PowaAurasOptions.GradientStyleList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.GradientStyleList[i]
			info.func = function(self)
				local gradientstyle = PowaAurasOptions.GradientStyleList[i]
				if aura.gradientstyle ~= gradientstyle then
					aura.gradientstyle = gradientstyle
					local texture = PowaAurasOptions.Textures[PowaAurasOptions.CurrentAuraId]
					if not aura.textaura then
						if aura.gradientstyle == "Horizontal" or aura.gradientstyle == "Vertical" then
							if not aura.randomcolor then
								texture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
							else
								PowaAurasOptions:UpdateRandomColor(aura)
							end
						else
							if not aura.randomcolor then
								texture:SetVertexColor(aura.r, aura.g, aura.b)
							else
								PowaAurasOptions:UpdateRandomColor(aura)
							end
						end
					else
						if not aura.randomcolor then
							texture:SetVertexColor(aura.r, aura.g, aura.b)
						else
							PowaAurasOptions:UpdateRandomColor(aura)
						end
					end
					if not aura.randomcolor then
						PowaAurasOptions:UpdatePreviewColor(aura)
					end
					Lib_UIDropDownMenu_SetSelectedName(PowaGradientStyleDropDown, gradientstyle)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaGradientStyleDropDown, aura.gradientstyle)
	elseif name == "PowaModelCategoryDropDown" then
		for i = 1, #PowaAurasOptions.ModelCategoryList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.ModelCategoryList[i]
			info.func = function(self)
				if aura.modelcategory ~= i then
					aura.modelcategory = i
					local MaxModels
					if not aura.modelcategory or aura.modelcategory == 1 then
						MaxModels = #PowaAurasOptions.ModelsCreature
					elseif aura.modelcategory == 2 then
						MaxModels = #PowaAurasOptions.ModelsEnvironments
					elseif aura.modelcategory == 3 then
						MaxModels = #PowaAurasOptions.ModelsInterface
					elseif aura.modelcategory == 4 then
						MaxModels = #PowaAurasOptions.ModelsSpells
					end
					if PowaBarAuraTextureSlider:GetValue() > MaxModels then
						PowaBarAuraTextureSlider:SetValue(1)
					end
					PowaBarAuraTextureSlider:SetMinMaxValues(1, MaxModels)
					PowaBarAuraTextureSliderHigh:SetText(MaxModels)
					Lib_UIDropDownMenu_SetSelectedName(PowaModelCategoryDropDown, PowaAurasOptions.ModelCategoryList[i])
					PowaAurasOptions.ModelTextureList = { }
					if not aura.modelcategory or aura.modelcategory == 1 then
						aura.modelpath = PowaAurasOptions.ModelsCreature[aura.texture]
						local displayID = PowaAurasOptions:GetTableNumberAll(PowaAurasOptions.ModelsDisplayInfo, aura.modelpath)
						if displayID then
							for i = 1, #displayID do
								tinsert(PowaAurasOptions.ModelTextureList, displayID[i])
							end
							sort(PowaAurasOptions.ModelTextureList)
						end
						if displayID then
							aura.modelpath = tonumber(PowaAurasOptions.ModelTextureList[1])
						end
						if not displayID then
							PowaModelTextureDropDown:Hide()
						elseif #PowaAurasOptions.ModelTextureList < 2 then
							PowaModelTextureDropDown:Show()
							Lib_UIDropDownMenu_DisableDropDown(PowaModelTextureDropDown)
						else
							PowaModelTextureDropDown:Show()
							Lib_UIDropDownMenu_EnableDropDown(PowaModelTextureDropDown)
						end
						Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
						PowaModelTextureDropDownText:SetText(tostring(aura.modelpath))
					elseif aura.modelcategory == 2 then
						aura.modelpath = PowaAurasOptions.ModelsEnvironments[aura.texture]
						PowaModelTextureDropDown:Hide()
					elseif aura.modelcategory == 3 then
						aura.modelpath = PowaAurasOptions.ModelsInterface[aura.texture]
						PowaModelTextureDropDown:Hide()
					elseif aura.modelcategory == 4 then
						aura.modelpath = PowaAurasOptions.ModelsSpells[aura.texture]
						PowaModelTextureDropDown:Hide()
					end
					PowaAurasOptions:ResetModel(aura)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaModelCategoryDropDown, PowaAurasOptions.ModelCategoryList[aura.modelcategory])
	elseif name == "PowaModelTextureDropDown" then
		for i = 1, #PowaAurasOptions.ModelTextureList do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.ModelTextureList[i]
			info.func = function(self)
				if aura.modelpath ~= tonumber(PowaAurasOptions.ModelTextureList[i]) then
					aura.modelpath = tonumber(PowaAurasOptions.ModelTextureList[i])
					PowaAurasOptions:Reset(aura)
					local secondaryAura = PowaAurasOptions.SecondaryAuras[PowaAurasOptions.CurrentAuraId]
					if secondaryAura then
						PowaAurasOptions:ResetSecondary(aura)
					end
					Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaModelTextureDropDown, tostring(aura.modelpath))
	elseif name == "PowaDropDownBuffType" then
		PowaAurasOptions:FillDropdownSorted(PowaAurasOptions.Text.AuraType, {func = PowaAurasOptions.DropDownMenu_OnClickBuffType, owner = owner})
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownBuffType, aura.bufftype)
	elseif name == "PowaDropDownPowerType" then
		info = {func = PowaAurasOptions.DropDownMenu_OnClickPowerType, owner = owner}
		for i, name in pairs(PowaAurasOptions.Text.PowerType) do
			info.text = name
			info.value = i
			Lib_UIDropDownMenu_AddButton(info)
		end
		aura:SetFixedIcon()
		PowaAurasOptions:UpdateMainOption()
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownPowerType, aura.PowerType)
	elseif name == "PowaDropDownStance" then
		info = {func = PowaAurasOptions.DropDownMenu_OnClickStance, owner = owner}
		for k, v in pairs(PowaAurasOptions.PowaStance) do
			info.text = v
			info.value = k
			Lib_UIDropDownMenu_AddButton(info)
		end
		aura:SetFixedIcon()
		PowaAurasOptions:UpdateMainOption()
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownStance, aura.stance)
	elseif name == "PowaDropDownGTFO" then
		info = {func = PowaAurasOptions.DropDownMenu_OnClickGTFO, owner = owner}
		for i = 0, #PowaAurasOptions.PowaGTFO do
			info.text = PowaAurasOptions.PowaGTFO[i]
			info.value = i
			Lib_UIDropDownMenu_AddButton(info)
		end
		aura:SetFixedIcon()
		PowaAurasOptions:UpdateMainOption()
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownGTFO, aura.GTFO)
	elseif name == "PowaDropDownAnimBegin" then
		info = {func = PowaAurasOptions.DropDownMenu_OnClickBegin, owner = owner}
		for i = 0, #PowaAurasOptions.BeginAnimDisplay do
			info.text = PowaAurasOptions.BeginAnimDisplay[i]
			info.value = i
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnimBegin, aura.begin)
	elseif name == "PowaDropDownAnimEnd" then
		info = {func = PowaAurasOptions.DropDownMenu_OnClickEnd, owner = owner}
		if aura.UseOldAnimations then
			for i = 0, #PowaAurasOptions.EndAnimDisplay - 2 do
				info.text = PowaAurasOptions.EndAnimDisplay[i]
				info.value = i
				Lib_UIDropDownMenu_AddButton(info)
			end
		else
			for i = 0, #PowaAurasOptions.EndAnimDisplay do
				info.text = PowaAurasOptions.EndAnimDisplay[i]
				info.value = i
				Lib_UIDropDownMenu_AddButton(info)
			end
		end
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnimEnd, aura.finish)
	elseif name == "PowaDropDownAnim1" then
		local tableSize
		if aura.UseOldAnimations then
			tableSize = #PowaAurasOptions.Anim - 2
		else
			tableSize = #PowaAurasOptions.Anim
		end
		for i = 1, tableSize do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Anim[i]
			info.value = i
			info.func = function(self)
				if aura.anim1 ~= i then
					aura.anim1 = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnim1, aura.anim1)
					PowaAurasOptions:RedisplayAura(PowaAurasOptions.CurrentAuraId)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnim1, aura.anim1)
	elseif name == "PowaDropDownAnim2" then
		local tableSize
		if aura.UseOldAnimations then
			tableSize = #PowaAurasOptions.Anim - 2
		else
			tableSize = #PowaAurasOptions.Anim
		end
		for i = 0, tableSize do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Anim[i]
			info.value = i
			info.func = function(self)
				if aura.anim2 ~= i then
					if i == 1 then
						PowaAurasOptions.SecondaryModels[aura.id] = nil
					end
					aura.anim2 = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnim2, aura.anim2)
					PowaAurasOptions:RedisplayAura(PowaAurasOptions.CurrentAuraId)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownAnim2, aura.anim2)
	elseif name == "PowaDropDownSound" then
		for i = 0, 29 do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Sound[i]
			info.value = i
			info.func = function(self)
				if aura.sound ~= i then
					if i == 0 or not PowaAurasOptions.Sound[i] then
						aura.sound = 0
						Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, 0)
						return
					end
					aura.sound = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, aura.sound)
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, 30)
					PowaDropDownSound2Text:SetText(PowaAurasOptions.Sound[0])
					PlaySound(PowaAurasOptions.Sound[aura.sound], PowaMisc.SoundChannel)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		if aura.sound >= 30 then
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, 0)
		else
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, aura.sound)
		end
	elseif name == "PowaDropDownSound2" then
		for i = 30, #PowaAurasOptions.Sound do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Sound[i]
			info.value = i
			info.func = function(self)
				if aura.sound ~= i then
					if i == 30 or not PowaAurasOptions.Sound[i] then
						aura.sound = 0
						Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, 30)
						return
					end
					aura.sound = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, aura.sound)
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound, 0)
					PowaDropDownSoundText:SetText(PowaAurasOptions.Sound[0])
					PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAurasOptions.Sound[aura.sound], PowaMisc.SoundChannel)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		if aura.sound <= 30 then
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, 30)
		else
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, aura.sound)
		end
	elseif name == "PowaDropDownSoundEnd" then
		for i = 0, 29 do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Sound[i]
			info.value = i
			info.func = function(self)
				if aura.soundend ~= i then
					if i == 0 or not PowaAurasOptions.Sound[i] then
						aura.soundend = 0
						Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, 0)
						return
					end
					aura.soundend = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, aura.soundend)
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, 30)
					PowaDropDownSound2EndText:SetText(PowaAurasOptions.Sound[0])
					PlaySound(PowaAurasOptions.Sound[aura.soundend], PowaMisc.SoundChannel)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		if aura.soundend >= 30 then
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, 0)
		else
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, aura.soundend)
		end
	elseif name == "PowaDropDownSound2End" then
		for i = 30, #PowaAurasOptions.Sound do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Sound[i]
			info.value = i
			info.func = function(self)
				if aura.soundend ~= i then
					if i == 30 or not PowaAurasOptions.Sound[i] then
						aura.soundend = 0
						Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, 30)
						return
					end
					aura.soundend = i
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, aura.soundend)
					Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, 0)
					PowaDropDownSoundEndText:SetText(PowaAurasOptions.Sound[0])
					PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAurasOptions.Sound[aura.soundend], PowaMisc.SoundChannel)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		if aura.soundend <= 30 then
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, 30)
		else
			Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, aura.soundend)
		end
	elseif name == "PowaDropDownTimerTexture" then
		for i = 1, #PowaAurasOptions.TimerTextures do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TimerTextures[i]
			info.func = function(self)
				local texture = PowaAurasOptions.TimerTextures[i]
				if aura.Timer.Texture ~= texture then
					aura.Timer.Texture = texture
					aura.Timer:Dispose()
					Lib_UIDropDownMenu_SetSelectedName(PowaDropDownTimerTexture, texture)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaDropDownTimerTexture, aura.Timer.Texture)
	elseif name == "PowaDropDownDefaultTimerTexture" then
		for i = 2, #PowaAurasOptions.TimerTextures do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TimerTextures[i]
			info.func = function(self)
				local texture = PowaAurasOptions.TimerTextures[i]
				Lib_UIDropDownMenu_SetSelectedName(PowaDropDownDefaultTimerTexture, texture)
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
	elseif name == "PowaBuffTimerRelative" then
		local relative = {"NONE", "TOPLEFT", "TOP", "TOPRIGHT", "RIGHT", "BOTTOMRIGHT", "BOTTOM", "BOTTOMLEFT", "LEFT", "CENTER"}
		for i = 1, #relative do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Text.Relative[relative[i]]
			info.value = relative[i]
			info.func = function(self)
				if aura.Timer.Relative ~= relative[i] then
					aura.Timer.x = 0
					aura.Timer.y = 0
					aura.Timer.Relative = relative[i]
					aura.Timer:Dispose()
					Lib_UIDropDownMenu_SetSelectedName(PowaBuffTimerRelative, PowaAurasOptions.Text.Relative[aura.Timer.Relative])
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaBuffTimerRelative, PowaAurasOptions.Text.Relative[aura.Timer.Relative])
	elseif name == "PowaDropDownStacksTexture" then
		for i = 1, #PowaAurasOptions.TimerTextures do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TimerTextures[i]
			info.func = function(self)
				local texture = PowaAurasOptions.TimerTextures[i]
				if aura.Stacks.Texture ~= texture then
					aura.Stacks.Texture = texture
					aura.Stacks:Dispose()
					Lib_UIDropDownMenu_SetSelectedName(PowaDropDownStacksTexture, texture)
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaDropDownStacksTexture, aura.Stacks.Texture)
	elseif name == "PowaDropDownDefaultStacksTexture" then
		for i = 2, #PowaAurasOptions.TimerTextures do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.TimerTextures[i]
			info.func = function(self)
				local texture = PowaAurasOptions.TimerTextures[i]
				Lib_UIDropDownMenu_SetSelectedName(PowaDropDownDefaultStacksTexture, texture)
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
	elseif name == "PowaBuffStacksRelative" then
		local relative = {"NONE", "TOPLEFT", "TOP", "TOPRIGHT", "RIGHT", "BOTTOMRIGHT", "BOTTOM", "BOTTOMLEFT", "LEFT", "CENTER"}
		for i = 1, #relative do
			local info = Lib_UIDropDownMenu_CreateInfo()
			info.text = PowaAurasOptions.Text.Relative[relative[i]]
			info.value = relative[i]
			info.func = function(self)
				if aura.Stacks.Relative ~= relative[i] then
					aura.Stacks.x = 0
					aura.Stacks.y = 0
					aura.Stacks.Relative = relative[i]
					aura.Stacks:Dispose()
					Lib_UIDropDownMenu_SetSelectedName(PowaBuffStacksRelative, PowaAurasOptions.Text.Relative[aura.Stacks.Relative])
				end
			end
			Lib_UIDropDownMenu_AddButton(info)
		end
		Lib_UIDropDownMenu_SetSelectedName(PowaBuffStacksRelative, PowaAurasOptions.Text.Relative[aura.Stacks.Relative])
	end
end

function PowaAurasOptions:FillDropdownSorted(t, info)
	local names = PowaAurasOptions:CopyTable(t)
	local values = ReverseTable(names)
	table.sort(names)
	for _, name in pairs(names) do
		info.text = name
		info.value = values[name]
		Lib_UIDropDownMenu_AddButton(info)
	end
end

function PowaAurasOptions.DropDownMenu_OnClickBuffType(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	PowaAurasOptions:ChangeAuraType(PowaAurasOptions.CurrentAuraId, self.value)
end

function PowaAurasOptions:ChangeAuraType(id, newType)
	local oldAura = self.Auras[id]
	local showing = oldAura.Showing
	oldAura:Hide()
	if oldAura.Timer then
		oldAura.Timer:Dispose()
	end
	if oldAura.Stacks then
		oldAura.Stacks:Dispose()
	end
	if not oldAura.model and not oldAura.modelcustom then
		oldAura:Dispose()
	end
	local aura = self:AuraFactory(newType, id, oldAura)
	aura.icon = ""
	aura.Showing = showing
	aura:Init()
	self.Auras[id] = aura
	if self.CurrentAuraId > 120 then
		PowaGlobalSet[id] = aura
	end
	self:CalculateAuraSequence()
	if aura.textaura == true then
		self:RedisplayAura(aura.id)
	end
	local model = self.Models[aura.id]
	if model then
		model:SetUnit("none")
	end
	if aura.bufftype == self.BuffTypes.Slots then
		if not PowaEquipmentSlotsFrame:IsVisible() then
			PowaEquipmentSlotsFrame:Show()
		end
	else
		if PowaEquipmentSlotsFrame:IsVisible() then
			PowaEquipmentSlotsFrame:Hide()
		end
	end
	if aura.bufftype == self.BuffTypes.ActionReady or aura.bufftype == self.BuffTypes.SpellCooldown then
		local spellLink = GetSpellLink(aura.buffname)
		local spellId
		if spellLink then
			spellId = string.match(spellLink, "spell:(%d+)")
		end
		local _, maxCharges = GetSpellCharges(spellId)
		if aura.Stacks and aura.Stacks.enabled and not maxCharges then
			aura.Stacks.enabled = false
			aura.Stacks:Dispose()
			PowaShowStacksButton:SetChecked(false)
		end
	end
	if aura.CheckBoxes.PowaOwntexButton ~= 1 then
		aura.owntex = false
	end
	self:UpdateMainOption()
	self:InitPage(aura)
	self:RedisplayAura(aura.id)
end

function PowaAurasOptions:RebuildAura(id)
	local oldAura = self.Auras[id]
	local showing = oldAura.Showing
	oldAura:Hide()
	if oldAura.Timer then
		oldAura.Timer:Dispose()
	end
	if oldAura.Stacks then
		oldAura.Stacks:Dispose()
	end
	if not oldAura.model and not oldAura.modelcustom then
		oldAura:Dispose()
	end
	local aura = self:AuraFactory(oldAura.bufftype, id, oldAura)
	aura.Showing = showing
	aura:Init()
	self.Auras[id] = aura
	if id > 120 then
		PowaGlobalSet[id] = aura
	end
	self:CalculateAuraSequence()
	if aura.textaura == true then
		self:RedisplayAura(aura.id)
	end
	local model = self.Models[aura.id]
	if model then
		model:SetUnit("none")
	end
	if aura.bufftype == self.BuffTypes.Slots then
		if not PowaEquipmentSlotsFrame:IsVisible() then
			PowaEquipmentSlotsFrame:Show()
		end
	else
		if PowaEquipmentSlotsFrame:IsVisible() then
			PowaEquipmentSlotsFrame:Hide()
		end
	end
	if aura.bufftype == self.BuffTypes.ActionReady or aura.bufftype == self.BuffTypes.SpellCooldown then
		local spellLink = GetSpellLink(aura.buffname)
		local spellId
		if spellLink then
			spellId = string.match(spellLink, "spell:(%d+)")
		end
		local _, maxCharges = GetSpellCharges(spellId)
		if aura.Stacks and aura.Stacks.enabled and not maxCharges then
			aura.Stacks.enabled = false
			aura.Stacks:Dispose()
			PowaShowStacksButton:SetChecked(false)
		end
	end
	if aura.CheckBoxes.PowaOwntexButton ~= 1 then
		aura.owntex = false
	end
	self:UpdateMainOption()
	self:RedisplayAura(aura.id)
end

function PowaAurasOptions:ShowSpinAtBeginningChecked(button)
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.beginSpin = true
	else
		aura.beginSpin = false
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:OldAnimationChecked(button)
	Lib_CloseDropDownMenus()
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.UseOldAnimations = true
		PowaShowSpinAtBeginning:Hide()
		if Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnimEnd) == 5 or Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnimEnd) == 6 then
			local aura = self.Auras[self.CurrentAuraId]
			Lib_UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, 1)
			aura.finish = 0
		end
		if Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnim1) == 11 or Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnim1) == 12 then
			local aura = self.Auras[self.CurrentAuraId]
			Lib_UIDropDownMenu_SetSelectedID(PowaDropDownAnim1, 1)
			aura.anim1 = 1
		end
		if Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnim2) == 12 or Lib_UIDropDownMenu_GetSelectedID(PowaDropDownAnim2) == 13 then
			local aura = self.Auras[self.CurrentAuraId]
			Lib_UIDropDownMenu_SetSelectedID(PowaDropDownAnim2, 1)
			aura.anim2 = 0
		end
	else
		aura.UseOldAnimations = false
		PowaShowSpinAtBeginning:Show()
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions.DropDownMenu_OnClickStance(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	if aura.stance ~= self.value then
		aura.stance = self.value
		aura.icon = ""
	end
	aura:SetFixedIcon()
	if not aura.icon or aura.icon == "" then
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
	else
		PowaIconTexture:SetTexture(aura.icon)
	end
	PowaAurasOptions:UpdateMainOption()
end

function PowaAurasOptions.DropDownMenu_OnClickGTFO(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	if aura.GTFO ~= self.value then
		aura.GTFO = self.value
		aura.icon = ""
	end
	aura:SetFixedIcon()
	if not aura.icon or aura.icon == "" then
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
	else
		PowaIconTexture:SetTexture(aura.icon)
	end
	PowaAurasOptions:UpdateMainOption()
end

function PowaAurasOptions.DropDownMenu_OnClickPowerType(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	if aura.PowerType ~= self.value then
		aura.PowerType = self.value
		aura.icon = ""
		aura:Init()
	end
	aura:SetFixedIcon()
	if not aura.icon or aura.icon == "" then
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark")
	else
		PowaIconTexture:SetTexture(aura.icon)
	end
	PowaAurasOptions:UpdateMainOption()
	PowaAurasOptions:InitPage(aura)
end

function PowaAurasOptions.DropDownMenu_OnClickBegin(self)
	Lib_UIDropDownMenu_SetSelectedID(self.owner, self.value + 1)
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	if aura.begin ~= self.begin then
		aura.begin = self.value
	end
	PowaAurasOptions:RedisplayAura(PowaAurasOptions.CurrentAuraId)
end

function PowaAurasOptions.DropDownMenu_OnClickEnd(self)
	local optionID = self:GetID()
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	Lib_UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, optionID)
	if aura.finish ~= optionID - 1 then
		aura.finish = optionID - 1
	end
	PowaAurasOptions:RedisplayAura(PowaAurasOptions.CurrentAuraId)
end

-- Options Deplacement
function PowaAurasOptions:FrameMouseDown(frame, button)
	if button == "LeftButton" then
		frame:StartMoving()
	end
end

function PowaAurasOptions:FrameMouseUp(frame, button)
	frame:StopMovingOrSizing()
end

-- Color Picker
function PowaAurasOptions.SetColor()
	PowaAurasOptions:SetAuraColor(ColorPickerFrame:GetColorRGB())
end

function PowaAurasOptions.CancelColor()
	if ColorPickerFrame.previousValues and ColorPickerFrame.previousValues.r and ColorPickerFrame.previousValues.g and ColorPickerFrame.previousValues.b then
		PowaAurasOptions:SetAuraColor(ColorPickerFrame.previousValues.r, ColorPickerFrame.previousValues.g, ColorPickerFrame.previousValues.b)
	end
end

function PowaAurasOptions:SetAuraColor(r, g, b)
	local swatch = _G[ColorPickerFrame.Button:GetName().."NormalTexture"]
	swatch:SetVertexColor(r, g, b)
	local frame = _G[ColorPickerFrame.Button:GetName().."_SwatchBg"]
	local aura = self.Auras[self.CurrentAuraId]
	frame.r = r
	frame.g = g
	frame.b = b
	ColorPickerFrame.Source.r = r
	ColorPickerFrame.Source.g = g
	ColorPickerFrame.Source.b = b
	self:UpdateColor(aura)
	local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
	if secondaryAura then
		self:UpdateSecondaryColor(aura)
	end
end

function PowaAurasOptions:OpenColorPicker(control, source, setTexture)
	Lib_CloseDropDownMenus()
	if ColorPickerFrame:IsVisible() then
		PowaAurasOptions.CancelColor()
		ColorPickerFrame:Hide()
	else
		local button
		if control == PowaColor then
			button = PowaColor_SwatchBg
		elseif control == PowaTimerColor then
			button = PowaTimerColor_SwatchBg
		elseif control == PowaStacksColor then
			button = PowaStacksColor_SwatchBg
		end
		ColorPickerFrame.Source = source
		ColorPickerFrame.Button = control
		ColorPickerFrame.setTexture = setTexture
		ColorPickerFrame.func = self.SetColor
		ColorPickerFrame:SetColorRGB(button.r, button.g, button.b)
		ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, a = button.opacity}
		ColorPickerFrame.cancelFunc = self.CancelColor
		ColorPickerFrame:SetPoint("TopLeft", "PowaBarConfigFrame", "TopRight", 0, 0)
		ColorPickerFrame:Show()
	end
end

function PowaAurasOptions.SetGradientColor()
	PowaAurasOptions:SetGradientAuraColor(ColorPickerFrame:GetColorRGB())
end

function PowaAurasOptions.CancelGradientColor()
	if ColorPickerFrame.previousGradientValues and ColorPickerFrame.previousGradientValues.r and ColorPickerFrame.previousGradientValues.g and ColorPickerFrame.previousGradientValues.b then
		PowaAurasOptions:SetGradientAuraColor(ColorPickerFrame.previousGradientValues.r, ColorPickerFrame.previousGradientValues.g, ColorPickerFrame.previousGradientValues.b)
	end
end

function PowaAurasOptions:SetGradientAuraColor(r, g, b)
	local swatch = _G[ColorPickerFrame.GradientButton:GetName().."NormalTexture"]
	swatch:SetVertexColor(r, g, b)
	local frame = _G[ColorPickerFrame.GradientButton:GetName().."_SwatchBg"]
	local aura = self.Auras[self.CurrentAuraId]
	frame.r = r
	frame.g = g
	frame.b = b
	aura.gr = r
	aura.gg = g
	aura.gb = b
	self:UpdateColor(aura)
	local secondaryAura = self.SecondaryAuras[self.CurrentAuraId]
	if secondaryAura then
		self:UpdateSecondaryColor(aura)
	end
end

function PowaAurasOptions:OpenGradientColorPicker(control, source, setTexture)
	Lib_CloseDropDownMenus()
	if ColorPickerFrame:IsVisible() then
		PowaAurasOptions.CancelGradientColor()
		ColorPickerFrame:Hide()
	else
		local button = PowaGradientColor_SwatchBg
		ColorPickerFrame.GradientSource = source
		ColorPickerFrame.GradientButton = control
		ColorPickerFrame.setTexture = setTexture
		ColorPickerFrame.func = self.SetGradientColor
		ColorPickerFrame:SetColorRGB(button.r, button.g, button.b)
		ColorPickerFrame.previousGradientValues = {r = button.r, g = button.g, b = button.b, a = button.opacity}
		ColorPickerFrame.cancelFunc = self.CancelGradientColor
		ColorPickerFrame:SetPoint("TopLeft", "PowaBarConfigFrame", "TopRight", 0, 0)
		ColorPickerFrame:Show()
	end
end

-- Font Selector
function PowaAurasOptions:FontSelectorOnShow(owner)
	owner:SetBackdropBorderColor(0.9, 1.0, 0.95)
	owner:SetBackdropColor(0.6, 0.6, 0.6)
end

function PowaAurasOptions:OpenFontSelector(owner)
	Lib_CloseDropDownMenus()
	if PowaFontSelectorFrame:IsVisible() then
		PowaFontSelectorFrame:Hide()
	else
		PowaFontSelectorFrame.selectedFont = self.Auras[self.CurrentAuraId].aurastextfont
		PowaFontSelectorFrame:Show()
	end
end

function PowaAurasOptions:FontSelectorOkay(owner)
	local aura = self.Auras[self.CurrentAuraId]
	if PowaFontSelectorFrame.selectedFont then
		aura.aurastextfont = PowaFontSelectorFrame.selectedFont
	else
		aura.aurastextfont = 1
	end
	self:RedisplayAura(self.CurrentAuraId)
	self:FontSelectorClose(owner)
end

function PowaAurasOptions:FontSelectorCancel(owner)
	self:FontSelectorClose(owner)
end

function PowaAurasOptions:FontSelectorClose(owner)
	PowaFontSelectorFrame:Hide()
end

function PowaAurasOptions:FontButton_OnClick(owner)
	PowaFontSelectorFrame.selectedFont = _G["FontSelectorEditorScrollButton"..owner:GetID()].font
	self:FontScrollBar_Update(owner)
end

function PowaAurasOptions.FontScrollBar_Update(owner)
	local fontOffset = FauxScrollFrame_GetOffset(FontSelectorEditorScrollFrame)
	for i = 1, 10, 1 do
		local fontIndex = fontOffset + i
		local fontName = PowaAurasOptions.Fonts[fontIndex]
		local fontText = _G["FontSelectorEditorScrollButton"..i.."Text"]
		local fontButton = _G["FontSelectorEditorScrollButton"..i]
		fontButton.font = fontIndex
		local namestart = string.find(fontName, "\\", 1, true)
		local nameend = string.find(fontName, ".", 1, true)
		if namestart and nameend and nameend > namestart then
			fontName = string.sub(fontName, namestart + 1, nameend - 1)
			while string.find(fontName, "\\", 1, true) do
				namestart = string.find(fontName, "\\", 1, true)
				fontName = string.sub(fontName, namestart + 1)
			end
		end
		fontText:SetFont(PowaAurasOptions.Fonts[fontIndex], 14, "Outline, Monochrome")
		fontText:SetText(fontName)
		if PowaFontSelectorFrame.selectedFont == fontIndex then
			fontButton:LockHighlight()
		else
			fontButton:UnlockHighlight()
		end
	end
	FauxScrollFrame_Update(FontSelectorEditorScrollFrame, #PowaAurasOptions.Fonts, 10, 16)
end

function PowaAurasOptions:EditorShow()
	if PowaBarConfigFrame:IsVisible() then
		self:EditorClose()
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	local owner = _G["PowaIcone"..self.CurrentAuraId]
	if aura then
		if not aura.Showing then
			aura.Active = true
			--aura:CreateFrames()
			--self.SecondaryAuras[aura.id] = nil
			self:DisplayAura(aura.id)
			if not aura.off then
				if owner then
					owner:SetAlpha(1.0)
				end
			end
		end
		self:InitPage(aura)
		PowaBarConfigFrame:Show()
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel)
	end
end

function PowaAurasOptions:EditorClose()
	if PowaBarConfigFrame:IsVisible() then
		if PowaFontSelectorFrame:IsVisible() then
			PowaFontSelectorFrame:Hide()
		end
		if ColorPickerFrame:IsVisible() then
			self.CancelColor()
			ColorPickerFrame:Hide()
		end
		PowaBarConfigFrame:Hide()
		PlaySound("TalentScreenClose", PowaMisc.SoundChannel)
	end
end

-- Advanced Options
function PowaAurasOptions:ShowTimerChecked(button)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.Timer.enabled = true
		self:CreateTimerFrameIfMissing(self.CurrentAuraId)
	else
		aura.Timer.enabled = false
		aura.Timer:Dispose()
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:TimerSizeSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Timer.h then
		aura.Timer.h = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:TimerAlphaSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Timer.a then
		aura.Timer.a = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:TimerCoordXSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Timer.x then
		aura.Timer.x = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:TimerCoordYSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Timer.y then
		aura.Timer.y = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:PowaTimerInvertAuraSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.InvertAuraBelow then
		aura.InvertAuraBelow = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:TimerDurationSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.timerduration then
		aura.timerduration = value
	end
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions.DropDownMenu_OnClickTimerRelative(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	local timer = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId].Timer
	timer.x = 0
	timer.y = 0
	timer.Relative = self.value
	timer:Dispose()
end

function PowaAurasOptions:TimerChecked(button, setting)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.Timer[setting] = true
	else
		aura.Timer[setting] = false
	end
	aura.Timer:Dispose()
	aura.Timer:SetShowOnAuraHide(aura)
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

function PowaAurasOptions:SettingChecked(button, setting)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura[setting] = true
	else
		aura[setting] = false
	end
end

function PowaAurasOptions:TimerTransparentChecked(button)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.Timer.Transparent = true
	else
		aura.Timer.Transparent = false
	end
	aura.Timer:Dispose()
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId)
end

-- Stacks
function PowaAurasOptions:ShowStacksChecked(button)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.Stacks.enabled = true
	else
		aura.Stacks.enabled = false
		aura.Stacks:Dispose()
	end
	self:RedisplayAura(self.CurrentAuraId)
end

function PowaAurasOptions:StacksAlphaSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Stacks.a then
		aura.Stacks.a = value
	end
end

function PowaAurasOptions:StacksSizeSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Stacks.h then
		aura.Stacks.h = value
	end
end

function PowaAurasOptions:StacksCoordXSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Stacks.x then
		aura.Stacks.x = value
	end
end


function PowaAurasOptions:StacksCoordYSliderChanged(slider, value)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if value ~= aura.Stacks.y then
		aura.Stacks.y = value
	end
end

function PowaAurasOptions.DropDownMenu_OnClickStacksRelative(self)
	Lib_UIDropDownMenu_SetSelectedValue(self.owner, self.value)
	local stacks = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId].Stacks
	stacks.x = 0
	stacks.y = 0
	stacks.Relative = self.value
	stacks:Dispose()
end

function PowaAurasOptions:StacksChecked(button, setting)
	if not (self.VariablesLoaded and self.SetupDone) then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if button:GetChecked() then
		aura.Stacks[setting] = true
	else
		aura.Stacks[setting] = false
	end
	aura.Stacks:Dispose()
end

function PowaAurasOptions:SlashCommands(msg)
	if msg == "dump" then
		local dumpLoaded = PowaAurasOptions.Dump
		if dumpLoaded then
			PowaAurasOptions:Dump()
			PowaAurasOptions:Message("State dumped to:")
			PowaAurasOptions:Message("WTF\\Account\\<ACCOUNT>\\"..GetRealmName().."\\"..UnitName("player").."\\SavedVariables\\PowerAuras.lua")
			PowaAurasOptions:Message("You must log-out to save the values to disk.")
		else
			PowaAurasOptions:Message("Function is not loaded.")
		end
	elseif msg == "cleardump" then
		local dumpLoaded = PowaAurasOptions.Dump
		if dumpLoaded then
			PowaAurasOptions:ClearDump()
			PowaAurasOptions:Message("State dump cleared.")
		else
			PowaAurasOptions:Message("Function is not loaded.")
		end
	elseif msg == "update" or msg == "upgrade" then
		PowaAurasOptions:UpdateOldAuras()
	elseif msg == "toggle" or msg == "tog" then
		PowaAurasOptions:Toggle()
	elseif msg == "showbuffs" or msg == "buffs" then
		PowaAurasOptions:ShowAurasOnUnit("Buffs", "HELPFUL")
	elseif msg == "showdebuffs" or msg == "debuffs" then
		PowaAurasOptions:ShowAurasOnUnit("Debuffs", "HARMFUL")
	elseif msg == "playertalents" then
		PowaAurasOptions:ListPlayerTalents()
	elseif msg == "pettalents" then
		PowaAurasOptions:ListPetTalents()
	else
		PowaAurasOptions:MainOptionShow()
	end
end

function PowaAurasOptions:ShowAurasOnUnit(display, auraType)
	local index = 1
	local unit = "player"
	if UnitExists("target") then
		unit = "target"
	end
	PowaAurasOptions:Message(display.." on "..unit)
	local Name, _, _, Applications, Type, Duration, Expires, Source, Stealable, shouldConsolidate, spellId = UnitAura(unit, index, auraType)
	while Name do
		PowaAurasOptions:Message(index..": "..Name.." (SpellID = "..spellId..")")
		index = index + 1
		Name, _, _, Applications, Type, Duration, Expires, Source, Stealable, shouldConsolidate, spellId = UnitAura(unit, index, auraType)
	end
end

-- Enable/Disable Options Functions
function PowaAurasOptions:DisableSlider(slider)
	_G[slider]:EnableMouse(false)
	_G[slider.."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	_G[slider.."Low"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	_G[slider.."High"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

function PowaAurasOptions:EnableSlider(slider)
	_G[slider]:EnableMouse(true)
	_G[slider.."Text"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	_G[slider.."Low"]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
	_G[slider.."High"]:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end

function PowaAurasOptions:DisableTextfield(textfield)
	_G[textfield]:Hide()
	_G[textfield.."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

function PowaAurasOptions:EnableTextfield(textfield)
	_G[textfield]:Show()
	_G[textfield.."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

function PowaAurasOptions:DisableCheckBox(checkbox)
	_G[checkbox]:Disable()
	_G[checkbox.."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
end

function PowaAurasOptions:EnableCheckBox(checkbox, color)
	_G[checkbox]:Enable()
	if not color then
		color = NORMAL_FONT_COLOR
	end
	_G[checkbox.."Text"]:SetTextColor(color.r, color.g, color.b)
end

function PowaAurasOptions:HideCheckBox(checkbox)
	_G[checkbox]:Hide()
end

function PowaAurasOptions:ShowCheckBox(checkbox)
	_G[checkbox]:Show()
end

-- Blizzard Addon
function PowaAurasOptions:EnableChecked()
	if PowaEnableButton:GetChecked() then
		self:Toggle(true)
	else
		self:MainOptionClose()
		self:Toggle(false)
	end
end

function PowaAurasOptions:MiscChecked(button, setting)
	if button:GetChecked() then
		PowaMisc[setting] = true
	else
		PowaMisc[setting] = false
	end
	if setting == "ScaleLocked" then
		if PowaMisc.ScaleLocked == true then
			PowaOptionsFrame.bottomrightframe:Hide()
			PowaOptionsFrame.bottomleftframe:Hide()
			PowaOptionsFrame.toprightframe:Hide()
			PowaOptionsFrame.topleftframe:Hide()
			PowaBarConfigFrame.bottomrightframe:Hide()
			PowaBarConfigFrame.bottomleftframe:Hide()
			PowaBarConfigFrame.toprightframe:Hide()
			PowaBarConfigFrame.topleftframe:Hide()
		else
			PowaOptionsFrame.bottomrightframe:Show()
			PowaOptionsFrame.bottomleftframe:Show()
			PowaOptionsFrame.toprightframe:Show()
			PowaOptionsFrame.topleftframe:Show()
			PowaBarConfigFrame.bottomrightframe:Show()
			PowaBarConfigFrame.bottomleftframe:Show()
			PowaBarConfigFrame.toprightframe:Show()
			PowaBarConfigFrame.topleftframe:Show()
		end
	end
end

function PowaAurasOptions:GlobalMiscChecked(button, setting)
	if button:GetChecked() then
		PowaGlobalMisc[setting] = true
	else
		PowaGlobalMisc[setting] = false
	end
end

local function OptionsOK()
	PowaMisc.OnUpdateLimit = (100 - PowaOptionsUpdateSlider2:GetValue()) / 200
	PowaMisc.AnimationLimit = (100 - PowaOptionsTimerUpdateSlider2:GetValue()) / 1000
	PowaMisc.UserSetMaxTextures = PowaOptionsTextureCount:GetValue()
	if PowaMisc.OverrideMaxTextures then
		PowaAurasOptions.MaxTextures = PowaMisc.UserSetMaxTextures
	else
		PowaAurasOptions.MaxTextures = PowaAurasOptions.TextureCount
	end
	PowaAurasOptions:EnableChecked()
	PowaAurasOptions:MiscChecked(PowaDebugButton, "Debug")
	PowaAurasOptions:MiscChecked(PowaTimerRoundingButton, "TimerRoundUp")
	PowaAurasOptions:MiscChecked(PowaDisableFrameScalingButton, "ScaleLocked")
	PowaAurasOptions:GlobalMiscChecked(PowaBlockIncomingAurasButton, "BlockIncomingAuras")
	PowaAurasOptions:GlobalMiscChecked(PowaFixExportsButton, "FixExports")
	local newDefaultTimerTexture = Lib_UIDropDownMenu_GetSelectedName(PowaDropDownDefaultTimerTexture)
	if newDefaultTimerTexture and newDefaultTimerTexture ~= PowaMisc.DefaultTimerTexture then
		PowaMisc.DefaultTimerTexture = newDefaultTimerTexture
		for auraId, aura in pairs(PowaAurasOptions.Auras) do
			if aura.Timer and aura.Timer.enabled and aura.Timer.Texture == "Default" then
				aura.Timer:Hide()
				PowaAurasOptions.TimerFrame[auraId] = { }
				PowaAurasOptions:CreateTimerFrame(auraId, 1)
				PowaAurasOptions:CreateTimerFrame(auraId, 2)
			end
		end
	end
	local newDefaultStacksTexture = Lib_UIDropDownMenu_GetSelectedName(PowaDropDownDefaultStacksTexture)
	if newDefaultStacksTexture and newDefaultStacksTexture ~= PowaMisc.DefaultStacksTexture then
		PowaMisc.DefaultStacksTexture = newDefaultStacksTexture
		for auraId, aura in pairs(PowaAurasOptions.Auras) do
			if aura.Stacks and aura.Stacks.enabled and aura.Stacks.Texture == "Default" then
				aura.Stacks:Hide()
				for i = 1, #PowaAurasOptions.StacksFrames[auraId].textures do
					PowaAurasOptions.StacksFrames[auraId].textures[i]:SetTexture(aura.Stacks:GetTexture())
				end
			end
		end
	end
	PowaGlobalMisc.PathToSounds = PowaCustomSoundPath:GetText()
	PowaGlobalMisc.PathToAuras = PowaCustomAuraPath:GetText()
	PowaAurasOptions.ModTest = false
	PowaAurasOptions.DoCheck.All = true
end

local function OptionsCancel()
	PowaAurasOptions.ModTest = false
	PowaAurasOptions.DoCheck.All = true
end

local function OptionsDefault()
	for k, v in pairs(PowaAurasOptions.PowaMiscDefault) do
		PowaMisc[k] = v
	end
	for k, v in pairs(PowaAurasOptions.PowaGlobalMiscDefault) do
		PowaGlobalMisc[k] = v
	end
	PowaAurasOptions:DisplayText("Power Aura Options Reset to Defaults.")
end

local function OptionsRefresh()
	PowaOptionsUpdateSlider2:SetValue(100 - 200 * PowaMisc.OnUpdateLimit)
	PowaOptionsTimerUpdateSlider2:SetValue(100 - 1000 * PowaMisc.AnimationLimit)
	PowaOptionsTextureCount:SetValue(PowaMisc.UserSetMaxTextures)
	PowaOverrideTextureCountButton:SetChecked(PowaMisc.OverrideMaxTextures)
	PowaEnableButton:SetChecked(PowaMisc.Disabled ~= true)
	PowaDebugButton:SetChecked(PowaMisc.Debug)
	PowaTimerRoundingButton:SetChecked(PowaMisc.TimerRoundUp)
	PowaAllowInspectionsButton:SetChecked(PowaMisc.AllowInspections)
	PowaDisableFrameScalingButton:SetChecked(PowaMisc.ScaleLocked)
	PowaBlockIncomingAurasButton:SetChecked(PowaGlobalMisc.BlockIncomingAuras)
	PowaFixExportsButton:SetChecked(PowaGlobalMisc.FixExports)
	Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownDefaultTimerTexture, PowaMisc.DefaultTimerTexture)
	Lib_UIDropDownMenu_SetSelectedValue(PowaDropDownDefaultStacksTexture, PowaMisc.DefaultStacksTexture)
	PowaDropDownDefaultTimerTextureText:SetText(PowaMisc.DefaultTimerTexture)
	PowaDropDownDefaultStacksTextureText:SetText(PowaMisc.DefaultStacksTexture)
	PowaCustomSoundPath:SetText(PowaGlobalMisc.PathToSounds)
	PowaCustomSoundPath:SetCursorPosition(0)
	PowaCustomAuraPath:SetText(PowaGlobalMisc.PathToAuras)
	PowaCustomAuraPath:SetCursorPosition(0)
end

function PowaAurasOptions:Blizzard_OnLoad(panel)
	panel.name = GetAddOnMetadata("PowerAuras", "Title")
	panel.okay = function(self)
		OptionsOK()
	end
	panel.cancel = function(self)
		OptionsCancel()
	end
	panel.default = function(self)
		OptionsDefault()
	end
	panel.refresh = function(self)
		OptionsRefresh()
	end
	InterfaceOptions_AddCategory(panel)
end

function PowaAurasOptions:PowaOptionsUpdateSliderChanged(slider, value)
	PowaOptionsUpdateSlider2Text:SetText(self.Text.nomUpdateSpeed..": "..value.."%")
end

function PowaAurasOptions:PowaOptionsTimerUpdateSliderChanged(slider, value)
	PowaOptionsTimerUpdateSlider2Text:SetText(self.Text.nomTimerUpdate..": "..value.."%")
end

function PowaAurasOptions:PowaOptionsMaxTexturesSliderChanged(slider, value)
	PowaOptionsTextureCountText:SetText(self.Text.nomTextureCount..": "..value)
end

-- Ternary Logic
function PowaAurasOptions:DisableTernary(control)
	_G[control:GetName().."Text"]:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	control:Disable()
end

function PowaAurasOptions:TernarySetState(button, value)
	button:Enable()
	_G[button:GetName().."Text"]:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
	if value == 0 then
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:SetChecked(false)
	elseif value == false then
		button:SetCheckedTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady")
		button:SetChecked(true)
	elseif value == true then
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:SetChecked(true)
	end
end

function PowaAurasOptions.Ternary_OnClick(self)
	local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
	if aura[self.Parameter] == 0 then
		aura[self.Parameter] = true
	elseif aura[self.Parameter] then
		aura[self.Parameter] = false
	else
		aura[self.Parameter] = 0
	end
	PowaAurasOptions:TernarySetState(self, aura[self.Parameter])
	PowaAurasOptions.Ternary_CheckTooltip(self)
end

function PowaAurasOptions.Ternary_CheckTooltip(button)
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
	GameTooltip:SetText(PowaAurasOptions.Text.TernaryAide[button.Parameter], nil, nil, nil, nil, 1)
	GameTooltip:AddLine(PowaAurasOptions.Text.aideTernary.."\n\124TInterface\\Buttons\\UI-CheckBox-Up:22\124t = "..PowaAurasOptions.Text.nomWhatever.."\n\124TInterface\\Buttons\\UI-CheckBox-Check:22\124t = "..PowaAurasOptions.Text.TernaryYes[button.Parameter].."\n\124TInterface\\RAIDFRAME\\ReadyCheck-NotReady:22\124t = "..PowaAurasOptions.Text.TernaryNo[button.Parameter], .8, .8, .8, 1)
	GameTooltip:Show()
end

function PowaAurasOptions:OptionTest()
	local aura = self.Auras[self.CurrentAuraId]
	if not aura or aura.buffname == "" or aura.buffname == " " then
		return
	end
	local owner = _G["PowaIcone"..self.CurrentAuraId - ((self.CurrentAuraPage - 1) * 24)]
	if aura.Showing then
		self:SetAuraHideRequest(aura)
		aura.Active = false
		if aura.customsoundend ~= "" then
			if aura.Debug then
				self:Message("Playing Custom end sound ", aura.customsoundend)
			end
			local pathToSound
			if string.find(aura.customsoundend, "\\") or string.find(aura.customsoundend, "/") then
				pathToSound = aura.customsoundend
			else
				pathToSound = PowaGlobalMisc.PathToSounds..aura.customsoundend
			end
			PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		elseif aura.soundend > 0 then
			if PowaAurasOptions.Sound[aura.soundend] and string.len(PowaAurasOptions.Sound[aura.soundend]) > 0 then
				if aura.Debug then
					self:Message("Playing end sound ", PowaAurasOptions.Sound[aura.soundend])
				end
				if string.find(PowaAurasOptions.Sound[aura.soundend], "%.") then
					PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAurasOptions.Sound[aura.soundend], PowaMisc.SoundChannel)
				else
					PlaySound(PowaAurasOptions.Sound[aura.soundend], PowaMisc.SoundChannel)
				end
			end
		end
		if owner then
			owner:SetAlpha(0.33)
		end
	else
		self:DisplayAura(aura.id)
		aura.Active = true
		if aura.customsound ~= "" then
			local pathToSound
			if string.find(aura.customsound, "\\") or string.find(aura.customsound, "/") then
				pathToSound = aura.customsound
			else
				pathToSound = PowaGlobalMisc.PathToSounds .. aura.customsound
			end
			PlaySoundFile(pathToSound, PowaMisc.SoundChannel)
		elseif aura.sound > 0 then
			if PowaAurasOptions.Sound[aura.sound] and string.len(PowaAurasOptions.Sound[aura.sound]) > 0 then
				if string.find(PowaAurasOptions.Sound[aura.sound], "%.") then
					PlaySoundFile(PowaGlobalMisc.PathToSounds .. PowaAurasOptions.Sound[aura.sound], PowaMisc.SoundChannel)
				else
					PlaySound(PowaAurasOptions.Sound[aura.sound], PowaMisc.SoundChannel)
				end
			end
		end
		if owner then
			owner:SetAlpha(1)
		end
	end
end

function PowaAurasOptions:OptionTestAll()
	PowaAurasOptions:OptionHideAll(true)
	for id, aura in pairs(self.Auras) do
		if aura and not aura.off and aura.buffname ~= "" and aura.buffname ~= " " then
			aura.Active = true
			self:DisplayAura(aura.id)
		end
	end
	local aura = self.Auras[self.CurrentAuraId]
	if aura.randomcolor then
		self:UpdatePreviewRandomColor(aura)
	else
		self:UpdatePreviewColor(aura)
	end
end

function PowaAurasOptions:OptionHideAll(now)
	for id, aura in pairs(self.Auras) do
		aura.Active = false
		self:ResetDragging(aura, self.Frames[aura.id])
		if now then
			aura:Hide()
			if aura.Timer then
				aura.Timer:Hide()
			end
			if aura.Stacks then
				aura.Stacks:Hide()
			end
		else
			self:SetAuraHideRequest(aura)
			if aura.Timer then
				aura.Timer.HideRequest = true
			end
		end
	end
	--PowaBarConfigFrame:Hide()
end

function PowaAurasOptions:SetLockButtonText()
	if PowaMisc.Locked then
		PowaMainLockButtonText:SetText(PowaAurasOptions.Text.nomUnlock)
	else
		PowaMainLockButtonText:SetText(PowaAurasOptions.Text.nomLock)
	end
end

function PowaAurasOptions:ToggleLock()
	PowaMisc.Locked = not PowaMisc.Locked
	self:SetLockButtonText()
	self:RedisplayAuras()
end

function PowaAurasOptions:ResetSlotsToEmpty()
	for _, child in ipairs({PowaEquipmentSlotsFrame:GetChildren()}) do
		if child:IsObjectType("Button") then
			local slotName = string.gsub(child:GetName(), "Powa", "")
			if string.match(slotName, "Slot") then
				local slotId, emptyTexture = GetInventorySlotInfo(slotName)
				_G[child:GetName().."IconTexture"]:SetTexture(emptyTexture)
				child.SlotId = slotId
				child.Set = false
				child.EmptyTexture = emptyTexture
			end
		end
	end
end

function PowaAurasOptions:EquipmentSlotsShow()
	self:ResetSlotsToEmpty()
	local aura = self.Auras[self.CurrentAuraId]
	if not aura then
		return
	end
	for pword in string.gmatch(aura.buffname, "[^/]+") do
		pword = aura:Trim(pword)
		if string.len(pword) > 0 and pword ~= "???" then
			if pword == "Head" or pword == "Neck" or pword == "Shoulder" or pword == "Back" or pword == "Chest" or pword == "Shirt" or pword == "Tabard" or pword == "Wrist" or pword == "Hands" or pword == "Waist" or pword == "Legs" or pword == "Feet" or pword == "Finger0" or pword == "Finger1" or pword == "Trinket0" or pword == "Trinket1" or pword == "MainHand" or pword == "SecondaryHand" then
				local slotId = GetInventorySlotInfo(pword.."Slot")
				if slotId then
					local ok, texture = pcall(GetInventoryItemTexture, "player", slotId)
					if not ok then
						self:Message("Slot definitions are invalid!")
						self:ResetSlotsToEmpty()
						aura.buffname = ""
						return
					end
					if texture then
						_G["Powa"..pword.."SlotIconTexture"]:SetTexture(texture)
						_G["Powa"..pword.."Slot"].Set = true
					end
				end
			end
		end
	end
end

function PowaAurasOptions:EquipmentSlot_OnClick(slotButton)
	if not slotButton.SlotId then
		return
	end
	local aura = self.Auras[self.CurrentAuraId]
	if not aura then
		return
	end
	if slotButton.Set then
		_G[slotButton:GetName().."IconTexture"]:SetTexture(slotButton.EmptyTexture)
		slotButton.Set = false
	else
		local texture = GetInventoryItemTexture("player", slotButton.SlotId)
		if texture then
			_G[slotButton:GetName().."IconTexture"]:SetTexture(texture)
			slotButton.Set = true
		end
	end
	aura.buffname = ""
	local sep = ""
	for _, child in ipairs({PowaEquipmentSlotsFrame:GetChildren()}) do
		if child:IsObjectType("Button") then
			local slotName = string.gsub(child:GetName(), "Powa", "")
			if string.match(slotName, "Slot") then
				if child.Set then
					aura.buffname = aura.buffname..sep..string.gsub(slotName, "Slot", "")
					sep = "/"
				end
			end
		end
	end
end

function PowaAurasOptions:ResizeFrame(frame)
	if not frame then
		return
	end
	if frame.resizable then
		return
	end
	frame.resizable = true
	frame.width = frame:GetWidth()
	frame.height = frame:GetHeight()
	frame.scale = frame:GetScale()
	frame.frameLevel = frame:GetFrameLevel()
	if frame.frameLevel > 13 then
		frame.frameLevel = 13
	end
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:SetMaxResize(frame.width * 1.5, frame.height * 1.5)
	frame:SetMinResize(frame.width / 1.5, frame.height / 1.5)
	frame:SetUserPlaced(true)
	frame.bottomrightframe = CreateFrame("Frame", nil, frame)
	frame.bottomrightframe:SetFrameStrata(frame:GetFrameStrata())
	frame.bottomrightframe:SetPoint("BottomRight", frame, "BottomRight", -8, 7)
	frame.bottomrightframe:SetWidth(16)
	frame.bottomrightframe:SetHeight(16)
	frame.bottomrightframe:SetFrameLevel(frame.frameLevel + 7)
	frame.bottomrightframe:EnableMouse(true)
	if PowaMisc.ScaleLocked then
		frame.bottomrightframe:Hide()
	else
		frame.bottomrightframe:Show()
	end
	frame.bottomrighttexture = frame.bottomrightframe:CreateTexture(nil, "Overlay")
	frame.bottomrighttexture:SetPoint("TopLeft", frame.bottomrightframe, "TopLeft", 0, 0)
	frame.bottomrighttexture:SetWidth(16)
	frame.bottomrighttexture:SetHeight(16)
	frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	frame.bottomrightframe:SetScript("OnEnter", function(self)
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.bottomrightframe:SetScript("OnLeave", function(self)
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.bottomrightframe:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			frame.resizing = nil
			frame:SetWidth(frame.width)
			frame:SetHeight(frame.height)
			local childrens = {frame:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= frame.bottomleftframe and child ~= frame.bottomrightframe and child ~= frame.toprightframe and child ~= frame.topleftframe then
					child:SetScale(frame.scale)
				end
			end
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		elseif button == "MiddleButton" then
			PowaOptionsFrame.bottomrightframe:Hide()
			PowaOptionsFrame.bottomleftframe:Hide()
			PowaOptionsFrame.toprightframe:Hide()
			PowaOptionsFrame.topleftframe:Hide()
			PowaBarConfigFrame.bottomrightframe:Hide()
			PowaBarConfigFrame.bottomleftframe:Hide()
			PowaBarConfigFrame.toprightframe:Hide()
			PowaBarConfigFrame.topleftframe:Hide()
			PowaMisc["ScaleLocked"] = true
			PowaDisableFrameScalingButton:SetChecked(true)
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		elseif button == "LeftButton" then
			frame.resizing = true
			frame.direction = "BottomRight"
			frame:StartSizing("Right")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		end
	end)
	frame.bottomrightframe:SetScript("OnMouseUp", function(self, button)
		local x, y = GetCursorPosition()
		local fx = self:GetLeft() * self:GetEffectiveScale()
		local fy = self:GetBottom() * self:GetEffectiveScale()
		if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		else
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		end
		frame.resizing = nil
		frame.direction = nil
		frame:StopMovingOrSizing()
	end)
	frame.bottomleftframe = CreateFrame("Frame", nil, frame)
	frame.bottomleftframe:SetFrameStrata(frame:GetFrameStrata())
	frame.bottomleftframe:SetPoint("BottomLeft", frame, "BottomLeft", 8, 7)
	frame.bottomleftframe:SetWidth(16)
	frame.bottomleftframe:SetHeight(16)
	frame.bottomleftframe:SetFrameLevel(frame.frameLevel + 7)
	frame.bottomleftframe:EnableMouse(true)
	if PowaMisc.ScaleLocked then
		frame.bottomleftframe:Hide()
	else
		frame.bottomleftframe:Show()
	end
	frame.bottomlefttexture = frame.bottomleftframe:CreateTexture(nil, "Overlay")
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = frame.bottomlefttexture:GetTexCoord()
	frame.bottomlefttexture:SetTexCoord(URx, URy, LRx, LRy, ULx, ULy, LLx, LLy)
	frame.bottomlefttexture:SetPoint("TopLeft", frame.bottomleftframe, "TopLeft", 0, 0)
	frame.bottomlefttexture:SetWidth(16)
	frame.bottomlefttexture:SetHeight(16)
	frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	frame.bottomleftframe:SetScript("OnEnter", function(self)
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.bottomleftframe:SetScript("OnLeave", function(self)
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.bottomleftframe:SetScript("OnMouseDown", function(self, button)
		if button == "RightButton" then
			frame.resizing = nil
			frame:SetWidth(frame.width)
			frame:SetHeight(frame.height)
			local childrens = {frame:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= frame.bottomleftframe and child ~= frame.bottomrightframe and child ~= frame.toprightframe and child ~= frame.topleftframe then
					child:SetScale(frame.scale)
				end
			end
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		elseif button == "MiddleButton" then
			PowaOptionsFrame.bottomrightframe:Hide()
			PowaOptionsFrame.bottomleftframe:Hide()
			PowaOptionsFrame.toprightframe:Hide()
			PowaOptionsFrame.topleftframe:Hide()
			PowaBarConfigFrame.bottomrightframe:Hide()
			PowaBarConfigFrame.bottomleftframe:Hide()
			PowaBarConfigFrame.toprightframe:Hide()
			PowaBarConfigFrame.topleftframe:Hide()
			PowaMisc["ScaleLocked"] = true
			PowaDisableFrameScalingButton:SetChecked(true)
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		elseif button == "LeftButton" then
			frame.resizing = true
			frame.direction = "BottomLeft"
			frame:StartSizing("Left")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		end
	end)
	frame.bottomleftframe:SetScript("OnMouseUp", function(self, button)
		local x, y = GetCursorPosition()
		local fx = self:GetLeft() * self:GetEffectiveScale()
		local fy = self:GetBottom() * self:GetEffectiveScale()
		if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		else
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		end
		frame.resizing = nil
		frame.direction = nil
		frame:StopMovingOrSizing()
	end)
	frame.topleftframe = CreateFrame("Frame", nil, frame)
	frame.topleftframe:SetFrameStrata(frame:GetFrameStrata())
	frame.topleftframe:SetPoint("TopLeft", frame, "TopLeft", 8, -7)
	frame.topleftframe:SetWidth(16)
	frame.topleftframe:SetHeight(16)
	frame.topleftframe:SetFrameLevel(frame.frameLevel + 7)
	frame.topleftframe:EnableMouse(true)
	if PowaMisc.ScaleLocked then
		frame.topleftframe:Hide()
	else
		frame.topleftframe:Show()
	end
	frame.toplefttexture = frame.topleftframe:CreateTexture(nil, "Overlay")
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = frame.toplefttexture:GetTexCoord()
	frame.toplefttexture:SetTexCoord(LRx, LRy, URx, URy, LLx, LLy, ULx, ULy)
	frame.toplefttexture:SetPoint("TopLeft", frame.topleftframe, "TopLeft", 0, 0)
	frame.toplefttexture:SetWidth(16)
	frame.toplefttexture:SetHeight(16)
	frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	frame.topleftframe:SetScript("OnEnter", function(self)
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.topleftframe:SetScript("OnLeave", function(self)
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.topleftframe:SetScript("OnMouseDown", function(self, button)
		frame.direction = "TopLeft"
		if button == "RightButton" then
			frame:SetWidth(frame.width)
			frame:SetHeight(frame.height)
			local childrens = {frame:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= frame.bottomleftframe and child ~= frame.bottomrightframe and child ~= frame.toprightframe and child ~= frame.topleftframe then
					child:SetScale(frame.scale)
				end
			end
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		elseif button == "MiddleButton" then
			PowaOptionsFrame.bottomrightframe:Hide()
			PowaOptionsFrame.bottomleftframe:Hide()
			PowaOptionsFrame.toprightframe:Hide()
			PowaOptionsFrame.topleftframe:Hide()
			PowaBarConfigFrame.bottomrightframe:Hide()
			PowaBarConfigFrame.bottomleftframe:Hide()
			PowaBarConfigFrame.toprightframe:Hide()
			PowaBarConfigFrame.topleftframe:Hide()
			PowaMisc["ScaleLocked"] = true
			PowaDisableFrameScalingButton:SetChecked(true)
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		elseif button == "LeftButton" then
			frame.resizing = true
			frame:StartSizing("Top")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		end
	end)
	frame.topleftframe:SetScript("OnMouseUp", function(self, button)
		local x, y = GetCursorPosition()
		local fx = self:GetLeft() * self:GetEffectiveScale()
		local fy = self:GetBottom() * self:GetEffectiveScale()
		if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		else
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomlefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		end
		frame.resizing = nil
		frame.direction = nil
		frame:StopMovingOrSizing()
	end)
	frame.toprightframe = CreateFrame("Frame", nil, frame)
	frame.toprightframe:SetFrameStrata(frame:GetFrameStrata())
	frame.toprightframe:SetPoint("TopRight", frame, "TopRight", -8, -7)
	frame.toprightframe:SetWidth(16)
	frame.toprightframe:SetHeight(16)
	frame.toprightframe:SetFrameLevel(frame.frameLevel + 7)
	frame.toprightframe:EnableMouse(true)
	if PowaMisc.ScaleLocked then
		frame.toprightframe:Hide()
	else
		frame.toprightframe:Show()
	end
	frame.toprighttexture = frame.toprightframe:CreateTexture(nil, "Overlay")
	local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = frame.toprighttexture:GetTexCoord()
	frame.toprighttexture:SetTexCoord(LLx, LLy, ULx, ULy, LRx, LRy, URx, URy)
	frame.toprighttexture:SetPoint("TopLeft", frame.toprightframe, "TopLeft", 0, 0)
	frame.toprighttexture:SetWidth(16)
	frame.toprighttexture:SetHeight(16)
	frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	frame.toprightframe:SetScript("OnEnter", function(self)
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	frame.toprightframe:SetScript("OnLeave", function(self)
		frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	frame.toprightframe:SetScript("OnMouseDown", function(self, button)
		frame.direction = "TopRight"
		if button == "RightButton" then
			frame:SetWidth(frame.width)
			frame:SetHeight(frame.height)
			local childrens = {frame:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= frame.bottomleftframe and child ~= frame.bottomrightframe and child ~= frame.toprightframe and child ~= frame.topleftframe then
					child:SetScale(frame.scale)
				end
			end
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		elseif button == "MiddleButton" then
			PowaOptionsFrame.bottomrightframe:Hide()
			PowaOptionsFrame.bottomleftframe:Hide()
			PowaOptionsFrame.toprightframe:Hide()
			PowaOptionsFrame.topleftframe:Hide()
			PowaBarConfigFrame.bottomrightframe:Hide()
			PowaBarConfigFrame.bottomleftframe:Hide()
			PowaBarConfigFrame.toprightframe:Hide()
			PowaBarConfigFrame.topleftframe:Hide()
			PowaMisc["ScaleLocked"] = true
			PowaDisableFrameScalingButton:SetChecked(true)
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		elseif button == "LeftButton" then
			frame.resizing = true
			frame:StartSizing("Top")
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
		end
	end)
	frame.toprightframe:SetScript("OnMouseUp", function(self, button)
		local x, y = GetCursorPosition()
		local fx = self:GetLeft() * self:GetEffectiveScale()
		local fy = self:GetBottom() * self:GetEffectiveScale()
		if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
		else
			frame.toprighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.toplefttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
			frame.bottomrighttexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
		end
		frame.resizing = nil
		frame.direction = nil
		frame:StopMovingOrSizing()
	end)
	frame:SetScript("OnSizeChanged", function(self)
		local left, bottom = self:GetLeft(), self:GetBottom()
		if self.direction == "TopLeft" or self.direction == "TopRight" then
			if self.resizing then
				self:ClearAllPoints()
				if frame.direction == "TopLeft" then
					self:SetPoint("BottomRight", UIParent, "BottomRight", - (UIParent:GetWidth() - (left + self:GetWidth())), bottom)
				else
					self:SetPoint("BottomLeft", UIParent, "BottomLeft", left, bottom)
				end
			end
			local s = self:GetHeight() / frame.height
			local childrens = {self:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= self.bottomleftframe and child ~= self.bottomrightframe and child ~= self.toprightframe and child ~= self.topleftframe then
					child:SetScale(s)
				end
			end
			self:SetWidth(frame.width * s)
		else
			if self.resizing then
				self:ClearAllPoints()
				if frame.direction == "BottomLeft" then
					self:SetPoint("TopLeft", UIParent, "TopLeft", left, (UIParent:GetWidth() - (bottom + self:GetHeight())))
				else
					self:SetPoint("TopLeft", UIParent, "TopLeft", left, (UIParent:GetWidth() - (bottom + self:GetHeight())))
				end
			end
			local s = self:GetWidth() / frame.width
			local childrens = {self:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= self.bottomleftframe and child ~= self.bottomrightframe and child ~= self.toprightframe and child ~= self.topleftframe then
					child:SetScale(s)
				end
			end
			self:SetHeight(frame.height * s)
		end
	end)
end

function PowaAurasOptions:IconOnMouseWheel(delta)
	if delta then
		if delta > 0 then
			if PowaMisc.GroupSize < 8 then
				PowaMisc.GroupSize = PowaMisc.GroupSize + 1
			end
		else
			if PowaMisc.GroupSize > 1 then
				PowaMisc.GroupSize =  PowaMisc.GroupSize - 1
			end
		end
	end
	local min = self.CurrentAuraId
	local max = min + (PowaMisc.GroupSize - 1)
	for i = min, max do
		if self.Auras[i] then
			local slot = i - ((PowaAurasOptions.CurrentAuraPage - 1) * 24)
			local icon = _G["PowaIcone"..slot]
			if icon then
				icon:SetAlpha(1)
			end
			self:DisplayAura(i)
		end
	end
	if delta then
		if min > 1 then
			for i = 1, min - 1 do
				if self.Auras[i] then
					local aura = self.Auras[i]
					aura.Active = false
					self:ResetDragging(aura, self.Frames[i])
					aura:Hide()
					if aura.Timer then
						aura.Timer:Hide()
					end
					if aura.Stacks then
						aura.Stacks:Hide()
					end
					local slot = i - ((PowaAurasOptions.CurrentAuraPage - 1) * 24)
					local icon = _G["PowaIcone"..slot]
					if icon then
						icon:SetAlpha(0.33)
					end
				end
			end
		end
		for i = max + 1, PowaAurasOptions.CurrentAuraPage * 24 do
			if self.Auras[i] then
				local aura = self.Auras[i]
				aura.Active = false
				self:ResetDragging(aura, self.Frames[i])
				aura:Hide()
				if aura.Timer then
					aura.Timer:Hide()
				end
				if aura.Stacks then
					aura.Stacks:Hide()
				end
				local slot = i - ((PowaAurasOptions.CurrentAuraPage - 1) * 24)
				local icon = _G["PowaIcone"..slot]
				if icon then
					icon:SetAlpha(0.33)
				end
			end
		end
	end
	if PowaMisc.GroupSize == 1 then
		PowaHeader:SetText(self.Text.nomEffectEditor.." ("..self.CurrentAuraId..")")
	else
		PowaHeader:SetText(self.Text.nomEffectEditor.." ("..self.CurrentAuraId.." - "..self.CurrentAuraId + (PowaMisc.GroupSize - 1)..")")
	end
	PowaAurasOptions:UpdatePreviewColor(self.Auras[self.CurrentAuraId])
end

function PowaAurasOptions.SliderSetValues(slider, delta)
	if delta > 0 then
		slider:SetValue(slider:GetValue() + slider:GetValueStep())
	else
		slider:SetValue(slider:GetValue() - slider:GetValueStep())
	end
end

function PowaAurasOptions.SliderOnMouseUp(self, x, y, decimals, postfix)
	local frame = self:GetName()
	local min
	local max
	if x ~= 0 then
		min = format("%."..decimals.."f", (self:GetValue() - x))
	else
		local sliderMin = self:GetMinMaxValues()
		min = sliderMin
	end
	if y ~= 0 then
		max = format("%."..decimals.."f", (self:GetValue() + y))
	else
		local _, sliderMax = self:GetMinMaxValues()
		max = sliderMax
	end
	self:SetMinMaxValues(min, max)
	if not postfix then
		_G[frame.."Low"]:SetText(min)
		_G[frame.."High"]:SetText(max)
	else
		_G[frame.."Low"]:SetText(min..postfix)
		_G[frame.."High"]:SetText(max..postfix)
	end
end

function PowaAurasOptions.SliderEditBoxSetValues(slider, editbox, x, y, decimals, endmark)
	local frame = slider:GetName()
	local slidervalue = slider:GetValue()
	local postfix = tostring(string.sub(editbox:GetText(), - 1))
	local value
	if postfix == "%" then
		value = tonumber(string.sub(editbox:GetText(), 1, - 2))
	else
		value = tonumber(editbox:GetText())
	end
	if value then
		value = format("%."..decimals.."f", value)
		local min
		local max
		if x ~= 0 then
			min = format("%."..decimals.."f", (value - x))
		else
			local sliderMin = slider:GetMinMaxValues()
			min = sliderMin
		end
		if y ~= 0 then
			max = format("%."..decimals.."f", (value + y))
		else
			local _, sliderMax = slider:GetMinMaxValues()
			max = sliderMax
		end
		slider:SetMinMaxValues(min, max)
		slider:SetValue(value)
		if endmark == nil then
			editbox:SetText(format("%."..decimals.."f", value))
		elseif endmark == "%" then
			editbox:SetText(format("%."..decimals.."f", value)..endmark)
		else
			if postfix == "%" then
				editbox:SetText(format("%."..decimals.."f", slider:GetValue()).."%")
			else
				editbox:SetText(format("%."..decimals.."f", slider:GetValue()))
			end
		end
		if endmark == "%" then
			_G[frame.."Low"]:SetText(min..endmark)
			_G[frame.."High"]:SetText(max..endmark)
		else
			_G[frame.."Low"]:SetText(min)
			_G[frame.."High"]:SetText(max)
		end
	else
		if x == 0 and y == 0 then
			local sliderMin, sliderMax = slider:GetMinMaxValues()
			slider:SetMinMaxValues(sliderMin, sliderMax)
		elseif x == 0 then
			local sliderMin = slider:GetMinMaxValues()
			slider:SetMinMaxValues(sliderMin, slidervalue + y)
		elseif y == 0 then
			local _, sliderMax = slider:GetMinMaxValues()
			slider:SetMinMaxValues(slidervalue - x, sliderMax)
		else
			slider:SetMinMaxValues(slidervalue - x, slidervalue + y)
		end
		slider:SetValue(slidervalue)
		if endmark == "%" then
			editbox:SetText(format("%."..decimals.."f", slidervalue)..endmark)
		else
			editbox:SetText(format("%."..decimals.."f", slidervalue))
		end
		if endmark == "%" then
			_G[frame.."Low"]:SetText((slidervalue - x)..endmark)
			_G[frame.."High"]:SetText((slidervalue + y)..endmark)
		else
			_G[frame.."Low"]:SetText(slidervalue - x)
			_G[frame.."High"]:SetText(slidervalue + y)
		end
	end
end

function PowaAurasOptions.SliderEditBoxChanged(self)
	local frame = self:GetName()
	local slider = _G[string.sub(frame, 1, - 1 * (string.len("EditBox") + 1))]
	local postfix = tostring(string.sub(self:GetText(), - 1))
	if slider == PowaBarAuraSizeSlider then
		PowaAurasOptions.SliderEditBoxSetValues(slider, self, 0, 100, 0, "%")
	elseif slider == PowaBarAuraCoordXSlider or slider == PowaTimerCoordXSlider or slider == PowaStacksCoordXSlider then
		PowaAurasOptions.SliderEditBoxSetValues(slider, self, 700, 700, 0)
	elseif slider == PowaBarAuraCoordYSlider or slider == PowaTimerCoordYSlider or slider == PowaStacksCoordYSlider then
		PowaAurasOptions.SliderEditBoxSetValues(slider, self, 400, 400, 0)
	elseif slider == PowaModelPositionZSlider then
		PowaAurasOptions.SliderEditBoxSetValues(slider, self, 100, 100, 0)
	elseif slider == PowaModelPositionXSlider or slider == PowaModelPositionYSlider then
		PowaAurasOptions.SliderEditBoxSetValues(slider, self, 50, 50, 0)
	end
	if postfix == "%" and (slider == PowaTimerSizeSlider or slider == PowaTimerAlphaSlider or slider == PowaStacksSizeSlider or slider == PowaStacksAlphaSlider) then
		local text = tonumber(string.sub(self:GetText(), 1, - 2))
		if text then
			text = text / 100
			slider:SetValue(text)
			self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text <= sliderlow or text >= sliderhigh then
				self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
			end
		else
			self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
		end
	elseif postfix == "%" and (slider == PowaBarAuraAlphaSlider or slider == PowaBarAuraSizeSlider or slider == PowaBarAuraAnimSpeedSlider) then
		local text = tonumber(string.sub(self:GetText(), 1, - 2))
		if text then
			slider:SetValue(text)
			self:SetText(format("%.0f", (slider:GetValue())).."%")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text <= sliderlow or text >= sliderhigh then
				self:SetText(format("%.0f", slider:GetValue()).."%")
			end
		else
			self:SetText(format("%.0f", slider:GetValue()).."%")
		end
	elseif postfix == "%" and slider == PowaBarThresholdSlider then
		local text = tonumber(string.sub(self:GetText(), 1, - 2))
		local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
		if text and aura.RangeType == "%" then
			slider:SetValue(text)
			self:SetText(format("%.0f", (slider:GetValue()))..aura.RangeType)
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text <= sliderlow or text >= sliderhigh then
				self:SetText(format("%.0f", slider:GetValue())..aura.RangeType)
			end
		else
			self:SetText(format("%.0f", slider:GetValue())..aura.RangeType)
		end
		PowaBarThresholdSliderEditBox:SetText(format("%.0f", PowaBarThresholdSlider:GetValue())..aura.RangeType)
	elseif slider == PowaTimerSizeSlider or slider == PowaTimerAlphaSlider or slider == PowaStacksSizeSlider or slider == PowaStacksAlphaSlider then
		local text = tonumber(self:GetText())
		if text then
			text = text / 100
			slider:SetValue(text)
			self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text < sliderlow or text > sliderhigh then
				self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
			end
		else
			self:SetText(format("%.0f", (slider:GetValue() * 100)).."%")
		end
	elseif slider == PowaBarAuraAlphaSlider or slider == PowaBarAuraSizeSlider or slider == PowaBarAuraAnimSpeedSlider then
		local text = tonumber(self:GetText())
		if text then
			slider:SetValue(text)
			self:SetText(format("%.0f", (slider:GetValue())).."%")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text <= sliderlow or text >= sliderhigh then
				self:SetText(format("%.0f", slider:GetValue()).."%")
			end
		else
			self:SetText(format("%.0f", slider:GetValue()).."%")
		end
	elseif slider == PowaBarThresholdSlider then
		local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
		if aura.PowerType == SPELL_POWER_BURNING_EMBERS then
			local text = tonumber(self:GetText())
			local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
			if text then
				slider:SetValue(text)
				self:SetText(format("%.1f", (slider:GetValue()))..aura.RangeType)
				local sliderlow, sliderhigh = slider:GetMinMaxValues()
				if text <= sliderlow or text >= sliderhigh then
					self:SetText(format("%.1f", slider:GetValue())..aura.RangeType)
				end
			else
				self:SetText(format("%.1f", slider:GetValue())..aura.RangeType)
			end
			PowaBarThresholdSliderEditBox:SetText(format("%.1f", PowaBarThresholdSlider:GetValue())..aura.RangeType)
		else
			local text = tonumber(self:GetText())
			local aura = PowaAurasOptions.Auras[PowaAurasOptions.CurrentAuraId]
			if text then
				slider:SetValue(text)
				self:SetText(format("%.0f", (slider:GetValue()))..aura.RangeType)
				local sliderlow, sliderhigh = slider:GetMinMaxValues()
				if text <= sliderlow or text >= sliderhigh then
					self:SetText(format("%.0f", slider:GetValue())..aura.RangeType)
				end
			else
				self:SetText(format("%.0f", slider:GetValue())..aura.RangeType)
			end
			PowaBarThresholdSliderEditBox:SetText(format("%.0f", PowaBarThresholdSlider:GetValue())..aura.RangeType)
	end
	elseif tonumber(postfix) == nil and slider == PowaBarAuraRotateSlider then
		local text = tonumber(string.sub(self:GetText(), 1, - 2))
		if text == nil then
			text = tonumber(string.sub(self:GetText(), 1, - 3))
		end
		if text then
			slider:SetValue(text)
			self:SetText(format("%.0f", slider:GetValue()).."°")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text < sliderlow or text > sliderhigh then
				self:SetText(format("%.0f", slider:GetValue()).."°")
			end
		else
			self:SetText(format("%.0f", slider:GetValue()).."°")
		end
	elseif slider == PowaBarAuraRotateSlider then
		local text = tonumber(self:GetText())
		if text then
			slider:SetValue(text)
			self:SetText(format("%.0f", slider:GetValue()).."°")
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if text < sliderlow or text > sliderhigh then
				self:SetText(format("%.0f", slider:GetValue()).."°")
			end
		else
			self:SetText(format("%.0f", slider:GetValue()).."°")
		end
	elseif slider == PowaBarAuraDeformSlider or slider == PowaBarAuraDurationSlider or slider == PowaTimerDurationSlider or slider == PowaTimerInvertAuraSlider then
		if tonumber(self:GetText()) ~= nil then
			slider:SetValue(tonumber(self:GetText()))
			self:SetText(format("%.2f", slider:GetValue()))
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if tonumber(self:GetText()) < sliderlow or tonumber(self:GetText()) > sliderhigh then
				self:SetText(slider:GetValue())
			end
		else
			self:SetText(slider:GetValue())
		end
	else
		if tonumber(self:GetText()) ~= nil then
			slider:SetValue(tonumber(self:GetText()))
			self:SetText(format("%.0f", slider:GetValue()))
			local sliderlow, sliderhigh = slider:GetMinMaxValues()
			if tonumber(self:GetText()) < sliderlow or tonumber(self:GetText()) > sliderhigh then
				self:SetText(slider:GetValue())
			end
		else
			self:SetText(slider:GetValue())
		end
	end
end