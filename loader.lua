-- Scripted by @neko.js
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local parentUI = game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

local activeConnections = {}
local uiTheme = {
	Current = "Dark",
	Hue = 0.9,
	Dark = {
		bg = Color3.fromRGB(12, 12, 15),
		card = Color3.fromRGB(18, 18, 22),
		text = Color3.fromRGB(245, 245, 250),
		subText = Color3.fromRGB(140, 140, 150),
		border = Color3.fromRGB(28, 28, 35)
	},
	Light = {
		bg = Color3.fromRGB(240, 240, 245),
		card = Color3.fromRGB(255, 255, 255),
		text = Color3.fromRGB(25, 25, 30),
		subText = Color3.fromRGB(110, 110, 120),
		border = Color3.fromRGB(215, 215, 225)
	}
}

local function getAccentColor()
	return Color3.fromHSV(uiTheme.Hue, 0.75, 0.95)
end

local function fadeUI(element, target, duration)
	local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	
	local function apply(item)
		if item:IsA("Frame") then
			if item.Name == "FullScreenContainer" then
				TweenService:Create(item, info, { BackgroundTransparency = target }):Play()
			elseif item.Name == "SplashFrame" or item.Name == "KeyFrame" or item.Name == "LogoContainer" or item.Name == "KeyButtonsContainer" then
				item.BackgroundTransparency = 1
			else
				local nonTransparentFrames = {
					MainFrame = true,
					KeyWindow = true,
					Sidebar = true,
					SidebarCover = true,
					SidebarDivider = true,
					HSVControl = true,
					LogoBadge = true,
					LoadingContainer = true,
					LoadingFill = true,
					OpaqueFrame = true
				}
				local defaultTrans = nonTransparentFrames[item.Name] and 0 or 1
				TweenService:Create(item, info, { BackgroundTransparency = target == 1 and 1 or defaultTrans }):Play()
			end
		elseif item:IsA("TextBox") or item:IsA("TextButton") then
			local isOpaque = item:IsA("TextBox") or item.Name == "btnClose" or item.Name == "btnTheme" or item.Name:find("KeyButton_") or item.Name == "OpaqueButton"
			local defaultBg = isOpaque and 0 or 1
			TweenService:Create(item, info, { BackgroundTransparency = target == 1 and 1 or defaultBg }):Play()
			if item:IsA("TextButton") then
				TweenService:Create(item, info, { TextTransparency = target }):Play()
			elseif item:IsA("TextBox") then
				TweenService:Create(item, info, { TextTransparency = target }):Play()
			end
		elseif item:IsA("TextLabel") then
			TweenService:Create(item, info, { TextTransparency = target }):Play()
		elseif item:IsA("ImageLabel") then
			TweenService:Create(item, info, { ImageTransparency = target }):Play()
		elseif item:IsA("UIStroke") then
			TweenService:Create(item, info, { Transparency = target }):Play()
		end
	end

	apply(element)
	for _, desc in ipairs(element:GetDescendants()) do
		apply(desc)
	end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NekoLib_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = parentUI

local fullScreenContainer = Instance.new("Frame")
fullScreenContainer.Name = "FullScreenContainer"
fullScreenContainer.Size = UDim2.new(1, 0, 1, 0)
fullScreenContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fullScreenContainer.BackgroundTransparency = 0
fullScreenContainer.BorderSizePixel = 0
fullScreenContainer.Active = true
fullScreenContainer.ZIndex = 10
fullScreenContainer.Parent = screenGui

local splashFrame = Instance.new("Frame")
splashFrame.Name = "SplashFrame"
splashFrame.Size = UDim2.new(1, 0, 1, 0)
splashFrame.BackgroundTransparency = 1
splashFrame.ZIndex = 11
splashFrame.Parent = fullScreenContainer

local logoContainer = Instance.new("Frame")
logoContainer.Name = "LogoContainer"
logoContainer.Size = UDim2.new(0, 320, 0, 80)
logoContainer.Position = UDim2.new(0.5, -160, 0.45, -40)
logoContainer.BackgroundTransparency = 1
logoContainer.ZIndex = 12
logoContainer.Parent = splashFrame

local logoBadge = Instance.new("Frame")
logoBadge.Name = "LogoBadge"
logoBadge.Size = UDim2.new(0, 70, 0, 70)
logoBadge.Position = UDim2.new(0, 10, 0.5, -35)
logoBadge.BackgroundColor3 = getAccentColor()
logoBadge.ZIndex = 13
logoBadge.Parent = logoContainer

local logoBadgeCorner = Instance.new("UICorner")
logoBadgeCorner.CornerRadius = UDim.new(0, 16)
logoBadgeCorner.Parent = logoBadge

local logoBadgeText = Instance.new("TextLabel")
logoBadgeText.Name = "LogoBadgeText"
logoBadgeText.Size = UDim2.new(1, 0, 1, 0)
logoBadgeText.BackgroundTransparency = 1
logoBadgeText.Text = "NK"
logoBadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoBadgeText.Font = Enum.Font.GothamBold
logoBadgeText.TextSize = 32
logoBadgeText.ZIndex = 14
logoBadgeText.Parent = logoBadge

local logoTitle = Instance.new("TextLabel")
logoTitle.Name = "LogoTitle"
logoTitle.Size = UDim2.new(0, 220, 0, 40)
logoTitle.Position = UDim2.new(0, 100, 0.5, -20)
logoTitle.BackgroundTransparency = 1
logoTitle.Text = "NekoLib"
logoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
logoTitle.Font = Enum.Font.GothamBold
logoTitle.TextSize = 42
logoTitle.TextXAlignment = Enum.TextXAlignment.Left
logoTitle.ZIndex = 13
logoTitle.Parent = logoContainer

local loadingContainer = Instance.new("Frame")
loadingContainer.Name = "LoadingContainer"
loadingContainer.Size = UDim2.new(0, 320, 0, 6)
loadingContainer.Position = UDim2.new(0.5, -160, 0.58, 0)
loadingContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
loadingContainer.BorderSizePixel = 0
loadingContainer.ZIndex = 12
loadingContainer.Parent = splashFrame

local loadingBarCorner = Instance.new("UICorner")
loadingBarCorner.CornerRadius = UDim.new(0, 3)
loadingBarCorner.Parent = loadingContainer

local loadingFill = Instance.new("Frame")
loadingFill.Name = "LoadingFill"
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.BackgroundColor3 = getAccentColor()
loadingFill.BorderSizePixel = 0
loadingFill.ZIndex = 13
loadingFill.Parent = loadingContainer

local loadingFillCorner = Instance.new("UICorner")
loadingFillCorner.CornerRadius = UDim.new(0, 3)
loadingFillCorner.Parent = loadingFill

local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(1, 0, 1, 0)
keyFrame.BackgroundTransparency = 1
keyFrame.Visible = false
keyFrame.ZIndex = 11
keyFrame.Parent = fullScreenContainer

local keyWindow = Instance.new("Frame")
keyWindow.Name = "KeyWindow"
keyWindow.Size = UDim2.new(0, 440, 0, 260)
keyWindow.Position = UDim2.new(0.5, -220, 0.5, -130)
keyWindow.BackgroundColor3 = uiTheme.Dark.card
keyWindow.BorderSizePixel = 0
keyWindow.ZIndex = 12
keyWindow.Parent = keyFrame

