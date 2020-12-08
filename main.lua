-- utils
function notification(cnf)
	game:service'StarterGui':SetCore("SendNotification",cnf)
end

-- init
while not game.IsLoaded do game:service'RunService'.RenderStepped:Wait() end
if (game:service'CoreGui':FindFirstChild("quRoot") and qu) then error("quLib is already loaded.") end
print("quLib -> loaded")

local root = Instance.new("Folder", game:service'CoreGui')
root.Name = "quRoot"

game:service'RunService'.RenderStepped:Connect(function()
    if not game:service'CoreGui':FindFirstChild("DevConsoleMaster") then return end
    local devConsoleUI = game:service'CoreGui'.DevConsoleMaster.DevConsoleWindow.DevConsoleUI
    local mainView = devConsoleUI:FindFirstChild("MainView")
    if mainView then
        local clientLog = mainView:FindFirstChild("ClientLog")
        for _,log in pairs(clientLog:GetChildren()) do
            if (log:IsA("Frame") and log.Name ~= "WindowingPadding") then
                local msg = log:FindFirstChild("msg")
                if msg then
                    local pattern = "QU|%d%d%d,%d%d%d,%d%d%d|"
                    local find0,find1 = string.find(msg.Text, pattern)
                    
                    if (find0 and find1) then
                        local foundPattern = string.sub(msg.Text, find0, find1)
                        local r = tonumber(string.sub(foundPattern, 4,6))
                        local g = tonumber(string.sub(foundPattern, 8,10))
                        local b = tonumber(string.sub(foundPattern, 12,14))
                        
                        local stringBuilder = ""
                        stringBuilder = stringBuilder..string.sub(msg.Text, 1, find0-1)
                        stringBuilder = stringBuilder..string.sub(msg.Text, find1+1, #msg.Text)
                        msg.Text = stringBuilder
                        msg.TextColor3 = Color3.fromRGB(r,g,b)
                    end
                end
            end
        end
    end
end)

-- table
local qu = {}

function qu:this()
    return qu
end

function qu:tick()
    return game:service'RunService'.RenderStepped:Wait()
end

function qu:service(...)
    return game:service(...)
end

function qu:players()
    return game:service'Players'
end

function qu:replicatedStorage()
    return game:service'ReplicatedStorage'
end

function qu:coreGui()
    return game:service'CoreGui'
end

function qu:starterGui()
    return game:service'StarterGui'
end

function qu:lighting()
    return game:service'Lighting'
end

function qu:testService()
    return game:service'TestService'
end

function qu:runService()
    return game:service'RunService'
end

function qu:getPlayers()
    return game:service'Players':GetPlayers()
end

function qu:localPlayer()
    return game:service'Players'.LocalPlayer
end

function qu:localChar()
    return game:service'Players'.LocalPlayer.Character
end

function qu:localHum()
    return game:service'Players'.LocalPlayer.Character.Humanoid
end

function qu:notify(title, text)
    notification({Title=title,Text=text,Icon=nil,Duration=5,Callback=nil})
end

function qu:printf(fmt, ...)
    return print(string.format(fmt, ...))
end

function qu:cprintf(R,G,B, fmt, ...)
    return print(string.format(("QU|%03d,%03d,%03d|"):format(R, G, B)..fmt, ...))
end

function qu:warnf(fmt, ...)
    return warn(string.format(fmt, ...))
end

function qu:errorf(fmt, ...)
    return error(string.format(fmt, ...))
end

function qu:infof(fmt, ...)
    return print(string.format(("QU|%03d,%03d,%03d|"):format(0, 162, 255)..fmt, ...))
end

function qu:assertf(condition, fmt, ...)
    return assert(condition, string.format(fmt, ...))
end

function qu:iNew(className, properties) 
    local instance = Instance.new(className)
    for n,v in pairs(properties) do instance[n] = v end
    return instance
end

function qu:waitUntil(condf)
    local start = tick()
    while not condf() do game:service'RunService'.RenderStepped:Wait() end
    return tick()-start
end

getgenv()["qu"] = qu
