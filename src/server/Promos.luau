--!strict
-- BloxFront promos (Data/Promos; 2026-10-27): who on this server is in the BloxFront group (+10% Stars
-- on every match: Rewards' deps.group = Promos.in_group), and the running event's gifts for everyone who
-- joins while it runs (Purchases.event_gift). The client hears OP.PROMO: { group, event?, given? }.
--
--   Promos.configure(deps)   { in_group = fn(player) -> boolean? (nil: Roblox didn't answer),
--                              gift = fn(player, event) -> given?, send = fn(player, state),
--                              now = fn() -> unix s, log? }
--   Promos.joined(player)    PlayerAdded (yields)
--   Promos.recheck(player)   the client asks again (after Roblox's join prompt; yields, rate-limited)
--   Promos.in_group(player) -> boolean
--   Promos.state(player) -> { group, event? }   for a client that says HELLO
--   Promos.tick()            about every 30 s: when the event starts, its gifts for everyone here (yields)
--   Promos.release(player)   PlayerRemoving
local IS_ROBLOX = typeof(game) == "Instance"
local Data: any = if IS_ROBLOX
	then require((game :: any):GetService("ReplicatedStorage"):WaitForChild("Airfront").Data.Promos)
	else require("../shared/Data/Promos")

local Promos = {}

--- A client may ask for a fresh group check this often (s).
Promos.RECHECK_S = 5.0

type Entry = { group: boolean, checked: number?, event: boolean, gifting: boolean? }

local deps: { [string]: any } = {}
local entries: { [any]: Entry } = {}

function Promos.configure(d: { [string]: any })
	for k, v in d do
		deps[k] = v
	end
end

--- Tests: forget everyone.
function Promos.reset()
	table.clear(entries)
end

local function now(): number
	return if deps.now then deps.now() else os.time()
end

local function entry(player: any): Entry
	local e = entries[player]
	if e == nil then
		e = { group = false, event = false }
		entries[player] = e
	end
	return e
end

function Promos.state(player: any): any
	local e = entry(player)
	local ev = Data.EVENT
	return {
		group = e.group,
		event = if Data.event_shown(now())
			then {
				key = ev.key,
				on = Data.event_on(now()),
				claimed = e.event,
				skin = ev.skin,
				flag = ev.flag,
				from = ev.from,
				to = ev.to,
			}
			else nil,
	}
end

local function send(player: any, given: any?)
	if deps.send then
		local st = Promos.state(player)
		st.given = given
		pcall(deps.send, player, st)
	end
end

local function check_group(player: any): boolean?
	if deps.in_group == nil then
		return nil
	end
	local ok, on = pcall(deps.in_group, player)
	if ok and type(on) == "boolean" then
		return on
	end
	if deps.log then
		deps.log("[Promos] group check failed for " .. tostring(player.UserId) .. ": " .. tostring(on))
	end
	return nil
end

--- The event's gifts for `player` if it runs and they don't have them yet: what it gave now, or nil.
local function gift(player: any, e: Entry): any
	if e.event or e.gifting or not Data.event_on(now()) or deps.gift == nil then
		return nil
	end
	e.gifting = true
	local ok, g = pcall(deps.gift, player, Data.EVENT)
	e.gifting = nil
	if ok and g ~= nil then
		e.event = true
		return if next(g) ~= nil then g else nil
	end
	return nil
end

function Promos.joined(player: any)
	local e = entry(player)
	local on = check_group(player)
	if on ~= nil then
		e.group = on
		e.checked = os.clock()
	end
	local given = gift(player, e)
	if entries[player] == e then
		send(player, given)
	end
end

--- the event's state last tick (on / shown): a change is sent to everyone
local last_on: boolean? = nil
local last_shown: boolean? = nil

function Promos.tick()
	local t = now()
	local on, shown = Data.event_on(t), Data.event_shown(t)
	local changed = on ~= last_on or shown ~= last_shown
	last_on, last_shown = on, shown
	for player, e in entries do
		if on and not e.event then
			local given = gift(player, e)
			if entries[player] == e then
				send(player, given)
			end
		elseif changed then
			send(player)
		end
	end
end

function Promos.recheck(player: any)
	local e = entry(player)
	if e.checked ~= nil and os.clock() - e.checked < Promos.RECHECK_S then
		send(player)
		return
	end
	e.checked = os.clock()
	local on = check_group(player)
	if on ~= nil then
		e.group = on
	end
	send(player)
end

function Promos.in_group(player: any): boolean
	local e = entries[player]
	return e ~= nil and e.group
end

function Promos.release(player: any)
	entries[player] = nil
end

return Promos
