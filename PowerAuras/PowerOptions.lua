local string, find, sub, gsub, gmatch, len, tostring, tonumber, table, sort, math, min, pairs, ipairs, strsplit = string, find, sub, gsub, gmatch, len, tostring, tonumber, table, sort, math, min, pairs, ipairs, strsplit;

-- Main Options
function PowaAuras:ResetPositions()
	PowaBarConfigFrame:ClearAllPoints();
	PowaBarConfigFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 50);
	PowaOptionsFrame:ClearAllPoints();
	PowaOptionsFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 50);
end

function PowaAuras:UpdateMainOption(hideAll)
	PowaOptionsHeader:SetText("Power Auras "..self.Version);
	PowaMainHideAllButton:SetText(self.Text.nomHide);
	PowaMainTestButton:SetText(self.Text.nomTest);
	PowaEditButton:SetText(self.Text.nomEdit);
	PowaOptionsRename:SetText(self.Text.nomRename);
	PowaEnableButton:SetChecked(PowaMisc.Disabled ~= true);
	PowaDebugButton:SetChecked(PowaMisc.Debug == true);
	PowaTimerRoundingButton:SetChecked(PowaMisc.TimerRoundUp == true);
	PowaAllowInspectionsButton:SetChecked(PowaMisc.AllowInspections == true);
	PowaOptionsTextureCount:SetValue(self.MaxTextures);
	-- Attach the icons
	for i = 1, 24 do
		local k = ((self.CurrentAuraPage - 1) * 24) + i;
		--self:Message("icon ", k);
		local aura = self.Auras[k];
		local icon = getglobal("PowaIcone"..i);
		-- Icon
		icon.aura = aura;
		if (aura == nil) then
			icon:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot");
			icon:SetText("");
			icon:SetAlpha(0.33);
		else
			--self:Message("buffname ", aura.buffname, "icon", aura.icon);
			if (aura.buffname == "" or aura.buffname == " ") then
				icon:SetNormalTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot");
			elseif (aura.icon == "") then -- active mais pas d'icone
				icon:SetNormalTexture("Interface\\Icons\\Inv_Misc_QuestionMark");
			else
				icon:SetNormalTexture(aura.icon);
			end
			if (aura.buffname ~= "" and aura.buffname ~= " " and aura.off) then
				icon:SetText("OFF");
			else
				icon:SetText("");
			end
			-- Highlighting the current aura icon
			if (self.CurrentAuraId == k) then -- The current button
				if (aura == nil or aura.buffname == "" or aura.buffname == " ") then
					PowaSelected:Hide();
				else
					PowaSelected:SetPoint("CENTER", "PowaIcone"..i, "CENTER");
					PowaSelected:Show();
				end
			end
			-- Descrease alpha for non-visible auras
			if (not aura.Showing) then
				icon:SetAlpha(0.33);
			else
				if hideAll == true then
					icon:SetAlpha(0.33);
				else
					icon:SetAlpha(1.0);
				end
			end
		end
	end
	-- Select the current list
	getglobal("PowaOptionsList"..self.CurrentAuraPage):SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight");
	getglobal("PowaOptionsList"..self.CurrentAuraPage):LockHighlight();
end

function PowaAuras:IconClick(owner, button)
	if (self.MoveEffect > 0) then -- Move mode
		return;
	end
	if (ColorPickerFrame:IsVisible()) then -- Color picker visible, ignore
		return;
	end
	local aura = owner.aura;
	if (aura == nil or aura.buffname == "" or aura.buffname == " ") then -- Not a live button
		return;
	end
	if IsShiftKeyDown() then -- Toggle ON/OFF
		if (aura.off) then
			aura.off = false;
			owner:SetText("");
		else
			aura.off = true;
			owner:SetText("OFF");
			owner:SetAlpha(0.33);
		end
	elseif IsControlKeyDown() then
		local show, reason = self:TestThisEffect(aura.id, true);
		if (show) then
			self:Message(self:InsertText(self.Text.nomReasonShouldShow, reason)); -- OK
		else
			self:Message(self:InsertText(self.Text.nomReasonWontShow, reason)); -- OK
		end
	elseif (self.CurrentAuraId == aura.id) then
		if (button == "RightButton") then
			if aura.off == false then
				if (not aura.Showing) then
					owner:SetAlpha(1.0);
				end
				PowaAuras:OptionEditorTest();
			end
			self:EditorShow();
		else
			if aura.off == false then
				if (not aura.Showing) then
					owner:SetAlpha(1.0);
				end
				PowaAuras:OptionTest();
			end
		end
	elseif (self.CurrentAuraId ~= aura.id) then -- Clicked a different button
		self:SetCurrent(owner, aura.id);
		self:InitPage(aura);
		if (button == "RightButton") then
			if aura.off == false then
				if (not aura.Showing) then
					owner:SetAlpha(1.0);
				end
				PowaAuras:OptionEditorTest();
			end
			PowaBarConfigFrame:Hide();
			self:EditorShow();
		end
	end
end

function PowaAuras:SetCurrent(icon, auraId)
	self.CurrentAuraId = auraId;
	if (icon == nil) then return; end
	PowaSelected:SetPoint("CENTER", icon, "CENTER");
	PowaSelected:Show();
end

function PowaAuras:IconeEntered(owner)
	local iconeID = owner:GetID();
	local k = ((self.CurrentAuraPage - 1) * 24) + iconeID;
	local aura = self.Auras[k];
	if (self.MoveEffect > 0) then
		return;
	elseif (aura == nil) then
		-- If not active
	elseif (aura.buffname == "" or aura.buffname == " ") then
		-- If no name
	else
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
		aura:AddExtraTooltipInfo(GameTooltip);
		if (aura.party) then
			GameTooltip:AddLine("("..self.Text.nomCheckParty..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.exact) then
			GameTooltip:AddLine("("..self.Text.nomExact..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.mine) then
			GameTooltip:AddLine("("..self.Text.nomMine..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.focus) then
			GameTooltip:AddLine("("..self.Text.nomCheckFocus..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.raid) then
			GameTooltip:AddLine("("..self.Text.nomCheckRaid..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.groupOrSelf) then
			GameTooltip:AddLine("("..self.Text.nomCheckGroupOrSelf..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.optunitn) then
			GameTooltip:AddLine("("..self.Text.nomCheckOptunitn..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.target) then
			GameTooltip:AddLine("("..self.Text.nomCheckTarget..")", 1.0, 0.2, 0.2, 1);
		end
		if (aura.targetfriend) then
			GameTooltip:AddLine("("..self.Text.nomCheckFriend..")", 0.2, 1.0, 0.2, 1);
		end
		GameTooltip:AddLine(self.Text.aideEffectTooltip, 1.0, 1.0, 1.0, 1);
		GameTooltip:AddLine(self.Text.aideEffectTooltip2, 1.0, 1.0, 1.0, 1);
		GameTooltip:Show();
	end
end

function PowaAuras:MainListClick(owner)
	local listeID = owner:GetID();
	if (self.MoveEffect == 1) then
		-- Move the aura
		self:BeginCopyEffect(self.CurrentAuraId, listeID)
		return;
	elseif (self.MoveEffect == 2) then
		-- Move the aura
		self:BeginMoveEffect(self.CurrentAuraId, listeID)
		return;
	end
	if IsShiftKeyDown() then -- Toggle ON/OFF
		local min = ((listeID - 1) * 24) + 1;
		local max = min + 23;
		local allEnabled = true;
		local offText = "OFF";
		for i = min, max do
			local aura = self.Auras[i];
			if (aura and aura.off) then
				allEnabled = false;
				offText = "";
				break;
			end
		end
		for i = min, max do
			--self:ShowText("Toggle aura ", i);
			local aura = self.Auras[i];
			if (aura) then
				local auraIcon = getglobal("PowaIcone"..(i - min + 1));
				aura.off = allEnabled;
				auraIcon:SetText(offText);
			end
			self.SecondaryAuras[i] = nil;
		end
		self.DoCheck.All = true;
		return;
	end
	getglobal("PowaOptionsList"..self.CurrentAuraPage):SetHighlightTexture("");
	getglobal("PowaOptionsList"..self.CurrentAuraPage):UnlockHighlight();
	PowaSelected:Hide();
	self.CurrentAuraPage = listeID;
	self.CurrentAuraId = ((self.CurrentAuraPage - 1) * 24) + 1;
	local aura = self.Auras[self.CurrentAuraId];
	if (aura ~= nil and aura.buffname ~= "" and aura.buffname ~= " ") then
		self:InitPage(aura);
	else
		self:EditorClose();
	end
	-- Set text for rename
	--local pageButton = "PowaOptionsList"..self.CurrentAuraPage;
	--self:ShowText(pageButton, getglobal(pageButton));
	local currentText = getglobal("PowaOptionsList"..self.CurrentAuraPage):GetText();
	if (currentText == nil) then
		currentText = "";
	end
	PowaOptionsRenameEditBox:SetText( currentText );
	self:UpdateMainOption();
end

function PowaAuras:MainListEntered(owner)
	local listeID = owner:GetID();
	if (self.CurrentAuraPage ~= listeID) then
		if (self.MoveEffect > 0) then
			getglobal("PowaOptionsList"..listeID):SetHighlightTexture("Interface\\Buttons\\UI-Panel-Button-Highlight");
		else
			getglobal("PowaOptionsList"..listeID):SetHighlightTexture("");
			getglobal("PowaOptionsList"..listeID):UnlockHighlight();
		end
	end
	if (self.MoveEffect == 1) then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
		GameTooltip:SetText(self.Text.aideCopy, nil, nil, nil, nil, 1);
		GameTooltip:Show();
	elseif (self.MoveEffect == 2) then
		GameTooltip:SetOwner(owner, "ANCHOR_RIGHT");
		GameTooltip:SetText(self.Text.aideMove, nil, nil, nil, nil, 1);
		GameTooltip:Show();
	end
end

function PowaAuras:OptionRename()
	PowaOptionsRename:Hide();
	PowaOptionsRenameEditBox:Show();
	local currentText = getglobal("PowaOptionsList"..self.CurrentAuraPage):GetText();
	if (currentText == nil) then currentText = "" end;
	PowaOptionsRenameEditBox:SetText( currentText );
end

function PowaAuras:OptionRenameEdited()
	PowaOptionsRename:Show();
	PowaOptionsRenameEditBox:Hide();
	getglobal("PowaOptionsList"..self.CurrentAuraPage):SetText( PowaOptionsRenameEditBox:GetText() );
	if (self.CurrentAuraPage > 5) then
		PowaGlobalListe[self.CurrentAuraPage-5] = PowaOptionsRenameEditBox:GetText();
	else
		PowaPlayerListe[self.CurrentAuraPage] = PowaOptionsRenameEditBox:GetText();
	end
end

function PowaAuras:TriageIcones(nPage)
	local min = ((nPage - 1) * 24) + 1;
	local max = min + 23;
	-- Hide any auras on this page
	for i = min, max do
		local aura = self.Auras[i];
		if (aura) then
			aura:Hide();
		end
		self.SecondaryAuras[i] = nil;
	end
	local a = min;
	for i = min, max do
		if (self.Auras[i]) then
			if (i ~= a) then
				self:ReindexAura(i, a);
			end
			if (i > a) then
				self.Auras[i] = nil;
			end
			a = a + 1;
		end
	end
	-- Keep global auras in step
	for i = 121, 360 do
		if (self.Auras[i]) then
			PowaGlobalSet[i] = self.Auras[i];
		else
			PowaGlobalSet[i] = nil;
		end
	end
end

function PowaAuras:ReindexAura(oldId, newId)
	self.Auras[newId] = self.Auras[oldId];
	self.Auras[newId].id = newId;
	if (self.Auras[newId].Timer) then
		self.Auras[newId].Timer.id = newId;
	end
	if (self.Auras[newId].Stacks) then
		self.Auras[newId].Stacks.id = newId;
	end
	-- Update any multi-id references
	for i = 1, 360 do
		local aura = self.Auras[i];
		if (aura) then
			if (aura.multiids and aura.multiids ~= "") then
				local newMultiids = "";
				local sep = "";
				for multiId in string.gmatch(aura.multiids, "[^/]+") do
					if (tonumber(multiId) == oldId) then
						newMultiids = newMultiids .. sep .. tostring(newId);
					else
						newMultiids = newMultiids .. sep .. multiId;
					end
					sep = "/";
				end
				aura.multiids = newMultiids;
			end
		end
	end
end

function PowaAuras:Dispose(tableName, key, key2)
	local t = self[tableName];
	if (t == nil or t[key] == nil) then return; end
	if (key2 ~= nil) then
		if (t[key][key2] == nil) then
			return;
		end
		t = t[key];
		key = key2;
	end
	if (t[key].Hide) then
		t[key]:Hide();
	end
	t[key] = nil;
end

function PowaAuras:DeleteAura(aura)
	if (not aura) then return; end
	--self:Message("DeleteAura ", aura.id);
	aura:Hide();
	if (aura.Timer) then aura.Timer:Dispose(); end
	if (aura.Stacks) then aura.Stacks:Dispose(); end
	aura:Dispose();
	PowaSelected:Hide();
	if (PowaBarConfigFrame:IsVisible()) then
		PowaBarConfigFrame:Hide();
	end
	self.Auras[aura.id] = nil;
	if (aura.id > 120) then
		PowaGlobalSet[aura.id] = nil;
	end
end

function PowaAuras:OptionDeleteEffect(auraId)
	if (not IsControlKeyDown()) then return; end
	self:DeleteAura(self.Auras[auraId]);
	self:TriageIcones(self.CurrentAuraPage);
	self:CalculateAuraSequence();
	self:UpdateMainOption();
end

function PowaAuras:GetNextFreeSlot(page)
	if (page == nil) then
		page = self.CurrentAuraPage;
	end
	local min = ((page - 1) * 24) + 1;
	local max = min + 23;
	for i = min, max do
		if (self.Auras[i] == nil or self.Auras[i].buffname == "" or self.Auras[i].buffname == " ") then -- Found a free slot
			return i;
		end
	end
	return nil;
end

function PowaAuras:OptionNewEffect()
	local i = self:GetNextFreeSlot();
	if (not i) then
		self:Message("All aura slots filled"); -- OK
		return;
	end
	--self:Message("New Effect slot=", i)
	self.CurrentAuraId = i;
	self.CurrentAuraPage = self.CurrentAuraPage;
	local aura = self:AuraFactory(self.BuffTypes.Buff, i);
	--self:Message("Timer.enabled=", aura.Timer.enabled)
	aura:Init();
	self.Auras[i] = aura;
	-- effet global ?
	if (i > 120) then
		PowaGlobalSet[i] = aura;
	end
	self:CalculateAuraSequence();
	aura.Active = true;
	aura:CreateFrames();
	self.SecondaryAuras[i] = nil; -- Force recreate
	self:DisplayAura(i);
	self:UpdateMainOption();
	self:UpdateTimerOptions();
	self:InitPage(aura);
	self:UpdateMainOption();
	if (PowaEquipmentSlotsFrame:IsVisible()) then
		PowaEquipmentSlotsFrame:Hide();
	end
	if (not PowaBarConfigFrame:IsVisible()) then
		PowaBarConfigFrame:Show();
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel);
	end
	--self:Debug("New aura ", i);
	--aura:Display();
end

function PowaAuras:ExtractImportValue(valueType, value)
	--self:Message("valueType=", valueType," value=", value);
	if (string.sub(valueType,1,2) == "st") then
		return value;
	end
	if value == "false" then
		return false;
	elseif value == "true" then
		return true;
	end
	return tonumber(value);
end

function PowaAuras:VersionGreater(v1, v2)
	if (v1.Major > v2.Major) then
		return true;
	end
	if (v1.Major < v2.Major) then
		return false;
	end
	if (v1.Minor > v2.Minor) then
		return true;
	end
	if (v1.Minor < v2.Minor) then
		return false;
	end
	if (v1.Build > v2.Build) then
		return true;
	end
	if (v1.Build < v2.Build) then
		return false;
	end
	return v1.Revision > v2.Revision;
end

function PowaAuras:ImportAura(aurastring, auraId, offset)
	--self:Message("Import ", auraId);
	--self:Message(aurastring);
	local aura = cPowaAura(auraId);
	local trimmed = string.gsub(aurastring,";%s*",";");
	local settings = {strsplit(";", trimmed)};
	local importAuraSettings = { };
	local importTimerSettings = { };
	local importStacksSettings = { };
	local hasTimerSettings = false;
	local hasStacksSettings = false;
	local oldSpellAlertLogic = true;
	local hasTypePrefix = false;
	if (not string.find(aurastring,"Version:", 1, true)) then
		hasTypePrefix = true;
	else
		hasTypePrefix = string.find(aurastring,"Version:st", 1, true);
	end
	--self:Message("hasTypePrefix=", hasTypePrefix);
	if (hasTypePrefix) then
		for null, val in ipairs(settings) do
			local key, var = strsplit(":", val);
			--self:Message("key ",key,"=", var);
			local varType = string.sub(var, 1, 2);
			var = string.sub(var, 3);
			if (key == "Version") then
				local null, null, major, minor = string.find(var, self.VersionPattern);
				if (self:VersionGreater({Major=tonumber(major), Minor = tonumber(minor), Build = 0, Revision = ""}, {Major = 3, Minor = 0, Build = 0, Revision = "J"})) then
					oldSpellAlertLogic = false;
				end
			elseif (string.sub(key, 1, 6) == "timer.") then
				local key = string.sub(key, 7);
				if (key == "InvertAuraBelow") then
					if (self:IsNumeric(var)) then
						importAuraSettings[key] = self:ExtractImportValue(varType, var);
					end
				else
					importTimerSettings[key] = self:ExtractImportValue(varType, var);
					hasTimerSettings = true;
				end
			elseif (string.sub(key, 1, 7) == "stacks.") then
				importStacksSettings[string.sub(key, 8)] = self:ExtractImportValue(varType, var);
				hasStacksSettings = true;
			else
				importAuraSettings[key] = self:ExtractImportValue(varType, var);
			end
		end
	else
		for null, val in ipairs(settings) do
			local key, var = strsplit(":", val);
			oldSpellAlertLogic = false;
			--self:Message("val=", val);
			--self:Message(key,"=", var);
			if (key == "Version") then
			elseif (string.sub(key,1,6) == "timer.") then
				key = string.sub(key,7);
				if (cPowaTimer.ExportSettings[key] ~= nil) then
					--self:Message("cPowaTimer.ExportSettings[key]=",cPowaTimer.ExportSettings[key]," type=", type(cPowaTimer.ExportSettings[key]));
					importTimerSettings[key] = self:ExtractImportValue(type(cPowaTimer.ExportSettings[key]), var);
					hasTimerSettings = true;
				end
			elseif (string.sub(key, 1, 7) == "stacks.") then
				key = string.sub(key, 8);
				if (cPowaStacks.ExportSettings[key] ~= nil) then
					importStacksSettings[key] = self:ExtractImportValue(type(cPowaStacks.ExportSettings[key]), var);
					hasStacksSettings = true;
				end
			else
				--self:Message("cPowaAura.ExportSettings[",key,"]=", cPowaAura.ExportSettings[key]);
				if (cPowaAura.ExportSettings[key] ~= nil) then
					importAuraSettings[key] = self:ExtractImportValue(type(cPowaAura.ExportSettings[key]), var);
				end
			end
		end
	end
	for k, v in pairs(aura) do
		if (importAuraSettings[k] ~= nil) then
			local varType = type(v);
			--self:Message("k=", k, " v=",importAuraSettings[k]);
			if (k == "combat") then
				if (importAuraSettings[k] == 0) then
					aura[k] = 0;
				elseif (importAuraSettings[k] == 1) then
					aura[k] = true;
				elseif (importAuraSettings[k] == 2) then
					aura[k] = false;
				else
					aura[k] = importAuraSettings[k];
				end
			elseif (k == "isResting") then
				if (importAuraSettings.ignoreResting == true) then
					aura[k] = true;
				elseif (importAuraSettings.ignoreResting == true) then
					aura[k] = 0;
				else
					aura[k] = importAuraSettings[k];
				end
			elseif (k == "inRaid") then
				if (importAuraSettings.isinraid == true) then
					aura[k] = true;
				elseif (importAuraSettings.isinraid == false) then
					aura[k] = 0;
				else
					aura[k] = importAuraSettings[k];
				end
			elseif (k == "multiids" and offset) then
				local newMultiids = "";
				local sep = "";
				for multiId in string.gmatch(importAuraSettings[k], "[^/]+") do
					multiId = cPowaAura:Trim(multiId);
					local negate = "";
					if (string.sub(multiId, 1, 1) == "!") then
						multiId = string.sub(multiId, 2);
						negate = "!";
					end
					local multiIdNumber = tonumber(multiId);
					--self:Message("multiId=", multiId, " multiIdNumber=", multiIdNumber, " offset=", offset);
					if (multiIdNumber) then
						newMultiids = newMultiids .. sep .. negate .. tostring(offset + multiIdNumber);
						--self:Message("newMultiids=", newMultiids);
						sep = "/";
					end
				end
				aura[k] = newMultiids;
			elseif (k == "icon") then
				if (string.find(string.lower(importAuraSettings[k]), string.lower(PowaAuras.IconSource), 1, true) == 1) then
					aura[k] = importAuraSettings[k];
				else
					aura[k] = PowaAuras.IconSource..importAuraSettings[k];
				end
			elseif (varType == "string" or varType == "boolean" or varType == "number" and k ~= "id") then
				aura[k] = importAuraSettings[k];
			end
		end
	end
	if (aura.bufftype == self.BuffTypes.Combo) then --backwards compatability
		if (string.len(aura.buffname) > 1 and string.find(aura.buffname, "/", 1, true) == nil) then
			local newBuffName = string.sub(aura.buffname, 1, 1);
			for i = 2, string.len(aura.buffname) do
				newBuffName = newBuffName.."/"..string.sub(aura.buffname, i, i);
			end
			aura.buffname = newBuffName
		end
	elseif (aura.bufftype == self.BuffTypes.SpellAlert) then
		if (oldSpellAlertLogic) then
			if (aura.target) then
				aura.groupOrSelf = true;
			elseif (aura.targetfriend) then
				aura.targetfriend = false;
			end
		end
	end
	if (importAuraSettings.timer) then --backwards compatability
		aura.Timer = cPowaTimer(aura);
	end
	if (hasTimerSettings) then
		aura.Timer = cPowaTimer(aura, importTimerSettings);
	end
	if (hasStacksSettings) then
		aura.Stacks = cPowaStacks(aura, importStacksSettings);
	end
	--self:Message("new Aura created from import");
	--aura:Display();
	return self:AuraFactory(aura.bufftype, auraId, aura);
