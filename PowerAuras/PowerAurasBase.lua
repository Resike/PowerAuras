local _, ns = ...

local getmetatable = getmetatable
local math = math
local pairs = pairs
local print = print
local select = select
local setmetatable = setmetatable
local string = string
local table = table
local tonumber = tonumber
local tostring = tostring
local type = type

local UIErrorsFrame = UIErrorsFrame

local UIERRORS_HOLD_TIME = UIERRORS_HOLD_TIME

local PowaAuras =
{
Version = GetAddOnMetadata("PowerAuras", "Version"),

VersionPattern = "(%d+)%.(%d+)%.(%d+)",

WoWBuild = tonumber(select(4, GetBuildInfo()), 10),

IconSource = "Interface\\Icons\\",

CurrentAuraId = 1,
NextCheck = 0.2,
Tstep = 0.09765625,
NextDebugCheck = 0.0,
InspectTimeOut = 12,
InspectDelay = 2,
ExportMaxSize = 4000,
ExportWidth = 500,
TextureCount = 254,

DebugEvents = false,
--DebugAura = 1,

-- Internal counters
DebugTimer = 0,
ChecksTimer = 0,
ThrottleTimer = 0,
TimerUpdateThrottleTimer = 0,
NextInspectTimeOut = 0,

--[[
-- Profiling
NextProfileCheck = 0,
ProfileTimer = 0,
UpdateCount = 0,
CheckCount = 0,
EffectCount = 0,
AuraCheckCount = 0,
AuraCheckShowCount = 0,
BuffRaidCount = 0,
BuffUnitSetCount = 0,
BuffUnitCount = 0,
BuffSlotCount = 0,
AuraTypeCount = { },
]]--

VariablesLoaded = false,
SetupDone = false,
ModTest = false,
DebugCycle = false,
ResetTargetTimers = false,

ActiveTalentGroup = GetSpecialization(),

WeAreInCombat = false,
WeAreInRaid = false,
WeAreInParty = false,
WeAreMounted = false,
WeAreInVehicle = false,
WeAreInPetBattle = false,
WeAreAlive = true,
PvPFlagSet = false,
Instance = "None",

GroupUnits = { },
GroupNames = { },

Pending = { }, -- Workaround for 'silent' cooldown end (no event fired)
Cascade = { }, -- Dependant auras that need checking

UsedInMultis = { },

PowaStance =
{
	[0] = "Humanoid"
},

PowaGTFO = {[0] = "High Damage", [1] = "Low Damage", [2] = "Fail Alert", [3] = "Friendly Fire"},

allowedOperators =
{
	["="] = true,
	[">"] = true,
	["<"] = true,
	["!"] = true,
	[">="] = true,
	["<="] = true,
	["-"] = true
},

DefaultOperator = ">=",

CurrentAuraPage = 1,

MoveEffect = 0, -- 1 = Copy, 2 = Move

Auras = { },
SecondaryAuras = { },
Frames = { },
SecondaryFrames = { },
Textures = { },
SecondaryTextures = { },

Models = { },
SecondaryModels = { },

TimerFrame = { },
StacksFrames = { },

Sound = { },
BeginAnimDisplay = { },
EndAnimDisplay = { },
Text = { },
Anim = { },

DebuffCatSpells = { },

AoeAuraAdded = { },
AoeAuraFaded = { },
AoeAuraTexture = { },

playerclass = "unknown",

Events = { },
AlwaysEvents =
{
	PLAYER_DIFFICULTY_CHANGED = true,
	ACTIVE_TALENT_GROUP_CHANGED = true,
	CHAT_MSG_ADDON = true,
	INSPECT_TALENT_READY = true,
	PLAYER_ALIVE = true,
	PLAYER_DEAD = true,
	PLAYER_REGEN_DISABLED = true,
	PLAYER_REGEN_ENABLED = true,
	PLAYER_TALENT_UPDATE = true,
	PLAYER_UNGHOST = true,
	PLAYER_UPDATE_RESTING = true,
	GROUP_ROSTER_UPDATE = true,
	UNIT_ENTERED_VEHICLE = true,
	UNIT_EXITED_VEHICLE = true,
	UNIT_FACTION = true,
	UNIT_SPELLCAST_SUCCEEDED = true,
	ZONE_CHANGED_NEW_AREA = true
},

RelativeToParent =
{
	TOPLEFT = "BOTTOMRIGHT",
	TOP = "BOTTOM",
	TOPRIGHT = "BOTTOMLEFT",
	RIGHT = "LEFT",
	BOTTOMRIGHT = "TOPLEFT",
	BOTTOM = "TOP",
	BOTTOMLEFT = "TOPRIGHT",
	LEFT = "RIGHT",
	CENTER = "CENTER"
},

BlendModeList =
{
	"Add",
	"Alphakey",
	"Blend",
	"Disable",
	"Mod"
},

StrataList =
{
	"Background",
	"Low",
	"Medium",
	"High",
	"Dialog",
	"Fullscreen",
	"Fullscreen_Dialog",
	"Tooltip"
},

TextureStrataList =
{
	"Background",
	"Border",
	"Artwork",
	"Overlay"
},

GradientStyleList =
{
	"None",
	"Horizontal",
	"Vertical"
},

ModelCategoryList =
{
	"Creature",
	"Environments",
	"Interface",
	"Spells"
},

ModelTextureList =
{

},

ChangedUnits =
{
	Buffs = { },
	Targets = { }
},

InspectedRoles = { },
FixRoles = { },

Spells =
{
	ACTIVATE_FIRST_TALENT = GetSpellInfo(63645),
	ACTIVATE_SECOND_TALENT = GetSpellInfo(63644),
	--BUFF_BLOOD_PRESENCE = GetSpellInfo(48266),
	--BUFF_FROST_PRESENCE = GetSpellInfo(48263),
	--BUFF_UNHOLY_PRESENCE = GetSpellInfo(48265),
	--TREE_OF_LIFE = GetSpellInfo(65139),
	--SHADOWFORM = GetSpellInfo(15473),
	DRUID_SHIFT_CAT = GetSpellInfo(768),
	DRUID_SHIFT_BEAR = GetSpellInfo(5487),
	--DRUID_SHIFT_DIREBEAR = GetSpellInfo(9634),
	DRUID_SHIFT_MOONKIN = GetSpellInfo(24858)
},

ExtraUnitEvent = { },
CastOnMe = { },
CastByMe = { },

DoCheck =
{
	Buffs = false,
	TargetBuffs = false,
	PartyBuffs = false,
	RaidBuffs = false,
	GroupOrSelfBuffs = false,
	UnitBuffs = false,
	FocusBuffs = false,

	Health = false,
	TargetHealth = false,
	PartyHealth = false,
	RaidHealth = false,
	FocusHealth = false,
	NamedUnitHealth = false,

	Mana = false,
	TargetMana = false,
	PartyMana = false,
	RaidMana = false,
	FocusMana = false,
	NamedUnitMana = false,

	Power = false,
	TargetPower = false,
	PartyPower = false,
	RaidPower = false,
	FocusPower = false,
	UnitPower = false,

	Combo = false,
	Aoe = false,

	Pet = false,

	Stance = false,
	Actions = false,
	Enchants = false,

	All = false,

	PvP = false,
	PartyPvP = false,
	RaidPvP = false,
	TargetPvP = false,

	Aggro = false,
	PartyAggro = false,
	RaidAggro = false,

	Spells = false,
	TargetSpells = false,
	FocusSpells = false,
	PlayerSpells = false,
	PartySpells = false,
	RaidSpells = false,

	SpellCooldowns = false,

	SpellLearned = false,

	Totems = false,
	Runes = false,
	Items = false,
	Slots = false,
	Tracking = false,

	GTFO = false,
	UnitMatch = false,
	PetStance = false,

	-- True if any type should be checked
	CheckIt = false
},

BuffTypes =
{
	Buff = 1,
	Debuff = 2,
	TypeDebuff = 3,
	AoE = 4,
	Enchant = 5,
	Combo = 6,
	ActionReady = 7,
	Health = 8,
	Mana = 9,
	EnergyRagePower = 10,
	Aggro = 11,
	PvP = 12,
	SpellAlert = 13,
	Stance = 14,
	SpellCooldown = 15,
	StealableSpell = 16,
	PurgeableSpell = 17,
	Static = 18,
	Totems = 19,
	Pet = 20,
	Runes = 21,
	Items = 22,
	Slots = 23,
	Tracking = 24,
	TypeBuff = 25,
	UnitMatch = 26,
	PetStance = 27,
	SpellLearned = 28,
	GTFO = 50
},

AnimationBeginTypes =
{
	None = 0,
	ZoomIn = 1,
	ZoomOut = 2,
	FadeIn = 3,
	TranslateLeft = 4,
	TranslateTopLeft = 5,
	TranslateTop = 6,
	TranslateTopRight = 7,
	TranslateRight = 8,
	TranslateBottomRight = 9,
	TranslateBottom = 10,
	TranslateBottomLeft = 11,
	Bounce = 12
},

AnimationEndTypes =
{
	None = 0,
	GrowAndFade = 1,
	ShrinkAndFade = 2,
	Fade = 3,
	SpinAndFade = 4,
	SpinShrinkAndFade = 5
},

AnimationTypes =
{
	Invisible = 0,
	Static = 1,
	Flashing = 2,
	Growing = 3,
	Pulse = 4,
	Bubble = 5,
	WaterDrop = 6,
	Electric = 7,
	Shrinking = 8,
	Flame = 9,
	Orbit = 10,
	SpinClockwise = 11,
	SpinAntiClockwise = 12,
	GrowingInverse = 13,
	ShrinkingInverse = 14
},

-- Aura name -> Auras array
AurasByType = { },

-- Index -> Aura name
AurasByTypeList = { },

DebuffCatType =
{
	CC = 1,
	Silence = 2,
	Snare = 3,
	Root = 4,
	Disarm = 5,
	Stun = 6,
	PvE = 10
},

WowTextures =
{
	-- Auras Types
	"Spells\\AuraRune_B",
	"Spells\\AuraRune256b",
	"Spells\\Circle",
	"Spells\\GENERICGLOW2B",
	"Spells\\GenericGlow2b1",
	"Spells\\ShockRingCrescent256",
	"Spells\\AuraRune1",
	"Spells\\AuraRune5Green",
	"Spells\\AuraRune7",
	"Spells\\AuraRune8",
	"Spells\\AuraRune9",
	"Spells\\AuraRune11",
	"Spells\\AuraRune_A",
	"Spells\\AuraRune_C",
	"Spells\\AuraRune_D",
	"Spells\\Holy_Rune1",
	"Spells\\Rune1d_GLOWless",
	"Spells\\Rune4blue",
	"Spells\\RuneBC1",
	"Spells\\RuneBC2",
	"Spells\\RUNEFROST",
	"Spells\\Holy_Rune_128",
	"Spells\\Nature_Rune_128",
	"Spells\\Death_Rune",
	"Spells\\DemonRune6",
	"Spells\\DemonRune7",
	"Spells\\DemonRune5backup",
	-- Icon Types
	"Particles\\Intellect128_outline",
	"Spells\\Intellect_128",
	"Spells\\GHOST1",
	"Spells\\Aspect_Beast",
	"Spells\\Aspect_Hawk",
	"Spells\\Aspect_Wolf",
	"Spells\\Aspect_Snake",
	"Spells\\Aspect_Cheetah",
	"Spells\\Aspect_Monkey",
	"Spells\\Blobs",
	"Spells\\Blobs2",
	"Spells\\GradientCrescent2",
	"Spells\\InnerFire_Rune_128",
	"Spells\\RapidFire_Rune_128",
	"Spells\\Protect_128",
	"Spells\\Reticle_128",
	"Spells\\Star2A",
	"Spells\\Star4",
	"Spells\\Strength_128",
	"Particles\\STUNWHIRL",
	"Spells\\BloodSplash1",
	"Spells\\DarkSummon",
	"Spells\\EndlessRage",
	"Spells\\Rampage",
	"Spells\\Eye",
	"Spells\\Eyes",
	"Spells\\Zap1b",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-1",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-2",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-3",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-4",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-5",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-6",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-7",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-8",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-9",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-10",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-11",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-12",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-13",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-14",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-15",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-16",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-17",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-18",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-19",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-20",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-21",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-22",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-23",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-24",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-25",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-26",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-27",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-28",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-29",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-30",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-31",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-32",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-33",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-34",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-35",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-36",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-37",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-38",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-39",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-40",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-41",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-42",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-43",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-44",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-45",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-46",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-47",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-48",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-49",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-50",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-51",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-52",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-53",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-54",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-55",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-56",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-57",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-58",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-59",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-60",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-61",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-62",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-63",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-64",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-65",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-66",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-67",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-68",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-69",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-70",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-71",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-72",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-73",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-74",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-75",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-76",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-77",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-78",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-79",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-80",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-81",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-82",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-83",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-84",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-85",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-86",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-87",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-88",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-89",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-90",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-91",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-92",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-93",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-94",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-95",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-96",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-97",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-98",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-99",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-100",
	"Interface\\PVPFrame\\Icons\\PVP-Banner-Emblem-101",
	"Interface\\Spellbook\\UI-Glyph-Rune1",
	"Interface\\Spellbook\\UI-Glyph-Rune-1",
	"Interface\\Spellbook\\UI-Glyph-Rune-2",
	"Interface\\Spellbook\\UI-Glyph-Rune-3",
	"Interface\\Spellbook\\UI-Glyph-Rune-4",
	"Interface\\Spellbook\\UI-Glyph-Rune-5",
	"Interface\\Spellbook\\UI-Glyph-Rune-6",
	"Interface\\Spellbook\\UI-Glyph-Rune-7",
	"Interface\\Spellbook\\UI-Glyph-Rune-8",
	"Interface\\Spellbook\\UI-Glyph-Rune-9",
	"Interface\\Spellbook\\UI-Glyph-Rune-10",
	"Interface\\Spellbook\\UI-Glyph-Rune-11",
	"Interface\\Spellbook\\UI-Glyph-Rune-12",
	"Interface\\Spellbook\\UI-Glyph-Rune-13",
	"Interface\\Spellbook\\UI-Glyph-Rune-14",
	"Interface\\Spellbook\\UI-Glyph-Rune-15",
	"Interface\\Spellbook\\UI-Glyph-Rune-16",
	"Interface\\Spellbook\\UI-Glyph-Rune-17",
	"Interface\\Spellbook\\UI-Glyph-Rune-18",
	"Interface\\Spellbook\\UI-Glyph-Rune-19",
	"Interface\\Spellbook\\UI-Glyph-Rune-20"
},

Fonts =
{
	-- Wow Fonts
	STANDARD_TEXT_FONT, -- "Fonts\\FRIZQT__.ttf"
	"Fonts\\ARIALN.ttf",
	"Fonts\\skurri.ttf",
	-- External Fonts
	"Interface\\Addons\\PowerAuras\\Fonts\\AllStar.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Army.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Army Condensed.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Army Expanded.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Blazed.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Blox.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Cloister Black.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Diediedie.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Hexagon.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Moonstar.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Morpheus.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Neon.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Pulse Virgin.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Punks Not Dead.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Starcraft.ttf",
	"Interface\\Addons\\PowerAuras\\Fonts\\Whoa.ttf"
},

Sound =
{
	-- Blizzard Sounds
	[1] = {"AuctionWindowClose", 5275},
	[2] = {"AuctionWindowOpen", 5274},
	[3] = {"Fishing Reel in", 3407},
	[4] = {"GAMEDIALOGOPEN", 88},
	[5] = {"GAMEDIALOGCLOSE", 89},
	[6] = {"HumanExploration", 4140},
	[7] = {"igAbilityOpen", 834},
	[8] = {"igAbilityClose", 835},
	[9] = {"igBackPackOpen", 862},
	[10] = {"igBackPackClose", 863},
	[11] = {"igInventoryOpen", 859},
	[12] = {"igInventoryClose", 860},
	[13] = {"igMainMenuOpen", 850},
	[14] = {"igMainMenuClose", 851},
	[15] = {"igMiniMapOpen", 821},
	[16] = {"igMiniMapClose", 822},
	[17] = {"igPlayerInvite", 880},
	[18] = {"igPVPUpdate", 4574},
	[19] = {"LEVELUP", 888},
	[20] = {"LOOTWINDOWCOINSOUND", 120},
	[21] = {"MapPing", 3175},
	[22] = {"PVPENTERQUEUE", 8458},
	[23] = {"PVPTHROUGHQUEUE", 8459},
	[24] = {"QUESTADDED", 618},
	[25] = {"QUESTCOMPLETED", 619},
	[26] = {"RaidWarning", 8959},
	[27] = {"ReadyCheck", 8960},
	[28] = {"TalentScreenOpen", 6144},
	[29] = {"TalentScreenClose", 6145},
},

SoundCustom =
{
	-- Second Tab
	-- Custom Sounds
	[31] = {"Aggro.mp3"},
	[32] = {"Arrow Swoosh.mp3"},
	[33] = {"Bam.mp3"},
	[34] = {"Bear Polar.mp3"},
	[35] = {"Big Kiss.mp3"},
	[36] = {"Bite.mp3"},
	[37] = {"Bloodbath.mp3"},
	[38] = {"Burp.mp3"},
	[39] = {"Cat.mp3"},
	[40] = {"Chant1.mp3"},
	[41] = {"Chant2.mp3"},
	[42] = {"Chimes.mp3"},
	[43] = {"Cookie.mp3"},
	[44] = {"Espark.mp3"},
	[45] = {"Fireball.mp3"},
	[46] = {"Gasp.mp3"},
	[47] = {"Heartbeat.mp3"},
	[48] = {"Hic.mp3"},
	[49] = {"Huh.mp3"},
	[50] = {"Hurricane.mp3"},
	[51] = {"Hyena.mp3"},
	[52] = {"Kaching.mp3"},
	[53] = {"Moan.mp3"},
	[54] = {"Panther.mp3"},
	[55] = {"Phone.mp3"},
	[56] = {"Punch.mp3"},
	[57] = {"Rainroof.mp3"},
	[58] = {"Rocket.mp3"},
	[59] = {"Ship Horn.mp3"},
	[60] = {"Shot.mp3"},
	[61] = {"Snake.mp3"},
	[62] = {"Sneeze.mp3"},
	[63] = {"Sonar.mp3"},
	[64] = {"Splash.mp3"},
	[65] = {"Squeaky.mp3"},
	[66] = {"Sword.mp3"},
	[67] = {"Throw.mp3"},
	[68] = {"Thunder.mp3"},
	[69] = {"Vengeance.mp3"},
	[70] = {"Warpath.mp3"},
	[71] = {"Wicked Laugh Female.mp3"},
	[72] = {"Wicked Laugh Male.mp3"},
	[73] = {"Wilhelm.mp3"},
	[74] = {"Wolf.mp3"},
	[75] = {"Yeehaw.mp3"},
	[76] = {"Health Low.mp3"},
	[77] = {"Mana Low.mp3"},
},

TimerTextures =
{
	"Default",
	"Original",
	"AccidentalPresidency",
	"Crystal",
	"Digital",
	"Monofonto",
	"OCR",
	"WhiteRabbit"
},

-- Colors used in messages
Colors =
{
	["Blue"] = "|cff6666ff",
	["Grey"] = "|cff999999",
	["Green"] = "|cff66cc33",
	["Red"] = "|cffff2020",
	["Yellow"] = "|cffffff40",
	["BGrey"] = "|c00D0D0D0",
	["White"] = "|c00FFFFFF",
	["Orange"] = "|cffff9930",
	["Purple"] = "|cffB0A0ff",
	["Gold"] = "|cffffff00"
},

SetColors =
{
	["PowaTargetButton"] = {r = 1.0, g = 0.2, b = 0.2},
	["PowaTargetFriendButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaPartyButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaGroupOrSelfButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaFocusButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaRaidButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaOptunitnButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaGroupAnyButton"] = {r = 0.2, g = 1.0, b = 0.2},
	["PowaOwntexButton"] = {r = 0.5, g = 0.8, b = 0.9},
	["PowaRoundIconsButton"] = {r = 0.5, g = 0.8, b = 0.9}
},

OptionCheckBoxes =
{
	"PowaTargetButton",
	"PowaPartyButton",
	"PowaGroupOrSelfButton",
	"PowaRaidButton",
	"PowaIngoreCaseButton",
	"PowaOwntexButton",
	"PowaInverseButton",
	"PowaFocusButton",
	"PowaOptunitnButton",
	"PowaGroupAnyButton",
	"PowaRoleTankButton",
	"PowaRoleHealerButton",
	"PowaRoleMeleDpsButton",
	"PowaRoleRangeDpsButton"
},

OptionTernary = { },

OptionHideables =
{
	"PowaGroupAnyButton",
	"PowaBarTooltipCheck",
	"PowaBarThresholdSlider",
	"PowaThresholdInvertButton",
	"PowaBarBuffStacks",
	"PowaDropDownStance",
	"PowaDropDownGTFO",
	"PowaDropDownPowerType"
},

Backdrop =
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	insets = {left = 0, top = 0, right = 0, bottom = 0},
	tile = true
},
}