local keyWindowCorner = Instance.new("UICorner")
keyWindowCorner.CornerRadius = UDim.new(0, 16)
keyWindowCorner.Parent = keyWindow

local keyWindowStroke = Instance.new("UIStroke")
keyWindowStroke.Thickness = 1.5
keyWindowStroke.Color = uiTheme.Dark.border
keyWindowStroke.Parent = keyWindow

local keyTitle = Instance.new("TextLabel")
keyTitle.Name = "KeyTitle"
keyTitle.Size = UDim2.new(1, 0, 0, 40)
keyTitle.Position = UDim2.new(0, 0, 0.08, 0)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "Authentication Required"
keyTitle.TextColor3 = uiTheme.Dark.text
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 22
keyTitle.ZIndex = 13
keyTitle.Parent = keyWindow

local keySubtitle = Instance.new("TextLabel")
keySubtitle.Name = "KeySubtitle"
keySubtitle.Size = UDim2.new(1, -40, 0, 36)
keySubtitle.Position = UDim2.new(0, 20, 0.24, 0)
keySubtitle.BackgroundTransparency = 1
keySubtitle.Text = "Enter a valid key to unlock NekoLib. Free keys are available via our official Discord community."
keySubtitle.TextColor3 = uiTheme.Dark.subText
keySubtitle.Font = Enum.Font.Gotham
keySubtitle.TextSize = 13
keySubtitle.TextWrapped = true
keySubtitle.ZIndex = 13
keySubtitle.Parent = keyWindow

local keyInput = Instance.new("TextBox")
keyInput.Name = "KeyInput"
keyInput.Size = UDim2.new(1, -80, 0, 45)
keyInput.Position = UDim2.new(0, 40, 0.44, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "Enter key here..."
keyInput.TextColor3 = uiTheme.Dark.text
keyInput.PlaceholderColor3 = uiTheme.Dark.subText
keyInput.Font = Enum.Font.Gotham
keyInput.TextSize = 14
keyInput.ZIndex = 13
keyInput.Parent = keyWindow

local keyInputCorner = Instance.new("UICorner")
keyInputCorner.CornerRadius = UDim.new(0, 10)
keyInputCorner.Parent = keyInput

local keyInputStroke = Instance.new("UIStroke")
keyInputStroke.Thickness = 1
keyInputStroke.Color = uiTheme.Dark.border
keyInputStroke.Parent = keyInput

local keyButtonsContainer = Instance.new("Frame")
keyButtonsContainer.Name = "KeyButtonsContainer"
keyButtonsContainer.Size = UDim2.new(1, -80, 0, 42)
keyButtonsContainer.Position = UDim2.new(0, 40, 0.68, 0)
keyButtonsContainer.BackgroundTransparency = 1
keyButtonsContainer.ZIndex = 13
keyButtonsContainer.Parent = keyWindow

local keyButtonsLayout = Instance.new("UIListLayout")
keyButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
keyButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
keyButtonsLayout.Padding = UDim.new(0, 10)
keyButtonsLayout.Parent = keyButtonsContainer

local function createKeyButton(text, layoutOrder, isAccent)
	local button = Instance.new("TextButton")
	button.Name = "KeyButton_" .. text
	button.Size = UDim2.new(0, 113, 1, 0)
	button.BackgroundColor3 = isAccent and getAccentColor() or Color3.fromRGB(10, 10, 12)
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 13
	button.LayoutOrder = layoutOrder
	button.ZIndex = 14
	button.Parent = keyButtonsContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = button

	if not isAccent then
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1
		stroke.Color = uiTheme.Dark.border
		stroke.Parent = button
	end

	return button
end

local btnUnload = createKeyButton("Unload", 1, false)
local btnGetKey = createKeyButton("Get Key", 2, false)
local btnContinue = createKeyButton("Continue", 3, true)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 720, 0, 480)
mainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
mainFrame.BackgroundColor3 = uiTheme.Dark.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false
mainFrame.ZIndex = 2
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 16)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Thickness = 2
mainFrameStroke.Color = getAccentColor()
mainFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainFrameStroke.Parent = mainFrame

local glowFrame = Instance.new("Frame")
glowFrame.Name = "GlowFrame"
glowFrame.Size = UDim2.new(1, 16, 1, 16)
glowFrame.Position = UDim2.new(0, -8, 0, -8)
glowFrame.BackgroundColor3 = getAccentColor()
glowFrame.BackgroundTransparency = 0.82
glowFrame.ZIndex = 1
glowFrame.Parent = mainFrame

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 20)
glowCorner.Parent = glowFrame

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 190, 1, 0)
sidebar.BackgroundColor3 = uiTheme.Dark.card
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = mainFrame

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 16)
sidebarCorner.Parent = sidebar

local sidebarCover = Instance.new("Frame")
sidebarCover.Name = "SidebarCover"
sidebarCover.Size = UDim2.new(0, 25, 1, 0)
sidebarCover.Position = UDim2.new(1, -25, 0, 0)
sidebarCover.BackgroundColor3 = uiTheme.Dark.card
sidebarCover.BorderSizePixel = 0
sidebarCover.ZIndex = 2
sidebarCover.Parent = sidebar

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Name = "SidebarDivider"
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(1, 0, 0, 0)
sidebarDivider.BackgroundColor3 = uiTheme.Dark.border
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 3
sidebarDivider.Parent = sidebar

local sidebarTitle = Instance.new("TextLabel")
sidebarTitle.Name = "SidebarTitle"
sidebarTitle.Size = UDim2.new(1, -20, 0, 30)
sidebarTitle.Position = UDim2.new(0, 15, 0, 15)
sidebarTitle.BackgroundTransparency = 1
sidebarTitle.Text = "NekoLib Menu"
sidebarTitle.TextColor3 = uiTheme.Dark.text
sidebarTitle.Font = Enum.Font.GothamBold
sidebarTitle.TextSize = 16
sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
sidebarTitle.ZIndex = 3
sidebarTitle.Parent = sidebar

local tabContainer = Instance.new("Frame")
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -20, 0, 220)
tabContainer.Position = UDim2.new(0, 10, 0, 60)
tabContainer.BackgroundTransparency = 1
tabContainer.ZIndex = 3
tabContainer.Parent = sidebar

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 8)
tabLayout.Parent = tabContainer

