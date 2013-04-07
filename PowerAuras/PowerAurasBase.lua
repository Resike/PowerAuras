PowaAuras =
{
Version = GetAddOnMetadata("PowerAuras", "Version");

VersionPattern = "(%d+)%.(%d+)";

WoWBuild = tonumber(select(4, GetBuildInfo()), 10);

IconSource = "Interface\\Icons\\";

CurrentAuraId = 1;
NextCheck = 0.2;
Tstep = 0.09765625;
NextDebugCheck = 0.0;
InspectTimeOut = 12;
InspectDelay = 2;
ExportMaxSize = 4000;
ExportWidth = 500;
TextureCount = 254;

DebugEvents = false;
--DebugAura = 1;

-- Internal counters
DebugTimer = 0;
ChecksTimer = 0;
ThrottleTimer = 0;
TimerUpdateThrottleTimer = 0;
NextInspectTimeOut = 0;

--[[
-- Profiling
NextProfileCheck = 0;
ProfileTimer = 0;
UpdateCount = 0;
CheckCount = 0;
EffectCount = 0;
AuraCheckCount = 0;
AuraCheckShowCount = 0;
BuffRaidCount = 0;
BuffUnitSetCount = 0;
BuffUnitCount = 0;
BuffSlotCount = 0;
AuraTypeCount = {};
]]

VariablesLoaded = false;
SetupDone = false;
ModTest = false;
DebugCycle = false;
ResetTargetTimers = false;

ActiveTalentGroup = GetActiveSpecGroup();

WeAreInCombat = false;
WeAreInRaid = false;
WeAreInParty = false;
WeAreMounted = false;
WeAreInVehicle = false;
WeAreAlive = true;
PvPFlagSet = false;
Instance = "none";

GroupUnits = {};
GroupNames = {};

Pending = {}; -- Workaround for 'silent' cooldown end (no event fired)
Cascade = {}; -- Dependant auras that need checking

UsedInMultis = {};

PowaStance =
{
	[0] = "Humanoid"
};

PowaGTFO = {[0] = "High Damage", [1] = "Low Damage", [2] = "Fail Alert", [3] = "Friendly Fire"};

allowedOperators =
{
	["="] = true,
	[">"] = true,
	["<"] = true,
	["!"] = true,
	[">="] = true,
	["<="] = true,
	["-"] = true,
};

DefaultOperator = ">=";

CurrentAuraPage = 1;

MoveEffect = 0; -- 1 = copie / 2 = move

Auras = {};
SecondaryAuras = {};
Frames = {};
SecondaryFrames = {};
Textures = {};
SecondaryTextures = {};

TimerFrame = {};
StacksFrames = {};

Sound = {};
BeginAnimDisplay = {};
EndAnimDisplay = {};
Text = {};
Anim = {};

DebuffCatSpells = {};

AoeAuraAdded = {};
AoeAuraFaded = {};
AoeAuraTexture = {};

playerclass = "unknown";

Events = {};
AlwaysEvents =
{
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
	ZONE_CHANGED_NEW_AREA = true,
};

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
	CENTER = "CENTER",
},

ChangedUnits =
{
	Buffs = {},
	Targets = {};
};

InspectedRoles = {};
FixRoles = {};

Spells =
{
	ACTIVATE_FIRST_TALENT = GetSpellInfo(63645),
	ACTIVATE_SECOND_TALENT = GetSpellInfo(63644),
	BUFF_BLOOD_PRESENCE = GetSpellInfo(48266),
	BUFF_FROST_PRESENCE = GetSpellInfo(48263),
	BUFF_UNHOLY_PRESENCE = GetSpellInfo(48265),
	MOONKIN_FORM = GetSpellInfo(24858),
	TREE_OF_LIFE = GetSpellInfo(65139),
	SHADOWFORM = GetSpellInfo(15473),
	DRUID_SHIFT_CAT = GetSpellInfo(768),
	DRUID_SHIFT_BEAR = GetSpellInfo(5487),
	DRUID_SHIFT_DIREBEAR = GetSpellInfo(9634),
	DRUID_SHIFT_MOONKIN = GetSpellInfo(24858),
};