function PowaAuras:RegisterAuraType(auraType)
	self.AurasByType[auraType] = { }
	table.insert(self.AurasByTypeList, auraType)
end

PowaAuras:RegisterAuraType('Buffs')
PowaAuras:RegisterAuraType('TargetBuffs')
PowaAuras:RegisterAuraType('PartyBuffs')
PowaAuras:RegisterAuraType('RaidBuffs')
PowaAuras:RegisterAuraType('GroupOrSelfBuffs')
PowaAuras:RegisterAuraType('UnitBuffs')
PowaAuras:RegisterAuraType('FocusBuffs')

PowaAuras:RegisterAuraType('Health')
PowaAuras:RegisterAuraType('TargetHealth')
PowaAuras:RegisterAuraType('FocusHealth')
PowaAuras:RegisterAuraType('PartyHealth')
PowaAuras:RegisterAuraType('RaidHealth')
PowaAuras:RegisterAuraType('NamedUnitHealth')

PowaAuras:RegisterAuraType('Mana')
PowaAuras:RegisterAuraType('TargetMana')
PowaAuras:RegisterAuraType('FocusMana')
PowaAuras:RegisterAuraType('PartyMana')
PowaAuras:RegisterAuraType('RaidMana')
PowaAuras:RegisterAuraType('NamedUnitMana')

