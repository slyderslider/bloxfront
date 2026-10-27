--!nonstrict
-- BloxFront's free cards on the title screen (Data/Promos; 2026-10-27), side by side under General's
-- button: "group" (an indigo card, +10% and a star, a green FREE tab: join the group for +10% Stars)
-- and "event" (an orange-to-purple card with the event's skin, FREE SKIN, while the event runs).
-- pressed() -> UIRoot opens PromoOffer. The tab says ACTIVE / CLAIMED once the server says so.
--
--   PromoCard.new(ctx, kind)   :set_scale(k)   :size_px()   :refresh()   .pressed (Signal)
local UITheme = require("./UITheme")
local W = require("./Widgets")
local UICtx = require("./UICtx")
local Locker = require("./Locker")
local Signal = UITheme.core("Signal")

local IS_ROBLOX = typeof(game) == "Instance"
local TweenService = if IS_ROBLOX then game:GetService("TweenService") else nil
local Promos = UICtx.data("Promos")
local Cosmetics = UICtx.data("Cosmetics")

local PromoCard = W.class(W.Control)

--- One card, desktop logical px (two of them and their gap are as wide as General's button).
PromoCard.SIZE = Vector2.new(110, 82)
PromoCard.PHONE_K = 0.72
PromoCard.SHINE_S = 4.6

local WHITE = Color3.new(1, 1, 1)
local INK = Color3.fromRGB(16, 12, 40)
local GREEN = Color3.fromRGB(64, 214, 120)
local GREEN_DARK = Color3.fromRGB(24, 140, 70)
local FONT_H = Font.fromId(UITheme.FONT_ID, Enum.FontWeight.Heavy)
local FONT_B = Font.fromId(UITheme.FONT_ID, Enum.FontWeight.Bold)

local LOOK = {
	group = {
		top = Color3.fromRGB(122, 112, 255),
		bottom = Color3.fromRGB(38, 30, 120),
		edge = Color3.fromRGB(190, 184, 255),
	},
	event = {
		top = Color3.fromRGB(255, 132, 38),
		bottom = Color3.fromRGB(64, 22, 96),
		edge = Color3.fromRGB(255, 196, 120),
	},
}

local function new(class: string, props: { [string]: any }, parent: Instance?): any
	local i = Instance.new(class)
	for k, v in props do
		(i :: any)[k] = v
	end
	if parent then
		i.Parent = parent
	end
	return i
end

local function tween(inst: Instance, t: number, props: { [string]: any })
	if TweenService ~= nil then
		TweenService:Create(inst, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	end
end

local function text(parent: Instance, props: { [string]: any }): TextLabel
	props.BackgroundTransparency = 1
	props.FontFace = props.FontFace or FONT_H
	props.TextColor3 = props.TextColor3 or WHITE
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	return new("TextLabel", props, parent)
end

function PromoCard.new(c: any, kind: string)
	local self = setmetatable({}, PromoCard.__mt)
	W.Control._init(self)
	self.ctx = c
	self.kind = kind
	self.pressed = Signal.new()
	self._k = 1.0
	self._t = math.random() * 2
	self._shine_t = if kind == "event" then 1.5 else 0.0
	self._state = nil
	self:set_mouse_filter(W.MOUSE_IGNORE)
	if IS_ROBLOX then
		self:_build()
	end
	self:refresh()
	self:set_process(true)
	return self
end

function PromoCard._build(self)
	local look = LOOK[self.kind] or LOOK.group
	local root = self.gui
	root.ClipsDescendants = false
	local S = PromoCard.SIZE
	local body = new("Frame", {
		Name = "Body",
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(S.X, S.Y),
	}, root)
	self._scale = new("UIScale", {}, body)
	local card = new("Frame", {
		Name = "Card",
		BackgroundColor3 = WHITE,
		ClipsDescendants = true,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 2,
	}, body)
	new("UICorner", { CornerRadius = UDim.new(0, 14) }, card)
	new("UIGradient", { Color = ColorSequence.new(look.top, look.bottom), Rotation = 90 }, card)
	new("UIStroke", {
		Color = look.edge,
		Thickness = 2,
		Transparency = 0.15,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, card)
	local art = UITheme.crate_art()
	self._rays = new("ImageLabel", {
		BackgroundTransparency = 1,
		Image = art.rays or "",
		ImageColor3 = WHITE,
		ImageTransparency = 0.82,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.42),
		Size = UDim2.fromOffset(130, 130),
		ZIndex = 3,
	}, card)
	if self.kind == "event" then
		text(card, {
			Text = "HALLOWEEN",
			FontFace = FONT_B,
			TextSize = 11,
			TextColor3 = Color3.fromRGB(255, 228, 190),
			Position = UDim2.fromOffset(0, 6),
			Size = UDim2.new(1, 0, 0, 14),
			ZIndex = 6,
		})
		local frame = new("Frame", {
			BackgroundColor3 = Color3.fromRGB(20, 10, 30),
			BackgroundTransparency = 0.35,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromOffset(S.X / 2, 22),
			Size = UDim2.fromOffset(34, 34),
			ZIndex = 4,
		}, card)
		new("UICorner", { CornerRadius = UDim.new(0, 8) }, frame)
		new("UIStroke", { Color = Color3.fromRGB(255, 196, 120), Thickness = 1.5, Transparency = 0.2 }, frame)
		local img = new("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -6, 1, -6),
			Position = UDim2.fromOffset(3, 3),
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 5,
		}, frame)
		new("UICorner", { CornerRadius = UDim.new(0, 6) }, img)
		self._icon = frame
		pcall(Locker.show_item, img, Cosmetics.item(Promos.EVENT and Promos.EVENT.skin))
		local t = text(card, {
			Text = "FREE SKIN",
			TextSize = 15,
			Position = UDim2.fromOffset(0, 58),
			Size = UDim2.new(1, 0, 0, 18),
			ZIndex = 6,
		})
		new("UIStroke", { Color = INK, Thickness = 1.5, Transparency = 0.2 }, t)
	else
		local big = text(card, {
			Text = string.format("+%d%%", math.floor(Promos.GROUP_STARS_BONUS * 100 + 0.5)),
			TextSize = 30,
			Position = UDim2.fromOffset(0, 12),
			Size = UDim2.new(1, 0, 0, 34),
			ZIndex = 6,
		})
		new("UIStroke", { Color = INK, Thickness = 2, Transparency = 0.15 }, big)
		self._icon = big
		local star = new("ImageLabel", {
			BackgroundTransparency = 1,
			Image = UITheme.icon("star") or "",
			ImageColor3 = UITheme.GOLD,
			ScaleType = Enum.ScaleType.Fit,
			Position = UDim2.fromOffset(20, 52),
			Size = UDim2.fromOffset(16, 16),
			ZIndex = 6,
		}, card)
		self._star = star
		local t = text(card, {
			Text = "STARS",
			TextSize = 15,
			TextXAlignment = Enum.TextXAlignment.Left,
			Position = UDim2.fromOffset(40, 51),
			Size = UDim2.fromOffset(64, 18),
			ZIndex = 6,
		})
		new("UIStroke", { Color = INK, Thickness = 1.5, Transparency = 0.2 }, t)
	end
	self._shine = new("Frame", {
		BackgroundColor3 = WHITE,
		BackgroundTransparency = 0.8,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(-0.3, 0.5),
		Size = UDim2.new(0, 18, 1.8, 0),
		Rotation = 18,
		ZIndex = 7,
	}, card)
	-- the FREE tab, out over the top-right corner
	local tab = new("Frame", {
		Name = "Tab",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = WHITE,
		Position = UDim2.fromOffset(S.X - 22, 1),
		Size = UDim2.fromOffset(54, 20),
		Rotation = 6,
		ZIndex = 9,
	}, body)
	new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, tab)
	self._tab_grad = new("UIGradient", { Color = ColorSequence.new(GREEN, GREEN_DARK), Rotation = 90 }, tab)
	new("UIStroke", {
		Color = INK,
		Thickness = 1.5,
		Transparency = 0.3,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, tab)
	self._tab = tab
	self._tab_text = text(tab, { Text = "FREE", TextSize = 11, Size = UDim2.fromScale(1, 1), ZIndex = 10 })
	local hit = new("TextButton", {
		Name = "Hit",
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 20,
	}, body)
	local hover = false
	hit.MouseEnter:Connect(function()
		hover = true
		tween(self._scale, 0.12, { Scale = self:_k_px() * 1.06 })
	end)
	hit.MouseLeave:Connect(function()
		hover = false
		tween(self._scale, 0.12, { Scale = self:_k_px() })
	end)
	hit.MouseButton1Down:Connect(function()
		tween(self._scale, 0.08, { Scale = self:_k_px() * 0.94 })
	end)
	hit.MouseButton1Up:Connect(function()
		tween(self._scale, 0.12, { Scale = self:_k_px() * (if hover then 1.06 else 1) })
	end)
	hit.Activated:Connect(function()
		self.ctx:sfx("click")
		self.pressed:Fire()
	end)
end

function PromoCard._k_px(self): number
	return self._k * UITheme.scale
end

--- `k`: 1 on desktop, PHONE_K on phones (also follows UITheme.scale: call it from apply_layout).
function PromoCard.set_scale(self, k: number)
	self._k = k
	if self._scale ~= nil then
		self._scale.Scale = self:_k_px()
	end
	self:set_min_size(self:size_px())
end

function PromoCard.size_px(self): Vector2
	return PromoCard.SIZE * self._k
end

--- The event's card shows while it runs (the server's word, else this device's clock); the tab says
--- whether the promo is already the player's.
function PromoCard.refresh(self)
	local s = self.ctx.session
	local promo = if s ~= nil then s.promo else nil
	local done = false
	local soon = false
	if self.kind == "event" then
		local t = os.time()
		local shown = Promos.event_shown(t)
		soon = not Promos.event_on(t)
		if promo ~= nil and promo.event ~= nil then
			shown = true
			soon = promo.event.on ~= true
			done = promo.event.claimed == true
		end
		self:set_visible(shown)
	else
		done = promo ~= nil and promo.group == true
	end
	local state = if done then "done" elseif soon then "soon" else "free"
	if self._tab_text == nil or state == self._state then
		return
	end
	self._state = state
	self._tab_text.Text = if state == "done"
		then (if self.kind == "event" then "CLAIMED" else "ACTIVE")
		elseif state == "soon" then "SOON"
		else "FREE"
	self._tab.Size = UDim2.fromOffset(if state == "done" then 64 else 54, 20)
end

function PromoCard._process(self, dt: number)
	if not self.visible or self._rays == nil then
		return
	end
	self._t += dt
	local t = self._t
	self._rays.Rotation = (t * 14) % 360
	self._tab.Rotation = 6 + math.sin(t * 2.6) * 3
	if self._star ~= nil then
		self._star.Rotation = math.sin(t * 2.0) * 12
	end
	if self._icon ~= nil and self.kind == "event" then
		self._icon.Rotation = math.sin(t * 1.7) * 6
	end
	self._shine_t += dt
	if self._shine_t >= PromoCard.SHINE_S then
		self._shine_t = 0
		self._shine.Position = UDim2.fromScale(-0.3, 0.5)
		tween(self._shine, 0.6, { Position = UDim2.fromScale(1.3, 0.5) })
	end
end

return PromoCard