ExtraUnitEvent = {};
CastOnMe = {};
CastByMe = {};

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
	CheckIt = false,
};

BuffTypes =
{
	Buff=1,
	Debuff=2,
	TypeDebuff=3,
	AoE=4,
	Enchant=5,
	Combo=6,
	ActionReady=7,
	Health=8,
	Mana=9,
	EnergyRagePower=10,
	Aggro=11,
	PvP=12,
	SpellAlert=13,
	Stance=14,
	SpellCooldown=15,
	StealableSpell=16,
	PurgeableSpell=17,
	Static=18,
	Totems=19,
	Pet=20,
	Runes=21,
	Items=22,
	Slots=23,
	Tracking=24,
	TypeBuff=25,
	UnitMatch=26,
	PetStance=27,
	GTFO=50,
};

AnimationBeginTypes =
{
	None=0,
	ZoomIn=1,
	ZoomOut=2,
	FadeIn=3,
	TranslateLeft=4,
	TranslateTopLeft=5,
	TranslateTop=6,
	TranslateTopRight=7,
	TranslateRight=8,
	TranslateBottomRight=9,
	TranslateBottom=10,
	TranslateBottomLeft=11,
	Bounce=12,
};

AnimationEndTypes =
{
	None=0,
	GrowAndFade=1,
	ShrinkAndFade=2,
	Fade=3,
	SpinAndFade=4,
	SpinShrinkAndFade=5,
};

AnimationTypes =
{
	Invisible=0,
	Static=1,
	Flashing=2,
	Growing=3,
	Pulse=4,
	Bubble=5,
	WaterDrop=6,
	Electric=7,
	Shrinking=8,
	Flame=9,
	Orbit=10,
	SpinClockwise=11,
	SpinAntiClockwise=12,
};

-- Aura name -> Auras array
AurasByType = {};

-- Index -> Aura name
AurasByTypeList = {};

DebuffCatType =
{
	CC = 1,
	Silence = 2,
	Snare = 3,
	Root = 4,
	Disarm = 5,
	Stun = 6,
	PvE = 10,
};

Sound =
{
	-- Blizzard Sounds
	[1] = "AuctionWindowClose",
	[2] = "AuctionWindowOpen",
	[3] = "Fishing Reel in",
	[4] = "GAMEDIALOGOPEN",
	[5] = "GAMEDIALOGCLOSE",
	[6] = "HumanExploration",
	[7] = "igAbilityOpen",
	[8] = "igAbilityClose",
	[9] = "igBackPackOpen",
	[10] = "igBackPackClose",
	[11] = "igInventoryOepn",
	[12] = "igInventoryClose",
	[13] = "igMainMenuOpen",
	[14] = "igMainMenuClose",
	[15] = "igMiniMapOpen",
	[16] = "igMiniMapClose",
	[17] = "igPlayerInvite",
	[18] = "igPVPUpdate",
	[19] = "LEVELUP",
	[20] = "LOOTWINDOWCOINSOUND",
	[21] = "MapPing",
	[22] = "PVPENTERQUEUE",
	[23] = "PVPTHROUGHQUEUE",
	[24] = "QUESTADDED",
	[25] = "QUESTCOMPLETED",
	[26] = "RaidWarning",
	[27] = "ReadyCheck",
	[28] = "TalentScreenOpen",
	[29] = "TalentScreenClose",
	[30] = "TellMessage",
	-- Second Tab
	-- Custom Sounds
	[31] = "Aggro.ogg",
	[32] = "Arrow Swoosh.ogg",
	[33] = "Bam.ogg",
	[34] = "Bear Polar.ogg",
	[35] = "Big Kiss.ogg",
	[36] = "Bite.ogg",
	[37] = "Burp.ogg",
	[38] = "Cat.ogg",
	[39] = "Chant1.ogg",
	[40] = "Chant2.ogg",
	[41] = "Chimes.ogg",
	[42] = "Cookie.ogg",
	[43] = "Espark.ogg",
	[44] = "Fireball.ogg",
	[45] = "Gasp.ogg",
	[46] = "Heartbeat.ogg",
	[47] = "Hic.ogg",
	[48] = "Huh.ogg",
	[49] = "Hurricane.ogg",
	[50] = "Hyena.ogg",
	[51] = "Kaching.ogg",
	[52] = "Moan.ogg",
	[53] = "Panther.ogg",
	[54] = "Phone.ogg",
	[55] = "Punch.ogg",
	[56] = "Rainroof.ogg",
	[57] = "Rocket.ogg",
	[58] = "Shit Horn.ogg",
	[59] = "Shot.ogg",
	[60] = "Snake.ogg",
	[61] = "Sneeze.ogg",
	[62] = "Sonar.ogg",
	[63] = "Splash.ogg",
	[64] = "Squeaky.ogg",
	[65] = "Sword.ogg",
	[66] = "Throw.ogg",	
	[67] = "Thunder.ogg",
	[68] = "Wicked Laugh Female.ogg",
	[69] = "Wicked Laugh Male.ogg",
	[70] = "Wilhelm.ogg",
	[71] = "Wolf.ogg",
	[72] = "Yeehaw.ogg",
};