local function createTab(name, iconText, layoutOrder)
	local tab = Instance.new("TextButton")
	tab.Name = "Tab_" .. name
	tab.Size = UDim2.new(1, 0, 0, 38)
	tab.BackgroundTransparency = 1
	tab.Text = ""
	tab.LayoutOrder = layoutOrder
	tab.ZIndex = 4
	tab.Parent = tabContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = tab

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = uiTheme.Dark.border
	stroke.Parent = tab

	table.insert(activeConnections, tab.MouseEnter:Connect(function()
		TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundTransparency = 0.92}):Play()
	end))
	table.insert(activeConnections, tab.MouseLeave:Connect(function()
		local activeTab = homePanel.Visible and "Home" or (scriptsPanel.Visible and "Scripts" or "Settings")
		if activeTab ~= name then
			TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
		end
	end))

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Name = "Icon"
	iconLabel.Size = UDim2.new(0, 24, 1, 0)
	iconLabel.Position = UDim2.new(0, 12, 0, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = iconText
	iconLabel.TextColor3 = uiTheme.Dark.subText
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 14
	iconLabel.ZIndex = 5
	iconLabel.Parent = tab

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Title"
	nameLabel.Size = UDim2.new(1, -48, 1, 0)
	nameLabel.Position = UDim2.new(0, 42, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = uiTheme.Dark.subText
	nameLabel.Font = Enum.Font.GothamSemibold
	nameLabel.TextSize = 13
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 5
	nameLabel.Parent = tab

	return tab
end

local tabHome = createTab("Home", "🏠", 1)
local tabScripts = createTab("Scripts", "📜", 2)
local tabSettings = createTab("Settings", "⚙️", 3)

local userCard = Instance.new("Frame")
userCard.Name = "UserCard"
userCard.Size = UDim2.new(1, -20, 0, 54)
userCard.Position = UDim2.new(0, 10, 1, -64)
userCard.BackgroundTransparency = 1
userCard.ZIndex = 3
userCard.Parent = sidebar

local userAvatar = Instance.new("ImageLabel")
userAvatar.Name = "UserAvatar"
userAvatar.Size = UDim2.new(0, 38, 0, 38)
userAvatar.Position = UDim2.new(0, 4, 0.5, -19)
userAvatar.BackgroundColor3 = uiTheme.Dark.border
userAvatar.ZIndex = 4
userAvatar.Parent = userCard

local userAvatarCorner = Instance.new("UICorner")
userAvatarCorner.CornerRadius = UDim.new(0, 19)
userAvatarCorner.Parent = userAvatar

local userDisplayName = Instance.new("TextLabel")
userDisplayName.Name = "UserDisplayName"
userDisplayName.Size = UDim2.new(1, -52, 0, 18)
userDisplayName.Position = UDim2.new(0, 48, 0.5, -18)
userDisplayName.BackgroundTransparency = 1
userDisplayName.Text = localPlayer.DisplayName
userDisplayName.TextColor3 = uiTheme.Dark.text
userDisplayName.Font = Enum.Font.GothamBold
userDisplayName.TextSize = 12
userDisplayName.TextXAlignment = Enum.TextXAlignment.Left
userDisplayName.ZIndex = 4
userDisplayName.Parent = userCard

local userHandle = Instance.new("TextLabel")
userHandle.Name = "UserHandle"
userHandle.Size = UDim2.new(1, -52, 0, 14)
userHandle.Position = UDim2.new(0, 48, 0.5, 0)
userHandle.BackgroundTransparency = 1
userHandle.Text = "@" .. localPlayer.Name
userHandle.TextColor3 = uiTheme.Dark.subText
userHandle.Font = Enum.Font.Gotham
userHandle.TextSize = 10
userHandle.TextXAlignment = Enum.TextXAlignment.Left
userHandle.ZIndex = 4
userHandle.Parent = userCard

task.spawn(function()
	local success, result = pcall(function()
		return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if success then
		userAvatar.Image = result
	end
end)

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, -190, 0, 50)
header.Position = UDim2.new(0, 190, 0, 0)
header.BackgroundTransparency = 1
header.ZIndex = 2
header.Parent = mainFrame

local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "HeaderTitle"
headerTitle.Size = UDim2.new(0, 200, 1, 0)
headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "NekoLib Dashboard"
headerTitle.TextColor3 = uiTheme.Dark.text
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextSize = 15
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 3
headerTitle.Parent = header

local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 120, 1, 0)
controlButtons.Position = UDim2.new(1, -130, 0, 0)
controlButtons.BackgroundTransparency = 1
controlButtons.ZIndex = 3
controlButtons.Parent = header

local controlLayout = Instance.new("UIListLayout")
controlLayout.FillDirection = Enum.FillDirection.Horizontal
controlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
controlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
controlLayout.Padding = UDim.new(0, 10)
controlLayout.Parent = controlButtons

local btnClose = Instance.new("TextButton")
btnClose.Name = "btnClose"
btnClose.Size = UDim2.new(0, 32, 0, 32)
btnClose.BackgroundColor3 = uiTheme.Dark.card
btnClose.Text = "X"
btnClose.TextColor3 = Color3.fromRGB(240, 70, 70)
btnClose.Font = Enum.Font.GothamBold
btnClose.TextSize = 14
btnClose.ZIndex = 4
btnClose.Parent = controlButtons

local btnCloseCorner = Instance.new("UICorner")
btnCloseCorner.CornerRadius = UDim.new(0, 8)
btnCloseCorner.Parent = btnClose

local btnCloseStroke = Instance.new("UIStroke")
btnCloseStroke.Thickness = 1
btnCloseStroke.Color = uiTheme.Dark.border
btnCloseStroke.Parent = btnClose

local btnTheme = Instance.new("TextButton")
btnTheme.Name = "btnTheme"
btnTheme.Size = UDim2.new(0, 32, 0, 32)
btnTheme.BackgroundColor3 = uiTheme.Dark.card
btnTheme.Text = "🌙"
btnTheme.TextColor3 = uiTheme.Dark.text
btnTheme.Font = Enum.Font.Gotham
btnTheme.TextSize = 14
btnTheme.ZIndex = 4
btnTheme.Parent = controlButtons

local btnThemeCorner = Instance.new("UICorner")
btnThemeCorner.CornerRadius = UDim.new(0, 8)
btnThemeCorner.Parent = btnTheme

local btnThemeStroke = Instance.new("UIStroke")
btnThemeStroke.Thickness = 1
btnThemeStroke.Color = uiTheme.Dark.border
btnThemeStroke.Parent = btnTheme

local hsvControl = Instance.new("Frame")
hsvControl.Name = "HSVControl"
hsvControl.Size = UDim2.new(0, 100, 0, 10)
hsvControl.Position = UDim2.new(1, -120, 1, -25)
hsvControl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hsvControl.BorderSizePixel = 0
hsvControl.ZIndex = 3
hsvControl.Parent = mainFrame

local hsvCorner = Instance.new("UICorner")
hsvCorner.CornerRadius = UDim.new(0, 5)
hsvCorner.Parent = hsvControl

local hsvGradient = Instance.new("UIGradient")
hsvGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
	ColorSequenceKeypoint.new(0.2, Color3.fromHSV(0.2, 1, 1)),
	ColorSequenceKeypoint.new(0.4, Color3.fromHSV(0.4, 1, 1)),
	ColorSequenceKeypoint.new(0.6, Color3.fromHSV(0.6, 1, 1)),
	ColorSequenceKeypoint.new(0.8, Color3.fromHSV(0.8, 1, 1)),
	ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
})
hsvGradient.Parent = hsvControl

local hsvIndicator = Instance.new("Frame")
hsvIndicator.Name = "HSVIndicator"
hsvIndicator.Size = UDim2.new(0, 14, 0, 14)
hsvIndicator.Position = UDim2.new(uiTheme.Hue, -7, 0.5, -7)
hsvIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
hsvIndicator.ZIndex = 4
hsvIndicator.Parent = hsvControl

