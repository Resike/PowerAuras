local string, tostring, tonumber, table, math, pairs, type, getmetatable, setmetatable, select = string, tostring, tonumber, table, math, pairs, type, getmetatable, setmetatable, select

local _, ns = ...
local PowaAuras = { }

PowaAuras =
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

ActiveTalentGroup = GetActiveSpecGroup(),

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
	MOONKIN_FORM = GetSpellInfo(24858),
	TREE_OF_LIFE = GetSpellInfo(65139),
	SHADOWFORM = GetSpellInfo(15473),
	DRUID_SHIFT_CAT = GetSpellInfo(768),
	DRUID_SHIFT_BEAR = GetSpellInfo(5487),
	DRUID_SHIFT_DIREBEAR = GetSpellInfo(9634),
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
	SpinAntiClockwise = 12
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
	"AuctionWindowClose",
	"AuctionWindowOpen",
	"Fishing Reel in",
	"GAMEDIALOGOPEN",
	"GAMEDIALOGCLOSE",
	"HumanExploration",
	"igAbilityOpen",
	"igAbilityClose",
	"igBackPackOpen",
	"igBackPackClose",
	"igInventoryOepn",
	"igInventoryClose",
	"igMainMenuOpen",
	"igMainMenuClose",
	"igMiniMapOpen",
	"igMiniMapClose",
	"igPlayerInvite",
	"igPVPUpdate",
	"LEVELUP",
	"LOOTWINDOWCOINSOUND",
	"MapPing",
	"PVPENTERQUEUE",
	"PVPTHROUGHQUEUE",
	"QUESTADDED",
	"QUESTCOMPLETED",
	"RaidWarning",
	"ReadyCheck",
	"TalentScreenOpen",
	"TalentScreenClose",
	"TellMessage",
	-- Second Tab
	-- Custom Sounds
	"Aggro.mp3",
	"Arrow Swoosh.mp3",
	"Bam.mp3",
	"Bear Polar.mp3",
	"Big Kiss.mp3",
	"Bite.mp3",
	"Bloodbath.mp3",
	"Burp.mp3",
	"Cat.mp3",
	"Chant1.mp3",
	"Chant2.mp3",
	"Chimes.mp3",
	"Cookie.mp3",
	"Espark.mp3",
	"Fireball.mp3",
	"Gasp.mp3",
	"Heartbeat.mp3",
	"Hic.mp3",
	"Huh.mp3",
	"Hurricane.mp3",
	"Hyena.mp3",
	"Kaching.mp3",
	"Moan.mp3",
	"Panther.mp3",
	"Phone.mp3",
	"Punch.mp3",
	"Rainroof.mp3",
	"Rocket.mp3",
	"Ship Horn.mp3",
	"Shot.mp3",
	"Snake.mp3",
	"Sneeze.mp3",
	"Sonar.mp3",
	"Splash.mp3",
	"Squeaky.mp3",
	"Sword.mp3",
	"Throw.mp3",	
	"Thunder.mp3",
	"Vengeance.mp3",
	"Warpath.mp3",
	"Wicked Laugh Female.mp3",
	"Wicked Laugh Male.mp3",
	"Wilhelm.mp3",
	"Wolf.mp3",
	"Yeehaw.mp3"
},

