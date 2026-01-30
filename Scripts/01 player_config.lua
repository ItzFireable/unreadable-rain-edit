local defaultGameplayCoordinates = {
	JudgeX = 0,
	JudgeY = -183,
	ComboX = 0,
	ComboY = -135,
	ErrorBarX = 426,
	ErrorBarY = 95,
	TargetTrackerX = 453,
	TargetTrackerY = 270,
	MiniProgressBarX = 426,
	MiniProgressBarY = 86,
	FullProgressBarX = 432,
	FullProgressBarY = 454,
	JudgeCounterX = 227,
	JudgeCounterY = 240,
	DisplayPercentX = 257,
	DisplayPercentY = 179,
	DisplayMeanX = 257,
	DisplayMeanY = 165,
	NPSDisplayX = 182,
	NPSDisplayY = 292,
	NPSGraphX = 0,
	NPSGraphY = 317,
	NotefieldX = 0,
	NotefieldY = 0,
	ProgressBarPos = 1,
	LeaderboardX = 0,
	LeaderboardY = 48,
	ReplayButtonsX = 809,
	ReplayButtonsY = 140,
	LifeP1X = 267,
	LifeP1Y = 226,
	LifeP1Rotation = -90,
	PracticeCDGraphX = 10,
	PracticeCDGraphY = 85,
	BPMTextX = 237,
	BPMTextY = 307,
	MusicRateX = 238,
	MusicRateY = 318
}

local defaultGameplaySizes = {
	JudgeZoom = 0.6,
	ComboZoom = 0.45,
	ErrorBarWidth = 130,
	ErrorBarHeight = 8,
	TargetTrackerZoom = 0.4,
	FullProgressBarWidth = 1,
	FullProgressBarHeight = 1,
	DisplayPercentZoom = 1,
	DisplayMeanZoom = 1,
	NPSDisplayZoom = 0.4,
	NPSGraphWidth = 1,
	NPSGraphHeight = 1,
	NotefieldWidth = 1.05,
	NotefieldHeight = 1.05,
	NotefieldSpacing = 0,
	LeaderboardWidth = 1,
	LeaderboardHeight = 1,
	LeaderboardSpacing = 0,
	ReplayButtonsZoom = 1,
	ReplayButtonsSpacing = 0,
	LifeP1Width = 0.71,
	LifeP1Height = 1.1,
	PracticeCDGraphWidth = 0.8,
	PracticeCDGraphHeight = 1,
	MusicRateZoom = 1,
	BPMTextZoom = 1
}

local defaultConfig = {
	ScreenFilter = 1,
	JudgeType = 1,
	AvgScoreType = 0,
	GhostScoreType = 1,
	DisplayPercent = true,
	DisplayMean = false,
	TargetTracker = false,
	TargetGoal = 93,
	TargetTrackerMode = 0, -- 0: set percent, 1: pb, 2: pb (replay)
	JudgeCounter = true,
	ErrorBar = 1,
	leaderboardEnabled = false,
	PlayerInfo = true,
	FullProgressBar = false,
	MiniProgressBar = true,
	LaneCover = 0, -- soon to be changed to: 0=off, 1=sudden, 2=hidden
	LaneCoverHeight = 10,
	NPSDisplay = true,
	NPSGraph = false,
	CBHighlight = false,
	OneShotMirror = false,
	JudgmentText = true,
	ComboText = false,
	ReceptorSize = 93,
	ErrorBarCount = 30,
	BackgroundType = 2,
	UserName = "",
	PasswordToken = "",
	CustomizeGameplay = false,
	CustomEvaluationWindowTimings = false,
	PracticeMode = false,
	GameplayXYCoordinates = {
		["3K"] = DeepCopy(defaultGameplayCoordinates),
		["4K"] = DeepCopy(defaultGameplayCoordinates),
		["5K"] = DeepCopy(defaultGameplayCoordinates),
		["6K"] = DeepCopy(defaultGameplayCoordinates),
		["7K"] = DeepCopy(defaultGameplayCoordinates),
		["8K"] = DeepCopy(defaultGameplayCoordinates),
		["9K"] = DeepCopy(defaultGameplayCoordinates),
		["10K"] = DeepCopy(defaultGameplayCoordinates),
		["12K"] = DeepCopy(defaultGameplayCoordinates),
		["16K"] = DeepCopy(defaultGameplayCoordinates)
	},
	GameplaySizes = {
		["3K"] = DeepCopy(defaultGameplaySizes),
		["4K"] = DeepCopy(defaultGameplaySizes),
		["5K"] = DeepCopy(defaultGameplaySizes),
		["6K"] = DeepCopy(defaultGameplaySizes),
		["7K"] = DeepCopy(defaultGameplaySizes),
		["8K"] = DeepCopy(defaultGameplaySizes),
		["9K"] = DeepCopy(defaultGameplaySizes),
		["10K"] = DeepCopy(defaultGameplaySizes),
		["12K"] = DeepCopy(defaultGameplaySizes),
		["16K"] = DeepCopy(defaultGameplaySizes)
	}
}