local hsvIndicatorCorner = Instance.new("UICorner")
hsvIndicatorCorner.CornerRadius = UDim.new(0, 7)
hsvIndicatorCorner.Parent = hsvIndicator

local hsvIndicatorStroke = Instance.new("UIStroke")
hsvIndicatorStroke.Thickness = 1.5
hsvIndicatorStroke.Color = Color3.fromRGB(0, 0, 0)
hsvIndicatorStroke.Parent = hsvIndicator

local workspaceContainer = Instance.new("Frame")
workspaceContainer.Name = "WorkspaceContainer"
workspaceContainer.Size = UDim2.new(1, -210, 1, -70)
workspaceContainer.Position = UDim2.new(0, 210, 0, 60)
workspaceContainer.BackgroundTransparency = 1
workspaceContainer.ZIndex = 2
workspaceContainer.Parent = mainFrame

local currentMetrics = {
	Logins = 1,
	TotalTime = 0
}

local function saveMetrics()
	local filename = "NekoLib_Metrics_" .. tostring(localPlayer.UserId) .. ".json"
	if writefile then
		writefile(filename, HttpService:JSONEncode(currentMetrics))
	end
end

local function loadMetrics()
	local filename = "NekoLib_Metrics_" .. tostring(localPlayer.UserId) .. ".json"
	if readfile and isfile and isfile(filename) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(filename))
		end)
		if success and type(data) == "table" then
			currentMetrics.Logins = (data.Logins or 0) + 1
			currentMetrics.TotalTime = data.TotalTime or 0
		end
	end
	saveMetrics()
end

task.spawn(loadMetrics)

local homePanel = Instance.new("Frame")
homePanel.Name = "HomePanel"
homePanel.Size = UDim2.new(1, 0, 1, 0)
homePanel.BackgroundTransparency = 1
homePanel.ZIndex = 3
homePanel.Parent = workspaceContainer

local profileCard = Instance.new("Frame")
profileCard.Name = "OpaqueFrame"
profileCard.Size = UDim2.new(1, 0, 0, 100)
profileCard.Position = UDim2.new(0, 0, 0, 10)
profileCard.BackgroundColor3 = uiTheme.Dark.card
profileCard.ZIndex = 4
profileCard.Parent = homePanel

local profileCardCorner = Instance.new("UICorner")
profileCardCorner.CornerRadius = UDim.new(0, 12)
profileCardCorner.Parent = profileCard

local profileCardStroke = Instance.new("UIStroke")
profileCardStroke.Thickness = 1
profileCardStroke.Color = uiTheme.Dark.border
profileCardStroke.Parent = profileCard

local profileAvatar = Instance.new("ImageLabel")
profileAvatar.Name = "ProfileAvatar"
profileAvatar.Size = UDim2.new(0, 80, 0, 80)
profileAvatar.Position = UDim2.new(0, 10, 0.5, -40)
profileAvatar.BackgroundColor3 = uiTheme.Dark.border
profileAvatar.ZIndex = 5
profileAvatar.Parent = profileCard

local profileAvatarCorner = Instance.new("UICorner")
profileAvatarCorner.CornerRadius = UDim.new(0, 40)
profileAvatarCorner.Parent = profileAvatar

task.spawn(function()
	local success, result = pcall(function()
		return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
	end)
	if success then
		profileAvatar.Image = result
	end
end)

local profileName = Instance.new("TextLabel")
profileName.Name = "ProfileName"
profileName.Size = UDim2.new(1, -110, 0, 24)
profileName.Position = UDim2.new(0, 105, 0, 18)
profileName.BackgroundTransparency = 1
profileName.Text = localPlayer.DisplayName
profileName.TextColor3 = uiTheme.Dark.text
profileName.Font = Enum.Font.GothamBold
profileName.TextSize = 18
profileName.TextXAlignment = Enum.TextXAlignment.Left
profileName.ZIndex = 5
profileName.Parent = profileCard

local profileUser = Instance.new("TextLabel")
profileUser.Name = "DescLabel"
profileUser.Size = UDim2.new(1, -110, 0, 18)
profileUser.Position = UDim2.new(0, 105, 0, 42)
profileUser.BackgroundTransparency = 1
profileUser.Text = "@" .. localPlayer.Name
profileUser.TextColor3 = uiTheme.Dark.subText
profileUser.Font = Enum.Font.Gotham
profileUser.TextSize = 13
profileUser.TextXAlignment = Enum.TextXAlignment.Left
profileUser.ZIndex = 5
profileUser.Parent = profileCard

local accountAgeLabel = Instance.new("TextLabel")
accountAgeLabel.Name = "DescLabel"
accountAgeLabel.Size = UDim2.new(1, -110, 0, 18)
accountAgeLabel.Position = UDim2.new(0, 105, 0, 62)
accountAgeLabel.BackgroundTransparency = 1
accountAgeLabel.Text = "Account Age: " .. tostring(localPlayer.AccountAge) .. " days"
accountAgeLabel.TextColor3 = uiTheme.Dark.subText
accountAgeLabel.Font = Enum.Font.Gotham
accountAgeLabel.TextSize = 12
accountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
accountAgeLabel.ZIndex = 5
accountAgeLabel.Parent = profileCard

local statsContainer = Instance.new("Frame")
statsContainer.Name = "StatsContainer"
statsContainer.Size = UDim2.new(1, 0, 0, 160)
statsContainer.Position = UDim2.new(0, 0, 0, 130)
statsContainer.BackgroundTransparency = 1
statsContainer.ZIndex = 4
statsContainer.Parent = homePanel

local statsLayout = Instance.new("UIGridLayout")
statsLayout.CellSize = UDim2.new(0.5, -8, 0.5, -8)
statsLayout.CellPadding = UDim2.new(0, 16, 0, 16)
statsLayout.Parent = statsContainer

local function createStatBox(title, initialValue)
	local box = Instance.new("Frame")
	box.Name = "OpaqueFrame"
	box.BackgroundColor3 = uiTheme.Dark.card
	box.ZIndex = 5
	box.Parent = statsContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = box

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = uiTheme.Dark.border
	stroke.Parent = box

	local lblTitle = Instance.new("TextLabel")
	lblTitle.Name = "DescLabel"
	lblTitle.Size = UDim2.new(1, -24, 0, 20)
	lblTitle.Position = UDim2.new(0, 12, 0, 10)
	lblTitle.BackgroundTransparency = 1
	lblTitle.Text = title
	lblTitle.TextColor3 = uiTheme.Dark.subText
	lblTitle.Font = Enum.Font.GothamSemibold
	lblTitle.TextSize = 12
	lblTitle.TextXAlignment = Enum.TextXAlignment.Left
	lblTitle.ZIndex = 6
	lblTitle.Parent = box

	local lblVal = Instance.new("TextLabel")
	lblVal.Name = "StatValueLabel"
	lblVal.Size = UDim2.new(1, -24, 0, 30)
	lblVal.Position = UDim2.new(0, 12, 0, 30)
	lblVal.BackgroundTransparency = 1
	lblVal.Text = initialValue
	lblVal.TextColor3 = uiTheme.Dark.text
	lblVal.Font = Enum.Font.GothamBold
	lblVal.TextSize = 16
	lblVal.TextXAlignment = Enum.TextXAlignment.Left
	lblVal.ZIndex = 6
	lblVal.Parent = box

	return lblVal
