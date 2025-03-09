-- Removendo a restrição de PlaceId para funcionar em todos os jogos
World1, World2, World3 = true, true, true

function CheckQuest() 
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    -- O código continua com a lógica de missões, se necessário
end

function Hop()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    function TPReturner()
        local Site;
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        for i,v in pairs(Site.data) do
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, v.id, game.Players.LocalPlayer)
                wait(4)
            end
        end
    end
    function Teleport() 
        while wait() do
            pcall(TPReturner)
        end
    end
    Teleport()
end

function UpdateESP() 
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        pcall(function()
            if not v.Character or not v.Character:FindFirstChild("Head") then return end
            local esp = v.Character.Head:FindFirstChild("ESP")
            if not esp then
                esp = Instance.new("BillboardGui", v.Character.Head)
                esp.Name = "ESP"
                esp.Size = UDim2.new(1, 200, 1, 30)
                esp.Adornee = v.Character.Head
                esp.AlwaysOnTop = true
                local label = Instance.new("TextLabel", esp)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.Text = v.Name .. "\n" .. math.floor((game.Players.LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude) .. "m"
            else
                esp.TextLabel.Text = v.Name .. "\n" .. math.floor((game.Players.LocalPlayer.Character.Head.Position - v.Character.Head.Position).Magnitude) .. "m"
            end
        end)
    end
end

while wait(1) do
    UpdateESP()
end