WowTextures =
{
	-- Auras Types
	[1] = "Spells\\AuraRune_B",
	[2] = "Spells\\AuraRune256b",
	[3] = "Spells\\Circle",
	[4] = "Spells\\GENERICGLOW2B",
	[5] = "Spells\\GenericGlow2b1",
	[6] = "Spells\\ShockRingCrescent256",
	[7] = "SPELLS\\AuraRune1",
	[8] = "SPELLS\\AuraRune5Green",
	[9] = "SPELLS\\AuraRune7",
	[10] = "SPELLS\\AuraRune8",
	[11] = "SPELLS\\AuraRune9",
	[12] = "SPELLS\\AuraRune11",
	[13] = "SPELLS\\AuraRune_A",
	[14] = "SPELLS\\AuraRune_C",
	[15] = "SPELLS\\AuraRune_D",
	[16] = "SPELLS\\Holy_Rune1",
	[17] = "SPELLS\\Rune1d_GLOWless",
	[18] = "SPELLS\\Rune4blue",
	[19] = "SPELLS\\RuneBC1",
	[20] = "SPELLS\\RuneBC2",
	[21] = "SPELLS\\RUNEFROST",
	[22] = "Spells\\Holy_Rune_128",
	[23] = "Spells\\Nature_Rune_128",
	[24] = "SPELLS\\Death_Rune",
	[25] = "SPELLS\\DemonRune6",
	[26] = "SPELLS\\DemonRune7",
	[27] = "Spells\\DemonRune5backup",
	-- Icon Types
	[28] = "Particles\\Intellect128_outline",
	[29] = "Spells\\Intellect_128",
	[30] = "SPELLS\\GHOST1",
	[31] = "Spells\\Aspect_Beast",
	[32] = "Spells\\Aspect_Hawk",
	[33] = "Spells\\Aspect_Wolf",
	[34] = "Spells\\Aspect_Snake",
	[35] = "Spells\\Aspect_Cheetah",
	[36] = "Spells\\Aspect_Monkey",
	[37] = "Spells\\Blobs",
	[38] = "Spells\\Blobs2",
	[39] = "Spells\\GradientCrescent2",
	[40] = "Spells\\InnerFire_Rune_128",
	[41] = "Spells\\RapidFire_Rune_128",
	[42] = "Spells\\Protect_128",
	[43] = "Spells\\Reticle_128",
	[44] = "Spells\\Star2A",
	[45] = "Spells\\Star4",
	[46] = "Spells\\Strength_128",
	[47] = "Particles\\STUNWHIRL",
	[48] = "SPELLS\\BloodSplash1",
	[49] = "SPELLS\\DarkSummon",
	[50] = "SPELLS\\EndlessRage",
	[51] = "SPELLS\\Rampage",
	[52] = "SPELLS\\Eye",
	[53] = "SPELLS\\Eyes",
	[54] = "SPELLS\\Zap1b",
};