end

function PowaAuras:CreateNewAuraFromImport(auraId, importString, updateLink)
	if importString == nil or importString == "" then
		return;
	end
	self.Auras[auraId] = self:ImportAura(importString, auraId, updateLink);
	self.Auras[auraId]:Init();
	self:CalculateAuraSequence();
	if (auraId > 120) then
		PowaGlobalSet[auraId] = self.Auras[auraId];
	end
end

function PowaAuras:CreateNewAuraSetFromImport(importString)
	if importString == nil or importString == "" then
		return;
	end
	local min = ((self.CurrentAuraPage-1)*24) + 1;
	local max = min + 23;
	for i = min, max do
		if (self.Auras[i] ~= nil) then
			self:DeleteAura(self.Auras[i]);
		end
	end
	local auraId = min;
	local offset;
	local setName;
	for k, v in string.gmatch(importString, "([^\n=@]+)=([^@]+)@") do
		--self:ShowText("k=", k, " len=", string.len(v));
		if (k == "Set") then
			setName = v;
		else
			if (not offset) then
				local null, null, oldAuraId = string.find(k, "(%d+)");
				--self:ShowText("oldAuraId=", oldAuraId);
				if (self:IsNumeric(oldAuraId)) then
					offset = min - oldAuraId;
				end
				--self:ShowText(" offset=", offset);
			end
			self.Auras[auraId] = self:ImportAura(v, auraId, offset);
			if (auraId > 120) then
				PowaGlobalSet[auraId] = self.Auras[auraId];
			end
			auraId = auraId + 1;
		end
	end
	if (setName ~= nil) then
		local nameFound = false;
		for i = 1, 5 do
			if (PowaPlayerListe[i] == setName) then
				nameFound = true;
			end
		end
		for i = 1, 10 do
			if (PowaGlobalListe[i] == setName) then
				nameFound = true;
			end
		end
		if (not nameFound) then
			getglobal("PowaOptionsList"..self.CurrentAuraPage):SetText( setName );
			if (self.CurrentAuraPage > 5) then
				PowaGlobalListe[self.CurrentAuraPage - 5] = setName;
			else
				PowaPlayerListe[self.CurrentAuraPage] = setName;
			end
		end
	end
	self:CalculateAuraSequence();
	self:UpdateMainOption();
end

function PowaAuras:OptionImportEffect()
	local i = self:GetNextFreeSlot();
	if (not i) then
		self:Message("All aura slots filled"); -- OK
		return;
	end
	self.ImportAuraId = i;
	StaticPopup_Show("POWERAURAS_IMPORT_AURA");
end

function PowaAuras:CreateAuraSetString()
	local setString = "Set=";
	if (self.CurrentAuraPage > 5) then
		setString = setString .. PowaGlobalListe[self.CurrentAuraPage-5];
	else
		setString = setString .. PowaPlayerListe[self.CurrentAuraPage];
	end
	setString = setString .. "@";
	local min = ((self.CurrentAuraPage-1)*24) + 1;
	local max = min + 23;
	for i = min, max do
		--self:ShowText(i);
		if (self.Auras[i] ~= nil and self.Auras[i].buffname ~= "" and self.Auras[i].buffname ~= " ") then
			setString = setString .. "\nAura[" .. tostring(i) .. "]=" .. self.Auras[i]:CreateAuraString(true).."@";
			--self:ShowText("Aura[" .. tostring(i) .. "]");
		end
	end
	return setString;
end

function PowaAuras:OptionImportSet()
	StaticPopup_Show("POWERAURAS_IMPORT_AURA_SET");
end

function PowaAuras:ImportAuraDialogInit()
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA"] = {
		text = self.Text.aideImport,
		button1 = self.Text.ImportDialogAccept,
		button2 = self.Text.ImportDialogCancel,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAuras:CreateNewAuraFromImport(PowaAuras.ImportAuraId, self.editBox:GetText());
			self:Hide();
		end,
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow();
			self.editBox:SetText("");
			PowaAuras:DisplayAura(PowaAuras.CurrentAuraId);
			PowaAuras:UpdateMainOption();
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			PowaAuras:CreateNewAuraFromImport(PowaAuras.ImportAuraId, parent.editBox:GetText());
			parent:Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopupDialogs["POWERAURAS_IMPORT_AURA_SET"] = {
		text = self.Text.aideImportSet,
		button1 = self.Text.ImportDialogAccept,
		button2 = self.Text.ImportDialogCancel,
		hasEditBox = 1,
		maxLetters = self.ExportMaxSize * 24,
		--hasWideEditBox = 1,
		editBoxWidth = self.ExportWidth,
		OnAccept = function(self)
			PowaAuras:CreateNewAuraSetFromImport(self.editBox:GetText());
			self:Hide();
		end,
		OnShow = function(self)
			self.editBox:SetFocus();
		end,
		OnHide = function(self)
			ChatEdit_FocusActiveWindow();
			self.editBox:SetText("");
			PowaAuras:DisplayAura(PowaAuras.CurrentAuraId);
			PowaAuras:UpdateMainOption();
		end,
		EditBoxOnEnterPressed = function(self)
			local parent = self:GetParent();
			PowaAuras:CreateNewAuraSetFromImport(parent.editBox:GetText());
			parent:Hide();
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide();
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};
end

-- Export Dialog
function PowaAuras:OptionExportEffect()
	if self.Auras[self.CurrentAuraId] then
		-- Manually set text.
		PowaAuraExportDialogCopyBox:SetText(PowaAuras.Auras[PowaAuras.CurrentAuraId]:CreateAuraString());
		PowaAuraExportDialog.sendType = 1;
		-- Use a special popup, which allows us to make our own frame.
		StaticPopupSpecial_Show(PowaAuraExportDialog);
	end
end

function PowaAuras:OptionExportSet()
	-- Manually set text.
	PowaAuraExportDialogCopyBox:SetText(PowaAuras:CreateAuraSetString());
	PowaAuraExportDialog.sendType = 2;
	-- Use a special popup, which allows us to make our own frame.
	StaticPopupSpecial_Show(PowaAuraExportDialog);
end

function PowaAuras:SetDialogTimeout(dialog, timeout)
	-- If no response is received after a specific time, we'll cancel what we're doing.
	-- Don't reset if the timeout period is the same.
	if(dialog.statusTimeoutLength == timeout) then
		if(timeout == 0) then
			-- Remove if not needed.
			dialog:SetScript("OnUpdate", nil);
		end
		return;
	end
	-- Update stuff.
	dialog.statusTimeoutLength = timeout;
	dialog.statusTimeout = (time() + timeout);
	-- If it's more than 0, add the loop.
	if(dialog.statusTimeoutLength > 0) then
		-- Add onupdate handler if needed.
		dialog:SetScript("OnUpdate", function(dialog)
			-- Set status to 3 and remove update loop if timeout exceeded.
			if(dialog.statusTimeout <= time()) then
				dialog.errorReason = 3;
				dialog:SetStatus(3);
			elseif(dialog.UpdateTimerDisplay) then
				-- Trigger update.
				dialog:UpdateTimerDisplay();
			end
		end);
	else
		-- Remove if not needed.
		dialog:SetScript("OnUpdate", nil);
	end
end

function PowaAuras:ExportDialogInit(self)
	-- Set parameters for StaticPopup.
	self.exclusive = 1;
	self.whileDead = 1;
	self.hideOnEscape = 1;
	self.timeout = 0;
	-- Status tracking, allows us to send and close/reopen the dialog with no lost progress. In theory.
	self.errorReason = 1;
	self.sendDisplay = "";
	self.sendStatus = 1;
	self.sendString = nil;
	self.sendTo = nil;
	self.sendType = nil;
	self.statusTimeout = 0;
	self.statusTimeoutLength = 0;
	-- Make certain elements easier to write to.
	self.AcceptButton = PowaAuraExportDialogSendButton;
	self.CancelButton = PowaAuraExportDialogCancelButton;
	self.Title = PowaAuraExportDialogSendTitle;
	self.EditBox = PowaAuraExportDialogSendBox;
	-- Localization.
	PowaAuraExportDialogTopTitle:SetText(PowaAuras.Text.ExportDialogTopTitle);
	PowaAuraExportDialogCopyTitle:SetText(PowaAuras.Text.ExportDialogCopyTitle);
	PowaAuraExportDialogMidTitle:SetText(PowaAuras.Text.ExportDialogMidTitle);
	PowaAuraExportDialogSendTitle:SetText(PowaAuras.Text.ExportDialogSendTitle1);
	PowaAuraExportDialogSendButton:SetText(PowaAuras.Text.ExportDialogSendButton1);
	PowaAuraExportDialogCancelButton:SetText(PowaAuras.Text.ExportDialogCancelButton);
	-- Add needed functions.
	-- Fired when the frame state needs updating.
	self.SetStatus = function(self, status)
		-- Can we send/receive data?
		if(not PowaAuras.Comms:IsRegistered()) then
			status = 6;
		end
		-- Change it.
		self.sendStatus = status or self.sendStatus or 1;
		-- Hide buttons, update labels and change values depending on status.
		if(self.sendStatus == 1) then
			-- Status 1 - not yet sent.
			self.Title:SetText(PowaAuras.Text.ExportDialogSendTitle1);
			self.AcceptButton:SetText(PowaAuras.Text.ExportDialogSendButton1);
			self.CancelButton:Enable();
			self.EditBox:Show();
			PowaAuras:SetDialogTimeout(self, 0);
		elseif(self.sendStatus >= 2) then
			-- Beats repeating code.
			self.AcceptButton:SetText(PowaAuras.Text.ExportDialogSendButton2);
			self.EditBox:Hide();
			self.AcceptButton:Disable();
			self.CancelButton:Disable();
			if(self.sendStatus == 2) then
				-- Status 2 - waiting for receiver.
				PowaAuras:SetDialogTimeout(self, 30);
				self.Title:SetText(format(PowaAuras.Text.ExportDialogSendTitle2, self.sendDisplay, (self.statusTimeout - time())));
			elseif(self.sendStatus == 3) then
				-- Status 3 - error (this can occur at any stage!).
				-- Determine the error string to display based on the passed code.
				local errstring = PowaAuras.Text.ExportDialogSendTitle3c; -- Defaults to timeout message.
				if(self.errorReason == 1) then
					errstring = PowaAuras.Text.ExportDialogSendTitle3a; -- In combat.
				elseif(self.errorReason == 2) then
					errstring = PowaAuras.Text.ExportDialogSendTitle3b; -- Autodeclining offers.
				elseif(self.errorReason == 4) then
					errstring = PowaAuras.Text.ExportDialogSendTitle3d; -- Busy with another request.
				elseif(self.errorReason == 5) then
					errstring = PowaAuras.Text.ExportDialogSendTitle3e; -- Declined offer.
				end
				-- Go forth.
				self.Title:SetText(format(errstring, self.sendDisplay));
				self.AcceptButton:Enable();
				self.CancelButton:Enable();
				PowaAuras:SetDialogTimeout(self, 0);
			elseif(self.sendStatus == 4) then
				-- Status 4 - send in progress.
				self.Title:SetText(PowaAuras.Text.ExportDialogSendTitle4);
				PowaAuras:SetDialogTimeout(self, 10);
			elseif(self.sendStatus == 5) then
				-- Status 5 - send complete.
				self.Title:SetText(PowaAuras.Text.ExportDialogSendTitle5);
				PowaAuras:SetDialogTimeout(self, 0);
				self.AcceptButton:Enable();
				self.CancelButton:Enable();
			elseif(self.sendStatus == 6) then
				-- Status 6 - Addon comms failure.
				-- Don't need this for the import dialog, as that only pops up if comms work in the first place.
				self.Title:SetText(PowaAuras.Text.aideCommsRegisterFailure);
				self.CancelButton:Enable();
				PowaAuras:SetDialogTimeout(self, 0);
			end
		end
	end
	-- Called when the timeout loop executes, used to tell the user how long is left before a timeout occurs.
	self.UpdateTimerDisplay = function(self)
		if(self.sendStatus == 2) then
			self.Title:SetText(format(PowaAuras.Text.ExportDialogSendTitle2, self.sendDisplay, (self.statusTimeout - time())));
		end
	end
	-- Fired when the frame is shown.
	self.OnShow = function(self)
		-- Update status.
		self:SetStatus();
		-- Store the aura string we want to transfer.
		self.sendString = PowaAuraExportDialogCopyBox:GetText();
		-- Usability.
		PowaAuraExportDialogCopyBox:HighlightText();
		PowaAuraExportDialogCopyBox:SetFocus();
	end
	-- Fired when the send button is clicked.
	self.OnAccept = function(self)
		-- Store the player name.
		self.sendTo = self.EditBox:GetText();
		-- We clear sendTo when requests fail, but we can't use format with nils. Check for name to print here.
		self.sendDisplay = self.sendTo;
		-- Change status to 2 or 1.
		if(self.sendStatus == 1) then
			self:SetStatus(2);
			-- Send message to the person.
			PowaComms:SendAddonMessage("EXPORT_REQUEST", self.sendType, self.sendTo);
		else
			self:SetStatus(1);
		end
	end
	-- Fired when the cancel button is clicked.
	self.OnCancel = function(self)
		-- Hide me.
		StaticPopupSpecial_Hide(self);
	end
	-- Handles rejection well.
	PowaComms:AddHandler("EXPORT_REJECT", function(null, data, from)
		-- Were we sending to this person?
		if(PowaAuraExportDialog.sendTo == from) then
			if(PowaMisc.Debug) then
				PowaAuras:ShowText("Comms: EXPORT_REJECT from " .. from);
			end
			PowaAuraExportDialog.sendTo = nil;
			PowaAuraExportDialog.errorReason = tonumber((data or 1), 10);
			PowaAuraExportDialog:SetStatus(3);
		end
	end);
	-- Is optimistic about this connection.
	PowaComms:AddHandler("EXPORT_ACCEPT", function(null, null, from)
		-- Were we sending to this person?
		if(PowaAuraExportDialog.sendTo == from) then
			if(PowaMisc.Debug) then
				PowaAuras:ShowText("Comms: EXPORT_ACCEPT from " .. from);
			end
			PowaAuraExportDialog:SetStatus(4);
			-- Let's get busy!
			PowaComms:SendAddonMessage("EXPORT_DATA", PowaAuraExportDialog.sendString, from);
			-- And we're done.
			PowaAuraExportDialog:SetStatus(5);
		end
	end);
end

