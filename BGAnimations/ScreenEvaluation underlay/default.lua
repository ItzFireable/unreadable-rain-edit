local choiceStyle = themeConfig:get_data().global.ResultScreenStyle

local t = Def.ActorFrame {}

if choiceStyle == 1 then
    t[#t+1] = LoadActor("Unredable/default")
elseif choiceStyle == 2 then
    t[#t+1] = LoadActor("Reimuboobs/default")
elseif choiceStyle == 3 then
    t[#t+1] = LoadActor("TilDeath/default")
end

return t
