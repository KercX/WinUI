local Utils = {}
local TweenService = game:GetService("TweenService")

function Utils:Tween(object, info, goals)
    local tween = TweenService:Create(object, TweenInfo.new(unpack(info)), goals)
    tween:Play()
    return tween
end

function Utils:CreateRipple(button)
    -- 
end

return Utils
