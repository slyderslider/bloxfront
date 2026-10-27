--!nonstrict
-- BloxFront admin panel (2026-10-26): a test drawer for the game's admins (Session.is_admin: the owner, or
-- rank 254+ in the owning group; everyone in a Studio playtest). Opened from the top bar's "A" button
-- (Main). Everything is for this match only and nothing is saved: gold / troops / the whole Arsenal
-- (Session.admin), skins and flags tried on in this match's mirror (only you see them), and in Studio the
-- real purchase prompts of every developer product (free test purchases there). A match played with it
-- earns no Stars.
--
-- API: AdminPanel.new(session) -> panel; panel:toggle(), panel:close(), panel.is_open.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AdminPanel = {}
AdminPanel.__index = AdminPanel

local FONT = Font.fromId(12187365977, Enum.FontWeight.Bold)
local FONT_M = Font.fromId(12187365977, Enum.FontWeight.Medium)
local BG = Color3.fromRGB(19, 22, 27)
local RAISED = Color3.fromRGB(38, 44, 53)
local INDIGO = Color3.fromRGB(108, 99, 255)
local TEXT = Color3.fromRGB(245, 247, 250)
local TEXT_3 = Color3.fromRGB(128, 138, 150)
local GOLD = Color3.fromRGB(255, 214, 102)
local RED = Color3.fromRGB(255, 90, 100)

AdminPanel.WIDTH = 320
--- Infinite gold keeps at least this much; infinite troops refill to the cap. Checked once a second.
AdminPanel.INFINITE_GOLD = 5000000
AdminPanel.TICK_S = 1.0

local function new(class: string, props: { [string]: any }, parent: Instance?): any
	local o = Instance.new(class)
	for k, v in props do
		(o :: any)[k] = v
	end
	if parent then
		o.Parent = parent
	end
	return o
end