PowaAuras:RegisterAuraType('Power')
PowaAuras:RegisterAuraType('TargetPower')
PowaAuras:RegisterAuraType('PartyPower')
PowaAuras:RegisterAuraType('RaidPower')
PowaAuras:RegisterAuraType('FocusPower')
PowaAuras:RegisterAuraType('NamedUnitPower')

PowaAuras:RegisterAuraType('Combo')
PowaAuras:RegisterAuraType('Aoe')

PowaAuras:RegisterAuraType('Stance')
PowaAuras:RegisterAuraType('Actions')
PowaAuras:RegisterAuraType('Enchants')

PowaAuras:RegisterAuraType('PvP')
PowaAuras:RegisterAuraType('PartyPvP')
PowaAuras:RegisterAuraType('RaidPvP')
PowaAuras:RegisterAuraType('TargetPvP')

PowaAuras:RegisterAuraType('Aggro')
PowaAuras:RegisterAuraType('PartyAggro')
PowaAuras:RegisterAuraType('RaidAggro')

PowaAuras:RegisterAuraType('Spells')
PowaAuras:RegisterAuraType('TargetSpells')
PowaAuras:RegisterAuraType('FocusSpells')
PowaAuras:RegisterAuraType('PlayerSpells')
PowaAuras:RegisterAuraType('PartySpells')
PowaAuras:RegisterAuraType('RaidSpells')
PowaAuras:RegisterAuraType('GroupOrSelfSpells')

