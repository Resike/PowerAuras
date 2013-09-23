local math, table, pairs = math, table, pairs

cPowaStacks = PowaClass(function(stacker, aura, base)
	for k, v in pairs(cPowaStacks.ExportSettings) do
		if base and base[k] ~= nil then
			stacker[k] = base[k]
		else
			stacker[k] = v
		end
	end
	stacker.Showing = false
	stacker.id = aura.id
end)

cPowaStacks.ExportSettings = {
	enabled = false,
	x = 0,
	y = 0,
	a = 1.0,
	h = 1.0,
	Transparent = false,
	HideLeadingZeros = false,
	UpdatePing = false,
	Texture = "Default",
	Relative = "NONE",
	UseOwnColor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0,
	LegacySizing = false
}

function cPowaStacks:CreateAuraString()
	local tempstr = ""
	for k, default in pairs(self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("stacks.", k, self[k], default)
	end
	return tempstr
end

function cPowaStacks:IsRelative()
	return self.Relative and self.Relative ~= "NONE"
end

function cPowaStacks:GetTexture()
	local texture = PowaMisc.DefaultStacksTexture
	if self.Texture ~= "Default" then
		texture = self.Texture
	end
	local postfix = ""
	if self.Transparent then
		postfix = "Transparent"
	end
	return "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix
end

function cPowaStacks:ShowValue(aura, newvalue)
	local frame = PowaAuras.StacksFrames[self.id]
	if not frame or not newvalue then
		return
	end
	if PowaAuras.ModTest then
		newvalue = math.random(0, 99)
	end
	local texcount = #frame.textures
	local unitcount = (newvalue == 0 and 1 or (floor(math.log10(newvalue)) + 1))
	local tStep = PowaAuras.Tstep
	local w = (self.LegacySizing and 20 or 10)
	for i = 1, (texcount > unitcount and texcount or unitcount) do
		if not frame.textures[i] then
			table.insert(frame.textures, i, frame:CreateTexture(nil, "BACKGROUND"))
			frame.textures[i]:SetTexture(self:GetTexture())
			texcount = texcount + 1
		end
		if aura.texmode == 1 then
			frame.textures[i]:SetBlendMode("Add")
		else
			frame.textures[i]:SetBlendMode("Disable")
		end
		if self.UseOwnColor then
			frame.textures[i]:SetVertexColor(self.r, self.g, self.b)
		else
			local auraTexture = PowaAuras.Textures[self.id]
			if auraTexture then
				if auraTexture:GetObjectType() == "Texture" then
					frame.textures[i]:SetVertexColor(auraTexture:GetVertexColor())
				elseif auraTexture:GetObjectType() == "FontString" then
					frame.textures[i]:SetVertexColor(auraTexture:GetTextColor())
				end
			else
				frame.textures[i]:SetVertexColor(aura.r, aura.g, aura.b)
			end
		end
		if i > unitcount then
			frame.textures[i]:Hide()
		else
			local leftOffset, rightOffset
			if aura.Stacks.Texture == "AccidentalPresidency" then
				leftOffset = 0.0015
				rightOffset = 0.0015
			elseif aura.Stacks.Texture == "Crystal" then
				leftOffset = 0
				rightOffset = 0.0032
			elseif aura.Stacks.Texture == "Digital" then
				leftOffset = - 0.0010
				rightOffset = 0.0032
			elseif aura.Stacks.Texture == "Monofonto" then
				leftOffset = 0
				rightOffset = 0.0010
			elseif aura.Stacks.Texture == "OCR" then
				leftOffset = - 0.0015
				rightOffset = - 0.0028
			elseif aura.Stacks.Texture == "WhiteRabbit" then
				leftOffset = 0.0002
				rightOffset = 0.0014
			else
				leftOffset = 0
				rightOffset = 0
			end
			frame.textures[i]:Show()
			frame.textures[i]:ClearAllPoints()
			frame.textures[i]:SetPoint("RIGHT", frame, "RIGHT", - ((i - 1) * (w * self.h)) + (((unitcount - 2) * (w * self.h)) / 2), 0)
			frame.textures[i]:SetWidth((w * self.h))
			frame.textures[i]:SetHeight((20 * self.h))
			frame.textures[i]:SetTexCoord(tStep + leftOffset, (tStep * 1.5) + rightOffset, tStep * (newvalue % 10), tStep * ((newvalue % 10) + 1))
			newvalue = floor(newvalue / 10)
		end
	end
	if not frame:IsVisible() then
		frame:Show()
	end
	if self.UpdatePing and frame.PingAnimationGroup then
		frame.PingAnimationGroup:Play()
	end
end

function cPowaStacks:SetStackCount(count)
	local aura = PowaAuras.Auras[self.id]
	if aura == nil then
		return
	end
	if self.enabled == false or aura.InactiveDueToMulti then
		return
	end
	if not count or count == 0 then
		local frame = PowaAuras.StacksFrames[self.id]
		if frame and frame:IsVisible() then
			frame:Hide()
		end
		self.Showing = false
		return
	end
	if self.lastShownValue == count and self.Showing then
		self.UpdateValueTo = nil
		return
	end
	self.UpdateValueTo = count
end

function cPowaStacks:Update()
	if not self.UpdateValueTo then
		return
	end
	local aura = PowaAuras.Auras[self.id]
	if aura == nil then
		return
	end
	self.lastShownValue = self.UpdateValueTo
	PowaAuras:CreateStacksFrameIfMissing(self.id, self.UpdatePing)
	self:ShowValue(aura, self.UpdateValueTo)
	self.Showing = true
	self.UpdateValueTo = nil
end

function cPowaStacks:Hide()
	if not self.Showing then
		return
	end
	if PowaAuras.StacksFrames[self.id] then
		PowaAuras.StacksFrames[self.id]:Hide()
	end
	self.Showing = false
	self.UpdateValueTo = nil
	self.lastShownValue = nil
end

function cPowaStacks:Dispose()
	self:Hide()
	PowaAuras:Dispose("StacksFrames", self.id)
end

-- Timer
cPowaTimer = PowaClass(function(timer, aura, base)
	for k, v in pairs (cPowaTimer.ExportSettings) do
		if base and base[k] ~= nil then
			timer[k] = base[k]
		else
			timer[k] = v
		end
	end
	timer.Showing = false
	timer.id = aura.id
	timer:SetShowOnAuraHide(aura)
end)

cPowaTimer.ExportSettings = {
	enabled = false,
	x = 0,
	y = 0,
	a = 1.0,
	h = 1.0,
	cents = true,
	Transparent = false,
	HideLeadingZeros = false,
	UpdatePing = false,
	ShowActivation = false,
	Seconds99 = false,
	Texture = "Default",
	Relative = "NONE",
	UseOwnColor = false,
	r = 1.0,
	g = 1.0,
	b = 1.0
}

function cPowaTimer:CreateAuraString()
	local tempstr = ""
	for k, default in pairs(self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("timer.", k, self[k], default)
	end
	return tempstr
end

function cPowaTimer:SetShowOnAuraHide(aura)
	self.ShowOnAuraHide = self.ShowActivation ~= true and ((aura.CooldownAura and (not aura.inverse and aura.CanHaveTimer)) or (not aura.CooldownAura and (aura.inverse and aura.CanHaveTimerOnInverse)))
end

function cPowaTimer:IsRelative()
	return self.Relative and self.Relative ~= "NONE"
end

function cPowaTimer:GetTexture()
	local texture = PowaMisc.DefaultTimerTexture
	if self.Texture ~= "Default" then
		texture = self.Texture
	end
	local postfix = ""
	if self.Transparent then
		postfix = "Transparent"
	end
	texture = "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix
	return texture
end

function cPowaTimer:Update(elapsed)
	local aura = PowaAuras.Auras[self.id]
	if not aura then
		return
	end
	if self.enabled == false and aura.InvertAuraBelow == 0 then
		return
	end
	local newvalue = 0
	if PowaAuras.ModTest then
		newvalue = math.random(0, 99) + (math.random(1, 99) / 100)
	elseif self.ShowActivation and self.Start ~= nil then
		newvalue = math.max(GetTime() - self.Start, 0)
	elseif aura.timerduration > 0 then
		if ((aura.target or aura.targetfriend) and PowaAuras.ResetTargetTimers == true) or not self.CustomDuration then
			self.CustomDuration = aura.timerduration
		else
			self.CustomDuration = math.max(self.CustomDuration - elapsed, 0)
		end
		newvalue = self.CustomDuration
	else
		if self.DurationInfo and self.DurationInfo > 0 then
			newvalue = math.max(self.DurationInfo - GetTime(), 0)
		end
		aura:CheckTimerInvert()
	end
	if self.enabled == false or (aura.ForceTimeInvert and aura.InvertTimeHides) then
		return
	end
	if newvalue and newvalue > 0 then
		PowaAuras:CreateTimerFrameIfMissing(self.id, self.UpdatePing)
		local split = 60
		if self.Seconds99 then
			split = 100
		end
		if self.cents then
			local small
			if newvalue > split then
				small = math.fmod(newvalue, 60) -- Seconds (large = minutes)
			else
				small = (newvalue - math.floor(newvalue)) * 100 -- Hundredths of a second (large = seconds)
			end
			if PowaMisc.TimerRoundUp then
				small = math.ceil(small)
			end
			if PowaAuras.DebugCycle then
				PowaAuras:Message("small = ", small)
			end
			if self.lastShownSmall ~= small then
				self:ShowValue(aura, 2, small)
				self.lastShownSmall = small
			end
		end
		local large = newvalue
		if newvalue > split then
			large = newvalue / 60
		end
		large = math.min(99.00, large)
		if not self.cents and PowaMisc.TimerRoundUp then
			large = math.ceil(large)
		else
			large = math.floor(large)
		end
		if self.lastShownLarge ~= large then
			self:ShowValue(aura, 1, large)
			self.lastShownLarge = large
		end
		self.Showing = true
	elseif self.Showing then
		self:Hide()
		PowaAuras:TestThisEffect(self.id)
	end
end

function cPowaTimer:SetDurationInfo(endtime)
	if self.DurationInfo ~= endtime then
		self.DurationInfo = endtime
		if PowaAuras.TimerFrame[self.id] then
			for frameIndex = 1, 2 do
				local timerFrame = PowaAuras.TimerFrame[self.id][frameIndex]
				if timerFrame and self.UpdatePing and timerFrame.PingAnimationGroup then
					timerFrame.PingAnimationGroup:Play()
				end
			end
		end
	end
end

function cPowaTimer:ExtractDigits(displayValue)
	local deci = math.floor(displayValue / 10)
	local uni = math.floor(displayValue - (deci * 10))
	return deci, uni
end

function cPowaTimer:ShowValue(aura, frameIndex, displayValue)
	if PowaAuras.TimerFrame == nil then
		return
	end
	if PowaAuras.TimerFrame[self.id] == nil then
		return
	end
	local timerFrame = PowaAuras.TimerFrame[self.id][frameIndex]
	if not timerFrame then
		return
	end
	if aura.texmode == 1 then
		timerFrame.texture:SetBlendMode("Add")
	else
		timerFrame.texture:SetBlendMode("Disable")
	end
	if self.UseOwnColor then
		timerFrame.texture:SetVertexColor(self.r, self.g, self.b)
	else
		local auraTexture = PowaAuras.Textures[self.id]
		if auraTexture then
			if auraTexture:GetObjectType() == "Texture" then
				timerFrame.texture:SetVertexColor(auraTexture:GetVertexColor())
			elseif auraTexture:GetObjectType() == "FontString" then
				timerFrame.texture:SetVertexColor(auraTexture:GetTextColor())
			end
		else
			timerFrame.texture:SetVertexColor(aura.r, aura.g, aura.b)
		end
	end
	local deci, uni = self:ExtractDigits(displayValue)
	local tStep = PowaAuras.Tstep
	local leftOffset, rightOffset
	if aura.Timer.Texture == "AccidentalPresidency" then
		leftOffset = 0.0015
		rightOffset = 0.0015
	elseif aura.Timer.Texture == "Crystal" then
		leftOffset = 0
		rightOffset = - 0.0010
	elseif aura.Timer.Texture == "Digital" then
		leftOffset = - 0.0010
		rightOffset = - 0.0030
	elseif aura.Timer.Texture == "Monofonto" then
		leftOffset = 0
		rightOffset = 0
	elseif aura.Timer.Texture == "OCR" then
		leftOffset = - 0.0015
		rightOffset = - 0.0028
	elseif aura.Timer.Texture == "WhiteRabbit" then
		leftOffset = 0.0002
		rightOffset = - 0.0010
	else
		leftOffset = 0
		rightOffset = 0
	end
	if deci == 0 and self.HideLeadingZeros then
		timerFrame.texture:SetTexCoord(tStep + leftOffset, (tStep * 1.5) + rightOffset, tStep * uni, tStep * (uni + 1))
	else
		timerFrame.texture:SetTexCoord((tStep * uni) + leftOffset, (tStep * (uni + 1)) + rightOffset, tStep * deci, tStep * (deci + 1))
	end
	if not timerFrame:IsVisible() then
		timerFrame:Show()
	end
end

function cPowaTimer:HideFrame(i)
	if PowaAuras.TimerFrame[self.id] and PowaAuras.TimerFrame[self.id][i] then
		PowaAuras.TimerFrame[self.id][i]:Hide()
	end
end

function cPowaTimer:Hide()
	if not self.Showing then
		return
	end
	if PowaAuras.TimerFrame[self.id] then
		self:HideFrame(1)
		self:HideFrame(2)
	end
	self.lastShownLarge = nil
	self.lastShownSmall = nil
	self.Showing = false
end

function cPowaTimer:Dispose()
	self:Hide()
	PowaAuras:Dispose("TimerFrame", self.id, 1)
	PowaAuras:Dispose("TimerFrame", self.id, 2)
	PowaAuras:Dispose("TimerFrame", self.id)
end