-- Cross-Client Import Dialog
function PowaAuras:PlayerImportDialogInit(self)
	-- Set parameters for StaticPopup.
	self.exclusive = 1;
	self.whileDead = 1;
	self.hideOnEscape = 1;
	self.timeout = 0;
	-- Status tracking, allows us to send and close/reopen the dialog with no lost progress. In theory.
	self.errorReason = 1;
	self.receiveDisplay = "";
	self.receiveFrom = nil;
	self.receiveStatus = 1;
	self.receiveString = nil;
	self.receiveType = nil;
	self.statusTimeout = 0;
	self.statusTimeoutLength = 0;
	-- Make certain elements easier to write to.
	self.AcceptButton = PowaAuraPlayerImportDialogAcceptButton;
	self.CancelButton = PowaAuraPlayerImportDialogCancelButton;
	self.Title = PowaAuraPlayerImportDialogDescTitle;
	self.Warning = PowaAuraPlayerImportDialogWarningTitle;
	-- Localization.
	PowaAuraPlayerImportDialogTopTitle:SetText(PowaAuras.Text.PlayerImportDialogTopTitle);
	PowaAuraPlayerImportDialogDescTitle:SetText(PowaAuras.Text.PlayerImportDialogDescTitle1);
	PowaAuraPlayerImportDialogWarningTitle:SetText(PowaAuras.Text.PlayerImportDialogWarningTitle);
	PowaAuraPlayerImportDialogAcceptButton:SetText(PowaAuras.Text.PlayerImportDialogAcceptButton1);
	PowaAuraPlayerImportDialogCancelButton:SetText(PowaAuras.Text.PlayerImportDialogCancelButton1);
	-- Add needed functions.
	-- Fired when the frame state needs updating.
	self.SetStatus = function(self, status)
		-- Change it.
		self.receiveStatus = status or self.receiveStatus or 1;
		-- Hide buttons, update labels and change values depending on status.
		if(self.receiveStatus == 1) then
			-- Status 1 - not yet accepted.
			self.AcceptButton:Enable();
			self.CancelButton:Enable();
			self.CancelButton:SetText(PowaAuras.Text.PlayerImportDialogCancelButton1);
			self.AcceptButton:SetText(PowaAuras.Text.PlayerImportDialogAcceptButton1);
			self.Title:SetText(format(PowaAuras.Text.PlayerImportDialogDescTitle1, self.receiveDisplay));
			PowaAuras:SetDialogTimeout(self, 25); -- Timeout earlier due to latency and whatnot.
			self.Warning:Hide();
		elseif(self.receiveStatus >= 2) then
			-- Disable buttons unless told otherwise.
			self.AcceptButton:Disable();
			self.CancelButton:Disable();
			self.CancelButton:SetText(PowaAuras.Text.ExportDialogCancelButton);
			self.Warning:Hide();
			if(self.receiveStatus == 2) then
				-- Status 2 - receiving.
				self.Title:SetText(PowaAuras.Text.PlayerImportDialogDescTitle2);
				PowaAuras:SetDialogTimeout(self, 10);
			elseif(self.receiveStatus == 3) then
				-- Status 3 - error (timeout likely).
				self.Title:SetText(PowaAuras.Text.PlayerImportDialogDescTitle3);
				self.CancelButton:Enable();
				PowaAuras:SetDialogTimeout(self, 0);
			elseif(self.receiveStatus == 4) then
				-- Status 4 - waiting for save.
				self.Title:SetText(PowaAuras.Text.PlayerImportDialogDescTitle4);
				-- Warning message for aura sets.
				if(self.receiveType == 2) then
					self.Warning:Show();
				end
				self.AcceptButton:SetText(PowaAuras.Text.PlayerImportDialogAcceptButton2);
				PowaAuras:SetDialogTimeout(self, 0);
				self.AcceptButton:Enable();
				self.CancelButton:Enable();
				-- Show options frame.
				PowaOptionsFrame:Show();
			elseif(self.receiveStatus == 5) then
				-- Status 5 - send complete.
				self.Title:SetText(PowaAuras.Text.PlayerImportDialogDescTitle5);
				self.AcceptButton:SetText(PowaAuras.Text.PlayerImportDialogAcceptButton2);
				PowaAuras:SetDialogTimeout(self, 0);
				self.AcceptButton:Disable();
				self.CancelButton:Enable();
			elseif(self.receiveStatus == 6) then
				-- Status 6 - no aura slots.
				self.Title:SetText(PowaAuras.Text.PlayerImportDialogDescTitle6);
				self.AcceptButton:SetText(PowaAuras.Text.PlayerImportDialogAcceptButton2);
				self.CancelButton:SetText(PowaAuras.Text.ExportDialogSendButton2);
				PowaAuras:SetDialogTimeout(self, 0);
				self.AcceptButton:Disable();
				self.CancelButton:Enable();
			end
		end
	end
	-- Fired when the frame is shown.
	self.OnShow = function(self)
		-- Update status.
		self:SetStatus();
	end
	-- Fired when the frame is hidden.
	self.OnHide = function(self)
		-- Reject only if we're at status 1.
		if(self.receiveStatus == 1 and self.receiveFrom) then
			PowaComms:SendAddonMessage("EXPORT_REJECT", 5, self.receiveFrom);
		end
		-- Clear our receiveFrom/etc. vars here.
		self.receiveFrom = nil;
		self.receiveDisplay = "";
		self.receiveString = nil;
	end
	-- Fired when the accept button is clicked.
	self.OnAccept = function(self)
		-- Accept only if we're at status 1.
		if(self.receiveStatus == 1 and self.receiveFrom) then
			PowaComms:SendAddonMessage("EXPORT_ACCEPT", "", self.receiveFrom);
			-- Update status.
			self:SetStatus(2);
		elseif(self.receiveStatus == 4 and self.receiveFrom) then
			-- Save my auras!
			if(self.receiveType == 1) then
				-- Single aura. Determine a slot to put it in...
				local i = PowaAuras:GetNextFreeSlot();
				if (not i) then
					self:SetStatus(6);
					return;
				end
				-- Save it.
				PowaAuras:CreateNewAuraFromImport(i, PowaAuraPlayerImportDialog.receiveString);
				-- Update isn't called automatically on single auras.
				PowaAuras:UpdateMainOption();
			elseif(self.receiveType == 2) then
				-- Aura set.
				PowaAuras:CreateNewAuraSetFromImport(PowaAuraPlayerImportDialog.receiveString);
			end
			-- Update status.
			self:SetStatus(5);
		end
	end
	-- Fired when the cancel button is clicked.
	self.OnCancel = function(self)
		-- Don't hide me if the current page is full. Instead, allow me to pick another page to save to.
		if(self.receiveStatus == 6) then
			self:SetStatus(4);
			return;
		end
		-- Hide me.
		StaticPopupSpecial_Hide(self);
	end
	-- This bit mostly consists of handlers.
	PowaComms:AddHandler("EXPORT_REQUEST", function(null, data, from)
		-- If we're busy, reject. If we're in combat, reject. If we're autoblocking, reject.
		if(PowaAuraPlayerImportDialog.receiveFrom) then
			if(PowaMisc.Debug) then
				PowaAuras:ShowText("Comms: Rejected EXPORT_REQUEST - Busy.");
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 4, from);
			return;
		end
		if(InCombatLockdown()) then
			if(PowaMisc.Debug) then
				PowaAuras:ShowText("Comms: Rejected EXPORT_REQUEST - In combat.");
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 1, from);
			return;
		end
		if(PowaGlobalMisc.BlockIncomingAuras == true) then
			if(PowaMisc.Debug) then
				PowaAuras:ShowText("Comms: Rejected EXPORT_REQUEST - BlockIncomingAuras = true.");
			end
			PowaComms:SendAddonMessage("EXPORT_REJECT", 2, from);
			return;
		end
		PowaAuraPlayerImportDialog:SetPoint("CENTER");
		-- Set status to 1, store name.
		PowaAuraPlayerImportDialog:SetStatus(1);
		PowaAuraPlayerImportDialog.receiveFrom = from;
		PowaAuraPlayerImportDialog.receiveDisplay = from;
		PowaAuraPlayerImportDialog.receiveType = tonumber(data, 10);
		-- Show.
		StaticPopupSpecial_Show(PowaAuraPlayerImportDialog);
	end);
	PowaComms:AddHandler("EXPORT_DATA", function(null, data, from)
		-- Were we receiving from this person?
		if(PowaAuraPlayerImportDialog.receiveFrom == from) then
			if(PowaMisc.Debug) then PowaAuras:ShowText("Comms: Receiving EXPORT_DATA"); end
			-- Status code 4 - we are pro.
			PowaAuraPlayerImportDialog:SetStatus(4);
			-- Store the data.
			PowaAuraPlayerImportDialog.receiveString = data;
		end
	end);
end

function PowaAuras:DisableMoveMode()
	PowaOptionsMove:UnlockHighlight();
	PowaOptionsCopy:UnlockHighlight();
	self.MoveEffect = 0;
	for i = 1, 15 do
		getglobal("PowaOptionsList"..i.."Glow"):Hide();
	end
	-- reactive les boutons
	PowaOptionsMove:Enable();
	PowaOptionsCopy:Enable();
	PowaOptionsRename:Enable();
	PowaEditButton:Enable();
	PowaMainTestButton:Enable();
	PowaMainHideAllButton:Enable();
	PowaOptionsSelectorNew:Enable();
	PowaOptionsSelectorDelete:Enable();
end

function PowaAuras:OptionMoveEffect(isMove)
	if (self.Auras[self.CurrentAuraId] == nil or self.Auras[self.CurrentAuraId].buffname == "" or self.Auras[self.CurrentAuraId].buffname == " ") then
		return;
	end
	-- Set glow for lists
	if (self.MoveEffect == 0) then
		if (isMove) then
			self.MoveEffect = 2;
			PowaOptionsMove:LockHighlight();
			PowaOptionsCopy:Disable();
		else
			self.MoveEffect = 1;
			PowaOptionsCopy:LockHighlight();
			PowaOptionsMove:Disable();
		end
		for i = 1, 15 do
			getglobal("PowaOptionsList"..i.."Glow"):SetVertexColor(0.5, 0.5, 0.5);
			getglobal("PowaOptionsList"..i.."Glow"):Show();
		end
		-- annule tous les boutons
		PowaOptionsRename:Disable();
		PowaEditButton:Disable();
		PowaMainTestButton:Disable();
		PowaMainHideAllButton:Disable();
		PowaOptionsSelectorNew:Disable();
		PowaOptionsSelectorDelete:Disable();
	else
		self:DisableMoveMode();
	end
end

function PowaAuras:BeginMoveEffect(Pfrom, ToPage)
	local i = self:GetNextFreeSlot(ToPage);
	if (not i) then
		self:Message("All aura slots filled"); -- OK
		return;
	end
	self:DoCopyEffect(Pfrom, i, true); -- Copy and delete current aura
	self:TriageIcones(self.CurrentAuraPage); -- Sorts the list to avoid holes
	self:CalculateAuraSequence();
	self.CurrentAuraId = ((self.CurrentAuraPage - 1) * 24) + 1; -- This will be the first effect in the current list
	-- Disable move mode
	self:DisableMoveMode();
	-- Update the page
	self:UpdateMainOption();
end

function PowaAuras:BeginCopyEffect(Pfrom, ToPage)
	local i = self:GetNextFreeSlot(ToPage);
	if (not i) then
		self:Message("All aura slots filled"); -- OK
		return;
	end
	self:DoCopyEffect(Pfrom, i, false); -- Copy the current aura
	self.CurrentAuraId = i;
	-- Disable move mode
	self:DisableMoveMode();
	-- Update the page
	self:UpdateMainOption();
end

function PowaAuras:DoCopyEffect(idFrom, idTo, isMove)
	self.Auras[idTo] = self:AuraFactory(self.Auras[idFrom].bufftype, idTo, self.Auras[idFrom]);
	self.Auras[idTo]:Init();
	if (self.Auras[idFrom].Timer) then
		self.Auras[idTo].Timer = cPowaTimer(self.Auras[idTo], self.Auras[idFrom].Timer);
	end
	if (self.Auras[idFrom].Stacks) then
		self.Auras[idTo].Stacks = cPowaStacks(self.Auras[idTo], self.Auras[idFrom].Stacks);
	end
	if (idTo > 120) then
		PowaGlobalSet[idTo] = self.Auras[idTo];
	end
	if (isMove) then
		self:DeleteAura(self.Auras[idFrom]);
		self:TriageIcones(self.CurrentAuraPage);
	end
	self:CalculateAuraSequence();
	self:UpdateMainOption();
end

function PowaAuras:MainOptionShow()
	--self:ShowText("MainOptionShow");
	if (PowaOptionsFrame:IsVisible()) then
		self:MainOptionClose();
	else
		PowaAuras_InitalizeOnMenuOpen();
		self:OptionHideAll();
		self.ModTest = true;
		self:UpdateMainOption();
		PowaOptionsFrame:Show();
		PowaAuras:UpdateMainOption(true);
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel);
		if (PowaMisc.Disabled) then
			self:DisplayText("Power Auras "..self.Colors.Red..ADDON_DISABLED.."|r");
		end
	end
end

function PowaAuras:MainOptionClose()
	--self:ShowText("MainOptionClose");
	self:DisableMoveMode();
	self.ModTest = false;
	if ColorPickerFrame:IsVisible() then
		self.CancelColor();
		ColorPickerFrame:Hide();
	end
	FontSelectorFrame:Hide();
	PowaBarConfigFrame:Hide();
	PowaOptionsFrame:Hide();
	PlaySound("TalentScreenClose", PowaMisc.SoundChannel);
	PowaAuras:OptionHideAll();
	self:FindAllChildren();
	self:CreateEffectLists();
	self.DoCheck.All = true;
	self:NewCheckBuffs();
	self:MemorizeActions();
	self:ReregisterEvents(PowaAuras_Frame);
end

-- Main Options
function PowaAuras:UpdateTimerOptions()
	local aura = self.Auras[self.CurrentAuraId];
	if (not aura.Timer) then
		aura.Timer = cPowaTimer(aura);
	end
	local timer = aura.Timer;
	if (timer) then
		PowaShowTimerButton:SetChecked(timer.enabled);
		PowaTimerAlphaSlider:SetValue(timer.a);
		PowaTimerSizeSlider:SetValue(timer.h);
		-- Timer slider X
		PowaTimerCoordXSlider:SetMinMaxValues(timer.x - 10000, timer.x + 10000);
		PowaTimerCoordXSliderLow:SetText(timer.x - 700);
		PowaTimerCoordXSliderHigh:SetText(timer.x + 700);
		PowaTimerCoordXSlider:SetValue(timer.x);
		PowaTimerCoordXSlider:SetMinMaxValues(timer.x - 700, timer.x + 700);
		-- Timer slider Y
		PowaTimerCoordYSlider:SetMinMaxValues(timer.y - 10000, timer.y + 10000);
		PowaTimerCoordYSliderLow:SetText(timer.y - 400);
		PowaTimerCoordYSliderHigh:SetText(timer.y + 400);
		PowaTimerCoordYSlider:SetValue(timer.y);
		PowaTimerCoordYSlider:SetMinMaxValues(timer.y - 400, timer.y + 400);
		PowaBuffTimerCentsButton:SetChecked(timer.cents);
		PowaBuffTimerLeadingZerosButton:SetChecked(timer.HideLeadingZeros);
		PowaBuffTimerTransparentButton:SetChecked(timer.Transparent);
		if (aura:FullTimerAllowed()) then
			-- Show full timer options
			PowaBuffTimerUpdatePingButton:SetChecked(timer.UpdatePing);
			self:EnableCheckBox("PowaBuffTimerUpdatePingButton");
			PowaBuffTimerActivationTime:Enable();
		else
			-- Show cut-down timer options
			PowaBuffTimerUpdatePingButton:SetChecked(false);
			self:DisableCheckBox("PowaBuffTimerUpdatePingButton");
			timer.ShowActivation = true;
			PowaBuffTimerActivationTime:Disable();
		end
		PowaBuffTimerActivationTime:SetChecked(timer.ShowActivation);
		PowaBuffTimer99:SetChecked(timer.Seconds99);
		PowaBuffTimerUseOwnColorButton:SetChecked(timer.UseOwnColor);
		PowaTimerColorNormalTexture:SetVertexColor(timer.r,timer.g,timer.b);
		--UIDropDownMenu_SetSelectedValue(PowaBuffTimerRelative, timer.Relative);
		--UIDropDownMenu_SetSelectedValue(PowaDropDownTimerTexture, timer.Texture);
		PowaTimerInvertAuraSlider:SetValue(aura.InvertAuraBelow);
	end
end

function PowaAuras:UpdateStacksOptions()
	local stacks = self.Auras[self.CurrentAuraId].Stacks;
	if (stacks) then
		PowaShowStacksButton:SetChecked(stacks.enabled);
		PowaStacksAlphaSlider:SetValue(stacks.a);
		PowaStacksSizeSlider:SetValue(stacks.h);
		-- Stacks slider X
		PowaStacksCoordXSlider:SetMinMaxValues(stacks.x - 10000, stacks.x + 10000);
		PowaStacksCoordXSliderLow:SetText(stacks.x - 700);
		PowaStacksCoordXSliderHigh:SetText(stacks.x + 700);
		PowaStacksCoordXSlider:SetValue(stacks.x);
		PowaStacksCoordXSlider:SetMinMaxValues(stacks.x - 700, stacks.x + 700);
		-- Stacks slider Y
		PowaStacksCoordYSlider:SetMinMaxValues(stacks.y - 10000, stacks.y + 10000);
		PowaStacksCoordYSliderLow:SetText(stacks.y - 400);
		PowaStacksCoordYSliderHigh:SetText(stacks.y + 400);
		PowaStacksCoordYSlider:SetValue(stacks.y);
		PowaStacksCoordYSlider:SetMinMaxValues(stacks.y - 400, stacks.y + 400);
		PowaBuffStacksTransparentButton:SetChecked(stacks.Transparent);
		PowaBuffStacksUpdatePingButton:SetChecked(stacks.UpdatePing);
		PowaBuffStacksLegacySizing:SetChecked(stacks.LegacySizing);
		PowaBuffStacksUseOwnColorButton:SetChecked(stacks.UseOwnColor);
		PowaStacksColorNormalTexture:SetVertexColor(stacks.r,stacks.g,stacks.b);
		--UIDropDownMenu_SetSelectedValue(PowaBuffStacksRelative, stacks.Relative);
		--UIDropDownMenu_SetSelectedValue(PowaDropDownStacksTexture, stacks.Texture);
	end
end

function PowaAuras:SetOptionText(aura)
	--self:ShowText("bufftype=", aura.bufftype);
	--self:ShowText("typeText=", aura.OptionText.typeText);
	PowaDropDownBuffTypeText:SetText(aura.OptionText.typeText);
	if (aura.OptionText.buffNameTooltip) then
		PowaBarBuffName:Show();
		PowaBarBuffName.aide = aura.OptionText.buffNameTooltip;
	else
		self:DisableTextfield("PowaBarBuffName");
	end
	if (aura.OptionText.exactTooltip) then
		self:EnableCheckBox("PowaExactButton");
		PowaExactButton.aide = aura.OptionText.exactTooltip;
	else
		self:DisableCheckBox("PowaExactButton");
	end
	if (aura.OptionText.mineText) then
		self:EnableCheckBox("PowaMineButton");
		PowaMineButtonText:SetText(aura.OptionText.mineText);
		PowaMineButton.tooltipText = aura.OptionText.mineTooltip;
	else
		PowaMineButton:SetChecked(false);
		self:DisableCheckBox("PowaMineButton");
	end
	if (aura.OptionText.extraText) then
		self:ShowCheckBox("PowaExtraButton");
		PowaExtraButtonText:SetText(aura.OptionText.extraText);
		PowaExtraButton.tooltipText = aura.OptionText.extraTooltip;
	else
		PowaExtraButton:SetChecked(false);
		self:HideCheckBox("PowaExtraButton");
	end
	if (aura.OptionText.targetFriendText) then
		self:EnableCheckBox("PowaTargetFriendButton");
		PowaTargetFriendButtonText:SetText(aura.OptionText.targetFriendText);
		PowaTargetFriendButtonText:SetTextColor(0.2, 1.0, 0.2)
		PowaTargetFriendButton.tooltipText = aura.OptionText.targetFriendTooltip;
	else
		PowaTargetFriendButton:SetChecked(false);
		self:DisableCheckBox("PowaTargetFriendButton");
	end
end

function PowaAuras:ShowOptions(optionsToShow)
	for k, v in pairs(self.OptionHideables) do
		if (optionsToShow and optionsToShow[v]) then
			--self:ShowText(" Show:", v);
			getglobal(v):Show();
		else
			--self:ShowText(" Hide:", v);
			getglobal(v):Hide();
		end
	end
end

function PowaAuras:EnableCheckBoxes(checkBoxesToEnable)
	--self:ShowText("EnableCheckBoxes");
	for k, v in pairs(self.OptionCheckBoxes) do
		--self:ShowText(v, " checkBoxesToEnable=", checkBoxesToEnable[v]);
		if (checkBoxesToEnable and checkBoxesToEnable[v]) then
			--self:ShowText(v, " Colours=", self.SetColours[v]);
			self:EnableCheckBox(v, self.SetColours[v]);
		else
			getglobal(v):SetChecked(false);
			self:DisableCheckBox(v);
		end
	end
end

function PowaAuras:EnableTernary(ternariesToEnable)
	--self:ShowText("EnableTernary");
	for k, v in pairs(self.OptionTernary) do
		--self:ShowText(v, " ternariesToEnable=", ternariesToEnable[v]);
		if (not ternariesToEnable or not ternariesToEnable[v]) then
			--self:ShowText("Disable Ternary ",v);
			--self:Ternary_Set(getglobal(v));
			self:DisableTernary(getglobal(v));
		end
	end
end