PowaAuras:RegisterAuraType('StealableSpells')
PowaAuras:RegisterAuraType('StealableTargetSpells')
PowaAuras:RegisterAuraType('StealableFocusSpells')

PowaAuras:RegisterAuraType('PurgeableSpells')
PowaAuras:RegisterAuraType('PurgeableTargetSpells')
PowaAuras:RegisterAuraType('PurgeableFocusSpells')

PowaAuras:RegisterAuraType('SpellCooldowns')

PowaAuras:RegisterAuraType('SpellLearned')

PowaAuras:RegisterAuraType('Static')

PowaAuras:RegisterAuraType('Totems')
PowaAuras:RegisterAuraType('Pet')
PowaAuras:RegisterAuraType('Runes')
PowaAuras:RegisterAuraType('Slots')
PowaAuras:RegisterAuraType('Items')
PowaAuras:RegisterAuraType('Tracking')

PowaAuras:RegisterAuraType('UnitMatch')
PowaAuras:RegisterAuraType("PetStance")

PowaAuras:RegisterAuraType('GTFOHigh')
PowaAuras:RegisterAuraType('GTFOLow')
PowaAuras:RegisterAuraType('GTFOFail')
PowaAuras:RegisterAuraType('GTFOFriendlyFire')

-- Use these spells to detect GCD, ideally these should be spells classes have from the beginning
--[[PowaAuras.GCDSpells =
{
	PALADIN = 19750, -- Flash of Light
	PRIEST = 1706, -- Levitate
	SHAMAN = 6196, -- Far Sight
	WARRIOR = 34428, -- Victory Rush
	DRUID = 339, -- Entangling Roots
	MAGE = 130, -- Slow Fall
	WARLOCK = 6201, -- Create Healthstone
	ROGUE = 1833, -- Cheap Shot
	HUNTER = 982, -- Revive Pet
	DEATHKNIGHT = 3714, -- Path of Frost
	MONK = 100780, -- Tiger Palm
	DEMONHUNTER = 162243 -- Demon's Bite (Havoc) 203782 -- Shear (Vengeance)
}]]

-- Invented so we can distinquish them two types
--SPELL_POWER_LUNAR_ECLIPSE = 108
--SPELL_POWER_SOLAR_ECLIPSE = 208

PowaAuras.PowerRanges =
{
	[-1] = 100,
	[SPELL_POWER_MANA] = 100,
	[SPELL_POWER_RAGE] = 100,
	[SPELL_POWER_FOCUS] = 100,
	[SPELL_POWER_ENERGY] = 100,
	[SPELL_POWER_RUNES] = 100,
	[SPELL_POWER_RUNIC_POWER] = 100,
	[SPELL_POWER_SOUL_SHARDS] = 5,
	--[SPELL_POWER_LUNAR_ECLIPSE] = 100,
	--[SPELL_POWER_SOLAR_ECLIPSE] = 100,
	[SPELL_POWER_LUNAR_POWER] = 100,
	--[SPELL_POWER_DEMONIC_FURY] = 1000,
	[SPELL_POWER_HOLY_POWER] = 5,
	[SPELL_POWER_ALTERNATE_POWER] = 100,
	--[SPELL_POWER_DARK_FORCE] = 5,
	[SPELL_POWER_CHI] = 6,
	--[SPELL_POWER_SHADOW_ORBS] = 5,
	[SPELL_POWER_INSANITY] = 100,
	[SPELL_POWER_MAELSTROM] = 150,
	[SPELL_POWER_FURY] = 130,
	[SPELL_POWER_PAIN] = 100,
	[SPELL_POWER_ARCANE_CHARGES] = 4,
	--[SPELL_POWER_BURNING_EMBERS] = 4,
}

