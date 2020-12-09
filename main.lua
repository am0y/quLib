-- utils
local function notification(cnf)
	game:service'StarterGui':SetCore("SendNotification",cnf)
end

local function tickcos()
    return (math.cos(tick())+1)/2
end

local function out(...)
    print("|quLib|", ...)
end

local function outf(fmt, ...)
    out(fmt:format(...))
end

-- init
while not game.IsLoaded do game:service'RunService'.RenderStepped:Wait() end
if (game:service'CoreGui':FindFirstChild("quRoot") and qu) then error("quLib is already loaded.") end

local root = Instance.new("Folder", game:service'CoreGui')
root.Name = "quRoot"

local devConsoleWindow_DescendantAdded = function(descendant)
    local msg = descendant:FindFirstChild("msg")
    if msg then
        do -- cprintf
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

        do -- rainbow
            local pattern = "|quLib|"
            local find0,find1 = string.find(msg.Text, pattern)
            if (find0 and find1) then                
                spawn(function() 
                    while game:service'RunService'.RenderStepped:Wait() do
                        if not msg then break end
                        msg.TextColor3 = Color3.fromHSV(tickcos(), 1, 1)
                    end
                end)  
            end                      
        end
    end
end
while not game:service'CoreGui':FindFirstChild("DevConsoleMaster") do game:service'RunService'.RenderStepped:Wait() end
game:service'CoreGui'.DevConsoleMaster.DevConsoleWindow.DescendantAdded:Connect(devConsoleWindow_DescendantAdded)

-- table
local qu = {}
local qu_s = {}
local qu_s_mt = {}
function qu_s_mt.__index(t,k)
    return game:service(k)
end
setmetatable(qu_s, qu_s_mt)

function qu:s()
    return qu_s
end

function qu:wait()
    return game:service'RunService'.RenderStepped:Wait()
end

function qu:plrs()
    return game:service'Players':GetPlayers()
end

function qu:lplr()
    return game:service'Players'.LocalPlayer
end

function qu:lchar()
    return game:service'Players'.LocalPlayer.Character
end

function qu:lhum()
    return game:service'Players'.LocalPlayer.Character.Humanoid
end

function qu:notify(title, text)
    notification({Title=title,Text=text,Icon=nil,Duration=5,Callback=nil})
end

function qu:printf(fmt, ...)
    return print(fmt:format(...))
end

function qu:cprintf(R,G,B, fmt, ...)
    return print(string.format(("QU|%03d,%03d,%03d|"):format(R, G, B)..fmt, ...))
end

function qu:warnf(fmt, ...)
    return warn(fmt:format(...))
end

function qu:errorf(fmt, ...)
    return error(fmt:format(...))
end

function qu:infof(fmt, ...)
    return print(string.format(("QU|%03d,%03d,%03d|"):format(0, 162, 255)..fmt, ...))
end

function qu:assertf(condition, fmt, ...)
    return assert(condition, fmt:format(...))
end

function qu:inew(className, properties) 
    local instance = Instance.new(className)
    for n,v in pairs(properties) do instance[n] = v end
    return instance
end

function qu:waituntil(condf)
    local start = tick()
    while not condf() do game:service'RunService'.RenderStepped:Wait() end
    return tick()-start
end

function qu:waitn(n)
    local start = tick()
    local cnt = 0
    while cnt < n do game:service'RunService'.RenderStepped:Wait() cnt = cnt + 1 end
    return tick()-start
end

getgenv()["qu"] = qu

out("loaded")
out("warning: quLib is not finished, so if you used it to make a script, expect your script to break when an update happens.")
