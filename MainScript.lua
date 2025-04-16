local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Main Screen UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomUI"
screenGui.Parent = game:GetService("CoreGui")

-- Helper function to create UICorner
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

-- Helper function to create Frame
local function createFrame(parent, size, position, color, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = transparency or 0
    frame.BorderSizePixel = 0
    frame.Parent = parent
    return frame
end

-- UI Components
local borderFrame = createFrame(screenGui, UDim2.new(0, 802, 0, 602), UDim2.new(0.5, -401, 0.5, -301), Color3.fromRGB(75, 75, 95))
createUICorner(borderFrame, 8)

local mainFrame = createFrame(borderFrame, UDim2.new(0, 800, 0, 600), UDim2.new(0.5, -400, 0.5, -300), Color3.fromRGB(20, 20, 30))
mainFrame.ClipsDescendants = true
createUICorner(mainFrame, 8)

local topBar = createFrame(mainFrame, UDim2.new(1, -150, 0, 50), UDim2.new(0, 150, 0, 0), Color3.fromRGB(25, 25, 35), 0.1)
createUICorner(topBar, 8)

-- Add an image to the very left of the topBar
local topBarImage = Instance.new("ImageLabel")
topBarImage.Size = UDim2.new(0, 60, 0, 60) -- Increased size slightly
topBarImage.Position = UDim2.new(0, -5, 0.5, -30) -- Adjusted position to center the larger image
topBarImage.BackgroundTransparency = 1
topBarImage.Image = "rbxassetid://89867993663380" -- Replace with the actual image ID
topBarImage.Parent = topBar

-- Add text next to the image
local topBarText = Instance.new("TextLabel")
topBarText.Size = UDim2.new(0, 200, 0, 50) -- Adjusted size for the text
topBarText.Position = UDim2.new(0, 45, 0.5, -26) -- Positioned next to the image
topBarText.BackgroundTransparency = 1
topBarText.Text = "Krypton"
topBarText.TextColor3 = Color3.fromRGB(220, 220, 220)
topBarText.Font = Enum.Font.GothamBold -- Bold font
topBarText.TextSize = 20 -- Adjusted text size
topBarText.TextXAlignment = Enum.TextXAlignment.Left
topBarText.Parent = topBar

local sidebar = createFrame(mainFrame, UDim2.new(0, 150, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(20, 20, 30))
createUICorner(sidebar, 8)

local contentPanel = createFrame(mainFrame, UDim2.new(1, -151, 1, -51), UDim2.new(0, 151, 0, 51), Color3.fromRGB(30, 30, 40), 0.2)
createUICorner(contentPanel, 8)

local innerPanel = createFrame(contentPanel, UDim2.new(0.98, 0, 0.91, 0), UDim2.new(0.01, 0, 0.073, 0), Color3.fromRGB(35, 35, 45))
createUICorner(innerPanel, 8) -- Rounded corners always

local tabExtension = createFrame(innerPanel, UDim2.new(0, 70, 0, 41), UDim2.new(0, 16, 0, -35), innerPanel.BackgroundColor3)
createUICorner(tabExtension, 8)

local tabExtensionText = Instance.new("TextLabel")
tabExtensionText.Size = UDim2.new(1, -20, 1, 0)
tabExtensionText.Position = UDim2.new(0, 20, 0, -3)
tabExtensionText.BackgroundTransparency = 1
tabExtensionText.TextColor3 = Color3.fromRGB(255, 255, 255)
tabExtensionText.Font = Enum.Font.GothamSemibold
tabExtensionText.TextSize = 12
tabExtensionText.Parent = tabExtension

local tabExtensionImage = Instance.new("ImageLabel")
tabExtensionImage.Size = UDim2.new(0, 14, 0, 14)
tabExtensionImage.Position = UDim2.new(0, 8, 0.5, -10)
tabExtensionImage.BackgroundTransparency = 1
tabExtensionImage.Parent = tabExtension

local cornerImage1 = Instance.new("ImageLabel")
cornerImage1.Size = UDim2.new(0, 10, 0, 10)
cornerImage1.Position = UDim2.new(0, -10, 0, 25)
cornerImage1.BackgroundTransparency = 1
cornerImage1.Image = "rbxassetid://140370829417994"
cornerImage1.Parent = tabExtension

local cornerImage2 = Instance.new("ImageLabel")
cornerImage2.Size = UDim2.new(0, 10, 0, 10)
cornerImage2.Position = UDim2.new(1, 0, 0, 25)
cornerImage2.BackgroundTransparency = 1
cornerImage2.Image = "rbxassetid://121243225898463"
cornerImage2.Parent = tabExtension

-- Dragging functionality
local dragging, dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    borderFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = borderFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Sidebar Buttons
local sections = {"Home", "Movement", "Visual", "Utility"}
local sectionImages = {
    Home = "rbxassetid://137123145292467", -- Replace with actual image IDs
    Movement = "rbxassetid://111502832608614",
    Visual = "rbxassetid://138701471245949", -- Replace with actual image IDs
    Utility = "rbxassetid://125189009266061"
}
local selectedButton = nil

for i, section in ipairs(sections) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (i - 1) * 60 + 10)
    button.BackgroundTransparency = 1
    button.Text = section
    button.TextColor3 = Color3.fromRGB(200, 200, 220)
    button.Font = Enum.Font.Gotham
    button.TextSize = 18
    button.Parent = sidebar

    local highlightBox = createFrame(button, UDim2.new(0.9, 0, 0.9, 0), UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(50, 50, 70), 1)
    createUICorner(highlightBox, 8)

    button.MouseEnter:Connect(function()
        if button ~= selectedButton then
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        TweenService:Create(highlightBox, TweenInfo.new(0.3), {BackgroundTransparency = 0.5}):Play()
    end)

    button.MouseLeave:Connect(function()
        if button ~= selectedButton then
            button.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        TweenService:Create(highlightBox, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    end)

    button.MouseButton1Click:Connect(function()
        if selectedButton then
            selectedButton.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        selectedButton = button
        button.TextColor3 = Color3.fromRGB(255, 255, 255)

        -- Update tabExtension
        tabExtension.Size = section == "Movement" and UDim2.new(0, 97, 0, 41) or UDim2.new(0, 70, 0, 41)
        tabExtensionText.Text = section
        tabExtensionImage.Image = sectionImages[section] or "rbxassetid://138701471245949"

        -- Clear innerPanel except for tabExtension, cornerImages, and UICorner
        for _, child in ipairs(innerPanel:GetChildren()) do
            if child ~= tabExtension and child ~= cornerImage1 and child ~= cornerImage2 and not child:IsA("UICorner") then
                child:Destroy()
            end
        end

        -- Add gravity toggle button if "Movement" section is selected
        if section == "Movement" then
            local toggleContainer = createFrame(innerPanel, UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.05, 0), Color3.fromRGB(43, 43, 53)) -- Darker toggle container
            createUICorner(toggleContainer, 8)

            -- Add lighter section for the image
            local imageSection = createFrame(toggleContainer, UDim2.new(0.1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(47, 47, 57))
            createUICorner(imageSection, 8)

            -- Mask the top-right corner
            local topRightMask = createFrame(imageSection, UDim2.new(0, 8, 0, 8), UDim2.new(1, -8, 0, 0), imageSection.BackgroundColor3)
            topRightMask.ZIndex = imageSection.ZIndex + 1

            -- Mask the bottom-right corner
            local bottomRightMask = createFrame(imageSection, UDim2.new(0, 8, 0, 8), UDim2.new(1, -8, 1, -8), imageSection.BackgroundColor3)
            bottomRightMask.ZIndex = imageSection.ZIndex + 1

            -- Add an ImageLabel to display an image
            local image = Instance.new("ImageLabel")
            image.Size = UDim2.new(0.8, 0, 0.8, 0)
            image.Position = UDim2.new(0.1, 0, 0.1, 0)
            image.BackgroundTransparency = 1
            image.Image = "rbxassetid://99437722862457" -- Replace with the actual image ID
            image.Parent = imageSection

            -- Add bold "Gravity" text and move it to the left
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(0.3, 0, 1, 0)
            toggleLabel.Position = UDim2.new(0.13, 0, 0, 0) -- Moved to the left
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = "Gravity"
            toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.Font = Enum.Font.GothamBold -- Made bold
            toggleLabel.TextSize = 16
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleContainer

            local toggleDescription = Instance.new("TextLabel")
            toggleDescription.Size = UDim2.new(0.4, 0, 1, 0)
            toggleDescription.Position = UDim2.new(0.25, 0, 0, 0)
            toggleDescription.BackgroundTransparency = 1
            toggleDescription.Text = "Default: 196.2, Low: 100"
            toggleDescription.TextColor3 = Color3.fromRGB(150, 150, 150)
            toggleDescription.Font = Enum.Font.Gotham
            toggleDescription.TextSize = 12
            toggleDescription.TextXAlignment = Enum.TextXAlignment.Left
            toggleDescription.Parent = toggleContainer
        end
    end)
end

-- Borders
createFrame(mainFrame, UDim2.new(0, 1, 1, 0), UDim2.new(0, 150, 0, 0), Color3.fromRGB(35, 35, 55))
createFrame(mainFrame, UDim2.new(1, -150, 0, 1), UDim2.new(0, 150, 0, 50), Color3.fromRGB(35, 35, 55))