PowaAuras.RangeType =
{
	[-1] = "%",
	[SPELL_POWER_MANA] = "%",
	[SPELL_POWER_RAGE] = "%",
	[SPELL_POWER_FOCUS] = "%",
	[SPELL_POWER_ENERGY] = "%",
	[SPELL_POWER_RUNES] = "%",
	[SPELL_POWER_RUNIC_POWER] = "%",
	[SPELL_POWER_SOUL_SHARDS] = "",
	--[SPELL_POWER_LUNAR_ECLIPSE] = "%",
	--[SPELL_POWER_SOLAR_ECLIPSE] = "%",
	[SPELL_POWER_LUNAR_POWER] = "",
	--[SPELL_POWER_DEMONIC_FURY] = "",
	[SPELL_POWER_HOLY_POWER] = "",
	[SPELL_POWER_ALTERNATE_POWER] = "",
	--[SPELL_POWER_DARK_FORCE] = "",
	[SPELL_POWER_CHI] = "",
	--[SPELL_POWER_SHADOW_ORBS] = "",
	[SPELL_POWER_INSANITY] = "",
	[SPELL_POWER_MAELSTROM] = "",
	[SPELL_POWER_FURY] = "",
	[SPELL_POWER_PAIN] = "",
	[SPELL_POWER_ARCANE_CHARGES] = "",
	--[SPELL_POWER_BURNING_EMBERS] = ""
}

PowaAuras.PowerTypeIcon =
{
	[-1] = "inv_battery_02",
	[SPELL_POWER_MANA] = "inv_elemental_primal_mana",
	[SPELL_POWER_RAGE] = "ability_warrior_rampage",
	[SPELL_POWER_FOCUS] = "ability_hunter_mastermarksman",
	[SPELL_POWER_ENERGY] = "inv_battery_02",
	[SPELL_POWER_RUNES] = "spell_deathknight_runetap",
	[SPELL_POWER_RUNIC_POWER] = "spell_arcane_arcane01",
	[SPELL_POWER_SOUL_SHARDS] = "inv_misc_gem_amethyst_02",
	--[SPELL_POWER_LUNAR_ECLIPSE] = "ability_druid_eclipse",
	--[SPELL_POWER_SOLAR_ECLIPSE] = "ability_druid_eclipseorange",
	[SPELL_POWER_LUNAR_POWER] = "ability_druid_eclipse",
	--[SPELL_POWER_DEMONIC_FURY] = "ability_warlock_eradication",
	[SPELL_POWER_HOLY_POWER] = "spell_holy_lightsgrace",
	[SPELL_POWER_ALTERNATE_POWER] = "inv_battery_02",
	--[SPELL_POWER_DARK_FORCE] = "spell_arcane_arcanetorrent",
	[SPELL_POWER_CHI] = "class_monk",
	--[SPELL_POWER_SHADOW_ORBS] = "spell_priest_shadoworbs",
	[SPELL_POWER_INSANITY] = "spell_priest_shadoworbs",
	[SPELL_POWER_MAELSTROM] = "spell_shaman_maelstromweapon",
	[SPELL_POWER_FURY] = "spell_shadow_shadowfury",
	[SPELL_POWER_PAIN] = "artifactability_vengeancedemonHunter_painbringer",
	[SPELL_POWER_ARCANE_CHARGES] = "spell_arcane_arcane04",
	--[SPELL_POWER_BURNING_EMBERS] = "ability_warlock_burningembers",
}

PowaAuras.TalentChangeSpells =
{
	[PowaAuras.Spells.ACTIVATE_FIRST_TALENT] = true,
	[PowaAuras.Spells.ACTIVATE_SECOND_TALENT] = true
	--[PowaAuras.Spells.BUFF_FROST_PRESENCE] = true,
	--[PowaAuras.Spells.BUFF_BLOOD_PRESENCE] = true,
	--[PowaAuras.Spells.BUFF_UNHOLY_PRESENCE] = true
}

