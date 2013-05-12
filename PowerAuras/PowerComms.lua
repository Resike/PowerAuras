local string, len, find, sub, tonumber, pairs, table, insert, remove, ceil, wipe = string, len, find, sub, tonumber, pairs, table, insert, remove, ceil, wipe

--[[
Author: Daniel Yates <dyates92@gmail.com>
Adds addon communication functionality into Power Auras. Utilizes the SendAddonMessage API and its own locking system to
minimize load and prevent clashes when dealing with split messages.
--]]
PowaComms = {
	Handlers = { }, -- Custom functions to be executed when an instruction is processed.
	Registered = false,

	ReceiverLock = nil,
	RecieverTimeout = 0,
	ReceiverInstruction = nil,
	ReceiverStore = {},

	SenderLock = nil,
	SenderTimeout = 0,
	SenderInstruction = nil,
	SenderStore = nil
}
-- Accessible through PowaAuras.Comms
PowaAuras["Comms"] = PowaComms
--[[
Register
Registers the POWA header for addon communications. Note that this requires a patch 4.1 client.
--]]
function PowaComms:Register()
	-- Register prefix.
	if (not RegisterAddonMessagePrefix) then
		return
	end
	RegisterAddonMessagePrefix("POWA")
	-- Check to see if it's registered (RegisterAddonMessagePrefix may return true even if it fails, just playing safe!).
	if (not IsAddonMessagePrefixRegistered("POWA")) then
		if(PowaMisc.debug) then
			PowaAuras:ShowText("PowaComms:Register() |cFFFF0000failed!|r")
		end
		self.Registered = false
		return false
	else
		if(PowaMisc.debug) then
			PowaAuras:ShowText("PowaComms:Register() |cFF00FF00succeeded!|r")
		end
		self.Registered = true
		return true
	end
end
--[[
IsRegistered
Returns the status of the PowaComms addon message header.
--]]
function PowaComms:IsRegistered()
	-- Stored the result of IsAddonMessagePrefixRegistered in a boolean during register func.
	return self.Registered
end
--[[
CHAT_MSG_ADDON
Responds to the CHAT_MSG_ADDON event. This will parse the header (or prefix) and determine what function to call to
handle the data.
--]]
function PowaAuras:CHAT_MSG_ADDON(header, data, channel, from)
	-- Check the header.
	if (header ~= "POWA") then
		return
	end
	-- A good data message is always in the following format: <INSTRUCTIONSEGMENT_INDEXSEGMENT_COUNT/>
	local stx = string.find(data, "<", 1, true)
	local segpos = string.find(data, "", stx + 1, true)
	local segtotal = string.find(data, "", segpos + 1, true)
	local datasegment = string.find(data, "/>", segtotal + 1, true)
	-- They all need to be present.
	if (not stx or not segpos or not segtotal or not datasegment) then
		return
	end
	-- Replace segpos/segtotal with their actual values. Extract the instruction too.
	local instruction, segpos, segtotal, datasegment = string.sub(data, stx + 1, segpos - 1),
		tonumber(string.sub(data, segpos + 1, segtotal - 1), 10),
		tonumber(string.sub(data, segtotal + 1, datasegment - 1), 10),
		string.sub(data, datasegment + 2)
	-- Fire handlers.
	self.Comms:FireHandler(instruction, datasegment, from, segpos, segtotal)
end
--[[
SendAddonMessage
Wrapper for SendAddonMessage, handles all of the lock requests and multiple data segments for you.
--]]
function PowaComms:SendAddonMessage(instruction, data, to, segment, total)
	-- Only send if we can receive.
	if (not self:IsRegistered()) then
		return false
	end
	-- Check length.
	local length = string.len(data)
	if (PowaMisc.debug) then
		PowaAuras:ShowText("Comms: Sending instruction "..instruction.." (data length "..length..")")
	end
	if (length <= 200) then
		-- And AWAY!
		data = "<"..instruction..""..(segment or 1)..""..(total or 1).."/>"..data
		SendAddonMessage("POWA", data, "WHISPER", to)
	elseif (not self.SenderLock or time() > self.SenderTimeout) then
		-- We'll need a multipart message. Store this data for now.
		self.SenderInstruction = instruction
		self.SenderStore = data
		-- Lock ourselves.
		self.SenderLock = to
		self.SenderTimeout = time() + 10
		-- Request a lock with this user.
		self:SendAddonMessage("REQUEST_LOCK", instruction, to)
	end
	return true
end
--[[
AddHandler
Adds an instruction handler. When this instruction is next recieved, your function will be called with the sender and
data passed as arguments. If your handler returns true, it will be removed from further executions, otherwise
it will remain until you return true.
--]]
function PowaComms:AddHandler(instruction, func)
	-- Add it.
	if (not self.Handlers[instruction]) then
		self.Handlers[instruction] = { }
	end
	table.insert(self.Handlers[instruction], func)
end
--[[
FireHandler
Executes any handlers for the given instruction.
--]]
function PowaComms:FireHandler(instruction, data, from, segpos, segtotal)
	-- Send data to the appropriate place.
	if (PowaMisc.debug) then
		PowaAuras:ShowText("Comms: Firing handler for instruction: "..instruction)
	end
	if (self.Handlers[instruction]) then
		for index, func in pairs(self.Handlers[instruction]) do
			if (func(self, data, from, segpos, segtotal) == true) then
				table.remove(self.Handlers[instruction], index)
			end
		end
	end
end
--[[
Receiver Functions
These functions are responsible for handling multipart data from a sender, most of them handle the locks.
--]]
--[[
ResetReceiverLock
Function for resetting reciever lock variables. Beats copy/pasting 3 lines repeatedly.
--]]
function PowaComms:ResetReceiverLock()
	self.ReceiverLock = nil
	self.ReceiverTimeout = 0
	self.ReceiverInstruction = nil
	wipe(self.ReceiverStore)