end

local keyStatValue = createStatBox("Authentication Key", "NekoLib_FreeKey")
local loginStatValue = createStatBox("System Access Logins", "0 times")
local timeStatValue = createStatBox("Dashboard Execution Session", "0h 0m 0s")
local versionStatValue = createStatBox("Client Engine Release", "v0.2beta")

task.spawn(function()
	while true do
		loginStatValue.Text = tostring(currentMetrics.Logins) .. " times"
		local hours = math.floor(currentMetrics.TotalTime / 3600)
		local mins = math.floor((currentMetrics.TotalTime % 3600) / 60)
		local secs = currentMetrics.TotalTime % 60
		timeStatValue.Text = string.format("%dh %dm %ds", hours, mins, secs)
		task.wait(1)
		currentMetrics.TotalTime = currentMetrics.TotalTime + 1
		saveMetrics()
	end
end)

local scriptsPanel = Instance.new("Frame")
scriptsPanel.Name = "ScriptsPanel"
scriptsPanel.Size = UDim2.new(1, 0, 1, 0)
scriptsPanel.BackgroundTransparency = 1
scriptsPanel.Visible = false
scriptsPanel.ZIndex = 3
scriptsPanel.Parent = workspaceContainer

local categoryContainer = Instance.new("Frame")
categoryContainer.Name = "CategoryContainer"
categoryContainer.Size = UDim2.new(1, 0, 0, 35)
categoryContainer.Position = UDim2.new(0, 0, 0, 0)
categoryContainer.BackgroundTransparency = 1
categoryContainer.ZIndex = 4
categoryContainer.Parent = scriptsPanel

local categoryLayout = Instance.new("UIListLayout")
categoryLayout.FillDirection = Enum.FillDirection.Horizontal
categoryLayout.Padding = UDim.new(0, 10)
categoryLayout.Parent = categoryContainer

local utilityScroll = Instance.new("ScrollingFrame")
utilityScroll.Name = "ScriptsScroll"
utilityScroll.Size = UDim2.new(1, 0, 1, -50)
utilityScroll.Position = UDim2.new(0, 0, 0, 50)
utilityScroll.BackgroundTransparency = 1
utilityScroll.BorderSizePixel = 0
utilityScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
utilityScroll.ScrollBarThickness = 4
utilityScroll.ScrollBarImageColor3 = uiTheme.Dark.border
utilityScroll.ZIndex = 4
utilityScroll.Parent = scriptsPanel

local utilityLayout = Instance.new("UIListLayout")
utilityLayout.SortOrder = Enum.SortOrder.LayoutOrder
utilityLayout.Padding = UDim.new(0, 10)
utilityLayout.Parent = utilityScroll

table.insert(activeConnections, utilityLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	utilityScroll.CanvasSize = UDim2.new(0, 0, 0, utilityLayout.AbsoluteContentSize.Y + 10)
end))

local gamesScroll = Instance.new("ScrollingFrame")
gamesScroll.Name = "ScriptsScroll"
gamesScroll.Size = UDim2.new(1, 0, 1, -50)
gamesScroll.Position = UDim2.new(0, 0, 0, 50)
gamesScroll.BackgroundTransparency = 1
gamesScroll.BorderSizePixel = 0
gamesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
gamesScroll.ScrollBarThickness = 4
gamesScroll.ScrollBarImageColor3 = uiTheme.Dark.border
gamesScroll.Visible = false
gamesScroll.ZIndex = 4
gamesScroll.Parent = scriptsPanel

local gamesLayout = Instance.new("UIListLayout")
gamesLayout.SortOrder = Enum.SortOrder.LayoutOrder
gamesLayout.Padding = UDim.new(0, 10)
gamesLayout.Parent = gamesScroll

table.insert(activeConnections, gamesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	gamesScroll.CanvasSize = UDim2.new(0, 0, 0, gamesLayout.AbsoluteContentSize.Y + 10)
end))

local function addScriptItem(category, name, desc, code)
	local parentScroll = category == "Utility" and utilityScroll or gamesScroll
	local item = Instance.new("Frame")
	item.Name = "OpaqueFrame"
	item.Size = UDim2.new(1, -10, 0, 60)
	item.BackgroundColor3 = uiTheme.Dark.card
	item.ZIndex = 5
	item.Parent = parentScroll

	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 8)
	itemCorner.Parent = item

	local itemStroke = Instance.new("UIStroke")
	itemStroke.Thickness = 1
	itemStroke.Color = uiTheme.Dark.border
	itemStroke.Parent = item

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.65, 0, 0, 25)
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = name
	titleLabel.TextColor3 = uiTheme.Dark.text
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 6
	titleLabel.Parent = item

	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "DescLabel"
	descLabel.Size = UDim2.new(0.65, 0, 0, 20)
	descLabel.Position = UDim2.new(0, 12, 0, 30)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = desc
	descLabel.TextColor3 = uiTheme.Dark.subText
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 11
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.ZIndex = 6
	descLabel.Parent = item

	local execBtn = Instance.new("TextButton")
	execBtn.Name = "OpaqueButton"
	execBtn.Size = UDim2.new(0, 90, 0, 32)
	execBtn.Position = UDim2.new(1, -102, 0.5, -16)
	execBtn.BackgroundColor3 = getAccentColor()
	execBtn.Text = "Execute"
	execBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	execBtn.Font = Enum.Font.GothamBold
	execBtn.TextSize = 12
	execBtn.ZIndex = 6
	execBtn.Parent = item

	local execCorner = Instance.new("UICorner")
	execCorner.CornerRadius = UDim.new(0, 6)
	execCorner.Parent = execBtn

	table.insert(activeConnections, execBtn.MouseButton1Click:Connect(function()
		local success, err = pcall(function()
			local func = loadstring(code)
			if func then task.spawn(func) end
		end)
	end))
end

local function createCategoryBtn(name)
	local btn = Instance.new("TextButton")
	btn.Name = "OpaqueButton"
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.BackgroundColor3 = getAccentColor()
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.ZIndex = 5
	btn.Parent = categoryContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	return btn
end

local btnUtility = createCategoryBtn("Utility")
local btnGames = createCategoryBtn("Games")

local function switchCategory(cat)
	utilityScroll.Visible = (cat == "Utility")
	gamesScroll.Visible = (cat == "Games")
	btnUtility.BackgroundColor3 = cat == "Utility" and getAccentColor() or Color3.fromRGB(40, 40, 45)
	btnGames.BackgroundColor3 = cat == "Games" and getAccentColor() or Color3.fromRGB(40, 40, 45)
end

table.insert(activeConnections, btnUtility.MouseButton1Click:Connect(function() switchCategory("Utility") end))
table.insert(activeConnections, btnGames.MouseButton1Click:Connect(function() switchCategory("Games") end))
switchCategory("Utility")