Fonts =
{
	-- Wow Fonts
	[1] = STANDARD_TEXT_FONT, -- "Fonts\\FRIZQT__.TTF"
	[2] = "Fonts\\ARIALN.TTF",
	[3] = "Fonts\\skurri.ttf",
	-- External Fonts
	[4] = "Interface\\Addons\\PowerAuras\\Fonts\\AllStar.ttf",
	[5] = "Interface\\Addons\\PowerAuras\\Fonts\\Army.ttf",
	[6] = "Interface\\Addons\\PowerAuras\\Fonts\\Army Condensed.ttf",
	[7] = "Interface\\Addons\\PowerAuras\\Fonts\\Army Expanded.ttf",
	[8] = "Interface\\Addons\\PowerAuras\\Fonts\\Blazed.ttf",
	[9] = "Interface\\Addons\\PowerAuras\\Fonts\\Blox.ttf",
	[10] = "Interface\\Addons\\PowerAuras\\Fonts\\Cloister Black.ttf",
	[11] = "Interface\\Addons\\PowerAuras\\Fonts\\Hexagon.ttf",
	[12] = "Interface\\Addons\\PowerAuras\\Fonts\\Moonstar.ttf",
	[13] = "Interface\\Addons\\PowerAuras\\Fonts\\Morpheus.ttf",
	[14] = "Interface\\Addons\\PowerAuras\\Fonts\\Neon.ttf",
	[15] = "Interface\\Addons\\PowerAuras\\Fonts\\Pulse Virgin.ttf",
	[16] = "Interface\\Addons\\PowerAuras\\Fonts\\Punks Not Dead.ttf",
	[17] = "Interface\\Addons\\PowerAuras\\Fonts\\Starcraft.ttf",
	[18] = "Interface\\Addons\\PowerAuras\\Fonts\\Whoa.ttf",
};

TimerTextures =
{
	"Original",
	"AccidentalPresidency",
	"Crystal",
	"Digital",
	"Monofonto",
	"OCR",
	"WhiteRabbit",
};

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
	["Gold"] = "|cffffff00",
};

SetColours =
{
	["PowaTargetButton"] = {r=1.0, g=0.2, b=0.2},
	["PowaTargetFriendButton"] = {r=0.2, g=1.0, b=0.2},
	["PowaPartyButton"] = {r=0.2, g=1.0, b=0.2},
	["PowaGroupOrSelfButton"] = {r=0.2, g=1.0, b=0.2},
	["PowaFocusButton"] = {r=0.2, g=1.0, b=0.2},
	["PowaRaidButton"] = {r=0.2, g=1.0, b=0.2},
	["PowaOptunitnButton"] = {r=0.2, g=1.0, b=0.2},
};

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
	"PowaRoleRangeDpsButton",
};

OptionTernary = {};

OptionHideables =
{
	"PowaGroupAnyButton",
	"PowaBarTooltipCheck",
	"PowaBarThresholdSlider",
	"PowaThresholdInvertButton",
	"PowaBarBuffStacks",
	"PowaDropDownStance",
	"PowaDropDownGTFO",
	"PowaDropDownPowerType",
};

Backdrop =
{
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	insets = {left = 0, top = 0, right = 0, bottom = 0},
	tile = true
};
};

function PowaAuras:RegisterAuraType(auraType)
	self.AurasByType[auraType] = {};
	table.insert(self.AurasByTypeList, auraType);
end

PowaAuras:RegisterAuraType('Buffs');
PowaAuras:RegisterAuraType('TargetBuffs');
PowaAuras:RegisterAuraType('PartyBuffs');
PowaAuras:RegisterAuraType('RaidBuffs');
PowaAuras:RegisterAuraType('GroupOrSelfBuffs');
PowaAuras:RegisterAuraType('UnitBuffs');
PowaAuras:RegisterAuraType('FocusBuffs');

