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
mainFrame.Size = UDim2.new(0, 580, 0, 380)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
mainFrame.BackgroundColor3 = uiTheme.Dark.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Visible = false
mainFrame.ZIndex = 1
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 16)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Thickness = 1.5
mainFrameStroke.Color = uiTheme.Dark.border
mainFrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainFrameStroke.Parent = mainFrame

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 170, 1, 0)
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
header.Size = UDim2.new(1, -170, 0, 50)
header.Position = UDim2.new(0, 170, 0, 0)
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
btnClose.Text = "✕"
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
workspaceContainer.Size = UDim2.new(1, -190, 1, -70)
workspaceContainer.Position = UDim2.new(0, 190, 0, 60)
workspaceContainer.BackgroundTransparency = 1
workspaceContainer.ZIndex = 2
workspaceContainer.Parent = mainFrame

local homePanel = Instance.new("Frame")
homePanel.Name = "HomePanel"
homePanel.Size = UDim2.new(1, 0, 1, 0)
homePanel.BackgroundTransparency = 1
homePanel.ZIndex = 3
homePanel.Parent = workspaceContainer

local scriptsPanel = Instance.new("Frame")
scriptsPanel.Name = "ScriptsPanel"
scriptsPanel.Size = UDim2.new(1, 0, 1, 0)
scriptsPanel.BackgroundTransparency = 1
scriptsPanel.Visible = false
scriptsPanel.ZIndex = 3
scriptsPanel.Parent = workspaceContainer

local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1, 0, 1, 0)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 3
settingsPanel.Parent = workspaceContainer

local scriptsTitle = Instance.new("TextLabel")
scriptsTitle.Name = "ScriptsTitle"
scriptsTitle.Size = UDim2.new(1, 0, 0, 30)
scriptsTitle.BackgroundTransparency = 1
scriptsTitle.Text = "Available Scripts"
scriptsTitle.TextColor3 = uiTheme.Dark.text
scriptsTitle.Font = Enum.Font.GothamBold
scriptsTitle.TextSize = 20
scriptsTitle.TextXAlignment = Enum.TextXAlignment.Left
scriptsTitle.ZIndex = 4
scriptsTitle.Parent = scriptsPanel

local scriptsScroll = Instance.new("ScrollingFrame")
scriptsScroll.Name = "ScriptsScroll"
scriptsScroll.Size = UDim2.new(1, 0, 1, -40)
scriptsScroll.Position = UDim2.new(0, 0, 0, 40)
scriptsScroll.BackgroundTransparency = 1
scriptsScroll.BorderSizePixel = 0
scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scriptsScroll.ScrollBarThickness = 4
scriptsScroll.ScrollBarImageColor3 = uiTheme.Dark.border
scriptsScroll.ZIndex = 4
scriptsScroll.Parent = scriptsPanel

local scriptsLayout = Instance.new("UIListLayout")
scriptsLayout.SortOrder = Enum.SortOrder.LayoutOrder
scriptsLayout.Padding = UDim.new(0, 10)
scriptsLayout.Parent = scriptsScroll

local function addScriptItem(name, desc, code)
	local item = Instance.new("Frame")
	item.Name = "OpaqueFrame"
	item.Size = UDim2.new(1, -10, 0, 60)
	item.BackgroundColor3 = uiTheme.Dark.card
	item.ZIndex = 5
	item.Parent = scriptsScroll

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

addScriptItem("Advanced Hub", "Universal exploit script hub.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/Meguminesan/script/refs/heads/main/advancedhub'))()")
addScriptItem("Infinite Yield", "Popular admin command script.", "loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()")

table.insert(activeConnections, scriptsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scriptsScroll.CanvasSize = UDim2.new(0, 0, 0, scriptsLayout.AbsoluteContentSize.Y + 10)
end))

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
settingsDesc.Size = UDim2.new(1, 0, 0, 40)
settingsDesc.Position = UDim2.new(0, 0, 0, 35)
settingsDesc.BackgroundTransparency = 1
settingsDesc.Text = "Configure the visual preferences and shell execution modes of NekoLib."
settingsDesc.TextColor3 = uiTheme.Dark.subText
settingsDesc.Font = Enum.Font.Gotham
settingsDesc.TextSize = 13
settingsDesc.TextXAlignment = Enum.TextXAlignment.Left
settingsDesc.ZIndex = 4
settingsDesc.Parent = settingsPanel