addScriptItem("Utility", "Advanced Hub", "This universal script has combat, characteristics, visual esp and many other utility functions.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/advancedhub'))()")
addScriptItem("Utility", "Product Fucker", "Get any unprotected product.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/productfucker'))()")
addScriptItem("Utility", "Infinite Yield", "Popular admin command script.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()")
addScriptItem("Games", "Sol's RNG", "Webhooking Biomes, Auras, Tips, Merchants, Full Settings for all Webhooks.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/solsrngeggs'))()")
addScriptItem("Games", "Jujutsu Shenenigans", "Auto BlackFlash for Vessel skill 3, Bind Systems.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/jujutsush'))()")
addScriptItem("Games", "FNAF: Eternal Nights", "Monsters ESP/Players ESP, Teleport any Item in game to you, ESP any item. FullBright + Noclip", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/fnafeternal'))()")
addScriptItem("Games", "Volleyball Legends", "Style/Ability Lucky Spins Dupe, Yen Dupe, logs and Webhook System with settings.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/volleyballlegends'))()")

local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1, 0, 1, 0)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 3
settingsPanel.Parent = workspaceContainer

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Name = "SettingsTitle"
settingsTitle.Size = UDim2.new(1, 0, 0, 30)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Interface Settings"
settingsTitle.TextColor3 = uiTheme.Dark.text
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 20
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.ZIndex = 4
settingsTitle.Parent = settingsPanel

local settingsDesc = Instance.new("TextLabel")
settingsDesc.Name = "SettingsDesc"
settingsDesc.Size = UDim2.new(1, -160, 0, 40)
settingsDesc.Position = UDim2.new(0, 0, 0, 35)
settingsDesc.BackgroundTransparency = 1
settingsDesc.Text = "Configure the visual preferences and shell execution modes of NekoLib."
settingsDesc.TextColor3 = uiTheme.Dark.subText
settingsDesc.Font = Enum.Font.Gotham
settingsDesc.TextSize = 13
settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
settingsDesc.ZIndex = 4
settingsDesc.Parent = settingsPanel

local settingsScroll = Instance.new("ScrollingFrame")
settingsScroll.Name = "SettingsScroll"
settingsScroll.Size = UDim2.new(1, 0, 1, -80)
settingsScroll.Position = UDim2.new(0, 0, 0, 80)
settingsScroll.BackgroundTransparency = 1
settingsScroll.BorderSizePixel = 0
settingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
settingsScroll.ScrollBarThickness = 4
settingsScroll.ScrollBarImageColor3 = uiTheme.Dark.border
settingsScroll.ZIndex = 4
settingsScroll.Parent = settingsPanel

local settingsLayout = Instance.new("UIListLayout")
settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
settingsLayout.Padding = UDim.new(0, 10)
settingsLayout.Parent = settingsScroll

table.insert(activeConnections, settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	settingsScroll.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 10)
end))

local currentSettings = {
	GuiScale = 1,
	Blur = false,
	Transparency = 0,
	Font = "Gotham",
	FontSize = 14
}

local function applyGuiScale(scale)
	currentSettings.GuiScale = scale
	mainFrame.Size = UDim2.new(0, 720 * scale, 0, 480 * scale)
	mainFrame.Position = UDim2.new(0.5, -360 * scale, 0.5, -240 * scale)
end

local function applyBlur(enabled)
	currentSettings.Blur = enabled
	local lighting = game:GetService("Lighting")
	local blur = lighting:FindFirstChild("NekoBlur")
	if enabled then
		if not blur then
			blur = Instance.new("BlurEffect")
			blur.Name = "NekoBlur"
			blur.Size = 10
			blur.Parent = lighting
		end
	else
		if blur then blur:Destroy() end
	end
end

local function applyTransparency(value)
	currentSettings.Transparency = value
	mainFrame.BackgroundTransparency = value
	sidebar.BackgroundTransparency = value
end

local function applyFontAndSize(fontName, size)
	currentSettings.Font = fontName
	currentSettings.FontSize = size
	local fontEnum = Enum.Font[fontName] or Enum.Font.Gotham
	for _, desc in ipairs(mainFrame:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextBox") or desc:IsA("TextButton") then
			desc.Font = fontEnum
		end
	end
end

local HttpService = game:GetService("HttpService")

local function saveSettings()
	local json = HttpService:JSONEncode(currentSettings)
	local filename = "NekoLib_" .. tostring(localPlayer.UserId) .. ".json"
	if writefile then
		writefile(filename, json)
	else
		print("Settings Mock Saved:", json)
	end
end

local function loadSettings()
	local filename = "NekoLib_" .. tostring(localPlayer.UserId) .. ".json"
	if readfile and isfile and isfile(filename) then
		local success, data = pcall(function()
			return HttpService:JSONDecode(readfile(filename))
		end)
		if success and type(data) == "table" then
			for k, v in pairs(data) do
				currentSettings[k] = v
			end
			applyGuiScale(currentSettings.GuiScale)
			applyBlur(currentSettings.Blur)
			applyTransparency(currentSettings.Transparency)
			applyFontAndSize(currentSettings.Font, currentSettings.FontSize)
		end
	end
end

task.spawn(loadSettings)

local function createSettingItem(name, desc)
	local item = Instance.new("Frame")
	item.Name = "OpaqueFrame"
	item.Size = UDim2.new(1, -10, 0, 60)
	item.BackgroundColor3 = uiTheme.Dark.card
	item.ZIndex = 5
	item.Parent = settingsScroll

	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 8)
	itemCorner.Parent = item

	local itemStroke = Instance.new("UIStroke")
	itemStroke.Thickness = 1
	itemStroke.Color = uiTheme.Dark.border
	itemStroke.Parent = item

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.6, 0, 0, 25)
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = name
	titleLabel.TextColor3 = uiTheme.Dark.text
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 6
	titleLabel.Parent = item

	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "DescLabel"
	descLabel.Size = UDim2.new(0.6, 0, 0, 20)
	descLabel.Position = UDim2.new(0, 12, 0, 30)
	descLabel.BackgroundTransparency = 1
	descLabel.Text = desc
	descLabel.TextColor3 = uiTheme.Dark.subText
	descLabel.Font = Enum.Font.Gotham
	descLabel.TextSize = 11
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.ZIndex = 6
	descLabel.Parent = item

	return item
end

local scaleItem = createSettingItem("GUI Scale", "Resize the dashboard interface.")
local scaleBtn = Instance.new("TextButton")
scaleBtn.Name = "OpaqueButton"
scaleBtn.Size = UDim2.new(0, 100, 0, 30)
scaleBtn.Position = UDim2.new(1, -112, 0.5, -15)
scaleBtn.BackgroundColor3 = getAccentColor()
scaleBtn.Text = "x" .. tostring(currentSettings.GuiScale)
scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleBtn.Font = Enum.Font.GothamBold
scaleBtn.TextSize = 12
scaleBtn.ZIndex = 6
scaleBtn.Parent = scaleItem

local scaleBtnCorner = Instance.new("UICorner")
scaleBtnCorner.CornerRadius = UDim.new(0, 6)
scaleBtnCorner.Parent = scaleBtn