function getDefaultGameplaySize(obj)
	return defaultGameplaySizes[obj]
end

function getDefaultGameplayCoordinate(obj)
	return defaultGameplayCoordinates[obj]
end

-- create the playerConfig global
playerConfig = create_setting("playerConfig", "playerConfig.lua", defaultConfig, -1)

-- shadow settings_mt.load to do several things:
--	load missing values from default
--	load missing values for the current keymode from the 4k config
--	load missing values for the current slot from the global slot
local tmp2 = playerConfig.load
playerConfig.load = function(self, slot)
	-- redefinition of force_table_elements_to_match_type to let settings_system
	-- completely ignore the format of the table if it changed dramatically between versions
	-- this lets us introduce backwards/forwards compatibility
	local tmp = force_table_elements_to_match_type
	force_table_elements_to_match_type = function()
	end

	local x = create_setting("playerConfig", "playerConfig.lua", {}, -1)
	x = x:load(slot)
	local coords = x.GameplayXYCoordinates
	local sizes = x.GameplaySizes
	if sizes and not sizes["4K"] then
		defaultConfig.GameplaySizes["3K"] = sizes
		defaultConfig.GameplaySizes["4K"] = sizes
		defaultConfig.GameplaySizes["5K"] = sizes
		defaultConfig.GameplaySizes["6K"] = sizes
		defaultConfig.GameplaySizes["7K"] = sizes
		defaultConfig.GameplaySizes["8K"] = sizes
		defaultConfig.GameplaySizes["9K"] = sizes
		defaultConfig.GameplaySizes["10K"] = sizes
		defaultConfig.GameplaySizes["12K"] = sizes
		defaultConfig.GameplaySizes["16K"] = sizes
	end
	if coords and not coords["4K"] then
		defaultConfig.GameplayXYCoordinates["3K"] = coords
		defaultConfig.GameplayXYCoordinates["4K"] = coords
		defaultConfig.GameplayXYCoordinates["5K"] = coords
		defaultConfig.GameplayXYCoordinates["6K"] = coords
		defaultConfig.GameplayXYCoordinates["7K"] = coords
		defaultConfig.GameplayXYCoordinates["8K"] = coords
		defaultConfig.GameplayXYCoordinates["9K"] = coords
		defaultConfig.GameplayXYCoordinates["10K"] = coords
		defaultConfig.GameplayXYCoordinates["12K"] = coords
		defaultConfig.GameplayXYCoordinates["16K"] = coords
	end
	force_table_elements_to_match_type = tmp
	return tmp2(self, slot)
end
playerConfig:load()

function LoadProfileCustom(profile, dir)
	local players = GAMESTATE:GetEnabledPlayers()
	local playerProfile
	local pn
	for k, v in pairs(players) do
		playerProfile = PROFILEMAN:GetProfile(v)
		if playerProfile:GetGUID() == profile:GetGUID() then
			pn = v
		end
	end

	if pn then
		local conf = playerConfig:load(pn_to_profile_slot(pn))
	end
end

function SaveProfileCustom(profile, dir)
	local players = GAMESTATE:GetEnabledPlayers()
	local playerProfile
	local pn
	for k, v in pairs(players) do
		playerProfile = PROFILEMAN:GetProfile(v)
		if playerProfile:GetGUID() == profile:GetGUID() then
			pn = v
		end
	end

	if pn then
		playerConfig:set_dirty(pn_to_profile_slot(pn))
		playerConfig:save(pn_to_profile_slot(pn))
	end
end