local function switchTab(tabName)
	homePanel.Visible = (tabName == "Home")
	scriptsPanel.Visible = (tabName == "Scripts")
	settingsPanel.Visible = (tabName == "Settings")

	local tabs = {Home = tabHome, Scripts = tabScripts, Settings = tabSettings}
	for name, btn in pairs(tabs) do
		local stroke = btn:FindFirstChildOfClass("UIStroke")
		if stroke then
			if name == tabName then
				stroke.Color = getAccentColor()
			else
				stroke.Color = uiTheme[uiTheme.Current].border
			end
		end
	end
end

local welcomeText = Instance.new("TextLabel")
welcomeText.Name = "WelcomeText"
welcomeText.Size = UDim2.new(1, 0, 0, 30)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Welcome to NekoLib Premium"
welcomeText.TextColor3 = uiTheme.Dark.text
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextSize = 20
welcomeText.ZIndex = 4
welcomeText.TextXAlignment = Enum.TextXAlignment.Left
welcomeText.Parent = homePanel

local descText = Instance.new("TextLabel")
descText.Name = "DescText"
descText.Size = UDim2.new(1, 0, 0, 80)
descText.Position = UDim2.new(0, 0, 0, 35)
descText.BackgroundTransparency = 1
descText.Text = "You have unlocked the runtime workspace successfully. Full access has been granted. Enjoy constructing scripts inside our high-performance UI shell framework."
descText.TextColor3 = uiTheme.Dark.subText
descText.Font = Enum.Font.Gotham
descText.TextSize = 13
descText.TextWrapped = true
descText.ZIndex = 4
descText.TextXAlignment = Enum.TextXAlignment.Left
descText.TextYAlignment = Enum.TextYAlignment.Top
descText.Parent = homePanel

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
	
	local activeTab = homePanel.Visible and "Home" or (scriptsPanel.Visible and "Scripts" or "Settings")
	local tabs = {Home = tabHome, Scripts = tabScripts, Settings = tabSettings}
	local activeBtn = tabs[activeTab]
	if activeBtn then
		local stroke = activeBtn:FindFirstChildOfClass("UIStroke")
		if stroke then stroke.Color = getAccentColor() end
	end

	for _, desc in ipairs(scriptsScroll:GetDescendants()) do
		if desc:IsA("TextButton") and desc.Name == "OpaqueButton" then
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
	tween(mainFrameStroke, { Color = palette.border })
	tween(keyTitle, { TextColor3 = palette.text })
	tween(keySubtitle, { TextColor3 = palette.subText })
	tween(sidebar, { BackgroundColor3 = palette.card })
	tween(sidebarTitle, { TextColor3 = palette.text })
	tween(sidebarCover, { BackgroundColor3 = palette.card })
	tween(sidebarDivider, { Color = palette.border })
	tween(userDisplayName, { TextColor3 = palette.text })
	tween(userHandle, { TextColor3 = palette.subText })
	tween(headerTitle, { TextColor3 = palette.text })
	tween(welcomeText, { TextColor3 = palette.text })
	tween(descText, { TextColor3 = palette.subText })
	tween(scriptsTitle, { TextColor3 = palette.text })
	tween(settingsTitle, { TextColor3 = palette.text })
	tween(settingsDesc, { TextColor3 = palette.subText })
	scriptsScroll.ScrollBarImageColor3 = palette.border
	tween(btnUnload, { BackgroundColor3 = palette.bg })
	tween(btnGetKey, { BackgroundColor3 = palette.bg })
	tween(btnClose, { BackgroundColor3 = palette.card })
	tween(btnTheme, { BackgroundColor3 = palette.card, TextColor3 = palette.text })
	btnTheme.Text = themeName == "Dark" and "🌙" or "☀️"

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

	for _, desc in ipairs(scriptsScroll:GetDescendants()) do
		if desc:IsA("Frame") and desc.Name == "OpaqueFrame" then
			tween(desc, { BackgroundColor3 = palette.card })
			local stroke = desc:FindFirstChildOfClass("UIStroke")
			if stroke then tween(stroke, { Color = palette.border }) end
		elseif desc:IsA("TextLabel") then
			if desc.Name == "TitleLabel" then
				tween(desc, { TextColor3 = palette.text })
			elseif desc.Name == "DescLabel" then
				tween(desc, { TextColor3 = palette.subText })
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
