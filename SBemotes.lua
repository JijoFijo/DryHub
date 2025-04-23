local UserInputService = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local consoleEmotes = playerGui:WaitForChild("ConsoleEmotes")

-- Open GUI with B
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end  -- Ignore if typing in chat or another UI element
    if input.KeyCode == Enum.KeyCode.B then
        consoleEmotes.Enabled = true
    end
end)

-- Function to connect emote buttons
local function connectEmoteButtons()
    for _, object in pairs(consoleEmotes:GetDescendants()) do
        if object:IsA("TextButton") or object:IsA("ImageButton") then
            object.MouseButton1Click:Connect(function()
                -- Put your emote trigger code here if you want!
                consoleEmotes.Enabled = false  -- Hide GUI after clicking
            end)
        end
    end
end

connectEmoteButtons()