function PowaAuras:SetupOptionsForAuraType(aura)
	--self:ShowText("aura=", aura);
	self:SetOptionText(aura);
	self:ShowOptions(aura.ShowOptions);
	self:EnableCheckBoxes(aura.CheckBoxes);
	self:EnableTernary(aura.Ternary);
	if (aura:ShowTimerDurationSlider()) then
		PowaTimerDurationSlider:Show();
	else
		PowaTimerDurationSlider:Hide();
	end
	if (aura.CanHaveInvertTime) then
		PowaTimerInvertAuraSlider:Show();
	else
		PowaTimerInvertAuraSlider:Hide();
	end
end

function PowaAuras:InitPage(aura)
	--self:ShowText("InitPage ", self.CurrentAuraId);
	if (aura == nil) then
		--self:ShowText("InitPage - Unknown aura resetting to: ", self.CurrentAuraId)
		aura = self.Auras[self.CurrentAuraId];
	end
	self:UpdateTimerOptions();
	UIDropDownMenu_SetSelectedName(PowaStrataDropDown, aura.strata);
	UIDropDownMenu_SetSelectedName(PowaTextureStrataDropDown, aura.texturestrata);
	UIDropDownMenu_SetSelectedName(PowaBlendModeDropDown, aura.blendmode);
	UIDropDownMenu_SetSelectedName(PowaGradientStyleDropDown, aura.gradientstyle);
	PowaFrameStrataLevelSlider:SetValue(aura.stratalevel);
	PowaTextureStrataSublevelSlider:SetValue(aura.texturesublevel);
	PowaStrataDropDownText:SetText(aura.strata)
	PowaTextureStrataDropDownText:SetText(aura.texturestrata)
	PowaBlendModeDropDownText:SetText(aura.blendmode)
	PowaGradientStyleDropDownText:SetText(aura.gradientstyle)
	PowaDropDownAnim1Text:SetText(self.Anim[aura.anim1]);
	PowaDropDownAnim2Text:SetText(self.Anim[aura.anim2]);
	PowaDropDownAnimBeginText:SetText(self.BeginAnimDisplay[aura.begin]);
	PowaDropDownAnimEndText:SetText(self.EndAnimDisplay[aura.finish]);
	if (aura.sound < 30) then
		PowaDropDownSoundText:SetText(self.Sound[aura.sound]);
		PowaDropDownSound2Text:SetText(self.Sound[30]);
	else
		PowaDropDownSoundText:SetText(self.Sound[0]);
		PowaDropDownSound2Text:SetText(self.Sound[aura.sound]);
	end
	if (aura.soundend < 30) then
		PowaDropDownSoundEndText:SetText(self.Sound[aura.soundend]);
		PowaDropDownSound2EndText:SetText(self.Sound[30]);
	else
		PowaDropDownSoundEndText:SetText(self.Sound[0]);
		PowaDropDownSound2EndText:SetText(self.Sound[aura.soundend]);
	end
	PowaBarCustomSound.aide = self.Text.aideCustomSound;
	PowaBarCustomSoundEnd.aide = self.Text.aideCustomSoundEnd;
	PowaDropDownStanceText:SetText(self.PowaStance[aura.stance]);
	PowaDropDownGTFOText:SetText(self.PowaGTFO[aura.GTFO]);
	PowaBarBuffStacks.aide = self.Text.aideStacks;
	PowaOwntexButton:SetChecked(aura.owntex);
	PowaRoundIconsButton:SetChecked(aura.roundicons);
	PowaWowTextureButton:SetChecked(aura.wowtex);
	PowaCustomTextureButton:SetChecked(aura.customtex);
	PowaTextAuraButton:SetChecked(aura.textaura);
	PowaRandomColorButton:SetChecked(aura.randomcolor);
	PowaShowSpinAtBeginning:SetChecked(aura.beginSpin);
	PowaOldAnimation:SetChecked(aura.UseOldAnimations);
	PowaIngoreCaseButton:SetChecked(aura.ignoremaj);
	PowaInverseButton:SetChecked(aura.inverse);
	PowaTargetButton:SetChecked(aura.target);
	PowaTargetFriendButton:SetChecked(aura.targetfriend);
	PowaPartyButton:SetChecked(aura.party);
	PowaFocusButton:SetChecked(aura.focus);
	PowaRaidButton:SetChecked(aura.raid);
	PowaGroupOrSelfButton:SetChecked(aura.groupOrSelf);
	PowaGroupAnyButton:SetChecked(aura.groupany);
	PowaOptunitnButton:SetChecked(aura.optunitn);
	PowaExactButton:SetChecked(aura.exact);
	PowaMineButton:SetChecked(aura.mine);
	PowaThresholdInvertButton:SetChecked(aura.thresholdinvert);
	PowaExtraButton:SetChecked(aura.Extra);
	PowaEnableFullRotationButton:SetChecked(aura.enablefullrotation);
	-- Ternary Logic
	self:TernarySetState(PowaInCombatButton, aura.combat);
	self:TernarySetState(PowaIsInRaidButton, aura.inRaid);
	self:TernarySetState(PowaIsInPartyButton, aura.inParty);
	self:TernarySetState(PowaRestingButton, aura.isResting);
	self:TernarySetState(PowaIsMountedButton, aura.ismounted);
	self:TernarySetState(PowaInVehicleButton, aura.inVehicle);
	self:TernarySetState(PowaIsAliveButton, aura.isAlive);
	self:TernarySetState(PowaPvPButton, aura.PvP);
	self:TernarySetState(Powa5ManInstanceButton, aura.Instance5Man);
	self:TernarySetState(Powa5ManHeroicInstanceButton, aura.Instance5ManHeroic);
	self:TernarySetState(Powa10ManInstanceButton, aura.Instance10Man);
	self:TernarySetState(Powa10ManHeroicInstanceButton, aura.Instance10ManHeroic);
	self:TernarySetState(Powa25ManInstanceButton, aura.Instance25Man);
	self:TernarySetState(Powa25ManHeroicInstanceButton, aura.Instance25ManHeroic);
	self:TernarySetState(PowaRoleTankButton, aura.RoleTank);
	self:TernarySetState(PowaRoleHealerButton, aura.RoleHealer);
	self:TernarySetState(PowaRoleMeleDpsButton, aura.RoleMeleDps);
	self:TernarySetState(PowaRoleRangeDpsButton, aura.RoleRangeDps);
	self:TernarySetState(PowaBgInstanceButton, aura.InstanceBg);
	self:TernarySetState(PowaArenaInstanceButton, aura.InstanceArena);
	PowaTimerDurationSlider:SetValue(aura.timerduration);
	self:SetThresholdSlider(aura);
	-- Dual specs
	self:EnableCheckBox("PowaTalentGroup1Button");
	self:EnableCheckBox("PowaTalentGroup2Button");
	PowaTalentGroup1Button:SetChecked(aura.spec1);
	PowaTalentGroup2Button:SetChecked(aura.spec2);
	self:EnableCheckBox("PowaAuraDebugButton");
	PowaAuraDebugButton:SetChecked(aura.Debug);
	aura:HideShowTabs();
	self:SetupOptionsForAuraType(aura);
	-- Page changes
	if (PowaBarConfigFrameEditor4:IsVisible() and not PowaEditorTab4:IsVisible()) then
		PanelTemplates_SelectTab(PowaEditorTab1);
		PanelTemplates_DeselectTab(PowaEditorTab2);
		PanelTemplates_DeselectTab(PowaEditorTab4);
		PowaBarConfigFrameEditor1:Show();
		PowaBarConfigFrameEditor2:Hide();
		PowaBarConfigFrameEditor4:Hide();
	end
	-- Auras visuals
	PowaBarAuraAlphaSlider:SetValue(aura.alpha);
	PowaBarAuraAlphaSliderText:SetText(self.Text.nomAlpha..": "..format("%.0f", aura.alpha * 100).."%");
	PowaBarAuraRotateSlider:SetValue(aura.rotate);
	if (aura.enablefullrotation == true) then
		PowaBarAuraRotateSlider:SetValueStep(1)
	else
		PowaBarAuraRotateSlider:SetValueStep(90)
	end
	PowaBarAuraSizeSlider:SetValue(aura.size);
	-- Texture Position Slider X
	PowaBarAuraCoordXSlider:SetMinMaxValues(aura.x - 10000, aura.x + 10000);
	PowaBarAuraCoordXSliderLow:SetText(aura.x - 700);
	PowaBarAuraCoordXSliderHigh:SetText(aura.x + 700);
	PowaBarAuraCoordXSlider:SetValue(aura.x);
	PowaBarAuraCoordXSlider:SetMinMaxValues(aura.x - 700, aura.x + 700);
	PowaBarAuraCoordXEdit:SetText(aura.x);
	-- Texture Position Slider Y
	PowaBarAuraCoordYSlider:SetMinMaxValues(aura.y - 10000, aura.y + 10000);
	PowaBarAuraCoordYSliderLow:SetText(aura.y - 400);
	PowaBarAuraCoordYSliderHigh:SetText(aura.y + 400);
	PowaBarAuraCoordYSlider:SetValue(aura.y);
	PowaBarAuraCoordYSlider:SetMinMaxValues(aura.y - 400, aura.y + 400);
	PowaBarAuraCoordYEdit:SetText(aura.y);
	PowaBarAuraAnimSpeedSlider:SetValue(aura.speed);
	PowaBarAuraDurationSlider:SetValue(aura.duration);
	PowaBarAuraDurationSlider:SetMinMaxValues(aura.minDuration or 0, 60);
	if (not aura.minDuration or aura.minDuration == 0) then
		PowaBarAuraDurationSliderLow:SetText("0 sec");
	else
		PowaBarAuraDurationSliderLow:SetText(aura.minDuration);
	end
	PowaBarAuraSymSlider:SetValue(aura.symetrie);
	PowaBarAuraDeformSlider:SetValue(aura.torsion);
	PowaBarBuffName:SetText(aura.buffname);
	PowaBarMultiID:SetText(aura.multiids);
	PowaBarTooltipCheck:SetText(aura.tooltipCheck);
	PowaBarCustomSound:SetText(aura.customsound);
	PowaAuras:CustomSoundTextChanged(true);
	PowaBarCustomSoundEnd:SetText(aura.customsoundend);
	PowaAuras:CustomSoundEndTextChanged(true);
	PowaBarUnitn:SetText(aura.unitn);
	PowaBarBuffStacks:SetText(aura:StacksText());
	PowaAuras:UpdateStacksOptions();
	PowaAuras:UpdateTimerOptions();
	if (aura.optunitn == true) then
		self:EnableTextfield("PowaBarUnitn");
	elseif (aura.optunitn == false) then
		self:DisableTextfield("PowaBarUnitn");
	end
	if (aura.icon == nil or aura.icon == "") then
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark");
	else
		PowaIconTexture:SetTexture(aura.icon);
	end
	local checkTexture = 0;
	if (aura.owntex) then
		--self:ShowText("owntex tex=", aura.icon);
		checkTexture = AuraTexture:SetTexture(PowaIconTexture:GetTexture());
		--PowaBarAuraTextureSlider:Hide();
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
	elseif (aura.wowtex) then
		PowaBarAuraTextureSlider:Show();
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
		if (#self.WowTextures > self.MaxTextures) then
			PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures);
			PowaBarAuraTextureSlider:SetValue(aura.texture);
		else
			PowaBarAuraTextureSlider:SetValue(aura.texture);
			PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures);
		end
		PowaBarAuraTextureSliderHigh:SetText(#self.WowTextures);
		checkTexture = AuraTexture:SetTexture(self.WowTextures[aura.texture]);
	elseif (aura.customtex) then
		PowaBarAuraTextureSlider:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
		PowaBarCustomTexName:Show();
		PowaBarCustomTexName:SetText(aura.customname);
		checkTexture = AuraTexture:SetTexture(self:CustomTexPath(aura.customname));
	elseif (aura.textaura) then
		PowaBarAuraTextureSlider:Hide();
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Show();
		PowaFontButton:Show();
		--self:ShowText("InitPage: set aurastext to ", aura.aurastext);
		PowaBarAurasText:SetText(aura.aurastext);
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\INV_Scroll_02");
	else
		PowaBarAuraTextureSlider:Show();
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
		if (#self.WowTextures < self.MaxTextures) then
			PowaBarAuraTextureSlider:SetMinMaxValues(1,self.MaxTextures);
			PowaBarAuraTextureSlider:SetValue(aura.texture);
		else
			PowaBarAuraTextureSlider:SetValue(aura.texture);
			PowaBarAuraTextureSlider:SetMinMaxValues(1,self.MaxTextures);
		end
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures);
		checkTexture = AuraTexture:SetTexture("Interface\\Addons\\PowerAuras\\Auras\\Aura"..aura.texture..".tga");
	end
	--self:ShowText("checkTexture=", checkTexture);
	if (checkTexture ~= 1) then
		AuraTexture:SetTexture("Interface\\CharacterFrame\\TempPortrait.tga");
	end
	if (aura.gradientstyle == "Horizontal") or (aura.gradientstyle == "Vertical") then
		AuraTexture:SetGradientAlpha(aura.gradientstyle, aura.r, aura.g, aura.b, 1.0, aura.gr, aura.gg, aura.gb, 1.0)
	else
		AuraTexture:SetVertexColor(aura.r, aura.g, aura.b);
	end
	if (AuraTexture:GetTexture() == "Interface\\CharacterFrame\\TempPortrait") or (AuraTexture:GetTexture() == "Interface\\Icons\\INV_Scroll_02") then
		AuraTexture:SetVertexColor(1, 1, 1);
	end
	PowaColorNormalTexture:SetVertexColor(aura.r, aura.g, aura.b);
	PowaGradientColorNormalTexture:SetVertexColor(aura.gr, aura.gg, aura.gb);
	--[[if (aura.symetrie == 1) then
		AuraTexture:SetTexCoord(1, 0, 0, 1); -- inverse X
	elseif (aura.symetrie == 2) then
		AuraTexture:SetTexCoord(0, 1, 1, 0); -- inverse Y
	elseif (aura.symetrie == 3) then
		AuraTexture:SetTexCoord(1, 0, 1, 0); -- inverse XY
	else
		AuraTexture:SetTexCoord(0, 1, 0, 1);
	end]]--
	--AuraTexture:SetRotation(math.rad(aura.rotate));
	PowaColor_SwatchBg.r = aura.r;
	PowaColor_SwatchBg.g = aura.g;
	PowaColor_SwatchBg.b = aura.b;
	PowaGradientColor_SwatchBg.r = aura.gr;
	PowaGradientColor_SwatchBg.g = aura.gg;
	PowaGradientColor_SwatchBg.b = aura.gb;
	PowaHeader:SetText(self.Text.nomEffectEditor.." ("..aura.id..")");
end

function PowaAuras:SetThresholdSlider(aura)
	if (not aura.MaxRange) then return; end
	--PowaAuras:ShowText("======SetThresholdSlider=========");
	--PowaAuras:ShowText("Threshold=", aura.threshold);
	--PowaAuras:ShowText("PowerType=", aura.PowerType);
	--PowaAuras:ShowText("MaxRange=", aura.MaxRange," rangeType=",aura.RangeType);
	local curThreshold = aura.threshold;
	PowaBarThresholdSlider:SetMinMaxValues(0,aura.MaxRange);
	PowaBarThresholdSlider:SetValue(curThreshold);
	PowaBarThresholdSliderLow:SetText("0"..aura.RangeType);
	PowaBarThresholdSliderHigh:SetText(aura.MaxRange..aura.RangeType);
end

-- Sliders Changed
function PowaAuras:BarAuraTextureSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraTextureSlider:GetValue();
	if (SliderValue == 0) or (SliderValue == nil) then
		SliderValue = 1;
		PowaBarAuraTextureSlider:SetValue(SliderValue);
	end
	local checkTexture = 0;
	local auraId = self.CurrentAuraId;
	if (self.Auras[auraId].owntex == true) then
		checkTexture = AuraTexture:SetTexture(self.Auras[auraId].icon);
	elseif (self.Auras[auraId].wowtex == true) then
		checkTexture = AuraTexture:SetTexture(self.WowTextures[SliderValue]);
	elseif (self.Auras[auraId].customtex == true) then
		checkTexture = AuraTexture:SetTexture(self:CustomTexPath(self.Auras[auraId].customname));
	elseif (self.Auras[auraId].textaura == true) then
		checkTexture = AuraTexture:SetTexture("Interface\\Icons\\INV_Scroll_02");
	else
		checkTexture = AuraTexture:SetTexture("Interface\\Addons\\PowerAuras\\Auras\\Aura"..SliderValue..".tga");
	end
	if (checkTexture ~= 1) then
		AuraTexture:SetTexture("Interface\\CharacterFrame\\TempPortrait.tga");
	end
	PowaBarAuraTextureSliderText:SetText(self.Text.nomTexture..": "..SliderValue);
	local aura = self.Auras[self.CurrentAuraId];
	if (self.Auras[auraId].textaura == true) or AuraTexture:GetTexture() == "Interface\\CharacterFrame\\TempPortrait" then
		AuraTexture:SetVertexColor(1, 1, 1);
	else
		if (aura.gradientstyle == "Horizontal") or (aura.gradientstyle == "Vertical") then
			AuraTexture:SetGradientAlpha(aura.gradientstyle, self.Auras[auraId].r, self.Auras[auraId].g, self.Auras[auraId].b, 1.0, self.Auras[auraId].gr, self.Auras[auraId].gg, self.Auras[auraId].gb, 1.0)
		else
			AuraTexture:SetVertexColor(self.Auras[auraId].r, self.Auras[auraId].g, self.Auras[auraId].b);
		end
	end
	self.Auras[auraId].texture = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:FrameStrataLevelSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaFrameStrataLevelSlider:GetValue();
	PowaFrameStrataLevelSliderText:SetText("Level: "..format("%.0f", SliderValue));
	self.Auras[self.CurrentAuraId].stratalevel = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:TextureStrataSublevelSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaTextureStrataSublevelSlider:GetValue();
	PowaTextureStrataSublevelSliderText:SetText("Sublevel: "..format("%.0f", SliderValue));
	self.Auras[self.CurrentAuraId].texturesublevel = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraAlphaSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraAlphaSlider:GetValue();
	PowaBarAuraAlphaSliderText:SetText(self.Text.nomAlpha..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].alpha = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraSizeSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local aura = self.Auras[self.CurrentAuraId];
	local SliderValue = PowaBarAuraSizeSlider:GetValue();
	PowaBarAuraSizeSliderText:SetText(self.Text.nomTaille..": "..format("%.0f", SliderValue * 100).."%");
	if (aura.textaura == true) then
		if (SliderValue < 1.61) then
			self.Auras[self.CurrentAuraId].size = SliderValue;
		end
	else
		self.Auras[self.CurrentAuraId].size = SliderValue;
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraCoordXSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraCoordXSlider:GetValue();
	PowaBarAuraCoordXSliderText:SetText(self.Text.nomPos.." X: "..SliderValue);
	if (PowaBarAuraCoordXEdit) then
		PowaBarAuraCoordXEdit:SetText(SliderValue);
	end
	self.Auras[self.CurrentAuraId].x = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraCoordYSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraCoordYSlider:GetValue();
	PowaBarAuraCoordYSliderText:SetText(self.Text.nomPos.." Y: "..SliderValue);
	if (PowaBarAuraCoordYEdit) then
		PowaBarAuraCoordYEdit:SetText(SliderValue);
	end
	self.Auras[self.CurrentAuraId].y = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraAnimSpeedSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraAnimSpeedSlider:GetValue();
	PowaBarAuraAnimSpeedSliderText:SetText(self.Text.nomSpeed..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].speed = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraAnimDurationSliderChanged(control)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = control:GetValue();
	getglobal(control:GetName().."Text"):SetText(self.Text.nomDuration..": "..format("%.2f", SliderValue).." sec");
	--self:ShowText("Duration set to ", SliderValue);
	self.Auras[self.CurrentAuraId].duration = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraSymSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraSymSlider:GetValue();
	if (SliderValue == 0) then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": "..self.Text.aucune);
		--AuraTexture:SetTexCoord(0, 1, 0, 1);
	elseif (SliderValue == 1) then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": X");
		--AuraTexture:SetTexCoord(1, 0, 0, 1);
	elseif (SliderValue == 2) then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": Y");
		--AuraTexture:SetTexCoord(0, 1, 1, 0);
	elseif (SliderValue == 3) then
		PowaBarAuraSymSliderText:SetText(self.Text.nomSymetrie..": XY");
		--AuraTexture:SetTexCoord(1, 0, 1, 0);
	end
	self.Auras[self.CurrentAuraId].symetrie = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraRotateSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraRotateSlider:GetValue();
	PowaBarAuraRotateSliderText:SetText(PowaAuras.Text.nomRotation..": "..SliderValue.."°");
	--[[if self.Auras[self.CurrentAuraId].textaura ~= true then
		AuraTexture:SetPoint("CENTER");
		AuraTexture:SetRotation(math.rad(SliderValue));
	end]]--
	self.Auras[self.CurrentAuraId].rotate = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarAuraDeformSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaBarAuraDeformSlider:GetValue();
	PowaBarAuraDeformSliderText:SetText(self.Text.nomDeform..": "..format("%.3f", SliderValue));
	self.Auras[self.CurrentAuraId].torsion = SliderValue;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:BarThresholdSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	--PowaAuras:ShowText("======BarThresholdSliderChanged======");
	local SliderValue = PowaBarThresholdSlider:GetValue();
	--PowaAuras:ShowText("SliderValue=", SliderValue);
	local aura = self.Auras[self.CurrentAuraId];
	--PowaAuras:ShowText("Old Threshold=", aura.threshold);
	--PowaAuras:ShowText("MaxRange=", aura.MaxRange..aura.RangeType);
	PowaBarThresholdSliderText:SetText(self.Text.nomThreshold..": "..SliderValue..aura.RangeType);
	aura.threshold = SliderValue;
	--PowaAuras:ShowText("New Threshold=", aura.threshold);
