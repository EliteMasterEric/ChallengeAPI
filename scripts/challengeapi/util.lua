ChallengeAPI.Util = {}

function ChallengeAPI.Util.SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "[^" .. sep .. "]+") do
        table.insert(t, str)
    end
    return t
end

function ChallengeAPI.Util.TearDelayToFireRate(delay)
    return 30 / (delay + 1)
end

function ChallengeAPI.Util.FireRateToTearDelay(fireRate)
    return (30 / fireRate)
end

---Replaces Variable placeholders in string with a given value
---Example: "My {1} message" --> "My test message"
---varID can be omitted to replace {1} (or pass in a string table, to replace {1}, {2}, etc.)
---@see EID:ReplaceVariableStr https://github.com/wofsauge/External-Item-Descriptions/blob/master/features/eid_api.lua#L3024C1-L3045C4
---@param str string
---@param varID integer | integer[] | string | string[]
---@param newString? string | string[] | integer
function ChallengeAPI.Util.ReplaceVariableStr(str, varID, newString)
	if newString == nil then
		newString = varID ---@diagnostic disable-line
		varID = 1
	end
	if type(str) ~= "string" or newString == nil then return str end
	
	if type(newString) == "table" then
		for i = 1, #newString do
			str = str:gsub("{"..i.."}", newString[i])
		end
		return str
	else
		return str:gsub("{"..varID.."}", newString)
	end
end

-- Append all the contents of t2 to t1
function ChallengeAPI.Util.AppendTable(t1, t2)
    for i = 1, #t2 do
        t1[#t1 + 1] = t2[i]
    end
    return t1
end

-- Returns true if the given table contains the given value.
function ChallengeAPI.Util.TableContains(t, value)
    for _, v in ipairs(t) do
        if v == value then
            return true
        end
    end
    return false
end

function ChallengeAPI.Util.LoadGoalIcon(iconPath)
    local sprite = Sprite()
    sprite:Load("gfx/ui/challenges/goals/goal.anm2", false)
    sprite:ReplaceSpritesheet(0, iconPath)
    sprite:LoadGraphics()
    return sprite
end