TimerTextures =
{
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

PowaAurasModels =
{
	-- Particles
	"Particles\\MorphFX.m2",
	-- Spells
	-- A
	"Spells\\AbolishMagic_Base.m2",
	"Spells\\Abyssal_Ball.m2",
	"Spells\\AllianceCTFflag_Generic_spell.m2",
	"Spells\\AllianceCTFflag_spell.m2",
	"Spells\\AmplifyMagic_Impact_Base.m2",
	"Spells\\AntiMagic_State_Base.m2",
	"Spells\\AntiMagic_State_blue.m2",
	"Spells\\AntiMagic_State_Red.m2",
	"Spells\\Arcane_Fire_Weapon_Effect.m2",
	"Spells\\Arcane_Missile_Lvl1.m2",
	"Spells\\Arcane_Missile_Lvl2.m2",
	"Spells\\Arcane_Missile_Lvl3.m2",
	"Spells\\Arcane_Missile_Lvl4.m2",
	"Spells\\ArcaneBomb_Missle.m2",
	"Spells\\ArcaneExplosion_Base.m2",
	"Spells\\ArcaneExplosion_Boss_Base.m2",
	"Spells\\ArcaneIntellect_Impact_Base.m2",
	"Spells\\ArcanePower_State_Chest.m2",
	"Spells\\ArcaneShot_Missile.m2",
	"Spells\\ArcaneShot_Missile2.m2",
	"Spells\\ArcaneSpirit_Impact_Base.m2",
	"Spells\\ArcaneTorrent.m2",
	"Spells\\AspectBeast_Impact_Head.m2",
	"Spells\\AspectCheetah_Impact_Head.m2",
	"Spells\\AspectHawk_Impact_Head.m2",
	"Spells\\AspectMonkey_Impact_Head.m2",
	"Spells\\AspectSnake_Impact_Head.m2",
	"Spells\\AspectWild_Impact_Head.m2",
	"Spells\\Assassinate_Impact.m2",
	"Spells\\Assassinate_Missile.m2",
	"Spells\\Astral_Recall_Impact_Base.m2",
	"Spells\\AvengingWrath_State_Chest.m2",
	-- B
	"Spells\\Backstab_impact_chest.m2",
	"Spells\\Ball_of_shadow.m2",
	"Spells\\Banish_chest.m2",
	"Spells\\Banish_chest_blue.m2",
	"Spells\\Banish_chest_dark.m2",
	"Spells\\Banish_chest_purple.m2",
	"Spells\\Banish_chest_white.m2",
	"Spells\\Banish_chest_yellow.m2",
	"Spells\\Barkshield_state_base.m2",
	"Spells\\Barkskin_state_base_iron.m2",
	"Spells\\Battleshout_cast_base.m2",
	"Spells\\Beartrap.m2",
	"Spells\\Beartrap_state.m2",
	"Spells\\Beastlore_impact_head.m2",
	"Spells\\Beastsoothe_impact_head.m2",
	"Spells\\Beastsoothe_state_head.m2",
	"Spells\\Bind_impact_base.m2",
	"Spells\\Blackhole_white.m2",
	"Spells\\Blackhole_white_h.m2",
	"Spells\\Blackmagic_precast_base.m2",
	"Spells\\Blackshot_missile.m2",
	"Spells\\Blazingfists_base.m2",
	"Spells\\Blessed_mending_impact.m2",
	"Spells\\Blessingoffreedom_impact.m2",
	"Spells\\Blessingoffreedom_state.m2",
	"Spells\\Blessingoflight_impact.m2",
	"Spells\\Blessingofprotection_chest.m2",
	"Spells\\Blessingofprotection_State_Classic.m2",
	"Spells\\BlessingofSpellProtection_Base.m2",
	"Spells\\BlindingShot_Impact.m2",
	"Spells\\BlindingShot_Missile.m2",
	"Spells\\Blizzard_Impact_Base.m2",
	"Spells\\BloodBoil_Impact_Chest.m2",
	"Spells\\BloodBolt_Chest.m2",
	"Spells\\BloodBolt_Missile_Low.m2",
	"Spells\\Bloodlust_State_Hand.m2",
	"Spells\\BloodyExplosion.m2",
	"Spells\\BloodyExplosionGreen.m2",
	"Spells\\BloodyExplosionPurple.m2",
	"Spells\\Bone_Cyclone_Impact.m2",
	"Spells\\BoneArm_01.m2",
	"Spells\\BoneArmor_Head.m2",
	"Spells\\BoneArmor_State_Chest.m2",
	"Spells\\BurningIntellect_Impact_Base.m2",
	"Spells\\BurningSpirit_Impact_Base.m2",
	"Spells\\BurningSpirit_Impact_Head.m2",
	-- C
	"Spells\\Camouflage_Hands.m2",
	"Spells\\Camouflage_Head.m2",
	"Spells\\Camouflage_Impact.m2",
	"Spells\\CatMark.m2",
	"Spells\\CatMark_Black.m2",
	"Spells\\CatMark_Blue.m2",
	"Spells\\CatMark_Green.m2",
	"Spells\\CatMark_Orange.m2",
	"Spells\\CatMark_Red.m2",
	"Spells\\CatMark_White.m2",
	"Spells\\CatMark_Yellow.m2",
	"Spells\\ChallengingShout_Cast_Base.m2",
	-- D
	"Spells\\Dampenmagic_impact_base.m2",
	"Spells\\Darkmoonvengeance_impact_chest.m2",
	"Spells\\Darkmoonvengeance_impact_head.m2",
	"Spells\\Darkritual_precast_base.m2",
	"Spells\\Darkritual_precast_baseblue.m2",
	"Spells\\Deadly_throw_impact_chest.m2",
	"Spells\\Deathbolt_missile_low.m2",
	"Spells\\Deathcoil_missile.m2",
	"Spells\\Deathknight_bloodboil_cast.m2",
	"Spells\\Deathknight_bloodstrike.m2",
	"Spells\\Deathknight_deathcoil_missile.m2",
	"Spells\\Deathknight_death_siphon_impact.m2",
	"Spells\\Deathknight_death_siphon_missile.m2",
	"Spells\\Deathknight_froststrike.m2",
	"Spells\\Deathknight_frozenruneweapon_impact.m2",
	"Spells\\Deathknight_ghoul_explode_simple.m2",
	"Spells\\Deathknight_hysteria.m2",
	"Spells\\Deathknight_lichborne_state.m2",
	"Spells\\Deathknight_obliterate.m2",
	"Spells\\Deathknight_obliterate_impact.m2",
	"Spells\\Deathknight_outbreak.m2",
	"Spells\\Deathknight_plaguestrikecaster.m2",
	"Spells\\Deathknight_strangulate_chain.m2",
	"Spells\\Deathwing_lava_burst.m2",
	"Spells\\Deathwing_lava_burst_impact.m2",
	"Spells\\Decimate_missile_red.m2",
	"Spells\\Demolisher_missile.m2",
	"Spells\\Demolisher_missile_blue.m2",
	"Spells\\Detectinvis_impact_head.m2",
	"Spells\\Deterrence_impact.m2",
	"Spells\\Deterrence_state_chest.m2",
	"Spells\\Devious_impact.m2",
	"Spells\\Diseasecloud.m2",
	"Spells\\Dispel_low_base.m2",
	"Spells\\Dispel_low_base_simple.m2",
	"Spells\\Divineshield_low_base.m2",
	"Spells\\Divineshield_v2_chest.m2",
	"Spells\\Druid_efflorescence_persistent.m2",
	"Spells\\Druid_non_shapeshifted_stampede.m2",
	"Spells\\Druid_pulverize_impact.m2",
	"Spells\\Druid_starsurge_missile.m2",
	"Spells\\Druid_swarm_impact.m2",
	"Spells\\Druid_swarm_state.m2",
	"Spells\\Druid_thrash_impact_01.m2",
	"Spells\\Druid_wildcharge_caster_state.m2",
	-- S
	"Spells\\Sha_bolt_missile_fear_v2.m2",
	"Spells\\Sha_bolt_missile_v2.m2",
	"Spells\\Sha_fireball_missile_high.m2",
	"Spells\\Sha_firebolt_missile_low.m2",
	"Spells\\Sha_firebolt_missile_low_fear.m2",
	"Spells\\Sha_ritual_precast_base.m2",
	"Spells\\Sha_rune_state.m2",
	"Spells\\Sha_state_base_high.m2",
	"Spells\\Sha_state_base_low.m2",
	"Spells\\Sha_zone.m2",
	"Spells\\Shadopalm_missile_red.m2",
	"Spells\\Shadopalm_precast_blue.m2",
	"Spells\\Shadopalm_precast_red.m2",
	"Spells\\Shadowmourne_visual_low.m2",
	"Spells\\Sleep_state_head.m2",
	"Spells\\Spell_warlockmorphwings.m2",
	"Spells\\Sprint_cast_base.m2",
	-- Buttons
	"Interface\\Button\\TalkToMe.m2",
	"Interface\\Button\\TalkToMeBlue.m2",
	"Interface\\Button\\TalkToMeGreen.m2",
	"Interface\\Button\\TalkToMeGrey.m2",
	"Interface\\Button\\TalkToMeQuestion_Grey.m2",
	"Interface\\Button\\TalkToMeQuestion_LTBlue.m2",
	"Interface\\Button\\TalkToMeQuestionMark.m2",
	-- Creatures
	"Creature\\Akama\\Akama.m2",
	"Creature\\Alexstrasza\\Alexstrasza.m2",
	"Creature\\Alexstrasza\\LadyAlexstrasa.m2",
	"Creature\\AlglonTheObserver\\AlgalonTheObserver.m2",
	"Creature\\Eredar\\Archimonde.m2",
	"Creature\\Arthas\\Arthas.m2",
	"Creature\\ArthasUndead\\ArthasUndead.m2",
	"Creature\\ArthasLichking\\ArthasLichking.m2",
	"Creature\\AvengingAngel\\AvengingAngel.m2",
	"Creature\\Azshara\\Azshara.m2",
	"Creature\\BloodQueen\\BloodQueen.m2",
	"Creature\\BoneGuard\\BoneGuard.m2",
	"Creature\\Brutallus\\Brutallus.m2",
	"Creature\\Chogall_corrupt\\Chogall_corrupt.m2",
	"Creature\\Deathwing\\Deathwing.m2",
	"Creature\\DeathwingHuman\\DeathwingHuman.m2",
	"Creature\\FandralStaghelm\\FandralStaghelm.m2",
	"Creature\\Hodir\\Hodir.m2",
	"Creature\\DragonKalecgos\\DragonKalecgos.m2",
	"Creature\\Kalecgos\\Kalecgos.m2",
	"Creature\\Illidan\\Illidan.m2",
	"Creature\\Illidan\\IllidanDark.m2",
	"Creature\\Jaina\\Jaina.m2",
	"Creature\\Kaelthas\\Kaelthas.m2",
	"Creature\\Kaelthas_broken\\KaelThasBroken.m2",
	"Creature\\KelThuzad\\KelThuzad.m2",
	"Creature\\LadySylvanasWindrunner\\LadySylvanasWindrunner.m2",
	"Creature\\Malygos\\Malygos.m2",
	"Creature\\Medivh\\Medivh.m2",
	"Creature\\Miev\\Miev.m2",
	"Creature\\MinisterOfDeath\\MinisterOfDeath.m2",
	"Creature\\MurlocCostume\\MurlocCostume.m2",
	"Creature\\MurlocCostume\\MurlocCostume_noflag.m2",
	"Creature\\MurlocCostume\\MurlocCostume_whiteflag.m2",
	"Creature\\Neptulon\\Neptulon.m2",
	"Creature\\NorthrendNightBane\\NorthrendNightBane.m2",
	"Creature\\Phoenix\\Phoenix.m2",
	"Creature\\Ragnaros2\\Ragnaros2.m2",
	"Creature\\ShaBoss_anger\\ShaBoss_anger.m2",
	"Creature\\ShaBoss_doubt\\ShaBoss_doubt.m2",
	"Creature\\ShaBoss_fear\\ShaBoss_fear.m2",
	"Creature\\Spirithealer\\Spirithealer.m2",
	"Creature\\ThunderKing\\MoguThunderKing.m2",
	"Creature\\TyraelPet\\TyraelPet.m2",
	"Creature\\Tyrande\\Tyrande.m2",
	"Creature\\Yoggsaron\\Yoggsaron.m2",
	"Creature\\Ysera\\Ysera.m2",
	"Creature\\Zuljin\\Zuljin.m2"
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
PowaAuras.GCDSpells =
{
	PALADIN = 35395, -- Crusader Strike
	PRIEST = 585, -- Smite
	SHAMAN = 403, -- Lightning Bolt
	WARRIOR = 34428, -- Victory Rush
	DRUID = 5176, -- Wrath
	MAGE = 44614, -- Frostfire Bolt
	WARLOCK = 686, -- Shadow Bolt
	ROGUE = 1752, -- Sinister Strike
	HUNTER = 982, -- Revive Pet
	DEATHKNIGHT = 45902, -- Blood Strike
	MONK = 100780 -- Jab
}

-- Invented so we can distinquish them two types
SPELL_POWER_LUNAR_ECLIPSE = 108
SPELL_POWER_SOLAR_ECLIPSE = 208

PowaAuras.PowerRanges =
{
	[-1] = 100,
	[SPELL_POWER_MANA] = 100,
	[SPELL_POWER_RAGE] = 100,
	[SPELL_POWER_FOCUS] = 100,
	[SPELL_POWER_ENERGY] = 100,
	[SPELL_POWER_RUNES] = 100,
	[SPELL_POWER_RUNIC_POWER] = 100,
	[SPELL_POWER_SOUL_SHARDS] = 4,
	[SPELL_POWER_LUNAR_ECLIPSE] = 100,
	[SPELL_POWER_SOLAR_ECLIPSE] = 100,
	[SPELL_POWER_DEMONIC_FURY] = 1000,
	[SPELL_POWER_HOLY_POWER] = 5,
	[SPELL_POWER_ALTERNATE_POWER] = 100,
	[SPELL_POWER_DARK_FORCE] = 5,
	[SPELL_POWER_CHI] = 5,
	[SPELL_POWER_SHADOW_ORBS] = 3,
	[SPELL_POWER_BURNING_EMBERS] = 4,
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
	[SPELL_POWER_LUNAR_ECLIPSE] = "%",
	[SPELL_POWER_SOLAR_ECLIPSE] = "%",
	[SPELL_POWER_DEMONIC_FURY] = "",
	[SPELL_POWER_HOLY_POWER] = "",
	[SPELL_POWER_ALTERNATE_POWER] = "",
	[SPELL_POWER_DARK_FORCE] = "",
	[SPELL_POWER_CHI] = "",
	[SPELL_POWER_SHADOW_ORBS] = "",
	[SPELL_POWER_BURNING_EMBERS] = ""
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
	[SPELL_POWER_LUNAR_ECLIPSE] = "ability_druid_eclipse",
	[SPELL_POWER_SOLAR_ECLIPSE] = "ability_druid_eclipseorange",
	[SPELL_POWER_DEMONIC_FURY] = "ability_warlock_eradication",
	[SPELL_POWER_HOLY_POWER] = "spell_holy_lightsgrace",
	[SPELL_POWER_ALTERNATE_POWER] = "inv_battery_02",
	[SPELL_POWER_DARK_FORCE] = "spell_arcane_arcanetorrent",
	[SPELL_POWER_CHI] = "class_monk",
	[SPELL_POWER_SHADOW_ORBS] = "spell_priest_shadoworbs",
	[SPELL_POWER_BURNING_EMBERS] = "ability_warlock_burningembers",
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
	[47481]	= PowaAuras.DebuffCatType.Stun,		-- Gnaw (Ghoul)
	[51209]	= PowaAuras.DebuffCatType.CC,		-- Hungering Cold
	[47476]	= PowaAuras.DebuffCatType.Silence,	-- Strangulate
	[45524]	= PowaAuras.DebuffCatType.Snare,	-- Chains of Ice
	[55666]	= PowaAuras.DebuffCatType.Snare,	-- Desecration (no duration, lasts as long as you stand in it)
	[50434]	= PowaAuras.DebuffCatType.Snare,	-- Chillblains - I
	[50435]	= PowaAuras.DebuffCatType.Snare,	-- Chillblains - II
	[96294]	= PowaAuras.DebuffCatType.Root,		-- Chains of Ice (Root effect caused by Chillblains talent, guessed spell ID!)
	[91797]	= PowaAuras.DebuffCatType.Stun,		-- Monstrous Blow (for unholy DK ghouls under Dark Transformation)
	[91802]	= PowaAuras.DebuffCatType.Root,		-- Shambling Rush (for unholy DK ghouls under Dark Transformation)
	-- Druid
	[5211]	= PowaAuras.DebuffCatType.Stun,		-- Bash (also Shaman Spirit Wolf ability)
	[33786]	= PowaAuras.DebuffCatType.CC,		-- Cyclone
	[2637]	= PowaAuras.DebuffCatType.CC,		-- Hibernate (works against Druids in most forms and Shamans using Ghost Wolf)
	[22570]	= PowaAuras.DebuffCatType.Stun,		-- Maim
	[9005]	= PowaAuras.DebuffCatType.Stun,		-- Pounce
	[19679]	= PowaAuras.DebuffCatType.Root,		-- Feral Charge Effect Bear. Immobilize.
	[49376]	= PowaAuras.DebuffCatType.Snare,	-- Feral Charge Effect Cat. Daze.
	[78675]	= PowaAuras.DebuffCatType.Silence,	-- Solar Beam (no duration unless glyphed, but the glyph mods the original spell)
	[339]	= PowaAuras.DebuffCatType.Root,		-- Entangling Roots
	[58179]	= PowaAuras.DebuffCatType.Snare,	-- Infected Wounds - I
	[58180]	= PowaAuras.DebuffCatType.Snare,	-- Infected Wounds - II
	[61391]	= PowaAuras.DebuffCatType.Snare,	-- Typhoon
	-- Hunter
	[3355]	= PowaAuras.DebuffCatType.CC,		-- Freezing Trap Effect
	[19577]	= PowaAuras.DebuffCatType.Stun,		-- Intimidation
	[1513]	= PowaAuras.DebuffCatType.CC,		-- Scare Beast (works against Druids in most forms and Shamans using Ghost Wolf)
	[19503]	= PowaAuras.DebuffCatType.CC,		-- Scatter Shot
	[19386]	= PowaAuras.DebuffCatType.CC,		-- Wyvern Sting
	[34490]	= PowaAuras.DebuffCatType.Silence,	-- Silencing Shot
	[19306]	= PowaAuras.DebuffCatType.Root,		-- Counterattack
	[19185]	= PowaAuras.DebuffCatType.Root,		-- Entrapment - I
	[64803]	= PowaAuras.DebuffCatType.Root,		-- Entrapment - II
	[35101]	= PowaAuras.DebuffCatType.Snare,	-- Concussive Barrage
	[5116]	= PowaAuras.DebuffCatType.Snare,	-- Concussive Shot
	[13810]	= PowaAuras.DebuffCatType.Snare,	-- Frost Trap Aura (no duration, lasts as long as you stand in it)
	[61394]	= PowaAuras.DebuffCatType.Snare,	-- Glyph of Freezing Trap
	[2974]	= PowaAuras.DebuffCatType.Snare,	-- Wing Clip
	-- Hunter Pets
	[50519]	= PowaAuras.DebuffCatType.Stun,		-- Sonic Blast (Bat)
	[91644]	= PowaAuras.DebuffCatType.Disarm,	-- Snatch (Bird of Prey)
	[50541]	= PowaAuras.DebuffCatType.Disarm,	-- Clench (Scorpid)
	[54644]	= PowaAuras.DebuffCatType.Snare,	-- Froststorm Breath (Chimera)
	[50245]	= PowaAuras.DebuffCatType.Root,		-- Pin (Crab)
	[54706]	= PowaAuras.DebuffCatType.Root,		-- Venom Web Spray (Silithid)
	[4167]	= PowaAuras.DebuffCatType.Root,		-- Web (Spider)
	[50433]	= PowaAuras.DebuffCatType.Snare,	-- Ankle Crack (Crocolisk)
	[90327]	= PowaAuras.DebuffCatType.Root,		-- Lock Jaw (Dog)
	[61685]	= PowaAuras.DebuffCatType.Root,		-- Charge (Various animals)
	[96201]	= PowaAuras.DebuffCatType.Stun,		-- Web Wrap (Shale Spider)
	[35346]	= PowaAuras.DebuffCatType.Snare,	-- Time Warp (Warp Stalker)
	[35346]	= PowaAuras.DebuffCatType.Stun,		-- Sting (Wasp)
	[52825]	= PowaAuras.DebuffCatType.Root,		-- Swoop (Various)
	[90337]	= PowaAuras.DebuffCatType.CC,		-- Bad Manner (Monkey)
	-- Mage
	[44572]	= PowaAuras.DebuffCatType.Stun,		-- Deep Freeze
	[31661]	= PowaAuras.DebuffCatType.CC,		-- Dragon's Breath
	[12355]	= PowaAuras.DebuffCatType.Stun,		-- Impact
	[64343]	= PowaAuras.DebuffCatType.Stun,		-- Impact (two ID's, one ought to work right?)
	[82691]	= PowaAuras.DebuffCatType.Stun,		-- Ring of Frost (counted as stun because the game thinks it's one).
	[118]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Sheep, keep well away from Welsh people)
	[61305]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Cat)
	[28272]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Pig)
	[61721]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Rabbit)
	[61780]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Turkey) Note: Turkey is not yet implemented, although it is in the data files.
	[28271]	= PowaAuras.DebuffCatType.CC,		-- Polymorph (Turtle)
	[18469]	= PowaAuras.DebuffCatType.Silence,	-- Silenced - Improved Counterspell I
	[55021]	= PowaAuras.DebuffCatType.Silence,	-- Silenced - Improved Counterspell II
	[33395]	= PowaAuras.DebuffCatType.Root,		-- Freeze (Water Elemental)
	[122]	= PowaAuras.DebuffCatType.Root,		-- Frost Nova
	[55080]	= PowaAuras.DebuffCatType.Root,		-- Shattered Barrier I
	[83073]	= PowaAuras.DebuffCatType.Root,		-- Shattered Barrier II
	[11113]	= PowaAuras.DebuffCatType.Snare,	-- Blast Wave
	[7321]	= PowaAuras.DebuffCatType.Snare,	-- Chilled (Frost Armor)
	[12484]	= PowaAuras.DebuffCatType.Snare,	-- Ice Shards I, 25% snare.
	[12485]	= PowaAuras.DebuffCatType.Snare,	-- Ice Shards II, 40% snare.
	[12486]	= PowaAuras.DebuffCatType.Snare,	-- Likely unused, but would presumably be Ice Shards III, 50% snare.
	[120]	= PowaAuras.DebuffCatType.Snare,	-- Cone of Cold
	[116]	= PowaAuras.DebuffCatType.Snare,	-- Frostbolt
	[47614]	= PowaAuras.DebuffCatType.Snare,	-- Frostfire Bolt
	[31589]	= PowaAuras.DebuffCatType.Snare,	-- Slow
	[84721]	= PowaAuras.DebuffCatType.Snare,	-- Frostfire Orb
	[83046]	= PowaAuras.DebuffCatType.Stun,		-- Improved Polymorph I
	[83047]	= PowaAuras.DebuffCatType.Stun,		-- Improved Polymorph II
	[83046]	= PowaAuras.DebuffCatType.Root,		-- Improved Cone of Cold I
	[83047]	= PowaAuras.DebuffCatType.Root,		-- Improved Cone of Cold II
	-- Monk
	[105593]= PowaAuras.DebuffCatType.Stun,		-- Fist of Justice
	-- Paladin
	[853]	= PowaAuras.DebuffCatType.Stun,		-- Hammer of Justice
	[2812]	= PowaAuras.DebuffCatType.Stun,		-- Holy Wrath (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
	[20066]	= PowaAuras.DebuffCatType.CC,		-- Repentance
	[20170]	= PowaAuras.DebuffCatType.Snare,	-- Snare (Seal of Justice proc)
	[10326]	= PowaAuras.DebuffCatType.CC,		-- Turn Evil (works against Warlocks using Metamorphasis and Death Knights using Lichborne)
	[63529]	= PowaAuras.DebuffCatType.Snare,	-- Avenger's Shield (Daze glyph)
	[31935]	= PowaAuras.DebuffCatType.Silence,	-- Avenger's Shield.
	-- Priest
	[605]	= PowaAuras.DebuffCatType.CC,		-- Mind Control
	[64044]	= PowaAuras.DebuffCatType.CC,		-- Psychic Horror
	[8122]	= PowaAuras.DebuffCatType.CC,		-- Psychic Scream
	[87204]	= PowaAuras.DebuffCatType.CC,		-- Sin and Punishment fear/horror.
	[9484]	= PowaAuras.DebuffCatType.CC,		-- Shackle Undead (works against Death Knights using Lichborne)
	[15487]	= PowaAuras.DebuffCatType.Silence,	-- Silence
	[64058] = PowaAuras.DebuffCatType.Disarm,	-- Psychic Horror
	[15407]	= PowaAuras.DebuffCatType.Snare,	-- Mind Flay
	[88625]	= PowaAuras.DebuffCatType.CC,		-- Holy Word: Chastise
	-- Rogue
	[2094]	= PowaAuras.DebuffCatType.CC,		-- Blind
	[1833]	= PowaAuras.DebuffCatType.Stun,		-- Cheap Shot
	[1776]	= PowaAuras.DebuffCatType.CC,		-- Gouge
	[408]	= PowaAuras.DebuffCatType.Stun,		-- Kidney Shot
	[6770]	= PowaAuras.DebuffCatType.CC,		-- Sap
	[1330]	= PowaAuras.DebuffCatType.Silence,	-- Garrote - Silence
	[18425]	= PowaAuras.DebuffCatType.Silence,	-- Silenced - Improved Kick I
	[86759]	= PowaAuras.DebuffCatType.Silence,	-- Silenced - Improved Kick II
	[51722]	= PowaAuras.DebuffCatType.Disarm,	-- Dismantle
	[31125]	= PowaAuras.DebuffCatType.Snare,	-- Blade Twisting I
	[51585]	= PowaAuras.DebuffCatType.Snare,	-- Blade Twisting II
	[3409]	= PowaAuras.DebuffCatType.Snare,	-- Crippling Poison
	[26679]	= PowaAuras.DebuffCatType.Snare,	-- Deadly Throw
	[51696]	= PowaAuras.DebuffCatType.Snare,	-- Waylay
	-- Shaman
	[39796]	= PowaAuras.DebuffCatType.Stun,		-- Stoneclaw Stun
	[51514]	= PowaAuras.DebuffCatType.CC,		-- Hex (although effectively a silence+disarm effect, it is conventionally thought of as a CC, plus you can trinket out of it)
	[64695]	= PowaAuras.DebuffCatType.Root,		-- Earthgrab (Storm, Earth and Fire)
	[63685]	= PowaAuras.DebuffCatType.Root,		-- Freeze (Frozen Power)
	[3600]	= PowaAuras.DebuffCatType.Snare,	-- Earthbind (5 second duration per pulse, but will keep re-applying the debuff as long as you stand within the pulse radius)
	[8056]	= PowaAuras.DebuffCatType.Snare,	-- Frost Shock
	[8034]	= PowaAuras.DebuffCatType.Snare,	-- Frostbrand Attack
	[73682]	= PowaAuras.DebuffCatType.Snare,	-- Unleash Frost (via Unleash Elements + Frostbrand Weapon)
	-- Warlock
	[710]	= PowaAuras.DebuffCatType.CC,		-- Banish (works against Warlocks using Metamorphasis and Druids using Tree Form)
	[6789]	= PowaAuras.DebuffCatType.CC,		-- Death Coil
	[5782]	= PowaAuras.DebuffCatType.CC,		-- Fear
	[5484]	= PowaAuras.DebuffCatType.CC,		-- Howl of Terror
	[6358]	= PowaAuras.DebuffCatType.CC,		-- Seduction (Succubus)
	[30283]	= PowaAuras.DebuffCatType.Stun,		-- Shadowfury
	[24259]	= PowaAuras.DebuffCatType.Silence,	-- Spell Lock (Felhunter)
	[18118]	= PowaAuras.DebuffCatType.Snare,	-- Aftermath
	[18223]	= PowaAuras.DebuffCatType.Snare,	-- Curse of Exhaustion
	[54785]	= PowaAuras.DebuffCatType.Stun,		-- Demon Leap (via metamorphosis)
	[60946]	= PowaAuras.DebuffCatType.Snare,	-- Nightmare (Improved Fear I)
	[60947]	= PowaAuras.DebuffCatType.Snare,	-- Nightmare (Improved Fear II)
	[85387]	= PowaAuras.DebuffCatType.Stun,		-- Aftermath (stun effect from rain of fire)
	[89766]	= PowaAuras.DebuffCatType.Stun,		-- Axe Toss (from a felguard)
	[93975]	= PowaAuras.DebuffCatType.Stun,		-- Aura of Foreboding I (stun effect)
	[93974]	= PowaAuras.DebuffCatType.Snare,	-- Aura of Foreboding I (root effect)
	[93986]	= PowaAuras.DebuffCatType.Stun,		-- Aura of Foreboding II (stun effect)
	[93987]	= PowaAuras.DebuffCatType.Snare,	-- Aura of Foreboding II (root effect)
	[63311]	= PowaAuras.DebuffCatType.Snare,	-- Shadowsnare
	-- Warrior
	[7922]	= PowaAuras.DebuffCatType.Stun,		-- Charge Stun
	[12809]	= PowaAuras.DebuffCatType.Stun,		-- Concussion Blow
	[20253]	= PowaAuras.DebuffCatType.Stun,		-- Intercept
	[5246]	= PowaAuras.DebuffCatType.CC,		-- Intimidating Shout
	[46968]	= PowaAuras.DebuffCatType.Stun,		-- Shockwave
	[18498]	= PowaAuras.DebuffCatType.Silence,	-- Silenced - Gag Order
	[676]	= PowaAuras.DebuffCatType.Disarm,	-- Disarm
	[23694]	= PowaAuras.DebuffCatType.Root,		-- Improved Hamstring
	[1715]	= PowaAuras.DebuffCatType.Snare,	-- Hamstring
	[12323]	= PowaAuras.DebuffCatType.Snare,	-- Piercing Howl
	[85388]	= PowaAuras.DebuffCatType.Stun,		-- Throwdown
	-- Engineering/Tailoring
	[75148]	= PowaAuras.DebuffCatType.Root,		-- Embersilk net
	[89637]	= PowaAuras.DebuffCatType.CC,		-- Big Daddy
	[30217]	= PowaAuras.DebuffCatType.Stun,		-- Adamantite Grenade
	[30216]	= PowaAuras.DebuffCatType.Stun,		-- Fel Iron Bomb
	[20549]	= PowaAuras.DebuffCatType.Stun,		-- War Stomp
	[25046]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent
	[39965]	= PowaAuras.DebuffCatType.Root,		-- Frost Grenade
	[55536]	= PowaAuras.DebuffCatType.Root,		-- Frostweave Net
	[13099]	= PowaAuras.DebuffCatType.Root,		-- Net-o-Matic
	-- Racials
	[20549]	= PowaAuras.DebuffCatType.Stun,		-- War stomp
	[28730]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (caster)
	[80483]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (hunter)
	[25046]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (rogue)
	[50613]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (death knight)
	[69179]	= PowaAuras.DebuffCatType.Silence,	-- Arcane Torrent (warrior)
	-- Other
	[29703]	= PowaAuras.DebuffCatType.Snare	-- Dazed
}

PowaAuras.Text = { }

PowaAurasOptions = { }
PowaAurasOptions = PowaAuras
ns.PowaAuras = PowaAuras

function PowaAuras:Debug(...)
	if PowaMisc.debug then
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

function PowaAuras:DisplayTable(t, indent)
	if not t or type(t) ~= "table" then
		return "No table"
	end
	if not indent then
		indent = ""
	else
		indent = indent.."  "
	end
	for i, v in pairs(t) do
		if type(v) ~= "function" then
			if type(v) ~= "table" then
				self:Message(indent..tostring(i).." = "..tostring(v))
			else
				self:Message(indent..tostring(i))
				self:DisplayTable(v, indent)
			end
		end
	end
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

function PowaAuras:ReverseTable(t)
	if type(t) ~= "table" then
		return
	end
	local newTable = { }
	for k, v in pairs(t) do
		newTable[v] = k
	end
	return newTable
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
	for i,v in pairs(t) do
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