end

-- Text Changed
function PowaAuras:TextCoordXChanged()
	local thisText = PowaBarAuraCoordXEdit:GetText();
	local thisNumber = tonumber(thisText);
	local auraId = self.CurrentAuraId;
	if (thisNumber == nil) then
		PowaBarAuraCoordXSliderText:SetText(self.Text.nomPos.." X: "..0);
		PowaBarAuraCoordXSlider:SetValue(0);
		PowaBarAuraCoordXEdit:SetText(0);
		self.Auras[auraId].x = 0;
	else
		PowaBarAuraCoordXSliderText:SetText(self.Text.nomPos.." X: "..thisNumber);
		PowaBarAuraCoordXSlider:SetValue(thisNumber);
		self.Auras[auraId].x = thisNumber;
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:TextCoordYChanged()
	local thisText = PowaBarAuraCoordYEdit:GetText();
	local thisNumber = tonumber(thisText);
	local auraId = self.CurrentAuraId;
	if (thisNumber == nil) then
		PowaBarAuraCoordYSliderText:SetText(self.Text.nomPos.." Y: "..0);
		PowaBarAuraCoordYSlider:SetValue(0);
		PowaBarAuraCoordYEdit:SetText(0);
		self.Auras[auraId].y = 0;
	else
		PowaBarAuraCoordYSliderText:SetText(self.Text.nomPos.." Y: "..thisNumber);
		PowaBarAuraCoordYSlider:SetValue(thisNumber);
		self.Auras[auraId].y = thisNumber;
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:TextChanged()
	local oldText = PowaBarBuffName:GetText();
	local auraId = self.CurrentAuraId;
	if (oldText ~= self.Auras[auraId].buffname) then
		self.Auras[auraId].buffname = PowaBarBuffName:GetText();
		self.Auras[auraId].icon = "";
		PowaIconTexture:SetTexture("Interface\\Icons\\Inv_Misc_QuestionMark");
	end
end

function PowaAuras:MultiIDChanged()
	local oldText = PowaBarMultiID:GetText();
	local auraId = self.CurrentAuraId;
	if (oldText ~= self.Auras[auraId].multiids) then
		self.Auras[auraId].multiids = PowaBarMultiID:GetText();
		self:FindAllChildren();
	end
end

function PowaAuras:TooltipCheckChanged()
	local oldText = PowaBarTooltipCheck:GetText();
	local auraId = self.CurrentAuraId;
	if (oldText ~= self.Auras[auraId].tooltipCheck) then
		self.Auras[auraId].tooltipCheck = PowaBarTooltipCheck:GetText();
	end
end

function PowaAuras:StacksTextChanged()
	local aura = self.Auras[self.CurrentAuraId];
	aura:SetStacks(PowaBarBuffStacks:GetText());
end

function PowaAuras:UnitnTextChanged()
	local oldUnitnText = PowaBarUnitn:GetText();
	local auraId = self.CurrentAuraId;
	if (oldUnitnText ~= self.Auras[auraId].unitn) then
		self.Auras[auraId].unitn = PowaBarUnitn:GetText();
	end
end

function PowaAuras:CustomTextChanged()
	local aura = self.Auras[self.CurrentAuraId];
	aura.customname = PowaBarCustomTexName:GetText();
	if string.find(aura.customname, "%.") or (aura.customname == nil) or (aura.customname == "") then
		aura.enablefullrotation = true;
	else
		aura.enablefullrotation = false;
		if (aura.rotate ~= 0) and (aura.rotate ~= 90) and (aura.rotate ~= 180) and (aura.rotate ~= 270) and (aura.rotate ~= 360) then
			PowaBarAuraRotateSlider:SetValue(0)
		end
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:AurasTextChanged()
	local aura = self.Auras[self.CurrentAuraId];
	aura.aurastext = PowaBarAurasText:GetText();
	--self:ShowText("AurasTextChanged: aura text changed to ", aura.aurastext);
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:CustomSoundTextChanged(force)
	local oldCustomSound = PowaBarCustomSound:GetText();
	local aura = self.Auras[self.CurrentAuraId];
	if (oldCustomSound ~= aura.customsound or force) then -- Custom sound changed
		aura.customsound = oldCustomSound;
		if (aura.customsound ~= "") then
			aura.sound = 0;
			PowaDropDownSoundText:SetText(self.Sound[0]);
			PowaDropDownSound2Text:SetText(self.Sound[30]);
			PowaDropDownSoundButton:Disable();
			PowaDropDownSound2Button:Disable();
			local pathToSound;
			if (string.find(aura.customsound, "\\")) then
				pathToSound = aura.customsound;
			else
				pathToSound = PowaGlobalMisc.PathToSounds..aura.customsound;
			end
			--self:ShowText("Playing sound "..pathToSound);
			local played = PlaySoundFile(pathToSound, PowaMisc.SoundChannel);
			--self:ShowText("played = "..played);
			if (not played) then
				--self:DisplayText("Failed to play sound "..pathToSound);
			end
		else
			PowaDropDownSoundButton:Enable();
			PowaDropDownSound2Button:Enable();
		end
	end
end

function PowaAuras:CustomSoundEndTextChanged(force)
	local oldCustomSound = PowaBarCustomSoundEnd:GetText();
	local aura = self.Auras[self.CurrentAuraId];
	if (oldCustomSound ~= aura.customsoundend or force) then -- custom sound changed
		aura.customsoundend = oldCustomSound;
		if (aura.customsoundend ~= "") then
			aura.soundend = 0;
			PowaDropDownSoundEndText:SetText(self.Sound[0]);
			PowaDropDownSound2EndText:SetText(self.Sound[30]);
			PowaDropDownSoundEndButton:Disable();
			PowaDropDownSound2EndButton:Disable();
			local pathToSound;
			if (string.find(aura.customsoundend, "\\")) then
				pathToSound = aura.customsoundend;
			else
				pathToSound = PowaGlobalMisc.PathToSounds..aura.customsoundend;
				--self:ShowText("Playing sound "..pathToSound);
			end
			--self:ShowText("Playing sound "..pathToSound);
			local played = PlaySoundFile(pathToSound, PowaMisc.SoundChannel);
			--self:ShowText("played = "..played);
			if (not played) then
				--self:DisplayText("Failed to play sound "..pathToSound);
			end
		else
			PowaDropDownSoundEndButton:Enable();
			PowaDropDownSound2EndButton:Enable();
		end
	end
end

-- Checkboxes Changed
function PowaAuras:InverseChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaInverseButton:GetChecked()) then
		aura.inverse = true;
	else
		aura.inverse = false;
	end
	aura:HideShowTabs();
end

function PowaAuras:IgnoreMajChecked()
	local auraId = self.CurrentAuraId;
	if (PowaIngoreCaseButton:GetChecked()) then
		self.Auras[auraId].ignoremaj = true;
	else
		self.Auras[auraId].ignoremaj = false;
	end
end

function PowaAuras:ExactChecked()
	local auraId = self.CurrentAuraId;
	if (PowaExactButton:GetChecked()) then
		self.Auras[auraId].exact = true;
	else
		self.Auras[auraId].exact = false;
	end
end

function PowaAuras:CheckedButtonOnClick(button, key)
	self.Auras[self.CurrentAuraId][key] = (button:GetChecked() ~= nil);
end

function PowaAuras:RandomColorChecked()
	local aura = self.Auras[self.CurrentAuraId];
	local auraId = self.CurrentAuraId;
	if (PowaRandomColorButton:GetChecked()) then
		self.Auras[auraId].randomcolor = true;
	else
		self.Auras[auraId].randomcolor = false;
	end
	self:RedisplayAura(aura.id);
end

function PowaAuras:ThresholdInvertChecked(owner)
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaThresholdInvertButton:GetChecked()) then
		aura.thresholdinvert = true;
	else
		aura.thresholdinvert = false;
	end
end

function PowaAuras:OwntexChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaOwntexButton:GetChecked()) then
		aura.owntex = true;
		aura.wowtex = false;
		aura.customtex = false;
		aura.textaura = false;
		aura.enablefullrotation = false;
		PowaWowTextureButton:SetChecked(false);
		PowaCustomTextureButton:SetChecked(false);
		PowaTextAuraButton:SetChecked(false);
		if (aura.rotate ~= 0) and (aura.rotate ~= 90) and (aura.rotate ~= 180) and (aura.rotate ~= 270) and (aura.rotate ~= 360) then
			PowaBarAuraRotateSlider:SetValue(0)
		end
		if (not PowaBarAuraTextureSlider:IsVisible()) then
			PowaBarAuraTextureSlider:Show();
		end
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
	else
		aura.owntex = false;
	end
	PowaAuras:InitPage(aura);
	self:RedisplayAura(aura.id);
end

function PowaAuras:WowTexturesChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaWowTextureButton:GetChecked()) then
		aura.wowtex = true;
		aura.owntex = false;
		aura.customtex = false;
		aura.textaura = false;
		if (PowaBarAuraTextureSlider:GetValue() > #self.WowTextures) then
			PowaBarAuraTextureSlider:SetValue(1);
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, #self.WowTextures);
		PowaBarAuraTextureSliderHigh:SetText(#self.WowTextures);
		PowaOwntexButton:SetChecked(false);
		PowaCustomTextureButton:SetChecked(false);
		PowaTextAuraButton:SetChecked(false);
		PowaBarAuraTextureSlider:Show();
		PowaBarCustomTexName:Hide();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
	else
		aura.wowtex = false;
		if (PowaBarAuraTextureSlider:GetValue() > self.MaxTextures) then
			PowaBarAuraTextureSlider:SetValue(1);
		end
		PowaBarAuraTextureSlider:SetMinMaxValues(1, self.MaxTextures);
		PowaBarAuraTextureSliderHigh:SetText(self.MaxTextures);
	end
	PowaAuras:BarAuraSizeSliderChanged();
	PowaAuras:BarAuraTextureSliderChanged();
	self:RedisplayAura(aura.id);
end

function PowaAuras:CustomTexturesChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaCustomTextureButton:GetChecked()) then
		aura.customtex = true;
		aura.owntex = false;
		aura.wowtex = false;
		aura.textaura = false;
		PowaBarAuraTextureSlider:Hide();
		PowaBarCustomTexName:Show();
		PowaBarCustomTexName:SetText(self.Auras[aura.id].customname);
		PowaOwntexButton:SetChecked(false);
		PowaWowTextureButton:SetChecked(false);
		PowaTextAuraButton:SetChecked(false);
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
	else
		aura.customtex = false;
		PowaBarAuraTextureSlider:Show();
		PowaBarCustomTexName:Hide();
	end
	PowaAuras:BarAuraSizeSliderChanged();
	PowaAuras:BarAuraTextureSliderChanged();
	self:RedisplayAura(aura.id);
end

function PowaAuras:TextAuraChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaTextAuraButton:GetChecked()) then
		--self:ShowText("TextAuraChecked: set");
		aura.textaura = true;
		aura.owntex = false;
		aura.wowtex = false;
		aura.customtex = false;
		PowaBarAuraTextureSlider:Hide();
		PowaBarAurasText:Show();
		PowaFontButton:Show();
		--self:ShowText("TextAuraChecked: aura text changed to ", aura.aurastext);
		PowaBarAurasText:SetText(aura.aurastext);
		PowaBarAurasText:SetText(aura.aurastext.."!");
		PowaAuras:AurasTextChanged()
		PowaBarAurasText:SetText(string.sub(aura.aurastext, 1, -2));
		PowaAuras:AurasTextChanged()
		PowaOwntexButton:SetChecked(false);
		PowaWowTextureButton:SetChecked(false);
		PowaCustomTextureButton:SetChecked(false);
		PowaBarCustomTexName:Hide();
		if (PowaBarAuraSizeSlider:GetValue() > 1.61) then
			PowaBarAuraSizeSlider:SetValue(1.61);
		end
	else
		--self:ShowText("TextAuraChecked: unset");
		aura.textaura = false;
		PowaBarAuraTextureSlider:Show();
		PowaBarAurasText:Hide();
		PowaFontButton:Hide();
	end
	PowaAuras:BarAuraSizeSliderChanged();
	self:BarAuraTextureSliderChanged();
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:EnableFullRotationChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaEnableFullRotationButton:GetChecked()) then
		aura.enablefullrotation = true;
		PowaBarAuraRotateSlider:SetValueStep(1)
	else
		aura.enablefullrotation = false;
		if (aura.rotate ~= 0) and (aura.rotate ~= 90) and (aura.rotate ~= 180) and (aura.rotate ~= 270) and (aura.rotate ~= 360) then
			PowaBarAuraRotateSlider:SetValue(0)
		end
		PowaBarAuraRotateSlider:SetValueStep(90)
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:RoundIconsChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaRoundIconsButton:GetChecked()) then
		aura.roundicons = true;
	else
		aura.roundicons = false;
	end
	self:RedisplayAura(self.CurrentAuraId);
end

-- Targets, Party, Raid, ... Checkbuttons
function PowaAuras:TargetChecked()
	local aura = self.Auras[self.CurrentAuraId];
	if (PowaTargetButton:GetChecked()) then
		aura.target = true;
	else
		aura.target = false;
	end
	self:InitPage();
end

function PowaAuras:TargetFriendChecked()
	local auraId = self.CurrentAuraId;
	if (PowaTargetFriendButton:GetChecked()) then
		self.Auras[auraId].targetfriend = true;
	else
		self.Auras[auraId].targetfriend = false;
	end
	self:InitPage();
end

function PowaAuras:PartyChecked()
	local auraId = self.CurrentAuraId;
	if (PowaPartyButton:GetChecked()) then
		self.Auras[auraId].party = true;
	else
		self.Auras[auraId].party = false;
	end
	self:InitPage();
end

function PowaAuras:GroupOrSelfChecked()
	local auraId = self.CurrentAuraId;
	if (PowaGroupOrSelfButton:GetChecked()) then
		self.Auras[auraId].groupOrSelf = true;
	else
		self.Auras[auraId].groupOrSelf = false;
	end
	self:InitPage();
end

function PowaAuras:FocusChecked()
	local auraId = self.CurrentAuraId;
	if (PowaFocusButton:GetChecked()) then
		self.Auras[auraId].focus = true;
	else
		self.Auras[auraId].focus = false;
	end
	self:InitPage();
end

function PowaAuras:RaidChecked()
	local auraId = self.CurrentAuraId;
	if (PowaRaidButton:GetChecked()) then
		self.Auras[auraId].raid = true;
	else
		self.Auras[auraId].raid = false;
	end
	self:InitPage();
end

function PowaAuras:GroupAnyChecked()
	local auraId = self.CurrentAuraId;
	if (PowaGroupAnyButton:GetChecked()) then
		self.Auras[auraId].groupany = true;
	else
		self.Auras[auraId].groupany = false;
	end
	self:InitPage();
end

function PowaAuras:OptunitnChecked()
	local auraId = self.CurrentAuraId;
	if (PowaOptunitnButton:GetChecked()) then
		self.Auras[auraId].optunitn = true;
		PowaBarUnitn:Show();
		PowaBarUnitn:SetText(self.Auras[auraId].unitn);
	else
		self.Auras[auraId].optunitn = false;
		PowaBarUnitn:Hide();
	end
end