local scales = {1, 1.25, 1.5, 2}
table.insert(activeConnections, scaleBtn.MouseButton1Click:Connect(function()
	local idx = table.find(scales, currentSettings.GuiScale) or 1
	local nextIdx = (idx % #scales) + 1
	local nextScale = scales[nextIdx]
	applyGuiScale(nextScale)
	scaleBtn.Text = "x" .. tostring(nextScale)
end))

local blurItem = createSettingItem("Depth Blur", "Toggles cinematic camera blur.")
local blurBtn = Instance.new("TextButton")
blurBtn.Name = "OpaqueButton"
blurBtn.Size = UDim2.new(0, 100, 0, 30)
blurBtn.Position = UDim2.new(1, -112, 0.5, -15)
blurBtn.BackgroundColor3 = currentSettings.Blur and getAccentColor() or Color3.fromRGB(40, 40, 45)
blurBtn.Text = currentSettings.Blur and "ON" or "OFF"
blurBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
blurBtn.Font = Enum.Font.GothamBold
blurBtn.TextSize = 12
blurBtn.ZIndex = 6
blurBtn.Parent = blurItem

local blurBtnCorner = Instance.new("UICorner")
blurBtnCorner.CornerRadius = UDim.new(0, 6)
blurBtnCorner.Parent = blurBtn

table.insert(activeConnections, blurBtn.MouseButton1Click:Connect(function()
	local targetState = not currentSettings.Blur
	applyBlur(targetState)
	blurBtn.Text = targetState and "ON" or "OFF"
	blurBtn.BackgroundColor3 = targetState and getAccentColor() or Color3.fromRGB(40, 40, 45)
end))

local transItem = createSettingItem("Transparency", "Set layout background glass effect.")
local transBtn = Instance.new("TextButton")
transBtn.Name = "OpaqueButton"
transBtn.Size = UDim2.new(0, 100, 0, 30)
transBtn.Position = UDim2.new(1, -112, 0.5, -15)
transBtn.BackgroundColor3 = getAccentColor()
transBtn.Text = tostring(math.floor(currentSettings.Transparency * 100)) .. "%"
transBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
transBtn.Font = Enum.Font.GothamBold
transBtn.TextSize = 12
transBtn.ZIndex = 6
transBtn.Parent = transItem

local transBtnCorner = Instance.new("UICorner")
transBtnCorner.CornerRadius = UDim.new(0, 6)
transBtnCorner.Parent = transBtn

local transOptions = {0, 0.15, 0.3, 0.5}
table.insert(activeConnections, transBtn.MouseButton1Click:Connect(function()
	local idx = table.find(transOptions, currentSettings.Transparency) or 1
	local nextIdx = (idx % #transOptions) + 1
	local nextTrans = transOptions[nextIdx]
	applyTransparency(nextTrans)
	transBtn.Text = tostring(math.floor(nextTrans * 100)) .. "%"
end))

local fontItem = createSettingItem("UI Font Style", "Switch between dashboard typeface configurations.")
local fontBtn = Instance.new("TextButton")
fontBtn.Name = "OpaqueButton"
fontBtn.Size = UDim2.new(0, 100, 0, 30)
fontBtn.Position = UDim2.new(1, -112, 0.5, -15)
fontBtn.BackgroundColor3 = getAccentColor()
fontBtn.Text = currentSettings.Font
fontBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fontBtn.Font = Enum.Font.GothamBold
fontBtn.TextSize = 11
fontBtn.ZIndex = 6
fontBtn.Parent = fontItem

local fontBtnCorner = Instance.new("UICorner")
fontBtnCorner.CornerRadius = UDim.new(0, 6)
fontBtnCorner.Parent = fontBtn

local fonts = {"Gotham", "Arial", "Code"}
table.insert(activeConnections, fontBtn.MouseButton1Click:Connect(function()
	local idx = table.find(fonts, currentSettings.Font) or 1
	local nextIdx = (idx % #fonts) + 1
	local nextFont = fonts[nextIdx]
	applyFontAndSize(nextFont, currentSettings.FontSize)
	fontBtn.Text = nextFont
end))

local fontSizeItem = createSettingItem("Text Size", "Modify text size offset slightly.")
local fontSizeBtn = Instance.new("TextButton")
fontSizeBtn.Name = "OpaqueButton"
fontSizeBtn.Size = UDim2.new(0, 100, 0, 30)
fontSizeBtn.Position = UDim2.new(1, -112, 0.5, -15)
fontSizeBtn.BackgroundColor3 = getAccentColor()
fontSizeBtn.Text = tostring(currentSettings.FontSize) .. " px"
fontSizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fontSizeBtn.Font = Enum.Font.GothamBold
fontSizeBtn.TextSize = 12
fontSizeBtn.ZIndex = 6
fontSizeBtn.Parent = fontSizeItem

local fontSizeBtnCorner = Instance.new("UICorner")
fontSizeBtnCorner.CornerRadius = UDim.new(0, 6)
fontSizeBtnCorner.Parent = fontSizeBtn

local sizes = {12, 14, 16}
table.insert(activeConnections, fontSizeBtn.MouseButton1Click:Connect(function()
	local idx = table.find(sizes, currentSettings.FontSize) or 2
	local nextIdx = (idx % #sizes) + 1
	local nextSize = sizes[nextIdx]
	applyFontAndSize(currentSettings.Font, nextSize)
	fontSizeBtn.Text = tostring(nextSize) .. " px"
end))

local saveBtn = Instance.new("TextButton")
saveBtn.Name = "OpaqueButton"
saveBtn.Size = UDim2.new(0, 150, 0, 36)
saveBtn.Position = UDim2.new(1, -160, 0, 35)
saveBtn.BackgroundColor3 = getAccentColor()
saveBtn.Text = "Save Settings"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 13
saveBtn.ZIndex = 6
saveBtn.Parent = settingsPanel

local saveBtnCorner = Instance.new("UICorner")
saveBtnCorner.CornerRadius = UDim.new(0, 8)
saveBtnCorner.Parent = saveBtn

table.insert(activeConnections, saveBtn.MouseButton1Click:Connect(saveSettings))

local function switchTab(tabName)
	homePanel.Visible = (tabName == "Home")
	scriptsPanel.Visible = (tabName == "Scripts")
	settingsPanel.Visible = (tabName == "Settings")

	local tabs = {Home = tabHome, Scripts = tabScripts, Settings = tabSettings}
	for name, btn in pairs(tabs) do
		local stroke = btn:FindFirstChildOfClass("UIStroke")
		if stroke then
			if name == tabName then
				TweenService:Create(stroke, TweenInfo.new(0.2), {Color = getAccentColor(), Thickness = 2}):Play()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
			else
				TweenService:Create(stroke, TweenInfo.new(0.2), {Color = uiTheme[uiTheme.Current].border, Thickness = 1}):Play()
				TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end
		end
	end
end

local function dragLogic()
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	table.insert(activeConnections, header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end))

	table.insert(activeConnections, header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end))

	table.insert(activeConnections, RunService.RenderStepped:Connect(function()
		if dragging and dragInput then
			update(dragInput)
		end
	end))
end

local function applyAccentUpdates()
	logoBadge.BackgroundColor3 = getAccentColor()
	loadingFill.BackgroundColor3 = getAccentColor()
	btnContinue.BackgroundColor3 = getAccentColor()
	mainFrameStroke.Color = getAccentColor()
	glowFrame.BackgroundColor3 = getAccentColor()
	
	local activeTab = homePanel.Visible and "Home" or (scriptsPanel.Visible and "Scripts" or "Settings")
	local tabs = {Home = tabHome, Scripts = tabScripts, Settings = tabSettings}
	local activeBtn = tabs[activeTab]
	if activeBtn then
		local stroke = activeBtn:FindFirstChildOfClass("UIStroke")
		if stroke then stroke.Color = getAccentColor() end
	end

	local activeCat = utilityScroll.Visible and "Utility" or "Games"
	btnUtility.BackgroundColor3 = activeCat == "Utility" and getAccentColor() or Color3.fromRGB(40, 40, 45)
	btnGames.BackgroundColor3 = activeCat == "Games" and getAccentColor() or Color3.fromRGB(40, 40, 45)

	for _, desc in ipairs(mainFrame:GetDescendants()) do
		if desc:IsA("TextButton") and desc.Name == "OpaqueButton" and desc ~= blurBtn and desc ~= btnUtility and desc ~= btnGames then
			desc.BackgroundColor3 = getAccentColor()
		end
	end
end

local function themeTransition(themeName)
	uiTheme.Current = themeName
	local palette = uiTheme[themeName]
	local duration = 0.35

	local function tween(obj, props)
		TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
	end

	tween(keyWindow, { BackgroundColor3 = palette.card })
	tween(keyWindowStroke, { Color = palette.border })
	tween(keyInput, { BackgroundColor3 = palette.bg, TextColor3 = palette.text, PlaceholderColor3 = palette.subText })
	tween(keyInputStroke, { Color = palette.border })
	tween(mainFrame, { BackgroundColor3 = palette.bg })
	tween(btnUnload, { BackgroundColor3 = palette.bg })
	tween(btnGetKey, { BackgroundColor3 = palette.bg })
	tween(btnClose, { BackgroundColor3 = palette.card })
	tween(btnTheme, { BackgroundColor3 = palette.card, TextColor3 = palette.text })
	btnTheme.Text = themeName == "Dark" and "🌙" or "☀️"

	for _, desc in ipairs(mainFrame:GetDescendants()) do
		if desc:IsA("Frame") then
			if desc.Name == "OpaqueFrame" then
				tween(desc, { BackgroundColor3 = palette.card })
				local stroke = desc:FindFirstChildOfClass("UIStroke")
				if stroke then tween(stroke, { Color = palette.border }) end
			elseif desc.Name == "Sidebar" or desc.Name == "SidebarCover" then
				tween(desc, { BackgroundColor3 = palette.card })
			elseif desc.Name == "SidebarDivider" then
				tween(desc, { BackgroundColor3 = palette.border })
			end
		elseif desc:IsA("TextLabel") then
			if desc.Name == "DescLabel" or desc.Name == "SettingsDesc" or desc.Name == "UserHandle" or desc.Name:find("Sub") or desc.Name:find("StatValue") then
				tween(desc, { TextColor3 = palette.subText })
			elseif desc.Name ~= "LogoBadgeText" and desc.Name ~= "LogoTitle" then
				tween(desc, { TextColor3 = palette.text })
			end
		elseif desc:IsA("TextBox") then
			tween(desc, { BackgroundColor3 = palette.bg, TextColor3 = palette.text })
		elseif desc:IsA("UIStroke") then
			if desc.Parent.Name ~= "MainFrame" and desc.Parent.Name ~= "GlowFrame" and not desc.Parent.Name:find("Tab_") then
				tween(desc, { Color = palette.border })
			end
		end
	end

	local activeTab = homePanel.Visible and "Home" or (scriptsPanel.Visible and "Scripts" or "Settings")

	for _, child in ipairs(tabContainer:GetChildren()) do
		if child:IsA("TextButton") then
			local stroke = child:FindFirstChildOfClass("UIStroke")
			if stroke then
				local tabName = child.Name:sub(5)
				tween(stroke, { Color = (tabName == activeTab) and getAccentColor() or palette.border })
			end
			for _, subChild in ipairs(child:GetChildren()) do
				if subChild:IsA("TextLabel") then
					tween(subChild, { TextColor3 = palette.subText })
				end
			end
		end
	end
end
local function destroyLibrary()
	for _, connection in ipairs(activeConnections) do
		if connection then
			connection:Disconnect()
		end
	end
	activeConnections = {}
	
	fadeUI(mainFrame, 1, 0.4)
	fadeUI(fullScreenContainer, 1, 0.4)
	
	task.wait(0.4)
	screenGui:Destroy()
end

local function processClipboard()
	local clipboardFunc = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if clipboardFunc then
		clipboardFunc("https://discord.gg/nekolib")
	end
end

local function applyHSVInteraction()
	local isDragging = false

	local function updateColor(input)
		local inputPosition = input.Position.X
		local sliderPosition = hsvControl.AbsolutePosition.X
		local sliderWidth = hsvControl.AbsoluteSize.X
		local percentage = math.clamp((inputPosition - sliderPosition) / sliderWidth, 0, 1)

		hsvIndicator.Position = UDim2.new(percentage, -7, 0.5, -7)
		uiTheme.Hue = percentage
		applyAccentUpdates()
	end

	table.insert(activeConnections, hsvControl.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			updateColor(input)
		end
	end))

	table.insert(activeConnections, UserInputService.InputChanged:Connect(function(input)
		if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateColor(input)
		end
	end))

	table.insert(activeConnections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = false
		end
	end))