end
--[[
MULTIPART
Receiver function for a multipart message. This will store the message in a table and when we have all pieces, the
message is concatenated, sent to the appropriate function and the sender is made aware that we're done.
--]]
PowaComms:AddHandler("MULTIPART", function(self, data, from, segpos, segtotal)
	-- Accept multipart messages from our locked partner.
	if (not self.ReceiverLock or self.ReceiverLock ~= from) then
		return
	end
	table.insert(self.ReceiverStore, segpos, data)
	-- Do we have all of the segments?
	-- If we never receive them all, our lock will expire in about 10 seconds and all data is purged, with the sender
	-- being notified.
	if (#(self.ReceiverStore) ~= segtotal) then
		return
	end
	-- Verify that all data exists.
	local instruction, count, data = self.ReceiverInstruction, #(self.ReceiverStore), ""
	-- Tell the sender they're done.
	self:SendAddonMessage("MULTIPART_SUCCESS", "", from)
	-- Concatenate the message.
	for i = count, 1, - 1 do
		data = self.ReceiverStore[i]..data
	end
	-- Reset our lock (doing this earlier would wipe our data).
	self:ResetReceiverLock()
	-- Forward to appropriate function.
	self:FireHandler(instruction, data, from, segpos, segtotal)
end)
--[[
REQUEST_LOCK
Request handler for multipart locks. Will grant them so long as we're not locked, or if the last lock timed out.
If a lock wasn't properly closed beforehand, the previous lock owner will receive a timeout message.
--]]
PowaComms:AddHandler("REQUEST_LOCK", function(self, data, from)
	-- Accept if we're not locked.
	if (not self.ReceiverLock or time() > self.ReceiverTimeout) then
		-- If it was an expired lock, tell the person it belonged to.
		-- Don't send timeouts if the same person is contacting us, it causes a problem.
		if (self.ReceiverLock and self.ReceiverLock ~= from) then
			self:SendAddonMessage("TIMEOUT_LOCK", "", self.ReceiverLock)
		end
		-- Reset our lock data (just to be safe).
		self:ResetReceiverLock()
		-- And set us up the bomb.
		self.ReceiverLock = from
		self.ReceiverTimeout = time() + 10
		self.ReceiverInstruction = data
		-- Tell sender we love them.
		self:SendAddonMessage("ACCEPT_LOCK", "", from)
	else
		-- We're locked.
		self:SendAddonMessage("REJECT_LOCK", "", from)
	end
end)
--[[
Sender Functions
These functions are responsible for sending multipart data to a receiver, most of them handle the locks.
--]]
--[[
ResetSenderLock
Function for resetting sender lock variables. Beats copy/pasting 3 lines repeatedly.
--]]
function PowaComms:ResetSenderLock()
	self.SenderLock = nil
	self.SenderTimeout = 0
	self.SenderInstruction = nil
	self.SenderStore = nil
end
--[[
ACCEPT_LOCK
Handler for lock accepts. Will begin transmitting a multipart message.
--]]
PowaComms:AddHandler("ACCEPT_LOCK", function(self, _, from)
	-- Verify lock ownership.
	if (not self.SenderLock or self.SenderLock ~= from) then
		return
	end
	-- Start transmitting data.
	local segment, i, total = "", 1, math.ceil(string.len(self.SenderStore) / 200)
	for i = 1, total do
		segment = string.sub(self.SenderStore, 0, 200)
		self.SenderStore = string.sub(self.SenderStore, 201)
		self:SendAddonMessage("MULTIPART", segment, from, i, total)
	end
end)
--[[
MULTIPART_SUCCESS
Called when the receiver has told us that all segments have been received, closes our sender lock.
--]]
PowaComms:AddHandler("MULTIPART_SUCCESS", function(self, _, from)
	-- Verify lock ownership.
	if (not self.SenderLock or self.SenderLock ~= from) then
		return
	end
	self:ResetSenderLock()
end)
--[[
REJECT_LOCK
Called if the receiver is busy and cannot service our request. Resets our lock.
--]]
PowaComms:AddHandler("REJECT_LOCK", function(self, _, from)
	-- Verify lock ownership.
	if (not self.SenderLock or self.SenderLock ~= from) then
		return
	end
	-- Close any locks we had with this user.
	self:ResetSenderLock()
end)
--[[
TIMEOUT_LOCK
Called if the receiver or us had a transmission fault which left us with an open lock. Will reset our sender lock.
--]]
PowaComms:AddHandler("TIMEOUT_LOCK", function(self, _, from)
	-- Verify lock ownership.
	if (not self.SenderLock or self.SenderLock ~= from) then
		return
	end
	-- Close any locks we had with this user.
	self:ResetSenderLock()
end)
--[[
Instruction Handler Functions
These functions are responsible for handling the individual instructions not related to locking.
--]]
--[[
VERSION_REQUEST
Sends our PowerAuras version to the requesting party. Mostly just here for testing. Sends the version back with a
VERSION_RESPONSE header.
--]]
PowaComms:AddHandler("VERSION_REQUEST", function(self, _, from)
	-- Give them our version.
	self:SendAddonMessage("VERSION_RESPONSE", PowaAuras.Version, from)
end)
--[[
VERSION_RESPONSE
Responds to a version request. Prints it out (send VERSION_REQUEST for debugging).
--]]
PowaComms:AddHandler("VERSION_RESPONSE", function(self, data, from)
	PowaAuras:ShowText(from, " is using version ", data, ".")
end)