local function corner(o: Instance, r: number)
	new("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

function AdminPanel.new(session: any)
	local self = setmetatable({}, AdminPanel)
	self.session = session
	self.is_open = false
	self.infinite_gold = false
	self.infinite_troops = false
	self._order = 0
	self:_build()
	self._acc = 0.0
	self._conn = RunService.Heartbeat:Connect(function(dt: number)
		self:_tick(dt)
	end)
	return self
end

function AdminPanel._next(self): number
	self._order += 1
	return self._order
end

function AdminPanel._build(self)
	local gui = new("ScreenGui", {
		Name = "BloxFrontAdmin",
		ResetOnSpawn = false,
		IgnoreGuiInset = false,
		DisplayOrder = 60,
		Enabled = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, Players.LocalPlayer:WaitForChild("PlayerGui"))
	self.gui = gui
	local panel = new("Frame", {
		Name = "Panel",
		BackgroundColor3 = BG,
		BackgroundTransparency = 0.04,
		Position = UDim2.new(0, 16, 0, 64),
		Size = UDim2.new(0, AdminPanel.WIDTH, 1, -80),
	}, gui)
	corner(panel, 16)
	new("UIStroke", { Color = INDIGO, Transparency = 0.5, Thickness = 1 }, panel)
	local head = new("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 58) }, panel)
	new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 10),
		Size = UDim2.new(1, -64, 0, 22),
		FontFace = FONT,
		TextSize = 18,
		TextColor3 = TEXT,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "ADMIN",
	}, head)
	new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(16, 32),
		Size = UDim2.new(1, -64, 0, 16),
		FontFace = FONT_M,
		TextSize = 12,
		TextColor3 = TEXT_3,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "This match only · nothing is saved · no Stars",
	}, head)
	local close = new("TextButton", {
		BackgroundColor3 = RAISED,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 12),
		Size = UDim2.fromOffset(32, 32),
		FontFace = FONT,
		TextSize = 16,
		TextColor3 = TEXT,
		Text = "X",
		AutoButtonColor = true,
	}, head)
	corner(close, 8)
	close.Activated:Connect(function()
		self:close()
	end)
	local list = new("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 58),
		Size = UDim2.new(1, 0, 1, -64),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = INDIGO,
	}, panel)
	new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, list)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		PaddingBottom = UDim.new(0, 14),
	}, list)
	self.list = list
	self.status = self:_label("", TEXT_3)

	self:_caption("SERVER RESTART (all servers)")
	self:_row({
		{ "In 1 min", function()
			self:_do("restart", 1)
		end },
		{ "In 5 min", function()
			self:_do("restart", 5)
		end },
		{ "In 10 min", function()
			self:_do("restart", 10)
		end },
	})
	self:_row({
		{ "Cancel restart", function()
			self:_do("restart", 0)
		end, RED },
	})
	self:_label(
		"Publish first. At 0:00 running matches are paid and ended; then click \"Migrate to Latest Update\" in the Creator Dashboard.",
		TEXT_3
	)

	self:_caption("MATCH")
	self:_row({
		{ "+10K Gold", function()
			self:_do("gold", 10000)
		end },
		{ "+1M Gold", function()
			self:_do("gold", 1000000)
		end },
	})
	self._gold_btn = self:_row({
		{ "Infinite Gold: off", function(b)
			self.infinite_gold = not self.infinite_gold
			b.Text = "Infinite Gold: " .. (if self.infinite_gold then "on" else "off")
			b.BackgroundColor3 = if self.infinite_gold then INDIGO else RAISED
			self:_say(if self.infinite_gold then "Gold stays at 5M or more" else "Infinite gold off")
		end },
	})
	self:_row({
		{ "+10K Troops", function()
			self:_do("troops", 10000)
		end },
		{ "Max Troops", function()
			self:_do("fill")
		end },
	})
	self:_row({
		{ "Infinite Troops: off", function(b)
			self.infinite_troops = not self.infinite_troops
			b.Text = "Infinite Troops: " .. (if self.infinite_troops then "on" else "off")
			b.BackgroundColor3 = if self.infinite_troops then INDIGO else RAISED
			self:_say(if self.infinite_troops then "Troops refill to the cap" else "Infinite troops off")
		end },
	})
	self:_row({
		{ "Unlock whole Arsenal", function()
			self:_do("unlock_all")
		end },
	})

	self:_caption("SOLO ONLY")
	self:_row({
		{ "1x", function()
			self:_do("speed", 1)
		end },
		{ "2x", function()
			self:_do("speed", 2)
		end },
		{ "4x", function()
			self:_do("speed", 4)
		end },
		{ "8x", function()
			self:_do("speed", 8)
		end },
	})
	self:_row({
		{ "Eliminate me (test defeat)", function()
			self:_do("eliminate")
		end, RED },
	})

	self:_caption("TRY ON SKINS (only you see them)")
	self:_cosmetic_grid("skin")
	self:_caption("TRY ON FLAGS")
	self:_cosmetic_grid("flag")

	if RunService:IsStudio() then
		self:_caption("STUDIO TESTS (Studio test data, not live)")
		self:_row({
			{ "+10K Stars", function()
				self:_do("stars", 10000)
			end },
			{ "+100K Stars", function()
				self:_do("stars", 100000)
			end },
		})
		self:_label("Developer products (Studio test purchases are free):", TEXT_3)
		self:_product_buttons()
	end
end

function AdminPanel._caption(self, text: string)
	new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 22),
		FontFace = FONT,
		TextSize = 11,
		TextColor3 = INDIGO,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Bottom,
		Text = text,
		LayoutOrder = self:_next(),
	}, self.list)
end

function AdminPanel._label(self, text: string, color: Color3): TextLabel
	return new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		FontFace = FONT_M,
		TextSize = 12,
		TextWrapped = true,
		TextColor3 = color,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = text,
		LayoutOrder = self:_next(),
	}, self.list)
end

--- One row of equal buttons: { {text, fn(button), colour?} }. Returns the last button.
function AdminPanel._row(self, buttons: { any }): TextButton
	local row = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = self:_next(),
	}, self.list)
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, row)
	local n = #buttons
	local last
	for i, spec in buttons do
		local b = new("TextButton", {
			BackgroundColor3 = spec[3] or RAISED,
			Size = UDim2.new(1 / n, -(6 * (n - 1)) / n, 1, 0),
			FontFace = FONT,
			TextSize = 13,
			TextColor3 = TEXT,
			Text = spec[1],
			AutoButtonColor = true,
			LayoutOrder = i,
		}, row)
		corner(b, 8)
		new("UIStroke", { Color = Color3.new(0, 0, 0), Transparency = 0.6, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual }, b)
		b.Activated:Connect(function()
			spec[2](b)
		end)
		last = b
	end
	return last
