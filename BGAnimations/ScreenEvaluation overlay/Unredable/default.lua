local t = Def.ActorFrame {}

--Group folder name
local frameWidth = 280
local frameHeight = 20
local frameX = SCREEN_WIDTH - 5
local frameY = 15

t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(frameX, frameY + 5):halign(1):zoom(0.4):maxwidth((frameWidth - 40) / 0.3)
	end,
	BeginCommand = function(self)
		self:queuecommand("Set"):diffuse(getMainColor("positive")):diffusebottomedge(Saturation(getMainColor("highlight"), 0.2))
	end,
	SetCommand = function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song ~= nil then
			self:settext(song:GetGroupName())
		end
	end
}

return t