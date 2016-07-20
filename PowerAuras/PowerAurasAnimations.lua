local _, ns = ...
local PowaAuras = ns.PowaAuras

local cos = cos
local math = math
local sin = sin

function PowaAuras:CalculateDurations(speed)
	-- Speed ranges from 0.05 to 2
	-- First duration is then 1.225 to 0.25
	-- Second duration is then 30 to 0.25
	return 1.25 - speed / 2, 1.526 / math.max(speed, 0.05) - 0.513
end

function PowaAuras:AddBeginAnimation(aura, frame)
	if not aura.begin or aura.begin == PowaAuras.AnimationBeginTypes.None then
		return nil
	end
	local animationGroup = frame:CreateAnimationGroup("Begin")
	--animationGroup:SetIgnoreFramerateThrottle(true)
	animationGroup.aura = aura
	animationGroup:SetScript("OnFinished", function(self, forced)
		local aura = self.aura
		if aura and aura.MainAnimation then
			aura.MainAnimation:Play()
			local secondaryAura = PowaAuras.SecondaryAuras[aura.id]
			if secondaryAura then
				local secondaryFrame = PowaAuras.SecondaryFrames[aura.id]
				if secondaryFrame then
					secondaryFrame:Show()
					if secondaryAura.MainAnimation then
						secondaryAura.MainAnimation:Play()
					end
				end
			end
		end
	end)
	local duration, duration2 = self:CalculateDurations(aura.speed)
	if aura.begin ~= PowaAuras.AnimationBeginTypes.Bounce then
		self:AddJumpAlphaAndReturn(animationGroup, 0, math.min(aura.alpha, 0.99), duration, 1)
	end
	if aura.begin == PowaAuras.AnimationBeginTypes.ZoomOut then
		self:AddJumpScaleAndReturn(animationGroup, 0.5, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.ZoomIn then
		self:AddJumpScaleAndReturn(animationGroup, 1.5, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.FadeIn then
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateLeft then
		self:AddJumpTranslateAndReturn(animationGroup, - 100, 0, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateTopLeft then
		self:AddJumpTranslateAndReturn(animationGroup, - 75,75, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateTop then
		self:AddJumpTranslateAndReturn(animationGroup, 0, 100, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateTopRight then
		self:AddJumpTranslateAndReturn(animationGroup, 75, 75, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateRight then
		self:AddJumpTranslateAndReturn(animationGroup, 100, 0, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateBottomRight then
		self:AddJumpTranslateAndReturn(animationGroup, 75, - 75, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateBottom then
		self:AddJumpTranslateAndReturn(animationGroup, 0, - 100, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.TranslateBottomLeft then
		self:AddJumpTranslateAndReturn(animationGroup, - 75, - 75, duration, 1)
	elseif aura.begin == PowaAuras.AnimationBeginTypes.Bounce then
		self:AddJumpAlphaAndReturn(animationGroup, 0, math.min(aura.alpha, 0.99), 0, 1)
		local u = 0
		local height = 100
		local efficiency = 0.6
		local a = 800 * aura.speed
		self:AddTranslation(animationGroup, 0, height, 0, 1)
		local steps = 6
		local dT = math.sqrt(2 * height / a)
		local dt = dT / steps
		local ds = { }
		for i = 1, steps do
			ds[i] = (u * dt + a * dt * dt / 2) / height
			u = u + a * dt
		end
		local order = 2
		while height > 2 do
			if height < 100 then
				for i = 1, steps do
					self:AddTranslation(animationGroup, 0, ds[steps - i + 1] * height, dt, order)
					order = order + 1
				end
			end
			for i = 1, steps do
				self:AddTranslation(animationGroup, 0, - ds[i] * height, dt, order)
				order = order + 1
			end
			height = height * efficiency
		end
	end
	if aura.beginSpin then
		self:AddRotation(animationGroup, 360, math.max(duration / 4, 0.25), animationGroup:GetMaxOrder() + 1)
	end
	return animationGroup
end

function PowaAuras:AddJumpTranslateAndReturn(animationGroup, dx, dy, duration, order)
	self:AddTranslation(animationGroup, dx, dy, 0, order)
	self:AddTranslation(animationGroup, - dx, - dy, duration, order + 1)
end

function PowaAuras:AddJumpAlphaAndReturn(animationGroup, alphaFrom, alphaTo, duration, order)
	self:AddAlpha(animationGroup, alphaFrom, alphaTo, 0, order)
	self:AddAlpha(animationGroup, alphaFrom, alphaTo, duration, order + 1)
end

function PowaAuras:AddJumpScaleAndReturn(animationGroup, scale, duration, order)
	self:AddScale(animationGroup, scale, scale, 0, order)
	self:AddScale(animationGroup, 1 / scale, 1 / scale, duration, order + 1)
end

function PowaAuras:AddMainAnimation(aura, frame)
	if not aura.anim1 then
		return nil
	end
	local animationGroup = frame:CreateAnimationGroup("Main")
	--animationGroup:SetIgnoreFramerateThrottle(true)
	animationGroup.aura = aura
	animationGroup:SetLooping("REPEAT")
	local speed = 1.0
	if aura.isSecondary then
		speed = PowaAuras.Auras[aura.id].speed
	else
		speed = aura.speed
	end
	local duration, duration2 = self:CalculateDurations(speed)
	if aura.anim1 == PowaAuras.AnimationTypes.Static then
		self:AddScale(animationGroup, 1.0, 1.0, 0, 1)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Flashing then
		local deltaAlpha = math.min(aura.alpha, 0.99)
		self:AddScale(animationGroup, 1.0, 1.0, 0, 1)
		self:AddAlpha(animationGroup, deltaAlpha, 0, duration, 1)
		self:AddAlpha(animationGroup, 0, deltaAlpha, duration, 2)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Growing then
		self:AddScale(animationGroup, 1.3, 1.3, duration * 3, 1)
		self:AddAlpha(animationGroup, math.min(aura.alpha, 0.99), 0, duration * 3, 1)
	elseif aura.anim1 == PowaAuras.AnimationTypes.GrowingInverse then
		self:AddAlpha(animationGroup, math.min(aura.alpha, 0.99), 0, 0, 1)
		self:AddScale(animationGroup, 1.3, 1.3, duration * 3, 1)
		self:AddAlpha(animationGroup, 0, math.min(aura.alpha, 0.99), duration * 3, 1)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Pulse then
		self:AddScale(animationGroup, 1.08, 1.08, duration, 1)
		self:AddScale(animationGroup, 0.9259, 0.9259, duration, 2)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Shrinking then
		self:AddAlpha(animationGroup, math.min(aura.alpha, 0.99), 0, 0, 1)
		self:AddScale(animationGroup, 1.3, 1.3, 0, 1)
		self:AddScale(animationGroup, 1 / 1.3, 1 / 1.3, duration * 3, 2)
		self:AddAlpha(animationGroup, 0, math.min(aura.alpha, 0.99), duration * 3, 2)
	elseif aura.anim1 == PowaAuras.AnimationTypes.ShrinkingInverse then
		self:AddScale(animationGroup, 1.3, 1.3, 0, 1)
		self:AddScale(animationGroup, 1 / 1.3, 1 / 1.3, duration * 3, 2)
		self:AddAlpha(animationGroup, math.min(aura.alpha, 0.99), 0, duration * 3, 2)
	elseif aura.anim1 == PowaAuras.AnimationTypes.WaterDrop then
		self:AddMoveRandomLocation(animationGroup, 0, 20, - 10, 0, 20, - 10, 0, 0, false, aura.speed, 1)
		self:AddScale(animationGroup, 0.85, 0.85, 0, 0, 1)
		self:AddScale(animationGroup, 1.76, 1.76, duration * 4, 2)
		self:AddAlpha(animationGroup, math.min(aura.alpha, 0.99), 0, duration * 4, 2)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Electric then
		local steps = 30
		local deltaAlpha = math.min(aura.alpha, 0.99) / steps
		local stepDuration = duration * 4 / steps
		animationGroup.speed = aura.speed
		animationGroup:SetScript("OnPlay", function(self)
			self.Trigger = (math.random( 210 - self.speed * 100 ) < 4)
		end)
		for i = 1, steps do
			self:AddMoveRandomLocation(animationGroup, 0, 10, - 5, 0, 10, - 5, stepDuration, true, aura.speed, i)
			self:AddAlpha(animationGroup, deltaAlpha, 0, stepDuration, i)
		end
	elseif aura.anim1 == PowaAuras.AnimationTypes.Flame then
		local steps = 40
		local deltaAlpha = math.min(aura.alpha, 0.99) / steps
		local stepDuration = duration * 4 / steps
		for i = 1, steps do
			self:AddMoveRandomLocation(animationGroup, 1, 7, - 4, 0, 2, 0, stepDuration, false, aura.speed, i)
			self:AddAlpha(animationGroup, deltaAlpha, 0, stepDuration, i)
			self:AddScale(animationGroup, 0.98, 0.98, stepDuration, i)
		end
	elseif aura.anim1 == PowaAuras.AnimationTypes.Bubble then
		local factor = 0.05
		local increase = 1 + factor
		local decrease = 1 - factor
		if aura.isSecondary then
			increase = 1 - factor
			decrease = 1 + factor
		end
		self:AddScale(animationGroup, increase, decrease, duration / 3, 1)
		self:AddScale(animationGroup, 1 / increase, 1 / decrease, duration / 3, 2)
		self:AddScale(animationGroup, decrease, increase, duration / 3, 3)
		self:AddScale(animationGroup, 1 / decrease, 1 / increase, duration / 3, 4)
	elseif aura.anim1 == PowaAuras.AnimationTypes.Orbit then
		local maxWidth = math.max(aura.x, - aura.x, 5)
		local maxHeight = maxWidth * (1.6 - aura.torsion)
		local i = 1
		local x = aura.x
		if aura.isSecondary then
			x = - PowaAuras.Auras[aura.id].x
			frame:SetPoint("Center", x, PowaAuras.Auras[aura.id].y)
		end
		local y = aura.y
		local step = 9
		local angleOffset = 190
		if x > 0 then
			angleOffset = 10
		end
		for angle = 0, 360 - step, step do
			local newx = maxWidth * cos(angle + angleOffset)
			local newy = aura.y + maxHeight * sin(angle + angleOffset)
			self:AddTranslation(animationGroup, newx - x, newy - y, duration * step / 30, i)
			i = i + 1
			x = newx
			y = newy
		end
	elseif aura.anim1 == PowaAuras.AnimationTypes.SpinClockwise then
		self:AddRotation(animationGroup, - 360, math.max(duration2, 0.25), 1)
	elseif aura.anim1 == PowaAuras.AnimationTypes.SpinAntiClockwise then
		self:AddRotation(animationGroup, 360, math.max(duration2, 0.25), 1)
	end
	return animationGroup
end

function PowaAuras:AddMoveRandomLocation(animationGroup, xrangel, xrangeu, xoffset, yrangel, yrangeu, yoffset, duration, useTrigger, speed, order)
	local trans = animationGroup:CreateAnimation("Translation")
	trans.speed = speed
	trans.xrangel = xrangel
	trans.xrangeu = xrangeu
	trans.yrangel = yrangel
	trans.yrangeu = yrangeu
	trans.xoffset = xoffset
	trans.yoffset = yoffset
	trans.useTrigger = useTrigger
	trans:SetOrder(order)
	trans:SetDuration(duration)
	trans:SetScript("OnPlay", function(self)
		if not self.useTrigger or self:GetParent().Trigger then
			self:SetOffset((math.random(self.xrangel,self.xrangeu) + self.xoffset) * self.speed, (math.random(self.yrangel,self.yrangeu) + self.yoffset) * self.speed)
		else
			self:SetOffset(0, 0)
		end
	end)
end

--[[function PowaAuras:AddAlphaOnTrigger(animationGroup, alphaTo, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha")
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	alpha.alphaTo = alphaTo
	alpha:SetScript("OnPlay", function(self)
		if self:GetParent().Trigger then
			self:SetChange(self.alphaTo)
		else
			self:SetChange(0)
		end
	end)
end]]

function PowaAuras:AddTranslation(animationGroup, dx, dy, duration, order)
	local trans = animationGroup:CreateAnimation("Translation")
	trans:SetOrder(order)
	trans:SetDuration(duration)
	trans:SetOffset(dx, dy)
end

function PowaAuras:AddScale(animationGroup, xscaleTo, yscaleTo, duration, order)
	local scale = animationGroup:CreateAnimation("Scale")
	scale:SetOrder(order)
	scale:SetDuration(duration)
	scale:SetScale(xscaleTo, yscaleTo)
	scale:SetSmoothing("IN_OUT")
end

function PowaAuras:AddAlpha(animationGroup, alphaFrom, alphaTo, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha")
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	--alpha:SetChange(alphaTo)
	alpha:SetFromAlpha(alphaFrom)
	alpha:SetToAlpha(alphaTo)
end

function PowaAuras:AddFade(animationGroup, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha")
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	alpha:SetScript("OnPlay", function(self)
		--self:SetChange(- self:GetRegionParent():GetAlpha())
		self:SetFromAlpha(self:GetRegionParent():GetAlpha())
		self:SetToAlpha(0)
	end)
end

function PowaAuras:AddRelativeAlpha(animationGroup, change, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha")
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	alpha:SetScript("OnPlay", function(self)
		local alpha = self:GetRegionParent():GetAlpha()
		--self:SetChange(math.min((alpha * change), 0.99))
		self:SetFromAlpha(0)
		self:SetToAlpha(math.min((alpha * change), 0.99))
	end)
end

function PowaAuras:AddAbsoluteAlpha(animationGroup, targetAlpha, duration, order)
	local alpha = animationGroup:CreateAnimation("Alpha")
	alpha:SetOrder(order)
	alpha:SetDuration(duration)
	alpha:SetScript("OnPlay", function(self)
		--self:SetChange(math.min(targetAlpha, 0.99) - self:GetRegionParent():GetAlpha())
		self:SetFromAlpha(0)
		self:SetToAlpha(math.min(targetAlpha, 0.99) - self:GetRegionParent():GetAlpha())
	end)
end

function PowaAuras:AddBrightenAndReturn(animationGroup, change, targetAlpha, duration, order)
	self:AddRelativeAlpha(animationGroup, change, 0, 0, order)
	self:AddAbsoluteAlpha(animationGroup, targetAlpha, duration, order + 1)
end

function PowaAuras:AddRotation(animationGroup, angle, duration, order)
	local rotation = animationGroup:CreateAnimation("Rotation")
	rotation:SetOrder(order)
	rotation:SetDuration(duration)
	rotation:SetDegrees(angle)
end

function PowaAuras:AddEndAnimation(aura, frame)
	if not aura.finish or aura.finish == PowaAuras.AnimationEndTypes.None then
		return nil
	end
	local animationGroup = frame:CreateAnimationGroup("End")
	--animationGroup:SetIgnoreFramerateThrottle(true)
	animationGroup.aura = aura
	animationGroup:SetScript("OnFinished", function(self, forced)
		if self.aura then
			self.aura:Hide(true)
		end
	end)
	local duration = self:CalculateDurations(aura.speed)
	if aura.finish == PowaAuras.AnimationEndTypes.Fade then
		self:AddFade(animationGroup, duration / 2, 1)
	elseif aura.finish == PowaAuras.AnimationEndTypes.GrowAndFade then
		self:AddFade(animationGroup, duration / 2, 1)
		self:AddScale(animationGroup, 2.0, 2.0, duration / 2, 1)
	elseif aura.finish == PowaAuras.AnimationEndTypes.ShrinkAndFade then
		self:AddFade(animationGroup, duration / 2, 1)
		self:AddScale(animationGroup, 0.25, 0.25, duration / 2, 1)
	elseif aura.finish == PowaAuras.AnimationEndTypes.SpinAndFade then
		self:AddFade(animationGroup, duration * 2, 1)
		self:AddRotation(animationGroup, 360 * 4, duration * 2, 1)
	elseif aura.finish == PowaAuras.AnimationEndTypes.SpinShrinkAndFade then
		self:AddFade(animationGroup, duration * 2, 1)
		self:AddRotation(animationGroup, 360 * 4, duration * 2, 1)
		self:AddScale(animationGroup, 0.25, 0.25, duration * 2, 1)
	end
	return animationGroup
end