-- Dropdown Menus
function PowaAuras.DropDownMenu_Initialize(owner)
	local info;
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	local name = owner:GetName();
	if (aura == nil) then
		aura = PowaAuras:AuraFactory(PowaAuras.BuffTypes.Buff, 0);
	end
	if (name == "PowaStrataDropDown") then
		UIDropDownMenu_SetWidth(owner, 125)
		for i = 1, #PowaAuras.StrataList do
			local info = UIDropDownMenu_CreateInfo();
			info.text = PowaAuras.StrataList[i];
			info.func = function(self)
				local strata = PowaAuras.StrataList[i];
				local AuraID = PowaAuras.CurrentAuraId;
				if PowaAuras.CurrentAuraId > 120 then
					PowaGlobalSet[AuraID]["strata"] = strata;
				end
				PowaSet[AuraID]["strata"] = strata
				PowaStrataDropDownText:SetText(strata);
				UIDropDownMenu_SetSelectedName(PowaStrataDropDown, strata);
				PowaAuras:RedisplayAura(PowaAuras.CurrentAuraId);
			end
			UIDropDownMenu_AddButton(info, level);
		end
	elseif (name == "PowaTextureStrataDropDown") then
		UIDropDownMenu_SetWidth(owner, 125)
		for i = 1, #PowaAuras.TextureStrataList do
			local info = UIDropDownMenu_CreateInfo();
			info.text = PowaAuras.TextureStrataList[i];
			info.func = function(self)
				local texturestrata = PowaAuras.TextureStrataList[i];
				local AuraID = PowaAuras.CurrentAuraId;
				if PowaAuras.CurrentAuraId > 120 then
					PowaGlobalSet[AuraID]["texturestrata"] = texturestrata;
				end
				PowaSet[AuraID]["texturestrata"] = texturestrata
				PowaTextureStrataDropDownText:SetText(texturestrata);
				UIDropDownMenu_SetSelectedName(PowaTextureStrataDropDown, texturestrata);
				PowaAuras:RedisplayAura(PowaAuras.CurrentAuraId);
			end
			UIDropDownMenu_AddButton(info, level);
		end
	elseif (name == "PowaBlendModeDropDown") then
		UIDropDownMenu_SetWidth(owner, 125)
		for i = 1, #PowaAuras.BlendModeList do
			local info = UIDropDownMenu_CreateInfo();
			info.text = PowaAuras.BlendModeList[i];
			info.func = function(self)
				local blendmode = PowaAuras.BlendModeList[i];
				local AuraID = PowaAuras.CurrentAuraId;
				if PowaAuras.CurrentAuraId > 120 then
					PowaGlobalSet[AuraID]["blendmode"] = blendmode;
				end
				PowaSet[AuraID]["blendmode"] = blendmode
				PowaBlendModeDropDownText:SetText(blendmode);
				UIDropDownMenu_SetSelectedName(PowaBlendModeDropDown, blendmode);
				PowaAuras:RedisplayAura(PowaAuras.CurrentAuraId);
			end
			UIDropDownMenu_AddButton(info, level);
		end
	elseif (name == "PowaGradientStyleDropDown") then
		UIDropDownMenu_SetWidth(owner, 120)
		for i = 1, #PowaAuras.GradientStyleList do
			local info = UIDropDownMenu_CreateInfo();
			info.text = PowaAuras.GradientStyleList[i];
			info.func = function(self)
				local gradientstyle = PowaAuras.GradientStyleList[i];
				local AuraID = PowaAuras.CurrentAuraId;
				if PowaAuras.CurrentAuraId > 120 then
					PowaGlobalSet[AuraID]["gradientstyle"] = gradientstyle;
				end
				PowaSet[AuraID]["gradientstyle"] = gradientstyle
				PowaGradientStyleDropDownText:SetText(gradientstyle);
				UIDropDownMenu_SetSelectedName(PowaGradientStyleDropDown, gradientstyle);
				PowaAuras:RedisplayAura(PowaAuras.CurrentAuraId);
			end
			UIDropDownMenu_AddButton(info, level);
		end
	elseif (name == "PowaDropDownBuffType") then
		UIDropDownMenu_SetWidth(owner, 175)
		PowaAuras:FillDropdownSorted(PowaAuras.Text.AuraType, {func = PowaAuras.DropDownMenu_OnClickBuffType, owner = owner});
		UIDropDownMenu_SetSelectedValue(PowaDropDownBuffType, aura.bufftype);
	elseif (name == "PowaDropDownPowerType") then
		UIDropDownMenu_SetWidth(owner, 145)
		info = {func = PowaAuras.DropDownMenu_OnClickPowerType, owner = owner};
		for i, name in pairs(PowaAuras.Text.PowerType) do
			info.text = name;
			info.value = i;
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_SetSelectedValue(PowaDropDownPowerType, aura.PowerType);
	elseif (name == "PowaDropDownStance") then
		UIDropDownMenu_SetWidth(owner, 145)
		info = {func = PowaAuras.DropDownMenu_OnClickStance, owner = owner};
		for k, v in pairs(PowaAuras.PowaStance) do
			info.text = v;
			info.value = k;
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_SetSelectedValue(PowaDropDownStance, aura.stance);
	elseif (name == "PowaDropDownGTFO") then
		UIDropDownMenu_SetWidth(owner, 145)
		info = {func = PowaAuras.DropDownMenu_OnClickGTFO, owner = owner};
		for i = 0, #(PowaAuras.PowaGTFO) do
			info.text = PowaAuras.PowaGTFO[i];
			info.value = i;
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_SetSelectedValue(PowaDropDownGTFO, aura.GTFO);
	elseif (name == "PowaDropDownAnimBegin") then
		UIDropDownMenu_SetWidth(owner, 190)
		info = {func = PowaAuras.DropDownMenu_OnClickBegin, owner = owner};
		for i = 0, #PowaAuras.BeginAnimDisplay do
			info.text = PowaAuras.BeginAnimDisplay[i];
			info.value = i;
			UIDropDownMenu_AddButton(info);
		end
		UIDropDownMenu_SetSelectedValue(PowaDropDownAnimBegin, aura.begin);
	elseif (name == "PowaDropDownAnimEnd") then
		UIDropDownMenu_SetWidth(owner, 190)
		info = {func = PowaAuras.DropDownMenu_OnClickEnd, owner = owner};
		local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
		if aura ~= nil then
			if aura.UseOldAnimations == false then
				for i = 0, #PowaAuras.EndAnimDisplay do
					info.text = PowaAuras.EndAnimDisplay[i];
					info.value = i;
					UIDropDownMenu_AddButton(info);
				end
			else
				for i = 0, #PowaAuras.EndAnimDisplay - 2  do
					info.text = PowaAuras.EndAnimDisplay[i];
					info.value = i;
					UIDropDownMenu_AddButton(info);
				end
			end
			UIDropDownMenu_SetSelectedValue(PowaDropDownAnimEnd, aura.finish);
		else
			for i = 0, #PowaAuras.EndAnimDisplay - 2  do
				info.text = PowaAuras.EndAnimDisplay[i];
				info.value = i;
				UIDropDownMenu_AddButton(info);
			end
			UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, 1);
		end
	elseif (name == "PowaDropDownAnim1") then
		UIDropDownMenu_SetWidth(owner, 190)
		local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
		if aura ~= nil then
			if aura.UseOldAnimations == false then
				for i = 1, #(PowaAuras.Anim) do
					info = { };
					info.text = PowaAuras.Anim[i];
					info.value = i;
					info.func = PowaAuras.DropDownMenu_OnClickAnim1;
					UIDropDownMenu_AddButton(info);
				end
			else
				for i = 1, #(PowaAuras.Anim) - 2 do
					info = { };
					info.text = PowaAuras.Anim[i];
					info.value = i;
					info.func = PowaAuras.DropDownMenu_OnClickAnim1;
					UIDropDownMenu_AddButton(info);
				end
			end
			UIDropDownMenu_SetSelectedValue(PowaDropDownAnim1, aura.anim1);
		else
			for i = 1, #(PowaAuras.Anim) - 2 do
				info = { };
				info.text = PowaAuras.Anim[i];
				info.value = i;
				info.func = PowaAuras.DropDownMenu_OnClickAnim1;
				UIDropDownMenu_AddButton(info);
			end
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim1, 1);
		end
	elseif (name == "PowaDropDownAnim2") then
		UIDropDownMenu_SetWidth(owner, 190)
		local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
		if aura ~= nil then
			if aura.UseOldAnimations == false then
				for i = 0, #(PowaAuras.Anim) do
					info = { };
					info.text = PowaAuras.Anim[i];
					info.value = i;
					info.func = PowaAuras.DropDownMenu_OnClickAnim2;
					UIDropDownMenu_AddButton(info);
				end
			else
				for i = 0, #(PowaAuras.Anim) - 2 do
					info = { };
					info.text = PowaAuras.Anim[i];
					info.value = i;
					info.func = PowaAuras.DropDownMenu_OnClickAnim2;
					UIDropDownMenu_AddButton(info);
				end
			end
			UIDropDownMenu_SetSelectedValue(PowaDropDownAnim2, aura.anim2);
		else
			for i = 0, #(PowaAuras.Anim) - 2 do
				info = { };
				info.text = PowaAuras.Anim[i];
				info.value = i;
				info.func = PowaAuras.DropDownMenu_OnClickAnim2;
				UIDropDownMenu_AddButton(info);
			end
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim2, 1);
		end
	elseif (name == "PowaDropDownSound") then
		UIDropDownMenu_SetWidth(owner, 210)
		info = {func = PowaAuras.DropDownMenu_OnClickSound, owner = owner};
		for i = 0, 29 do
			if (PowaAuras.Sound[i]) then
				info.text = PowaAuras.Sound[i];
				info.value = i;
				UIDropDownMenu_AddButton(info);
			end
		end
		if (aura.sound < 30) then
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound, aura.sound);
		else
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound, 0);
		end
	elseif (name == "PowaDropDownSound2") then
		UIDropDownMenu_SetWidth(owner, 210)
		info = {func = PowaAuras.DropDownMenu_OnClickSound, owner = owner};
		for i = 30, #PowaAuras.Sound do
			if (PowaAuras.Sound[i]) then
				info.text = PowaAuras.Sound[i];
				info.value = i;
				UIDropDownMenu_AddButton(info);
			end
		end
		if (aura.sound >= 30) then
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, aura.sound);
		else
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound2, 30);
		end
	elseif (name == "PowaDropDownSoundEnd") then
		UIDropDownMenu_SetWidth(owner, 210)
		info = {func = PowaAuras.DropDownMenu_OnClickSoundEnd, owner = owner};
		for i = 0, 29 do
			if (PowaAuras.Sound[i]) then
				info.text = PowaAuras.Sound[i];
				info.value = i;
				UIDropDownMenu_AddButton(info);
			end
		end
		if (aura.soundend < 30) then
			UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, aura.soundend);
		else
			UIDropDownMenu_SetSelectedValue(PowaDropDownSoundEnd, 0);
		end
	elseif (name == "PowaDropDownSound2End") then
		UIDropDownMenu_SetWidth(owner, 210)
		info = {func = PowaAuras.DropDownMenu_OnClickSoundEnd, owner = owner};
		for i = 30, #PowaAuras.Sound do
			if (PowaAuras.Sound[i]) then
				info.text = PowaAuras.Sound[i];
				info.value = i;
				UIDropDownMenu_AddButton(info);
			end
		end
		if (aura.soundend >= 30) then
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, aura.soundend);
		else
			UIDropDownMenu_SetSelectedValue(PowaDropDownSound2End, 30);
		end
	elseif (name == "PowaBuffTimerRelative") then
		UIDropDownMenu_SetWidth(owner, 190)
		info = {func = PowaAuras.DropDownMenu_OnClickTimerRelative, owner = owner};
		for null, v in pairs({"NONE", "TOPLEFT", "TOP", "TOPRIGHT", "RIGHT", "BOTTOMRIGHT", "BOTTOM", "BOTTOMLEFT", "LEFT", "CENTER"}) do
			info.text = PowaAuras.Text.Relative[v];
			info.value = v;
			UIDropDownMenu_AddButton(info);
		end
		if (aura.Timer) then
			UIDropDownMenu_SetSelectedValue(PowaBuffTimerRelative, aura.Timer.Relative);
		end
	elseif (name == "PowaBuffStacksRelative") then
		UIDropDownMenu_SetWidth(owner, 190)
		info = {func = PowaAuras.DropDownMenu_OnClickStacksRelative, owner = owner};
		for null, v in pairs({"NONE", "TOPLEFT", "TOP", "TOPRIGHT", "RIGHT", "BOTTOMRIGHT", "BOTTOM", "BOTTOMLEFT", "LEFT", "TOPLEFT", "CENTER"}) do
			info.text = PowaAuras.Text.Relative[v];
			info.value = v;
			UIDropDownMenu_AddButton(info);
		end
		if (aura.Stacks) then
			UIDropDownMenu_SetSelectedValue(PowaBuffStacksRelative, aura.Stacks.Relative);
		end
	end
end

function PowaAuras:FillDropdownSorted(t, info)
	local names = PowaAuras:CopyTable(t);
	local values = PowaAuras:ReverseTable(names);
	table.sort(names);
	--for k,v in ipairs(names) do PowaAuras:Message(k, " ", v, " ", auraReverse[v]) end
	for null,name in pairs(names) do
		info.text = name;
		info.value = values[name];
		UIDropDownMenu_AddButton(info);
	end
end

function PowaAuras.DropDownMenu_OnClickBuffType(self)
	--PowaAuras:Message("DropDownMenu_OnClickBuffType bufftype ", self.value, " for aura ", PowaAuras.CurrentAuraId, " ", self.owner);
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	PowaAuras:ChangeAuraType(PowaAuras.CurrentAuraId, self.value);
end

function PowaAuras:ChangeAuraType(id, newType)
	local oldAura = self.Auras[id];
	local showing = oldAura.Showing;
	oldAura:Hide();
	--PowaAuras:Message("ChangeAuraType newType ", newType, " for aura ", id);
	if (oldAura.Timer) then oldAura.Timer:Dispose(); end
	if (oldAura.Stacks) then oldAura.Stacks:Dispose(); end
	oldAura:Dispose();
	local aura = self:AuraFactory(newType, id, oldAura);
	aura.icon = "";
	aura.Showing = showing;
	aura:Init();
	self.Auras[id] = aura
	if (self.CurrentAuraId > 120) then
		PowaGlobalSet[id] = aura;
	end
	self:CalculateAuraSequence();
	if (aura.bufftype == self.BuffTypes.Slots) then
		if (not PowaEquipmentSlotsFrame:IsVisible()) then
			PowaEquipmentSlotsFrame:Show();
		end
	else
		if (PowaEquipmentSlotsFrame:IsVisible()) then
			PowaEquipmentSlotsFrame:Hide();
		end
	end
	if (aura.CheckBoxes.PowaOwntexButton ~= 1) then
		aura.owntex = false;
	end
	self:UpdateMainOption();
	self:RedisplayAura(aura.id);
	self:InitPage(aura);
end

function PowaAuras:ShowSpinAtBeginningChecked(control)
	local aura = self.Auras[self.CurrentAuraId];
	if (control:GetChecked()) then
		aura.beginSpin = true;
	else
		aura.beginSpin = false;
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:OldAnimationChecked(control)
	local aura = self.Auras[self.CurrentAuraId];
	if (control:GetChecked()) then
		aura.UseOldAnimations = true;
		PowaShowSpinAtBeginning:Hide();
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnimEnd) == 5 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, 1);
			PowaAuras.Auras[auraId].finish = 0;
			PowaAuras:RedisplayAura(auraId);
		end
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnimEnd) == 6 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, 1);
			PowaAuras.Auras[auraId].finish = 0;
			PowaAuras:RedisplayAura(auraId);
		end
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnim1) == 11 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim1, 1);
			PowaAuras.Auras[auraId].anim1 = 1;
			PowaAuras:RedisplayAura(auraId);
		end
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnim1) == 12 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim1, 1);
			PowaAuras.Auras[auraId].anim1 = 1;
			PowaAuras:RedisplayAura(auraId);
		end
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnim2) == 12 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim2, 1);
			PowaAuras.Auras[auraId].anim2 = 0;
			PowaAuras:RedisplayAura(auraId);
		end
		if UIDropDownMenu_GetSelectedID(PowaDropDownAnim2) == 13 then
			local auraId = PowaAuras.CurrentAuraId;
			UIDropDownMenu_SetSelectedID(PowaDropDownAnim2, 1);
			PowaAuras.Auras[auraId].anim2 = 0;
			PowaAuras:RedisplayAura(auraId);
		end
	else
		aura.UseOldAnimations = false;
		PowaShowSpinAtBeginning:Show();
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras.DropDownMenu_OnClickAnim1(owner)
	local optionID = owner:GetID();
	local auraId = PowaAuras.CurrentAuraId;
	--PowaAuras:ShowText("DropDownMenu_OnClickAnim1 optionID=", optionID, " auraId=", auraId);
	UIDropDownMenu_SetSelectedID(PowaDropDownAnim1, optionID);
	--local optionName = UIDropDownMenu_GetText(PowaDropDownAnim1);
	--UIDropDownMenu_SetSelectedValue(PowaDropDownAnim1, optionName);
	PowaAuras.Auras[auraId].anim1 = optionID;
	PowaAuras:RedisplayAura(auraId);
end

function PowaAuras.DropDownMenu_OnClickAnim2(owner)
	local optionID = owner:GetID();
	local auraId = PowaAuras.CurrentAuraId;
	UIDropDownMenu_SetSelectedID(PowaDropDownAnim2, optionID);
	--local optionName = UIDropDownMenu_GetText(PowaDropDownAnim2);
	--UIDropDownMenu_SetSelectedValue(PowaDropDownAnim2, optionName);
	PowaAuras.Auras[auraId].anim2 = optionID - 1;
	PowaAuras:RedisplayAura(auraId);
end

function PowaAuras.DropDownMenu_OnClickSound(self)
	--PowaAuras:ShowText("DropDownMenu_OnClickSound n=", self.owner:GetName()," v=",self.value, " t=", PowaAuras.Sound[self.value]);
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	if (self.value == 0 or self.value == 30 or not PowaAuras.Sound[self.value]) then
		PowaAuras.Auras[PowaAuras.CurrentAuraId].sound = 0;
		return;
	end
	PowaAuras.Auras[PowaAuras.CurrentAuraId].sound = self.value;
	if (self.value < 30) then
		PowaDropDownSound2Text:SetText(PowaAuras.Sound[30]);
	else
		PowaDropDownSoundText:SetText(PowaAuras.Sound[0]);
	end
	if (string.find(PowaAuras.Sound[self.value], "%.")) then
		--PowaAuras:ShowText("Playing sound "..PowaGlobalMisc.PathToSounds..PowaAuras.Sound[self.value]);
		PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAuras.Sound[self.value], PowaMisc.SoundChannel);
	else
		--PowaAuras:ShowText("Playing WoW sound "..PowaAuras.Sound[self.value]);
		PlaySound(PowaAuras.Sound[self.value], PowaMisc.SoundChannel);
	end
end;

function PowaAuras.DropDownMenu_OnClickSoundEnd(self)
	--PowaAuras:ShowText("DropDownMenu_OnClickSoundEnd n=", self.owner:GetName()," v=",self.value, " t=", PowaAuras.Sound[self.value]);
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	if (self.value == 0 or self.value == 30 or not PowaAuras.Sound[self.value]) then
		PowaAuras.Auras[PowaAuras.CurrentAuraId].soundend = 0;
		return;
	end
	PowaAuras.Auras[PowaAuras.CurrentAuraId].soundend = self.value;
	if (self.value < 30) then
		PowaDropDownSound2EndText:SetText(PowaAuras.Sound[30]);
	else
		PowaDropDownSoundEndText:SetText(PowaAuras.Sound[0]);
	end
	if (string.find(PowaAuras.Sound[self.value], "%.")) then
		--PowaAuras:ShowText("Playing sound "..PowaGlobalMisc.PathToSounds..PowaAuras.Sound[self.value]);
		PlaySoundFile(PowaGlobalMisc.PathToSounds..PowaAuras.Sound[self.value], PowaMisc.SoundChannel);
	else
		--PowaAuras:ShowText("Playing WoW sound "..PowaAuras.Sound[self.value]);
		PlaySound(PowaAuras.Sound[self.value], PowaMisc.SoundChannel);
	end
end