end

function AdminPanel._cosmetic_grid(self, kind: string)
	local ok, Cosmetics = pcall(function()
		return require(ReplicatedStorage:WaitForChild("Airfront").Data.Cosmetics)
	end)
	if not ok or type(Cosmetics) ~= "table" then
		self:_label("Cosmetics did not load", RED)
		return
	end
	local items = { { id = false, name = "None" } }
	if kind == "skin" then
		for _, it in Cosmetics.all() do
			if it.kind == "skin" then
				table.insert(items, it)
			end
		end
		for _, it in Cosmetics.exclusives() do
			table.insert(items, it)
		end
	else
		for _, it in Cosmetics.shop_items() do
			table.insert(items, it)
		end
	end
	local grid = new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = self:_next(),
	}, self.list)
	new("UIGridLayout", {
		CellSize = UDim2.new(0.5, -3, 0, 28),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, grid)
	for i, it in items do
		local b = new("TextButton", {
			BackgroundColor3 = RAISED,
			FontFace = FONT_M,
			TextSize = 12,
			TextColor3 = if it.rarity == "legendary" or it.rarity == "exclusive" then GOLD else TEXT,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Text = it.name or tostring(it.id),
			AutoButtonColor = true,
			LayoutOrder = i,
		}, grid)
		corner(b, 6)
		b.Activated:Connect(function()
			self:_wear(kind, it.id)
		end)
	end
end

function AdminPanel._product_buttons(self)
	local ok, Products = pcall(function()
		return require(ReplicatedStorage:WaitForChild("Airfront").Data.Products)
	end)
	if not ok or type(Products) ~= "table" then
		self:_label("Products did not load", RED)
		return
	end
	local keys = {}
	for k, p in Products do
		if type(p) == "table" and type(p.id) == "number" and p.id > 0 then
			table.insert(keys, k)
		end
	end
	table.sort(keys, function(a, b)
		local fa, fb = string.sub(a, 1, 5) == "shop_", string.sub(b, 1, 5) == "shop_"
		if fa ~= fb then
			return fb
		end
		return a < b
	end)
	for _, k in keys do
		local p = Products[k]
		self:_row({
			{ string.format("%s · R$ %d", k, p.robux or 0), function()
				MarketplaceService:PromptProductPurchase(Players.LocalPlayer, p.id)
				self:_say("Purchase prompt: " .. k)
			end },
		})
	end
end

function AdminPanel._say(self, text: string)
	self.status.Text = text
end

function AdminPanel._do(self, action: string, arg: any?)
	local s = self.session
	if s == nil or not s.is_admin then
		self:_say("Not an admin")
		return
	end
	local ok = s:admin(action, arg)
	self:_say(if ok then ("Done: " .. action .. (if arg ~= nil then " " .. tostring(arg) else "")) else ("Not now: " .. action .. " (in a match?)"))
end

--- Tries a skin / flag on for this match, in this device's mirror only (the next cosmetics update of a
--- public match puts your own back).
function AdminPanel._wear(self, kind: string, id: any)
	local st = self.session and self.session.state
	local me = st and st.local_owner or 0
	if st == nil or me == 0 or type(st.set_cosmetics) ~= "function" then
		self:_say("Start a match first")
		return
	end
	local c = table.clone((st.cosmetics or {})[me] or {})
	c[kind] = if id == false then nil else id
	st:set_cosmetics({ [me] = c })
	self:_say(kind .. ": " .. (if id == false then "none" else tostring(id)))
end

function AdminPanel._tick(self, dt: number)
	if not (self.infinite_gold or self.infinite_troops) then
		return
	end
	self._acc += dt
	if self._acc < AdminPanel.TICK_S then
		return
	end
	self._acc = 0.0
	local s = self.session
	if s == nil or not s.is_admin then
		return
	end
	if self.infinite_gold then
		s:admin("gold_min", AdminPanel.INFINITE_GOLD)
	end
	if self.infinite_troops then
		s:admin("fill")
	end
end

function AdminPanel.toggle(self)
	if self.is_open then
		self:close()
	else
		self.is_open = true
		self.gui.Enabled = true
	end
end

function AdminPanel.close(self)
	self.is_open = false
	self.gui.Enabled = false
end

return AdminPanel
