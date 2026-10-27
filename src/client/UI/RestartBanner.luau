--!strict
-- BloxFront restart countdown banner (server/Restart; 2026-10-27): while a restart is announced, a pill at
-- the top of every screen counts down ("Server update in 4:32 · Stars for your match will be paid"); at
-- 0:00 it says the update is happening, and a solo match reports its Stars (Session.restart_due).
-- Plain Instances in its own ScreenGui, above the game's UI.
--
--   RestartBanner.new(session)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local RestartBanner = {}
RestartBanner.__index = RestartBanner

local AMBER = Color3.fromRGB(255, 196, 70)
local INK = Color3.fromRGB(14, 16, 30)
local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
--- The pill's top (px, under the top bar), and how long "Updating now!" stays after 0:00 (s).
RestartBanner.TOP = 68
RestartBanner.LINGER_S = 120

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

function RestartBanner.new(session: any)
	local self = setmetatable({}, RestartBanner)
	self.session = session
	self._due_sent = false
	local gui = new("ScreenGui", {
		Name = "BloxFrontRestart",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 1000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	}, Players.LocalPlayer:WaitForChild("PlayerGui"))
	local pill = new("Frame", {
		Name = "Pill",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -60),
		Size = UDim2.fromOffset(0, 36),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = INK,
		BackgroundTransparency = 0.08,
		Visible = false,
	}, gui)
	new("UICorner", { CornerRadius = UDim.new(1, 0) }, pill)
	new("UIStroke", { Color = AMBER, Thickness = 2, Transparency = 0.1 }, pill)
	new("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) }, pill)
	self._label = new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		FontFace = FONT,
		TextSize = 15,
		TextColor3 = Color3.new(1, 1, 1),
		RichText = true,
		Text = "",
	}, pill)
	self._pill = pill
	self._shown = false
	if session.restart_changed ~= nil then
		session.restart_changed:Connect(function()
			self._due_sent = false
			self:_update()
		end)
	end
	local acc = 0
	RunService.Heartbeat:Connect(function(dt: number)
		acc += dt
		if acc >= 0.25 then
			acc = 0
			self:_update()
		end
	end)
	self:_update()
	return self
end

function RestartBanner._show(self, on: boolean)
	if on == self._shown then
		return
	end
	self._shown = on
	local pill = self._pill
	if on then
		pill.Visible = true
		pill.Position = UDim2.new(0.5, 0, 0, -60)
		TweenService:Create(
			pill,
			TweenInfo.new(0.35, Enum.EasingStyle.Back),
			{ Position = UDim2.new(0.5, 0, 0, RestartBanner.TOP) }
		)
			:Play()
	else
		local t = TweenService:Create(pill, TweenInfo.new(0.25), { Position = UDim2.new(0.5, 0, 0, -60) })
		t.Completed:Connect(function()
			if not self._shown then
				pill.Visible = false
			end
		end)
		t:Play()
	end
end

function RestartBanner._update(self)
	local at = tonumber(self.session.restart_at) or 0
	if at <= 0 then
		self:_show(false)
		return
	end
	local left = at - os.time()
	if left < -RestartBanner.LINGER_S then
		self:_show(false)
		return
	end
	if left > 0 then
		local m, s = math.floor(left / 60), left % 60
		self._label.Text = string.format(
			'<font color="#FFC446">Server update in %d:%02d</font>  ·  Stars for your match will be paid',
			m,
			s
		)
	else
		self._label.Text = '<font color="#FFC446">Updating now!</font>  ·  Your Stars were paid. See you in a moment!'
		if not self._due_sent then
			self._due_sent = true
			pcall(function()
				self.session:restart_due()
			end)
		end
	end
	self:_show(true)
end

return RestartBanner
