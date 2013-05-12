local math, min, max, floor, random, fmod, ceil, log10, table, insert, pairs = math, min, max, floor, random, fmod, ceil, log10, table, insert, pairs;

cPowaStacks = PowaClass(function(stacker, aura, base)
	for k, v in pairs (cPowaStacks.ExportSettings) do
		if (base and base[k] ~= nil) then
			stacker[k] = base[k];
		else
			stacker[k] = v;
		end
	end
	stacker.Showing = false;
	stacker.id = aura.id;
end);

-- This is the set of values that will be exported with their default values
-- Be very careful if you change this as it may break old exports, adding new values is safe
-- Stings must always be set as at least an empty string
-- Numbers an booleans can be set interchangable (e.g. for tri-states)
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
	LegacySizing = true,
}

function cPowaStacks:CreateAuraString()
	local tempstr = "";
	for k, default in pairs(self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("stacks.", k, self[k], default);
	end
	return tempstr;
end

function cPowaStacks:IsRelative()
	return (self.Relative and self.Relative ~= "NONE");
end

function cPowaStacks:GetTexture()
	local texture = PowaMisc.DefaultStacksTexture;
	if (self.Texture ~= "Default") then
		texture = self.Texture;
	end
	local postfix = "";
	if (self.Transparent) then
		postfix = "Transparent";
	end
	return "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix..".tga";
end

function cPowaStacks:ShowValue(aura, newvalue)
	local frame = PowaAuras.StacksFrames[self.id];
	if (frame == nil or newvalue == nil) then
		return;
	end
	--PowaAuras:ShowText("Stacks Showvalue id=", self.id, " newvalue=", newvalue);
	if (PowaAuras.ModTest) then
		newvalue = math.random(0,25000);
	end
	-- Create textures dynamically to support > 9 stacks.
	local texcount = #(frame.textures);
	local unitcount = (newvalue == 0 and 1 or (floor(math.log10(newvalue)) + 1));
	local tStep = PowaAuras.Tstep;
	local w = (self.LegacySizing and 20 or 10);
	for i = 1, (texcount > unitcount and texcount or unitcount) do
		-- Make textures if needed.
		if(not frame.textures[i]) then
			-- PowaAuras:ShowText("StacksTexture=", i, ", texcount=", texcount, ", unitcount=", unitcount);
			table.insert(frame.textures, i, frame:CreateTexture(nil, "BACKGROUND"));
			frame.textures[i]:SetTexture(self:GetTexture());
			-- Increment texcount to be more accurate.
			texcount = texcount + 1;
		end
		-- Update blending modes.
		if (aura.texmode == 1) then
			frame.textures[i]:SetBlendMode("ADD");
		else
			frame.textures[i]:SetBlendMode("DISABLE");
		end
		if (self.UseOwnColor) then
			frame.textures[i]:SetVertexColor(self.r,self.g,self.b);
		else
			local auraTexture = PowaAuras.Textures[self.id];
			if (auraTexture) then
				if auraTexture:GetObjectType() == "Texture" then
					frame.textures[i]:SetVertexColor(auraTexture:GetVertexColor());
				elseif auraTexture:GetObjectType() == "FontString" then
					frame.textures[i]:SetVertexColor(auraTexture:GetTextColor());
				end
			else
				frame.textures[i]:SetVertexColor(aura.r,aura.g,aura.b);
			end
		end
		-- Update positions.
		if(i > unitcount) then
			-- This one isn't being displayed.
			frame.textures[i]:Hide();
		else
			-- Show and position it accordingly.
			frame.textures[i]:Show();
			frame.textures[i]:ClearAllPoints();
			frame.textures[i]:SetPoint("RIGHT", frame, "RIGHT", - ((i - 1) * (w * self.h)) + (((unitcount - 2) * (w * self.h)) / 2), 0);
			frame.textures[i]:SetWidth((w * self.h));
			frame.textures[i]:SetHeight((20 * self.h));
			-- Set the texture coordinates.
			frame.textures[i]:SetTexCoord(tStep , tStep * 1.5, tStep * (newvalue % 10), tStep * ((newvalue % 10) + 1));
			-- PowaAuras:ShowText("Show stacks: ", (newvalue % 10), " (", newvalue, ")");
			-- Divide newvalue by 10 so it's correct for the next one.
			newvalue = floor(newvalue / 10);
		end
	end
	if (not frame:IsVisible()) then
		--PowaAuras:Message("Show Stacks Frame for ", self.id);
		frame:Show();
	end
	if (self.UpdatePing and frame.PingAnimationGroup) then
		--PowaAuras:ShowText("Stacks UpdatePing");
		frame.PingAnimationGroup:Play();
	end
end

function cPowaStacks:SetStackCount(count)
	--PowaAuras:UnitTestInfo("SetStackCount Id=",self.id," Count=",count);
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then
		--PowaAuras:UnitTestInfo("Stacks aura missing");
		--PowaAuras:Message("Stacks aura missing");
		return;
	end
	if (self.enabled == false or aura.InactiveDueToMulti) then
		--PowaAuras:UnitTestInfo("Stacks disabled");
		--if (aura.Debug) then
		--PowaAuras:DisplayText("Stacks disabled");
		--end
		return;
	end
	if (aura.Debug) then
		PowaAuras:DisplayText("SetStackCount Id=", self.id, " Count=", count);
	end
	if (not count or count == 0) then
		local frame = PowaAuras.StacksFrames[self.id];
		if (frame and frame:IsVisible()) then
			frame:Hide();
		end
		self.Showing = false;
		return;
	end
	if (self.lastShownValue == count and self.Showing) then
		self.UpdateValueTo = nil;
		if (aura.Debug) then
			PowaAuras:DisplayText("Stacks unchanged");
		end
		return;
	end
	self.UpdateValueTo = count;
end

function cPowaStacks:Update()
	if (not self.UpdateValueTo) then return; end
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then return;end
	if (aura.Debug) then
		PowaAuras:DisplayText("Stacks Update UpdateValueTo=",self.UpdateValueTo);
	end
	self.lastShownValue = self.UpdateValueTo;
	PowaAuras:CreateStacksFrameIfMissing(self.id, self.UpdatePing);
	self:ShowValue(aura, self.UpdateValueTo);
	self.Showing = true;
	self.UpdateValueTo = nil;
end

function cPowaStacks:Hide()
	--PowaAuras:ShowText("Hide Stacks Frame for ", self.id, " ", self.Showing, " ", PowaAuras.StacksFrames[self.id]);
	if (not self.Showing) then return; end
	if (PowaAuras.StacksFrames[self.id]) then
		PowaAuras.StacksFrames[self.id]:Hide();
	end
	self.Showing = false;
	self.UpdateValueTo = nil;
	self.lastShownValue = nil;
end

function cPowaStacks:Dispose()
	self:Hide();
	PowaAuras:Dispose("StacksFrames", self.id);
end

-- Timer
cPowaTimer = PowaClass(function(timer, aura, base)
	for k, v in pairs (cPowaTimer.ExportSettings) do
		if (base and base[k] ~= nil) then
			timer[k] = base[k];
		else
			timer[k] = v;
		end
	end
	timer.Showing = false;
	timer.id = aura.id;
	timer:SetShowOnAuraHide(aura);
	--for k,v in pairs (timer) do
	--PowaAuras:ShowText("  "..tostring(k).."="..tostring(v));
	--end
end);

-- This is the set of values that will be exported with their default values
-- Be very careful if you change this as it may break many old exports
-- Stings must always be set as at least an empty string
-- Numbers an booleans can be set interchangable (e.g. for tri-states)
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
	local tempstr = "";
	for k, default in pairs (self.ExportSettings) do
		tempstr = tempstr..PowaAuras:GetSettingForExport("timer.", k, self[k], default);
	end
	return tempstr;
end

function cPowaTimer:SetShowOnAuraHide(aura)
	--PowaAuras:Message("CTR Timer id=", aura.id);
	--PowaAuras:Message("CooldownAura=", aura.CooldownAura);
	--PowaAuras:Message("inverse=", aura.inverse);
	--PowaAuras:Message("CanHaveTimer=", aura.CanHaveTimer);
	--PowaAuras:Message("CanHaveTimerOnInverse=", aura.CanHaveTimerOnInverse);
	--PowaAuras:Message("ShowActivation=", self.ShowActivation);
	self.ShowOnAuraHide = self.ShowActivation ~= true and ((aura.CooldownAura and (not aura.inverse and aura.CanHaveTimer)) or (not aura.CooldownAura and (aura.inverse and aura.CanHaveTimerOnInverse)));
	--PowaAuras:Message("ShowOnAuraHide=", self.ShowOnAuraHide);
end

function cPowaTimer:IsRelative()
	return (self.Relative and self.Relative ~= "NONE");
end

function cPowaTimer:GetTexture()
	local texture = PowaMisc.DefaultTimerTexture;
	if (self.Texture ~= "Default") then
		texture = self.Texture;
	end
	local postfix = "";
	if (self.Transparent) then
		postfix = "Transparent";
	end
	texture = "Interface\\Addons\\PowerAuras\\TimerTextures\\"..texture.."\\Timers"..postfix..".tga";
	--PowaAuras:ShowText("Timer texture: ", texture);
	return texture;
end

function cPowaTimer:Update(elapsed)
	--PowaAuras:UnitTestInfo("Timer.Update ",self.id);
	local aura = PowaAuras.Auras[self.id];
	if (aura == nil) then
		--PowaAuras:UnitTestInfo("Timer aura missing");
		if (PowaAuras.DebugCycle) then
			PowaAuras:DisplayText("Timer aura missing for id=", self.id);
		end
		return;
	end
	if (PowaAuras.DebugCycle) then
		PowaAuras:DisplayText("Timer.Update ",self.id);
	end
	if (self.enabled == false and aura.InvertAuraBelow == 0) then
		--PowaAuras:UnitTestInfo("Timer disabled");
		if (PowaAuras.DebugCycle) then
			PowaAuras:DisplayText("Timer disabled");
		end
		return;
	end
	local newvalue = 0;
	if (PowaAuras.DebugCycle) then
		PowaAuras:DisplayText("newvalue=",newvalue);
	end
	-- Determine the value to display in the timer
	if (PowaAuras.ModTest) then
		newvalue = math.random(0, 99) + (math.random(0, 99) / 100);
	elseif (self.ShowActivation and self.Start ~= nil) then
		newvalue = math.max(GetTime() - self.Start, 0);
	elseif (aura.timerduration > 0) then -- if a user defined timer is active for the aura override the rest
		if (((aura.target or aura.targetfriend) and (PowaAuras.ResetTargetTimers == true)) or not self.CustomDuration) then
			self.CustomDuration = aura.timerduration;
		else
			self.CustomDuration = math.max(self.CustomDuration - elapsed, 0);
		end
		newvalue = self.CustomDuration;
	else
		if (self.DurationInfo and self.DurationInfo > 0) then
			newvalue = math.max(self.DurationInfo - GetTime(), 0);
		end
		aura:CheckTimerInvert();
	end
	if (PowaAuras.DebugCycle) then
		PowaAuras:Message("newvalue=", newvalue); -- OK
	end
	--PowaAuras:UnitTestInfo("Timer newvalue", newvalue);
	--PowaAuras:ShowText("Timer newvalue=", newvalue, " elapsed=", elapsed);
	if (self.enabled == false or (aura.ForceTimeInvert and aura.InvertTimeHides)) then
		--PowaAuras:UnitTestInfo("Timer disabled");
		--PowaAuras:ShowText("Timer disabled");
		return;
	end
	if (newvalue and newvalue > 0) then -- Time has value to display
		PowaAuras:CreateTimerFrameIfMissing(self.id, self.UpdatePing);
		local split = 60;
		if (self.Seconds99) then
			split = 100;
		end
		if (PowaAuras.DebugCycle) then
			PowaAuras:Message("cents=", self.cents); -- OK
		end
		if (self.cents) then
			local small;
			if (newvalue > split) then
				small = math.fmod(newvalue, 60); -- Seconds (large = minutes)
			else
				small = (newvalue - math.floor(newvalue)) * 100; -- Hundredths of a second (large = seconds)
			end
			if (PowaMisc.TimerRoundUp) then
				small = math.ceil(small);
			end
			if (PowaAuras.DebugCycle) then
				PowaAuras:Message("small=",small); -- OK
			end
			if (self.lastShownSmall ~= small) then
				self:ShowValue(aura, 2, small);
				self.lastShownSmall = small;
			end
		end
		local large = newvalue;
		if (newvalue > split) then
			large = newvalue / 60;
		end
		large = math.min(99.00, large);
		if ((not self.cents) and PowaMisc.TimerRoundUp) then
			large = math.ceil(large);
		else
			large = math.floor(large);
		end
		if (PowaAuras.DebugCycle) then
			PowaAuras:Message("large=",large); -- OK
		end
		if (self.lastShownLarge ~= large) then
			self:ShowValue(aura, 1, large);
			self.lastShownLarge = large;
		end
		self.Showing = true;
	elseif (self.Showing) then
		if (PowaAuras.DebugCycle) then
			PowaAuras:Message("HideTimerFrames"); -- OK
		end
		self:Hide();
		PowaAuras:TestThisEffect(self.id);
	end
end

function cPowaTimer:SetDurationInfo(endtime)
	if (self.DurationInfo ~= endtime) then
		self.DurationInfo = endtime;
		--PowaAuras:ShowText("Timer refresh ", self.id, " DurationInfo", self.DurationInfo, " time=", self.DurationInfo - GetTime());
		if (PowaAuras.TimerFrame[self.id]) then
			for frameIndex = 1,2 do
				local timerFrame = PowaAuras.TimerFrame[self.id][frameIndex];
				if (timerFrame and self.UpdatePing and timerFrame.PingAnimationGroup) then
					--PowaAuras:ShowText("Timer UpdatePing");
					timerFrame.PingAnimationGroup:Play();
				end
			end
		end
	end
end

function cPowaTimer:ExtractDigits(displayValue)
	local deci = math.floor(displayValue / 10);
	local uni = math.floor(displayValue - (deci * 10))
	return deci, uni;
end

function cPowaTimer:ShowValue(aura, frameIndex, displayValue)
	if (PowaAuras.TimerFrame == nil) then return; end
	if (PowaAuras.TimerFrame[self.id] == nil) then return; end
	local timerFrame = PowaAuras.TimerFrame[self.id][frameIndex];
	if (timerFrame == nil) then return; end
	if (aura.texmode == 1) then
		timerFrame.texture:SetBlendMode("ADD");
	else
		timerFrame.texture:SetBlendMode("DISABLE");
	end
	if (self.UseOwnColor) then
		timerFrame.texture:SetVertexColor(self.r,self.g,self.b);
	else
		local auraTexture = PowaAuras.Textures[self.id];
		if (auraTexture) then
			if auraTexture:GetObjectType() == "Texture" then
				timerFrame.texture:SetVertexColor(auraTexture:GetVertexColor());
			elseif auraTexture:GetObjectType() == "FontString" then
				timerFrame.texture:SetVertexColor(auraTexture:GetTextColor());
			end
		else
			timerFrame.texture:SetVertexColor(aura.r,aura.g,aura.b);
		end
	end
	local deci, uni = self:ExtractDigits(displayValue);
	--PowaAuras:ShowText("Show timer: ",deci, " ", uni, " ", PowaAuras.Auras[k].Timer.HideLeadingZeros);
	local tStep = PowaAuras.Tstep;
	if (deci == 0 and self.HideLeadingZeros) then
		timerFrame.texture:SetTexCoord(tStep , tStep * 1.5, tStep * uni, tStep * (uni + 1));
	else
		timerFrame.texture:SetTexCoord(tStep * uni, tStep * (uni + 1), tStep * deci, tStep * (deci + 1));
	end
	if (not timerFrame:IsVisible()) then
		if (aura.Debug) then
			PowaAuras:DisplayText("Show timer frame id=", self.id, " index=", frameIndex);
		end
		timerFrame:Show(); -- Timer Frame
	end
	--PowaAuras:ShowText("Show #3 ", k, " ", i, " ", j, " ", seconds);
	--PowaAuras:ShowText("deci=", deci, " uni=", uni);
end

function cPowaTimer:HideFrame(i)
	if (PowaAuras.TimerFrame[self.id] and PowaAuras.TimerFrame[self.id][i]) then
		--PowaAuras:ShowText("Hide Timer Frame ", i," for ", self.id);
		PowaAuras.TimerFrame[self.id][i]:Hide();
	end
end

function cPowaTimer:Hide()
	if (not self.Showing) then return; end
	if PowaAuras.TimerFrame[self.id] then
		self:HideFrame(1);
		self:HideFrame(2);
	end
	self.lastShownLarge = nil;
	self.lastShownSmall = nil;
	self.Showing = false;
	--PowaAuras:ShowText("Hide timer frame");
end

function cPowaTimer:Dispose()
	self:Hide();
	PowaAuras:Dispose("TimerFrame", self.id, 1);
	PowaAuras:Dispose("TimerFrame", self.id, 2);
	PowaAuras:Dispose("TimerFrame", self.id);
end