end

local function startCoreLoop()
	fadeUI(fullScreenContainer, 0, 0.1)
	
	local fillTween = TweenService:Create(loadingFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 1, 0) })
	fillTween:Play()
	fillTween.Completed:Wait()

	fadeUI(splashFrame, 1, 0.4)
	task.wait(0.4)
	splashFrame.Visible = false

	keyFrame.Visible = true
	fadeUI(keyFrame, 0, 0.3)
	applyAccentUpdates()

	table.insert(activeConnections, btnContinue.MouseButton1Click:Connect(function()
		if keyInput.Text == "NekoLib_FreeKey" then
			fadeUI(fullScreenContainer, 1, 0.5)
			task.wait(0.5)
			
			fullScreenContainer.Visible = false
			mainFrame.Visible = true
			fadeUI(mainFrame, 0, 0.5)
			
			dragLogic()
			applyHSVInteraction()
		else
			keyInputStroke.Color = Color3.fromRGB(255, 70, 70)
			task.delay(1, function()
				keyInputStroke.Color = uiTheme[uiTheme.Current].border
			end)
		end
	end))

	table.insert(activeConnections, btnGetKey.MouseButton1Click:Connect(processClipboard))
	table.insert(activeConnections, btnUnload.MouseButton1Click:Connect(destroyLibrary))
	table.insert(activeConnections, btnClose.MouseButton1Click:Connect(destroyLibrary))

	table.insert(activeConnections, tabHome.MouseButton1Click:Connect(function() switchTab("Home") end))
	table.insert(activeConnections, tabScripts.MouseButton1Click:Connect(function() switchTab("Scripts") end))
	table.insert(activeConnections, tabSettings.MouseButton1Click:Connect(function() switchTab("Settings") end))
	switchTab("Home")

	table.insert(activeConnections, btnTheme.MouseButton1Click:Connect(function()
		if uiTheme.Current == "Dark" then
			themeTransition("Light")
		else
			themeTransition("Dark")
		end
	end))
end

task.spawn(startCoreLoop)
