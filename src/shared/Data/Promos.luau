--!strict
-- BloxFront promos (2026-10-27): the free cards on the title screen's right, under General's.
--
--   Group bonus   join the BloxFront group (GROUP_ID) for +GROUP_STARS_BONUS on every match's Stars,
--                 like a boost (server/Rewards: the "group" line). The server asks Roblox whether the
--                 player is in the group (server/Promos), on joining and when the client asks again
--                 after Roblox's join prompt.
--   Event         while EVENT runs (from .. to, Unix seconds UTC), every player who joins gets its
--                 items for good (server/Purchases.event_gift, once per event); outside it the card
--                 is hidden.
local Promos = {}

Promos.GROUP_ID = 818671112
Promos.GROUP_NAME = "BloxFront"
Promos.GROUP_STARS_BONUS = 0.10

--- The running event. `skin` (Data/Cosmetics.event_skins) and `flag` (a Data/Shop key) are given free.
Promos.EVENT = {
	key = "halloween_2026",
	name = "Halloween Event",
	-- 2026-10-27 00:00 .. 2026-11-03 00:00 UTC (the Halloween flag set's sale ends then too)
	from = 1793059200,
	to = 1793664000,
	skin = "ev_jack_o_lantern",
	flag = "phantom",
}

--- Is the event on at unix time `t`?
function Promos.event_on(t: number): boolean
	local e = Promos.EVENT
	return e ~= nil and t >= e.from and t < e.to
end

--- What a match's Stars gain (`total` before 2x Stars) for a group member: whole QUANTUMs, at least one.
function Promos.group_bonus(total: number, quantum: number): number
	if total <= 0 then
		return 0
	end
	local q = math.max(quantum, 1)
	return math.max(q, math.floor(total * Promos.GROUP_STARS_BONUS / q) * q)
end

return Promos