PowaAuras:RegisterAuraType('Health');
PowaAuras:RegisterAuraType('TargetHealth');
PowaAuras:RegisterAuraType('FocusHealth');
PowaAuras:RegisterAuraType('PartyHealth');
PowaAuras:RegisterAuraType('RaidHealth');
PowaAuras:RegisterAuraType('NamedUnitHealth');

PowaAuras:RegisterAuraType('Mana');
PowaAuras:RegisterAuraType('TargetMana');
PowaAuras:RegisterAuraType('FocusMana');
PowaAuras:RegisterAuraType('PartyMana');
PowaAuras:RegisterAuraType('RaidMana');
PowaAuras:RegisterAuraType('NamedUnitMana');

PowaAuras:RegisterAuraType('Power');
PowaAuras:RegisterAuraType('TargetPower');
PowaAuras:RegisterAuraType('PartyPower');
PowaAuras:RegisterAuraType('RaidPower');
PowaAuras:RegisterAuraType('FocusPower');
PowaAuras:RegisterAuraType('NamedUnitPower');

PowaAuras:RegisterAuraType('Combo');
PowaAuras:RegisterAuraType('Aoe');

PowaAuras:RegisterAuraType('Stance');
PowaAuras:RegisterAuraType('Actions');
PowaAuras:RegisterAuraType('Enchants');

PowaAuras:RegisterAuraType('PvP');
PowaAuras:RegisterAuraType('PartyPvP');
PowaAuras:RegisterAuraType('RaidPvP');
PowaAuras:RegisterAuraType('TargetPvP');

PowaAuras:RegisterAuraType('Aggro');
PowaAuras:RegisterAuraType('PartyAggro');
PowaAuras:RegisterAuraType('RaidAggro');

PowaAuras:RegisterAuraType('Spells');
PowaAuras:RegisterAuraType('TargetSpells');
PowaAuras:RegisterAuraType('FocusSpells');
PowaAuras:RegisterAuraType('PlayerSpells');
PowaAuras:RegisterAuraType('PartySpells');
PowaAuras:RegisterAuraType('RaidSpells');
PowaAuras:RegisterAuraType('GroupOrSelfSpells');

PowaAuras:RegisterAuraType('StealableSpells');
PowaAuras:RegisterAuraType('StealableTargetSpells');
PowaAuras:RegisterAuraType('StealableFocusSpells');

PowaAuras:RegisterAuraType('PurgeableSpells');
PowaAuras:RegisterAuraType('PurgeableTargetSpells');
PowaAuras:RegisterAuraType('PurgeableFocusSpells');

PowaAuras:RegisterAuraType('SpellCooldowns');

PowaAuras:RegisterAuraType('Static');

PowaAuras:RegisterAuraType('Totems');
PowaAuras:RegisterAuraType('Pet');
PowaAuras:RegisterAuraType('Runes');
PowaAuras:RegisterAuraType('Slots');
PowaAuras:RegisterAuraType('Items');
PowaAuras:RegisterAuraType('Tracking');

PowaAuras:RegisterAuraType('UnitMatch');
PowaAuras:RegisterAuraType("PetStance");

PowaAuras:RegisterAuraType('GTFOHigh');
PowaAuras:RegisterAuraType('GTFOLow');
PowaAuras:RegisterAuraType('GTFOFail');
PowaAuras:RegisterAuraType('GTFOFriendlyFire');

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
	MONK = 100780, -- Jab
};

