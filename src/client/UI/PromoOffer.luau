--!nonstrict
-- The window behind BloxFront's free cards (Data/Promos; 2026-10-27), as General's (GeneralOffer):
--   "group"  join the BloxFront group for +10% Stars on every match. JOIN GROUP opens Roblox's own
--            prompt (GroupService:PromptJoinAsync); the server then checks again (Session.promo_check)
--            and says so (OP.PROMO), and the window shows the boost as on.
--   "event"  the event: before it starts, when (in the player's own time) and NOTIFY ME, Roblox's RSVP
--            prompt for the experience event (SocialService:PromptRsvpToEventAsync); while it runs,
--            everyone who joins gets its skin and flag for good (server/Promos). EQUIP SKIN puts the
--            skin on.
--
--   PromoOffer.new(ctx)   :bind(session)   :open(kind)   :close()   .closed (Signal)   .is_open
local UITheme = require("./UITheme")
local W = require("./Widgets")
local GlassPanel = require("./GlassPanel")
local UICtx = require("./UICtx")
local Locker = require("./Locker")
local Signal = UITheme.core("Signal")

local IS_ROBLOX = typeof(game) == "Instance"
local Promos = UICtx.data("Promos")
local Cosmetics = UICtx.data("Cosmetics")
local Shop = UICtx.data("Shop")

local PromoOffer = W.class(W.Control)

PromoOffer.W = 340
PromoOffer.COMPACT_W = 280

local ORANGE = Color3.fromRGB(255, 150, 60)
local INDIGO_HI = Color3.fromRGB(165, 159, 255)

function PromoOffer.new(c: any)
	local self = setmetatable({}, PromoOffer.__mt)
	W.Control._init(self)
	self.ctx = c
	self.closed = Signal.new()
	self.is_open = false
	self.kind = "group"
	self:set_anchors_and_offsets_preset(W.PRESET_FULL_RECT)
	self:set_mouse_filter(W.MOUSE_STOP)
	self:set_visible(false)
	self._dim = W.ColorRect.new(UITheme.rgba(0.01, 0.015, 0.05, 0.78))
	self._dim:set_anchors_and_offsets_preset(W.PRESET_FULL_RECT)
	self._dim.gui_input:Connect(function(e)
		if e.pressed and not self._panel:has_global_point(e.global_position) then
			self:close()
		end
	end)
	self:add_child(self._dim)
	self:_build()
	self:set_process(true)
	return self
end

function PromoOffer._build(self)
	self._panel = GlassPanel.new(24.0, 18.0, 18, true, 34)
	self._panel:set_tint(UITheme.rgba(0.05, 0.05, 0.13, 0.97))
	self:add_child(self._panel)
	local v = UITheme.vbox(10)
	self._v = v
	self._panel:add_child(v)
	local head = UITheme.hbox(10)
	self._cap = UITheme.caption("", 11, UITheme.AMBER_HI)
	self._cap.size_flags_horizontal = W.EXPAND_FILL
	self._cap.size_flags_vertical = W.SHRINK_CENTER
	head:add_child(self._cap)
	local close = W.Button.new("", "GhostButton")
	close:set_icon("close")
	close.expand_icon = true
	close:set_min_size(Vector2.new(34, 34))
	close:add_theme_constant_override("icon_max_width", 13)
	close:add_theme_stylebox_override("normal", UITheme.empty_box(8, 8))
	close:add_theme_stylebox_override("hover", UITheme.flat(UITheme.FILL, 8, UITheme.CLEAR, 0, 8, 8))
	close.size_flags_vertical = W.SHRINK_CENTER
	close.pressed:Connect(function()
		self:close()
	end)
	head:add_child(close)
	v:add_child(head)
	self._title = UITheme.label("", 26, 800, UITheme.TEXT, 2)
	v:add_child(self._title)
	self._sub = UITheme.label("", 13, 500, UITheme.TEXT_2)
	self._sub:set_autowrap(true)
	v:add_child(self._sub)
	self._row1 = self:_row(v)
	self._row2 = self:_row(v)
	self._time = UITheme.label("", 12, 700, ORANGE)
	self._time:set_alignment(W.ALIGN_CENTER)
	v:add_child(self._time)
	self._buy = UITheme.button("", "PrimaryButton", "", 48.0)
	self._buy.pressed:Connect(function()
		self:_act()
	end)
	v:add_child(self._buy)
	self._note = UITheme.label("", 11, 500, UITheme.TEXT_3)
	self._note:set_alignment(W.ALIGN_CENTER)
	self._note:set_autowrap(true)
	v:add_child(self._note)
end

--- A row: a picture (an icon, or an item shown as the Locker shows it) in a disc, a bold line and a
--- muted one under it.
function PromoOffer._row(_self, parent: any): any
	local row = UITheme.hbox(12)
	local disc = W.Panel.new()
	disc:set_mouse_filter(W.MOUSE_IGNORE)
	disc:set_min_size(Vector2.new(44, 44))
	disc.size_flags_vertical = W.SHRINK_CENTER
	disc:add_theme_stylebox_override("panel", UITheme.flat(UITheme.FILL_2, 12, UITheme.c(UITheme.TEXT, 0.25), 1))
	local img = nil
	if IS_ROBLOX then
		img = Instance.new("ImageLabel")
		img.BackgroundTransparency = 1
		img.AnchorPoint = Vector2.new(0.5, 0.5)
		img.Position = UDim2.fromScale(0.5, 0.5)
		img.Size = UDim2.new(1, -10, 1, -10)
		img.ScaleType = Enum.ScaleType.Fit
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = img
		img.Parent = disc.gui
	end
	row:add_child(disc)
	local col = UITheme.vbox(2)
	col.size_flags_horizontal = W.EXPAND_FILL
	col.size_flags_vertical = W.SHRINK_CENTER
	local h = UITheme.label("", 15, 700, UITheme.TEXT)
	local b = UITheme.label("", 12, 500, UITheme.TEXT_2)
	b:set_autowrap(true)
	col:add_child(h)
	col:add_child(b)
	row:add_child(col)
	parent:add_child(row)
	return { head = h, body = b, disc = disc, img = img }
end

local function show_icon(r: any, icon: string, color: Color3)
	if r.img == nil then
		return
	end
	Locker.show_item(r.img, nil)
	r.img.ResampleMode = Enum.ResamplerMode.Default
	r.img.Image = UITheme.icon(icon) or ""
	r.img.ImageColor3 = color
	r.img.Size = UDim2.new(0.6, 0, 0.6, 0)
end

local function show_thing(r: any, it: any)
	if r.img == nil then
		return
	end
	r.img.ImageColor3 = Color3.new(1, 1, 1)
	r.img.Size = UDim2.new(1, -10, 1, -10)
	Locker.show_item(r.img, it)
end

function PromoOffer.bind(self, s: any)
	self.session = s
	if s ~= nil and s.promo_changed ~= nil then
		self:_connect(s.promo_changed:Connect(function(promo: any)
			if self.is_open then
				self:refresh()
			end
		end))
	end
end

function PromoOffer._promo(self): any
	local s = self.ctx.session
	return if s ~= nil and s.promo ~= nil then s.promo else { group = false }
end

local function time_left(to: number, what: string?): string
	local left = math.max(0, to - os.time())
	local d = math.floor(left / 86400)
	local h = math.floor(left % 86400 / 3600)
	local m = math.floor(left % 3600 / 60)
	if d > 0 then
		return string.format("%s %dd %dh", what or "Ends in", d, h)
	end
	return string.format("%s %dh %dm", what or "Ends in", h, m)
end

function PromoOffer.refresh(self)
	local promo = self:_promo()
	if self.kind == "event" then
		local ev = Promos.EVENT
		local claimed = promo.event ~= nil and promo.event.claimed == true
		local started = if promo.event ~= nil then promo.event.on == true else Promos.event_on(os.time())
		local skin = Cosmetics.item(ev.skin)
		local flag = if Shop.flag(ev.flag) ~= nil then Cosmetics.item(Shop.item_id(ev.flag)) else nil
		self._cap:set_text("LIMITED EVENT")
		self._title:set_text(string.upper(ev.name))
		self._title:set_color(ORANGE)
		self._sub:set_text(
			string.format(
				"Join the game between %s and %s and get these for free. Yours to keep!",
				os.date("%b %d, %H:%M", ev.from),
				os.date("%b %d, %H:%M", ev.to)
			)
		)
		self._row1.head:set_text((if skin ~= nil then skin.name else "Halloween") .. " skin")
		self._row1.body:set_text("A spooky territory skin for your nation.")
		show_thing(self._row1, skin)
		self._row2.head:set_text((if flag ~= nil then flag.name else "Halloween") .. " flag")
		self._row2.body:set_text("From the Halloween flag set.")
		show_thing(self._row2, flag)
		self._row2.disc:set_visible(true)
		self._time:set_text(if started then time_left(ev.to) else time_left(ev.from, "Starts in"))
		self._time:set_visible(true)
		local s = self.ctx.session
		local worn = s ~= nil
			and type(s.inventory) == "table"
			and type(s.inventory.equipped) == "table"
			and s.inventory.equipped.skin == ev.skin
		if not started then
			local rsvp = type(ev.rsvp_id) == "string" and ev.rsvp_id ~= ""
			-- (always pressable: a prompt closed by accident can be opened again; 2026-10-27: Roman)
			self._buy:set_text(if self._rsvp_done then "NOTIFIED ✓" elseif rsvp then "NOTIFY ME" else "STARTS SOON")
			self._buy:set_disabled(not rsvp)
			self._note:set_text(
				if self._rsvp_done
					then "You'll get a notification when it starts. Tap again to change it."
					else "Come back when it starts: the gifts arrive as soon as you join."
			)
		elseif claimed then
			self._buy:set_text(if worn then "SKIN EQUIPPED" else "EQUIP SKIN")
			self._buy:set_disabled(worn)
			self._note:set_text("Both are in your Locker.")
		else
			self._buy:set_text("CLAIMING…")
			self._buy:set_disabled(true)
			self._note:set_text("They arrive a moment after you join.")
		end
	else
		local on = promo.group == true
		local pct = math.floor(Promos.GROUP_STARS_BONUS * 100 + 0.5)
		self._cap:set_text("FREE BOOST")
		self._title:set_text(string.format("+%d%% STARS", pct))
		self._title:set_color(INDIGO_HI)
		self._sub:set_text(
			string.format("Join the %s group and get %d%% more Stars from every match.", Promos.GROUP_NAME, pct)
		)
		self._row1.head:set_text(string.format("+%d%% Stars every match", pct))
		self._row1.body:set_text("Works like a boost, on top of 2x Stars. Free, for as long as you stay.")
		show_icon(self._row1, "star", UITheme.GOLD)
		self._row2.head:set_text("Join the group")
		self._row2.body:set_text("One tap below. Group ID " .. tostring(Promos.GROUP_ID) .. ".")
		show_icon(self._row2, "users", INDIGO_HI)
		self._time:set_visible(false)
		if on then
			self._buy:set_text("BOOST ACTIVE")
			self._buy:set_disabled(true)
			self._note:set_text("Thanks for joining! Every match pays +" .. pct .. "% Stars.")
		else
			self._buy:set_text("JOIN GROUP")
			self._buy:set_disabled(false)
			self._note:set_text("Already joined? Tap JOIN GROUP and we check again.")
		end
	end
	if self.is_open and self.visible then
		self:apply_layout()
	end
end

function PromoOffer._act(self)
	local s = self.ctx.session
	if self.kind == "event" then
		local ev = Promos.EVENT
		local promo = self:_promo()
		local started = if promo.event ~= nil then promo.event.on == true else Promos.event_on(os.time())
		if not started then
			-- Roblox's RSVP prompt for the experience event (a notification when it starts)
			if IS_ROBLOX and type(ev.rsvp_id) == "string" and ev.rsvp_id ~= "" then
				task.spawn(function()
					local ok, status = pcall(function()
						return (game:GetService("SocialService") :: any):PromptRsvpToEventAsync(ev.rsvp_id)
					end)
					if ok then
						self._rsvp_done = tostring(status) == "Enum.RsvpStatus.Going"
					end
					if self.is_open then
						self:refresh()
					end
				end)
			end
			return
		end
		if s ~= nil and type(s.equip) == "function" then
			s:equip("skin", ev.skin)
			self.ctx:sfx("confirm")
			task.delay(0.6, function()
				if self.is_open then
					self:refresh()
				end
			end)
		end
		return
	end
	-- (while Roblox's prompt is up a second press does nothing; closed, the button works again)
	if self:_promo().group == true or self._prompting or not IS_ROBLOX then
		return
	end
	self._prompting = true
	task.spawn(function()
		pcall(function()
			game:GetService("GroupService"):PromptJoinAsync(Promos.GROUP_ID)
		end)
		self._prompting = nil
		if s ~= nil and type(s.promo_check) == "function" then
			s:promo_check()
		end
	end)
end

function PromoOffer._process(self, dt: number)
	-- (the countdown ticks while the window is open)
	if self.is_open and self.kind == "event" then
		self._tick_t = (self._tick_t or 0) + dt
		if self._tick_t >= 1.0 then
			self._tick_t = 0
			local ev = Promos.EVENT
			local promo = self:_promo()
			local started = if promo.event ~= nil then promo.event.on == true else Promos.event_on(os.time())
			self._time:set_text(if started then time_left(ev.to) else time_left(ev.from, "Starts in"))
		end
	end
end

--- Has the player said they're going to the Roblox event (SocialService:GetEventRsvpStatusAsync)? Asked
--- each time the event's window opens, before the event.
function PromoOffer._fetch_rsvp(self)
	local ev = Promos.EVENT
	if self.kind ~= "event" or not IS_ROBLOX or type(ev.rsvp_id) ~= "string" or ev.rsvp_id == "" then
		return
	end
	if Promos.event_on(os.time()) then
		return
	end
	task.spawn(function()
		local ok, status = pcall(function()
			return (game:GetService("SocialService") :: any):GetEventRsvpStatusAsync(ev.rsvp_id)
		end)
		if ok then
			self._rsvp_done = tostring(status) == "Enum.RsvpStatus.Going"
			if self.is_open then
				self:refresh()
			end
		end
	end)
end

function PromoOffer.open(self, kind: string?)
	if self.is_open then
		return
	end
	self.kind = if kind == "event" then "event" else "group"
	self.is_open = true
	self:_fetch_rsvp()
	self:refresh()
	self:set_visible(true)
	self:apply_layout()
	self._panel:set_modulate_a(1.0)
	self._dim:set_modulate_a(0.0)
	W.fade(self._dim, 1.0, 0.2)
	UICtx.pop_in(self._panel, 0.0, 0.94, 0.3)
	self.ctx:sfx("open")
end

function PromoOffer.close(self)
	if not self.is_open then
		return
	end
	self.is_open = false
	self.ctx:sfx("close")
	local t = self:create_tween():set_parallel(true)
	t:tween_property(self._dim, "modulate:a", 0.0, 0.15)
	t:tween_property(self._panel, "modulate:a", 0.0, 0.15)
	t:chain():tween_callback(function()
		if not self.is_open then
			self:set_visible(false)
		end
	end)
	self.closed:Fire()
end

function PromoOffer.apply_layout(self)
	local ctx = self.ctx
	local compact = ctx.compact
	local w = if compact then PromoOffer.COMPACT_W else PromoOffer.W
	self._panel:set_border(if self.kind == "event" then UITheme.c(ORANGE, 0.5) else UITheme.c(INDIGO_HI, 0.5))
	self._v:set_separation(if compact then 6 else 10)
	self._title:set_font_size(if compact then 20 else 26)
	self._sub:set_min_size(Vector2.new(w, 0))
	self._note:set_min_size(Vector2.new(w, 0))
	for _, r in { self._row1, self._row2 } do
		r.head:set_font_size(if compact then 13 else 15)
		r.body:set_font_size(if compact then 11 else 12)
		r.body:set_min_size(Vector2.new(w - 56, 0))
		r.disc:set_min_size(if compact then Vector2.new(36, 36) else Vector2.new(44, 44))
	end
	self._buy:set_min_size(Vector2.new(w, if compact then 40 else 48))
	local area = ctx:clear_rect()
	local pn = self._panel
	pn:reset_size()
	local sz = pn:get_combined_minimum_size()
	local pos = area.Min + (Vector2.new(area.Width, area.Height) - sz) * 0.5
	local rp = Vector2.new(math.floor(pos.X + 0.5), math.floor(math.max(pos.Y, area.Min.Y + 4.0) + 0.5))
	pn:set_offsets(rp.X, rp.Y, rp.X, rp.Y)
	pn:reset_size()
end

return PromoOffer
