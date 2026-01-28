-- Various player and stage info, more text = fps drop so we should be sparing
local profileP1 = GetPlayerOrMachineProfile(PLAYER_1)
local PlayerFrameX = 8
local PlayerFrameY = SCREEN_HEIGHT - 58
local bgalpha = PREFSMAN:GetPreference("BGBrightness")

local translated_info = {
	Judge = THEME:GetString("ScreenGameplay", "ScoringJudge"),
	Scoring = THEME:GetString("ScreenGameplay", "ScoringType")
}

local t = Def.ActorFrame {
	Def.Quad {
		InitCommand = function(self)
			self:xy(0, SCREEN_HEIGHT):align(0,1):zoomto(150,61)
			self:diffuse(0,0,0,bgalpha*0.4)
		end,
	},
	Def.Quad {
		InitCommand = function(self)
			self:xy(150, SCREEN_HEIGHT):align(0,1):zoomto((SCREEN_WIDTH*.44)-150,18)
			self:diffuse(0,0,0,bgalpha*0.4)
			self:faderight(0.7)
		end,
	},
	Def.Sprite {
		InitCommand = function(self)
			self:halign(0):valign(0):xy(PlayerFrameX, PlayerFrameY + 2)
		end,
		BeginCommand = function(self)
			self:finishtweening()
			self:Load(getAvatarPath(PLAYER_1))
			self:zoomto(48, 48)
		end
	},
	LoadFont("Common Large") .. {
		InitCommand = function(self)
			self:xy(PlayerFrameX + 100, PlayerFrameY + 32):halign(0):zoom(0.35):maxwidth(140):diffuse(getMainColor("positive"))
		end,
		SetCommand = function(self)
			self:settext(getDifficulty(GAMESTATE:GetCurrentSteps():GetDifficulty()))
			self:diffuse(
				getDifficultyColor(
					GetCustomDifficulty(
						GAMESTATE:GetCurrentSteps():GetStepsType(),
						GAMESTATE:GetCurrentSteps():GetDifficulty()
					)
				)
			)
		end,
		DoneLoadingNextSongMessageCommand = function(self)
			self:queuecommand("Set")
		end
	},
	LoadFont("Common Large") .. {
		InitCommand = function(self)
			self:xy(PlayerFrameX + 52, PlayerFrameY + 38):halign(0):zoom(0.7):maxwidth(64)
		end,
		SetCommand = function(self)
			local meter = GAMESTATE:GetCurrentSteps():GetMSD(getCurRateValue(), 1)
			self:settextf("%05.2f", meter)
			self:diffuse(byMSD(meter))
		end,
		DoneLoadingNextSongMessageCommand = function(self)
			self:queuecommand("Set")
		end,
		CurrentRateChangedMessageCommand = function(self)
			self:queuecommand("Set")
		end,
		PracticeModeReloadMessageCommand = function(self)
			self:queuecommand("Set")
		end
	},
	LoadFont("Common Normal") .. {
		InitCommand = function(self)
			self:xy(PlayerFrameX + 100, PlayerFrameY + 46):halign(0):zoom(0.4):maxwidth(SCREEN_WIDTH * 0.5)
		end,
		BeginCommand = function(self)
			self:settextf("%s, J%d", getModifierTranslations(GAMESTATE:GetPlayerState():GetPlayerOptionsString("ModsLevel_Current")), GetTimingDifficulty())
		end
	},
	LoadFont("Common Normal") .. {
		InitCommand = function(self)
			self:xy(PlayerFrameX + 52, PlayerFrameY + 14):halign(0):zoom(0.75)
		end,
		BeginCommand = function(self)
			-- set player name
			local pname = PROFILEMAN:GetPlayerName(PLAYER_1)
			if pname ~= "" then
				self:settext(pname)
			end
		end
	},
}
return t
