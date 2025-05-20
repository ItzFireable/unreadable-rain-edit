local rain = function(angle, intensity)
    local speed = 1 - math.min(intensity, 800) / 1000
    local t = Def.ActorFrame {}
    for i = 1, math.min(300, intensity) do
        t[#t+1] = Def.Quad {
            InitCommand = function(self)
                self:queuecommand("Regen")
            end,
            RegenCommand = function(self)
                local where = math.random(-math.abs(angle) * 20,SCREEN_WIDTH + math.abs(angle) * 20)
                self:sleep(math.random(intensity) / intensity):rotationz(90 + angle):zoomto(intensity / 4,1):xy(where,-500):diffuse(color("#8888ff")):diffusealpha(0.4)
                self:linear(speed):xy(where - (angle * 30), SCREEN_HEIGHT + 500):queuecommand("Regen")
            end
        }
    end
    return t
end

local t = Def.ActorFrame {}

t[#t+1] = rain(0, 300)

return t
