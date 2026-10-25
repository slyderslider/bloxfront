--!strict
-- The lobby service's shared secret (HMAC-SHA256). BloxFront (2026-10-26): no lobby service is run,
-- the lobby list lives in MemoryStore only (LobbyHttp.ENABLED = false), so no secret is needed. If you
-- ever run your own service, keep its secret out of the public repo (e.g. load it from a private
-- place, never commit it).
return ""
