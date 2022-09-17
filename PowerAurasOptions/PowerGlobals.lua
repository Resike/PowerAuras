POWA_OPTIONS_FRAME_BACKDROP_200_32_10101010 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileEdge = true,
	tileSize = 200,
	edgeSize = 32,
	insets = { left = 10, right = 10, top = 10, bottom = 10 },
}

POWA_OPTIONS_EQUIPMENT_BACKDROP_200_16_4444 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 200,
	edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

POWA_OPTIONS_SELECTOR_BACKDROP_128_12_2222 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 128,
	edgeSize = 12,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
}

POWA_OPTIONS_LIST_BACKDROP_128_16_2222 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileEdge = true,
	tileSize = 128,
	edgeSize = 16,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
}

POWA_OPTIONS_EXPORT_BACKDROP_32_32_10101010 = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileEdge = true,
	tileSize = 32,
	edgeSize = 32,
	insets = { left = 10, right = 10, top = 10, bottom = 10 },
}

POWA_OPTIONS_SLIDER_BACKDROP_8_8_3333 = {
	bgFile = "Interface\\Buttons\\UI-SliderBar-Background",
	edgeFile = "Interface\\Buttons\\UI-SliderBar-Border",
	tile = true,
	tileEdge = true,
	tileSize = 8,
	edgeSize = 8,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

POWA_OPTIONS_SLIDER_EDIT_BACKDROP_5_1 = {
	bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
	edgeFile = "Interface\\ChatFrame\\ChatFrameBackground",
	tile = true,
	tileEdge = true,
	tileSize = 5,
	edgeSize = 1,
}

local BackdropTemplatePolyfillMixin = {}

function BackdropTemplatePolyfillMixin:OnBackdropLoaded()
	if not self.backdropInfo then
		return
	end

	if not self.backdropInfo.edgeFile and not self.backdropInfo.bgFile then
		self.backdropInfo = nil
		return
	end

	self:ApplyBackdrop()

	if self.backdropColor then
		local r, g, b = self.backdropColor:GetRGB()
		self:SetBackdropColor(r, g, b, self.backdropColorAlpha or 1)
	end

	if self.backdropBorderColor then
		local r, g, b = self.backdropBorderColor:GetRGB()
		self:SetBackdropBorderColor(r, g, b, self.backdropBorderColorAlpha or 1)
	end

	if self.backdropBorderBlendMode then
		self:SetBackdropBorderBlendMode(self.backdropBorderBlendMode)
	end
end

function BackdropTemplatePolyfillMixin:OnBackdropSizeChanged()
	if self.backdropInfo then
		self:SetupTextureCoordinates()
	end
end

function BackdropTemplatePolyfillMixin:ApplyBackdrop()
	-- The SetBackdrop call will implicitly reset the background and border
	-- texture vertex colors to white, consistent across all client versions.

	self:SetBackdrop(self.backdropInfo)
end

function BackdropTemplatePolyfillMixin:ClearBackdrop()
	self:SetBackdrop(nil)
	self.backdropInfo = nil
end

function BackdropTemplatePolyfillMixin:GetEdgeSize()
	-- The below will indeed error if there's no backdrop assigned this is
	-- consistent with how it works on 9.x clients.

	return self.backdropInfo.edgeSize or 39
end

function BackdropTemplatePolyfillMixin:HasBackdropInfo(backdropInfo)
	return self.backdropInfo == backdropInfo
end

function BackdropTemplatePolyfillMixin:SetBorderBlendMode()
	-- The pre-9.x API doesn't support setting blend modes for backdrop
	-- borders, so this is a no-op that just exists in case we ever assume
	-- it exists.
end

function BackdropTemplatePolyfillMixin:SetupPieceVisuals()
	-- Deliberate no-op as backdrop internals are handled C-side pre-9.x.
end

function BackdropTemplatePolyfillMixin:SetupTextureCoordinates()
	-- Deliberate no-op as texture coordinates are handled C-side pre-9.x.
end

PowaBackdropTemplateMixin = CreateFromMixins(BackdropTemplateMixin or BackdropTemplatePolyfillMixin)
