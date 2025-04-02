local t = Def.ActorFrame {}
local choiceStyle = themeConfig:get_data().global.ResultScreenStyle

if choiceStyle == 1 then
    t[#t+1] = LoadActor("Unredable/default")
elseif choiceStyle == 2 then
    t[#t+1] = LoadActor("Reimuboobs/default")
elseif choiceStyle == 3 then
	t[#t+1] = LoadActor("TilDeath/default")
end

translated_info = {
	Title = THEME:GetString("ScreenEvaluation", "Title"),
	Replay = THEME:GetString("ScreenEvaluation", "ReplayTitle")
}

--readded this bc the gradecounter breaks if the replay results text is not present
--thanks steffen
t[#t + 1] = LoadFont("Common Large") .. {
	InitCommand = function(self)
		self:xy(30, 32):halign(0):valign(1):zoom(0.35):diffuse(getMainColor("positive")):diffusealpha(0)
		self:settext("")
	end,
	OnCommand = function(self)
		local title = translated_info["Title"]
		local ss = SCREENMAN:GetTopScreen():GetStageStats()
		if not ss:GetLivePlay() then title = translated_info["Replay"] end
		local gamename = GAMESTATE:GetCurrentGame():GetName():lower()
		if gamename ~= "dance" then
			title = gamename:gsub("^%l", string.upper) .. " " .. title
		end
		self:settextf("%s:", title)

		-- gradecounter logic
		-- only increment gradecounter on liveplay
		local liveplay = ss:GetLivePlay()
		if liveplay then
			local score = SCOREMAN:GetMostRecentScore()
			local wg = score:GetWifeGrade()
			if wg == "Grade_Tier01" or wg == "Grade_Tier02" or wg == "Grade_Tier03" or wg == "Grade_Tier04" then
				GRADECOUNTERSTORAGE:increment("AAAA")
			elseif wg == "Grade_Tier05" or wg == "Grade_Tier06" or wg == "Grade_Tier07" then
				GRADECOUNTERSTORAGE:increment("AAA")
			elseif wg == "Grade_Tier08" or wg == "Grade_Tier09" or wg == "Grade_Tier10" then
				GRADECOUNTERSTORAGE:increment("AA")
			elseif wg == "Grade_Tier11" or wg == "Grade_Tier12" or wg == "Grade_Tier13" then
				GRADECOUNTERSTORAGE:increment("A")
			end
		end
		-- gradecounter logic end
	end,
}

t[#t + 1] = LoadActor("../_volumecontrol")
t[#t + 1] = LoadActor("../_cursor")

return t
