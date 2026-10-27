--!strict
-- BloxFront restart countdown (2026-10-27): a game admin announces a restart in N minutes from the admin
-- panel; every server hears it (MessagingService), every player sees the countdown (OP.RESTART), and
-- when it runs out each server pays the Stars of its running match and ends it (on_due), so nobody
-- loses a match to the update. Roblox's "Migrate to Latest Update" then moves everyone without loss.
--
--   Restart.configure(deps)   { publish = fn(msg)?, send_all = fn(state), on_due = fn(), now = fn() -> unix s,
--                               log? }
--   Restart.announce(minutes) an admin's word: 0 cancels (publishes it to every server, applies it here)
--   Restart.heard(msg)        MessagingService: { at = unix s } (0 = cancelled)
--   Restart.state() -> { at }?   for a client that says HELLO (nil: no restart announced)
--   Restart.tick()            about every second: runs on_due once when the countdown is over
local Restart = {}

Restart.TOPIC = "BF_Restart"
--- An announcement is at most this far ahead (minutes).
Restart.MAX_MIN = 60

local deps: { [string]: any } = {}
local at = 0
local fired = false

function Restart.configure(d: { [string]: any })
	for k, v in d do
		deps[k] = v
	end
end

--- Tests: forget the announcement.
function Restart.reset()
	at = 0
	fired = false
end

local function now(): number
	return if deps.now then deps.now() else os.time()
end

local function log(text: string)
	if deps.log then
		deps.log("[Restart] " .. text)
	end
end

function Restart.state(): any
	return if at > 0 then { at = at } else nil
end

local function apply(t: number)
	if t > 0 and (t ~= t or t > now() + Restart.MAX_MIN * 60 + 60) then
		return
	end
	at = if t > 0 then math.floor(t) else 0
	fired = false
	log(if at > 0 then string.format("in %d s", at - now()) else "cancelled")
	if deps.send_all then
		pcall(deps.send_all, { at = at })
	end
end

function Restart.announce(minutes: number)
	local m = math.clamp(math.floor(tonumber(minutes) or 0), 0, Restart.MAX_MIN)
	local t = if m > 0 then now() + m * 60 else 0
	apply(t)
	if deps.publish then
		local ok, err = pcall(deps.publish, { at = t })
		if not ok then
			log("publish failed (this server only): " .. tostring(err))
		end
	end
end

function Restart.heard(msg: any)
	if type(msg) == "table" and type(msg.at) == "number" and msg.at ~= at then
		apply(msg.at)
	end
end

function Restart.tick()
	if at <= 0 or fired or now() < at then
		return
	end
	fired = true
	log("countdown over: paying and ending the running match")
	if deps.on_due then
		local ok, err = pcall(deps.on_due)
		if not ok then
			log("on_due failed: " .. tostring(err))
		end
	end
end

return Restart
