local defaultConfig = {
	grades = {
		Grade_Tier06 = "#eebb00",
		Grade_Tier07 = "#eebb00",
		Grade_Tier08 = "#66cc66",
		Grade_Tier09 = "#66cc66",
		Grade_Tier10 = "#66cc66",
		Grade_Tier11 = "#da5757",
		Grade_Tier12 = "#da5757",
		Grade_Tier13 = "#da5757",
		Grade_Tier14 = "#5b78bb",
		Grade_Tier15 = "#c97bff",
		Grade_Tier16 = "#8c6239",
		Grade_Tier17 = "#000000",
		Grade_None = "#666666",
		Grade_Failed = "#cdcdcd",
		Grade_Tier01 = "#ffffff",
		Grade_Tier02 = "#66ccff",
		Grade_Tier03 = "#66ccff",
		Grade_Tier04 = "#66ccff",
		Grade_Tier05 = "#eebb00"
	},
	difficulty = {
		Medium = "#ddaa00",
		Hard = "#ff6666",
		Crazy = "#cc66ff",
		Freestyle = "#666666",
		Edit = "#666666",
		Difficulty_Beginner = "#66ccff",
		Difficulty_Easy = "#099948",
		Difficulty_Medium = "#ddaa00",
		Difficulty_Hard = "#ff6666",
		Difficulty_Challenge = "#c97bff",
		Difficulty_Edit = "#666666",
		Challenge = "#c97bff",
		Difficulty_Crazy = "#cc66ff",
		Difficulty_Nightmare = "#666666",
		Difficulty_Freestyle = "#666666",
		Beginner = "#66ccff",
		Nightmare = "#666666",
		Easy = "#099948"
	},
	laneCover = { bpmText = "#4CBB17", heightText = "#FFFFFF", cover = "#333333" },
	leaderboard = { background = "#111111CC", text = "#ff2c60", border = "#000111" },
	judgment = {
		TapNoteScore_W2 = "#f2cb30",
		TapNoteScore_W1 = "#99ccff",
		HoldNoteScore_LetGo = "#cc2929",
		HoldNoteScore_Held = "#f2cb30",
		TapNoteScore_Miss = "#cc2929",
		TapNoteScore_W5 = "#ff1ab3",
		TapNoteScore_W4 = "#1ab2ff",
		TapNoteScore_W3 = "#14cc8f"
	},
	main = {
		tabs = "#000000",
		enabled = "#4CBB17",
		highlight = "#7a1f32",
		frames = "#000000",
		negative = "#FF9999",
		disabled = "#666666",
		positive = "#FF2B6F"
	},
	title = {
		Line_Right = "#ff2c60",
		BG_Left = "#161515",
		Line_Left = "#ff2c60",
		BG_Right = "#222222"
	},
	clearType = {
		SDP = "#cc8800",
		None = "#666666",
		PFC = "#eeaa00",
		BF = "#999999",
		Invalid = "#e61e25",
		SDG = "#448844",
		NoPlay = "#666666",
		FC = "#66cc66",
		Clear = "#33aaff",
		MF = "#cc6666",
		MFC = "#66ccff",
		SDCB = "#33bbff",
		Failed = "#e61e25",
		WF = "#dddddd"
	},
	combo = {
		Perf_FullCombo = "#fff568",
		FullCombo = "#a4ff00",
		RegularCombo = "#ffffff",
		ComboLabel = "#00aeef",
		Marv_FullCombo = "#00aeef"
	},
	difficultyVivid = {
		Medium = "#ffff00",
		Hard = "#ff0000",
		Crazy = "#cc66ff",
		Freestyle = "#666666",
		Edit = "#666666",
		Difficulty_Beginner = "#0099ff",
		Difficulty_Easy = "#00ff00",
		Difficulty_Medium = "#ffff00",
		Difficulty_Hard = "#ff0000",
		Difficulty_Challenge = "#cc66ff",
		Difficulty_Edit = "#666666",
		Challenge = "#cc66ff",
		Difficulty_Crazy = "#cc66ff",
		Difficulty_Nightmare = "#666666",
		Difficulty_Freestyle = "#666666",
		Beginner = "#0099ff",
		Nightmare = "#666666",
		Easy = "#00ff00"
	},
	songLength = { normal = "#FFFFFF", marathon = "#da5757", long = "#ff9a00" }
}

colorConfig = create_setting("colorConfig", "colorConfig.lua", defaultConfig, -1)
--colorConfig:load()

--keys to current table. Assumes a depth of 2.
local curColor = { "", "" }

function getTableKeys()
	return curColor
end

function setTableKeys(table)
	curColor = table
end

function getDefaultColorForCurColor()
	return defaultConfig[curColor[1]][curColor[2]]
end

function getMainColor(type)
	return color(colorConfig:get_data().main[type])
end

function getLeaderboardColor(type)
	return color(colorConfig:get_data().leaderboard[type])
end

function getLaneCoverColor(type)
	return color(colorConfig:get_data().laneCover[type])
