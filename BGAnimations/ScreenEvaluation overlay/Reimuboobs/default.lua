local t = Def.ActorFrame {}


translated_info = {
	Title = THEME:GetString("ScreenEvaluation", "Title"),
	Replay = THEME:GetString("ScreenEvaluation", "ReplayTitle")
}


--Group folder name
local frameWidth = SCREEN_CENTER_X - capWideScale(get43size(150),20)
local frameHeight = 20
local frameX = SCREEN_WIDTH - 20
local frameY = 15

t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(frameX, frameY + 10):halign(1):zoom(0.35):maxwidth((frameWidth) / 0.5)
	end,
	BeginCommand = function(self)
		self:queuecommand("Set"):diffuse(getMainColor("positive"))
	end,
	SetCommand = function(self)
		local song = GAMESTATE:GetCurrentSong()
		if song ~= nil then
			self:settext(song:GetGroupName())
		end
	end
}

local bannersizemultiplier = 1.27
local BannerWidth = 220 * bannersizemultiplier-- 220
local BannerHeight = 77 * bannersizemultiplier    -- 77

--test banner overlay
t[#t + 1] = Def.Quad {
	Name = "Banner",
	OnCommand = function(self)
		self:x(SCREEN_CENTER_X + capWideScale(get43size(280),280)):y(70):valign(0) --308
		self:scaletoclipped(capWideScale(get43size(270), BannerWidth), capWideScale(get43size(94.5), BannerHeight)) -- 220, 77
		self:diffuse(getMainColor("frames"))
	end
}

--test banner overlay
t[#t + 1] = Def.Sprite {
	Name = "Banner",
	OnCommand = function(self)
		self:x(SCREEN_CENTER_X + capWideScale(get43size(280),280)):y(70):valign(0) --308
		self:scaletoclipped(capWideScale(get43size(270), BannerWidth), capWideScale(get43size(94.5), BannerHeight)) -- 220, 77
		local bnpath = GAMESTATE:GetCurrentSong():GetBannerPath()
		self:visible(true)
		if not BannersEnabled() then
			self:visible(false)
		elseif not bnpath then
			bnpath = THEME:GetPathG("Common", "fallback banner")
		end
		self:LoadBackground(bnpath)
	end
}

--cdtitle for funsies
t[#t + 1] = Def.Sprite {
	Texture= GAMESTATE:GetCurrentSong():GetCDTitlePath(),
	InitCommand=function(self)
		self:xy(SCREEN_RIGHT - 30,SCREEN_CENTER_Y - 180):wag()

		local height = self:GetHeight()
		local width = self:GetWidth()

		if height >= 60 and width >= 75 then
			if height * (75 / 60) >= width then
				self:zoom(40 / height)
			else
				self:zoom(56.25 / width)
			end
		elseif height >= 60 then
			self:zoom(40 / height)
		elseif width >= 75 then
			self:zoom(56.25 / width)
		else
			self:zoom(0.75)
		end
	end
}

return t

