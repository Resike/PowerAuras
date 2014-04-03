--[[
	Author: Daniel Yates <dyates92@gmail.com>
	Adds addon communication functionality into Power Auras. Utilizes the SendAddonMessage API and its own locking system to minimize load and prevent clashes when dealing with split messages.
--]]

local PowaAurasOptions = PowaAurasOptions

local string = string
local tonumber = tonumber
local math = math
local pairs = pairs
local table = table
local wipe = wipe

local GetTime = GetTime
local IsAddonMessagePrefixRegistered = IsAddonMessagePrefixRegistered
local RegisterAddonMessagePrefix = RegisterAddonMessagePrefix
local SendAddonMessage = SendAddonMessage

PowaComms = {
	Handlers = { },
	Registered = false,
	ReceiverLock = nil,
	RecieverTimeout = 0,
	ReceiverInstruction = nil,
	ReceiverStore = { },
	SenderLock = nil,
	SenderTimeout = 0,
	SenderInstruction = nil,
	SenderStore = nil
}

-- Accessible through PowaAurasOptions.Comms
PowaAurasOptions["Comms"] = PowaComms

function PowaComms:Register()
	if not RegisterAddonMessagePrefix then
		return
	end
	RegisterAddonMessagePrefix("POWA")
	if not IsAddonMessagePrefixRegistered("POWA") then
		if PowaMisc.Debug then
			PowaAurasOptions:ShowText("PowaComms:Register() |cFFFF0000failed!|r")
		end
		self.Registered = false
		return false
	else
		if PowaMisc.Debug then
			PowaAurasOptions:ShowText("PowaComms:Register() |cFF00FF00succeeded!|r")
		end
		self.Registered = true
		return true
	end
end

function PowaComms:IsRegistered()
	return self.Registered
end

function PowaAurasOptions:CHAT_MSG_ADDON(header, data, channel, from)
	if header ~= "POWA" then
		return
	end
	local stx = string.find(data, "<", 1, true)
	local segpos = string.find(data, ";", stx + 1, true)
	local segtotal = string.find(data, ";", segpos + 1, true)
	local datasegment = string.find(data, "/>", segtotal + 1, true)
	if not stx or not segpos or not segtotal or not datasegment then
		return
	end
	local instruction = string.sub(data, stx + 1, segpos - 1)
	local segpos = tonumber(string.sub(data, segpos + 1, segtotal - 1), 10)
	local segtotal = tonumber(string.sub(data, segtotal + 1, datasegment - 1), 10)
	local datasegment = string.sub(data, datasegment + 2)
	self.Comms:FireHandler(instruction, datasegment, from, segpos, segtotal)
end

function PowaComms:SendAddonMessage(instruction, data, to, segment, total)
	if not self:IsRegistered() then
		return false
	end
	local length = string.len(data)
	if PowaMisc.Debug then
		PowaAurasOptions:ShowText("Comms: Sending instruction "..instruction.." (data length "..length..")")
	end
	if length <= 200 then
		data = "<"..instruction..";"..(segment or 1)..";"..(total or 1).."/>"..data
		SendAddonMessage("POWA", data, "WHISPER", to)
	elseif not self.SenderLock or GetTime() > self.SenderTimeout then
		self.SenderInstruction = instruction
		self.SenderStore = data
		self.SenderLock = to
		self.SenderTimeout = GetTime() + 10
		self:SendAddonMessage("REQUEST_LOCK", instruction, to)
	end
	return true
end

function PowaComms:AddHandler(instruction, func)
	if not self.Handlers[instruction] then
		self.Handlers[instruction] = { }
	end
	table.insert(self.Handlers[instruction], func)
end

function PowaComms:FireHandler(instruction, data, from, segpos, segtotal)
	if PowaMisc.Debug then
		PowaAurasOptions:ShowText("Comms: Firing handler for instruction: "..instruction)
	end
	if self.Handlers[instruction] then
		for index, func in pairs(self.Handlers[instruction]) do
			if func(self, data, from, segpos, segtotal) == true then
				table.remove(self.Handlers[instruction], index)
			end
		end
	end
end

function PowaComms:ResetReceiverLock()
	self.ReceiverLock = nil
	self.ReceiverTimeout = 0
	self.ReceiverInstruction = nil
	wipe(self.ReceiverStore)
end

PowaComms:AddHandler("MULTIPART", function(self, data, from, segpos, segtotal)
	if not self.ReceiverLock or self.ReceiverLock ~= from then
		return
	end
	table.insert(self.ReceiverStore, segpos, data)
	if #self.ReceiverStore ~= segtotal then
		return
	end
	local instruction, count, data = self.ReceiverInstruction, #self.ReceiverStore, ""
	self:SendAddonMessage("MULTIPART_SUCCESS", "", from)
	for i = count, 1, - 1 do
		data = self.ReceiverStore[i]..data
	end
	self:ResetReceiverLock()
	self:FireHandler(instruction, data, from, segpos, segtotal)
end)

PowaComms:AddHandler("REQUEST_LOCK", function(self, data, from)
	if not self.ReceiverLock or GetTime() > self.ReceiverTimeout then
		if self.ReceiverLock and self.ReceiverLock ~= from then
			self:SendAddonMessage("TIMEOUT_LOCK", "", self.ReceiverLock)
		end
		self:ResetReceiverLock()
		self.ReceiverLock = from
		self.ReceiverTimeout = GetTime() + 10
		self.ReceiverInstruction = data
		self:SendAddonMessage("ACCEPT_LOCK", "", from)
	else
		self:SendAddonMessage("REJECT_LOCK", "", from)
	end
end)

function PowaComms:ResetSenderLock()
	self.SenderLock = nil
	self.SenderTimeout = 0
	self.SenderInstruction = nil
	self.SenderStore = nil
end

PowaComms:AddHandler("ACCEPT_LOCK", function(self, _, from)
	if not self.SenderLock or self.SenderLock ~= from then
		return
	end
	local segment, i, total = "", 1, math.ceil(string.len(self.SenderStore) / 200)
	for i = 1, total do
		segment = string.sub(self.SenderStore, 0, 200)
		self.SenderStore = string.sub(self.SenderStore, 201)
		self:SendAddonMessage("MULTIPART", segment, from, i, total)
	end
end)

PowaComms:AddHandler("MULTIPART_SUCCESS", function(self, _, from)
	if not self.SenderLock or self.SenderLock ~= from then
		return
	end
	self:ResetSenderLock()
end)

PowaComms:AddHandler("REJECT_LOCK", function(self, _, from)
	if not self.SenderLock or self.SenderLock ~= from then
		return
	end
	self:ResetSenderLock()
end)

PowaComms:AddHandler("TIMEOUT_LOCK", function(self, _, from)
	if not self.SenderLock or self.SenderLock ~= from then
		return
	end
	self:ResetSenderLock()
end)

PowaComms:AddHandler("VERSION_REQUEST", function(self, _, from)
	self:SendAddonMessage("VERSION_RESPONSE", PowaAurasOptions.Version, from)
end)

PowaComms:AddHandler("VERSION_RESPONSE", function(self, data, from)
	PowaAurasOptions:ShowText(from, " is using version ", data, ".")
end)