end

function getGradeColor(grade)
	return color(colorConfig:get_data().grades[grade]) or color(colorConfig:get_data().grades["Grade_None"])
end

function getDifficultyColor(diff)
	return color(colorConfig:get_data().difficulty[diff]) or color("#ffffff")
end

function getVividDifficultyColor(diff)
	return color(colorConfig:get_data().difficultyVivid[diff]) or color("#ffffff")
end

function getTitleColor(type)
	return color(colorConfig:get_data().title[type])
end

function getComboColor(type)
	return color(colorConfig:get_data().combo[type])
end

-- expecting ms input (153, 13.321, etc) so convert to seconds to compare to judgment windows -mina
function offsetToJudgeColor(offset, scale)
	local offset = math.abs(offset / 1000)
	if not scale then
		scale = PREFSMAN:GetPreference("TimingWindowScale")
	end
	if offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW1") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W1"])
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW2") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W2"])
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW3") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W3"])
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW4") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W4"])
	elseif offset <= math.max(scale * PREFSMAN:GetPreference("TimingWindowSecondsW5"), 0.180) then
		return color(colorConfig:get_data().judgment["TapNoteScore_W5"])
	else
		return color(colorConfig:get_data().judgment["TapNoteScore_Miss"])
	end
end

-- 30% hardcoded, should var but lazy atm -mina
function offsetToJudgeColorAlpha(offset, scale)
	local offset = math.abs(offset / 1000)
	if not scale then
		scale = PREFSMAN:GetPreference("TimingWindowScale")
	end
	if offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW1") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W1"] .. "48")
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW2") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W2"] .. "48")
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW3") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W3"] .. "48")
	elseif offset <= scale * PREFSMAN:GetPreference("TimingWindowSecondsW4") then
		return color(colorConfig:get_data().judgment["TapNoteScore_W4"] .. "48")
	elseif offset <= math.max(scale * PREFSMAN:GetPreference("TimingWindowSecondsW5"), 0.180) then
		return color(colorConfig:get_data().judgment["TapNoteScore_W5"] .. "48")
	else
		return color(colorConfig:get_data().judgment["TapNoteScore_Miss"] .. "48")
	end
end

-- 30% hardcoded, should var but lazy atm -mina
function customOffsetToJudgeColor(offset, windows)
	local offset = math.abs(offset)
	if offset <= windows.TapNoteScore_W1 then
		return color(colorConfig:get_data().judgment["TapNoteScore_W1"])
	elseif offset <= windows.TapNoteScore_W2 then
		return color(colorConfig:get_data().judgment["TapNoteScore_W2"])
	elseif offset <= windows.TapNoteScore_W3 then
		return color(colorConfig:get_data().judgment["TapNoteScore_W3"])
	elseif offset <= windows.TapNoteScore_W4 then
		return color(colorConfig:get_data().judgment["TapNoteScore_W4"])
	elseif offset <= windows.TapNoteScore_W5 then
		return color(colorConfig:get_data().judgment["TapNoteScore_W5"])
	else
		return color(colorConfig:get_data().judgment["TapNoteScore_Miss"])
	end
end

function byJudgment(judge)
	return color(colorConfig:get_data().judgment[judge])
end

function byDifficulty(diff)
	return color(colorConfig:get_data().difficulty[diff])
end

-- i guess if i'm going to use this naming convention it might as well be complete and standardized which means redundancy -mina
function byGrade(grade)
	return color(colorConfig:get_data().grades[grade]) or color(colorConfig:get_data().grades["Grade_None"])
end

-- Colorized stuff
function byMSD(x)
	if x then
		return HSV(math.max(95 - (x / 40) * 150, -50), 0.9, 0.9)
	end
	return HSV(0, 0.9, 0.9)
end

function byMusicLength(x)
	if x then
		x = math.min(x, 600)
		return HSV(math.max(95 - (x / 900) * 150, -50), 0.9, 0.9)
	end
	return HSV(0, 0.9, 0.9)
end

function byFileSize(x)
	if x then
		x = math.min(x, 600)
		return HSV(math.max(95 - (x / 1025) * 150, -50), 0.9, 0.9)
	end
	return HSV(0, 0.9, 0.9)
end

-- yes i know i shouldnt hardcode this -mina
function bySkillRange(x)
	if x <= 10 then
		return color("#66ccff")
	elseif x <= 15 then
		return color("#099948")
	elseif x <= 21 then
		return color("#ddaa00")
	elseif x <= 25 then
		return color("#ff6666")
	else
		return color("#c97bff")
	end
end

-- the graph kills itself if this function doesn't exist soooooo i'll just put this
-- also if you attempt to make the colors the same as the byMSD function the graph also kills itself, dunno why and i don't really care
function getMSDColor(MSD)
	if MSD then
		return HSV(math.min(220, math.max(280 - MSD * 11, -40)), 0.5, 1)
	end
	return HSV(0, 0.9, 0.9)
end
