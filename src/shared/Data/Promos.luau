--!strict
-- BloxFront promos (2026-10-27): the free cards on the title screen's right, under General's.
--
--   Group bonus   join the BloxFront group (GROUP_ID) for +GROUP_STARS_BONUS on every match's Stars,
--                 like a boost (server/Rewards: the "group" line). The server asks Roblox whether the
--                 player is in the group (server/Promos), on joining and when the client asks again
--                 after Roblox's join prompt.
--   Event         announced from `announce` (the card shows: STARTS IN, and its window offers Roblox's
--                 RSVP prompt for the experience event `rsvp_id`, SocialService:PromptRsvpToEventAsync);
--                 while it runs (from .. to, Unix seconds UTC) every player who joins, or is already
--                 here when it starts, gets its items for good (server/Purchases.event_gift, once per
--                 event). After `to` the card is gone.
local Promos = {}

Promos.GROUP_ID = 818671112
Promos.GROUP_NAME = "BloxFront"
Promos.GROUP_STARS_BONUS = 0.10

--- The running event. `skin` (Data/Cosmetics.event_skins) and `flag` (a Data/Shop key) are given free.
Promos.EVENT = {
	key = "halloween_2026",
	name = "Halloween Event",
	-- the card from 2026-10-27; the event 2026-10-30 20:00 .. 2026-11-01 20:00 German time (CET, UTC+1),
	-- as the Roblox experience event on the Creator Dashboard
	announce = 1793059200,
	from = 1793386800,
	to = 1793559600,
	-- the Roblox experience event's id (Creator Dashboard -> Events: the number in its link); "" = no
	-- RSVP button
	rsvp_id = "8369433822273602127",
	skin = "ev_jack_o_lantern",
	flag = "phantom",
}

--- Is the event on at unix time `t`?
function Promos.event_on(t: number): boolean
	local e = Promos.EVENT
	return e ~= nil and t >= e.from and t < e.to
end

--- Is the event's card shown at unix time `t` (announced, not over)?
function Promos.event_shown(t: number): boolean
	local e = Promos.EVENT
	return e ~= nil and t >= (e.announce or e.from) and t < e.to
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