-- Invented so we can distinquish them two types
SPELL_POWER_LUNAR_ECLIPSE = 108;
SPELL_POWER_SOLAR_ECLIPSE = 208;

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
	[SPELL_POWER_HOLY_POWER] = 5,
	[SPELL_POWER_ALTERNATE_POWER] = 100,
	[SPELL_POWER_DARK_FORCE] = 5,
	[SPELL_POWER_CHI] = 5,
	[SPELL_POWER_SHADOW_ORBS] = 3,
	[SPELL_POWER_BURNING_EMBERS] = 4,
	[SPELL_POWER_DEMONIC_FURY] = 1000
};

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
	[SPELL_POWER_HOLY_POWER] = "",
	[SPELL_POWER_ALTERNATE_POWER] = "",
	[SPELL_POWER_DARK_FORCE] = "",
	[SPELL_POWER_CHI] = "",
	[SPELL_POWER_SHADOW_ORBS] = "",
	[SPELL_POWER_BURNING_EMBERS] = "",
	[SPELL_POWER_DEMONIC_FURY] = ""
};

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
	[SPELL_POWER_HOLY_POWER] = "spell_holy_lightsgrace",
	[SPELL_POWER_ALTERNATE_POWER] = "inv_battery_02",
	[SPELL_POWER_DARK_FORCE] = "spell_arcane_arcanetorrent",
	[SPELL_POWER_CHI] = "class_monk",
	[SPELL_POWER_SHADOW_ORBS] = "spell_priest_shadoworbs",
	[SPELL_POWER_BURNING_EMBERS] = "ability_warlock_burningembers",
	[SPELL_POWER_DEMONIC_FURY] = "ability_warlock_eradication"
};

PowaAuras.TalentChangeSpells =
{
	[PowaAuras.Spells.ACTIVATE_FIRST_TALENT] = true,
	[PowaAuras.Spells.ACTIVATE_SECOND_TALENT] = true,
	[PowaAuras.Spells.BUFF_FROST_PRESENCE] = true,
	[PowaAuras.Spells.BUFF_BLOOD_PRESENCE] = true,
	[PowaAuras.Spells.BUFF_UNHOLY_PRESENCE] = true,
};

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
	[29703]	= PowaAuras.DebuffCatType.Snare,	-- Dazed
};

PowaAuras.Text = {};

function PowaAuras:UnitTestDebug(...)

end

function PowaAuras:UnitTestInfo(...)

end

function PowaAuras:Debug(...)
	if (PowaMisc.debug == true) then
		self:Message(...) --OK
	end
	--self:UnitTestDebug(...);
end