PowaAuras.DebuffTypeSpellIds =
{
	-- Death Knight
	[108194]	= PowaAuras.DebuffCatType.Stun,		-- Asphyxiate
	[115001]	= PowaAuras.DebuffCatType.Stun,		-- Remorseless Winter
	[47476]		= PowaAuras.DebuffCatType.Silence,	-- Strangulate
	[96294]		= PowaAuras.DebuffCatType.Root,		-- Chains of Ice (Chilblains)
	[45524]		= PowaAuras.DebuffCatType.Snare,	-- Chains of Ice
	[50435]		= PowaAuras.DebuffCatType.Snare,	-- Chillblains
	-- Death Knight Pets
	[91800]		= PowaAuras.DebuffCatType.Stun,		-- Gnaw (Ghoul)
	[91797]		= PowaAuras.DebuffCatType.Stun,		-- Monstrous Blow (Dark Transformation Ghoul)
	[91807]		= PowaAuras.DebuffCatType.Root,		-- Shambling Rush (Ghoul)
	-- Druid
	[99]		= PowaAuras.DebuffCatType.CC,		-- Disorienting Roar
	[33786]		= PowaAuras.DebuffCatType.CC,		-- Cyclone
	[2637]		= PowaAuras.DebuffCatType.CC,		-- Hibernate
	[113004]	= PowaAuras.DebuffCatType.CC,		-- Intimidating Roar (Symbiosis Main target)
	[113056]	= PowaAuras.DebuffCatType.CC,		-- Intimidating Roar (Symbiosis Secondary targets)
	[5211]		= PowaAuras.DebuffCatType.Stun,		-- Mighty Bash
	[22570]		= PowaAuras.DebuffCatType.Stun,		-- Maim
	[9005]		= PowaAuras.DebuffCatType.Stun,		-- Pounce
	[102546]	= PowaAuras.DebuffCatType.Stun,		-- Pounce (Incarnation)
	[110698]	= PowaAuras.DebuffCatType.Stun,		-- Hammer of Justice (Symbiosis)
	[126451]	= PowaAuras.DebuffCatType.Stun,		-- Clash (Symbiosis)
	[81261]		= PowaAuras.DebuffCatType.Silence,	-- Solar Beam
	[114238]	= PowaAuras.DebuffCatType.Silence,	-- Fae Silence (Gylphed)
	[126458]	= PowaAuras.DebuffCatType.Disarm,	-- Grapple Weapon (Symbiosis)
	[110693]	= PowaAuras.DebuffCatType.Root,		-- Frost Nova (Symbiosis)
	[339]		= PowaAuras.DebuffCatType.Root,		-- Entangling Roots
	[19975]		= PowaAuras.DebuffCatType.Root,		-- Entangling Roots (Nature's Grasp)
	[113770]	= PowaAuras.DebuffCatType.Root,		-- Entangling Roots (Force of Nature)
	[102359]	= PowaAuras.DebuffCatType.Root,		-- Mass Entanglement
	[45334]		= PowaAuras.DebuffCatType.Root,		-- Wild Charge (Bear)
	[50259]		= PowaAuras.DebuffCatType.Snare,	-- Wild Charge (Cat)
	[127797]	= PowaAuras.DebuffCatType.Snare,	-- Ursol's Vortex
	[58180]		= PowaAuras.DebuffCatType.Snare,	-- Infected Wounds
	[61391]		= PowaAuras.DebuffCatType.Snare,	-- Typhoon (Daze)
	[81281]		= PowaAuras.DebuffCatType.Snare,	-- Fungal Growth
	[102355]	= PowaAuras.DebuffCatType.Snare,	-- Faerie Swarm
	-- Druid Pets
	[113801]	= PowaAuras.DebuffCatType.Stun,		-- Bash (Treants)
	-- Hunter
	[3355]		= PowaAuras.DebuffCatType.CC,		-- Freezing Trap
	[1513]		= PowaAuras.DebuffCatType.CC,		-- Scare Beast
	[19503]		= PowaAuras.DebuffCatType.CC,		-- Scatter Shot
	[19386]		= PowaAuras.DebuffCatType.CC,		-- Wyvern Sting
	[117526]	= PowaAuras.DebuffCatType.Stun,		-- Binding Shot
	[24394]		= PowaAuras.DebuffCatType.Stun,		-- Intimidation
	[34490]		= PowaAuras.DebuffCatType.Silence,	-- Silencing Shot
	[136634]	= PowaAuras.DebuffCatType.Root,		-- Narrow Escape
	[64803]		= PowaAuras.DebuffCatType.Root,		-- Entrapment
	[121414]	= PowaAuras.DebuffCatType.Snare,	-- Graive Toss
	[135299]	= PowaAuras.DebuffCatType.Snare,	-- Ice Trap
	[35101]		= PowaAuras.DebuffCatType.Snare,	-- Concussive Barrage
	[5116]		= PowaAuras.DebuffCatType.Snare,	-- Concussive Shot
	[61394]		= PowaAuras.DebuffCatType.Snare,	-- Frozen Wake (Glyphed)
	-- Hunter Pets
	[90337]		= PowaAuras.DebuffCatType.CC,		-- Bad Manner (Monkey)
	[126246]	= PowaAuras.DebuffCatType.CC,		-- Lullaby (Crane)
	[126355]	= PowaAuras.DebuffCatType.CC,		-- Paralyzing Quill (Porcupine)
	[126423]	= PowaAuras.DebuffCatType.CC,		-- Petrifying Gaze (Basilisk)
	[56626]		= PowaAuras.DebuffCatType.Stun,		-- Sting (Wasp)
	[50519]		= PowaAuras.DebuffCatType.Stun,		-- Sonic Blast (Bat)
	[96201]		= PowaAuras.DebuffCatType.Stun,		-- Web Wrap (Shale Spider)
	[91644]		= PowaAuras.DebuffCatType.Disarm,	-- Snatch (Bird of Prey)
	[50541]		= PowaAuras.DebuffCatType.Disarm,	-- Clench (Scorpid)
	[50245]		= PowaAuras.DebuffCatType.Root,		-- Pin (Crab)
	[4167]		= PowaAuras.DebuffCatType.Root,		-- Web (Spider)
	[54706]		= PowaAuras.DebuffCatType.Root,		-- Venom Web Spray (Silithid)
	[90327]		= PowaAuras.DebuffCatType.Root,		-- Lock Jaw (Dog)
	[61685]		= PowaAuras.DebuffCatType.Root,		-- Charge (Various)
	[54644]		= PowaAuras.DebuffCatType.Snare,	-- Froststorm Breath (Chimera)
	[50433]		= PowaAuras.DebuffCatType.Snare,	-- Ankle Crack (Crocolisk)
	[35346]		= PowaAuras.DebuffCatType.Snare,	-- Time Warp (Warp Stalker)
	-- Mage
	[118]		= PowaAuras.DebuffCatType.CC,		-- Polymorph
	[31661]		= PowaAuras.DebuffCatType.CC,		-- Dragon's Breath
	[82691]		= PowaAuras.DebuffCatType.CC,		-- Ring of Frost
	[118271]	= PowaAuras.DebuffCatType.Stun,		-- Combustion
	[44572]		= PowaAuras.DebuffCatType.Stun,		-- Deep Freeze
	[102051]	= PowaAuras.DebuffCatType.Silence,	-- Frostjaw
	[55021]		= PowaAuras.DebuffCatType.Silence,	-- Silenced - Improved Counterspell
	[122]		= PowaAuras.DebuffCatType.Root,		-- Frost Nova
	[111340]	= PowaAuras.DebuffCatType.Root,		-- Ice Ward
	[113092]	= PowaAuras.DebuffCatType.Snare,	-- Frost Bomb
	[12486]		= PowaAuras.DebuffCatType.Snare,	-- Chilled (Blizzard)
	[7321]		= PowaAuras.DebuffCatType.Snare,	-- Chilled (Frost Armor)
	[120]		= PowaAuras.DebuffCatType.Snare,	-- Cone of Cold
	[116]		= PowaAuras.DebuffCatType.Snare,	-- Frostbolt
	[44614]		= PowaAuras.DebuffCatType.Snare,	-- Frostfire Bolt
	[84721]		= PowaAuras.DebuffCatType.Snare,	-- Frozen Orb
	[31589]		= PowaAuras.DebuffCatType.Snare,	-- Slow
	-- Mage Pets
	[33395]		= PowaAuras.DebuffCatType.Root,		-- Freeze (Water Elemental)
	-- Monk
	[115078]	= PowaAuras.DebuffCatType.CC,		-- Paralysis
	[123393]	= PowaAuras.DebuffCatType.CC,		-- Breath of Fire (Glyphed)
	[107079]	= PowaAuras.DebuffCatType.CC,		-- Quaking Palm
	[120086]	= PowaAuras.DebuffCatType.Stun,		-- Fist of Fury
	[119381]	= PowaAuras.DebuffCatType.Stun,		-- Leg Sweep
	[119392]	= PowaAuras.DebuffCatType.Stun,		-- Charging Ox Wave
	[122242]	= PowaAuras.DebuffCatType.Stun,		-- Clash
	[102795]	= PowaAuras.DebuffCatType.Stun,		-- Bear Hug (Symbiosis)
	[137460]	= PowaAuras.DebuffCatType.Silence,	-- Ring of Peace (Silence)
	[116709]	= PowaAuras.DebuffCatType.Silence,	-- Spear Hand Strike
	[137461]	= PowaAuras.DebuffCatType.Disarm,	-- Ring of Peace (Disarm)
	[117368]	= PowaAuras.DebuffCatType.Disarm,	-- Grapple Weapon
	[116706]	= PowaAuras.DebuffCatType.Root,		-- Disable
	[113275]	= PowaAuras.DebuffCatType.Root,		-- Entangling Roots (Symbiosis)
	[123407]	= PowaAuras.DebuffCatType.Root,		-- Spinning Fire Blossom
	[116095]	= PowaAuras.DebuffCatType.Snare,	-- Disable (Snare)
	[116330]	= PowaAuras.DebuffCatType.Snare,	-- Dizzying Haze
	[118585]	= PowaAuras.DebuffCatType.Snare,	-- Leer of the Ox
	[123586]	= PowaAuras.DebuffCatType.Snare,	-- Flying Serpent Kick
	-- Paladin
	[20066]		= PowaAuras.DebuffCatType.CC,		-- Repentance
	[10326]		= PowaAuras.DebuffCatType.CC,		-- Turn Evil
	[145067]	= PowaAuras.DebuffCatType.CC,		-- Turn Evil (Evil is a Point of View)
	[105421]	= PowaAuras.DebuffCatType.CC,		-- Blinding Light
	[115752]	= PowaAuras.DebuffCatType.Stun,		-- Blinding Light (Glyphed)
	[853]		= PowaAuras.DebuffCatType.Stun,		-- Hammer of Justice
	[105593]	= PowaAuras.DebuffCatType.Stun,		-- Fist of Justice
	[119072]	= PowaAuras.DebuffCatType.Stun,		-- Holy Wrath
	[31935]		= PowaAuras.DebuffCatType.Silence,	-- Avenger's Shield
	[63529]		= PowaAuras.DebuffCatType.Snare,	-- Dazed - Avenger's Shield
	[20170]		= PowaAuras.DebuffCatType.Snare,	-- Seal of Justice
	[110300]	= PowaAuras.DebuffCatType.Snare,	-- Burden of Guilt
	[114919]	= PowaAuras.DebuffCatType.Snare,	-- Arcing Light
	-- Priest
	[605]		= PowaAuras.DebuffCatType.CC,		-- Dominate Mind
	[64044]		= PowaAuras.DebuffCatType.CC,		-- Psychic Horror
	[8122]		= PowaAuras.DebuffCatType.CC,		-- Psychic Scream
	[88625]		= PowaAuras.DebuffCatType.CC,		-- Holy Word: Chastise
	[9484]		= PowaAuras.DebuffCatType.CC,		-- Shackle Undead
	[113506]	= PowaAuras.DebuffCatType.CC,		-- Cyclone (Symbiosis)
	[15487]		= PowaAuras.DebuffCatType.Silence,	-- Silence
	[64058]		= PowaAuras.DebuffCatType.Disarm,	-- Psychic Horror (Disarm)
	[87194]		= PowaAuras.DebuffCatType.Root,		-- Mind Blast (Glyphed)
	[114404]	= PowaAuras.DebuffCatType.Root,		-- Void Tendrils
	[15407]		= PowaAuras.DebuffCatType.Snare,	-- Mind Flay
	-- Priest Pets
	[113792]	= PowaAuras.DebuffCatType.CC,		-- Psychic Terror (Psyfiend)
	-- Rogue
	[2094]		= PowaAuras.DebuffCatType.CC,		-- Blind
	[1776]		= PowaAuras.DebuffCatType.CC,		-- Gouge
	[6770]		= PowaAuras.DebuffCatType.CC,		-- Sap
	[1833]		= PowaAuras.DebuffCatType.Stun,		-- Cheap Shot
	[408]		= PowaAuras.DebuffCatType.Stun,		-- Kidney Shot
	[113953]	= PowaAuras.DebuffCatType.Stun,		-- Paralysis
	[1330]		= PowaAuras.DebuffCatType.Silence,	-- Garrote
	[51722]		= PowaAuras.DebuffCatType.Disarm,	-- Dismantle
	[115197]	= PowaAuras.DebuffCatType.Root,		-- Partial Paralysis
	[3409]		= PowaAuras.DebuffCatType.Snare,	-- Crippling Poison
	[26679]		= PowaAuras.DebuffCatType.Snare,	-- Deadly Throw
	-- Shaman
	[51514]		= PowaAuras.DebuffCatType.CC,		-- Hex
	[77505]		= PowaAuras.DebuffCatType.Stun,		-- Earthquake
	[118905]	= PowaAuras.DebuffCatType.Stun,		-- Static Charge
	[81261]		= PowaAuras.DebuffCatType.Silence,	-- Solar Beam (Symbiosis)
	[64695]		= PowaAuras.DebuffCatType.Root,		-- Earthgrab
	[63685]		= PowaAuras.DebuffCatType.Root,		-- Freeze
	[3600]		= PowaAuras.DebuffCatType.Snare,	-- Earthbind
	[8056]		= PowaAuras.DebuffCatType.Snare,	-- Frost Shock
	[8034]		= PowaAuras.DebuffCatType.Snare,	-- Frostbrand Attack
	-- Shaman Pets
	[118345]	= PowaAuras.DebuffCatType.Stun,		-- Pulverize (Primal Earth Elemental)
	-- Warlock
	[710]		= PowaAuras.DebuffCatType.CC,		-- Banish
	[118699]	= PowaAuras.DebuffCatType.CC,		-- Fear
	[5484]		= PowaAuras.DebuffCatType.CC,		-- Howl of Terror
	[137143]	= PowaAuras.DebuffCatType.CC,		-- Blood Horror
	[6789]		= PowaAuras.DebuffCatType.CC,		-- Mortal Coil
	[30283]		= PowaAuras.DebuffCatType.Stun,		-- Shadowfury
	[22703]		= PowaAuras.DebuffCatType.Stun,		-- Summon Infernal
	[47897]		= PowaAuras.DebuffCatType.Snare,	-- Demonic Breath
	[18223]		= PowaAuras.DebuffCatType.Snare,	-- Curse of Exhaustion
	[60947]		= PowaAuras.DebuffCatType.Snare,	-- Improved Fear
	-- Warlock Pets
	[115268]	= PowaAuras.DebuffCatType.CC,		-- Mesmerize (Shivarra)
	[6358]		= PowaAuras.DebuffCatType.CC,		-- Seduction (Succubus)
	[89766]		= PowaAuras.DebuffCatType.Stun,		-- Axe Toss (Felguard)
	[24259]		= PowaAuras.DebuffCatType.Silence,	-- Spell Lock (Fel Hunter)
	[115782]	= PowaAuras.DebuffCatType.Silence,	-- Optical Blast (Observer)
	[118093]	= PowaAuras.DebuffCatType.Disarm,	-- Disarm (Voidwalker/Voidlord)
	-- Warrior
	[5246]		= PowaAuras.DebuffCatType.CC,		-- Intimidating Shout (Main target)
	[20511]		= PowaAuras.DebuffCatType.CC,		-- Intimidating Shout (Secondary targets)
	[7922]		= PowaAuras.DebuffCatType.Stun,		-- Charge Stun
	[46968]		= PowaAuras.DebuffCatType.Stun,		-- Shockwave
	[118895]	= PowaAuras.DebuffCatType.Stun,		-- Dragon Roar
	[132169]	= PowaAuras.DebuffCatType.Stun,		-- Storm Bolt
	[18498]		= PowaAuras.DebuffCatType.Silence,	-- Silenced - Gag Order
	[676]		= PowaAuras.DebuffCatType.Disarm,	-- Disarm
	[107566]	= PowaAuras.DebuffCatType.Root,		-- Staggering Shout
	[105771]	= PowaAuras.DebuffCatType.Root,		-- Warbringer
	[147531]	= PowaAuras.DebuffCatType.Snare,	-- Bloodbath
	[1715]		= PowaAuras.DebuffCatType.Snare,	-- Hamstring
	[129923]	= PowaAuras.DebuffCatType.Snare,	-- Sluggish
	[12323]		= PowaAuras.DebuffCatType.Snare,	-- Piercing Howl
	-- Engineering/Tailoring
	[89637]		= PowaAuras.DebuffCatType.CC,		-- Big Daddy
	[30217]		= PowaAuras.DebuffCatType.Stun,		-- Adamantite Grenade
	[30216]		= PowaAuras.DebuffCatType.Stun,		-- Fel Iron Bomb
	[39965]		= PowaAuras.DebuffCatType.Root,		-- Frost Grenade
	[55536]		= PowaAuras.DebuffCatType.Root,		-- Frostweave Net
	[13099]		= PowaAuras.DebuffCatType.Root,		-- Net-o-Matic
	[75148]		= PowaAuras.DebuffCatType.Root,		-- Embersilk net
	-- Racials
	[20549]		= PowaAuras.DebuffCatType.Stun,		-- War Stomp
	[28730]		= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (Mana version)
	[80483]		= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (Focus version)
	[25046]		= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (Energy version)
	[50613]		= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (Runic Power version)
	[69179]		= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (Rage version)
	-- Other
	[29703]		= PowaAuras.DebuffCatType.Snare		-- Dazed
}

PowaAuras.Text = { }

ns.PowaAuras = PowaAuras
PowaAurasOptions = PowaAuras

function PowaAuras:Debug(...)
	if PowaMisc.Debug then
		self:Message(...)
	end
end

function PowaAuras:Message(...)
	local args = {...}
	if not args or #args == 0 then
		return
	end
	local Message = ""
	for i = 1, #args do
		Message = Message..tostring(args[i])
	end
	print(Message)
end

function PowaAuras:ShowText(...)
	self:Message(...)
end

function PowaAuras:DisplayText(...)
	self:Message(...)
end

function PowaAuras:Error(msg, holdtime)
	if not holdtime then
		holdtime = UIERRORS_HOLD_TIME
	end
	UIErrorsFrame:AddMessage(msg, 0.75, 0.75, 1.0, 1.0, holdtime)
end

function PowaAuras:IsNumeric(a)
	return type(tonumber(a)) == "number"
end

function PowaAuras:TableEmpty(t)
	if type(t) ~= "table" then
		return
	end
	for k in pairs(t) do
		return false
	end
	return true
end

function PowaAuras:TableSize(t)
	if type(t) ~= "table" then
		return
	end
	local size = 0
	for k in pairs(t) do
		size = size + 1
	end
	return size
end

function PowaAuras:DisplayTable(t, i)
	if type(t) ~= "table" then
		return
	end
	if not i then
		i = ""
	else
		i = i.." "
	end
	for k, v in pairs(t) do
		if type(v) ~= "function" then
			if type(v) ~= "table" then
				print(tostring(k).." = "..tostring(v)..i)
			else
				print(tostring(k)..i)
				self:DisplayTable(v, i)
			end
		end
	end
end

function PowaAuras:CopyTable(t, lookup_table, original)
	if type(t) ~= "table" then
		return t
	end
	local copy
	if not original then
		copy = { }
	else
		copy = original
	end
	for i, v in pairs(t) do
		if type(v) ~= "function" then
			if type(v) ~= "table" then
				copy[i] = v
			else
				lookup_table = lookup_table or { }
				lookup_table[t] = copy
				if lookup_table[v] then
					copy[i] = lookup_table[v]
				else
					copy[i] = self:CopyTable(v, lookup_table)
				end
			end
		end
	end
	return copy
end

function PowaAuras:MergeTables(desTable, sourceTable)
	if not sourceTable or type(sourceTable) ~= "table" then
		return
	end
	if not desTable or type(desTable) ~= "table" then
		desTable = sourceTable
		return
	end
	for i,v in pairs(sourceTable) do
		if type(v) ~= "function" then
			if type(v) ~= "table" then
				desTable[i] = v
			else
				if not desTable[i] or type(desTable[i]) ~= "table" then
					desTable[i] = { }
				end
				self:MergeTables(desTable[i], v)
			end
		end
	end
end

function PowaAuras:GetTableNumber(t, s)
	if type(t) ~= "table" then
		return
	end
	for k, v in pairs(t) do
		if v == s then
			return k
		end
	end
	return false
end

function PowaAuras:GetTableNumberAll(t, s)
	if type(t) ~= "table" then
		return
	end
	local r = { }
	for k, v in pairs(t) do
		if v == s then
			table.insert(r, k)
		end
	end
	if not r[1] then
		return nil
	end
	return r
end

function PowaAuras:InsertText(text, ...)
	local args = {...}
	if not args or #args == 0 then
		return text
	end
	for k, v in pairs(args) do
		text = string.gsub(text, "$"..k, tostring(v))
	end
	return text
end

function PowaAuras:MatchString(textToSearch, textToFind, ingoreCase)
	if not textToSearch then
		return textToFind == nil
	end
	if ingoreCase then
		textToFind = string.upper(textToFind)
		textToSearch = string.upper(textToSearch)
	end
	return string.find(textToSearch, textToFind, 1, true)
end

function PowaAuras:Different(o1, o2)
	local t1 = type(o1)
	local t2 = type(o2)
	if t1 ~= t2 or t1 == "string" or t2 == "string" then
		return tostring(o1) ~= tostring(o2)
	end
	if t1 == "number" then
		return math.abs(o1 - o2) > 1e-9
	end
	return o1 ~= o2
end

function PowaAuras:GetSettingForExport(prefix, k, v, default)
	if not self:Different(v, default) and not PowaGlobalMisc.FixExports then
		return ""
	end
	local varType = type(v)
	local setting = prefix..k..":"
	if varType == "string" then
		setting = setting..v
	elseif varType == "number" then
		local round = math.floor(v * 10000 + 0.5) / 10000
		setting = setting..tostring(round)
	else
		setting = setting..tostring(v)
	end
	return setting.."; "
end