function PowaAuras.DropDownMenu_OnClickStance(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	local auraId = PowaAuras.CurrentAuraId;
	if (PowaAuras.Auras[auraId].stance ~= self.value) then
		PowaAuras.Auras[auraId].stance = self.value;
		PowaAuras.Auras[auraId].icon = "";
	end
	PowaAuras:InitPage();
end

function PowaAuras.DropDownMenu_OnClickGTFO(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura.GTFO ~= self.value) then
		aura.GTFO = self.value;
		aura.icon = "";
	end
	PowaAuras:InitPage(aura);
end

function PowaAuras.DropDownMenu_OnClickPowerType(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura.PowerType ~= self.value) then
		--PowaAuras:ShowText("PowerType changed to ", self.value);
		aura.PowerType = self.value;
		aura.icon = "";
		aura:Init();
		--PowaAuras:ShowText("MaxRange=", aura.MaxRange);
		--PowaAuras:ShowText("RangeType=", aura.RangeType);
	end
	PowaAuras:InitPage();
end

function PowaAuras.DropDownMenu_OnClickBegin(self)
	UIDropDownMenu_SetSelectedID(self.owner, self.value + 1);
	--local optionName = UIDropDownMenu_GetText(PowaDropDownAnimBegin);
	--UIDropDownMenu_SetSelectedValue(PowaDropDownAnimBegin, optionName);
	PowaAuras.Auras[PowaAuras.CurrentAuraId].begin = self.value;
	PowaAuras:RedisplayAura(auraId);
end

function PowaAuras.DropDownMenu_OnClickEnd(self)
	local optionID = self:GetID();
	local auraId = PowaAuras.CurrentAuraId;
	UIDropDownMenu_SetSelectedID(PowaDropDownAnimEnd, optionID);
	--local optionName = UIDropDownMenu_GetText(PowaDropDownAnimEnd);
	--UIDropDownMenu_SetSelectedValue(PowaDropDownAnimEnd, optionName);
	PowaAuras.Auras[auraId].finish = optionID - 1;
	PowaAuras:RedisplayAura(auraId);
end

-- Options Deplacement
function PowaAuras:Bar_MouseDown(frame, button)
	if( button == "LeftButton") then
		frame:StartMoving();
	end
end

function PowaAuras:Bar_MouseUp(frame, button)
	frame:StopMovingOrSizing();
end

-- Color Picker
function PowaAuras.SetColor()
	PowaAuras:SetAuraColor(ColorPickerFrame:GetColorRGB());
end

function PowaAuras.CancelColor()
	PowaAuras:SetAuraColor(ColorPickerFrame.previousValues.r, ColorPickerFrame.previousValues.g, ColorPickerFrame.previousValues.b);
end

function PowaAuras:SetAuraColor(r, g, b)
	--self:Message("SetColor r=", r, " g=",g, " b=", b);
	local swatch = getglobal(ColorPickerFrame.Button:GetName().."NormalTexture"); -- Only the visuals
	swatch:SetVertexColor(r, g, b);
	local frame = getglobal(ColorPickerFrame.Button:GetName().."_SwatchBg"); -- Set the calling button's color
	frame.r = r;
	frame.g = g;
	frame.b = b;
	ColorPickerFrame.Source.r = r;
	ColorPickerFrame.Source.g = g;
	ColorPickerFrame.Source.b = b;
	if (ColorPickerFrame.setTexture) then
		AuraTexture:SetVertexColor(r, g, b);
	end
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:OpenColorPicker(control, source, setTexture)
	CloseMenus();
	if ColorPickerFrame:IsVisible() then
		PowaAuras.CancelColor();
		ColorPickerFrame:Hide();
	else
		local button = PowaColor_SwatchBg;
		ColorPickerFrame.Source = source;
		ColorPickerFrame.Button = control;
		ColorPickerFrame.setTexture = setTexture;
		ColorPickerFrame.func = self.SetColor -- button.swatchFunc;
		ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
		
		ColorPickerFrame.previousValues = {r = button.r, g = button.g, b = button.b, a = button.opacity};
		ColorPickerFrame.cancelFunc = self.CancelColor
		ColorPickerFrame:SetPoint("TOPLEFT", "PowaBarConfigFrame", "TOPRIGHT", 0, 0)
		ColorPickerFrame:Show();
	end
end

function PowaAuras.SetGradientColor()
	PowaAuras:SetGradientAuraColor(ColorPickerFrame:GetColorRGB());
end

function PowaAuras.CancelGradientColor()
	PowaAuras:SetGradientAuraColor(ColorPickerFrame.previousGradientValues.r, ColorPickerFrame.previousGradientValues.g, ColorPickerFrame.previousGradientValues.b);
end

function PowaAuras:SetGradientAuraColor(r, g, b)
	--self:Message("SetColor r=", r, " g=",g, " b=", b);
	local swatch = getglobal(ColorPickerFrame.GradientButton:GetName().."NormalTexture"); -- Only the visuals
	swatch:SetVertexColor(r, g, b);
	local frame = getglobal(ColorPickerFrame.GradientButton:GetName().."_SwatchBg"); -- Set the calling button's color
	frame.r = r;
	frame.g = g;
	frame.b = b;
	self.Auras[self.CurrentAuraId].gr = r;
	self.Auras[self.CurrentAuraId].gg = g;
	self.Auras[self.CurrentAuraId].gb = b;
	self:RedisplayAura(self.CurrentAuraId);
end

function PowaAuras:OpenGradientColorPicker(control, source, setTexture)
	CloseMenus();
	if ColorPickerFrame:IsVisible() then
		PowaAuras.CancelGradientColor();
		ColorPickerFrame:Hide();
	else
		local button = PowaGradientColor_SwatchBg;
		ColorPickerFrame.GradientSource = source;
		ColorPickerFrame.GradientButton = control;
		ColorPickerFrame.setTexture = setTexture;
		ColorPickerFrame.func = self.SetGradientColor -- button.swatchFunc;
		ColorPickerFrame:SetColorRGB(button.r, button.g, button.b);
		
		ColorPickerFrame.previousGradientValues = {r = button.r, g = button.g, b = button.b, a = button.opacity};
		ColorPickerFrame.cancelFunc = self.CancelGradientColor
		ColorPickerFrame:SetPoint("TOPLEFT", "PowaBarConfigFrame", "TOPRIGHT", 0, 0)
		ColorPickerFrame:Show();
	end
end

-- Font Selector
function PowaAuras:FontSelectorOnShow(owner)
	owner:SetBackdropBorderColor(0.9, 1.0, 0.95);
	owner:SetBackdropColor(0.6, 0.6, 0.6);
end

function PowaAuras:OpenFontSelector(owner)
	CloseMenus();
	if (FontSelectorFrame:IsVisible()) then
		FontSelectorFrame:Hide();
	else
		FontSelectorFrame.selectedFont = self.Auras[self.CurrentAuraId].aurastextfont;
		FontSelectorFrame:Show();
	end
end

function PowaAuras:FontSelectorOkay(owner)
	if FontSelectorFrame.selectedFont then
		self.Auras[self.CurrentAuraId].aurastextfont = FontSelectorFrame.selectedFont;
	else
		self.Auras[self.CurrentAuraId].aurastextfont = 1;
	end
	self:RedisplayAura(self.CurrentAuraId);
	self:FontSelectorClose(owner);
end

function PowaAuras:FontSelectorCancel(owner)
	self:FontSelectorClose(owner);
end

function PowaAuras:FontSelectorClose(owner)
	if (FontSelectorFrame:IsVisible()) then
		FontSelectorFrame:Hide();
	end
end

function PowaAuras:FontButton_OnClick(owner)
	FontSelectorFrame.selectedFont = getglobal("FontSelectorEditorScrollButton"..owner:GetID()).font;
	self:FontScrollBar_Update(owner);
end

function PowaAuras.FontScrollBar_Update(owner)
	local fontOffset = FauxScrollFrame_GetOffset(FontSelectorEditorScrollFrame);
	local fontIndex;
	local fontName, namestart, nameend;
	for i = 1, 10, 1 do
		fontIndex = fontOffset + i;
		fontName = PowaAuras.Fonts[fontIndex];
		fontText = getglobal("FontSelectorEditorScrollButton"..i.."Text");
		fontButton = getglobal("FontSelectorEditorScrollButton"..i);
		fontButton.font = fontIndex;
		namestart = string.find(fontName, "\\", 1, true);
		nameend = string.find(fontName, ".", 1, true);
		if namestart and nameend and (nameend > namestart) then
			fontName = string.sub(fontName, namestart + 1, nameend - 1);
			while string.find(fontName, "\\", 1, true) do
				namestart = string.find(fontName, "\\", 1, true)
				fontName = string.sub(fontName, namestart + 1);
			end
		end
		fontText:SetFont(PowaAuras.Fonts[fontIndex], 14, "OUTLINE, MONOCHROME");
		fontText:SetText(fontName);
		if FontSelectorFrame.selectedFont == fontIndex then
			fontButton:LockHighlight();
		else
			fontButton:UnlockHighlight();
		end
	end
	FauxScrollFrame_Update(FontSelectorEditorScrollFrame, #PowaAuras.Fonts, 10, 16 );
end

function PowaAuras:EditorShow()
	local owner = _G["PowaIcone"..self.CurrentAuraId];
	if (PowaBarConfigFrame:IsVisible()) then
		self:EditorClose();
		return;
	end
	local aura = self.Auras[self.CurrentAuraId];
	if (aura) then
		if (not aura.Showing) then
			aura.Active = true;
			aura:CreateFrames();
			self.SecondaryAuras[aura.id] = nil; -- Force recreate
			self:DisplayAura(aura.id);
			if aura.off == false then
				if (owner ~= nil) then
					owner:SetAlpha(1.0)
				end
			end
		end
		self:InitPage(aura);
		PowaBarConfigFrame:Show();
		PlaySound("TalentScreenOpen", PowaMisc.SoundChannel);
	end
end

function PowaAuras:EditorClose()
	if (PowaBarConfigFrame:IsVisible()) then
		if (FontSelectorFrame:IsVisible()) then
			FontSelectorFrame:Hide();
		end
		if (ColorPickerFrame:IsVisible()) then
			self.CancelColor();
			ColorPickerFrame:Hide();
		end
		PowaBarConfigFrame:Hide();
		PlaySound("TalentScreenClose", PowaMisc.SoundChannel);
	end
end

-- Advanced Options
function PowaAuras:UpdateOptionsTimer(auraId)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local timer = self.Auras[auraId].Timer;
	local frame1 = self.TimerFrame[auraId][1];
	frame1:SetAlpha(math.min(timer.a, 0.99));
	frame1:SetWidth(20 * timer.h);
	frame1:SetHeight(20 * timer.h);
	if (timer:IsRelative()) then
		frame1:SetPoint(self.RelativeToParent[timer.Relative], self.Frames[auraId], timer.Relative, timer.x, timer.y);
	else
		frame1:SetPoint("CENTER", timer.x, timer.y);
	end
	local frame2 = self.TimerFrame[auraId][2];
	frame2:SetAlpha(timer.a * 0.75);
	frame2:SetWidth(14 * timer.h);
	frame2:SetHeight(14 * timer.h);
	frame2:SetPoint("LEFT", frame1, "RIGHT", 1, - 1.5);
end

function PowaAuras:UpdateOptionsStacks(auraId)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local stacks = self.Auras[auraId].Stacks;
	local frame = self.StacksFrames[auraId];
	frame:SetAlpha(math.min(stacks.a, 0.99));
	frame:SetWidth(20 * stacks.h);
	frame:SetHeight(20 * stacks.h);
	frame:SetPoint("Center", stacks.x, stacks.y);
	if (stacks:IsRelative()) then
		--PowaAuras:ShowText(self.Frames[auraId],": stacks.Relative=", stacks.Relative, " RelativeToParent=", self.RelativeToParent[stacks.Relative], " x=", stacks.x, " y=",stacks.y);
		frame:SetPoint(self.RelativeToParent[stacks.Relative], self.Frames[auraId], stacks.Relative, stacks.x, stacks.y);
	else
		frame:SetPoint("CENTER", stacks.x, stacks.y);
	end
end

function PowaAuras:ShowTimerChecked(control)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (control:GetChecked()) then
		self.Auras[self.CurrentAuraId].Timer.enabled = true;
		self:CreateTimerFrameIfMissing(self.CurrentAuraId);
	else
		self.Auras[self.CurrentAuraId].Timer.enabled = false;
		self.Auras[self.CurrentAuraId].Timer:Dispose();
	end
end

function PowaAuras:TimerSizeSliderChanged()
	local SliderValue = PowaTimerSizeSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaTimerSizeSliderText:SetText(self.Text.nomTaille..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].Timer.h = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:TimerAlphaSliderChanged()
	local SliderValue = PowaTimerAlphaSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaTimerAlphaSliderText:SetText(self.Text.nomAlpha..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].Timer.a = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:TimerCoordXSliderChanged()
	local SliderValue = PowaTimerCoordXSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaTimerCoordXSliderText:SetText(self.Text.nomPos.." X: "..SliderValue);
	self.Auras[self.CurrentAuraId].Timer.x = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:TimerCoordYSliderChanged()
	local SliderValue = PowaTimerCoordYSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaTimerCoordYSliderText:SetText(self.Text.nomPos.." Y: "..SliderValue);
	self.Auras[self.CurrentAuraId].Timer.y = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:PowaTimerInvertAuraSliderChanged(slider)
	local text;
	local SliderValue = PowaTimerInvertAuraSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (self.Auras[self.CurrentAuraId].InvertTimeHides) then
		text = self.Text.nomTimerHideAura;
		slider.aide = PowaAuras.Text.aidePowaTimerHideAuraSlider;
	else
		text = self.Text.nomTimerInvertAura;
		slider.aide = PowaAuras.Text.aidePowaTimerInvertAuraSlider;
	end
	PowaTimerInvertAuraSliderText:SetText(text..": "..format("%.2f", SliderValue).." sec");
	self.Auras[self.CurrentAuraId].InvertAuraBelow = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:TimerDurationSliderChanged()
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local SliderValue = PowaTimerDurationSlider:GetValue();
	PowaTimerDurationSliderText:SetText(self.Text.nomTimerDuration..": "..format("%.2f", SliderValue).." sec");
	self.Auras[self.CurrentAuraId].timerduration = SliderValue;
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras.DropDownMenu_OnClickTimerRelative(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	--PowaAuras:ShowText(PowaAuras.Auras[PowaAuras.CurrentAuraId].id," change timer relative position ", self.value);
	local timer = PowaAuras.Auras[PowaAuras.CurrentAuraId].Timer;
	timer.x = 0;
	timer.y = 0;
	timer.Relative = self.value;
	timer:Dispose();
end

function PowaAuras:TimerChecked(control, setting)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local aura = self.Auras[self.CurrentAuraId];
	if (control:GetChecked()) then
		aura.Timer[setting] = true;
	else
		aura.Timer[setting] = false;
	end
	aura.Timer:Dispose();
	aura.Timer:SetShowOnAuraHide(aura);
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

function PowaAuras:SettingChecked(control, setting)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (control:GetChecked()) then
		self.Auras[self.CurrentAuraId][setting] = true;
	else
		self.Auras[self.CurrentAuraId][setting] = false;
	end
end

function PowaAuras:TimerTransparentChecked(control)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (control:GetChecked()) then
		self.Auras[self.CurrentAuraId].Timer.Transparent = true;
	else
		self.Auras[self.CurrentAuraId].Timer.Transparent = false;
	end
	self.Auras[self.CurrentAuraId].Timer:Dispose();
	--self:CreateTimerFrameIfMissing(self.CurrentAuraId);
end

-- Stacks
function PowaAuras:ShowStacksChecked(control)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (control:GetChecked()) then
		self.Auras[self.CurrentAuraId].Stacks.enabled = true;
	else
		self.Auras[self.CurrentAuraId].Stacks.enabled = false;
		self.Auras[self.CurrentAuraId].Stacks:Dispose();
	end
end

function PowaAuras:StacksAlphaSliderChanged()
	local SliderValue = PowaStacksAlphaSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaStacksAlphaSliderText:SetText(self.Text.nomAlpha..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].Stacks.a = SliderValue;
end

function PowaAuras:StacksSizeSliderChanged()
	local SliderValue = PowaStacksSizeSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaStacksSizeSliderText:SetText(self.Text.nomTaille..": "..format("%.0f", SliderValue * 100).."%");
	self.Auras[self.CurrentAuraId].Stacks.h = SliderValue;
end

function PowaAuras:StacksCoordXSliderChanged()
	local SliderValue = PowaStacksCoordXSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaStacksCoordXSliderText:SetText(self.Text.nomPos.." X: "..SliderValue);
	self.Auras[self.CurrentAuraId].Stacks.x = SliderValue;
end


function PowaAuras:StacksCoordYSliderChanged()
	local SliderValue = PowaStacksCoordYSlider:GetValue();
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	PowaStacksCoordYSliderText:SetText(self.Text.nomPos.." Y: "..SliderValue);
	self.Auras[self.CurrentAuraId].Stacks.y = SliderValue;
end

function PowaAuras.DropDownMenu_OnClickStacksRelative(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	--PowaAuras:ShowText(PowaAuras.Auras[PowaAuras.CurrentAuraId].id," change stacks relative position ", self.value);
	local stacks = PowaAuras.Auras[PowaAuras.CurrentAuraId].Stacks;
	stacks.x = 0;
	stacks.y = 0;
	stacks.Relative = self.value;
	stacks:Dispose();
end

function PowaAuras:StacksChecked(control, setting)
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	if (control:GetChecked()) then
		self.Auras[self.CurrentAuraId].Stacks[setting] = true;
	else
		self.Auras[self.CurrentAuraId].Stacks[setting] = false;
	end
	self.Auras[self.CurrentAuraId].Stacks:Dispose();
end

function PowaAuras_CommanLine(msg)
	if (msg == "dump") then
		PowaAuras:Dump();
		PowaAuras:Message("State dumped to"); -- OK
		PowaAuras:Message("WTF \\ Account \\ <ACCOUNT> \\ "..GetRealmName().." \\ "..UnitName("player").." \\ SavedVariables \\ PowerAuras.lua"); -- OK
		PowaAuras:Message("You must log-out to save the values to disk (at end of fight/raid is fine)"); -- OK
	elseif (msg=="toggle" or msg=="tog") then
		PowaAuras:Toggle();
	elseif (msg=="showbuffs") then
		PowaAuras:ShowAurasOnUnit("Buffs", "HELPFUL");
	elseif (msg=="showdebuffs") then
		PowaAuras:ShowAurasOnUnit("Debuffs", "HARMFUL");
	else
		PowaAuras:MainOptionShow();
	end
end

function PowaAuras_InitalizeOnMenuOpen()
	-- Initalize dropdown menu buttons on menu open
	-- PowaDropDownBuffType
	UIDropDownMenu_Initialize(PowaDropDownBuffType, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownPowerType
	UIDropDownMenu_Initialize(PowaDropDownPowerType, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownStance
	UIDropDownMenu_Initialize(PowaDropDownStance, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownGTFO
	UIDropDownMenu_Initialize(PowaDropDownGTFO, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownAnimBegin
	UIDropDownMenu_Initialize(PowaDropDownAnimBegin, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownAnimEnd
	UIDropDownMenu_Initialize(PowaDropDownAnimEnd, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownAnim1
	UIDropDownMenu_Initialize(PowaDropDownAnim1, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownAnim2
	UIDropDownMenu_Initialize(PowaDropDownAnim2, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownSound
	UIDropDownMenu_Initialize(PowaDropDownSound, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownSound2
	UIDropDownMenu_Initialize(PowaDropDownSound2, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownSoundEnd
	UIDropDownMenu_Initialize(PowaDropDownSoundEnd, PowaAuras.DropDownMenu_Initialize);
	-- PowaDropDownSound2End
	UIDropDownMenu_Initialize(PowaDropDownSound2End, PowaAuras.DropDownMenu_Initialize);
end

function PowaAuras:ShowAurasOnUnit(display, auraType)
	local index = 1;
	local unit = "player";
	if (UnitExists("target")) then
		unit = "target";
	end
	PowaAuras:Message(display.." on "..unit);
	local Name, null, null, Applications, Type, Duration, Expires, Source, Stealable, shouldConsolidate, spellId = UnitAura(unit, index, auraType);
	while (Name ~= nil) do
		PowaAuras:Message(index..": "..Name.." (SpellID="..spellId..")");
		index = index + 1;
		Name, null, null, Applications, Type, Duration, Expires, Source, Stealable, shouldConsolidate, spellId = UnitAura(unit, index, auraType);
	end
end

-- Enable/Disable Options Functions
function PowaAuras:DisableSlider(slider)
	getglobal(slider):EnableMouse(false);
	getglobal(slider.."Text"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	getglobal(slider.."Low"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	getglobal(slider.."High"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end

function PowaAuras:EnableSlider(slider)
	getglobal(slider):EnableMouse(true);
	getglobal(slider.."Text"):SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	getglobal(slider.."Low"):SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	getglobal(slider.."High"):SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
end

function PowaAuras:DisableTextfield(textfield)
	getglobal(textfield):Hide();
	getglobal(textfield.."Text"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end

function PowaAuras:EnableTextfield(textfield)
	getglobal(textfield):Show();
	getglobal(textfield.."Text"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end

function PowaAuras:DisableCheckBox(checkBox)
	getglobal(checkBox):Disable();
	getglobal(checkBox.."Text"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
end

function PowaAuras:EnableCheckBox(checkBox, colour)
	--self:ShowText("EnableCheckBox ", checkBox);
	getglobal(checkBox):Enable();
	if (not colour) then
		colour = NORMAL_FONT_COLOR;
	end
	--self:ShowText("r=", color.r, " g=", color.g, " b=", color.b);
	getglobal(checkBox.."Text"):SetTextColor(colour.r, colour.g, colour.b);
end

function PowaAuras:HideCheckBox(checkBox)
	getglobal(checkBox):Hide();
end

function PowaAuras:ShowCheckBox(checkBox)
	getglobal(checkBox):Show();
end

-- Blizzard Addon
function PowaAuras:EnableChecked()
	--PowaAuras:ShowText("EnableChecked");
	if (PowaEnableButton:GetChecked()) then
		self:Toggle(true);
	else
		self:MainOptionClose();
		self:Toggle(false);
	end
end

function PowaAuras:MiscChecked(control, setting)
	if (control:GetChecked()) then
		PowaMisc[setting] = true;
	else
		PowaMisc[setting] = false;
	end
end

function PowaAuras:GlobalMiscChecked(control, setting)
	if (control:GetChecked()) then
		PowaGlobalMisc[setting] = true;
	else
		PowaGlobalMisc[setting] = false;
	end
end

local function OptionsOK()
	--PowaAuras:DisplayText("OptionsOK");
	PowaMisc.OnUpdateLimit = (100 - PowaOptionsUpdateSlider2:GetValue()) / 200;
	PowaMisc.UserSetMaxTextures = PowaOptionsTextureCount:GetValue();
	if (PowaMisc.OverrideMaxTextures) then
		PowaAuras.MaxTextures = PowaMisc.UserSetMaxTextures;
	else
		PowaAuras.MaxTextures = PowaAuras.TextureCount;
	end
	PowaAuras:EnableChecked();
	PowaAuras:MiscChecked(PowaDebugButton, "Debug");
	PowaAuras:MiscChecked(PowaTimerRoundingButton, "TimerRoundUp");
	PowaAuras:GlobalMiscChecked(PowaBlockIncomingAurasButton, "BlockIncomingAuras");
	local newDefaultTimerTexture = UIDropDownMenu_GetSelectedValue(PowaDropDownDefaultTimerTexture);
	if (newDefaultTimerTexture ~= PowaMisc.DefaultTimerTexture) then
		PowaMisc.DefaultTimerTexture = newDefaultTimerTexture;
		for auraId, aura in pairs(PowaAuras.Auras) do
			if (aura.Timer and aura.Timer.Texture == "Default") then
				aura.Timer:Hide();
				PowaAuras.TimerFrame[auraId] = {};
				PowaAuras:CreateTimerFrame(auraId, 1);
				PowaAuras:CreateTimerFrame(auraId, 2);
			end
		end
	end
	local newDefaultStacksTexture = UIDropDownMenu_GetSelectedValue(PowaDropDownDefaultStacksTexture);
	if (newDefaultStacksTexture ~= PowaMisc.DefaultStacksTexture) then
		PowaMisc.DefaultStacksTexture = newDefaultStacksTexture;
		for auraId, aura in pairs(PowaAuras.Auras) do
			if (aura.Stacks and aura.Stacks.Texture == "Default") then
				aura.Stacks:Hide();
				PowaAuras.StacksFrames[auraId].texture:SetTexture(aura.Stacks:GetTexture());
			end
		end
	end
	PowaGlobalMisc.PathToSounds = PowaCustomSoundPath:GetText();
	PowaGlobalMisc.PathToAuras = PowaCustomAuraPath:GetText();
	PowaAuras.ModTest = false;
	PowaAuras.DoCheck.All = true;
end

local function OptionsCancel()
	--PowaAuras:DisplayText("OptionsCancel");
	PowaAuras.ModTest = false;
	PowaAuras.DoCheck.All = true;
end

local function OptionsDefault()
	for k, v in pairs(PowaAuras.PowaMiscDefault) do
		PowaMisc[k] = v;
	end
	for k, v in pairs(PowaAuras.PowaGlobalMiscDefault) do
		PowaGlobalMisc[k] = v;
	end
	self:DisplayText("Power Aura Options Reset to Defaults");
end

local function OptionsRefresh()
	--PowaAuras:ShowText("OptionsRefresh");
	--PowaAuras:ShowText("OnUpdateLimit=", PowaMisc.OnUpdateLimit);
	--PowaAuras:ShowText("AnimationLimit=", PowaMisc.AnimationLimit);
	--PowaAuras:ShowText("Disabled=", PowaMisc.Disabled ~= false);
	--PowaAuras:ShowText("debug=", PowaMisc.Debug);
	--PowaAuras:ShowText("UserSetMaxTextures=", PowaMisc.UserSetMaxTextures);
	PowaOptionsUpdateSlider2:SetValue(100 - 200 * PowaMisc.OnUpdateLimit);
	PowaOptionsTimerUpdateSlider2:SetValue(100 - 1000 * PowaMisc.AnimationLimit);
	PowaOptionsTextureCount:SetValue(PowaMisc.UserSetMaxTextures);
	PowaOverrideTextureCountButton:SetChecked(PowaMisc.OverrideMaxTextures);
	PowaEnableButton:SetChecked(PowaMisc.Disabled ~= true);
	PowaDebugButton:SetChecked(PowaMisc.Debug);
	PowaTimerRoundingButton:SetChecked(PowaMisc.TimerRoundUp);
	PowaAllowInspectionsButton:SetChecked(PowaMisc.AllowInspections);
	PowaBlockIncomingAurasButton:SetChecked(PowaGlobalMisc.BlockIncomingAuras);
	UIDropDownMenu_SetSelectedValue(PowaDropDownDefaultTimerTexture, PowaMisc.DefaultTimerTexture);
	UIDropDownMenu_SetSelectedValue(PowaDropDownDefaultStacksTexture, PowaMisc.DefaultStacksTexture);
	PowaCustomSoundPath:SetText(PowaGlobalMisc.PathToSounds);
	PowaCustomSoundPath:SetCursorPosition(0)
	PowaCustomAuraPath:SetText(PowaGlobalMisc.PathToAuras);
	PowaCustomAuraPath:SetCursorPosition(0)
end

function PowaOptionsCpuFrame2_OnLoad(panel)
	panel.name = GetAddOnMetadata("PowerAuras", "Title");
	panel.okay = function (self) OptionsOK(); end;
	panel.cancel = function (self) OptionsCancel(); end;
	panel.default = function (self) OptionsDefault(); end;
	panel.refresh = function (self) OptionsRefresh(); end;
	InterfaceOptions_AddCategory(panel);
end

function PowaAuras:PowaOptionsUpdateSliderChanged2(control)
	PowaOptionsUpdateSlider2Text:SetText(self.Text.nomUpdateSpeed..": "..control:GetValue().."%");
end

function PowaAuras:PowaOptionsTimerUpdateSliderChanged2(control)
	PowaOptionsTimerUpdateSlider2Text:SetText(self.Text.nomTimerUpdate..": "..control:GetValue().."%");
end

function PowaAuras:PowaOptionsMaxTexturesSliderChanged(control)
	PowaOptionsTextureCountText:SetText(self.Text.nomTextureCount..": "..control:GetValue());
end

function PowaAuras.DropDownDefaultTimerMenu_Initialize(owner)
	PowaAuras:InitializeTextureDropdown(owner, PowaAuras.DropDownMenu_OnClickDefaultTimer, PowaMisc.DefaultTimerTexture, false);
end

function PowaAuras.DropDownDefaultStacksMenu_Initialize(owner)
	PowaAuras:InitializeTextureDropdown(owner, PowaAuras.DropDownMenu_OnClickDefaultStacks, PowaMisc.DefaultStacksTexture, false);
end

function PowaAuras.DropDownMenu_OnClickDefaultTimer(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	PowaMisc.DefaultTimerTexture = self.value;
end

function PowaAuras.DropDownMenu_OnClickDefaultStacks(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	PowaMisc.DefaultStacksTexture = self.value;
end

function PowaAuras:InitializeTextureDropdown(owner, onClick, currentValue, addDefaultOption)
	--self:ShowText("InitializeTextureDropdown currentValue=", currentValue, " addDefaultOption=", addDefaultOption);
	UIDropDownMenu_SetWidth(owner, 190)
	local info = {func = onClick, owner = owner, text = PowaAuras.Text.Default};
	if (addDefaultOption) then
		UIDropDownMenu_AddButton(info);
	end
	for k, v in pairs(PowaAuras.TimerTextures) do
		info.text = v;
		info.value = v;
		UIDropDownMenu_AddButton(info);
	end
	UIDropDownMenu_SetSelectedValue(owner, currentValue);
end

function PowaAuras.DropDownTimerMenu_Initialize(owner)
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura == nil or aura.Timer == nil) then
		return;
	end
	PowaAuras:InitializeTextureDropdown(owner, PowaAuras.DropDownMenu_OnClickTimerTexture, aura.Timer.Texture, true);
end

function PowaAuras.DropDownMenu_OnClickTimerTexture(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura == nil or aura.Timer == nil) then
		return;
	end
	aura.Timer.Texture = self.value;
	aura.Timer:Dispose();
	--PowaAuras:CreateTimerFrameIfMissing(PowaAuras.CurrentAuraId);
end

function PowaAuras.DropDownStacksMenu_Initialize(owner)
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura == nil or aura.Stacks == nil) then
		return;
	end
	PowaAuras:InitializeTextureDropdown(owner, PowaAuras.DropDownMenu_OnClickStacksTexture, aura.Stacks.Texture, true);
end

function PowaAuras.DropDownMenu_OnClickStacksTexture(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	if (aura == nil or aura.Stacks == nil) then
		return;
	end
	aura.Stacks.Texture = self.value;
	aura.Stacks:Dispose();
end

-- Ternary Logic
function PowaAuras:DisableTernary(control)
	getglobal(control:GetName().."Text"):SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b);
	control:Disable();
end

function PowaAuras:TernarySetState(button, value)
	local label = getglobal(button:GetName().."Text")
	button:Enable();
	label:SetTextColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	if value == 0 then
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:SetChecked(0)
	elseif value == false then
		button:SetCheckedTexture("Interface\\RAIDFRAME\\ReadyCheck-NotReady")
		button:SetChecked(1)
	elseif value == true then
		button:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		button:SetChecked(1)
	end
end

function PowaAuras.Ternary_OnClick(self)
	local aura = PowaAuras.Auras[PowaAuras.CurrentAuraId];
	--PowaAuras:ShowText("Ternary_OnClick control=",self:GetName(), " Parameter=", self.Parameter);
	if (aura[self.Parameter] == 0) then
		aura[self.Parameter] = true; -- Ignore => On
	elseif (aura[self.Parameter] == true) then
		aura[self.Parameter] = false; -- On => Off
	else
		aura[self.Parameter] = 0; -- Off => Ignore
	end	
	PowaAuras:TernarySetState(self, aura[self.Parameter]);
	PowaAuras.Ternary_CheckTooltip(self)
end

function PowaAuras.Ternary_CheckTooltip(button)
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
	GameTooltip:SetText(PowaAuras.Text.TernaryAide[button.Parameter], nil, nil, nil, nil, 1);
	GameTooltip:AddLine(PowaAuras.Text.aideTernary.."\n\124TInterface\\Buttons\\UI-CheckBox-Up:22\124t = "..PowaAuras.Text.nomWhatever.."\n\124TInterface\\Buttons\\UI-CheckBox-Check:22\124t = "..PowaAuras.Text.TernaryYes[button.Parameter].."\n\124TInterface\\RAIDFRAME\\ReadyCheck-NotReady:22\124t = "..PowaAuras.Text.TernaryNo[button.Parameter], .8, .8, .8, 1)
	GameTooltip:Show()
end

function PowaAuras:OptionTest()
	--self:Message("OptionTest for ", self.CurrentAuraId);
	local aura = self.Auras[self.CurrentAuraId];
	local owner = _G["PowaIcone"..self.CurrentAuraId];
	if (not aura or aura.buffname == "" or aura.buffname == " ") then
		return;
	end
	if (aura.Showing) then
		self:SetAuraHideRequest(aura);
		aura.Active = false;
		if (owner ~= nil) then
			owner:SetAlpha(0.33)
		end
	else
		aura:CreateFrames();
		self.SecondaryAuras[aura.id] = nil; -- Force recreate
		self:DisplayAura(aura.id);
		aura.Active = true;
		if (owner ~= nil) then
			owner:SetAlpha(1)
		end
	end
end

function PowaAuras:OptionEditorTest()
	--self:Message("OptionTest for ", self.CurrentAuraId);
	local aura = self.Auras[self.CurrentAuraId];
	if (not aura or aura.buffname == "" or aura.buffname == " ") then
		return;
	end
	if (not aura.Showing) then
		aura.Active = true;
		aura:CreateFrames();
		self.SecondaryAuras[aura.id] = nil; -- Force recreate
		self:DisplayAura(aura.id);
	end
end

function PowaAuras:OptionTestAll()
	PowaAuras:OptionHideAll(true);
	--self:ShowText("Test All Active Frames now=", now);
	for id, aura in pairs(self.Auras) do
		if (not aura.off) then
			aura.Active = true;
			aura:CreateFrames();
			self.SecondaryAuras[aura.id] = nil; -- Force recreate
			self:DisplayAura(aura.id);
		end
	end
	
end

function PowaAuras:OptionHideAll(now) -- Hide all auras
	--self:ShowText("Hide All Frames now=", now);
	for id, aura in pairs(self.Auras) do
		aura.Active = false;
		self:ResetDragging(aura, self.Frames[aura.id]);
		if now then
			--self:ShowText("Hide aura id=", id);
			aura:Hide();
			if (aura.Timer) then aura.Timer:Hide(); end
			if (aura.Stacks) then aura.Stacks:Hide(); end
		else
			self:SetAuraHideRequest(aura);
			if (aura.Timer) then aura.Timer.HideRequest = true; end
		end
	end
	--PowaBarConfigFrame:Hide();
end

function PowaAuras:RedisplayAuras()
	for id, aura in pairs(self.Auras) do
		aura.Active = false;
		if (aura.Showing) then
			aura:Hide();
			if (aura.Timer) then aura.Timer:Hide(); end
			if (aura.Stacks) then aura.Stacks:Hide(); end
			aura.Active = true;
			aura:CreateFrames();
			self.SecondaryAuras[aura.id] = nil; -- Force recreate
			self:DisplayAura(aura.id);
		end
	end
end

function PowaAuras:SetLockButtonText()
	if (PowaMisc.Locked) then
		PowaMainLockButtonText:SetText(PowaAuras.Text.nomUnlock);
	else
		PowaMainLockButtonText:SetText(PowaAuras.Text.nomLock);
	end
end

function PowaAuras:ToggleLock()
	PowaMisc.Locked = not PowaMisc.Locked;
	self:SetLockButtonText();
	self:RedisplayAuras();
end

function PowaAuras:RedisplayAura(auraId) --Re-show aura after options changed
	if (not (self.VariablesLoaded and self.SetupDone)) then return; end
	local aura = self.Auras[auraId];
	if (not aura) then
		return;
	end
	--self:ShowText("RedisplayAura auraId=", aura.id, " showing=", aura.Showing);
	local showing = aura.Showing;
	aura:Hide();
	aura.BeginAnimation = nil;
	aura.MainAnimation = nil;
	aura.EndAnimation = nil;
	aura:CreateFrames();
	self.SecondaryAuras[aura.id] = nil; -- Force recreate
	if (showing) then
		self:DisplayAura(aura.id);
	end
end

function PowaAuras:ResetSlotsToEmpty()
	for null, child in ipairs({ PowaEquipmentSlotsFrame:GetChildren() }) do
		--self:Message(child:GetName(), " ", child:GetObjectType());
		if (child:IsObjectType("Button")) then
			local slotName = string.gsub(child:GetName(), "Powa", "");
			if (string.match(slotName, "Slot")) then
				local slotId, emptyTexture = GetInventorySlotInfo(slotName);
				getglobal(child:GetName().."IconTexture"):SetTexture(emptyTexture);
				child.SlotId = slotId;
				child.Set = false;
				child.EmptyTexture = emptyTexture;
			end
		end
	end
end

function PowaAuras:EquipmentSlotsShow()
	self:ResetSlotsToEmpty();
	local aura = self.Auras[self.CurrentAuraId];
	if (not aura) then
		return;
	end
	for pword in string.gmatch(aura.buffname, "[^/]+") do
		pword = aura:Trim(pword);
		if (string.len(pword) > 0 and pword ~= "???") then
			local slotId = GetInventorySlotInfo(pword.."Slot");
			--PowaAuras:Message("pword=",pword, " slotId= ",slotId);
			if (slotId) then
				local ok, texture = pcall(GetInventoryItemTexture, "player", slotId);
				if (not ok) then
					self:Message("Slot definitions are invalid!");
					self:ResetSlotsToEmpty();
					aura.buffname = "";
					return;
				end
				if (texture ~= nil) then
					getglobal("Powa"..pword.."SlotIconTexture"):SetTexture(texture);
					getglobal("Powa"..pword.."Slot").Set = true;
				end
			end
		end
	end
end

function PowaAuras:EquipmentSlotsHide()

end

function PowaAuras:EquipmentSlot_OnClick(slotButton)
	if (not slotButton.SlotId) then
		return;
	end
	local aura = self.Auras[self.CurrentAuraId];
	if (not aura) then
		return;
	end
	if (slotButton.Set) then
		getglobal(slotButton:GetName().."IconTexture"):SetTexture(slotButton.EmptyTexture);
		slotButton.Set = false;
	else
		local texture = GetInventoryItemTexture("player", slotButton.SlotId);
		if (texture ~= nil) then
			getglobal(slotButton:GetName().."IconTexture"):SetTexture(texture);
			slotButton.Set = true;
		end
	end
	aura.buffname = "";
	local sep = "";
	for null, child in ipairs({ PowaEquipmentSlotsFrame:GetChildren() }) do
		--self:Message(child:GetName(), " ", child:GetObjectType());
		if (child:IsObjectType("Button")) then
			local slotName = string.gsub(child:GetName(), "Powa", "");
			if (string.match(slotName, "Slot")) then
				if (child.Set) then
					aura.buffname = aura.buffname..sep..string.gsub(slotName, "Slot", "");
					sep = "/";
				end
			end
		end
	end
	--self:Message("aura.buffname=", aura.buffname);
end

function PowaAuras.OnMouseWheel(self, delta)
	if delta > 0 then
		self:SetValue(self:GetValue() + self:GetValueStep());
	else
		self:SetValue(self:GetValue() - self:GetValueStep());
	end
end

function PowaAuras.OnMouseUpX(self)
	local frame = self:GetName();
	self:SetMinMaxValues(self:GetValue() - 700, self:GetValue() + 700);
	_G[frame.."Low"]:SetText(self:GetValue() - 700);
	_G[frame.."High"]:SetText(self:GetValue() + 700);
end

function PowaAuras.OnMouseUpY(self)
	local frame = self:GetName();
	self:SetMinMaxValues(self:GetValue() - 400, self:GetValue() + 400);
	_G[frame.."Low"]:SetText(self:GetValue() - 400);
	_G[frame.."High"]:SetText(self:GetValue() + 400);
end