function PowaAuras:Message(...)
	args={...};
	if (args==nil or #args==0) then
		return;
	end
	local Message = "";
	for i=1, #args do
		Message = Message..tostring(args[i]);
	end
	DEFAULT_CHAT_FRAME:AddMessage(Message);
end

-- Use this for temp debug messages
function PowaAuras:ShowText(...)
	self:Message(...); -- OK
end

-- Use this for real messages instead of ShowText
function PowaAuras:DisplayText(...)
	self:Message(...);
end

function PowaAuras:DisplayTable(t, indent)
	if (not t or type(t)~="table") then
		return "No table";
	end
	if (indent == nil) then
		indent = "";
	else
		indent = indent .. "  ";
	end
	for i,v in pairs(t) do
		if (type(v)~="function") then
			if (type(v)~="table") then
				self:Message(indent..tostring(i).." = "..tostring(v))
			else
				self:Message(indent..tostring(i))
				self:DisplayTable(v, indent);
			end
		end
	end
end

-- This function will print a Message to the GUI screen (not the chat window) then fade.
function PowaAuras:Error( msg, holdtime )
	if (holdtime==nil) then
		holdtime = UIERRORS_HOLD_TIME;
	end
	UIErrorsFrame:AddMessage(msg, 0.75, 0.75, 1.0, 1.0, holdtime);
end

function PowaAuras:IsNumeric(a)
	return type(tonumber(a)) == "number";
end

function PowaAuras:ReverseTable(t)
	if (type(t)~="table") then return nil; end
	local newTable = {};
	for k,v in pairs(t) do
		newTable[v] = k;
	end
	return newTable;
end

function PowaAuras:TableEmpty(t)
	if (type(t)~="table") then return nil; end
	for k in pairs(t) do
		return false;
	end
	return true;
end

function PowaAuras:TableSize(t)
	if (type(t)~="table") then return nil; end
	local size = 0;
	for k in pairs(t) do
		size = size + 1;
	end
	return size;
end

function PowaAuras:CopyTable(t, lookup_table, original)
	if (type(t)~="table") then
		return t;
	end
	local copy;
	if (original==nil) then
		copy = {};
	else
		copy = original;
	end
	for i,v in pairs(t) do
		if (type(v)~="function") then
			if (type(v)~="table") then
				copy[i] = v;
			else
				lookup_table = lookup_table or {};
				lookup_table[t] = copy;
				if lookup_table[v] then
					copy[i] = lookup_table[v]; -- We already copied this table. Reuse the copy.
				else
					copy[i] = self:CopyTable(v, lookup_table); -- Not yet copied. Copy it.
				end
			end
		end
	end
	return copy
end

function PowaAuras:MergeTables(desTable, sourceTable)
	if (not sourceTable or type(sourceTable)~="table") then
		return;
	end
	if (not desTable or type(desTable)~="table") then
		desTable = sourceTable;
		return;
	end
	for i,v in pairs(sourceTable) do
		if (type(v)~="function") then
			if (type(v)~="table") then
				desTable[i] = v;
			else
				if (not desTable[i] or type(desTable[i])~="table") then
					desTable[i] = {};
				end
				self:MergeTables(desTable[i], v);
			end
		end
	end
end

function PowaAuras:InsertText(text, ...)
	args={...};
	if (args==nil or #args==0) then
		return text;
	end
	for k, v in pairs(args) do
		text = string.gsub(text, "$"..k, tostring(v));
	end
	return text;
end

function PowaAuras:MatchString(textToSearch, textToFind, ingoreCase)
	if (textToSearch==nil) then
		return textToFind==nil;
	end
	if (ingoreCase) then
		textToFind = string.upper(textToFind);
		textToSearch = string.upper(textToSearch);
	end
	return string.find(textToSearch, textToFind, 1, true)
end

function PowaAuras:Different(o1, o2)
	local t1 = type(t1);
	local t2 = type(t2);
	if (t1~=t2 or t1 == "string" or t2 == "string") then
		return tostring(o1)~=tostring(o2);
	end
	if (t1=="number") then
		return math.abs(o1-o2) > 1e-9;
	end
	return o1 ~= o2;
end

function PowaAuras:GetSettingForExport(prefix, k, v, default)
	-- Causes an unreproducable bug. Will increase size of export codes, but at least they work.
	if (not self:Different(v, default) and not PowaGlobalMisc.FixExports) then return ""; end
	local varType = type(v);
	local setting = prefix..k..":";
	if (varType == "string") then
		setting = setting..v;
	elseif(varType == "number") then
		local round = math.floor(v * 10000 + 0.5) / 10000;
		setting = setting..tostring(round);
	else
		setting = setting..tostring(v);
	end
	return setting.."; ";
end

-- PowaAura Classes
function PowaClass(base,ctor)
	local c = {} -- A new class instance
	if not ctor and type(base) == 'function' then
		ctor = base;
		base = nil;
	elseif type(base) == 'table' then
		-- Our new class is a shallow copy of the base class!
		for i,v in pairs(base) do
			c[i] = v;
		end
		if (type(ctor)=="table") then
			for i,v in pairs(ctor) do
				c[i] = v;
			end
			ctor = nil;
		end
		c._base = base;
	end
	-- The class will be the metatable for all its objects,
	-- And they will look up their methods in it.
	c.__index = c
	-- Expose a ctor which can be called by <classname>(<args>)
	local mt = {}
	mt.__call = function(class_tbl,...)
		local obj = {}
		setmetatable(obj,c)
		if ctor then
			--PowaAuras:ShowText("Call constructor "..tostring(ctor));
			ctor(obj,...)
		end
		return obj
	end
	if ctor then
		c.init = ctor;
	else
		if base and base.init then
			c.init = base.init;
			ctor = base.init;
		end
	end
	c.is_a = function(self,klass)
		local m = getmetatable(self)
		while m do
			if m == klass then return true end
			m = m._base
		end
		return false
	end
	setmetatable(c,mt)
	return c
end