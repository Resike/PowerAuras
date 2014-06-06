local _, ns = ...
local PowaAuras = ns.PowaAuras

PowaAuras.Anim[0] = "[Invisible]"
PowaAuras.Anim[1] = "Static"
PowaAuras.Anim[2] = "Flashing"
PowaAuras.Anim[3] = "Growing"
PowaAuras.Anim[4] = "Pulse"
PowaAuras.Anim[5] = "Bubble"
PowaAuras.Anim[6] = "Water drop"
PowaAuras.Anim[7] = "Electric"
PowaAuras.Anim[8] = "Shrinking"
PowaAuras.Anim[9] = "Flame"
PowaAuras.Anim[10] = "Orbit"
PowaAuras.Anim[11] = "Spin Clockwise"
PowaAuras.Anim[12] = "Spin Anti-Clockwise"

PowaAuras.BeginAnimDisplay[0] = "[None]"
PowaAuras.BeginAnimDisplay[1] = "Zoom In"
PowaAuras.BeginAnimDisplay[2] = "Zoom Out"
PowaAuras.BeginAnimDisplay[3] = "Fade In"
PowaAuras.BeginAnimDisplay[4] = "Left"
PowaAuras.BeginAnimDisplay[5] = "Top-Left"
PowaAuras.BeginAnimDisplay[6] = "Top"
PowaAuras.BeginAnimDisplay[7] = "Top-Right"
PowaAuras.BeginAnimDisplay[8] = "Right"
PowaAuras.BeginAnimDisplay[9] = "Bottom-Right"
PowaAuras.BeginAnimDisplay[10] = "Bottom"
PowaAuras.BeginAnimDisplay[11] = "Bottom-Left"
PowaAuras.BeginAnimDisplay[12] = "Bounce"

PowaAuras.EndAnimDisplay[0] = "[None]"
PowaAuras.EndAnimDisplay[1] = "Grow"
PowaAuras.EndAnimDisplay[2] = "Shrink"
PowaAuras.EndAnimDisplay[3] = "Fade Out"
PowaAuras.EndAnimDisplay[4] = "Spin"
PowaAuras.EndAnimDisplay[5] = "Spin In"

PowaAuras.Sound[0] = "None"
PowaAuras.Sound[30] = "None"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Type /powa to view the options.",

aucune = "None",
aucun = "None",
mainHand = "main",
offHand = "off",
bothHands = "both",
Unknown = "unknown",

DebuffType =
{
	Magic = "Magic",
	Disease = "Disease",
	Curse = "Curse",
	Poison = "Poison",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "Silence",
	[PowaAuras.DebuffCatType.Snare] = "Snare",
	[PowaAuras.DebuffCatType.Stun] = "Stun",
	[PowaAuras.DebuffCatType.Root] = "Root",
	[PowaAuras.DebuffCatType.Disarm] = "Disarm",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

Role =
{
	RoleTank = "Tank",
	RoleHealer = "Healer",
	RoleMeleDps = "Melee DPS",
	RoleRangeDps = "Ranged DPS"
},

nomReasonRole =
{
	RoleTank = "Is a Tank",
	RoleHealer = "Is a Healer",
	RoleMeleDps = "Is a Melee DPS",
	RoleRangeDps = "Is a Ranged DPS"
},

nomReasonNotRole =
{
	RoleTank = "Not a Tank",
	RoleHealer = "Not a Healer",
	RoleMeleDps = "Not a Melee DPS",
	RoleRangeDps = "Not a Ranged DPS"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Buff",
	[PowaAuras.BuffTypes.Debuff] = "Debuff",
	[PowaAuras.BuffTypes.AoE] = "AOE Debuff",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debuff type",
	[PowaAuras.BuffTypes.Enchant] = "Weapon Enchant",
	[PowaAuras.BuffTypes.Combo] = "Combo Points",
	[PowaAuras.BuffTypes.ActionReady] = "Action Usable",
	[PowaAuras.BuffTypes.Health] = "Health",
	[PowaAuras.BuffTypes.Mana] = "Mana",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Rage/Energy/Power",
	[PowaAuras.BuffTypes.Aggro] = "Aggro",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "Stance/Seal/Form",
	[PowaAuras.BuffTypes.SpellAlert] = "Spell Alert",
	[PowaAuras.BuffTypes.SpellCooldown] = "Spell Cooldown",
	[PowaAuras.BuffTypes.StealableSpell] = "Stealable Spell",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Purgeable Spell",
	[PowaAuras.BuffTypes.Static] = "Static Aura",
	[PowaAuras.BuffTypes.Totems] = "Totems",
	[PowaAuras.BuffTypes.Pet] = "Pet",
	[PowaAuras.BuffTypes.Runes] = "Runes",
	[PowaAuras.BuffTypes.Slots] = "Equipment Slots",
	[PowaAuras.BuffTypes.Items] = "Named Items",
	[PowaAuras.BuffTypes.Tracking] = "Tracking",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
	[PowaAuras.BuffTypes.PetStance] = "Pet Stance",
	[PowaAuras.BuffTypes.GTFO] = "GTFO Alert"
},

PowerType =
{
	[-1] = "Default",
	[SPELL_POWER_RAGE] = "Rage",
	[SPELL_POWER_FOCUS] = "Focus",
	[SPELL_POWER_ENERGY] = "Energy",
	[SPELL_POWER_RUNIC_POWER] = "Runic Power",
	[SPELL_POWER_SOUL_SHARDS] = "Soul Shards",
	[SPELL_POWER_LUNAR_ECLIPSE] = "Lunar Eclipse",
	[SPELL_POWER_SOLAR_ECLIPSE] = "Solar Eclipse",
	[SPELL_POWER_HOLY_POWER] = "Holy Power",
	[SPELL_POWER_ALTERNATE_POWER] = "Boss Power",
	[SPELL_POWER_DARK_FORCE] = "Dark Force",
	[SPELL_POWER_CHI] = "Chi",
	[SPELL_POWER_SHADOW_ORBS] = "Shadow Orbs",
	[SPELL_POWER_BURNING_EMBERS] = "Burning Embers",
	[SPELL_POWER_DEMONIC_FURY] = "Demonic Fury"
},

Relative =
{
	NONE = "Free",
	TOPLEFT = "Top-Left",
	TOP = "Top",
	TOPRIGHT = "Top-Right",
	RIGHT = "Right",
	BOTTOMRIGHT = "Bottom-Right",
	BOTTOM = "Bottom",
	BOTTOMLEFT = "Bottom-Left",
	LEFT = "Left",
	CENTER = "Center"
},

Slots =
{
	Back = "Back",
	Chest = "Chest",
	Feet = "Feet",
	Finger0 = "Finger1",
	Finger1 = "Finger2",
	Hands = "Hands",
	Head = "Head",
	Legs = "Legs",
	MainHand = "MainHand",
	Neck = "Neck",
	SecondaryHand = "OffHand",
	Shirt = "Shirt",
	Shoulder = "Shoulder",
	Tabard = "Tabard",
	Trinket0 = "Trinket1",
	Trinket1 = "Trinket2",
	Waist = "Waist",
	Wrist = "Wrist"
},

SlotsToCheck = "Select Slots to Check",

Okay = "Okay",
Cancel = "Cancel",

-- Main
nomEnable = "Enable Power Auras",
aideEnable = "Enable all Power Aura effects.",

nomDebug = "Activate Debug Messages",
aideDebug = "Enable Debug Messages.",
nomTextureCount = "Max Textures",
aideTextureCount = "Change this if you add your own textures",

aideOverrideTextureCount = "Set this if you are adding your own textures.",
nomOverrideTextureCount = "Override the number of textures.",

ListePlayer = "Page",
ListeGlobal = "Global",
aideMove = "Move the effect here.",
aideCopy = "Copy the effect here.",
nomRename = "Rename",
aideRename = "Rename the currently selected aura page.",

nomTest = "Test",
nomTestAll = "Test All",
nomHide = "Hide all",
nomEdit = "Edit",
nomDonate = "Donate",
nomNew = "New",
nomDel = "Delete",
nomImport = "Import",
nomExport = "Export",
nomImportSet = "Import Set",
nomExportSet = "Export Set",
nomUnlock = "Unlock",
nomLock = "Lock",

aideImport = "Press Ctrl-V to paste the Aura-string and press \'Import\'.",
aideExport = "Press Ctrl-C to copy the Aura-string for sharing.",
aideImportSet = "Press Ctrl-V to paste the Aura-Set-string and press \'Import\' this will erase all auras on this page.",
aideExportSet = "Press Ctrl-C to copy all the Auras on this page for sharing.",
aideDel = "Delete the currently selected aura. (Hold Ctrl to allow this button to work.)",

nomMove = "Move",
nomCopy = "Copy",
nomPlayerEffects = "Character effects",
nomGlobalEffects = "Global\neffects",

aideEffectTooltip = "Shift-click to toggle effect on/off.",
aideEffectTooltip2 = "Ctrl-click to self check.",
aideEffectTooltip3 = "Alt-click to set group size.",

aideItems = "Enter full name of Item or [xxx] for ID.",
aideSlots = "Enter name of slot to track: Back, Chest, Feet, Finger0, Finger1, Hands, Head, Legs, MainHand, Neck, SecondaryHand, Shirt, Shoulder, Tabard, Trinket0, Trinket1, Waist, Wrist.",
aideTracking = "Enter name of Tracking type. e.g. fish",
aideUnitMatch = "Enter the names of the units that need to match, separated by a forward slash (/).\n\nYou can use unit ID's such as \"player\", \"pet\", \"boss1\", \"arena1\", as well as an asterisk (*) to see if the unit in question exists.\n\n|cFFEFEFEFExamples|r\nTarget is Ragnaros:\ntarget/Ragnaros\n\nPet target exists:\npettarget/*\n\nBoss targetting me:\nboss1target/player",
aidePetStance = "Enter the ID numbers of pet stances that need to be active in order for the aura to show. You can specify multiple stances to trigger an aura by separating them with a forward slash (/).\n\n|cFFEFEFEFStance ID Numbers|r\nAssist = 1\nDefensive = 2\nPassive = 3\n\n|cFFFF0000Note: |rYou must have the three stances on your pet action bar for this to work.",

-- Editor
aideCustomText = "Enter text to display. (%n=buff/debuff name, %t=target name, %f=focus name, %u=unit name, %str=str, %agl=agl, %sta=sta, %int=int, %spi=spi, %sp=spell power, %ap=attack power, %crt=critical strike)",

nomSound = "Starting Sound:",

nomSound2 = "Custom Starting Sound:",
aideSound = "Plays a sound at the beginning.",
aideSound2 = "Plays a sound at the beginning.",
nomCustomSound = "Custom Starting Soundfile:",
aideCustomSound = "Enter a soundfile that is in the Sounds folder.\nSupported file formats: .mp3, .wav and .ogg, you must copy the file before you start the game.\nExamples: 'cookie.mp3', 'Sound\\Events\\\nGuldanCheers.wav'.",

nomCustomSoundPath = "Path to custom sounds:",
aideCustomSoundPath = "Set this to your own path (within the WoW install folder) to prevent your own sounds being overwritten by updating Power Auras.",

nomCustomAuraPath = "Path to custom aura textures:",
aideCustomAuraPath = "Set this to your own path (within the WoW install folder) to prevent your own textures being overwritten by updating Power Auras.",

nomSoundEnd = "Ending Sound:",
nomSound2End = "Custom Ending Sound:",
aideSoundEnd = "Plays a sound at the end.",
aideSound2End = "Plays a sound at the end.",
nomCustomSoundEnd = "Custom Ending Soundfile:",
aideCustomSoundEnd = "Enter a soundfile that is in the Sounds folder.\nSupported file formats: .mp3, .wav and .ogg, you must copy the file before you start the game.\nExamples: 'cookie.mp3', 'Sound\\Events\\\nGuldanCheers.wav'.",
nomTexture = "Texture",
aideTexture = "The texture to be shown. You can easily replace textures by changing the files Aura#.tga in the Addon's directory.",
nomModel = "Model",

nomAnim1 = "Main Animation",
nomAnim2 = "Secondary Animation",
aideAnim1 = "Animate the texture or not, with various effects.",
aideAnim2 = "This animation will be shown with less opacity than the main animaton.",

nomDeform = "Deformation",

aideColor = "Click here to change the base color of the texture.",
aideTimerColor = "Click here to change the color of the timer.",
aideStacksColor = "Click here to change the color of the stacks.",
aideSecondaryColor = "Click here to change the secondary color of the texture.",
nomFont = "Font",
nomFontSelector = "Font Selector",
aideFont = "Click here to pick Font. Press Okay to apply the selection.",
aideMultiID = "Enter here other Aura IDs to combine checks. Multiple IDs must be separated with '/'. Aura ID can be found as [#] on first line of Aura tooltip.",
aideTooltipCheck = "Also check the tooltip contains this text.",

aideBuff = "Enter here the name or id of the buff, or a part of the name, which must activate/deactivate the effect. You can also enter several names/ids. (ex: Super Buff/Power/12345)",
aideBuff2 = "Enter here the name or id of the debuff, or a part of the name, which must activate/deactivate the effect. You can also enter several names/ids. (ex: Dark Disease/Plague/12345)",
aideBuff3 = "Enter here the type of the debuff which must activate or deactivate the effect. (Poison, Disease, Curse, Magic, CC, Silence, Stun, Snare, Root or None) You can also enter several types. (ex: Disease/Poison)",
aideBuff4 = "Enter here the name of area of effect that must trigger this effect. (like a rain of fire for example, the name of this AOE can be found in the combat log)",
aideBuff5 = "Enter here the temporary enchant which must activate this effect: optionally prepend it with 'main/' or 'off/ to designate mainhand or offhand slot. (ex: main/crippling)",
aideBuff6 = "Enter here the number of combo points that must activate this effect. (ex : 1 or 1/2/3 or 0/4/5 etc...)",
aideBuff7 = "Enter here the name, or a part of the name, of an action in your action bars. The effect will be active when this action is usable.",
aideBuff8 = "Enter here the full name or id of a spell from your spellbook. You can only enter one spell/id for one aura.",

aideSpells = "Enter here the Spell Name that will trigger a spell alert Aura.",
aideStacks = "Enter here the operator and the amount of stacks, required activate/deactivate the effect. Operator is required. ex: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "Enter here the Stealable Spell Name that will trigger the Aura. (use * for any stealable spell)",
aidePurgeableSpells = "Enter here the Purgeable Spell Name that will trigger the Aura. (use * for any purgeable spell)",

aideTotems = "Enter here the Totem Name or part of it's name, that will trigger the Aura or a number. 1 = Fire, 2 = Earth, 3 = Water, 4 = Air. (Enter 'totem' for any totems.)",

aideRunes = "Enter here the Runes that will trigger the Aura. B/b=Blood, F/f=frost, U/u=Unholy, D/d=Death. (Death runes will count as the other types if you use uppercase or the ignorecase flag is set) ex: 'BF' 'BfU' 'DDD'",

aideUnitn = "Enter here the name of the unit, which must activate/deactivate the effect. You can enter only names, if they are in your raid or group.",
aideUnitn2 = "Only for raid/group.",

aideMaxTex = "Define the maximum number of textures available on the Effect Editor. If you add textures on the Mod directory (with the names AURA1.tga to AURA50.tga), you must indicate the correct number here.",
aideWowTextures = "Check this to use the texture of WoW instead of textures in the Power Auras directory.",
aideTextAura = "Check this to type text instead of texture.",
nomModels = "Models",
nomCustomModels = "Custom",
aideModels = "Check this to use 3D models from the game.",
aideCustomModels = "Check this to use custom 3D models from the game.",
aideCustomModelsEditbox = "Enter the model's path here.\n(ex: 'Creature\\MurlocCostume\\MurlocCostume.m2')",
aideRealaura = "Real Aura",
aideCustomTextures = "Check this to use textures from the set up 'Custom' folder.",
aideCustomTextureEditbox = "Enter the name of the texture here. (ex: myTexture.tga).\nYou can also use a Spell Name (ex: Feign Death) or SpellID (ex: 5384).",
aideRandomColor = "Check this to use random color for the aura each time it will be activated.",
aideDesaturate = "Check this to desaturate the current aura's color.",
aideEnableFullRotation = "Check this to enable whole 0-360° rotation for the rotation slider.",
nomLevel = "Level",
nomSublevel = "Sublevel",
nomModelZ = "Model Z",
nomModelX = "Model X",
nomModelY = "Model Y",
nomAnimation = "Animation",
nomDefault = "Default",

aideTexMode = "Uncheck this to use the texture opacity. By default, the darkest colors will be more transparent.",

nomActivationBy = "Activation by",

nomOwnTex = "Own Texture",
aideOwnTex = "Use the selected buff/debuff or ability's texture instead.",
nomRoundIcons = "Rounded Icon",
aideRoundIcons = "Enable this to use rounded icon.",
nomStacks = "Stacks",

nomUpdateSpeed = "Update speed",
nomSpeed = "Animation speed",
nomTimerUpdate = "Timer update speed",
nomBegin = "Begin Animation",
nomEnd = "End Animation",
nomSymetrie = "Symmetry",
nomAlpha = "Opacity",
nomPos = "Position",
nomRotation = "Rotation",
nomTaille = "Size",

nomExact = "Exact Name",
nomThreshold = "Threshold",
aideThreshInv = "Check this to invert the threshold logic.",
nomThreshInv = "Invert",
nomStance = "Stance",
nomGTFO = "Alert Type",
nomPowerType = "Power Type",

nomMine = "Cast by me",
aideMine = "Check this to test only buffs/debuffs cast by the player.",
nomDispellable = "Dispellable",
aideDispellable = "Check to show only buffs that are dispellable.",
nomCanInterrupt = "Interruptable",
aideCanInterrupt = "Check to show only for spells that can be Interrupted.",
nomIgnoreUseable = "Cooldown Only",
aideIgnoreUseable = "Ignores when spell is usable.",
nomSpellLearned = "Spell Learned",
aideSpellLearned = "Check to show only for learned spells",
nomIgnoreItemUseable = "Equipped Only",
aideIgnoreItemUseable = "Ignores if item is usable.",
nomCheckPet = "Pet",
aideCheckPet = "Check to Monitor only Pet Spells.",

nomOnMe = "Cast on Me",
aideOnMe = "Only show if being cast on me.",

nomPlayerSpell = "Player Casting",
aidePlayerSpell = "Check if Player is casting a spell.",

nomCheckTarget = "Enemy Target",
nomCheckFriend = "Friendly Target",
nomCheckParty = "Party Member",
nomCheckFocus = "Focus",
nomCheckRaid = "Raid Member",
nomCheckGroupOrSelf = "Self/Party/Raid",
nomCheckGroupAny = "Any Member",
nomCheckOptunitn = "Unit Name",
nomPetCooldown = "Pet Cooldown",

aideTarget = "Check this to test an enemy target only.",
aideTargetFriend = "Check this to test a friendly target only.",
aideParty = "Check this to test a party member only.",
aideGroupOrSelf = "Check this to test a party or raid member or self.",
aideFocus = "Check this to test the focus only.",
aideRaid = "Check this to test a raid member only.",
aideGroupAny = "Check this to test buff on 'Any' party/raid member. Unchecked: Test that 'All' are buffed.",
aideOptunitn = "Check this to test a special character in party/raid group only.",
aideExact = "Check this to test the exact name of the buff/debuff/action.",
aideStance = "Select which Stance, Aura or Form trigger the event.",
aideGTFO = "Select which GTFO Alert will trigger the event.",
aidePowerType = "Select which type of resource to track.",

nomCheckShowSpinAtBeginning = "Spin the aura after shown",
aideShowSpinAtBeginning = "Spin the aura 360° after the begin animation ends.",

nomCheckShowTimer = "Show Timer",
nomTimerDuration = "Duration",
aideTimerDuration = "Show a timer to simulate buff/debuff duration on the target. (0 to deactivate)",
aideShowTimer = "Check this to show the timer of this effect.",
aideSelectTimer = "Select which timer will show the duration.",
aideSelectTimerBuff = "Select which timer will show the duration. (This one is reserved for player's buffs)",
aideSelectTimerDebuff = "Select which timer will show the duration. (This one is reserved for player's debuffs)",

nomCheckShowStacks = "Show Stacks",
aideShowStacks = "Activate this to show the stacks for this effect.",

nomCheckInverse = "Invert",
aideInverse = "Invert the logic to show this effect only when buff/debuff is not active.",

nomCheckIgnoreMaj = "Ignore Case",
aideIgnoreMaj = "Check this to ignore upper/lowercase of buff/debuff names.",

nomAuraDebug = "Debug",
aideAuraDebug = "Enable debugging this aura.",

nomDuration = "Animation duration",
aideDuration = "After this time, this effect will disapear. (0 to deactivate)",

nomOldAnimations = "Old Animations",
aideOldAnimations = "Use Old Animations",

nomCentiemes = "Show hundredths",
nomDual = "Show two timers",
nomHideLeadingZeros = "Hide leading zeros",
nomTransparent = "Use transparent textures",
nomActivationTime = "Show time since activation",
nomTimer99 = "Only show seconds below 100",
nomUseOwnColor = "Use own color:",
nomUpdatePing = "Animate on refresh",
nomLegacySizing = "Wider Digits",
nomRelative = "Timer Position:",
nomRelativeStacks = "Stacks Postion:",
nomClose = "Close",
nomCopy = "Copy",
nomEffectEditor = "Effect Editor",
nomAdvOptions = "Options",
nomMaxTex = "Maximum of textures available",
nomTabAnim = "Animation",
nomTabActiv = "Activation",
nomTabSound = "Sound",
nomTabTimer = "Timer",
nomTabStacks = "Stacks",
nomWowTextures = "WoW Textures",
nomCustomTextures = "Custom Textures",
nomTextAura = "Text Aura",
nomBlendMode = "Blend Mode",
nomSecondaryBlendMode = "Secondary Blend Mode",
nomFrameStrata = "Frame's Strata",
nomSecondaryFrameStrata = "Secondary Frame's Strata",
nomTextureStrata = "Texture's Strata",
nomSecondaryTextureStrata = "Secondary Texture's Strata",
nomRealaura = "Real Aura",
nomColorPicker = "Base Color",
nomGradientStyle = "Gradient Style",
nomModelCategory = "Model Category",
nomModelTexture = "Model Texture",
nomSecondaryColorPicker = "Secondary Color",
nomRandomColor = "Random Colors",
nomDesaturate = "Desaturate",
nomEnableFullRotation = "Enable Full Rotation",

nomTalentGroup1 = "Primary Spec",
aideTalentGroup1 = "Show this effect only when you are in your primary talent spec.",
nomTalentGroup2 = "Secondary Spec",
aideTalentGroup2 = "Show this effect only when you are in your secondary talent spec.",

nomReset = "Reset Editor Positions",
nomPowaShowAuraBrowser = "Show Aura Browser",

nomDefaultTimerTexture = "Default Timer Texture:",
nomTimerTexture = "Timer Texture:",
nomDefaultStacksTexture = "Default Stacks Texture:",
nomStacksTexture = "Stacks Texture:",

Enabled = "Enabled",
Disabled = "Disabled",
Default = "Default",

Ternary =
{
	combat = "In Combat",
	inRaid = "In Raid",
	inParty = "In Party",
	isResting = "Resting",
	ismounted = "Mounted",
	inVehicle = "In Vehicle",
	inPetBattle = "In Pet Battle",
	isAlive = "Alive",
	PvP = "PvP flag",
	InstanceScenario = "Scenario",
	InstanceScenarioHeroic = "Scenario Hc",
	Instance5Man = "5 Man",
	Instance5ManHeroic = "5 Man Hc",
	InstanceChallengeMode = "Chall Mode",
	Instance10Man = "10 Man",
	Instance10ManHeroic = "10 Man Hc",
	Instance25Man = "25/40 Man",
	Instance25ManHeroic = "25 Man Hc",
	InstanceFlexible = "Flexible",
	InstanceBg = "Battleground",
	InstanceArena = "Arena"
},

nomWhatever = "Ignored",
aideTernary = "Sets how the status effects how this aura is shown.",

TernaryYes =
{
	combat = "Only when in Combat",
	inRaid = "Only when in Raid",
	inParty = "Only when in Party",
	isResting = "Only when Resting",
	ismounted = "Only when Mounted",
	inVehicle = "Only when in Vehicle",
	inPetBattle = "Only when in Pet Battle",
	isAlive = "Only When Alive",
	PvP = "Only when PvP flag set",
	InstanceScenario = "Only when in a Scenario Normal instance",
	InstanceScenarioHeroic = "Only when in a Scenario Heroic instance",
	Instance5Man = "Only when in a 5-Man Normal instance",
	Instance5ManHeroic = "Only when in a 5-Man Heroic instance",
	InstanceChallengeMode = "Only when in a Challenge Mode instance",
	Instance10Man = "Only when in a 10-Man Normal instance",
	Instance10ManHeroic = "Only when in a 10-Man Heroic instance",
	Instance25Man = "Only when in a 25-Man or 40-Man Normal instance",
	Instance25ManHeroic = "Only when in a 25-Man Heroic instance",
	InstanceFlexible = "Only when in a Flexible instance",
	InstanceBg = "Only when in a Battleground",
	InstanceArena = "Only when in an Arena instance",
	RoleTank = "Only when a Tank",
	RoleHealer = "Only when a Healer",
	RoleMeleDps = "Only when a Melee DPS",
	RoleRangeDps = "Only when a Ranged DPS"
},

TernaryNo =
{
	combat = "Only when not in Combat",
	inRaid = "Only when not in Raid",
	inParty = "Only when not in Party",
	isResting = "Only when not Resting",
	ismounted = "Only when not Mounted",
	inVehicle = "Only when not in Vehicle",
	inPetBattle = "Only when not in Pet Battle",
	isAlive = "Only when Dead",
	PvP = "Only when PvP flag Not set",
	InstanceScenario = "Only when not in a Scenario Normal instance",
	InstanceScenarioHeroic = "Only when Notin a Scenario Heroic instance",
	Instance5Man = "Only when not in a 5-Man Normal instance",
	Instance5ManHeroic = "Only when not in a 5-Man Heroic instance",
	InstanceChallengeMode = "Only when not in a Challenge Mode instance",
	Instance10Man = "Only when not in a 10-Man Normal instance",
	Instance10ManHeroic = "Only when not in a 10-Man Heroic instance",
	Instance25Man = "Only when not in a 25-Man or 40-Man Normal instance",
	Instance25ManHeroic = "Only when not in a 25-Man Heroic instance",
	InstanceFlexible = "Only when not in a Flexible instance",
	InstanceBg = "Only when not in a Battleground",
	InstanceArena = "Only when not in an Arena instance",
	RoleTank = "Only when Not a Tank",
	RoleHealer = "Only when Not a Healer",
	RoleMeleDps = "Only when Not a Melee DPS",
	RoleRangeDps = "Only when Not a Ranged DPS"
},

TernaryAide =
{
	combat = "Effect modified by Combat status.",
	inRaid = "Effect modified by Raid status.",
	inParty = "Effect modified by Party status.",
	isResting = "Effect modified by Resting status.",
	ismounted = "Effect modified by Mounted status.",
	inVehicle = "Effect modified by Vehicle status.",
	inPetBattle = "Effect modified by Pet Battle",
	isAlive = "Effect modified by Alive status.",
	PvP = "Effect modified by PvP flag.",
	InstanceScenario = "Effect modified by being in a Scenario Normal instance.",
	InstanceScenarioHeroic = "Effect modified by being in a Scenario Heroic instance.",
	Instance5Man = "Effect modified by being in a 5-Man Normal instance.",
	Instance5ManHeroic = "Effect modified by being in a 5-Man Heroic instance.",
	InstanceChallengeMode = "Effect modified by being in a Challenge Mode instance.",
	Instance10Man = "Effect modified by being in a 10-Man Normal instance.",
	Instance10ManHeroic = "Effect modified by being in a 10-Man Heroic instance.",
	Instance25Man = "Effect modified by being in a 25-Man or 40-Man Normal instance.",
	Instance25ManHeroic = "Effect modified by being in a 25-Man Heroic instance.",
	InstanceFlexible = "Effect modified by being in a Flexible instance.",
	InstanceBg = "Effect modified by being in a Battleground.",
	InstanceArena = "Effect modified by being in an Arena instance.",
	RoleTank = "Effect modified by being a Tank.",
	RoleHealer = "Effect modified by being a Healer.",
	RoleMeleDps = "Effect modified by being a Melee DPS.",
	RoleRangeDps = "Effect modified by being a Ranged DPS."
},

nomTimerInvertAura = "Invert Aura Timer",
aidePowaTimerInvertAuraSlider = "Invert the aura when the duration is less than this limit. (0 to deactivate)",
nomTimerHideAura = "Hide Aura and Timer Until Time Above",
aidePowaTimerHideAuraSlider = "Hide the aura and timer when the duration is greater than this limit. (0 to deactivate)",

aideTimerRounding = "When checked will round the timers up.",
nomTimerRounding = "Round Timers Up",

aideAllowInspections = "Allow Power Auras to Inspect players to determine roles, turning this off will sacrifice accuracy for speed.",
nomAllowInspections = "Allow Inspections",

nomCarried = "If in Bag",
aideCarried = "Ignores when item is usable.",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "Should show because $1",
nomReasonWontShow = "Won't show because $1",

nomReasonMulti = "All multiples match $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras Disabled",
nomReasonGlobalCooldown = "Ignore Global Cooldown",

nomReasonBuffPresent = "$1 has $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
nomReasonBuffMissing = "$1 doesn't have $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
nomReasonBuffFoundButIncomplete = "$2 $3 found for $1 but\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 has $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "Not all in $1 have $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
nomReasonAllInGroupHaveBuff = "All in $1 have $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "No one in $1 has $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Buff present, timer invert",
nomReasonBuffPresentNotMine = "Not cast by me",
nomReasonBuffFound = "Buff present",
nomReasonStacksMismatch = "Stacks = $1 expecting $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

nomReasonAuraMissing = "Aura missing",
nomReasonAuraOff = "Aura off",
nomReasonAuraBad = "Aura bad",

nomReasonNotForTalentSpec = "Aura not active for this talent spec",

nomReasonPlayerDead = "Player is DEAD",
nomReasonPlayerAlive = "Player is Alive",
nomReasonNoTarget = "No Target",
nomReasonTargetPlayer = "Target is you",
nomReasonTargetDead = "Target is Dead",
nomReasonTargetAlive = "Target is Alive",
nomReasonTargetFriendly = "Target is Friendly",
nomReasonTargetNotFriendly = "Target not Friendly",

nomReasonNoPet = "Player has no Pet",

nomReasonNotInCombat = "Not in combat",
nomReasonInCombat = "In combat",

nomReasonInParty = "In Party",
nomReasonInRaid = "In Raid",
nomReasonNotInParty = "Not in Party",
nomReasonNotInRaid = "Not in Raid",
nomReasonNotInGroup = "Not in Party/Raid",
nomReasonNoFocus = "No focus",
nomReasonNoCustomUnit = "Can't find custom unit not in party, raid or with pet unit=$1",
nomReasonPvPFlagNotSet = "PvP flag not set",
nomReasonPvPFlagSet = "PvP flag set",

nomReasonNotMounted = "Not Mounted",
nomReasonMounted = "Mounted",
nomReasonNotInVehicle = "Not In Vehicle",
nomReasonInVehicle = "In Vehicle",
nomReasonNotInPetBattle = "Not In Pet Battle",
nomReasonInPetBattle = "In Pet Battle",
nomReasonNotResting = "Not Resting",
nomReasonResting = "Resting",
nomReasonStateOK = "State OK",

nomReasonNotIn5ManInstance = "Not in 5 Man Instance",
nomReasonIn5ManInstance = "In 5 Man Instance",
nomReasonNotIn5ManHeroicInstance = "Not in 5 Man Heroic Instance",
nomReasonIn5ManHeroicInstance = "In 5 Man Heroic Instance",

nomReasonNotIn10ManInstance = "Not in 10 Man Instance",
nomReasonIn10ManInstance = "In 10 Man Instance",
nomReasonNotIn10ManHeroicInstance = "Not in 10 Man Heroic Instance",
nomReasonIn10ManHeroicInstance = "In 10 Man Heroic Instance",

nomReasonNotIn25ManInstance = "Not in 25 Man Instance",
nomReasonIn25ManInstance = "In 25 Man Instance",
nomReasonNotIn25ManHeroicInstance = "Not in 25 Man Heroic Instance",
nomReasonIn25ManHeroicInstance = "In 25 Man Heroic Instance",

nomReasonNotInBgInstance = "Not in Battleground Instance",
nomReasonInBgInstance = "In Battleground Instance",
nomReasonNotInArenaInstance = "Not in Arena Instance",
nomReasonInArenaInstance = "In Arena Instance",

nomReasonInverted = "$1 (inverted)", -- $1 is the reason, but the inverted flag is set so the logic is reversed

nomReasonSpellUsable = "Spell $1 usable",
nomReasonSpellNotUsable = "Spell $1 not usable",
nomReasonSpellNotReady = "Spell $1 Not Ready, on cooldown, timer invert",
nomReasonSpellNotEnabled = "Spell $1 not enabled ",
nomReasonSpellNotFound = "Spell $1 not found",
nomReasonSpellOnCooldown = "Spell $1 on Cooldown",
nomReasonSpellLearned = "and spell is learned",
nomReasonSpellNotLearned = "and spell is not learned",

nomReasonCastingOnMe = "$1 is casting $2 on me", --$1=CasterName $2=SpellName (e.g. "Rotface is casting Slime Spray on me")
nomReasonNotCastingOnMe = "No matching spell being cast on me",

nomReasonCastingByMe = "I am casting $1 on $2", --$1=SpellName $2=TargetName (e.g. "I am casting Holy Light on Fred")
nomReasonNotCastingByMe = "No matching spell being cast by me",

nomReasonAnimationDuration = "Still within custom duration",

nomReasonItemUsable = "Item $1 usable",
nomReasonItemNotUsable = "Item $1 not usable",
nomReasonItemNotReady = "Item $1 Not Ready, on cooldown, timer invert",
nomReasonItemNotEnabled = "Item $1 not enabled ",
nomReasonItemNotFound = "Item $1 not found",
nomReasonItemOnCooldown = "Item $1 on Cooldown",

nomReasonItemEquipped = "Item $1 equipped",
nomReasonItemNotEquipped = "Item $1 not equipped",

nomReasonItemInBags = "Item $1 in bags",
nomReasonItemNotInBags = "Item $1 not in bags",
nomReasonItemNotOnPlayer = "Item $1 not carried",

nomReasonSlotUsable = "$1 Slot usable",
nomReasonSlotNotUsable = "$1 Slot not usable",
nomReasonSlotNotReady = "$1 Slot Not Ready, on cooldown, timer invert",
nomReasonSlotNotEnabled = "$1 Slot has no cooldown effect",
nomReasonSlotNotFound = "$1 Slot not found",
nomReasonSlotOnCooldown = "$1 Slot on Cooldown",
nomReasonSlotNone = "$1 Slot is empty",

nomReasonStealablePresent = "$1 has Stealable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "Nobody has Stealable spell $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "Raid$1Target has has Stealable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "Party$1Target has has Stealable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 has Purgeable spell $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "Nobody has Purgeable spell $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "Raid$1Target has has Purgeable spell $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "Party$1Target has has Purgeable spell $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonAoETrigger = "AoE $1 triggered", -- $1=AoE spell name
nomReasonAoENoTrigger = "AoE no trigger for $1", -- $1=AoE spell match

nomReasonEnchantMainInvert = "Main Hand $1 enchant found, timer invert", -- $1=Enchant match
nomReasonEnchantMain = "Main Hand $1 enchant found", -- $1=Enchant match
nomReasonEnchantOffInvert = "Off Hand $1 enchant found, timer invert", -- $1=Enchant match
nomReasonEnchantOff = "Off Hand $1 enchant found", -- $1=Enchant match
nomReasonNoEnchant = "No enchant found on weapons for $1", -- $1=Enchant match

nomReasonNoUseCombo = "You do not use combo points",
nomReasonNoUseComboInForm = "You don't use combo points in this form",
nomReasonComboMatch = "Combo points $1 match $2", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "Combo points $1 no match with $2", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "not found on Action Bar",
nomReasonActionReady = "Action Ready",
nomReasonActionNotReadyInvert = "Action Not Ready (on cooldown), timer invert",
nomReasonActionNotReady = "Action Not Ready (on cooldown)",
nomReasonActionlNotEnabled = "Action not enabled",
nomReasonActionNotUsable = "Action not usable",

nomReasonYouAreCasting = "You are casting $1", -- $1=Casting match
nomReasonYouAreNotCasting = "You are not casting $1", -- $1=Casting match
nomReasonTargetCasting = "Target casting $1", -- $1=Casting match
nomReasonFocusCasting = "Focus casting $1", -- $1=Casting match
nomReasonRaidTargetCasting = "Raid$1Target casting $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "Party$1Target casting $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "Nobody's target casting $1", -- $1=Casting match

nomReasonStance = "Current Stance $1, matches $2", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "Current Stance $1, does not match $2", -- $1=Current Stance, $2=Match Stance

nomReasonRunesNotReady = "Runes not Ready",
nomReasonRunesReady = "Runes Ready",

nomReasonPetExists= "Player has Pet",
nomReasonPetMissing = "Player Pet Missing",

nomReasonTrackingMissing = "Tracking not set to $1",
nomTrackingSet = "Tracking set to $1",

nomNotInInstance = "Not in correct instance",

nomReasonStatic = "Static Aura",

nomReasonUnitMatch = "Unit $1 matches unit $2.",
nomReasonNoUnitMatch = "Unit $1 does not match unit $2.",

nomReasonPetStance = "Pet is in $1 stance.",

nomReasonUnknownName = "Unit name unknown",
nomReasonRoleUnknown = "Role unknown",
nomReasonRoleNoMatch = "No matching Role",

nomUnknownSpellId = "PowerAuras: Aura $1 references an unknown spellId: ", -- $1=SpellID

nomReasonGTFOAlerts = "GTFO alerts are never always on.",

ReasonStat =
{
	Health = {MatchReason = "$1 Health past limit", NoMatchReason = "$1 Health not past limit"},
	Mana = {MatchReason = "$1 Mana past limit", NoMatchReason = "$1 Mana not past limit"},
	Power = {MatchReason = "$1 $3 past limit", NoMatchReason = "$1 $3 not past limit", NilReason = "$1 has wrong Power Type"},
	Aggro = {MatchReason = "$1 has aggro", NoMatchReason = "$1 does not have aggro"},
	PvP = {MatchReason = "$1 PvP flag set", NoMatchReason = "$1 PvP flag not set"},
	SpellAlert = {MatchReason = "$1 casting $2", NoMatchReason = "$1 not casting $2"}
},

-- Import dialog
ImportDialogAccept = "Import",
ImportDialogCancel = "Close",

-- Export dialog
ExportDialogTopTitle = "Export Auras",
ExportDialogCopyTitle = "Press Ctrl-C to copy the below aura string.",
ExportDialogMidTitle = "Send to Player",
ExportDialogSendTitle1 = "Enter a player name below and click 'Send'.",
ExportDialogSendTitle2 = "Contacting %s (%d seconds remaining)...", -- The 1/2/3/4 suffix denotes the internal status of the frame.
ExportDialogSendTitle3a = "%s is in combat and cannot accept the offer.",
ExportDialogSendTitle3b = "%s is not accepting export requests.",
ExportDialogSendTitle3c = "%s has not responded, they may be away or offline.",
ExportDialogSendTitle3d = "%s is currently receiving another export request.",
ExportDialogSendTitle3e = "%s has declined the offer.",
ExportDialogSendTitle4 = "Sending auras...",
ExportDialogSendTitle5 = "Send successful!",
ExportDialogSendButton1 = "Send",
ExportDialogSendButton2 = "Back",
ExportDialogCancelButton = "Close",

-- Cross-client import dialog
PlayerImportDialogTopTitle = "You Have Auras!",
PlayerImportDialogDescTitle1 = "%s would like to send you some auras.",
PlayerImportDialogDescTitle2 = "Receiving auras...",
PlayerImportDialogDescTitle3 = "The offer has expired.",
PlayerImportDialogDescTitle4 = "Select a page to save the auras to.",
PlayerImportDialogWarningTitle = "|cFFFF0000Note: |rYou are being sent an aura set, this will overwrite any existing auras on the selected page.",
PlayerImportDialogDescTitle5 = "Auras saved!",
PlayerImportDialogDescTitle6 = "No aura slots are available.",
PlayerImportDialogAcceptButton1 = "Accept",
PlayerImportDialogAcceptButton2 = "Save",
PlayerImportDialogCancelButton1 = "Reject",

aideCommsRegisterFailure = "There was an error when setting up addon communications.",
aideBlockIncomingAuras = "Prevent anybody sending you auras.",
aideDisableFrameScaling = "Disabled the rescale button on the frames.",
nomBlockIncomingAuras = "Block Incoming Auras",
nomDisableScaling = "Disable Frame Scaling",
aideFixExports = "Check this when aura exports are not functioning correctly and leave you with a blank textbox.",
nomFixExports = "Alternative Exports",
aideAnimationsAreBrokenSorry = "If your animations appear to skip or increase in size randomly, you should enable this."
})
if (GetLocale() == "deDE") then
PowaAuras.Anim[0] = "[Nichts]"
PowaAuras.Anim[1] = "Statisch"
PowaAuras.Anim[2] = "Blitzend"
PowaAuras.Anim[3] = "Wachsend"
PowaAuras.Anim[4] = "Pulsierend"
PowaAuras.Anim[5] = "Blase"
PowaAuras.Anim[6] = "Wassertropfen"
PowaAuras.Anim[7] = "Elektrisch"
PowaAuras.Anim[8] = "Schrumpfend"
PowaAuras.Anim[9] = "Flamme"
PowaAuras.Anim[10] = "Orbit"
PowaAuras.Anim[11] = "Im Uhrzeigersinn drehend"
PowaAuras.Anim[12] = "Gegen den Uhrzeigersinn drehend"

PowaAuras.BeginAnimDisplay[0] = "[Nichts]"
PowaAuras.BeginAnimDisplay[1] = "Reinzoomend"
PowaAuras.BeginAnimDisplay[2] = "Rauszoomend"
PowaAuras.BeginAnimDisplay[3] = "Nur Alpha"
PowaAuras.BeginAnimDisplay[4] = "Links"
PowaAuras.BeginAnimDisplay[5] = "Oben links"
PowaAuras.BeginAnimDisplay[6] = "Oben"
PowaAuras.BeginAnimDisplay[7] = "Oben rechts"
PowaAuras.BeginAnimDisplay[8] = "Rechts"
PowaAuras.BeginAnimDisplay[9] = "Unten rechts"
PowaAuras.BeginAnimDisplay[10] = "Unten"
PowaAuras.BeginAnimDisplay[11] = "Unten links"
PowaAuras.BeginAnimDisplay[12] = "Hüpfen"

PowaAuras.EndAnimDisplay[0] = "[Nichts]"
PowaAuras.EndAnimDisplay[1] = "Wachsen"
PowaAuras.EndAnimDisplay[2] = "Schrumpfen"
PowaAuras.EndAnimDisplay[3] = "Nur Alpha"
PowaAuras.EndAnimDisplay[4] = "Drehen"
PowaAuras.EndAnimDisplay[5] = "Reindrehen"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Gib /powa ein, um die Optionen zu öffnen.",

aucune = "Keine",
aucun = "Keine",
mainHand = "Waffenhand",
offHand = "Schildhand",
bothHands = "Beide",

Unknown = "Unbekannt",

DebuffType =
{
	Magic = "Magie",
	Disease = "Krankheit",
	Curse = "Fluch",
	Poison = "Gift",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "Stille",
	[PowaAuras.DebuffCatType.Snare] = "Fesseln",
	[PowaAuras.DebuffCatType.Stun] = "Betäubung",
	[PowaAuras.DebuffCatType.Root] = "Wurzeln",
	[PowaAuras.DebuffCatType.Disarm] = "Entwaffnen",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

Role =
{
	RoleTank = "Tank",
	RoleHealer = "Heiler",
	RoleMeleDps = "Nahkämpfer",
	RoleRangeDps = "Fernkämpfer"
},

nomReasonRole =
{
	RoleTank = "Ist Tank",
	RoleHealer = "Ist Heiler",
	RoleMeleDps = "Ist Nahkämpfer",
	RoleRangeDps = "Ist Fernkämpfer"
},

nomReasonNotRole =
{
	RoleTank = "Ist kein Tank",
	RoleHealer = "Ist kein Heiler",
	RoleMeleDps = "Ist kein Nahkämpfer",
	RoleRangeDps = "Ist kein Fernkämpfer"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Buff",
	[PowaAuras.BuffTypes.Debuff] = "Debuff",
	[PowaAuras.BuffTypes.AoE] = "AOE Debuff",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debuff Typ",
	[PowaAuras.BuffTypes.Enchant] = "Waffenbuffs",
	[PowaAuras.BuffTypes.Combo] = "Kombopunkte",
	[PowaAuras.BuffTypes.ActionReady] = "Aktion benutzbar",
	[PowaAuras.BuffTypes.Health] = "Leben",
	[PowaAuras.BuffTypes.Mana] = "Mana",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Wut/Energie/Runen",
	[PowaAuras.BuffTypes.Aggro] = "Aggro",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "Haltung",
	[PowaAuras.BuffTypes.SpellAlert] = "Zauberalarm",
	[PowaAuras.BuffTypes.SpellCooldown] = "My Spell Cooldown",
	[PowaAuras.BuffTypes.StealableSpell] = "Stehlbare Zauber",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Reinigbare Zauber",
	[PowaAuras.BuffTypes.Static] = "Static Aura",
	[PowaAuras.BuffTypes.Totems] = "Totems",
	[PowaAuras.BuffTypes.Pet] = "Haustier",
	[PowaAuras.BuffTypes.Runes] = "Runen",
	[PowaAuras.BuffTypes.Slots] = "Ausrüstungsplatz",
	[PowaAuras.BuffTypes.Items] = "Gegenstand",
	[PowaAuras.BuffTypes.Tracking] = "Aufspüren",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff-Typ",
	[PowaAuras.BuffTypes.UnitMatch] = "Spieler/Einheit",
	[PowaAuras.BuffTypes.PetStance] = "Begleiter-Haltung",
	[PowaAuras.BuffTypes.GTFO] = "GTFO-Alert"
},

PowerType =
{
		[-1] = "Standard",
		[SPELL_POWER_ALTERNATE_POWER] = "Boss-Fähigkeit",
		[SPELL_POWER_BURNING_EMBERS] = "Brennende Funken",
		[SPELL_POWER_CHI] = "Chi",
		[SPELL_POWER_DARK_FORCE] = "Dunkle Macht",
		[SPELL_POWER_DEMONIC_FURY] = "Dämonischer Furor",
		[SPELL_POWER_ENERGY] = "Energie",
		[SPELL_POWER_FOCUS] = "Fokus",
		[SPELL_POWER_HOLY_POWER] = "Heilige Kraft",
		[SPELL_POWER_LUNAR_ECLIPSE] = "Mondfinsternis",
		[SPELL_POWER_RAGE] = "Wut",
		[SPELL_POWER_RUNIC_POWER] = "Runenmacht",
		[SPELL_POWER_SHADOW_ORBS] = "Schattenkugeln",
		[SPELL_POWER_SOLAR_ECLIPSE] = "Sonnenfinsternis",
		[SPELL_POWER_SOUL_SHARDS] = "Seelensplitter",
},

Relative =
{
	NONE = "Frei",
	TOPLEFT = "Oben links",
	TOP = "Oben",
	TOPRIGHT = "Oben rechts",
	RIGHT = "Rechts",
	BOTTOMRIGHT = "Unten rechts",
	BOTTOM = "Unten",
	BOTTOMLEFT = "Unten links",
	LEFT = "Links",
	CENTER = "Mitte"
},

SlotsToCheck = "Wähle zu überprüfende Slots",

Cancel = "Abbrechen",

-- Main
nomEnable = "Aktiviere Power Auras",
aideEnable = "Alle Power Auras Effekte einschalten",

nomDebug = "Aktiviere Debug Meldungen",
nomTextureCount = "Maximale Texturen",
aideDebug = "Zeigt Debug Meldungen im Chatfenster.",
ListePlayer = "Char",
ListeGlobal = "Global",
aideMove = "Effekt hierher verschieben.",
aideCopy = "Effekt hierher kopieren.",
nomRename = "Umbenennen",
aideRename = "Seitentitel umbenennen.",
nomTest = "Test",
nomTestAll = "Test All",
nomHide = "Alle ausblenden",
nomEdit = "Editieren",
nomNew = "Neu",
nomDel = "Löschen",
nomImport = "Importieren",
nomExport = "Exportieren",
nomImportSet = "Set importieren",
nomExportSet = "Set exportieren",
aideImport = "Zum Einfügen des Aura-Strings drücke Strg-V und anschließend \'Akzeptieren\'.",
aideExport = "Zum Kopieren und Weitergeben des Aura-Strings drücke Strg-C.",
aideImportSet = "Zum Einfügen des Aura-Set-Strings drücke Strg-V und anschließends \'Akzeptieren'\. Das wird alle Auras auf dieser Seite löschen.",
aideExportSet = "Zum Kopieren und Weitergeben aller Auren auf dieser Seite drücke Strg-C.",
aideDel = "Löscht den ausgewählten Effekt. (Halte STRG zum Löschen gedrückt.)",
nomMove = "Verschieben",
nomCopy = "Kopieren",
nomPlayerEffects = "Charakter Effekte",
nomGlobalEffects = "Globale\nEffekte",
aideEffectTooltip = "(Shift-Klick um Effekt ein- oder auszuschalten.)",
aideEffectTooltip2 = "(Strg-Klick um Aktivierungsbedingungen anzuzeigen.)",

nomSound = "Sound abspielen:",
aideSound = "Spielt einen Sound am Anfang ab.",
nomSound2 = "Noch mehr Sounds zum abspielen:",
aideSound2 = "Spielt einen Sound am Anfang ab",
nomCustomSound = "ODER Sounddatei:",
aideCustomSound = "Dateiname der Sounddatei eingeben, die VOR dem Starten von WoW im Sounds Verzeichniss war. mp3 und wav werden unterstützt. Bsp.: 'cookie.mp3'",

nomSoundEnd = "Sound abspielen:",
nomSound2End = "Noch mehr Sounds zum Abspielen:",
aideSoundEnd = "Spielt einen Sound am Ende ab.",
aideSound2End = "Spielt einen Sound am Ende ab.",
nomCustomSoundEnd = "ODER Sounddatei:",
aideCustomSoundEnd = "Dateiname der Sounddatei eingeben, die VOR dem Starten von WoW im Sounds Verzeichniss war. mp3 und wav werden unterstützt. Bsp.: 'cookie.mp3'",
nomTexture = "Grafik",
aideTexture = "Die Grafik, die angezeigt werden soll. Du kannst ganz leicht Grafiken austauschen, indem du die Aura#.tga Dateien im Verzeichnis des Addons veränderst.",

nomAnim1 = "Hauptanimation",
nomAnim2 = "Zweitanimation",
aideAnim1 = "Animiere die Aura oder nicht.",
aideAnim2 = "Diese Animation wird mit weniger Stärke angezeigt als die Hauptanimation. Achtung vor zu viel Animationen auf dem Bildschirm.",

nomDeform = "Deformation",

aideColor = "Klicken, um die Farbe der Grafik zu ändern.",
aideTimerColor = "Hier klicken, um die Farbe der Timer zu ändern.",
aideStacksColor = "Hier klicken, um die Farbe der Stacks zu ändern.",
aideFont = "Klicken, um die Schriftart zu wählen. Drücke OK, um die Auswahl anzuwenden.",
aideMultiID = "Gib hier andere Aura-IDs für kombinierte Checks ein. Mehrere IDs müssen mit einem '/' getrennt werden. Die Aura ID kann als [#] in der ersten Zeile des Aura Tooltips gefunden werden.",
aideTooltipCheck = "Checke auch die Tooltips, die diesen Text enthalten.",

aideBuff = "Gib hier den Namen oder einen Teil vom Namen des Buffs ein, der die Aura auslösen soll. Mit einem Slash können mehrere Namen getrennt werden. Bsp.: 'Super Buff/Power'",
aideBuff2 = "Gib hier den Namen oder einen Teil vom Namen des Debuffs ein, der die Aura auslösen soll. Mit einem Slash können mehrere Namen getrennt werden. Bsp.: 'Dunkle Krankheit/Seuche'",
aideBuff3 = "Gib hier den Typ (Gift, Krankheit, Fluch, Magie, CC, Stille, Betäubung, Fesseln, Wurzeln oder Nichts) des Debuffs ein, der die Aura auslösen soll. Mit einem Slash können mehrere Typen getrennt werden. Bsp.: 'Krankheit/Gift'",
aideBuff4 = "Gib hier den Namen des Flächeneffekts (AoE) ein, der die Aura auslösen soll. Die Namen findest du z.B. im Kampflog. Bsp.: 'Feuerregen'",
aideBuff5 = "Gib hier den Namen oder einen Teil vom Namen der temporären Waffenverzauberung ein, die die Aura auslösen soll. Schreibe optional 'Waffenhand/' oder 'Schildhand/' davor, um einen Slot festzulegen. Bsp.: 'Waffenhand/Verkrüppelndes'",
aideBuff6 = "Gib hier die Anzahl Kombopunkte ein, die die Aura ein- oder auszuschalten. Bsp.: '1' oder '1/2/3' oder '0/4/5' usw…",
aideBuff7 = "Gib hier einen Namen oder einen Teil vom Namen einer Aktion auf deinen Aktionsleisten ein. Der Effekt wird aktiv sein, wenn die Aktion benutzbar ist.",
aideBuff8 = "Gib hier den Namen oder einen Teil vom Namen eines Zaubers in deinem Zauberbuch ein. Du kannst auch eine Zauber-ID (Bsp.: '[12345]') eingeben.",

aideSpells = "Gib hier den Namen eines Zaubers ein, der die Zauberalarm-Aura auslöst.",
aideStacks = "Gib hier den Operator und die Anzahl Stapel ein, die benötigt werden, um die Aura auszulösen. Ein Operator wird benötigt. Bsp: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "Gib hier den Names des stehlbaren Zaubers ein, der die Aura auslösen soll. Benutze '*' für alle stehlbaren Zauber.",
aidePurgeableSpells = "Gib hier den Namen des reinigbaren Zaubers ein, der die Aura auslösen soll. Benutze '*' für alle reinigbaren Zauber.",

aideTotems = "Gib hier den Namen des Totems ein, das die Aura auslösen soll: 1=Feuer, 2=Erde, 3=Wasser, 4=Luft. Benutze '*' für ein beliebiges Totem.",

aideRunes = "Gib hier die Runen ein, die die Aura auslösen sollen: B=Blut, U=Unheilig, F=Frost, D=Tod (Todesrunen zählen auch als die anderen Typen). Bsp.: 'BF' 'BFU' 'DDD'",

aideUnitn = "Gib hier den Namen des Spielers ein, welcher den Effekt aktivieren/deaktivieren muss. Funktioniert nur mit Spielern innerhalb des Schlachtzugs oder der Gruppe.",
aideUnitn2 = "Nur für Schlachtzug/Gruppe.",

aideMaxTex = "Definiert die Anzahl der Grafiken, die im Editor zur Verfügung stehen. Wenn du Grafiken im Verzeichnis des Addons hinzufügst (mit den Namen AURA1.tga bis AURA50.tga), muss hier die letzte Zahl eingetragen werden.",
aideWowTextures = "Aktivieren, um die WoW-Grafiken anstatt der Grafiken im PowerAuras-Verzeichnis zu verwenden.",
aideTextAura = "Aktivieren, um Text einzugeben anstatt zu Grafiken zu wählen.",
aideRealaura = "Echte Aura.",
aideCustomTextures = "Aktivieren, um die Grafiken im 'Custom'-Unterverzeichnis zu verwenden. Trage den Namen der Textur unten ein. Bsp.: 'meineTextur.tga'",
aideRandomColor = "Aktivieren, um dem Effekt bei jeder Aktivierung eine zufällige Farbe zu geben.",

aideTexMode = "Deaktivieren, um die Texturtransparenz zu verwenden. Standardmäßig sind die dunkleren Farben mehr transparent.",

nomActivationBy = "Aktiv wenn",

nomOwnTex = "Benutze eigene Grafiken",
aideOwnTex = "Benutze die Grafik des Buffs/Debuffs/Items bzw. der Fähigkeit.",
nomStacks = "Stapel",

nomUpdateSpeed = "Updatetempo",
nomSpeed = "Animationstempo",
nomTimerUpdate = "Timer Updatetempo",
nomBegin = "Animationsstart",
nomEnd = "Animationsende",
nomSymetrie = "Spiegelachse",
nomAlpha = "Transparenz",
nomPos = "Position",
nomTaille = "Größe",

nomExact = "Exakter Name",
nomThreshold = "Schwellwert",
aideThreshInv = "Aktivieren, um die Schwellwertlogik umzukehren: Deaktiviert = Warnung, wenn unter Schwellwert /Aktiviert = Warnung, wenn über Schwellert.",
nomThreshInv = "</>",
nomStance = "Haltung",
nomGTFO = "Alert Type",
nomPowerType = "Power Type:",

nomMine = "Von mir gezaubert",
aideMine = "Aktivieren, um nur Buffs/Debuffs zu testen, die vom Spieler gezaubert wurden.",
nomDispellable = "Ich kann entfernen",
aideDispellable = "Aktivieren, um nur entfernbare Buffs anzuzeigen.",
nomCanInterrupt = "Kann unterbrochen werden",
aideCanInterrupt = "Aktivieren, um nur unterbrechbare Zauber anzuzeigen.",
nomOnMe = "Auf mich gezaubert",
aideOnMe = "Aktivieren, um nur auf den Spieler gezauberte Zauber anzuzeigen.",

nomPlayerSpell = "Spieler wirkt Zauber",
aidePlayerSpell = "Aktivieren, falls der Spieler einen Zauber wirkt.",

nomCheckTarget = "Feindliches Ziel",
nomCheckFriend = "Freundliches Ziel",
nomCheckParty = "Gruppenmitglied",
nomCheckFocus = "Fokus",
nomCheckRaid = "Schlachtzugsmitglied",
nomCheckGroupOrSelf = "Schlachtzug/Gruppe oder selbst",
nomCheckGroupAny = "Irgendeiner",
nomCheckOptunitn = "Charname",

aideTarget = "Aktivieren, um nur feindliche Ziele zu überwachen.",
aideTargetFriend = "Aktivieren, um nur freundliche Ziele zu überwachen.",
aideParty = "Aktivieren, um nur Gruppenmitglieder zu überwachen.",
aideGroupOrSelf = "Aktivieren, um Gruppen- oder Schlachtzugsmitglieder oder sich selbst zu überwachen.",
aideFocus = "Aktivieren, um nur das Fokusziel zu überwachen.",
aideRaid = "Aktivieren, um nur Schlachtzugsmitglieder zu überwachen.",
aideGroupAny = "Aktivieren, um zu prüfen, ob 'irgendein' Gruppen/Schlachtzugsmitglied gebufft ist. Deaktivieren, um zu prüfen, ob 'alle' gebufft sind.",
aideOptunitn = "Aktivieren, um nur einen bestimmten Char in der Gruppe bzw. im Schlachtzug zu überwachen.",
aideExact = "Aktivieren, um den exakten Namen des Buffs/Debuff/Aktion zu überprüfen.",
aideStance = "Haltung, Aura oder Form auswählen, die die Aura aktivieren soll.",
aideGTFO = "Wählt aus, welcher GTFO-Alarm die Aura auslöst.",

aideShowSpinAtBeginning = "Zeige am Ende der Anfangsanimation eine 360-Grad-Drehung.",
nomCheckShowSpinAtBeginning = "Zeige Drehung am Ende der Anfangsanimation",

nomCheckShowTimer = "Zeigen",
nomTimerDuration = "Dauer",
aideTimerDuration = "Zeigt einen Timer. um die Buff-/Debuff-Dauer auf dem Ziel zu simulieren ('0' zum Deaktivieren).",
aideShowTimer = "Aktivieren, um den Timer für diesen Effekt anzuzeigen.",
aideSelectTimer = "Auswählen, welcher Timer die Dauer anzeigen soll.",
aideSelectTimerBuff = "Auswählen, welcher Timer die Dauer anzeigen soll (dieser ist für die Buffs des Spielers reserviert).",
aideSelectTimerDebuff = "Auswählen, welcher Timer die Dauer anzeigen soll (dieser ist für die Debuffs des Spielers reserviert).",

nomCheckShowStacks = "Zeigen",
aideShowStacks = "Aktivieren, um die Stacks für diesen Effekt anzuzeigen.",

nomCheckInverse = "Umkehren",
aideInverse = "Kehrt die Logik des Effekts um, sodass er nur angezeigt wird, wenn der Buff/Debuff nicht aktiv ist.",

nomCheckIgnoreMaj = "Ignoriere Groß-/Kleinschreibung",
aideIgnoreMaj = "Aktivieren, um die Groß-/Kleinschreibung bei Buff- und Debuffnamen zu ignorieren.",

nomAuraDebug = "Debug",
aideAuraDebug = "Diese Aura debuggen.",

nomDuration = "Animationsdauer",
aideDuration = "Nach dieser Zeit wird die Aura verschwinden ('0' zum Deaktivieren).",

nomOldAnimations = "Alte Animationen",
aideOldAnimations = "Benutze die alten Animationen.",

nomCentiemes = "Zeige Hundertstel",
nomDual = "Zeige zwei Timer",
nomHideLeadingZeros = "Verstecke führende Nullen",
nomTransparent = "Verwende transparente Grafiken",
nomActivationTime = "Zeige Zeit seit Aktivierung",
nomUseOwnColor = "Eigene Farbe benutzen:",
nomUpdatePing = "Animiere bei Wiederholung",
nomRelative = "Ausrichtung relativ zur Hauptaura",
nomClose = "Schließen",
nomEffectEditor = "Effekt-Editor",
nomAdvOptions = "Optionen",
nomMaxTex = "Anzahl verfügbare Grafiken",
nomTabAnim = "Animation",
nomTabActiv = "Aktivierung",
nomTabSound = "Sound",
nomTabTimer = "Timer",
nomTabStacks = "Stapel",
nomWowTextures = "WoW-Grafiken",
nomCustomTextures = "Eigene Grafiken",
nomTextAura = "Textaura",
nomRealaura = "Echte Aura",
nomRandomColor = "Zufällige Farbe",

nomTalentGroup1 = "Specc 1",
aideTalentGroup1 = "Zeige diesen Effekt nur, wenn du in deiner primären Talenzspezialisierung bist.",
nomTalentGroup2 = "Specc 2",
aideTalentGroup2 = "Zeige diesen Effekt nur, wenn du in deiner sekundären Talenzspezialisierung bist.",

nomReset = "Setzte Editorpositionen zurück",
nomPowaShowAuraBrowser = "Zeige Auraauswahl",

nomDefaultTimerTexture = "Standard Timer Grafik",
nomTimerTexture = "Timer Grafik",
nomDefaultStacksTexture = "Standard Stapel Grafik",
nomStacksTexture = "Stapel Grafik",

Enabled = "Aktiviert",
Default = "Standard",

Ternary =
{
	combat = "Im Kampf",
	inRaid = "Im Schlachtzug",
	inParty = "In Gruppe",
	isResting = "Erholen",
	ismounted = "Auf Reittier",
	inVehicle = "In Fahrzeug",
	isAlive = "Am Leben",
	PvP = "PvP aktiv",
	InstanceChallengeMode = "Herausforderung",
	InstanceScenario = "Szenario",
	InstanceScenarioHeroic = "Szenario HC",
	Instance5Man = "5-Mann",
	Instance5ManHeroic = "5-Mann HC",
	Instance10Man = "10-Mann",
	Instance10ManHeroic = "10-Mann HC",
	Instance25Man = "25-Mann",
	Instance25ManHeroic = "25-Mann HC",
	InstanceBg = "Schlachtfeld",
	InstanceArena = "Arena"
},

nomWhatever = "Ignorieren",
aideTernary = "Legt fest, wie der Status die Aura auslöst.",

TernaryYes =
{
	combat = "Nur wenn im Kampf",
	inRaid = "Nur wenn in einer Schlachtzugsgruppe",
	inParty = "Nur wenn in einer Gruppe",
	isResting = "Nur wenn erholend",
	ismounted = "Nur wenn auf einem Reittier",
	inVehicle = "Nur wenn in einem Fahrzeug",
	isAlive = "Nur wenn am Leben",
	PvP = "Nur wenn PvP aktiv",
	InstanceChallengeMode = "Nur in einer Herausforderungsmodus-Instanz",
	InstanceScenario = "Nur in einem normalen Szenario",
	InstanceScenarioHeroic = "Nur in einem heroischen Szenario",
	Instance5Man = "Nur in einer normalen 5-Mann-Instanz",
	Instance5ManHeroic = "Nur in einer heroischen 5-Mann-Instanz",
	Instance10Man = "Nur in einer normalen 10-Mann-Instanz",
	Instance10ManHeroic = "Nur in einer heroischen 10-Mann-Instanz",
	Instance25Man = "Nur in einer normalen 25-Mann-Instanz",
	Instance25ManHeroic = "Nur in einer heroischen 25-Mann-Instanz",
	InstanceBg = "Nur auf einem Schlachtfeld",
	InstanceArena = "Nur in einer Arena",
	RoleTank = "Nur wenn Tank",
	RoleHealer = "Nur wenn Heiler",
	RoleMeleDps = "Nur wenn Nahkämpfer",
	RoleRangeDps = "Nur wenn Fernkämpfer"
},

TernaryNo =
{
	combat = "Nur wenn nicht im Kampf",
	inRaid = "Nur wenn in keiner Schlachtzugsgruppe",
	inParty = "Nur wenn in keiner Gruppe",
	isResting = "Nur wenn nicht erholend",
	ismounted = "Nur wenn auf keinem Reittier",
	inVehicle = "Nur wenn in keinem Fahrzeug",
	isAlive = "Nur wenn tot",
	PvP = "Nur wenn kein PvP aktiv",
	InstanceChallengeMode = "Nur wenn nicht in einer Herausforderungsmodus-Instanz",
	InstanceScenario = "Nur wenn nicht in einem normalen Szenario",
	InstanceScenarioHeroic = "Nur wenn nicht in einem heroischen Szenario",
	Instance5Man = "Nur wenn nicht in einer normalen 5-Mann-Instanz",
	Instance5ManHeroic = "Nur wenn nicht in einer heroischen 5-Mann-Instanz",
	Instance10Man = "Nur wenn nicht in einer normalen 10-Mann-Instanz",
	Instance10ManHeroic = "Nur wenn nicht in einer heroischen 10-Mann-Instanz",
	Instance25Man = "Nur wenn nicht in einer normalen 25-Mann-Instanz",
	Instance25ManHeroic = "Nur wenn nicht in einer heroischen 25-Mann-Instanz",
	InstanceBg = "Nur wenn nicht auf einem Schlachtfeld",
	InstanceArena = "Nur wenn nicht in einer Arena",
	RoleTank = "Nur wenn kein Tank",
	RoleHealer = "Nur wenn kein Heiler",
	RoleMeleDps = "Nur wenn kein Nahkämpfer",
	RoleRangeDps = "Nur wenn kein Fernkämpfer"
},

TernaryAide =
{
	combat = "Effekt beeinflusst durch Kampfstatus.",
	inRaid = "Effekt beeinflusst durch Schlachtzugsstatus.",
	inParty = "Effekt beeinflusst durch Gruppenstatus.",
	isResting = "Effekt beeinflusst durch Erholenstatus.",
	ismounted = "Effekt beeinflusst durch Reittierstatus.",
	inVehicle = "Effekt beeinflusst durch Fahrzeugstatus.",
	isAlive = "Effekt beeinflusst durch Lebensstatus.",
	PvP = "Effekt beinflusst durch PvP-Status.",
	InstanceChallengeMode = "Effekt beeinflusst durch Herausforderungsmodus-Instanz.",
	InstanceScenario = "Effekt beeinflusst durch normales Szenario",
	InstanceScenarioHeroic = "Effekt beeinflusse durch heroisches Szenario",
	Instance5Man = "Effekt beeinflusst durch normale 5-Mann-Instanz.",
	Instance5ManHeroic = "Effekt beeinflusst durch heroische 5-Mann-Instanz.",
	Instance10Man = "Effekt beeinflusst durch normale 10-Mann-Instanz.",
	Instance10ManHeroic = "Effekt beeinflusst durch heroische 10-Mann-Instanz.",
	Instance25Man = "Effekt beeinflusst durch normale 25-Mann-Instanz.",
	Instance25ManHeroic = "Effekt beeinflusst durch heroische 25-Mann-Instanz.",
	InstanceBg = "Effekt beeinflusst durch Schlachtfeld.",
	InstanceArena = "Effekt beeinflusst durch Arena.",
	RoleTank = "Effekt beeinflusst durch Tanklasse.",
	RoleHealer = "Effekt beeinflusst durch Heilklasse.",
	RoleMeleDps = "Effekt beeinflusst durch Nahkampfklasse.",
	RoleRangeDps = "Effekt beeinflusst durch Fernkampfklasse."
},

aideTracking = "Gib die Art des Aufspürens an. Bsp.: 'Fischsuche'",
nomTrackingSet = "Aufspüren auf $1 gesetzt",

nomTimerInvertAura = "Kehre Aura um wenn Dauer unterhalb",
aidePowaTimerInvertAuraSlider = "Kehre die Aura um, wenn die Dauer weniger als dieses Limit ist ('0' zum Deaktivieren).",
nomTimerHideAura = "Verstecke Aura und Timer wenn Dauer oberhalb",
aidePowaTimerHideAuraSlider = "Verstecke die Aura und den Timer, wenn die Dauer größer als dieses Limit ist ('0' zum Deaktivieren).",

aideTimerRounding = "Aktivieren, um den Timer aufzurunden.",
nomTimerRounding = "Timer aufrunden",

nomIgnoreUseable = "Anzeige nur vom CD abhängig",
aideIgnoreUseable = "Ignoriert, wenn der Zauber benutzbar ist (benutzt nur die Abklingzeit).",

aideAllowInspections = "Allow Power Auras to Inspect players to determine roles, turning this off will sacrifice accuracy for speed.",
nomAllowInspections = "Allow Inspections",

nomCarried = "In Taschen",
aideCarried = "Ignoriert, ob der Gegenstand benutzbar ist.",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "Sollte angezeigt werden, weil $1",
nomReasonWontShow = "Wird nicht angezeigt, weil $1",

nomReasonMulti = "Alle mehrfachen passen auf $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras deaktiviert",
nomReasonGlobalCooldown = "Ignoriere Globale Abklingzeit",

nomReasonBuffPresent = "$1 hat $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
nomReasonBuffMissing = "$1 hat nicht $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
nomReasonBuffFoundButIncomplete = "$2 $3 bei $1 gefunden, aber\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 hat $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "Nicht alle in $1 haben $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
nomReasonAllInGroupHaveBuff = "Alle in $1 haben $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "Keiner in $1 hat $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

nomReasonBuffPresentTimerInvert = "der Buff läuft, Timer umgekehrt",
nomReasonBuffPresentNotMine = "nicht von mir gezaubert",
nomReasonBuffFound = "der Buff läuft",
nomReasonStacksMismatch = "der Stapel = $1. $2 erwartet", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

nomReasonAuraMissing = "die Aura fehlt",
nomReasonAuraOff = "die Aura ist aus",
nomReasonAuraBad = "die Aura ist fehlerhaft",

nomReasonNotForTalentSpec = "die Aura nicht für diese Talentspezialisierung aktiviert wurde",

nomReasonPlayerDead = "der Spieler tot ist",
nomReasonPlayerAlive = "der Spieler am Leben ist",
nomReasonNoTarget = "kein Ziel",
nomReasonTargetPlayer = "das Ziel bist du",
nomReasonTargetDead = "das Ziel tot ist",
nomReasonTargetAlive = "das Ziel lebt",
nomReasonTargetFriendly = "das Ziel freundlich ist",
nomReasonTargetNotFriendly = "das Ziel nicht freundlich ist",

nomReasonNotInCombat = "nicht im Kampf",
nomReasonInCombat = "im Kampf",

nomReasonInParty = "in Gruppe",
nomReasonInRaid = "im Schlachtzug",
nomReasonNotInParty = "nicht in Gruppe",
nomReasonNotInRaid = "nicht im Schlachtzug",
nomReasonNotInGroup = "nicht in Gruppe/Schlachtzug",
nomReasonNoFocus = "kein Fokus",
nomReasonNoCustomUnit = "benutzerdefinierte Einheit nicht in der Gruppe, im Schlachtzug oder mit Begleitereinheit $1 gefunden werden konnte",
nomReasonPvPFlagNotSet = "PvP Status nicht aktiv",
nomReasonPvPFlagSet = "PvP Status aktiv",

nomReasonNotMounted = "auf keinem Reittier",
nomReasonMounted = "auf einem Reittier",
nomReasonNotInVehicle = "in keinem Fahrzeug",
nomReasonInVehicle = "in einem Fahrzeug",
nomReasonNotResting = "nicht erholend",
nomReasonResting = "erholend",

nomReasonInverted = "$1 (umgekehrt)", -- $1 is the reason, but the inverted flag is set so the logic is reversed

nomReasonSpellUsable = "Zauber $1 benutzbar ist",
nomReasonSpellNotUsable = "Zauber $1 nicht benutzbar ist",
nomReasonSpellNotReady = "Zauber $1 nicht bereit ist (auf Abklingzeit), Timer umgekehrt",
nomReasonSpellNotEnabled = "Zauber $1 nicht aktiviert ist",
nomReasonSpellNotFound = "Zauber $1 nicht gefunden wurde",
nomReasonSpellOnCooldown = "Zauber $1 auf Abklingzeit",

nomReasonActionNotFound = "nicht in der Aktionsleiste gefunden",
nomReasonActionNotReady = "Aktion nicht bereit (auf Abklingzeit)",
nomReasonActionNotReadyInvert = "Aktion nicht bereit (auf Abklingzeit), Timer umgekehrt",
nomReasonActionNotUsable = "Aktion nicht benutzbar",
nomReasonActionReady = "Aktion bereit",
nomReasonActionlNotEnabled = "Aktion nicht aktiviert",
nomReasonAnimationDuration = "Noch in eigener Laufzeit", -- fuzzy
nomReasonGTFOAlerts = "GTFO sind nie immer aktiv.",
nomReasonIn10ManHeroicInstance = "In heroischer 10-Mann-Instanz",
nomReasonIn10ManInstance = "In 10-Mann-Instanz",
nomReasonIn25ManHeroicInstance = "In heroischer 25-Mann-Instanz",
nomReasonIn25ManInstance = "In 25-Mann-Instanz",
nomReasonIn5ManHeroicInstance = "In heroischer 5-Mann-Instanz",
nomReasonIn5ManInstance = "In 5-Mann-Instanz",
nomReasonInArenaInstance = "In einer Arena",
nomReasonInBgInstance = "Auf einem Schlachtfeld",
nomReasonItemEquipped = "Gegenstand $1 angelegt",
nomReasonItemInBags = "Gegenstand $1 in Taschen",
nomReasonItemNotEnabled = "Gegenstand $1 nicht aktiviert",
nomReasonItemNotEquipped = "Gegenstand $1 nicht angelegt",
nomReasonItemNotFound = "Gegenstand $1 nicht gefunden",
nomReasonItemNotInBags = "Gegenstand $1 nicht in Taschen",
nomReasonItemNotOnPlayer = "Gegenstand $1 nicht getragen",
nomReasonItemNotReady = "Gegenstand $1 nicht bereit (auf Abklingzeit), Timer umgekehrt",
nomReasonItemNotUsable = "Gegenstand $1 nicht benutzbar",
nomReasonItemOnCooldown = "Gegenstand $1 auf Abklingzeit",
nomReasonItemUsable = "Gegenstand $1 benutzbar",
nomReasonNoPet = "Spieler hat keinen Begleiter",
nomReasonNoUnitMatch = "Einheit $1 passt nicht auf Einheit $2.",
nomReasonNoUseCombo = "Du benutzt keine Kombopunkte",
nomReasonNoUseComboInForm = "Du benutzt keine Kombopunkte in dieser Form",
nomReasonNotCastingByMe = "Kein passender Zauber durch mich gewirkt",
nomReasonNotCastingOnMe = "Kein passender Zauber auf mich gewirkt",
nomReasonNotIn10ManHeroicInstance = "Nicht in heroischer 10-Mann-Instanz",
nomReasonNotIn10ManInstance = "Nicht in 10-Mann-Instanz",
nomReasonNotIn25ManHeroicInstance = "Nicht in heroischer 25-Mann-Instanz",
nomReasonNotIn25ManInstance = "Nicht in 25-Mann-Instanz",
nomReasonNotIn5ManHeroicInstance = "Nicht in heroischer 5-Mann-Instanz",
nomReasonNotIn5ManInstance = "Nicht in 5-Mann-Instanz",
nomReasonNotInArenaInstance = "Nicht in einer Arena",
nomReasonNotInBgInstance = "Nicht auf einem Schlachtfeld",
nomReasonPetExists = "Spieler hat Begleiter",
nomReasonPetMissing = "Begleiter des Spielers fehlt",
nomReasonPetStance = "Begleiter ist in Haltung $1.",
nomReasonRoleNoMatch = "Keine passende Rolle", -- fuzzy
nomReasonRoleUnknown = "Unbekannte Rolle", -- fuzzy
nomReasonRunesNotReady = "Runen nicht bereit",
nomReasonRunesReady = "Runen bereit",
nomReasonStateOK = "Status OK",
nomReasonStatic = "Statische Aura",
nomReasonTrackingMissing = "Aufspüren nicht auf $1 gesetzt",
nomReasonUnitMatch = "Einheit $1 passt auf Einheit $2.",
nomReasonUnknownName = "Einheitenname unbekannt",

ReasonStat =
{
	Health = {MatchReason = "$1 Gesundheit niedrig", NoMatchReason = "$1 Gesundheit nicht niedrig genug"},
	Mana = {MatchReason = "$1 Mana niedrig", NoMatchReason = "$1 Mana nicht niedrig genug"},
	Power = {MatchReason = "$1 EnergieWutRunen niedrig", NoMatchReason = "$1 EnergieWutRunen nicht niedrig genug", NilReason = "$1 has wrong Power Type"},
	Aggro = {MatchReason = "$1 hat Aggro", NoMatchReason = "$1 hat keine Aggro"},
	PvP = {MatchReason = "$1 PvP Markierung gesetzt", NoMatchReason = "$1 PvP Markierung nicht gesetzt"},
	SpellAlert = {MatchReason = "$1 zaubert $2", NoMatchReason = "$1 zaubert nicht $2"}
},

-- 3D models
aideCustomModels = "Auswählen, um eigene 3D-Modelle zu benutzen.",
aideModels = "Auswählen, um 3D-Modelle aus dem Spiel zu benutzen.",
nomCustomModels = "Custom",
nomModelX = "Modell X",
nomModelY = "Modell Y",
nomModelZ = "Modell Z",
nomModels = "Modelle",

-- Export dialog
ExportDialogCancelButton = "Schließen",
ExportDialogCopyTitle = "Drücke Strg-C um den untenstehenden Aura-Text zu kopieren.",
ExportDialogMidTitle = "an Spieler senden",
ExportDialogSendButton1 = "Senden",
ExportDialogSendButton2 = "Zurück",
ExportDialogSendTitle1 = "Gib unten einen Spielernamen ein und drücke 'Senden'.",
ExportDialogSendTitle3a = "%s ist im Kampf und kann die Auren nicht annehmen.",
ExportDialogSendTitle3b = "%s nimmt keine Auren an.",
ExportDialogSendTitle3c = "%s hat nicht geantwortet, könnte AFK oder offline sein.",
ExportDialogSendTitle3d = "%s empfängt derzeit bereits andere Auren.",
ExportDialogSendTitle3e = "%s hat den Empfang der Auren abgelehnt.",
ExportDialogSendTitle4 = "Sende Auren...",
ExportDialogSendTitle5 = "Senden erfolgreich!",
ExportDialogTopTitle = "Auren exportieren",

-- Import dialog
PlayerImportDialogAcceptButton1 = "Akzeptieren",
PlayerImportDialogAcceptButton2 = "Speichern",
PlayerImportDialogCancelButton1 = "Ablehnen",
PlayerImportDialogDescTitle1 = "%s möchte dir einige Auren senden.",
PlayerImportDialogDescTitle2 = "Empfange Auren...",
PlayerImportDialogDescTitle3 = "Das Angebot der Auren ist abgelaufen.",
PlayerImportDialogDescTitle4 = "Wähle eine Seite zum Speichern der Auren aus.",
PlayerImportDialogDescTitle5 = "Auren gespeichert!",
PlayerImportDialogDescTitle6 = "Es ist kein Platz für Auren vorhanden.",
PlayerImportDialogTopTitle = "Du bekommst Auren!",
PlayerImportDialogWarningTitle = "|cFFFF0000Hinweis: |rDir wird ein Satz Auren geschickt, dies wird alle bestehenden Auren auf der ausgewählten Seite überschreiben.",

ImportDialogAccept = "Importieren",
ImportDialogCancel = "Schließen"
})
elseif (GetLocale() == "esES") then
PowaAuras.Anim[0] = "[Invisible]"
PowaAuras.Anim[1] = "Estático"
PowaAuras.Anim[2] = "Brillante"
PowaAuras.Anim[3] = "Aumento"
PowaAuras.Anim[4] = "Pulsación"
PowaAuras.Anim[5] = "Burbujeo"
PowaAuras.Anim[6] = "Gota"
PowaAuras.Anim[7] = "Electrico"
PowaAuras.Anim[8] = "Contracción"
PowaAuras.Anim[9] = "Llama"
PowaAuras.Anim[10] = "Orbita"
PowaAuras.Anim[11] = "Giro horario"
PowaAuras.Anim[12] = "Giro antihorario"

PowaAuras.BeginAnimDisplay[0] = "[Nada]"
PowaAuras.BeginAnimDisplay[1] = "Zoom"
PowaAuras.BeginAnimDisplay[2] = "Zoom fuera"
PowaAuras.BeginAnimDisplay[3] = "Desaparecer"
PowaAuras.BeginAnimDisplay[4] = "Izquierda"
PowaAuras.BeginAnimDisplay[5] = "Arriba-izquierda"
PowaAuras.BeginAnimDisplay[6] = "Arriba"
PowaAuras.BeginAnimDisplay[7] = "Arriba-derecha"
PowaAuras.BeginAnimDisplay[8] = "Derecha"
PowaAuras.BeginAnimDisplay[9] = "Abajo-derecha"
PowaAuras.BeginAnimDisplay[10] = "Abajo"
PowaAuras.BeginAnimDisplay[11] = "Abajo-Izquierda"
PowaAuras.BeginAnimDisplay[12] = "Rebote"

PowaAuras.EndAnimDisplay[0] = "[Nada]"
PowaAuras.EndAnimDisplay[1] = "Aumentar"
PowaAuras.EndAnimDisplay[2] = "Encoger"
PowaAuras.EndAnimDisplay[3] = "Desaparecer"
PowaAuras.EndAnimDisplay[4] = "Girar"
PowaAuras.EndAnimDisplay[5] = "Girar adentro"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Teclea /powa para ver las opciones",

aucune = "Nada",
aucun = "Nada",
mainHand = "Principal",
offHand = "Secundaria",
bothHands = "Ambas",

Unknown = "Desconocido",

DebuffType =
{
	Magic = "Magia",
	Disease = "Enfermedad",
	Curse = "Maldición",
	Poison = "Veneno",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "Silenciado",
	[PowaAuras.DebuffCatType.Snare] = "Dormido",
	[PowaAuras.DebuffCatType.Stun] = "Aturdido",
	[PowaAuras.DebuffCatType.Root] = "Enraizado",
	[PowaAuras.DebuffCatType.Disarm] = "Desarmado",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

Role =
{
	RoleTank = "Tanque",
	RoleHealer = "Curador",
	RoleMeleDps = "DPS cuerpo a cuerpo",
	RoleRangeDps = "DPS a distancia"
},

nomReasonRole =
{
	RoleTank = "Es tanque",
	RoleHealer = "Es curador",
	RoleMeleDps = "Es DPS cuerpo a cuerpo",
	RoleRangeDps = "Es DPS a distancia"
},

nomReasonNotRole =
{
	RoleTank = "No es tanque",
	RoleHealer = "No es curador",
	RoleMeleDps = "No es DPS cuerpo a cuerpo",
	RoleRangeDps = "No es DPS a distancia"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Bufo",
	[PowaAuras.BuffTypes.Debuff] = "Debufo",
	[PowaAuras.BuffTypes.AoE] = "Debufo en AoE",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debufo (tipo)",
	[PowaAuras.BuffTypes.Enchant] = "Encantamiento de arma",
	[PowaAuras.BuffTypes.Combo] = "Puntos de combo",
	[PowaAuras.BuffTypes.ActionReady] = "Acción disponible",
	[PowaAuras.BuffTypes.Health] = "Vida",
	[PowaAuras.BuffTypes.Mana] = "Maná",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Ira/Energía/Poder",
	[PowaAuras.BuffTypes.Aggro] = "Aggro",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "Actitud",
	[PowaAuras.BuffTypes.SpellAlert] = "Alerta de hechizo",
	[PowaAuras.BuffTypes.SpellCooldown] = "CD de hechizo",
	[PowaAuras.BuffTypes.StealableSpell] = "Hechizo para robar",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Hechizo purgable",
	[PowaAuras.BuffTypes.Static] = "Aura estática",
	[PowaAuras.BuffTypes.Totems] = "Tótems",
	[PowaAuras.BuffTypes.Pet] = "Mascota",
	[PowaAuras.BuffTypes.Runes] = "Runas",
	[PowaAuras.BuffTypes.Slots] = "Ranuras de equipamiento",
	[PowaAuras.BuffTypes.Items] = "Nombre de objetos",
	[PowaAuras.BuffTypes.Tracking] = "Rastreo",
	[PowaAuras.BuffTypes.TypeBuff] = "Bufo (tipo)",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
	[PowaAuras.BuffTypes.GTFO] = "Alerta ¡Muévete!"
},

PowerType =
{
	[-1] = "Por defecto",
	[SPELL_POWER_RAGE] = "Ira",
	[SPELL_POWER_FOCUS] = "Enfoque",
	[SPELL_POWER_ENERGY] = "Energía",
	[SPELL_POWER_RUNIC_POWER] = "Poder rúnico",
	[SPELL_POWER_SOUL_SHARDS] = "Fragmentos de alma",
	[SPELL_POWER_LUNAR_ECLIPSE] = "Eclipse lunar",
	[SPELL_POWER_SOLAR_ECLIPSE] = "Eclipse solar",
	[SPELL_POWER_HOLY_POWER] = "Poder sagrado",
	[SPELL_POWER_ALTERNATE_POWER] = "Boss Power",
	[SPELL_POWER_DARK_FORCE] = "Dark Force",
	[SPELL_POWER_CHI] = "Chi",
	[SPELL_POWER_SHADOW_ORBS] = "Shadow Orbs",
	[SPELL_POWER_BURNING_EMBERS] = "Burning Embers",
	[SPELL_POWER_DEMONIC_FURY] = "Demonic Fury"
},

Relative =
{
	NONE = "Libre",
	TOPLEFT = "Arriba-Izquierda",
	TOP = "Arriba",
	TOPRIGHT = "Arriba-Derecha",
	RIGHT = "Derecha",
	BOTTOMRIGHT = "Abajo-Derecha",
	BOTTOM = "Abajo",
	BOTTOMLEFT = "Abajo-Izquierda",
	LEFT = "Izquierda",
	CENTER = "Centro"
},

Slots =
{
	Back = "Espalda",
	Chest = "Pecho",
	Feet = "Pies",
	Finger0 = "Dedo1",
	Finger1 = "Dedo2",
	Hands = "Manos",
	Head = "Cabeza",
	Legs = "Piernas",
	MainHand = "Mano derecha",
	Neck = "Cuello",
	SecondaryHand = "Mano izquierda",
	Shirt = "Camisa",
	Shoulder = "Hombros",
	Tabard = "Tabardo",
	Trinket0 = "Abalorio1",
	Trinket1 = "Abalorio2",
	Waist = "Cintura",
	Wrist = "Muñeca"
},

-- Main
nomEnable = "Activar Power Auras",
aideEnable = "Permitir todos los efectos de Power Auras",

nomDebug = "Activar mensajes de depuración",
aideDebug = "Permitir mensajes de depuración",
nomTextureCount = "Texturas máximas",
aideTextureCount = "Cambia esto si añades tus propias texturas",

aideOverrideTextureCount = "Sobrepasa número de texturas",
nomOverrideTextureCount = "Activa esto si vas a añadir tus propias texturas",

ListePlayer = "Página",
ListeGlobal = "Global",
aideMove = "Mover el aura aquí",
aideCopy = "Copiar el aura aquí.",
nomRename = "Renombrar",
aideRename = "Renombrar la página de efectos seleccionada",

nomTest = "Mostrar",
nomTestAll = "Mostrar todos",
nomHide = "Esconder todos",
nomEdit = "Editar",
nomNew = "Nuevo",
nomDel = "Borrar",
nomImport = "Importar",
nomExport = "Exportar",
nomImportSet = "Importar bloque",
nomExportSet = "Exportar bloque",
nomUnlock = "Desbloquear",
nomLock = "Bloquear",

aideImport = "Presiona Ctrl-V para pegar el código de aura y presiona \'Aceptar\'",
aideExport = "Presiona Ctrl-C para copiar el código de aura para compartir",
aideImportSet = "Presiona Ctrl-V para pegar el código de aura y presiona \'Aceptar\' esto borrará todas las auras en esta página",
aideExportSet = "Presiona Ctrl-C para copiar todas las auras de esta página para compartir",
aideDel = "Borra el aura seleccionada (mantén CTRL presionado para que el botón funcione)",

nomMove = "Mover",
nomCopy = "Copiar",
nomPlayerEffects = "Auras del personaje",
nomGlobalEffects = "Auras globales",

aideEffectTooltip = "(Shift-Click para activar/desactivar un aura)",
aideEffectTooltip2 = "(CTRL-Click para comprobación de funcionamiento)",

aideItems = "Introduce el nombre completo del objeto o [xxx] para su ID",
aideSlots = "Introduce el nombre de la ranura a rastrear: Munición, Espalda, Pecho, Pies, Dedo1, Dedo2, Manos, Cabeza, Piernas, Mano derecha, Collar, A distancia, Mano izquierda, Camisa, Hombros, Tabardo, Abalorio1, Abalorio2, Cintura, Muñeca",
aideTracking = "Introduce el nombre del tipo de rastreo ej. pescado",

-- Editor
aideCustomText = "Introduce texto para mostrar (%t=nombre del objetivo, %f=nombre del foco, %v=valor de visualización, %u=nombre de la unidad, %str=fuerza, agl=agilidad, %sta=aguante, %int=intelecto, %sp1=espíritu, %sp=poder con hechizos, %ap=poder de ataque)",

nomSound = "Sonido para reproducir",
nomSound2 = "Más sonidos para reproducir",
aideSound = "Reproduce un sonido al inicio",
aideSound2 = "Reproduce un sonido al inicio",
nomCustomSound = "O archivo de sonido",
aideCustomSound = "Introduce un archivo de sonido que esté en la carpeta de sonidos, ANTES de iniciar el juego. Mp3 y wav son compatibles. Ej: 'cookie.mp3' o introduce la ruta completa para reproducir cualquier sonido del WoW ej: Sound\\Events\\GuldanCheers.wav",

nomCustomSoundPath = "Ruta sonidos personalizados:",
aideCustomSoundPath = "Publica tu propia ruta (within the WoW install) para evitar sobreescribirlos al actualizar Power Auras",

nomCustomAuraPath = "Ruta texturas personalizados:",
aideCustomAuraPath = "Publica tu propia ruta (within the WoW install) para evitar sobreescribirlas al actualizar Power Auras",

nomSoundEnd = "Sonido para reproducir",
nomSound2End = "Más sonidos para reproducir",
aideSoundEnd = "Reproduce un sonido al final",
aideSound2End = "Reproduce un sonido al final",
nomCustomSoundEnd = "O archivo de sonido",
aideCustomSoundEnd = "Introduce un archivo de sonido que esté en la carpeta de sonidos, ANTES de iniciar el juego. Mp3 y wav son compatibles. Ej: 'cookie.mp3' o introduce la ruta completa para reproducir cualquier sonido del WoW ej: Sound\\Events\\GuldanCheers.wav",
nomTexture = "Textura",
aideTexture = "Textura para mostrar. Puedes cambiar las texturas facilmente cambiando el archivo Aura#.tga en la carpeta Addons",

nomAnim1 = "Animación principal",
nomAnim2 = "Animación secundaria",
aideAnim1 = "Anima la textura o no, con varios efectos",
aideAnim2 = "Esta animación se mostrará con menos opacidad que la principal. Cuidado con no sobrecargar la pantalla",

nomDeform = "Deformación",

aideColor = "Click aquí para cambiar el color de la textura",
aideTimerColor = "Click aquí para cambiar el color del reloj",
aideStacksColor = "Click aquí para cambiar el color de las acumulaciones",
aideFont = "Click aquí para elegir la fuente. Presiona OK para aplicar",
aideMultiID = "Introduce aquí IDs de otras auras para combinar comprobaciones. Varias IDs deben separarse con '/'. El ID del aura puede verse como [#] en la primera línea de la descripción del aura",
aideTooltipCheck = "Comprueba también que la descripción contiene este texto",

aideBuff = "Introduce aquí el nombre del bufo, o una parte del nombre, que debe activar/desactivar el aura. Puedes introducir varios nombres (ej: Super Bufo/Poder)",
aideBuff2 = "Introduce aquí el nombre del debufo, o una parte del nombre, que debe activar/desactivar el aura. Puedes introducir varios nombres (ex: Dark Disease/Plague)",
aideBuff3 = "Introduce aquí el tipo de debufoque debe activar o desactivar el aura (Veneno, Enfermedad, Maldición, Magia, CC, Silenciado, Aturdido, Dormido, Enraizado o nada). Puedes introducir varios tipos (ej: enfermedad/veneno)",
aideBuff4 = "Introduce aquí el nombre del AoE que debe activar el aura (lluvia de fuego por ejemplo, el nombre del AOE puede verse en el registro de combate)",
aideBuff5 = "Introduce aquí el encantamiento temporal que debe activar el aura: como opción precédelo con 'main/' o 'off/ para designar ranura de mano derecha o izquierda (ej: main/mangosta)",
aideBuff6 = "Introduce aquí el número de puntos de combo que deben activar el aura (ej: 1 o 1/2/3 o 0/4/5 etc...) ",
aideBuff7 = "Introduce aquí el nombre, o una parte del nombre, de una habilidad en tus barras de acción. Este aura estará activa cuando esa habilidad se pueda utilizar",
aideBuff8 = "Introduce aquí el nombre, o una parte del nombre, de una habilidad de tu libro de hechizos. Puedes introducir una ID de habilidad [12345]",

aideSpells = "Introduce aquí el nombre de la habilidad que activará un aura de alerta de hechizo",
aideStacks = "Introduce aquí el símbolo y la cantidad de acumulaciones requiridas para activar/desactivar el aura. Requerido símbolo ej: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "Introduce aquí el nombre del hechizo para robar que activará el aura (usa * para cualquier hechizo para robar)",
aidePurgeableSpells = "Introduce aquí el nombre del hechizo purgable que activará el aura (usa * para cualquier hechizo purgable)",

aideTotems = "Introduce aquí el nombre del tótem que activará el aura o su número 1=fuego, 2=tierra, 3=agua, 4=aire (usa * para cualquier tótem)",

aideRunes = "Introduce aquí las runas que activarán el aura B/b=sangre, F/f=escarcha, U/u=profana, D/d=muerte (las runas de muerte contarán como las de otro tipo si usas las casillas de ignorar mayúsculas/minúsculas) ex: 'BF' 'BfU' 'DDD'",

aideUnitn = "Introduce aquí el nombre de la unidad, que debe activar/desactivar el aura. Puedes introducir sólo nombres, si están en tu banda/grupo",
aideUnitn2 = "Sólo para banda/grupo",

aideMaxTex = "Define el número máximo de texturas en el editor. Si añades texturas en la carpeta Mod (con los nombres AURA1.tga a AURA50.tga), debes indicar el número correcto aquí",
aideWowTextures = "Activa esto para usar texturas de WoW en lugar de las texturas en la carpeta de Power Auras para este aura",
aideTextAura = "Activa esto para poner texto en lugar de textura",
aideRealaura = "Aura auténtica",
aideCustomTextures = "Activa esto para usar texturas de la subcarpeta 'Custom'. Introduce el nombre de la textura debajo (ej: miTextura.tga). Puedes usar un nombre de habilidad (ej: lluvia de fuego) o ID de habilidad (ej: 5384)",
aideRandomColor = "Activa esto para que este aura use color aleatorio cada vez que se active",

aideTexMode = "Desactiva esto para usar la opacidad de la textura. Por defecto, los colores más oscuros serán más transparentes",

nomActivationBy = "Activado por",

nomOwnTex = "Usar textura propia",
aideOwnTex = "Usar la textura del bufo/debufo o habilidad",
nomStacks = "Acumulaciones",

nomUpdateSpeed = "Velocidad de actualización",
nomSpeed = "Velocidad de animación",
nomTimerUpdate = "Velocidad de actualización del reloj",
nomBegin = "Iniciar animación",
nomEnd = "Finalizar animación",
nomSymetrie = "Simetría",
nomAlpha = "Opacidad",
nomPos = "Posición",
nomTaille = "Tamaño",

nomExact = "Nombre exacto",
nomThreshold = "Umbral",
aideThreshInv = "Activa esto para invertir la lógica del umbral. Desactivado = poca alerta / Activado = mucha alerta.",
nomThreshInv = "</>",
nomStance = "Actitud",
nomGTFO = "Tipo de alerta",
nomPowerType = "Tipo de poder",

nomMine = "Lanzado por mí",
aideMine = "Activa esto para mostrar sólo bufos/debufos lanzados por el jugador",
nomDispellable = "Puedo disipar",
aideDispellable = "Activa esto para mostrar sólo bufos que son disipables",
nomCanInterrupt = "Puede interrumpirse",
aideCanInterrupt = "Activa esto para mostrar sólo hechizos que pueden interrumpirse",
nomIgnoreUseable = "Reutilización sólo",
aideIgnoreUseable = "Ignora si la habilidad se puede usar (sólo usa el CD)",
nomIgnoreItemUseable = "Sólo si equipado",
aideIgnoreItemUseable = "Ignora si el objeto se puede utilizar (sólo si está equipado)",
nomCheckPet = "Mascota",
aideCheckPet = "Marca para monitorizar sólo habilidades de mascota",

nomOnMe = "Lanzado en mí",
aideOnMe = "Mostrar sólo si se lanza en mí",

nomPlayerSpell = "Jugador lanzando",
aidePlayerSpell = "Comprobar si el jugador esta lanzando un hechizo",

nomCheckTarget = "Objetivo enemigo",
nomCheckFriend = "Objetivo amistoso",
nomCheckParty = "Miembro de grupo",
nomCheckFocus = "Foco",
nomCheckRaid = "Miembro de banda",
nomCheckGroupOrSelf = "Banda/grupo o yo",
nomCheckGroupAny = "Cualquiera",
nomCheckOptunitn = "Nombre de unidad",

aideTarget = "Activa esto para comprobar sólo al objetivo enemigo",
aideTargetFriend = "Activa esto para comprobar sólo al objetivo amistoso.",
aideParty = "Activa esto para comprobar sólo a miembros del grupo",
aideGroupOrSelf = "Activa esto para comprobar a miembros del grupo/banda o a tí mismo",
aideFocus = "Activa esto para comprobar sólo al foco",
aideRaid = "Activa esto para comprobar sólo a miembros de banda",
aideGroupAny = "Activa esto para comprobar bufos en 'Cualquier' miembro del grupo/banda. Desactivado: comprueba que 'Todos' estén bufados",
aideOptunitn = "Activa esto para comprobar sólo a un personaje miembro del grupo/banda",
aideExact = "Activa esto para comprobar el nombre exacto del bufo/debufo/acción",
aideStance = "Selecciona qué actitud, aura o forma activa el aura",
aideGTFO = "Selecciona qué alerta ¡muévete! cativa el aura",
aidePowerType = "Selecciona qué tipo de recurso monitorizar",

aideShowSpinAtBeginning = "Al final del inicio de la animación, ejecuta un giro de 360 grados",
nomCheckShowSpinAtBeginning = "Ejecuta un giro después del inicio de la animación",

nomCheckShowTimer = "Mostrar",
nomTimerDuration = "Duración",
aideTimerDuration = "Muestra un reloj para simular la duración del bufo/debufo en el objetivo (0 para desactivar)",
aideShowTimer = "Activa esto para mostrar el reloj de este efecto",
aideSelectTimer = "Selecciona qué reloj mostrará la duración",
aideSelectTimerBuff = "Selecciona qué reloj mostrará la duración (reservado para los bufos de jugadores)",
aideSelectTimerDebuff = "Selecciona qué reloj mostrará la duración (reservado para los debufos de jugadores)",

nomCheckShowStacks = "Mostrar",
aideShowStacks = "Activa esto para mostrar las acumulaciones de este efecto",

nomCheckInverse = "Invertir",
aideInverse = "Invierte la lógica para mostrar este aura sólo cuando el bufo/debufo no está activo",

nomCheckIgnoreMaj = "Ignorar tipografía",
aideIgnoreMaj = "Activa esto para ignorar mayúsculas/minúsculas del nombre de bufos/debufos",

nomAuraDebug = "Depurar",
aideAuraDebug = "Depurar este aura",

nomDuration = "Duración de la animación",
aideDuration = "Después de este tiempo, el aura desaparecerá (0 para desactivar)",

nomOldAnimations = "Animaciones antiguas",
aideOldAnimations = "Usar animaciones antiguas",

nomCentiemes = "Mostrar centésimas",
nomDual = "Mostrar dos relojes",
nomHideLeadingZeros = "Ocultar ceros a la izquierda",
nomTransparent = "Usar texturas transparantes",
nomActivationTime = "Mostrar tiempo desde la activación",
nomTimer99 = "Mostrar segundos por debajo de 100",
nomUseOwnColor = "Usar color personalizado",
nomUpdatePing = "Animar al renovar",
nomLegacySizing = "Dígitos más anchos",
nomRelative = "Relación con el aura",
nomClose = "Cerrar",
nomEffectEditor = "Editor de efectos",
nomAdvOptions = "Opciones",
nomMaxTex = "Máximo de texturas disponibles",
nomTabAnim = "Animación",
nomTabActiv = "Activación",
nomTabSound = "Sonido",
nomTabTimer = "Reloj",
nomTabStacks = "Acumulaciones",
nomWowTextures = "Texturas WoW",
nomCustomTextures = "Texturas personalizadas",
nomTextAura = "Aura de texto",
nomRealaura = "Aura auténtica",
nomRandomColor = "Color aleatorio",

nomTalentGroup1 = "Talentos 1",
aideTalentGroup1 = "Muestra este efecto sólo cuando usas tus talentos principales",
nomTalentGroup2 = "Talentos 2",
aideTalentGroup2 = "Muestra este efecto sólo cuando usas tus talentos secundarios",

nomReset = "Reiniciar posiciones del editor",
nomPowaShowAuraBrowser = "Mostrar buscador de auras",

nomDefaultTimerTexture = "Textura del reloj por defecto",
nomTimerTexture = "Textura del reloj",
nomDefaultStacksTexture = "Textura de las acumulaciones por defecto",
nomStacksTexture = "Textura de las acumulaciones",

Enabled = "Habilitado",
Default = "Por defecto",

Ternary =
{
	combat = "En combate",
	inRaid = "En banda",
	inParty = "En grupo",
	isResting = "Descansando",
	ismounted = "Sobre montura",
	inVehicle = "En vehículo",
	isAlive = "Vivo",
	PvP = "PvP activado",
	Instance5Man = "5-Normal",
	Instance5ManHeroic = "5-Heróico",
	Instance10Man = "10-Normal",
	Instance10ManHeroic = "10-Heróico",
	Instance25Man = "25-Normal",
	Instance25ManHeroic = "25-Heróico",
	InstanceBg = "Campo de batalla",
	InstanceArena = "Arena"
},

nomWhatever = "Ignorado",
aideTernary = "Establece cuando este aura se muestra.",

TernaryYes =
{
	combat = "Sólo en combate",
	inRaid = "Sólo en banda",
	inParty = "Sólo en grupo",
	isResting = "Sólo descansando",
	ismounted = "Sólo sobre montura",
	inVehicle = "Sólo en vehículos",
	isAlive = "Sólo vivo",
	PvP = "Sólo con PvP activado",
	Instance5Man = "Sólo en mazmorras 5-Normal",
	Instance5ManHeroic = "Sólo en mazmorras 5-Heróico",
	Instance10Man = "Sólo en bandas 10-Normal",
	Instance10ManHeroic = "Sólo en bandas 10-Heróico",
	Instance25Man = "Sólo en bandas 25-Normal",
	Instance25ManHeroic = "Sólo en bandas 25-Heróico",
	InstanceBg = "Sólo en campos de batalla",
	InstanceArena = "Sólo en Arenas",
	RoleTank = "Sólo cuando tanque",
	RoleHealer = "Sólo cuando curador",
	RoleMeleDps = "Sólo cuando DPS cuerpo a cuerpo",
	RoleRangeDps = "Sólo cuando DPS a distancia"
},

TernaryNo =
{
	combat = "Sólo cuando no en combate",
	inRaid = "Sólo cuando no en banda",
	inParty = "Sólo cuando no en grupo",
	isResting = "Sólo cuando no descansando",
	ismounted = "Sólo cuando no sobre montura",
	inVehicle = "Sólo cuando no en vehículos",
	isAlive = "Sólo muerto",
	PvP = "Sólo cuando PvP desactivado",
	Instance5Man = "Sólo cuando no en mazmorras 5-Normal",
	Instance5ManHeroic = "Sólo cuando no en mazmorras 5-Heróico",
	Instance10Man = "Sólo cuando no en bandas 10-Normal",
	Instance10ManHeroic = "Sólo cuando no en bandas 10-Heróico",
	Instance25Man = "Sólo cuando no en bandas 25-Normal",
	Instance25ManHeroic = "Sólo cuando no en bandas 25-Heróico",
	InstanceBg = "Sólo cuando no en campos de batalla",
	InstanceArena = "Sólo cuando no en arena",
	RoleTank = "Sólo cuando no tanque",
	RoleHealer = "Sólo cuando no curador",
	RoleMeleDps = "Sólo cuando no DPS cuerpo a cuerpo",
	RoleRangeDps = "Sólo cuando no DPS a distancia"
},

TernaryAide =
{
	combat = "Efecto modificado por estado de combate",
	inRaid = "Efecto modificado por estado de banda",
	inParty = "Efecto modificado por estado de grupo",
	isResting = "Efecto modificado por descansado",
	ismounted = "Efecto modificado por montura",
	inVehicle = "Efecto modificado por vehículos",
	isAlive = "Efecto modificado por vida",
	PvP = "Efecto modificado por estado de PvP",
	Instance5Man = "Efecto modificado por estar en mazmorra 5-Normal",
	Instance5ManHeroic = "Efecto modificado por estar en mazmorra 5-Heróico",
	Instance10Man = "Efecto modificado por estar en banda 10-Normal",
	Instance10ManHeroic = "Efecto modificado por estar en banda 10-Heróico",
	Instance25Man = "Efecto modificado por estar en banda 25-Normal",
	Instance25ManHeroic = "Efecto modificado por estar en banda 25-Heróico",
	InstanceBg = "Efecto modificado por estar en campo de batalla",
	InstanceArena = "Efecto modificado por estar en arena",
	RoleTank = "Efecto modificado por ser tanque",
	RoleHealer = "Efecto modificado por ser curador",
	RoleMeleDps = "Efecto modificado por ser DPS cuerpo a cuerpo",
	RoleRangeDps = "Efecto modificado por ser DPS a distancia"
},

nomTimerInvertAura = "Invertir aura cuando tiempo inferior a",
aidePowaTimerInvertAuraSlider = "Invertir aura cuando cuando la duración sea menos que el límite (0 para desactivar)",
nomTimerHideAura = "Ocultar aura y reloj hasta",
aidePowaTimerHideAuraSlider = "Ocultar aura y reloj cuando la duracion sea mayor que el límite (0 para desactivar)",

aideTimerRounding = "Al comprobar, se redondeará el tiempo",
nomTimerRounding = "Redondear",

aideAllowInspections = "Permitir a Power Auras inspeccionar a los jugadores para determinar roles, desactivando esto se sacrifica precisión por rapidez",
nomAllowInspections = "Permitir inspeccionar",

nomCarried = "Sólo si en bolsas",
aideCarried = "Ignora si el objeto se puede utilizar (sólo si está en las bolsas)",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "Debería mostrarse porque $1",
nomReasonWontShow = "No debería mostrarse porque $1",

nomReasonMulti = "Todos los múltiples concuerdan con $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras desactivado",
nomReasonGlobalCooldown = "Ignora el tiempo de reutilización global",

nomReasonBuffPresent = "$1 tiene $2 $3", --$1=Target $2=BuffType, $3=BuffName (ej: "unidad4 tiene el debufo miseria")
nomReasonBuffMissing = "$1 no tiene $2 $3", --$1=Target $2=BuffType, $3=BuffName (ej: "unidad4 no tiene el debufo miseria")
nomReasonBuffFoundButIncomplete = "$2 $3 found for $1 but\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (ej: "Debufo hender armadura encontrado en objetivo pero \nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 tiene $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (ej: "Raid23 tiene bufo Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "No todos en $1 tienen $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "No todos en banda tienen bufo Blessing of Kings")
nomReasonAllInGroupHaveBuff = "Todos en $1 tienen $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "Todos en banda tienen bufo Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "Nadie en $1 has $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "Nadie en banda tiene bufo Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Bufo encontrado, reloj invertido",
nomReasonBuffPresentNotMine = "No lanzado por mí",
nomReasonBuffFound = "Bufo encontrado",
nomReasonStacksMismatch = "Acumulaciones = $1 , se esperaban $2", --$1=Actual Stack count, $2=Expected Stack logic match (ej: ">=0")

nomReasonAuraMissing = "Falta aura",
nomReasonAuraOff = "Aura desactivada",
nomReasonAuraBad = "Aura falsa",

nomReasonNotForTalentSpec = "Aura no activa para esta especialización de talentos",

nomReasonPlayerDead = "El jugador está muerto",
nomReasonPlayerAlive = "El jugador está vivo",
nomReasonNoTarget = "No hay objetivo",
nomReasonTargetPlayer = "El objetivo eres tú",
nomReasonTargetDead = "El objetivo está muerto",
nomReasonTargetAlive = "El objetivo está vivo",
nomReasonTargetFriendly = "El objetivo es amistoso",
nomReasonTargetNotFriendly = "El objetivo no es amistoso",

nomReasonNoPet = "El jugador no tiene mascota",

nomReasonNotInCombat = "No en combate",
nomReasonInCombat = "En combate",

nomReasonInParty = "En grupo",
nomReasonInRaid = "En banda",
nomReasonNotInParty = "No en grupo",
nomReasonNotInRaid = "No en banda",
nomReasonNotInGroup = "No en grupo/banda",
nomReasonNoFocus = "No hay foco",
nomReasonNoCustomUnit = "No se encuentra la unidad en grupo, banda o con mascota=$1",
nomReasonPvPFlagNotSet = "PvP no activado",
nomReasonPvPFlagSet = "PvP activado",

nomReasonNotMounted = "No sobre montura",
nomReasonMounted = "Sobre montura",
nomReasonNotInVehicle = "No en vehículo",
nomReasonInVehicle = "En vehículo",
nomReasonNotResting = "No descansando",
nomReasonResting = "Descansando",
nomReasonStateOK = "Estado OK",

nomReasonNotIn5ManInstance = "No en mazmorra 5-Normal",
nomReasonIn5ManInstance = "En mazmorra 5-Normal",
nomReasonNotIn5ManHeroicInstance = "No en mazmorra 5-Heróico",
nomReasonIn5ManHeroicInstance = "En mazmorra 5-Heróico",

nomReasonNotIn10ManInstance = "No en banda 10-Normal",
nomReasonIn10ManInstance = "En banda 10-Normal",
nomReasonNotIn10ManHeroicInstance = "No en banda 10-Heróico",
nomReasonIn10ManHeroicInstance = "En banda 10-Heróico",

nomReasonNotIn25ManInstance = "No en banda 25-Normal",
nomReasonIn25ManInstance = "En banda 25-Normal",
nomReasonNotIn25ManHeroicInstance = "No en banda 25-Heróico",
nomReasonIn25ManHeroicInstance = "En banda 25-Heróico",

nomReasonNotInBgInstance = "No en campo de batalla",
nomReasonInBgInstance = "En campo de batalla",
nomReasonNotInArenaInstance = "No en arena",
nomReasonInArenaInstance = "En arena",

nomReasonInverted = "$1 (invertido)", -- $1 es la razón, pero la casilla invertido está marcada, así que la lógica está invertida

nomReasonSpellUsable = "Habilidad $1 se puede usar",
nomReasonSpellNotUsable = "Habilidad $1 no se puede usar",
nomReasonSpellNotReady = "Habilidad $1 no preparada, en reutilización, reloj invertido",
nomReasonSpellNotEnabled = "Habilidad $1 no habilitada ",
nomReasonSpellNotFound = "Habilidad $1 no encontrada",
nomReasonSpellOnCooldown = "Habilidad $1 en reutilización",

nomReasonCastingOnMe = "$1 lanzando $2 en mí", --$1=CasterName $2=SpellName (ej: "Rotface is casting Slime Spray on me")
nomReasonNotCastingOnMe = "Habilidad desconocida lanzándose en mí",

nomReasonCastingByMe = "Estoy lanzando $1 en $2", --$1=SpellName $2=TargetName (e.g. "I am casting Holy Light on Fred")
nomReasonNotCastingByMe = "No se encuentra el hechizo lanzado por mí",

nomReasonAnimationDuration = "Aún dentro de la duración personalizada",

nomReasonItemUsable = "Objeto $1 se puede usar",
nomReasonItemNotUsable = "Objeto $1 no se puede usar",
nomReasonItemNotReady = "Objeto $1 no preparado, en reutilización, reloj invertido",
nomReasonItemNotEnabled = "Objeto $1 no habilitado",
nomReasonItemNotFound = "Objeto $1 no encontrado",
nomReasonItemOnCooldown = "Objeto $1 en reutilización",

nomReasonItemEquipped = "Objeto $1 equipado",
nomReasonItemNotEquipped = "Objeto $1 no equipado",

nomReasonItemInBags = "Objeto $1 en bolsas",
nomReasonItemNotInBags = "Objeto $1 no en bolsas",
nomReasonItemNotOnPlayer = "Objeto $1 no transportado",

nomReasonSlotUsable = "$1 ranura se puede usar",
nomReasonSlotNotUsable = "$1 ranura no se puede usar",
nomReasonSlotNotReady = "$1 ranura no preparada, en reutilización, reloj invertido",
nomReasonSlotNotEnabled = "$1 ranura no tiene reutilización",
nomReasonSlotNotFound = "$1 ranura no encontrada",
nomReasonSlotOnCooldown = "$1 ranura en reutilización",
nomReasonSlotNone = "$1 ranura está vacía",

nomReasonStealablePresent = "$1 tiene hechizo para robar $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "Nadie tiene hechizo para robar $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "Raid$1Target tiene hechizo para robar $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "Party$1Target tiene hechizo para robar $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 tiene hechizo purgable $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "Nadie tiene hechizo purgable $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "Raid$1Target tiene hechizo purgable $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "Party$1Target tiene hechizo purgable $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonAoETrigger = "AoE $1 activado", -- $1=AoE spell name
nomReasonAoENoTrigger = "AoE no activada $1", -- $1=AoE spell match

nomReasonEnchantMainInvert = "Mano derecha $1 encantamiento encontrado, reloj invertido", -- $1=Enchant match
nomReasonEnchantMain = "Mano derecha $1 encantamiento encontrado", -- $1=Enchant match
nomReasonEnchantOffInvert = "Mano izquierda $1 encantamiento encontrado, reloj invertido", -- $1=Enchant match
nomReasonEnchantOff = "Mano izquierda $1 encantamiento encontrado", -- $1=Enchant match
nomReasonNoEnchant = "Encantamiento no encontrado en armas $1", -- $1=Enchant match

nomReasonNoUseCombo = "No usas puntos de combo",
nomReasonNoUseComboInForm = "No usas puntos de combo bajo esta forma",
nomReasonComboMatch = "Puntos de combo $1 concuerdan con $2", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "Puntos de combo $1 no concuerdan con $2", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "No encontrado en barras de acción",
nomReasonActionReady = "Habilidad preparada",
nomReasonActionNotReadyInvert = "Habilidad no preparada (reutilización), reloj invertido",
nomReasonActionNotReady = "Habilidad no preparada (reutilización)",
nomReasonActionlNotEnabled = "Habilidad deshabilitada",
nomReasonActionNotUsable = "No se puede usar la habilidad",

nomReasonYouAreCasting = "Estás lanzando $1", -- $1=Casting match
nomReasonYouAreNotCasting = "No estás lanzando $1", -- $1=Casting match
nomReasonTargetCasting = "Objetivo lanzando $1", -- $1=Casting match
nomReasonFocusCasting = "Foco lanzando $1", -- $1=Casting match
nomReasonRaidTargetCasting = "Raid$1Target lanzando $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "Party$1Target lanzando $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "Objetivo de nadie lanzando $1", -- $1=Casting match

nomReasonStance = "Actitud actual $1, concuerda con $2", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "Actitud actual $1, no concuerda con $2", -- $1=Current Stance, $2=Match Stance

nomReasonRunesNotReady = "Runas no preparadas",
nomReasonRunesReady = "Runas preparadas",

nomReasonPetExists= "El jugador tiene mascota",
nomReasonPetMissing = "Falta mascota del jugador",

nomReasonTrackingMissing = "Rastreo no fijado en $1",
nomTrackingSet = "Rastreo fijado en $1",

nomNotInInstance = "Actitud no adecuada",

nomReasonStatic = "Aura estática",

nomReasonUnknownName = "Nombre de la unidad desconocido",
nomReasonRoleUnknown = "Rol desconocido",
nomReasonRoleNoMatch = "Rol no coincidente",

nomUnknownSpellId = "PowerAuras: Aura $1 hace referencia a un ID desconocido", -- $1=SpellID

nomReasonGTFOAlerts = "Las alertas ¡muévete! no siempre están activadas",

ReasonStat =
{
	Health = {MatchReason = "$1 poca vida", NoMatchReason = "$1 demasiada vida"},
	Mana = {MatchReason = "$1 poco maná", NoMatchReason = "$1 demasiado maná"},
	Power = {MatchReason = "$1 poco poder", NoMatchReason = "$1 demasiado poder", NilReason = "$1 tiene un tipo de poder distinto"},
	Aggro = {MatchReason = "$1 tiene aggro", NoMatchReason = "$1 no tiene aggro"},
	PvP = {MatchReason = "$1 PvP activado", NoMatchReason = "$1 PvP no activado"},
	SpellAlert = {MatchReason = "$1 lanzando $2", NoMatchReason = "$1 no está lanzando $2"}
},

-- Export dialog
ExportDialogTopTitle = "Exportar Auras",
ExportDialogCopyTitle = "Presiona Ctrl-C para copiar el código de aura inferior",
ExportDialogMidTitle = "Enviar a jugador",
ExportDialogSendTitle1 = "Introduce el nombre de un jugador y pulsa el botón 'Enviar'",
ExportDialogSendTitle2 = "Conectando %s (%d segundos restantes)...", -- The 1/2/3/4 suffix denotes the internal status of the frame.
ExportDialogSendTitle3a = "%s está en combate y no puede aceptar",
ExportDialogSendTitle3b = "%s no acepta peticiones",
ExportDialogSendTitle3c = "%s no ha respondido, puede que esté ausente",
ExportDialogSendTitle3d = "%s está recibiendo otra petición",
ExportDialogSendTitle3e = "%s ha rechazado la petición",
ExportDialogSendTitle4 = "Enviando auras...",
ExportDialogSendTitle5 = "¡Envío realizado!",
ExportDialogSendButton1 = "Enviar",
ExportDialogSendButton2 = "Atrás",
ExportDialogCancelButton = "Cerrar",

-- Cross-client import dialog
PlayerImportDialogTopTitle = "¡Tienes auras!",
PlayerImportDialogDescTitle1 = "%s quiere enviarte auras",
PlayerImportDialogDescTitle2 = "Recibiendo auras...",
PlayerImportDialogDescTitle3 = "La petición ha caducado",
PlayerImportDialogDescTitle4 = "Selecciona una página para guardar las auras",
PlayerImportDialogWarningTitle = "|cFFFF0000Note: |rTe están enviando un bloque de auras, esto sobreescribirá todas las auras de esta página",
PlayerImportDialogDescTitle5 = "¡Auras guardadas!",
PlayerImportDialogDescTitle6 = "No hay ranuras para auras disponibles",
PlayerImportDialogAcceptButton1 = "Aceptar",
PlayerImportDialogAcceptButton2 = "Guardar",
PlayerImportDialogCancelButton1 = "Rechazar",

aideCommsRegisterFailure = "There was an error when setting up addon communications.",
aideBlockIncomingAuras = "Evita que otros te envíen sus auras",
nomBlockIncomingAuras = "Bloque de auras entrante",
})
elseif (GetLocale() == "esMX") then
PowaAuras.Anim[0] = "[Invisible]"
PowaAuras.Anim[1] = "Estático"
PowaAuras.Anim[2] = "Brillante"
PowaAuras.Anim[3] = "Aumento"
PowaAuras.Anim[4] = "Pulsación"
PowaAuras.Anim[5] = "Burbujeo"
PowaAuras.Anim[6] = "Gota"
PowaAuras.Anim[7] = "Electrico"
PowaAuras.Anim[8] = "Contracción"
PowaAuras.Anim[9] = "Llama"
PowaAuras.Anim[10] = "Orbita"
PowaAuras.Anim[11] = "Giro horario"
PowaAuras.Anim[12] = "Giro antihorario"

PowaAuras.BeginAnimDisplay[0] = "[Nada]"
PowaAuras.BeginAnimDisplay[1] = "Zoom"
PowaAuras.BeginAnimDisplay[2] = "Zoom fuera"
PowaAuras.BeginAnimDisplay[3] = "Desaparecer"
PowaAuras.BeginAnimDisplay[4] = "Izquierda"
PowaAuras.BeginAnimDisplay[5] = "Arriba-izquierda"
PowaAuras.BeginAnimDisplay[6] = "Arriba"
PowaAuras.BeginAnimDisplay[7] = "Arriba-derecha"
PowaAuras.BeginAnimDisplay[8] = "Derecha"
PowaAuras.BeginAnimDisplay[9] = "Abajo-derecha"
PowaAuras.BeginAnimDisplay[10] = "Abajo"
PowaAuras.BeginAnimDisplay[11] = "Abajo-Izquierda"
PowaAuras.BeginAnimDisplay[12] = "Rebote"

PowaAuras.EndAnimDisplay[0] = "[Nada]"
PowaAuras.EndAnimDisplay[1] = "Aumentar"
PowaAuras.EndAnimDisplay[2] = "Encoger"
PowaAuras.EndAnimDisplay[3] = "Desaparecer"
PowaAuras.EndAnimDisplay[4] = "Girar"
PowaAuras.EndAnimDisplay[5] = "Girar adentro"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Teclea /powa para ver las opciones",

aucune = "Nada",
aucun = "Nada",
mainHand = "Principal",
offHand = "Secundaria",
bothHands = "Ambas",

Unknown	 = "Desconocido",

DebuffType =
{
	Magic = "Magia",
	Disease = "Enfermedad",
	Curse = "Maldición",
	Poison = "Veneno",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "Silenciado",
	[PowaAuras.DebuffCatType.Snare] = "Dormido",
	[PowaAuras.DebuffCatType.Stun] = "Aturdido",
	[PowaAuras.DebuffCatType.Root] = "Enraizado",
	[PowaAuras.DebuffCatType.Disarm] = "Desarmado",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

Role =
{
	RoleTank = "Tanque",
	RoleHealer = "Curador",
	RoleMeleDps = "DPS cuerpo a cuerpo",
	RoleRangeDps = "DPS a distancia"
},

nomReasonRole =
{
	RoleTank = "Es tanque",
	RoleHealer = "Es curador",
	RoleMeleDps = "Es DPS cuerpo a cuerpo",
	RoleRangeDps = "Es DPS a distancia"
},

nomReasonNotRole =
{
	RoleTank = "No es tanque",
	RoleHealer = "No es curador",
	RoleMeleDps = "No es DPS cuerpo a cuerpo",
	RoleRangeDps = "No es DPS a distancia"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Bufo",
	[PowaAuras.BuffTypes.Debuff] = "Debufo",
	[PowaAuras.BuffTypes.AoE] = "Debufo en AoE",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debufo (tipo)",
	[PowaAuras.BuffTypes.Enchant] = "Encantamiento de arma",
	[PowaAuras.BuffTypes.Combo] = "Puntos de combo",
	[PowaAuras.BuffTypes.ActionReady] = "Acción disponible",
	[PowaAuras.BuffTypes.Health] = "Vida",
	[PowaAuras.BuffTypes.Mana] = "Maná",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Ira/Energía/Poder",
	[PowaAuras.BuffTypes.Aggro] = "Aggro",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "Actitud",
	[PowaAuras.BuffTypes.SpellAlert] = "Alerta de hechizo",
	[PowaAuras.BuffTypes.SpellCooldown] = "CD de hechizo",
	[PowaAuras.BuffTypes.StealableSpell] = "Hechizo para robar",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Hechizo purgable",
	[PowaAuras.BuffTypes.Static] = "Aura estática",
	[PowaAuras.BuffTypes.Totems] = "Tótems",
	[PowaAuras.BuffTypes.Pet] = "Mascota",
	[PowaAuras.BuffTypes.Runes] = "Runas",
	[PowaAuras.BuffTypes.Slots] = "Ranuras de equipamiento",
	[PowaAuras.BuffTypes.Items] = "Nombre de objetos",
	[PowaAuras.BuffTypes.Tracking] = "Rastreo",
	[PowaAuras.BuffTypes.TypeBuff] = "Bufo (tipo)",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
	[PowaAuras.BuffTypes.GTFO] = "Alerta ¡Muévete!"
},

PowerType =
{
	[-1] = "Por defecto",
	[SPELL_POWER_RAGE] = "Ira",
	[SPELL_POWER_FOCUS] = "Enfoque",
	[SPELL_POWER_ENERGY] = "Energía",
	[SPELL_POWER_RUNIC_POWER] = "Poder rúnico",
	[SPELL_POWER_SOUL_SHARDS] = "Fragmentos de alma",
	[SPELL_POWER_LUNAR_ECLIPSE] = "Eclipse lunar",
	[SPELL_POWER_SOLAR_ECLIPSE] = "Eclipse solar",
	[SPELL_POWER_HOLY_POWER] = "Poder sagrado",
	[SPELL_POWER_ALTERNATE_POWER] = "Boss Power",
	[SPELL_POWER_DARK_FORCE] = "Dark Force",
	[SPELL_POWER_CHI] = "Chi",
	[SPELL_POWER_SHADOW_ORBS] = "Shadow Orbs",
	[SPELL_POWER_BURNING_EMBERS] = "Burning Embers",
	[SPELL_POWER_DEMONIC_FURY] = "Demonic Fury"
},

Relative =
{
	NONE = "Libre",
	TOPLEFT = "Arriba-Izquierda",
	TOP = "Arriba",
	TOPRIGHT = "Arriba-Derecha",
	RIGHT = "Derecha",
	BOTTOMRIGHT = "Abajo-Derecha",
	BOTTOM = "Abajo",
	BOTTOMLEFT = "Abajo-Izquierda",
	LEFT = "Izquierda",
	CENTER = "Centro"
},

Slots =
{
	Back = "Espalda",
	Chest = "Pecho",
	Feet = "Pies",
	Finger0 = "Dedo1",
	Finger1 = "Dedo2",
	Hands = "Manos",
	Head = "Cabeza",
	Legs = "Piernas",
	MainHand = "Mano derecha",
	Neck = "Cuello",
	SecondaryHand = "Mano izquierda",
	Shirt = "Camisa",
	Shoulder = "Hombros",
	Tabard = "Tabardo",
	Trinket0 = "Abalorio1",
	Trinket1 = "Abalorio2",
	Waist = "Cintura",
	Wrist = "Muñeca"
},

-- Main
nomEnable = "Activar Power Auras",
aideEnable = "Permitir todos los efectos de Power Auras",

nomDebug = "Activar mensajes de depuración",
aideDebug = "Permitir mensajes de depuración",
nomTextureCount = "Texturas máximas",
aideTextureCount = "Cambia esto si añades tus propias texturas",

aideOverrideTextureCount = "Sobrepasa número de texturas",
nomOverrideTextureCount = "Activa esto si vas a añadir tus propias texturas",

ListePlayer = "Página",
ListeGlobal = "Global",
aideMove = "Mover el aura aquí",
aideCopy = "Copiar el aura aquí.",
nomRename = "Renombrar",
aideRename = "Renombrar la página de efectos seleccionada",

nomTest = "Mostrar",
nomTestAll = "Mostrar todos",
nomHide = "Esconder todos",
nomEdit = "Editar",
nomNew = "Nuevo",
nomDel = "Borrar",
nomImport = "Importar",
nomExport = "Exportar",
nomImportSet = "Importar bloque",
nomExportSet = "Exportar bloque",
nomUnlock = "Desbloquear",
nomLock = "Bloquear",

aideImport = "Presiona Ctrl-V para pegar el código de aura y presiona \'Aceptar\'",
aideExport = "Presiona Ctrl-C para copiar el código de aura para compartir",
aideImportSet = "Presiona Ctrl-V para pegar el código de aura y presiona \'Aceptar\' esto borrará todas las auras en esta página",
aideExportSet = "Presiona Ctrl-C para copiar todas las auras de esta página para compartir",
aideDel = "Borra el aura seleccionada (mantén CTRL presionado para que el botón funcione)",

nomMove = "Mover",
nomCopy = "Copiar",
nomPlayerEffects = "Auras del personaje",
nomGlobalEffects = "Auras globales",

aideEffectTooltip = "(Shift-Click para activar/desactivar un aura)",
aideEffectTooltip2 = "(CTRL-Click para comprobación de funcionamiento)",

aideItems = "Introduce el nombre completo del objeto o [xxx] para su ID",
aideSlots = "Introduce el nombre de la ranura a rastrear: Munición, Espalda, Pecho, Pies, Dedo1, Dedo2, Manos, Cabeza, Piernas, Mano derecha, Collar, A distancia, Mano izquierda, Camisa, Hombros, Tabardo, Abalorio1, Abalorio2, Cintura, Muñeca",
aideTracking = "Introduce el nombre del tipo de rastreo ej. pescado",

-- Editor
aideCustomText = "Introduce texto para mostrar (%t=nombre del objetivo, %f=nombre del foco, %v=valor de visualización, %u=nombre de la unidad, %str=fuerza, agl=agilidad, %sta=aguante, %int=intelecto, %sp1=espíritu, %sp=poder con hechizos, %ap=poder de ataque)",

nomSound = "Sonido para reproducir",
nomSound2 = "Más sonidos para reproducir",
aideSound = "Reproduce un sonido al inicio",
aideSound2 = "Reproduce un sonido al inicio",
nomCustomSound = "O archivo de sonido",
aideCustomSound = "Introduce un archivo de sonido que esté en la carpeta de sonidos, ANTES de iniciar el juego. Mp3 y wav son compatibles. Ej: 'cookie.mp3' o introduce la ruta completa para reproducir cualquier sonido del WoW ej: Sound\\Events\\GuldanCheers.wav",

nomCustomSoundPath = "Ruta sonidos personalizados:",
aideCustomSoundPath = "Publica tu propia ruta (within the WoW install) para evitar sobreescribirlos al actualizar Power Auras",

nomCustomAuraPath = "Ruta texturas personalizados:",
aideCustomAuraPath = "Publica tu propia ruta (within the WoW install) para evitar sobreescribirlas al actualizar Power Auras",

nomSoundEnd = "Sonido para reproducir",
nomSound2End = "Más sonidos para reproducir",
aideSoundEnd = "Reproduce un sonido al final",
aideSound2End = "Reproduce un sonido al final",
nomCustomSoundEnd = "O archivo de sonido",
aideCustomSoundEnd = "Introduce un archivo de sonido que esté en la carpeta de sonidos, ANTES de iniciar el juego. Mp3 y wav son compatibles. Ej: 'cookie.mp3' o introduce la ruta completa para reproducir cualquier sonido del WoW ej: Sound\\Events\\GuldanCheers.wav",
nomTexture = "Textura",
aideTexture = "Textura para mostrar. Puedes cambiar las texturas facilmente cambiando el archivo Aura#.tga en la carpeta Addons",

nomAnim1 = "Animación principal",
nomAnim2 = "Animación secundaria",
aideAnim1 = "Anima la textura o no, con varios efectos",
aideAnim2 = "Esta animación se mostrará con menos opacidad que la principal. Cuidado con no sobrecargar la pantalla",

nomDeform = "Deformación",

aideColor = "Click aquí para cambiar el color de la textura",
aideTimerColor = "Click aquí para cambiar el color del reloj",
aideStacksColor = "Click aquí para cambiar el color de las acumulaciones",
aideFont = "Click aquí para elegir la fuente. Presiona OK para aplicar",
aideMultiID = "Introduce aquí IDs de otras auras para combinar comprobaciones. Varias IDs deben separarse con '/'. El ID del aura puede verse como [#] en la primera línea de la descripción del aura",
aideTooltipCheck = "Comprueba también que la descripción contiene este texto",

aideBuff = "Introduce aquí el nombre del bufo, o una parte del nombre, que debe activar/desactivar el aura. Puedes introducir varios nombres (ej: Super Bufo/Poder)",
aideBuff2 = "Introduce aquí el nombre del debufo, o una parte del nombre, que debe activar/desactivar el aura. Puedes introducir varios nombres (ex: Dark Disease/Plague)",
aideBuff3 = "Introduce aquí el tipo de debufoque debe activar o desactivar el aura (Veneno, Enfermedad, Maldición, Magia, CC, Silenciado, Aturdido, Dormido, Enraizado o nada). Puedes introducir varios tipos (ej: enfermedad/veneno)",
aideBuff4 = "Introduce aquí el nombre del AoE que debe activar el aura (lluvia de fuego por ejemplo, el nombre del AOE puede verse en el registro de combate)",
aideBuff5 = "Introduce aquí el encantamiento temporal que debe activar el aura: como opción precédelo con 'main/' o 'off/ para designar ranura de mano derecha o izquierda (ej: main/mangosta)",
aideBuff6 = "Introduce aquí el número de puntos de combo que deben activar el aura (ej: 1 o 1/2/3 o 0/4/5 etc...) ",
aideBuff7 = "Introduce aquí el nombre, o una parte del nombre, de una habilidad en tus barras de acción. Este aura estará activa cuando esa habilidad se pueda utilizar",
aideBuff8 = "Introduce aquí el nombre, o una parte del nombre, de una habilidad de tu libro de hechizos. Puedes introducir una ID de habilidad [12345]",

aideSpells = "Introduce aquí el nombre de la habilidad que activará un aura de alerta de hechizo",
aideStacks = "Introduce aquí el símbolo y la cantidad de acumulaciones requiridas para activar/desactivar el aura. Requerido símbolo ej: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "Introduce aquí el nombre del hechizo para robar que activará el aura (usa * para cualquier hechizo para robar)",
aidePurgeableSpells = "Introduce aquí el nombre del hechizo purgable que activará el aura (usa * para cualquier hechizo purgable)",

aideTotems = "Introduce aquí el nombre del tótem que activará el aura o su número 1=fuego, 2=tierra, 3=agua, 4=aire (usa * para cualquier tótem)",

aideRunes = "Introduce aquí las runas que activarán el aura B/b=sangre, F/f=escarcha, U/u=profana, D/d=muerte (las runas de muerte contarán como las de otro tipo si usas las casillas de ignorar mayúsculas/minúsculas) ex: 'BF' 'BfU' 'DDD'",

aideUnitn = "Introduce aquí el nombre de la unidad, que debe activar/desactivar el aura. Puedes introducir sólo nombres, si están en tu banda/grupo",
aideUnitn2 = "Sólo para banda/grupo",

aideMaxTex = "Define el número máximo de texturas en el editor. Si añades texturas en la carpeta Mod (con los nombres AURA1.tga a AURA50.tga), debes indicar el número correcto aquí",
aideWowTextures = "Activa esto para usar texturas de WoW en lugar de las texturas en la carpeta de Power Auras para este aura",
aideTextAura = "Activa esto para poner texto en lugar de textura",
aideRealaura = "Aura auténtica",
aideCustomTextures = "Activa esto para usar texturas de la subcarpeta 'Custom'. Introduce el nombre de la textura debajo (ej: miTextura.tga). Puedes usar un nombre de habilidad (ej: lluvia de fuego) o ID de habilidad (ej: 5384)",
aideRandomColor = "Activa esto para que este aura use color aleatorio cada vez que se active",

aideTexMode = "Desactiva esto para usar la opacidad de la textura. Por defecto, los colores más oscuros serán más transparentes",

nomActivationBy = "Activado por",

nomOwnTex = "Usar textura propia",
aideOwnTex = "Usar la textura del bufo/debufo o habilidad",
nomStacks = "Acumulaciones",

nomUpdateSpeed = "Velocidad de actualización",
nomSpeed = "Velocidad de animación",
nomTimerUpdate = "Velocidad de actualización del reloj",
nomBegin = "Iniciar animación",
nomEnd = "Finalizar animación",
nomSymetrie = "Simetría",
nomAlpha = "Opacidad",
nomPos = "Posición",
nomTaille = "Tamaño",

nomExact = "Nombre exacto",
nomThreshold = "Umbral",
aideThreshInv = "Activa esto para invertir la lógica del umbral. Desactivado = poca alerta / Activado = mucha alerta.",
nomThreshInv = "</>",
nomStance = "Actitud",
nomGTFO = "Tipo de alerta",
nomPowerType = "Tipo de poder",

nomMine = "Lanzado por mí",
aideMine = "Activa esto para mostrar sólo bufos/debufos lanzados por el jugador",
nomDispellable = "Puedo disipar",
aideDispellable = "Activa esto para mostrar sólo bufos que son disipables",
nomCanInterrupt = "Puede interrumpirse",
aideCanInterrupt = "Activa esto para mostrar sólo hechizos que pueden interrumpirse",
nomIgnoreUseable = "Reutilización sólo",
aideIgnoreUseable = "Ignora si la habilidad se puede usar (sólo usa el CD)",
nomIgnoreItemUseable = "Sólo si equipado",
aideIgnoreItemUseable = "Ignora si el objeto se puede utilizar (sólo si está equipado)",
nomCheckPet = "Mascota",
aideCheckPet = "Marca para monitorizar sólo habilidades de mascota",

nomOnMe = "Lanzado en mí",
aideOnMe = "Mostrar sólo si se lanza en mí",

nomPlayerSpell = "Jugador lanzando",
aidePlayerSpell = "Comprobar si el jugador esta lanzando un hechizo",

nomCheckTarget = "Objetivo enemigo",
nomCheckFriend = "Objetivo amistoso",
nomCheckParty = "Miembro de grupo",
nomCheckFocus = "Foco",
nomCheckRaid = "Miembro de banda",
nomCheckGroupOrSelf = "Banda/grupo o yo",
nomCheckGroupAny = "Cualquiera",
nomCheckOptunitn = "Nombre de unidad",

aideTarget = "Activa esto para comprobar sólo al objetivo enemigo",
aideTargetFriend = "Activa esto para comprobar sólo al objetivo amistoso.",
aideParty = "Activa esto para comprobar sólo a miembros del grupo",
aideGroupOrSelf = "Activa esto para comprobar a miembros del grupo/banda o a tí mismo",
aideFocus = "Activa esto para comprobar sólo al foco",
aideRaid = "Activa esto para comprobar sólo a miembros de banda",
aideGroupAny = "Activa esto para comprobar bufos en 'Cualquier' miembro del grupo/banda. Desactivado: comprueba que 'Todos' estén bufados",
aideOptunitn = "Activa esto para comprobar sólo a un personaje miembro del grupo/banda",
aideExact = "Activa esto para comprobar el nombre exacto del bufo/debufo/acción",
aideStance = "Selecciona qué actitud, aura o forma activa el aura",
aideGTFO = "Selecciona qué alerta ¡muévete! cativa el aura",
aidePowerType = "Selecciona qué tipo de recurso monitorizar",

aideShowSpinAtBeginning = "Al final del inicio de la animación, ejecuta un giro de 360 grados",
nomCheckShowSpinAtBeginning = "Ejecuta un giro después del inicio de la animación",

nomCheckShowTimer = "Mostrar",
nomTimerDuration = "Duración",
aideTimerDuration = "Muestra un reloj para simular la duración del bufo/debufo en el objetivo (0 para desactivar)",
aideShowTimer = "Activa esto para mostrar el reloj de este efecto",
aideSelectTimer = "Selecciona qué reloj mostrará la duración",
aideSelectTimerBuff = "Selecciona qué reloj mostrará la duración (reservado para los bufos de jugadores)",
aideSelectTimerDebuff = "Selecciona qué reloj mostrará la duración (reservado para los debufos de jugadores)",

nomCheckShowStacks = "Mostrar",
aideShowStacks = "Activa esto para mostrar las acumulaciones de este efecto",

nomCheckInverse = "Invertir",
aideInverse = "Invierte la lógica para mostrar este aura sólo cuando el bufo/debufo no está activo",

nomCheckIgnoreMaj = "Ignorar tipografía",
aideIgnoreMaj = "Activa esto para ignorar mayúsculas/minúsculas del nombre de bufos/debufos",

nomAuraDebug = "Depurar",
aideAuraDebug = "Depurar este aura",

nomDuration = "Duración de la animación",
aideDuration = "Después de este tiempo, el aura desaparecerá (0 para desactivar)",

nomOldAnimations = "Animaciones antiguas",
aideOldAnimations = "Usar animaciones antiguas",

nomCentiemes = "Mostrar centésimas",
nomDual = "Mostrar dos relojes",
nomHideLeadingZeros = "Ocultar ceros a la izquierda",
nomTransparent = "Usar texturas transparantes",
nomActivationTime = "Mostrar tiempo desde la activación",
nomTimer99 = "Mostrar segundos por debajo de 100",
nomUseOwnColor = "Usar color personalizado",
nomUpdatePing = "Animar al renovar",
nomLegacySizing = "Dígitos más anchos",
nomRelative = "Relación con el aura",
nomClose = "Cerrar",
nomEffectEditor = "Editor de efectos",
nomAdvOptions = "Opciones",
nomMaxTex = "Máximo de texturas disponibles",
nomTabAnim = "Animación",
nomTabActiv = "Activación",
nomTabSound = "Sonido",
nomTabTimer = "Reloj",
nomTabStacks = "Acumulaciones",
nomWowTextures = "Texturas WoW",
nomCustomTextures = "Texturas personalizadas",
nomTextAura = "Aura de texto",
nomRealaura = "Aura auténtica",
nomRandomColor = "Color aleatorio",

nomTalentGroup1 = "Talentos 1",
aideTalentGroup1 = "Muestra este efecto sólo cuando usas tus talentos principales",
nomTalentGroup2 = "Talentos 2",
aideTalentGroup2 = "Muestra este efecto sólo cuando usas tus talentos secundarios",

nomReset = "Reiniciar posiciones del editor",
nomPowaShowAuraBrowser = "Mostrar buscador de auras",

nomDefaultTimerTexture = "Textura del reloj por defecto",
nomTimerTexture = "Textura del reloj",
nomDefaultStacksTexture = "Textura de las acumulaciones por defecto",
nomStacksTexture = "Textura de las acumulaciones",

Enabled = "Habilitado",
Default = "Por defecto",

Ternary =
{
	combat = "En combate",
	inRaid = "En banda",
	inParty = "En grupo",
	isResting = "Descansando",
	ismounted = "Sobre montura",
	inVehicle = "En vehículo",
	isAlive = "Vivo",
	PvP = "PvP activado",
	Instance5Man = "5-Normal",
	Instance5ManHeroic = "5-Heróico",
	Instance10Man = "10-Normal",
	Instance10ManHeroic = "10-Heróico",
	Instance25Man = "25-Normal",
	Instance25ManHeroic = "25-Heróico",
	InstanceBg = "Campo de batalla",
	InstanceArena = "Arena",
},

nomWhatever = "Ignorado",
aideTernary = "Establece cuando este aura se muestra.",

TernaryYes =
{
	combat = "Sólo en combate",
	inRaid = "Sólo en banda",
	inParty = "Sólo en grupo",
	isResting = "Sólo descansando",
	ismounted = "Sólo sobre montura",
	inVehicle = "Sólo en vehículos",
	isAlive = "Sólo vivo",
	PvP = "Sólo con PvP activado",
	Instance5Man = "Sólo en mazmorras 5-Normal",
	Instance5ManHeroic = "Sólo en mazmorras 5-Heróico",
	Instance10Man = "Sólo en bandas 10-Normal",
	Instance10ManHeroic = "Sólo en bandas 10-Heróico",
	Instance25Man = "Sólo en bandas 25-Normal",
	Instance25ManHeroic = "Sólo en bandas 25-Heróico",
	InstanceBg = "Sólo en campos de batalla",
	InstanceArena = "Sólo en Arenas",
	RoleTank = "Sólo cuando tanque",
	RoleHealer = "Sólo cuando curador",
	RoleMeleDps = "Sólo cuando DPS cuerpo a cuerpo",
	RoleRangeDps = "Sólo cuando DPS a distancia",
},

TernaryNo =
{
	combat = "Sólo cuando no en combate",
	inRaid = "Sólo cuando no en banda",
	inParty = "Sólo cuando no en grupo",
	isResting = "Sólo cuando no descansando",
	ismounted = "Sólo cuando no sobre montura",
	inVehicle = "Sólo cuando no en vehículos",
	isAlive = "Sólo muerto",
	PvP = "Sólo cuando PvP desactivado",
	Instance5Man = "Sólo cuando no en mazmorras 5-Normal",
	Instance5ManHeroic = "Sólo cuando no en mazmorras 5-Heróico",
	Instance10Man = "Sólo cuando no en bandas 10-Normal",
	Instance10ManHeroic = "Sólo cuando no en bandas 10-Heróico",
	Instance25Man = "Sólo cuando no en bandas 25-Normal",
	Instance25ManHeroic = "Sólo cuando no en bandas 25-Heróico",
	InstanceBg = "Sólo cuando no en campos de batalla",
	InstanceArena = "Sólo cuando no en arena",
	RoleTank = "Sólo cuando no tanque",
	RoleHealer = "Sólo cuando no curador",
	RoleMeleDps = "Sólo cuando no DPS cuerpo a cuerpo",
	RoleRangeDps = "Sólo cuando no DPS a distancia"
},

TernaryAide =
{
	combat = "Efecto modificado por estado de combate",
	inRaid = "Efecto modificado por estado de banda",
	inParty = "Efecto modificado por estado de grupo",
	isResting = "Efecto modificado por descansado",
	ismounted = "Efecto modificado por montura",
	inVehicle = "Efecto modificado por vehículos",
	isAlive = "Efecto modificado por vida",
	PvP = "Efecto modificado por estado de PvP",
	Instance5Man = "Efecto modificado por estar en mazmorra 5-Normal",
	Instance5ManHeroic = "Efecto modificado por estar en mazmorra 5-Heróico",
	Instance10Man = "Efecto modificado por estar en banda 10-Normal",
	Instance10ManHeroic = "Efecto modificado por estar en banda 10-Heróico",
	Instance25Man = "Efecto modificado por estar en banda 25-Normal",
	Instance25ManHeroic = "Efecto modificado por estar en banda 25-Heróico",
	InstanceBg = "Efecto modificado por estar en campo de batalla",
	InstanceArena = "Efecto modificado por estar en arena",
	RoleTank = "Efecto modificado por ser tanque",
	RoleHealer = "Efecto modificado por ser curador",
	RoleMeleDps = "Efecto modificado por ser DPS cuerpo a cuerpo",
	RoleRangeDps = "Efecto modificado por ser DPS a distancia"
},

nomTimerInvertAura = "Invertir aura cuando tiempo inferior a",
aidePowaTimerInvertAuraSlider = "Invertir aura cuando cuando la duración sea menos que el límite (0 para desactivar)",
nomTimerHideAura = "Ocultar aura y reloj hasta",
aidePowaTimerHideAuraSlider = "Ocultar aura y reloj cuando la duracion sea mayor que el límite (0 para desactivar)",

aideTimerRounding = "Al comprobar, se redondeará el tiempo",
nomTimerRounding = "Redondear",

aideAllowInspections = "Permitir a Power Auras inspeccionar a los jugadores para determinar roles, desactivando esto se sacrifica precisión por rapidez",
nomAllowInspections = "Permitir inspeccionar",

nomCarried = "Sólo si en bolsas",
aideCarried = "Ignora si el objeto se puede utilizar (sólo si está en las bolsas)",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "Debería mostrarse porque $1",
nomReasonWontShow = "No debería mostrarse porque $1",

nomReasonMulti = "Todos los múltiples concuerdan con $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras desactivado",
nomReasonGlobalCooldown = "Ignora el tiempo de reutilización global",

nomReasonBuffPresent = "$1 tiene $2 $3", --$1=Target $2=BuffType, $3=BuffName (ej: "unidad4 tiene el debufo miseria")
nomReasonBuffMissing = "$1 no tiene $2 $3", --$1=Target $2=BuffType, $3=BuffName (ej: "unidad4 no tiene el debufo miseria")
nomReasonBuffFoundButIncomplete = "$2 $3 found for $1 but\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (ej: "Debufo hender armadura encontrado en objetivo pero \nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 tiene $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (ej: "Raid23 tiene bufo Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "No todos en $1 tienen $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "No todos en banda tienen bufo Blessing of Kings")
nomReasonAllInGroupHaveBuff = "Todos en $1 tienen $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "Todos en banda tienen bufo Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "Nadie en $1 has $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (ej: "Nadie en banda tiene bufo Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Bufo encontrado, reloj invertido",
nomReasonBuffPresentNotMine = "No lanzado por mí",
nomReasonBuffFound = "Bufo encontrado",
nomReasonStacksMismatch = "Acumulaciones = $1 , se esperaban $2", --$1=Actual Stack count, $2=Expected Stack logic match (ej: ">=0")

nomReasonAuraMissing = "Falta aura",
nomReasonAuraOff = "Aura desactivada",
nomReasonAuraBad = "Aura falsa",

nomReasonNotForTalentSpec = "Aura no activa para esta especialización de talentos",

nomReasonPlayerDead = "El jugador está muerto",
nomReasonPlayerAlive = "El jugador está vivo",
nomReasonNoTarget = "No hay objetivo",
nomReasonTargetPlayer = "El objetivo eres tú",
nomReasonTargetDead = "El objetivo está muerto",
nomReasonTargetAlive = "El objetivo está vivo",
nomReasonTargetFriendly = "El objetivo es amistoso",
nomReasonTargetNotFriendly = "El objetivo no es amistoso",

nomReasonNoPet = "El jugador no tiene mascota",

nomReasonNotInCombat = "No en combate",
nomReasonInCombat = "En combate",

nomReasonInParty = "En grupo",
nomReasonInRaid = "En banda",
nomReasonNotInParty = "No en grupo",
nomReasonNotInRaid = "No en banda",
nomReasonNotInGroup = "No en grupo/banda",
nomReasonNoFocus = "No hay foco",
nomReasonNoCustomUnit = "No se encuentra la unidad en grupo, banda o con mascota=$1",
nomReasonPvPFlagNotSet = "PvP no activado",
nomReasonPvPFlagSet = "PvP activado",

nomReasonNotMounted = "No sobre montura",
nomReasonMounted = "Sobre montura",
nomReasonNotInVehicle = "No en vehículo",
nomReasonInVehicle = "En vehículo",
nomReasonNotResting = "No descansando",
nomReasonResting = "Descansando",
nomReasonStateOK = "Estado OK",

nomReasonNotIn5ManInstance = "No en mazmorra 5-Normal",
nomReasonIn5ManInstance = "En mazmorra 5-Normal",
nomReasonNotIn5ManHeroicInstance = "No en mazmorra 5-Heróico",
nomReasonIn5ManHeroicInstance = "En mazmorra 5-Heróico",

nomReasonNotIn10ManInstance = "No en banda 10-Normal",
nomReasonIn10ManInstance = "En banda 10-Normal",
nomReasonNotIn10ManHeroicInstance = "No en banda 10-Heróico",
nomReasonIn10ManHeroicInstance = "En banda 10-Heróico",

nomReasonNotIn25ManInstance = "No en banda 25-Normal",
nomReasonIn25ManInstance = "En banda 25-Normal",
nomReasonNotIn25ManHeroicInstance = "No en banda 25-Heróico",
nomReasonIn25ManHeroicInstance = "En banda 25-Heróico",

nomReasonNotInBgInstance = "No en campo de batalla",
nomReasonInBgInstance = "En campo de batalla",
nomReasonNotInArenaInstance = "No en arena",
nomReasonInArenaInstance = "En arena",

nomReasonInverted = "$1 (invertido)", -- $1 es la razón, pero la casilla invertido está marcada, así que la lógica está invertida

nomReasonSpellUsable = "Habilidad $1 se puede usar",
nomReasonSpellNotUsable = "Habilidad $1 no se puede usar",
nomReasonSpellNotReady = "Habilidad $1 no preparada, en reutilización, reloj invertido",
nomReasonSpellNotEnabled = "Habilidad $1 no habilitada ",
nomReasonSpellNotFound = "Habilidad $1 no encontrada",
nomReasonSpellOnCooldown = "Habilidad $1 en reutilización",

nomReasonCastingOnMe = "$1 lanzando $2 en mí", --$1=CasterName $2=SpellName (ej: "Rotface is casting Slime Spray on me")
nomReasonNotCastingOnMe = "Habilidad desconocida lanzándose en mí",

nomReasonCastingByMe = "Estoy lanzando $1 en $2", --$1=SpellName $2=TargetName (e.g. "I am casting Holy Light on Fred")
nomReasonNotCastingByMe = "No se encuentra el hechizo lanzado por mí",

nomReasonAnimationDuration = "Aún dentro de la duración personalizada",

nomReasonItemUsable = "Objeto $1 se puede usar",
nomReasonItemNotUsable = "Objeto $1 no se puede usar",
nomReasonItemNotReady = "Objeto $1 no preparado, en reutilización, reloj invertido",
nomReasonItemNotEnabled = "Objeto $1 no habilitado",
nomReasonItemNotFound = "Objeto $1 no encontrado",
nomReasonItemOnCooldown = "Objeto $1 en reutilización",

nomReasonItemEquipped = "Objeto $1 equipado",
nomReasonItemNotEquipped = "Objeto $1 no equipado",

nomReasonItemInBags = "Objeto $1 en bolsas",
nomReasonItemNotInBags = "Objeto $1 no en bolsas",
nomReasonItemNotOnPlayer = "Objeto $1 no transportado",

nomReasonSlotUsable = "$1 ranura se puede usar",
nomReasonSlotNotUsable = "$1 ranura no se puede usar",
nomReasonSlotNotReady = "$1 ranura no preparada, en reutilización, reloj invertido",
nomReasonSlotNotEnabled = "$1 ranura no tiene reutilización",
nomReasonSlotNotFound = "$1 ranura no encontrada",
nomReasonSlotOnCooldown = "$1 ranura en reutilización",
nomReasonSlotNone = "$1 ranura está vacía",

nomReasonStealablePresent = "$1 tiene hechizo para robar $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "Nadie tiene hechizo para robar $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "Raid$1Target tiene hechizo para robar $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "Party$1Target tiene hechizo para robar $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 tiene hechizo purgable $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "Nadie tiene hechizo purgable $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "Raid$1Target tiene hechizo purgable $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "Party$1Target tiene hechizo purgable $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonAoETrigger = "AoE $1 activado", -- $1=AoE spell name
nomReasonAoENoTrigger = "AoE no activada $1", -- $1=AoE spell match

nomReasonEnchantMainInvert = "Mano derecha $1 encantamiento encontrado, reloj invertido", -- $1=Enchant match
nomReasonEnchantMain = "Mano derecha $1 encantamiento encontrado", -- $1=Enchant match
nomReasonEnchantOffInvert = "Mano izquierda $1 encantamiento encontrado, reloj invertido", -- $1=Enchant match
nomReasonEnchantOff = "Mano izquierda $1 encantamiento encontrado", -- $1=Enchant match
nomReasonNoEnchant = "Encantamiento no encontrado en armas $1", -- $1=Enchant match

nomReasonNoUseCombo = "No usas puntos de combo",
nomReasonNoUseComboInForm = "No usas puntos de combo bajo esta forma",
nomReasonComboMatch = "Puntos de combo $1 concuerdan con $2", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "Puntos de combo $1 no concuerdan con $2", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "No encontrado en barras de acción",
nomReasonActionReady = "Habilidad preparada",
nomReasonActionNotReadyInvert = "Habilidad no preparada (reutilización), reloj invertido",
nomReasonActionNotReady = "Habilidad no preparada (reutilización)",
nomReasonActionlNotEnabled = "Habilidad deshabilitada",
nomReasonActionNotUsable = "No se puede usar la habilidad",

nomReasonYouAreCasting = "Estás lanzando $1", -- $1=Casting match
nomReasonYouAreNotCasting = "No estás lanzando $1", -- $1=Casting match
nomReasonTargetCasting = "Objetivo lanzando $1", -- $1=Casting match
nomReasonFocusCasting = "Foco lanzando $1", -- $1=Casting match
nomReasonRaidTargetCasting = "Raid$1Target lanzando $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "Party$1Target lanzando $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "Objetivo de nadie lanzando $1", -- $1=Casting match

nomReasonStance = "Actitud actual $1, concuerda con $2", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "Actitud actual $1, no concuerda con $2", -- $1=Current Stance, $2=Match Stance

nomReasonRunesNotReady = "Runas no preparadas",
nomReasonRunesReady = "Runas preparadas",

nomReasonPetExists= "El jugador tiene mascota",
nomReasonPetMissing = "Falta mascota del jugador",

nomReasonTrackingMissing = "Rastreo no fijado en $1",
nomTrackingSet = "Rastreo fijado en $1",

nomNotInInstance = "Actitud no adecuada",

nomReasonStatic = "Aura estática",

nomReasonUnknownName = "Nombre de la unidad desconocido",
nomReasonRoleUnknown = "Rol desconocido",
nomReasonRoleNoMatch = "Rol no coincidente",

nomUnknownSpellId = "PowerAuras: Aura $1 hace referencia a un ID desconocido", -- $1=SpellID

nomReasonGTFOAlerts = "Las alertas ¡muévete! no siempre están activadas",

ReasonStat =
{
	Health = {MatchReason = "$1 poca vida", NoMatchReason = "$1 demasiada vida"},
	Mana = {MatchReason = "$1 poco maná", NoMatchReason = "$1 demasiado maná"},
	Power = {MatchReason = "$1 poco poder", NoMatchReason = "$1 demasiado poder", NilReason = "$1 tiene un tipo de poder distinto"},
	Aggro = {MatchReason = "$1 tiene aggro", NoMatchReason = "$1 no tiene aggro"},
	PvP = {MatchReason = "$1 PvP activado", NoMatchReason = "$1 PvP no activado"},
	SpellAlert = {MatchReason = "$1 lanzando $2", NoMatchReason = "$1 no está lanzando $2"}
},

-- Import dialog
ImportDialogAccept = "Import",
ImportDialogCancel = "Close",

-- Export dialog
ExportDialogTopTitle = "Exportar Auras",
ExportDialogCopyTitle = "Presiona Ctrl-C para copiar el código de aura inferior",
ExportDialogMidTitle = "Enviar a jugador",
ExportDialogSendTitle1 = "Introduce el nombre de un jugador y pulsa el botón 'Enviar'",
ExportDialogSendTitle2 = "Conectando %s (%d segundos restantes)...", -- The 1/2/3/4 suffix denotes the internal status of the frame.
ExportDialogSendTitle3a = "%s está en combate y no puede aceptar",
ExportDialogSendTitle3b = "%s no acepta peticiones",
ExportDialogSendTitle3c = "%s no ha respondido, puede que esté ausente",
ExportDialogSendTitle3d = "%s está recibiendo otra petición",
ExportDialogSendTitle3e = "%s ha rechazado la petición",
ExportDialogSendTitle4 = "Enviando auras...",
ExportDialogSendTitle5 = "¡Envío realizado!",
ExportDialogSendButton1 = "Enviar",
ExportDialogSendButton2 = "Atrás",
ExportDialogCancelButton = "Cerrar",

-- Cross-client import dialog
PlayerImportDialogTopTitle = "¡Tienes auras!",
PlayerImportDialogDescTitle1 = "%s quiere enviarte auras",
PlayerImportDialogDescTitle2 = "Recibiendo auras...",
PlayerImportDialogDescTitle3 = "La petición ha caducado",
PlayerImportDialogDescTitle4 = "Selecciona una página para guardar las auras",
PlayerImportDialogWarningTitle = "|cFFFF0000Note: |rTe están enviando un bloque de auras, esto sobreescribirá todas las auras de esta página",
PlayerImportDialogDescTitle5 = "¡Auras guardadas!",
PlayerImportDialogDescTitle6 = "No hay ranuras para auras disponibles",
PlayerImportDialogAcceptButton1 = "Aceptar",
PlayerImportDialogAcceptButton2 = "Guardar",
PlayerImportDialogCancelButton1 = "Rechazar",

aideCommsRegisterFailure = "There was an error when setting up addon communications.",
aideBlockIncomingAuras = "Evita que otros te envíen sus auras",
nomBlockIncomingAuras = "Bloque de auras entrante",
})
elseif (GetLocale() == "frFR") then
PowaAuras.Anim[0] = "[Invisible]"
PowaAuras.Anim[1] = "Statique"
PowaAuras.Anim[2] = "Clignotement"
PowaAuras.Anim[3] = "Agrandir"
PowaAuras.Anim[4] = "Pulsation"
PowaAuras.Anim[5] = "Effet bulle"
PowaAuras.Anim[6] = "Goutte d'eau"
PowaAuras.Anim[7] = "Electrique"
PowaAuras.Anim[8] = "Rétrécir"
PowaAuras.Anim[9] = "Flamme"
PowaAuras.Anim[10] = "Orbite"
PowaAuras.Anim[11] = "Tournoiement sens horaire"
PowaAuras.Anim[12] = "Tournoiement sens horaire inverse"

PowaAuras.BeginAnimDisplay[0] = "[Aucun]"
PowaAuras.BeginAnimDisplay[1] = "Zoom Avant"
PowaAuras.BeginAnimDisplay[2] = "Zoom Arriere"
PowaAuras.BeginAnimDisplay[3] = "Transparence seule"
PowaAuras.BeginAnimDisplay[4] = "Gauche"
PowaAuras.BeginAnimDisplay[5] = "Haut-Gauche"
PowaAuras.BeginAnimDisplay[6] = "Haut"
PowaAuras.BeginAnimDisplay[7] = "Haut-Droite"
PowaAuras.BeginAnimDisplay[8] = "Droite"
PowaAuras.BeginAnimDisplay[9] = "Bas-Droite"
PowaAuras.BeginAnimDisplay[10] = "Bas"
PowaAuras.BeginAnimDisplay[11] = "Bas-Gauche"
PowaAuras.BeginAnimDisplay[12] = "Rebondissement"

PowaAuras.EndAnimDisplay[0] = "[Aucun]"
PowaAuras.EndAnimDisplay[1] = "Zoom Avant"
PowaAuras.EndAnimDisplay[2] = "Zoom Arriere"
PowaAuras.EndAnimDisplay[3] = "Transparence seule"
PowaAuras.EndAnimDisplay[4] = "Tournoiement"
PowaAuras.EndAnimDisplay[5] = "Tournoiement zoom arrière"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Tapez /powa pour afficher les options.",

aucune = "Aucune",
aucun = "Aucun",
mainHand = "Droite",
offHand = "Dauche",
bothHands = "Toutes",

DebuffType =
{
	Magic = "Magie",
	Disease = "Maladie",
	Curse = "Malédiction",
	Poison = "Poison",
	Enrage = "Enrager"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "Contrôle de foule",
	[PowaAuras.DebuffCatType.Silence] = "Silence",
	[PowaAuras.DebuffCatType.Snare] = "Ralentissement",
	[PowaAuras.DebuffCatType.Stun] = "Étourdissement",
	[PowaAuras.DebuffCatType.Root] = "Enracinement",
	[PowaAuras.DebuffCatType.Disarm] = "Désarmement",
	[PowaAuras.DebuffCatType.PvE] = "JcE"
},

Role =
{
	RoleTank = "Tank",
	RoleHealer = "Soigneur",
	RoleMeleDps = "DPS de mêlée",
	RoleRangeDps = "DPS à distance"
},

nomReasonRole =
{
	RoleTank = "Est un tank",
	RoleHealer = "Est un soigneur",
	RoleMeleDps = "Est un DPS de mêlée",
	RoleRangeDps = "Est un DPS à distance"
},

nomReasonNotRole =
{
	RoleTank = "N'est pas un tank",
	RoleHealer = "N'est pas un soigneur",
	RoleMeleDps = "N'est pas un DPS de mêlée",
	RoleRangeDps = "N'est pas un DPS à distance"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Amélioration",
	[PowaAuras.BuffTypes.Debuff] = "Affaiblissement",
	[PowaAuras.BuffTypes.AoE] = "Debuff de zone",
	[PowaAuras.BuffTypes.TypeDebuff] = "Type du Debuff",
	[PowaAuras.BuffTypes.Enchant] = "Enchantement d'arme",
	[PowaAuras.BuffTypes.Combo] = "Combos",
	[PowaAuras.BuffTypes.ActionReady] = "Action utilisable",
	[PowaAuras.BuffTypes.Health] = "Vie",
	[PowaAuras.BuffTypes.Mana] = "Mana",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Rage/Energie/Runique",
	[PowaAuras.BuffTypes.Aggro] = "Aggro",
	[PowaAuras.BuffTypes.PvP] = "JcJ",
	[PowaAuras.BuffTypes.Stance] = "Posture",
	[PowaAuras.BuffTypes.SpellAlert] = "Alerte de sort",
	[PowaAuras.BuffTypes.SpellCooldown] = "Mes propres temps de recharges",
	[PowaAuras.BuffTypes.StealableSpell] = "Sort volable",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Sort dissipable",
	[PowaAuras.BuffTypes.Static] = "Aura permanente",
	[PowaAuras.BuffTypes.Totems] = "Totems",
	[PowaAuras.BuffTypes.Pet] = "Famillier",
	[PowaAuras.BuffTypes.Runes] = "Runes",
	[PowaAuras.BuffTypes.Slots] = "Emplacement d'équipement",
	[PowaAuras.BuffTypes.Items] = "Nom d'objet",
	[PowaAuras.BuffTypes.Tracking] = "Pistage",
	[PowaAuras.BuffTypes.TypeBuff] = "Type d'amélioration",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
	[PowaAuras.BuffTypes.GTFO] = "Alerte GTFO"
},

PowerType =
{
	[-1] = "Default",
	[SPELL_POWER_RAGE] = "Rage",
	[SPELL_POWER_FOCUS] = "Focalisation",
	[SPELL_POWER_ENERGY] = "Énergie",
	[SPELL_POWER_RUNIC_POWER] = "Puissance runique",
	[SPELL_POWER_SOUL_SHARDS] = "Fragment d'âme",
	[SPELL_POWER_HOLY_POWER] = "Puissance sacrée",
	[SPELL_POWER_ALTERNATE_POWER] = "Boss Power",
	[SPELL_POWER_DARK_FORCE] = "Dark Force",
	[SPELL_POWER_CHI] = "Chi",
	[SPELL_POWER_SHADOW_ORBS] = "Shadow Orbs",
	[SPELL_POWER_BURNING_EMBERS] = "Burning Embers",
	[SPELL_POWER_DEMONIC_FURY] = "Demonic Fury"
},

Relative =
{
	NONE = "Libre",
	TOPLEFT = "En haut à gauche",
	TOP = "En haut",
	TOPRIGHT = "En haut à droite",
	RIGHT = "À droite",
	BOTTOMRIGHT = "En bas à droite",
	BOTTOM = "En bas",
	BOTTOMLEFT = "En bas à gauche",
	LEFT = "À gauche",
	CENTER = "Au centre"
},

Slots =
{
	Back = "Cape",
	Chest = "Torse",
	Feet = "Pieds",
	Finger0 = "Doigt 1",
	Finger1 = "Doigt 2",
	Hands = "Mains",
	Head = "Tête",
	Legs = "Jambes",
	MainHand = "Main droite",
	Neck = "Cou",
	SecondaryHand = "Main gauche",
	Shirt = "Chemise",
	Shoulder = "Épaule",
	Tabard = "Tabard",
	Trinket0 = "Bijou 1",
	Trinket1 = "Bijou 2",
	Waist = "Taille",
	Wrist = "Poignets"
},

-- Main
nomEnable = "Activer Power Auras",
aideEnable = "Active tous les effets de Power Auras",

nomDebug = "Activer Debug Messages",

ListePlayer = "Page",
ListeGlobal = "Global",
aideMove = "Déplace l'effet séléctionné ici.",
aideCopy = "Copie l'effet séléctionné ici.",
nomRename = "Renommer",
aideRename = "Renomme la page d'effet en cours.",

nomTest = "Tester",
nomTestAll = "Tester tout",
nomHide = "Tout masquer",
nomEdit = "Editer",
nomNew = "Nouveau",
nomDel = "Supprimer",
nomImport = "Importer",
nomExport = "Exporter",
nomImportSet = "Importer Set",
nomExportSet = "Exporter Set",
nomUnlock = "Unlock",
nomLock = "Lock",

aideDel = "Supprime l'effet séléctionné (appuyez sur CTRL pour autoriser la suppression)",

nomMove = "Déplacer",
nomCopy = "Copier",
nomPlayerEffects = "Effets du personnage",
nomGlobalEffects = "Effets\nglobaux",

aideEffectTooltip = "(Maj-click pour mettre cet effet sur ON ou OFF)",

-- Editor
nomSound = "Son à jouer",
nomSound2 = "Son à jouer supplémentaire",
nomCustomSound = "Fichier de son:",

nomSoundEnd = "Son à jouer",
nomSound2End = "Son à jouer supplémentaire",
nomCustomSoundEnd = "Fichier de son:",
nomTexture = "Texture",
aideTexture = "La texture à afficher. Vous pouvez facilement remplacer les textures en changeant les fichier Aura#.tga du dossier de l'AddOn.",

nomAnim1 = "Animation principale",
nomAnim2 = "Animation secondaire",
aideAnim1 = "Anime la texture ou pas, avec différents effets.",
aideAnim2 = "Cette animation sera affichée avec moins d'opacité que la principale. Attention, afin de ne pas surcharger le tout.",

nomDeform = "Déformation",

aideColor = "Cliquez ici pour changer la couleur de la texture.",

aideBuff = "Entrez ici le nom du buff, ou une partie du nom, qui doit activer/désactiver l'effet. Vous pouvez entrer plusieurs noms s'ils sont séparé comme il convient (ex: Super Buff/Puissance)",
aideBuff2 = "Entrez ici le nom du débuff, ou une partie du nom, qui doit activer/désactiver l'effet. Vous pouvez entrer plusieurs noms s'ils sont séparé comme il convient (ex: Maladie noire/Peste)",
aideBuff3 = "Entrez ici le type du débuff qui doit activer ou désactiver l'effet (Poison, Maladie, Malédiction, Magie ou Aucun). Vous pouvez aussi entrer plusieurs types de débuffs à la fois.",
aideBuff4 = "Entrez ici le nom de l'effet de zone qui activera l'effet (comme une pluie de feu par exemple, généralement le nom de l'effet est disponible dans le journal de combat)",
aideBuff6 = "Vous pouvez entrez ici le ou les chiffres des points de combos qui activeront l'effet (ex : 1 ou 1/2/3 ou 0/4/5 etc...) ",
aideBuff7 = "Indiquez ici le nom, ou une partie du nom, d'une des actions dans vos barres. L'effet sera actif si l'action est utilisable.",

aideUnitn = "Entrez ici le nom du unit, qui doit activer/désactiver l'effet. Works only for raid/partymembers.",
aideUnitn2 = "Only for raid/group.",

aideMaxTex = "Defini le maximum de textures disponibles dans l'Editeur d'Effets. Si vous rajoutez des textures en les mettant dans le dossier de l'AddOn (nommées de AURA1.tga à AURA50.tga) c'est ici qu'il faudra le signaler.",
aideWowTextures = "Cochez cette case pour utiliser les textures internes du jeu plutôt que le dossier de l'addon pour cet effet.",
aideRealaura = "Reale Aura",
aideCustomTextures = "Cochez cette case pour utiliser les textures présentes dans le sous-dossier 'Custom'. Vous devez connaitre le nom du fichier et indiquer son nom (ex : myTexture.tga)",
aideRandomColor = "Cochez cette case pour que l'effet prenne des couleurs au hasard à chaque activation.",

aideTexMode = "Decochez cette case pour utiliser la transparence de la texture. Par defaut, les couleurs sombres seront plus transparentes.",

nomActivationBy = "Activation par :",

nomOwnTex = "Utiliser la propre texture",
aideOwnTex = "Utiliser la propre texture du sort/technique/objet à la place de l'aura.",
nomStacks = "Pile",

nomUpdateSpeed = "Update speed",
nomSpeed = "Vitesse d'animation.",
nomTimerUpdate = "Timer update speed",
nomBegin = "Animation de départ",
nomEnd = "Animation de fin",
nomSymetrie = "Symétrie",
nomAlpha = "Transparence",
nomPos = "Position",
nomTaille = "Taille",

nomExact = "Nom exacte",
nomThreshold = "Seuil",
aideThreshInv = "Inverse la fonction du seuil.",
nomThreshInv = "Inverse",
nomStance = "Posture",
nomGTFO = "Type d'alerte",
nomPowerType = "Type de puissance",

nomMine = "Lancé par moi",
nomIgnoreItemUseable = "Équipé uniquement",
aideIgnoreItemUseable = "Ignore si l'objet est utilisable ou non.",

nomCheckTarget = "Cible ennemie",
nomCheckFriend = "Cible amie",
nomCheckParty = "Cible de groupe",
nomCheckFocus = "Cible de focalisation",
nomCheckRaid = "Cible de raid",
nomCheckGroupOrSelf = "Raid,groupe,sois-même",
nomCheckGroupAny = "Raid/groupe",
nomCheckOptunitn = "Cible spécifique",

aideTarget = "Cochez cette case pour vérifier plutôt les buffs/débuffs d'une cible ennemie.",
aideTargetFriend = "Cochez cette case pour vérifier plutôt les buffs/débuffs d'une cible amie.",
aideParty = "Cochez cette case pour vérifier plutôt les buffs/débuffs d'une cible partie.",
aideFocus = "Cochez cette case pour vérifier plutôt les buffs/débuffs d'une cible focus.",
aideRaid = "Cochez cette case pour vérifier plutôt les buffs/débuffs d'une cible raid.",
aideGroupAny = "Cochez cette case pour contrôler les améliorations de n'importe-quelle unité de raid ou groupe.",

aideShowSpinAtBeginning = "Un tournoiement de 360° après l'animation de départ.",
nomCheckShowSpinAtBeginning = "Tournoiement après l'animation de début.",

nomCheckShowTimer = "Afficher",
nomTimerDuration = "Chronometre",
aideTimerDuration = "Affiche un timer pour simuler la durée d'un buff/debuff sur la cible (0 pour désactiver)",
aideShowTimer = "Cochez cette case pour afficher la durée de cet effet.",
aideSelectTimer = "Choisissez quel timer sera pris pour afficher la durée",
aideSelectTimerBuff = "Choisissez quel timer sera pris pour afficher la durée (celui-ci est reservé aux buffs du joueur)",
aideSelectTimerDebuff = "Choisissez quel timer sera pris pour afficher la durée (celui-ci est reservé aux debuffs du joueur)",

nomCheckShowStacks = "Afficher",
aideShowStacks = "Activate this to show the stacks for this effect.",

nomCheckInverse = "Afficher si inactif",
aideInverse = "Cochez cette case pour afficher cet effet uniquement quand le buff/débuff n'est pas actif.",

nomCheckIgnoreMaj = "Ignorer les majuscules",
aideIgnoreMaj = "Cochez cette case pour ignorer les majuscules/minuscules du nom des buffs/débuffs.",

nomDuration = "Durée de l'animation",
aideDuration = "Passé ce délai, l'animation sera masquée (0 pour désactiver)",

nomOldAnimations = "Anciennes animations",
aideOldAnimations = "Utiliser les anciennes animations.",

nomCentiemes = "Afficher centiemes",
nomDual = "Afficher 2 durées",
nomHideLeadingZeros = "Masquer le zéro devant le chiffre",
nomTransparent = "Fond transparent",
nomActivationTime = "Durée depuis activation",
nomTimer99 = "When below 100 show only seconds",
nomUseOwnColor = "Couleur perso.",
nomUpdatePing = "Animation à l'actualisation",
nomLegacySizing = "Wider Digits",
nomRelative = "Ancrage par rapport à l'aura",
nomClose = "Fermer",
nomEffectEditor = "Editeur d'Effet",
nomAdvOptions = "Options",
nomMaxTex = "Maximum de textures disponibles",
nomTabAnim = "Animation",
nomTabActiv = "Activation",
nomTabSound = "Son",
nomTabTimer = "Compteur",
nomTabStacks = "Empilement",
nomWowTextures = "Textures du jeu",
nomCustomTextures = "Autres textures",
nomTextAura = "Remplacer par texte",
nomRealaura = "Reale Aura",
nomRandomColor = "Couleurs aléatoires",

nomTalentGroup1 = "Spé. 1",
nomTalentGroup2 = "Spé. 2",

nomTimerTexture = "Police du compteur",
nomStacksTexture = "Police de l'empilement",

Ternary =
{
	combat = "En combat",
	inRaid = "En raid",
	inParty = "En groupe",
	isResting = "En repos",
	ismounted = "En monture",
	inVehicle = "En véhicule",
	isAlive = "Vivant",
	PvP = "Statut JcJ",
	Instance5Man = "5 joueurs",
	Instance5ManHeroic = "5 joueurs H",
	Instance10Man = "10 joueurs",
	Instance10ManHeroic = "10 joueurs H",
	Instance25Man = "25 joueurs",
	Instance25ManHeroic = "25 joueurs H",
	InstanceBg = "Champ de bataille",
	InstanceArena = "Arène"
},

nomTimerInvertAura = "Cacher l'aura et le compteur lorsque le temps restant est supérieur à",
aidePowaTimerInvertAuraSlider = "0 pour désactiver",
nomTimerHideAura = "Cacher l'aura et le compteur lorsque le temps restant est supérieur à",
aidePowaTimerHideAuraSlider = "0 pour désactiver",

nomCarried = "Dans le sac uniquement",
aideCarried = "Ignore si l'objet est utilisable ou non",

nomReasonBuffPresentNotMine = "Pas lancé par moi",
})
elseif (GetLocale() == "koKR") then
PowaAuras.Anim[0] = "[보이지 않음]"
PowaAuras.Anim[1] = "공전"
PowaAuras.Anim[2] = "점멸"
PowaAuras.Anim[3] = "성장"
PowaAuras.Anim[4] = "파동"
PowaAuras.Anim[5] = "거품"
PowaAuras.Anim[6] = "낙수"
PowaAuras.Anim[7] = "전기장"
PowaAuras.Anim[8] = "꽁무니"
PowaAuras.Anim[9] = "화염"
PowaAuras.Anim[10] = "궤도"
PowaAuras.Anim[11] = "Spin Clockwise"
PowaAuras.Anim[12] = "Spin Anti-Clockwise"

PowaAuras.BeginAnimDisplay[0] = "[없음]"
PowaAuras.BeginAnimDisplay[1] = "확대"
PowaAuras.BeginAnimDisplay[2] = "축소"
PowaAuras.BeginAnimDisplay[3] = "불투명도만"
PowaAuras.BeginAnimDisplay[4] = "좌측"
PowaAuras.BeginAnimDisplay[5] = "상단-좌측"
PowaAuras.BeginAnimDisplay[6] = "상단"
PowaAuras.BeginAnimDisplay[7] = "상단-우측"
PowaAuras.BeginAnimDisplay[8] = "우측"
PowaAuras.BeginAnimDisplay[9] = "하단-우측"
PowaAuras.BeginAnimDisplay[10] = "하단"
PowaAuras.BeginAnimDisplay[11] = "하단-좌측"
PowaAuras.BeginAnimDisplay[12] = "Bounce"

PowaAuras.EndAnimDisplay[0] = "[없음]"
PowaAuras.EndAnimDisplay[1] = "확대"
PowaAuras.EndAnimDisplay[2] = "축소"
PowaAuras.EndAnimDisplay[3] = "불투명도만"
PowaAuras.EndAnimDisplay[4] = "Spin"
PowaAuras.EndAnimDisplay[5] = "Spin In"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "옵션을 볼려면 /powa를 입력하십시오.",

aucune = "없음",
aucun = "없음",
mainHand = "주무기",
offHand = "보조 무기",
bothHands = "둘다",

DebuffType =
{
	Magic = "마법",
	Disease = "질병",
	Curse = "저주",
	Poison = "독",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "군중제어",
	[PowaAuras.DebuffCatType.Silence] = "침묵",
	[PowaAuras.DebuffCatType.Snare] = "덫",
	[PowaAuras.DebuffCatType.Stun] = "기절",
	[PowaAuras.DebuffCatType.Root] = "올가미",
	[PowaAuras.DebuffCatType.Disarm] = "무장해제",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "버프",
	[PowaAuras.BuffTypes.Debuff] = "디버프",
	[PowaAuras.BuffTypes.AoE] = "AOE 디버프",
	[PowaAuras.BuffTypes.TypeDebuff] = "디버프의 유형",
	[PowaAuras.BuffTypes.Enchant] = "무기 강화",
	[PowaAuras.BuffTypes.Combo] = "연계 점수",
	[PowaAuras.BuffTypes.ActionReady] = "사용 가능한 행동",
	[PowaAuras.BuffTypes.Health] = "생명력",
	[PowaAuras.BuffTypes.Mana] = "마나",
	[PowaAuras.BuffTypes.EnergyRagePower] = "분노/기력/룬",
	[PowaAuras.BuffTypes.Aggro] = "어그로",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "태세",
	[PowaAuras.BuffTypes.SpellAlert] = "주문 경고",
	[PowaAuras.BuffTypes.SpellCooldown] = "나의 주문",
	[PowaAuras.BuffTypes.StealableSpell] = "훔치기 가능한 주문",
	[PowaAuras.BuffTypes.PurgeableSpell] = "제거가능한 주문",
	[PowaAuras.BuffTypes.Static] = "Static Aura",
	[PowaAuras.BuffTypes.Totems] = "Totems",
	[PowaAuras.BuffTypes.Pet] = "Pet",
	[PowaAuras.BuffTypes.Runes] = "Runes",
	[PowaAuras.BuffTypes.Slots] = "Equipment Slots",
	[PowaAuras.BuffTypes.Items] = "Named Items",
	[PowaAuras.BuffTypes.Tracking] = "Tracking",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match",
	[PowaAuras.BuffTypes.GTFO] = "GTFO Alert"
},

-- Main
nomEnable = "Power Auras 활성화",
aideEnable = "모든 Power Auras 효과를 활성화합니다.",

nomDebug = "디버그 메시지 활성화",
nomTextureCount = "Max Textures",
aideDebug = "디버그 메시지를 활성화합니다.",
ListePlayer = "페이지",
ListeGlobal = "공통",
aideMove = "여기로 효과를 이동시킵니다.",
aideCopy = "여기로 효과를 복사합니다.",
nomRename = "이름 변경",
aideRename = "선택된 효과의 페이지의 이름을 변경합니다.",
nomTest = "테스트",
nomHide = "모두 숨기기",
nomEdit = "편집",
nomNew = "새로",
nomDel = "삭제",
nomImport = "들여오기",
nomExport = "내보내기",
nomImportSet = "설정 가져오기",
nomExportSet = "설정 내보내기",
aideImport = "오라 구문열을 붙여넣기 하려면 Ctrl-V를 누르고 \'승낙\'을 누르십시오.",
aideExport = "공유하기 위해 오라 구문열을 복사하려면 Ctrl-C를 누르십시오.",
aideImportSet = "오라 설정 구문열을 붙여넣기 하려면 Ctrl-V를 누르고 \'승낙\'을 누르십시오.",
aideExportSet = "공유하기 위해 모든 오라 구문열을 복사하려면 Ctrl-C를 누르십시오.",
aideDel = "선택된 효과를 제거합니다(이 버튼을 작동되게 하려면 CTRL을 누르십시오).",
nomMove = "이동",
nomCopy = "복사",
nomPlayerEffects = "캐릭터별 효과",
nomGlobalEffects = "공통 효과",
aideEffectTooltip = "(효과 켜기/끄기를 전환하려면 Shift-클릭하십시오)",

-- Editor
nomSound = "재생할 소리",
aideSound = "애니메이션 시작시 소리를 재생합니다.",
nomCustomSound = "혹은 소리 파일:",
aideCustomSound = "게임을 시작하기 전에, Sounds 폴더내의 소리 파일의 이름을 아래의 빈칸에 입력하십시오. mp3 및 wav 확장자를 지원합니다. (예: 'cookie.mp3')",

nomTexture = "텍스쳐",
aideTexture = "보여지게 될 텍스쳐를 선택합니다. 애드온 폴더내의 Aura#.tga 파일의 변경을 통해 텍스쳐를 쉽게 바꿀 수 있습니다.",

nomAnim1 = "주 애니메이션",
nomAnim2 = "보조 애니메이션",
aideAnim1 = "다양한 효과와 더불어 텍스쳐에 움직임을 부여할 지 여부를 선택합니다.",
aideAnim2 = "이 애니메이션은 주 애니메이션보다는 덜 불투명하게 보여지게 됩니다. 화면의 과부하를 줄이기 위해 한개의 보조 애니메이션만이 동시에 보여지게 된다는 점에 주의 하십시오.",

nomDeform = "형태 변경",

aideColor = "텍스쳐의 색상을 변경하려면 여기를 클릭하십시오.",
aideFont = "글꼴을 선택하려면 여기를 클릭하십시오. 선택한 것을 적용하려면 '확인'을 누르십시오.",
aideMultiID = "체크한 것과 연결시키기 위해 다른 오라 ID를 여기에 입력합니다. 다중 ID는 '/'로 구별지워져야만 합니다. 오라 ID는 오라 툴팁의 첫번째 줄에서 [#]로 찾을 수 있습니다.",

aideBuff = "여기에 이 효과를 활성/비활성화해야만 하는 버프의 이름을, 혹은 이름의 일부분을 입력합니다. 구분되어 있어야 할 이름이라면 각각의 이름을 ('/'로 분리해) 입력할 수 있습니다(예: Super Buff/Power).",
aideBuff2 = "여기에 이 효과를 활성/비활성화해야만 하는 디버프의 이름을, 혹은 이름의 일부분을 입력합니다. 구분되어 있어야 할 이름이라면 각각의 이름을 ('/'로 분리해) 입력할 수 있습니다(예: Dark Disease/Plague).",
aideBuff3 = "여기에 이 효과를 활성/비활성화해야만 하는 디버프의 유형(독, 질병, 저주, 마법, 군중제어, 침묵, 기절, 덫, 올가미 혹은 없음)을 입력합니다. 디버프 각각의 유형을 ('/'로 분리해) 입력할 수도 있습니다(예: 질병/독).",
aideBuff4 = "여기에 이 효과에 적용해야만 하는 효과의 범위 이름(AOE)을 입력합니다(예를 들면 불의 비와 같은 경우입니다. 이 효과의 범위(AOE)의 이름을 전투 기록에서 찾을 수 있습니다).",
aideBuff5 = "여기에 이 효과를 활성화해야만 하는 일시적인 무기 강화를 입력합니다 : 선택적으로 주무기 혹은 보조무기 장착 칸을 지정하기 위해 '주무기', '보조 무기' 혹은 양 무기에 대해 '둘다'(예: 주무기/crippling).",
aideBuff6 = "여기에 이 효과를 활성화해야만 하는 연계 점수의 숫자를 입력합니다(예 : 1 혹은 1/2/3 혹은 0/4/5 등등...).",
aideBuff7 = "여기에 단축 행동바에 있는 행동의 이름을, 혹은 이름의 일부분을 입력합니다. 이 행동이 사용 가능한 경우에 효과는 활성화될 것입니다.",
aideBuff8 = "여기에 마법책에 있는 주문의 이름을, 혹은 이름의 일부분을 입력합니다. 주문의 ID를 입력하여도 됩니다(예: 12345).",

aideSpells = "여기에 주문 경고 오라를 적용할 주문의 이름을 입력합니다.",
aideStacks = "여기에 이 효과를 활성/비활성화하는데 요구되는 연산자와 중첩 횟수를 입력합니다. 연산자를 사용한 경우에만 작동합니다! 예: '<5' '>3' '=11' '!5' '>=0' '<=6' '2<>8'",

aideStealableSpells = "마법훔치기를 할 주문명을 여기에 입력하시요. (use * for any stealable spell).",
aidePurgeableSpells = "정화할 주문명을 여기에 입력하시요. (use * for any purgeable spell).",

aideUnitn = "여기에 이 효과를 활성/비활성화해야만 하는 유닛의 이름을 입력합니다. 공격대 혹은 그룹에 속해 있는 유닛의 이름만 입력할 수 있습니다.",
aideUnitn2 = "공격대/그룹에 한해",

aideMaxTex = "효과 편집기에 가능한 텍스쳐의 최대 갯수를 정의 합니다. 애드온 폴더에 텍스쳐를 추가하려면(AURA1.tga에서 AURA50.tga까지 이름과 함께), 여기에 올바른 갯수를 지시해야만 합니다.",
aideWowTextures = "이 효과에 대해 Power Auras 폴더내의 텍스쳐 대신에 WoW의 텍스쳐를 사용하려면 이 옵션에 체크하십시오.",
aideTextAura = "텍스쳐 대신에 문자를 입력하려면 이 옵션에 체크하십시오.",
aideRealaura = "활성 오오라",
aideCustomTextures = "하위 폴더 'Custom'에 있는 텍스쳐를 사용하려면 이 옵션에 체크하십시오. 아래에 텍스쳐의 이름을 기입해야만 합니다(예: myTexture.tga)",
aideRandomColor = "이 효과를 알리기 위해 활성화되는 매 시간마다 무작위 색상을 사용하려면 이 옵션에 체크하십시오.",

aideTexMode = "불투명한 텍스쳐를 사용하려면 이 옵션을 체크 해제하십시오. 기본적으로 가장 어두운 색상이 더욱 반투명합니다.",

nomActivationBy = "활성화:",

nomOwnTex = "자신의 텍스쳐 사용",
aideOwnTex = "기본 텍스쳐 대신에 자신의 디/버프 혹은 능력 텍스쳐를 사용합니다.",
nomStacks = "중첩",

nomUpdateSpeed = "Update speed",
nomSpeed = "애니메이션 속도",
nomTimerUpdate = "Timer update speed",
nomBegin = "시작 애니메이션",
nomEnd = "종료 애니메이션",
nomSymetrie = "좌우 대칭",
nomAlpha = "불투명도",
nomPos = "위치",
nomTaille = "크기",

nomExact = "정확한 이름",
nomThreshold = "한계치",
aideThreshInv = "한계치 값을 뒤집으려면 이 옵션에 체크하십시오. 생명력/마나: 기본 = 낮음 경고/체크시 = 높음 경고. 기력/분노/마력: 기본 = 높음 경고/체크시 = 낮음 경고",
nomThreshInv = "</>",
nomStance = "태세",

nomMine = "나에 의해 시전된",
aideMine = "플레이어에 의해 시전된 버프/디버프에 한해 테스트하려면 이곳에 체크하십시오.",
nomDispellable = "내가 해제할 수 있는",

nomCheckTarget = "적대적 대상",
nomCheckFriend = "우호적 대상",
nomCheckParty = "파티원",
nomCheckFocus = "주시 대상",
nomCheckRaid = "공격대원",
nomCheckGroupOrSelf = "공격대/파티원 혹은 자신",
nomCheckGroupAny = "특정",
nomCheckOptunitn = "유닛 이름",

aideTarget = "적대적 대상에 한해 테스트하려면 이곳에 체크하십시오.",
aideTargetFriend = "우호적 대상에 한해 테스트하려면 이곳에 체크하십시오.",
aideParty = "파티원에 한해 테스트하려면 이곳에 체크하십시오.",
aideGroupOrSelf = "파티 혹은 공격대원 혹은 자신에 한해 테스트하려면 이곳에 체크하십시오.",
aideFocus = "주시 대상에 한해 테스트하려면 이곳에 체크하십시오.",
aideRaid = "공격대원에 한해 테스트하려면 이곳에 체크하십시오.",
aideGroupAny = "'특정' 파티/공격대원에 대해 버프를 테스트하려면 이곳에 체크하십시오. 비체크시: '모든' 파티/공격대원에 대해 버프가 테스트됩니다.",
aideOptunitn = "공격대/그룹에 속해 있는 특정 캐릭터에 한해 테스트하려면 이곳에 체크하십시오.",
aideExact = "버프/디버프/행동의 정확한 이름을 테스트하려면 이곳에 체크하십시오.",
aideStance = "이벤트에 적용할 태세, 오라 혹은 변신을 선택하십시오.",

nomCheckShowTimer = "보이기",
nomTimerDuration = "지속시간",
aideTimerDuration = "대상에 대해 버프/디버프 지속시간을 시연하기 위해서 타이머를 보여줍니다(비활성화하려면 0)",
aideShowTimer = "이 효과의 타이머를 보여주려면 이곳에 체크하십시오.",
aideSelectTimer = "지속시간을 보여줄 타이머를 선택합니다.",
aideSelectTimerBuff = "지속시간을 보여줄 타이머를 선택합니다(이중 하나는 플레이어의 버프를 위해 남겨둔 상태입니다).",
aideSelectTimerDebuff = "지속시간을 보여줄 타이머를 선택합니다(이중 하나는 플레이어의 디버프를 위해 남겨둔 상태입니다).",

nomCheckShowStacks = "보이기",

nomCheckInverse = "비활성화시 보이기",
aideInverse = "버프/디버프가 비활성화되어 있는 경우에만 이 효과를 보여주려면 여기에 체크하십시오.",

nomCheckIgnoreMaj = "대문자 무시",
aideIgnoreMaj = "버프/디버프 이름의 대/소문자를 무시하려면 여기에 체크하십시오.",

nomDuration = "애니메이션 지속시간",
aideDuration = "이 시간 이후로 이 효과는 나타나지 않습니다(비활성화 하려면 0)",

nomCentiemes = "초 백단위 보이기",
nomDual = "타이머 두개 보이기",
nomHideLeadingZeros = "0일때 숨기기",
nomTransparent = "반투명한 텍스쳐 사용",
nomUpdatePing = "Animate on refresh",
nomClose = "닫기",
nomEffectEditor = "효과 편집기",
nomAdvOptions = "확장 옵션",
nomMaxTex = "가능한 텍스쳐의 최대 갯수",
nomTabAnim = "애니메이션",
nomTabActiv = "활성화",
nomTabSound = "소리",
nomTabTimer = "타이머",
nomTabStacks = "중첩",
nomWowTextures = "WoW 텍스쳐",
nomCustomTextures = "사용자 텍스쳐",
nomTextAura = "문자 오라",
nomRealaura = "활성 오라",
nomRandomColor = "무작위 색상",

nomTalentGroup1 = "특성 전문화 1",
aideTalentGroup1 = "첫번째 특성을 전문화한 경우에만 이 효과를 보여줍니다.",
nomTalentGroup2 = "특성 전문화 2",
aideTalentGroup2 = "두번째 특성을 전문화한 경우에만 이 효과를 보여줍니다.",

nomReset = "편집창 위치 초기화",	
nomPowaShowAuraBrowser = "Aura Browser 보이기",

nomDefaultTimerTexture = "타이머 텍스쳐 기본값",
nomTimerTexture = "타이머 텍스쳐",
nomDefaultStacksTexture = "충첩 텍스쳐 기본값",
nomStacksTexture = "중첩 텍스쳐",

Enabled = "활성화",
Default = "기본값",

Ternary =
{
	combat = "전투 중",
	inRaid = "공격대 중",
	inParty = "파티 중",
	isResting = "휴식 중",
	ismounted = "탈것 중",
	inVehicle = "운송수단 중",
	isAlive= "살아 있을 때"
},

nomWhatever = "무시",
aideTernary = "오라표시 조건을 설정",

TernaryYes =
{
	combat = "오직 전투중일 때",
	inRaid = "오직 공격대에 속해 있을 때",
	inParty = "오직 5인 파티에 속해 있을 때",
	isResting = "오직 휴식상태일 때",
	ismounted = "오직 탈것 상태일 때",
	inVehicle = "오직 운송수단 타고 있을 때",
	isAlive= "오직 살아 있을 때만"
},

TernaryNo =
{
	combat = "전투중이 아닐 때",
	inRaid = "공격대가 아닐 때",
	inParty = "파티가 아닐 때",
	isResting = "휴식 상태가 아닐 때",
	ismounted = "탈것을 탄 상태가 아닐 때",
	inVehicle = "운송수단을 타고 있지 않을 때",
	isAlive= "죽었을 때"
},

TernaryAide =
{
	combat = "전투 상황에 의한 효능 상태.",
	inRaid = "공격대 상황에 의한 효능 상태.",
	inParty = "파티 상황에 의한 효능 상태.",
	isResting = "휴식상황에 의한 효능 상태.",
	ismounted = "탈것 상황에 의한 효능 상태.",
	inVehicle = "운송수단 상황에 의한 효능 상태.",
	isAlive= "살아 있는 상황에 의한 효능 상태."
},

nomTimerInvertAura = "시간 이하일 때 오라 반전",
aidePowaTimerInvertAuraSlider = "제한시간보다 지속시간이 적을 때 오라 반전(0일 때 비활성화)",
nomTimerHideAura = "오라 숨김 & 상기 시간까지",
aidePowaTimerHideAuraSlider = "제한 시간보다 지속시간이 더 중요할 때 오라와 시간 숨김 (0일 때 비활성화)"
})
elseif (GetLocale() == "ruRU") then
PowaAuras.Anim[0] = "[Cкрытый]"
PowaAuras.Anim[1] = "Статический"
PowaAuras.Anim[2] = "Мигание"
PowaAuras.Anim[3] = "Увеличение"
PowaAuras.Anim[4] = "Пульсация"
PowaAuras.Anim[5] = "Пузыриться"
PowaAuras.Anim[6] = "Капанье воды"
PowaAuras.Anim[7] = "Электрический"
PowaAuras.Anim[8] = "Стягивание"
PowaAuras.Anim[9] = "Огонь"
PowaAuras.Anim[10] = "Вращаться"
PowaAuras.Anim[11] = "Поворот по часовой стрелке"
PowaAuras.Anim[12] = "Поворот против часовой стрелки"

PowaAuras.BeginAnimDisplay[0] = "[Нету]"
PowaAuras.BeginAnimDisplay[1] = "Увеличить масштаб"
PowaAuras.BeginAnimDisplay[2] = "Уменьшить масштаб"
PowaAuras.BeginAnimDisplay[3] = "Только матовость"
PowaAuras.BeginAnimDisplay[4] = "Слева"
PowaAuras.BeginAnimDisplay[5] = "Вверху-слева"
PowaAuras.BeginAnimDisplay[6] = "Вверху"
PowaAuras.BeginAnimDisplay[7] = "Вверху-справа"
PowaAuras.BeginAnimDisplay[8] = "Справа"
PowaAuras.BeginAnimDisplay[9] = "Внизу-справа"
PowaAuras.BeginAnimDisplay[10] = "Внизу"
PowaAuras.BeginAnimDisplay[11] = "Внизу-слева"
PowaAuras.BeginAnimDisplay[12] = "Bounce"

PowaAuras.EndAnimDisplay[0] = "[Нету]"
PowaAuras.EndAnimDisplay[1] = "Увеличить масштаб"
PowaAuras.EndAnimDisplay[2] = "Уменьшить масштаб"
PowaAuras.EndAnimDisplay[3] = "Только матовость"
PowaAuras.EndAnimDisplay[4] = "Поворот"
PowaAuras.EndAnimDisplay[5] = "Spin In"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "Для просмотра настроек введите /powa.",

aucune = "Нету",
aucun = "Нету",
mainHand = "правая",
offHand = "левая",
bothHands = "Обе",

Unknown	 = "unknown",

DebuffType =
{
	Magic = "Магия",
	Disease = "Болезнь",
	Curse = "Проклятие",
	Poison = "Яд",
	Enrage = "Enrage",
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "Silence",
	[PowaAuras.DebuffCatType.Snare] = "Snare",
	[PowaAuras.DebuffCatType.Stun] = "Stun",
	[PowaAuras.DebuffCatType.Root] = "Root",
	[PowaAuras.DebuffCatType.Disarm] = "Disarm",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

Role =
{
	RoleTank = "Танк",
	RoleHealer = "Лекарь",
	RoleMeleDps = "Ближний бой",
	RoleRangeDps = "Дальний бой"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Бафф",
	[PowaAuras.BuffTypes.Debuff] = "Дебафф",
	[PowaAuras.BuffTypes.AoE] = "Масс дебафф",
	[PowaAuras.BuffTypes.TypeDebuff] = "Тип дебаффов",
	[PowaAuras.BuffTypes.Enchant] = "Усиление оружия",
	[PowaAuras.BuffTypes.Combo] = "Приёмы в серии",
	[PowaAuras.BuffTypes.ActionReady] = "Применимое действие",
	[PowaAuras.BuffTypes.Health] = "Здоровье",
	[PowaAuras.BuffTypes.Mana] = "Мана",
	[PowaAuras.BuffTypes.EnergyRagePower] = "Ярость/Энергия/Руны",
	[PowaAuras.BuffTypes.Aggro] = "Угроза",
	[PowaAuras.BuffTypes.PvP] = "PvP",
	[PowaAuras.BuffTypes.Stance] = "Стойка",
	[PowaAuras.BuffTypes.SpellAlert] = "Оповещение о заклинаниях",
	[PowaAuras.BuffTypes.SpellCooldown] = "Моё заклинание",
	[PowaAuras.BuffTypes.StealableSpell] = "Крадущее заклинание",
	[PowaAuras.BuffTypes.PurgeableSpell] = "Очищающее заклинание",
	[PowaAuras.BuffTypes.Static] = "Статик аура",
	[PowaAuras.BuffTypes.Totems] = "Тотемы",
	[PowaAuras.BuffTypes.Pet] = "Питомец",
	[PowaAuras.BuffTypes.Runes] = "Руны",
	[PowaAuras.BuffTypes.Slots] = "Слот экипировки",
	[PowaAuras.BuffTypes.Items] = "Named Items",
	[PowaAuras.BuffTypes.Tracking] = "Выслеживание",
	[PowaAuras.BuffTypes.GTFO] = "Предупреждение GTFO",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match"
},

PowerType =
{
	[-1] = "Default",
	[SPELL_POWER_RAGE] = "Ярость",
	[SPELL_POWER_FOCUS] = "Фокус",
	[SPELL_POWER_ENERGY] = "Энергия",
	[SPELL_POWER_RUNIC_POWER] = "Runic Power",
	[SPELL_POWER_SOUL_SHARDS] = "Soul Shards",
	[SPELL_POWER_HOLY_POWER] = "Holy Power",
	[SPELL_POWER_ALTERNATE_POWER] = "Boss Power",
	[SPELL_POWER_DARK_FORCE] = "Dark Force",
	[SPELL_POWER_CHI] = "Chi",
	[SPELL_POWER_SHADOW_ORBS] = "Shadow Orbs",
	[SPELL_POWER_BURNING_EMBERS] = "Burning Embers",
	[SPELL_POWER_DEMONIC_FURY] = "Demonic Fury"
},

Slots =
{
	Back = "Спина",
	Chest = "Грудь",
	Feet = "Ноги",
	Finger0 = "Палец1",
	Finger1 = "Палец2",
	Hands = "Руки",
	Head = "Голова",
	Legs = "Ноги",
	MainHand = "Правая рука",
	Neck = "Ожерелье",
	SecondaryHand = "Левая рука",
	Shirt = "Рубашка",
	Shoulder = "Плечи",
	Tabard = "Tabard",
	Trinket0 = "Аксессуар1",
	Trinket1 = "Аксессуар2",
	Waist = "Пояс",
	Wrist = "Запястье"
},

-- Main
nomEnable = "Активировать Power Auras",
aideEnable = "Включить все эффекты Power Auras",

nomDebug = "Активировать сообщения отладки",
aideDebug = "Включить сообщения отладки",

ListePlayer = "Страница",
ListeGlobal = "Глобальное",
aideMove = "Переместить эффект сюда.",
aideCopy = "Копировать эффект сюда.",
nomRename = "Переименовать",
aideRename = "Переименовать выбранную страницу эффектов.",

nomTest = "Тест",
nomTestAll = "Тест всего",
nomHide = "Скрыть все",
nomEdit = "Править",
nomNew = "Новое",
nomDel = "Удалить",
nomImport = "Импорт",
nomExport = "Экспорт",
nomImportSet = "Имп. набора",
nomExportSet = "Эксп. набора",
nomUnlock = "Разблокировать",
nomLock = "Блокировать",

aideImport = "Нажмите Ctrl-V чтобы вставить строку-ауры и нажмите \'Принять\'.",
aideExport = "Нажмите Ctrl-C чтобы скопировать строку-ауры.",
aideImportSet = "Нажмите Ctrl-V чтобы вставить строку-набора-аур и нажмите \'Принять\', это сотрёт все ауры на этой странице.",
aideExportSet = "Нажмите Ctrl-C чтобы скопировать все ауры на этой странице.",
aideDel = "Удалить выбранный эффект (Чтобы кнопка заработала, удерживайте CTRL)",

nomMove = "Переместить",
nomCopy = "Копировать",
nomPlayerEffects = "Эффекты персонажа",
nomGlobalEffects = "Глобальные\nэффекты",

aideEffectTooltip = "([Shift-клик] - вкл/выкл эффект)",
aideEffectTooltip2 = "([Ctrl--клик] - задать причину для активации)",

-- Editor
nomSound = "Проигрываемый звук",
nomSound2 = "Еще звуки",
aideSound = "Проиграть звук при начале.",
aideSound2 = "Проиграть звук при начале.",
nomCustomSound = "или звуковой файл:",
aideCustomSound = "Введите название звукового файла, который поместили в папку Sounds, ПРЕЖДЕ чем запустили игру. Поддерживаются mp3 и WAV. Например: 'cookie.mp3')",

nomTexture = "Текстура",
aideTexture = "Выбор отображаемой текстуры. Вы можете легко заменить текстуры путем изменения файлов Aura#.tga в директории модификации.",

nomAnim1 = "Главная анимация",
nomAnim2 = "Вторичная анимация",
aideAnim1 = "Оживить текстуры или нет, с различными эффектами.",
aideAnim2 = "Эта анимация будет показана с меньшей прозрачностью, чем основная анимация. Внимание, чтобы не перегружать экран, в одно и то же время будет показана только одна вторичная анимация.",

nomDeform = "Деформация",

aideColor = "Кликните тут, чтобы изменить цвет текстуры.",
aideTimerColor = "Click here to change the color of the timer.",
aideStacksColor = "Click here to change the color of the stacks.",
aideFont = "Нажмите сюда, чтобы выбрать шрифт. Нажмите OK, чтобы применить выбранное.",
aideMultiID = "Здесь введите идентификаторы (ID) других аур для объединения проверки. Несколько ID должны разделяться с помощью '/'. ID аура можно найти в виде [#], в первой строке подсказки ауры. А лучше на http://ru.wowhead.com",
aideTooltipCheck = "Также проверять подсказки на содержание данного текста",

aideBuff = "Здесь введите название баффа, или часть названия, который должен активировать/дезактивировать эффект. Вы можете ввести несколько названий, если они порядочно разделены (К примеру: Супер бафф/Сила)",
aideBuff2 = "Здесь введите название дебаффа, или часть названия, который должен активировать/дезактивировать эффект. Вы можете ввести несколько названий, если они порядочно разделены (К примеру: Тёмная болезнь/Чума)",
aideBuff3 = "Здесь введите тип дебаффа, который должен активировать/дезактивировать эффект (Яд, Болезнь, Проклятие, Магия или отсутствует). Вы также можете ввести несколько типов дебаффов.",
aideBuff4 = "Enter here the name of area of effect that must trigger this effect (like a rain of fire for example, the name of this AOE can be found in the combat log)",
aideBuff5 = "Enter here the temporary enchant which must activate this effect : optionally prepend it with 'main/' or 'off/ to designate mainhand or offhand slot. (ex: main/crippling)",
aideBuff6 = "Вы можете ввести количество приёмов в серии, которое активирует данный эффект (пример : 1 или 1/2/3 или 0/4/5 и т.д...) ",
aideBuff7 = "Здесь введите название или часть названия, какого-либо действия с ваших понелей команд. Эффект активируется при использовании этого действия.",
aideBuff8 = "Здесь введите название, или часть названия заклинания из вашей книги заклинаний. Вы можете ввести идентификатор(id) заклинания [12345].",

aideSpells = "Здесь введите название способности, которое вызовет оповещение.",
aideStacks = "Здесь введите оператор и значение стопки, которые должны активировать/дезактивировать эффект. Это работает только с оператором! К примеру: '<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "Здесь введите название крадущего заклинания, которое вызовет оповещение (используйте * для любого крадущего заклинания).",
aidePurgeableSpells = "Здесь введите название очищающего заклинания, которое вызовет оповещение (используйте * для любого очищающего заклинания).",

aideUnitn = "Здесь введите название существа/игрока, который должен активировать/дезактивировать эффект. Можно ввести только имена, если они находятся в вашей группе или рейде.",
aideUnitn2 = "Только в группе/рейде.",

aideMaxTex = "Определите максимальное количество текстур доступных в Редакторе эффектов. Если добавить текстуры в папке модификации (с именами AURA1.tga до AURA50.tga), здесь необходимо указать правильный номер.",
aideWowTextures = "Отметив тут, для данного эффекта будут использоваться текстуру WoW, вместо текстур в папке Power Auras.",
aideTextAura = "Отметив тут, вы можете ввести используемый текст вместо текстуры.",
aideRealaura = "Реальная аура",
aideCustomTextures = "Отметьте тут, чтобы использовать текстуры из подкаталога 'Custom'. Введите название текстуры ниже (пример: myTexture.tga). Также вы можете использовать название заклинания (ex: Притвориться мертвым) или ID заклинания (пример: 5384).",
aideRandomColor = "Отметив это, вы устанавливаете использование случайного цвета каждый раз при активации эффекта.",

aideTexMode = "Снимите этот флажок, чтобы использовать полупрозрачность текстур. По умолчанию, темные цвета будут более прозрачными.",

nomActivationBy = "Активация :",

nomOwnTex = "Своя текстуру",
aideOwnTex = "Используйте де/бафф или способность вместо текстур.",
nomStacks = "Стопка",

nomUpdateSpeed = "Скорость обновления",
nomSpeed = "Скорость анимации",
nomTimerUpdate = "Скорость обновления таймера",
nomBegin = "Начало анимации",
nomEnd = "Конец анимации",
nomSymetrie = "Симметрия",
nomAlpha = "Прозрачность",
nomPos = "Позиция",
nomTaille = "Размер",

nomExact = "Точное название",
nomThreshold = "Порог",
aideThreshInv = "Инверсия логики порога значений. Здоровье/Мана: по умолчанию = сообщать при малом количестве / отмечено = сообщать при большем количестве. Энергия/Ярость/Сила: по умолчанию = сообщать при большем количестве / отмечено = сообщать при малом количестве",
nomThreshInv = "</>",
nomStance = "Стойка",
nomGTFO = "Тип тревоги",
nomPowerType = "Power Type:",

nomMine = "Применяемое мною",
aideMine = "Отметив это, будет происходить проверка только баффов/дебаффав применяемых игроком.",
nomDispellable = "Могу рассеять",
aideDispellable = "Отметив это, будут отображаться только те баффы, которые можно рассеить",
nomCanInterrupt = "Может быть прерван",
aideCanInterrupt = "Отметив это, будут отображаться только те заклинания которые могут быть прерваны",

nomPlayerSpell = "Игрок применяет",
aidePlayerSpell = "Проверять, применяет ли игрок заклинание",

nomCheckTarget = "Враждебная цель",
nomCheckFriend = "Дружелюбная цель",
nomCheckParty = "Участник группы",
nomCheckFocus = "Фокус",
nomCheckRaid = "Участник рейда",
nomCheckGroupOrSelf = "Рейд/Группу/Себя",
nomCheckGroupAny = "Любой",
nomCheckOptunitn = "Название юнита",

aideTarget = "Отметив это, будет происходить проверка только враждебной цели.",
aideTargetFriend = "Отметив это, будет происходить проверка только дружеской цели.",
aideParty = "Отметив это, будет происходить проверка только участников группы.",
aideGroupOrSelf = "Отметив это, будет происходить проверка группы или рейда или вас.",
aideFocus = "Отметив это, будет происходить проверка только фокуса.",
aideRaid = "Отметив это, будет происходить проверка только участника рейда.",
aideGroupAny = "Отметив это, будет происходить проверка баффов у 'любого' участника группы/рейда. Без отметки: Будет подразумеваться что 'Все' участники с баффами.",
aideOptunitn = "Отметив это, будет происходить проверка только определённого персонажа в группе/рейде.",
aideExact = "Отметив это, будет происходить проверка точного названия баффа/дебаффа/действия.",	
aideStance = "Выберите, какая стойка, форма или аура вызовет событие.",
aideGTFO = "Выберите, какое предупреждение GTFO вызовет событие.",

aideShowSpinAtBeginning = "В конце начать отображать анимацию с поворотом на 360 градусов",
nomCheckShowSpinAtBeginning = "Показать поворот после начала конца анимации",

nomCheckShowTimer = "Показать",
nomTimerDuration = "Длительность",
aideTimerDuration = "Отображать таймер симулирующий длительность баффа/дебаффа на цели (0 - дезактивировать)",
aideShowTimer = "Отображение таймера для этого эффекта.",
aideSelectTimer = "Выберите, который таймер будет отображать длительность.",
aideSelectTimerBuff = "Выберите, который таймер будет отображать длительность (это предназначено для баффов игроков)",
aideSelectTimerDebuff = "Выберите, который таймер будет отображать длительность (это предназначено для баффов игроков)",

nomCheckShowStacks = "Показать",

nomCheckInverse = "Инвертировать",
aideInverse = "Инвертировать логику отображение этого эффекта только когда бафф/дебафф неактивен.",

nomCheckIgnoreMaj = "Игнор верхнего регистра",
aideIgnoreMaj = "Если отметите это, будет игнорироваться верхний/нижний регистр строчных букв в названиях баффов/дебаффов.",

nomAuraDebug = "Отладка",
aideAuraDebug = "Отлажывать данную ауру",

nomDuration = "Длина анимации:",
aideDuration = "После истечения этого времени, данный эффект исчезнет (0 - дезактивировать)",

nomOldAnimations = "Старая анимация",
aideOldAnimations = "Использовать старую анимацию",

nomCentiemes = "Показывать сотую часть",
nomDual = "Показывать 2 таймера",
nomHideLeadingZeros = "Убрать нули",
nomTransparent = "Прозрачные текстуры",
nomActivationTime = "Показать время после активации",
nomUseOwnColor = "ТИспользовать свой цвет:",
nomClose = "Закрыть",
nomEffectEditor = "Редактор эффектов",
nomAdvOptions = "Опции",
nomMaxTex = "Доступно максимум текстур",
nomTabAnim = "Анимация",
nomTabActiv = "Активация",
nomTabSound = "Звук",
nomTabTimer = "Таймер",
nomTabStacks = "Стопки",
nomWowTextures = "Текстуры WoW",
nomCustomTextures = "Свои текстуры",
nomTextAura = "Текст ауры",
nomRealaura = "Реальные ауры",
nomRandomColor = "Случайные цвета",

nomTalentGroup1 = "Спек 1",
aideTalentGroup1 = "Отображать данный эффект только когда у вас активирован основной набор талантов.",
nomTalentGroup2 = "Спек 2",
aideTalentGroup2 = "Отображать данный эффект только когда у вас активирован второстепенный набор талантов.",

nomReset = "Сброс позиции редактора",
nomPowaShowAuraBrowser = "Показать окно просмотра аур",

nomDefaultTimerTexture = "Стандартная текстура таймера",
nomTimerTexture = "Текстура таймера",
nomDefaultStacksTexture = "Стандартная текстура стопки",
nomStacksTexture = "Текстура стопки",

Enabled = "Включено",
Default = "По умолчанию",

Ternary =
{
	combat = "В бою",
	inRaid = "В рейде",
	inParty = "В группе",
	isResting = "Отдых",
	ismounted = "Верхом",
	inVehicle = "В транспорте",
	isAlive = "Живой",
	PvP = "С меткой PvP",
	Instance5Man = "5-чел",
	Instance5ManHeroic = "5-чел Гер",
	Instance10Man = "10-чел",
	Instance10ManHeroic = "10-чел Гер",
	Instance25Man = "25-чел",
	Instance25ManHeroic = "25-чел Гер",
	InstanceBg = "Поле боя",
	InstanceArena = "Арена"
},

nomWhatever = "Игнорировать",
aideTernary = "Установите в каком состоянии, будет отображаться эта ауры.",

TernaryYes =
{
	combat = "Только когда в бою",
	inRaid = "Только когда в рейде",
	inParty = "Только когда в группе",
	isResting = "Только когда вы отдыхаете",
	ismounted = "Только когда на средстве передвижения",
	inVehicle = "Только когда в транспорте",
	isAlive = "Только когда жив",
	PvP = "Только когда включен PvP режим",
	Instance5Man = "Только когда в обычном подземелье на 5-чел",
	Instance5ManHeroic = "Только когда в героическом подземелье на 5-чел",
	Instance10Man = "Только когда в обычном подземелье на 10-чел",
	Instance10ManHeroic = "Только когда в героическом подземелье на 10-чел",
	Instance25Man = "Только когда в обычном подземелье на 25-чел",
	Instance25ManHeroic = "Только когда в героическом подземелье на 25-чел",
	InstanceBg = "Только когда на поле боя",
	InstanceArena = "Только когда на арене",
	RoleTank = "Only when a Tank",
	RoleHealer = "Only when a Healer",
	RoleMeleDps = "Only when a Melee DPS",
	RoleRangeDps = "Only when a Ranged DPS"
},

TernaryNo =
{
	combat = "Только когда НЕ в бою",
	inRaid = "Только когда НЕ в рейде",
	inParty = "Только когда НЕ в группе",
	isResting = "Только когда НЕ на отдыхе",
	ismounted = "Только когда НЕ на средстве передвижения",
	inVehicle = "Только когда НЕ в транспорте",
	isAlive = "Только когда мёртв",
	PvP = "Только когда НЕ включен PvP режим",
	Instance5Man = "Только когда НЕ в обычном подземелье на 5-чел",
	Instance5ManHeroic = "Только когда НЕ в героическом подземелье на 5-чел",
	Instance10Man = "Только когда НЕ в обычном подземелье на 10-чел",
	Instance10ManHeroic = "Только когда НЕ в героическом подземелье на 10-чел",
	Instance25Man = "Только когда НЕ в обычном подземелье на 25-чел",
	Instance25ManHeroic = "Только когда НЕ в героическом подземелье на 25-чел",
	InstanceBg = "Только когда НЕ на поле боя",
	InstanceArena = "Только когда НЕ на арене",
	RoleTank = "Only when Not a Tank",
	RoleHealer = "Only when Not a Healer",
	RoleMeleDps = "Only when Not a Melee DPS",
	RoleRangeDps = "Only when Not a Ranged DPS"
},

TernaryAide =
{
	combat = "Эффект изменен статусом боя.",
	inRaid = "Эффект изменен статусом участия в рейде.",
	inParty = "Эффект изменен статусом участия в группе.",
	isResting = "Эффект изменен статусом отдыха.",
	ismounted = "Эффект изменен статусом - на средстве передвижения.",
	inVehicle = "Эффект изменен статусом - в транспорте.",
	isAlive = "Эффект изменен статусом - живой.",
	PvP = "Эффект изменен статусом PvP",
	Instance5Man = "Эффект изменен нахождением в обычном подземелье на 5-чел",
	Instance5ManHeroic = "Эффект изменен нахождением в героическом подземелье на 5-чел",
	Instance10Man = "Эффект изменен нахождением в обычном подземелье на 10-чел",
	Instance10ManHeroic = "Эффект изменен нахождением в героическом подземелье на 10-чел",
	Instance25Man = "Эффект изменен нахождением в обычном подземелье на 25-чел",
	Instance25ManHeroic = "Эффект изменен нахождением в героическом подземелье на 25-чел",
	InstanceBg = "Эффект изменен нахождением на поле боя",
	InstanceArena = "Эффект изменен нахождением на арене",
	RoleTank = "Effect modified by being a Tank",
	RoleHealer = "Effect modified by being a Healer",
	RoleMeleDps = "Effect modified by being a Melee DPS",
	RoleRangeDps = "Effect modified by being a Ranged DPS"
},

nomTimerInvertAura = "Инвертировать ауру когда время ниже",
aidePowaTimerInvertAuraSlider = "Инвертировать ауру когда длительность меньше чем этот предел (0 - дезактивировать)",
nomTimerHideAura = "Скрыть ауру и таймер если время выше",
aidePowaTimerHideAuraSlider = "Скрыть ауру и таймер когда длительность больше чем этот предел (0 - дезактивировать)",

aideTimerRounding = "When checked will round the timer up",
nomTimerRounding = "Round Timer Up",

aideAllowInspections = "Allow Power Auras to Inspect players to determine roles, turning this off will sacrifice accuracy for speed",
nomAllowInspections = "Allow Inspections",

nomIgnoreUseable = "Только восстановление",
aideIgnoreUseable = "Ignores if spell is usable (just uses cooldown)",

nomIgnoreItemUseable = "Equipped Only",
aideIgnoreItemUseable = "Ignores if item is usable (just if equipped)",

nomCarried = "Only if in bags",
aideCarried = "Ignores if item is usable (just if in a bag)",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "Следует показать, потому что $1",
nomReasonWontShow = "Не показывают, потому что $1",

nomReasonMulti = "Все многочисленные совпадения $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras отключен",
nomReasonGlobalCooldown = "Игнорировать общее восстановление (ГКД)",

nomReasonBuffPresent = "$1 имеет $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
nomReasonBuffMissing = "$1 не имеет $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
nomReasonBuffFoundButIncomplete = "$2 $3 найден у $1 но\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 имеет $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "Не все в $1 имеют $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
nomReasonAllInGroupHaveBuff = "Все в $1 имеют $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "Никто в $1 неимеет $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Buff present, timer invert",
nomReasonBuffPresentNotMine = "Применено не мною",
nomReasonBuffFound = "Buff present",
nomReasonStacksMismatch = "Stacks = $1 expecting $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

nomReasonAuraMissing = "Аура отсутствует",
nomReasonAuraOff = "Нет ауры",
nomReasonAuraBad = "Плохая аура",

nomReasonNotForTalentSpec = "Аура не активирована для данного набора талантов",

nomReasonPlayerDead = "Игрок УМЕР",
nomReasonPlayerAlive = "Игрок ЖИВ",
nomReasonNoTarget = "Нет цели",
nomReasonTargetPlayer = "Цель - вы",
nomReasonTargetDead = "Цель мертва",
nomReasonTargetAlive = "Цель жива",
nomReasonTargetFriendly = "Цель - Союзник",
nomReasonTargetNotFriendly = "Цель - не Союзник",

nomReasonNotInCombat = "Вне боя",
nomReasonInCombat = "В боя",

nomReasonInParty = "В группе",
nomReasonInRaid = "В рейде",
nomReasonNotInParty = "Не в группе",
nomReasonNotInRaid = "Не в рейде",
nomReasonNotInGroup = "Не в группе/рейде",
nomReasonNoFocus = "Нет фокуса",
nomReasonNoCustomUnit = "Can't find custom unit not in party, raid or with pet unit=$1",
nomReasonPvPFlagNotSet = "Режим PvP не включен",
nomReasonPvPFlagSet = "Режим PvP включен",

nomReasonNotMounted = "Не на средстве передвижения",
nomReasonMounted = "На средстве передвижения",
nomReasonNotInVehicle = "Не в транспорте",
nomReasonInVehicle = "В транспорте",
nomReasonNotResting = "Не отдыхает",
nomReasonResting = "Отдых",
nomReasonStateOK = "Состояние OK",

nomReasonNotIn5ManInstance = "Не в подземелье на 5-чел",
nomReasonIn5ManInstance = "В подземелье на 5-чел",
nomReasonNotIn5ManHeroicInstance = "Не в героическом подземелье на 5-чел",
nomReasonIn5ManHeroicInstance = "В героическом подземелье на 5-чел",

nomReasonNotIn10ManInstance = "Не в подземелье на 10-чел",
nomReasonIn10ManInstance = "В подземелье на 10-чел",
nomReasonNotIn10ManHeroicInstance = "Не в героическом подземелье на 10-чел",
nomReasonIn10ManHeroicInstance = "В героическом подземелье на 10-чел",

nomReasonNotIn25ManInstance = "Не в подземелье на 25-чел",
nomReasonIn25ManInstance = "В подземелье на 25-чел",
nomReasonNotIn25ManHeroicInstance = "Не в героическом подземелье на 25-чел",
nomReasonIn25ManHeroicInstance = "В героическом подземелье на 25-чел",

nomReasonNotInBgInstance = "Не на поле боя",
nomReasonInBgInstance = "На поле боя",
nomReasonNotInArenaInstance = "Не на арене",
nomReasonInArenaInstance = "На арене",

nomReasonInverted = "$1 (инвертированный)", -- $1 is the reason, but the inverted flag is set so the logic is reversed

nomReasonSpellUsable = "Заклинание $1 используемое",
nomReasonSpellNotUsable = "Заклинание $1 не используемое",
nomReasonSpellNotReady = "Заклинание $1 не готово, на восстановлении, инверсия таймера",
nomReasonSpellNotEnabled = "Заклинание $1 не включено ",
nomReasonSpellNotFound = "Заклинание $1 не найдено",
nomReasonSpellOnCooldown = "Заклинание $1 на восстановлении",

nomReasonStealablePresent = "$1 имеет похищающее заклинание $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "Никто не имеет похищающее заклинание $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "Raid$1Target имеет похищающее заклинание $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "Party$1Target имеет похищающее заклинание $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 имеет очищающее заклинание $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "Никто не имеет очищающее заклинание $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "Raid$1Target имеет очищающее заклинание $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "Party$1Target имеет очищающее заклинание $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonEnchantMainInvert = "Найдено улучшение $1 на правой руке, инверсия таймера", -- $1=Enchant match
nomReasonEnchantMain = "Найдено улучшение $1 на правой руке", -- $1=Enchant match
nomReasonEnchantOffInvert = "Найдено улучшение $1 на левой руке, инверсия таймера", -- $1=Enchant match
nomReasonEnchantOff = "Найдено улучшение $1 на левой руке", -- $1=Enchant match
nomReasonNoEnchant = "Улучшений оружия ненайдено на $1", -- $1=Enchant match

nomReasonNoUseCombo = "Вы не используете длину серии приемов",
nomReasonComboMatch = "Длина серии приемов $1, совпадает с $2", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "Длина серии приемов $1, не совпадает с $2", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "не найдено на панеле команд",
nomReasonActionReady = "Действие готово",
nomReasonActionNotReadyInvert = "Действие не готово (на восстановлении), инверсия таймера",
nomReasonActionNotReady = "Действие не готово (на восстановлении)",
nomReasonActionlNotEnabled = "Действие не включено",
nomReasonActionNotUsable = "Действие не используемое",

nomReasonYouAreCasting = "Вы применяете $1", -- $1=Casting match
nomReasonYouAreNotCasting = "Вы не применяете $1", -- $1=Casting match
nomReasonTargetCasting = "Цель применяет $1", -- $1=Casting match
nomReasonFocusCasting = "Фокус применяет $1", -- $1=Casting match
nomReasonRaidTargetCasting = "Raid$1цель применяет $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "Party$1цель применяет $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "Nobody's target casting $1", -- $1=Casting match

nomReasonStance = "Текущая стойка $1, совпадает с $2", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "Текущая стойка $1, не совпадает с $2", -- $1=Current Stance, $2=Match Stance

nomReasonRunesNotReady = "Руны не готовы",
nomReasonRunesReady = "Руны готовы",

ReasonStat =
{
	Health = {MatchReason = "$1 Низкий уровень здоровья", NoMatchReason = "$1 Уровень здоровье не достаточно низкий"},
	Mana = {MatchReason = "$1 Низкий уровень маны", NoMatchReason = "$1 Уровень мана не достаточно низкий"},
	RageEnergy = {MatchReason = "$1 Низкий уровень энергии", NoMatchReason = "$1 Уровень энергия не достаточно низкий"},
	Aggro = {MatchReason = "$1 присутствует угроза", NoMatchReason = "$1 без угрозы"},
	PvP = {MatchReason = "$1 с меткой PvP", NoMatchReason = "$1 без метки PvP"},
	SpellAlert = {MatchReason = "$1 casting $2", NoMatchReason = "$1 not casting $2"}
}
})
elseif (GetLocale() == "zhCN") then
PowaAuras.Anim[0] = "[无]"
PowaAuras.Anim[1] = "静止"
PowaAuras.Anim[2] = "闪光效果"
PowaAuras.Anim[3] = "生长效果"
PowaAuras.Anim[4] = "脉搏效果"
PowaAuras.Anim[5] = "气泡效果"
PowaAuras.Anim[6] = "水滴效果"
PowaAuras.Anim[7] = "漏电效果"
PowaAuras.Anim[8] = "收缩效果"
PowaAuras.Anim[9] = "火焰效果"
PowaAuras.Anim[10] = "盘旋效果"

PowaAuras.BeginAnimDisplay[0] = "[无]"
PowaAuras.BeginAnimDisplay[1] = "由小放大"
PowaAuras.BeginAnimDisplay[2] = "由大渐小"
PowaAuras.BeginAnimDisplay[3] = "逐渐清晰"
PowaAuras.BeginAnimDisplay[4] = "左边进入"
PowaAuras.BeginAnimDisplay[5] = "左上进入"
PowaAuras.BeginAnimDisplay[6] = "上部进入"
PowaAuras.BeginAnimDisplay[7] = "右上进入"
PowaAuras.BeginAnimDisplay[8] = "右边进入"
PowaAuras.BeginAnimDisplay[9] = "右下进入"
PowaAuras.BeginAnimDisplay[10] = "下部进入"
PowaAuras.BeginAnimDisplay[11] = "左下进入"
PowaAuras.BeginAnimDisplay[12] = "弹跳进入"

PowaAuras.EndAnimDisplay[0] = "[无]"
PowaAuras.EndAnimDisplay[1] = "放大消失"
PowaAuras.EndAnimDisplay[2] = "缩小消失"
PowaAuras.EndAnimDisplay[3] = "淡化消失"
PowaAuras.EndAnimDisplay[4] = "旋转渐隐"
PowaAuras.EndAnimDisplay[5] = "旋转缩小"

PowaAuras.Sound[0] = "[无]"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "输入 /powa 打开特效编辑器.",

aucune = "无",
aucun = "无",
mainHand = "主手",
offHand = "副手",
bothHands = "双手",

DebuffType =
{
	Magic = "魔法",
	Disease = "疾病",
	Curse = "诅咒",
	Poison = "中毒",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "沉默",
	[PowaAuras.DebuffCatType.Snare] = "诱捕",
	[PowaAuras.DebuffCatType.Stun] = "昏迷",
	[PowaAuras.DebuffCatType.Root] = "无法行动",
	[PowaAuras.DebuffCatType.Disarm] = "缴械",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Buff",
	[PowaAuras.BuffTypes.Debuff] = "Debuff",
	[PowaAuras.BuffTypes.AoE] = "AOE法术",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debuff类型",
	[PowaAuras.BuffTypes.Enchant] = "武器强化",
	[PowaAuras.BuffTypes.Combo] = "连击点数",
	[PowaAuras.BuffTypes.ActionReady] = "技能冷却",
	[PowaAuras.BuffTypes.Health] = "生命值",
	[PowaAuras.BuffTypes.Mana] = "魔法值",
	[PowaAuras.BuffTypes.EnergyRagePower] = "怒气/能量/符文能量",
	[PowaAuras.BuffTypes.Aggro] = "获得仇恨",
	[PowaAuras.BuffTypes.PvP] = "PvP标志",
	[PowaAuras.BuffTypes.Stance] = "姿态",
	[PowaAuras.BuffTypes.SpellAlert] = "法术预警",
	[PowaAuras.BuffTypes.SpellCooldown] = "自身技能",
	[PowaAuras.BuffTypes.StealableSpell] = "可偷取法术",
	[PowaAuras.BuffTypes.PurgeableSpell] = "可净化法术",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match"
},

-- Main
nomEnable = "启用",
aideEnable = "启用/禁用所有PowerAuras特效",

nomDebug = "调试模式",
nomTextureCount = "Max Textures",
aideDebug = "打开调试模式后,将在聊天窗口显示特效的触发条件等信息",
ListePlayer = "分类",
ListeGlobal = "全局",
aideMove = "移动特效",
aideCopy = "复制特效",
nomRename = "重命名",
aideRename = "重命名我的特效分类名",
nomTest = "测试",
nomHide = "全部隐藏",
nomEdit = "编辑",
nomNew = "新建",
nomDel = "删除",
nomImport = "导入",
nomExport = "导出",
nomImportSet = "批量导入",
nomExportSet = "批量导出",
aideImport = "把特效字串粘贴(Ctrl+v)在此编辑框内,然后点击\'接受\'按钮",
aideExport = "复制(Ctrl+c)此编辑框内的特效字串,与其它人分享你的特效",
aideImportSet = "把批量特效字串粘贴(Ctrl+v)在此编辑框内,然后点击\'接受\'按钮,注意:批量导入时将会删除本页所有现有特效",
aideExportSet = "复制(Ctrl+c)此编辑框内的特效字串,将此页内所有特效与其它人分享",
aideDel = "删除所选特效(必须按住Ctrl键才能使用此功能)",
nomMove = "移动",
nomCopy = "复制",
nomPlayerEffects = "我的特效",
nomGlobalEffects = "通用特效",
aideEffectTooltip = "按住Shift键点击图标以启用/禁用该特效",

-- Editor
nomSound = "播放声音",
aideSound = "特效触发时播放声音",
nomCustomSound = "自定义声音文件:",
aideCustomSound = "输入声音文件名称,如cookie.mp3 注意:你需要在游戏启动前把声音文件放入Sounds文件夹下,目前仅支持mp3和wav格式.",

nomTexture = "当前材质",
aideTexture = "显示特效使用的材质.你可以修改相应文件夹内的.tga 文件来增加特效",

nomAnim1 = "动画效果",
nomAnim2 = "辅助效果",
aideAnim1 = "是否为所选材质使用动画效果",
aideAnim2 = "此动画效果以较低不透明度显示,为了不过多占用屏幕同一时间只显示一个辅助效果",

nomDeform = "拉伸",

aideColor = "点击此处修改材质颜色",
aideFont = "点击此处来选择字体,点击OK按钮使你的选择生效",
aideMultiID = "此处输入其它特效的ID,以执行联合检查.多个ID号须用'/'分隔. 特效ID可以在某个特效的鼠标提示中第一行找到,如:[2],2就是此特效ID",
aideTooltipCheck = "此处输入用于激活特效的某个状态的鼠标提示文字",

aideBuff = "此处输入用于激活特效的buff的名字,或名字中的几个连续文字.如果使用分隔符,也可以输入多个buff的名字.例如输入: 能量灌注/奥术能量",
aideBuff2 = "此处输入用于激活特效的debuff的名字,或名字中的几个连续文字.如果使用分隔符,也可以输入多个debuff的名字.例如输入: 堕落治疗/燃烧刺激",
aideBuff3 = "此处输入用于激活特效的debuff的类型名称,或名称中的几个连续文字.如果使用分隔符,也可以输入多个debuff类型的名称.例如输入: 魔法/诅咒/中毒/疾病",
aideBuff4 = "此处输入用于激活特效的AOE法术的名字,AOE法术名字可以在战斗记录中找到.例如输入:邪恶光环/火焰之雨/暴风雪",
aideBuff5 = "此处输入用于激活特效的武器临时附魔效果.另外你可以通过前置'main/'或者'off/'来指明主副手位置(例如: main/致残毒药,表示检测主手上的这种毒药)",
aideBuff6 = "此处输入用于激活特效的连击点数.例如输入: 1或者1/2/3或者0/4/5等等自由组合",
aideBuff7 = "此处输入用于激活特效的动作条上的动作名,或名字中的几个连续文字,当此动作完全冷却时此效果触发.例如输入:赞达拉英雄护符/法力之潮图腾/心灵专注",
aideBuff8 = "此处输入用于激活特效的法术名称,或名称中的一部分,或者是你技能书中的技能,也可以输入一个技能ID",

aideSpells = "此处输入用于激活法术预警特效的法术名称",
aideStacks = "输入用于激活特效的操作符及叠加数量，只能输入一个操作符，例如：'<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "此处输入可偷取的法术名称(用 * 将检测所有可被偷取的法术).",
aidePurgeableSpells = "此处输入可净化的法术名称(用 * 将检测所有可被净化的法术).",

aideUnitn = "此处输入用于激活特效的特定成员名称,必须处于同一团队",
aideUnitn2 = "仅用于团队/队伍模式",

aideMaxTex = "定义特效编辑器使用的材质数量,如果你增加了自定义材质请修改此值.",
aideWowTextures = "使用游戏内置材质",
aideTextAura = "使用文字做为特效材质(图形材质将被禁用)",
aideRealaura = "清晰光环",
aideCustomTextures = "使用自定义材质,例如: Flamme.tga(自定义材质需保存在custom文件夹下)",
aideRandomColor = "每次激活时使用随机颜色",

aideTexMode = "材质透明度反向显示",

nomActivationBy = "激活条件",

nomOwnTex = "使用技能图标",
aideOwnTex = "使用buff/debuff或技能的默认图标做为材质",
nomStacks = "叠加",

nomUpdateSpeed = "更新速度",
nomSpeed = "运动速度",
nomTimerUpdate = "计时器更新速度",
nomBegin = "进场效果",
nomEnd = "结束效果",
nomSymetrie = "对称性",
nomAlpha = "不透明度",
nomPos = "位置",
nomTaille = "大小",

nomExact = "精确匹配名称",
nomThreshold = "触发极限",
aideThreshInv = "选中此项可反转触发逻辑. 生命值/法力值: 默认=低于指定值时触发特效 / 选中此项后=高于指定值时触发特效. 能量/怒气/符文能量: 默认=高于指定值时触发特效 / 选中此项后=低于指定值时触发特效",
nomThreshInv = "</>",
nomStance = "姿态",

nomMine = "自己施放的",
aideMine = "选中此项则仅检测由玩家自己施放的buff/debuff",
nomDispellable = "自己可以驱散的",
aideDispellable = "选中此项则仅检测可被驱散的buff",
nomCanInterrupt = "可打断",
aideCanInterrupt = "选中此项则仅检测可被打断的技能",

nomPlayerSpell = "施法状态",
aidePlayerSpell = "检测玩家是否正在咏唱一个法术",

nomCheckTarget = "敌方目标",
nomCheckFriend = "友方目标",
nomCheckParty = "团队目标",
nomCheckFocus = "焦点目标",
nomCheckRaid = "团队成员",
nomCheckGroupOrSelf = "团队/小队或自己",
nomCheckGroupAny = "任何人",
nomCheckOptunitn = "特定成员",

aideTarget = "此buff/debuff仅存在于敌方目标上",
aideTargetFriend = "此buff/debuff仅存在于友方目标上",
aideParty = "此buff/debuff仅存在于小队中",
aideGroupOrSelf = "选中此项后将仅对团队或小队成员(包括自己)进行检测",
aideFocus = "此buff/debuff仅存在焦点目标上",
aideRaid = "此buff/debuff仅存在于团队中",
aideGroupAny = "选中此项后,当任何一个小队/团队成员有此buff/debuff就触发特效. 不选中此项(默认状态),则检查到所有人都有此buff/debuff才触发特效",
aideOptunitn = "此buff/debuff仅存在于团队/小队中的特定成员身上",
aideExact = "选中此项将精确匹配buff/debuff名称",
aideStance = "选择用于触发特效的姿态",

aideShowSpinAtBeginning = "起始动画结束后使其做360度旋转",
nomCheckShowSpinAtBeginning = "动画结束后旋转",

nomCheckShowTimer = "显示",
nomTimerDuration = "延迟消失",
aideTimerDuration = "目标上的buff/debuff计时器延迟到此时间结束后再消失(0为禁用)",
aideShowTimer = "为此效果显示计时器",
aideSelectTimer = "选择使用何种计时器来显示持续时间",
aideSelectTimerBuff = "选择使用何种计时器来显示持续时间(仅用于玩家buff)",
aideSelectTimerDebuff = "选择使用何种计时器来显示持续时间(仅用于玩家debuff)",

nomCheckShowStacks = "叠加次数",

nomCheckInverse = "不存在",
aideInverse = "选中此项后,仅当buff/debuff不存在时显示此特效",

nomCheckIgnoreMaj = "忽略大小写",	
aideIgnoreMaj = "选中此项将忽略buff/debuff名字的大小写字母(供英文玩家使用,中国玩家不需要修改此项)",

nomDuration = "延迟消失",
aideDuration = "特效延迟到此时间结束后再消失(0为禁用)",

nomCentiemes = "显示百分位",
nomDual = "显示两个计时器",
nomHideLeadingZeros = "隐藏前置零位,如:08秒显示为8秒",
nomTransparent = "使用透明材质",
nomUpdatePing = "刷新提示",
nomClose = "关闭",
nomEffectEditor = "特效编辑器",
nomAdvOptions = "选项",
nomMaxTex = "最大可用材质",
nomTabAnim = "动画",
nomTabActiv = "条件",
nomTabSound = "声音",
nomTabTimer = "计时器",
nomTabStacks = "叠加",
nomWowTextures = "使用内置材质",
nomCustomTextures = "使用自定义材质",
nomTextAura = "文字材质",
nomRealaura = "清晰光环",
nomRandomColor = "随机颜色",

nomTalentGroup1 = "主天赋",
aideTalentGroup1 = "选中此项后,仅当你处于主天赋状态下才触发此特效",
nomTalentGroup2 = "副天赋",
aideTalentGroup2 = "选中此项后,仅当你处于副天赋状态下才触发此特效",

nomReset = "重置编辑器位置",
nomPowaShowAuraBrowser = "显示特效浏览器",

nomDefaultTimerTexture = "默认计时器材质",
nomTimerTexture = "计时器材质",
nomDefaultStacksTexture = "默认叠加次数材质",
nomStacksTexture = "叠加次数材质",

Enabled = "已启用",
Default = "默认",

Ternary =
{
	combat = "战斗状态",
	inRaid = "团队状态",
	inParty = "小队状态",
	isResting = "休息状态",
	ismounted = "骑乘状态",
	inVehicle = "载具状态",
	isAlive = "存活状态"
},

nomWhatever = "忽略",
aideTernary = "设置这些状态将影响特效显示的方式",

TernaryYes =
{
	combat = "在战斗状态时触发",
	inRaid = "在团队状态时触发",
	inParty = "在小队状态时触发",
	isResting = "在休息状态时触发",
	ismounted = "在骑乘状态时触发",
	inVehicle = "在载具状态时触发",
	isAlive = "在存活状态时触发"
},

TernaryNo =
{
	combat = "非战斗状态时触发",
	inRaid = "非团队状态时触发",
	inParty = "非小队状态时触发",
	isResting = "非休息状态时触发",
	ismounted = "非骑乘状态时触发",
	inVehicle = "非载具状态时触发",
	isAlive = "在死亡状态时触发"
},

TernaryAide =
{
	combat = "此效果受战斗状态影响",
	inRaid = "此效果受团队状态影响",
	inParty = "此效果受小队状态影响",
	isResting = "此效果受休息状态影响",
	ismounted = "此效果受骑乘状态影响",
	inVehicle = "此效果受载具状态影响",
	isAlive = "此效果受存活状态影响"
},

nomTimerInvertAura = "超时颠倒材质",
aidePowaTimerInvertAuraSlider = "特效持续时间超过设定值时将材质颠倒(0 为禁用)",
nomTimerHideAura = "隐藏特效",
aidePowaTimerHideAuraSlider = "隐藏特效和计时器,直到持续时间超过设定值(0 为禁用)",

aideTimerRounding = "选中此项时将对计时器取整",
nomTimerRounding = "取整",

aideGTFO = "使用首领技能来匹配AOE法术预警检测",
nomGTFO = "首领AOE法术",

nomIgnoreUseable = "显示冷却中的法术",
aideIgnoreUseable = "忽略可用的法术(仅检测冷却中的法术)",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "应该显示特效,因为$1",
nomReasonWontShow = "不会显示特效,因为$1",

nomReasonMulti = "所有匹配特征 $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras 被禁用了",
nomReasonGlobalCooldown = "忽略了全局冷却时间(GCD)",

nomReasonBuffPresent = "$1 获得了 $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
nomReasonBuffMissing = "$1 没有获得 $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
nomReasonBuffFoundButIncomplete = "$2 $3 作用在 $1 上,但是\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 获得了 $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "不是所有 $1 的成员都获得了$2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
nomReasonAllInGroupHaveBuff = "所有 $1 的成员都获得了 $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "没有 $1 的成员获得了 $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Buff出现, 计时器倒置",
nomReasonBuffFound = "Buff出现",
nomReasonStacksMismatch = "叠加次数 = $1 但预设值是 $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

nomReasonAuraMissing = "特效丢失",
nomReasonAuraOff = "特效被禁用",
nomReasonAuraBad = "特效损坏",

nomReasonNotForTalentSpec = "在此套天赋下特效不会触发",

nomReasonPlayerDead = "玩家死亡",
nomReasonPlayerAlive = "玩家存活",
nomReasonNoTarget = "没有目标",
nomReasonTargetPlayer = "目标是你",
nomReasonTargetDead = "目标死亡",
nomReasonTargetAlive = "目标存活",
nomReasonTargetFriendly = "友好的目标",
nomReasonTargetNotFriendly = "敌对的目标",

nomReasonNotInCombat = "不在战斗状态",
nomReasonInCombat = "在战斗状态",

nomReasonInParty = "在小队中",
nomReasonInRaid = "在团队中",
nomReasonNotInParty = "不在小队中",
nomReasonNotInRaid = "不在团队中",
nomReasonNoFocus = "没有焦点目标",
nomReasonNoCustomUnit = "找不到你定义的单位:$1,不在队伍\团队中,或携带宠物",

nomReasonNotMounted = "不在骑乘",
nomReasonMounted = "骑乘状态",
nomReasonNotInVehicle = "不在载具中",
nomReasonInVehicle = "在载具中",
nomReasonNotResting = "不在休息状态",
nomReasonResting = "休息状态",
nomReasonStateOK = "状态正常",

nomReasonInverted = "$1 (被倒置)", -- $1 is the reason, but the inverted flag is set so the logic is reversed

nomReasonSpellUsable = "法术 $1 可用",
nomReasonSpellNotUsable = "法术 $1 不可用",
nomReasonSpellNotReady = "法术 $1 没有准备好, 在冷却中, 计时器倒置",
nomReasonSpellNotEnabled = "法术 $1 没有启用",
nomReasonSpellNotFound = "法术 $1 没有找到",
nomReasonSpellOnCooldown = "Spell $1 on Cooldown",

nomReasonStealablePresent = "$1 有可偷取的法术 $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "没有在任何目标上找到可偷取法术 $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "团队目标$1 有可偷取的法术 $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "小队目标$1 有可偷取的法术 $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 有可净化的法术 $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "没有在任何目标上找到可净化的法术 $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "团队目标$1 有可净化的法术 $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "小队目标$1 有可净化的法术 $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonAoETrigger = "检测到AoE法术 $1", -- $1=AoE spell name
nomReasonAoENoTrigger = "没有检测到AoE法术 $1", -- $1=AoE spell match

nomReasonEnchantMainInvert = "找到主手武器强化效果 $1 计时器倒置", -- $1=Enchant match
nomReasonEnchantMain = "找到主手武器强化效果 $1", -- $1=Enchant match
nomReasonEnchantOffInvert = "找到副手武器强化效果 $1 计时器倒置", -- $1=Enchant match
nomReasonEnchantOff = "找到副手武器强化效果 $1", -- $1=Enchant match
nomReasonNoEnchant = "没有在任何武器上找到强化效果 $1", -- $1=Enchant match

nomReasonNoUseCombo = "你没有使用连击点数",
nomReasonComboMatch = "目前连击点数是 $1 与设置值 $2 相匹配", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "目前连击点数是 $1 与设置值 $2 不匹配", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "没有在动作条上找到此技能",
nomReasonActionReady = "技能可用了",
nomReasonActionNotReadyInvert = "技能不可用(冷却中), 计时器倒置",
nomReasonActionNotReady = "技能不可用(冷却中)",
nomReasonActionlNotEnabled = "技能没有启用",
nomReasonActionNotUsable = "技能不可用",

nomReasonYouAreCasting = "你正在施放法术 $1", -- $1=Casting match
nomReasonYouAreNotCasting = "你没有施放法术 $1", -- $1=Casting match
nomReasonTargetCasting = "目标正在施放法术 $1", -- $1=Casting match
nomReasonFocusCasting = "焦点目标正在施放法术 $1", -- $1=Casting match
nomReasonRaidTargetCasting = "团队目标$1正在施放法术 $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "小队目标$1正在施放法术 $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "没有任何人的目标在施放法术 $1", -- $1=Casting match

nomReasonStance = "当前姿态 $1 与设置值 $2 相匹配", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "当前姿态 $1 与设置值 $2 不匹配", -- $1=Current Stance, $2=Match Stance

ReasonStat =
{
	Health = {MatchReason = "$1 生命值低", NoMatchReason = "$1 生命值不够低"},
	Mana = {MatchReason = "$1 法术值低", NoMatchReason = "$1法术值不够低"},
	RageEnergy = {MatchReason = "$1 能量值低", NoMatchReason = "$1 能量值不够低"},
	Aggro = {MatchReason = "$1 获得仇恨", NoMatchReason = "$1 没有获得仇恨"},
	PvP = {MatchReason = "$1 PVP状态", NoMatchReason = "$1 不在PVP状态"}
}
})
elseif (GetLocale() == "zhTW") then
PowaAuras.Anim[0] = "[無]"
PowaAuras.Anim[1] = "靜止"
PowaAuras.Anim[2] = "閃光效果"
PowaAuras.Anim[3] = "生長效果"
PowaAuras.Anim[4] = "脈搏效果"
PowaAuras.Anim[5] = "氣泡效果"
PowaAuras.Anim[6] = "水滴效果"
PowaAuras.Anim[7] = "漏電效果"
PowaAuras.Anim[8] = "收縮效果"
PowaAuras.Anim[9] = "火焰效果"
PowaAuras.Anim[10] = "盤旋效果"

PowaAuras.BeginAnimDisplay[0] = "[無]"
PowaAuras.BeginAnimDisplay[1] = "由小放大"
PowaAuras.BeginAnimDisplay[2] = "由大漸小"
PowaAuras.BeginAnimDisplay[3] = "逐漸清晰"
PowaAuras.BeginAnimDisplay[4] = "左邊進入"
PowaAuras.BeginAnimDisplay[5] = "左上進入"
PowaAuras.BeginAnimDisplay[6] = "上部進入"
PowaAuras.BeginAnimDisplay[7] = "右上進入"
PowaAuras.BeginAnimDisplay[8] = "右邊進入"
PowaAuras.BeginAnimDisplay[9] = "右下進入"
PowaAuras.BeginAnimDisplay[10] = "下部進入"
PowaAuras.BeginAnimDisplay[11] = "左下進入"
PowaAuras.BeginAnimDisplay[12] = "彈跳進入"

PowaAuras.EndAnimDisplay[0] = "[無]"
PowaAuras.EndAnimDisplay[1] = "放大消失"
PowaAuras.EndAnimDisplay[2] = "縮小消失"
PowaAuras.EndAnimDisplay[3] = "淡化消失"
PowaAuras.EndAnimDisplay[4] = "旋轉漸隱"
PowaAuras.EndAnimDisplay[5] = "旋轉縮小"

PowaAuras.Sound[0] = "[無]"

PowaAuras:MergeTables(PowaAuras.Text,
{
welcome = "輸入 /powa 打開特效編輯器.",

aucune = "無",
aucun = "無",
mainHand = "主手",
offHand = "副手",
bothHands = "雙手",

DebuffType =
{
	Magic = "魔法",
	Disease = "疾病",
	Curse = "詛咒",
	Poison = "中毒",
	Enrage = "Enrage"
},

DebuffCatType =
{
	[PowaAuras.DebuffCatType.CC] = "CC",
	[PowaAuras.DebuffCatType.Silence] = "沈默",
	[PowaAuras.DebuffCatType.Snare] = "誘捕",
	[PowaAuras.DebuffCatType.Stun] = "昏迷",
	[PowaAuras.DebuffCatType.Root] = "無法行動",
	[PowaAuras.DebuffCatType.Disarm] = "繳械",
	[PowaAuras.DebuffCatType.PvE] = "PvE"
},

AuraType =
{
	[PowaAuras.BuffTypes.Buff] = "Buff",
	[PowaAuras.BuffTypes.Debuff] = "Debuff",
	[PowaAuras.BuffTypes.AoE] = "AOE法術",
	[PowaAuras.BuffTypes.TypeDebuff] = "Debuff類型",
	[PowaAuras.BuffTypes.Enchant] = "武器強化",
	[PowaAuras.BuffTypes.Combo] = "連擊點數",
	[PowaAuras.BuffTypes.ActionReady] = "技能冷卻",
	[PowaAuras.BuffTypes.Health] = "生命值",
	[PowaAuras.BuffTypes.Mana] = "魔法值",
	[PowaAuras.BuffTypes.EnergyRagePower] = "怒氣/能量/符文能量",
	[PowaAuras.BuffTypes.Aggro] = "獲得仇恨",
	[PowaAuras.BuffTypes.PvP] = "PvP標誌",
	[PowaAuras.BuffTypes.Stance] = "姿態",
	[PowaAuras.BuffTypes.SpellAlert] = "法術預警",
	[PowaAuras.BuffTypes.SpellCooldown] = "自身技能",
	[PowaAuras.BuffTypes.StealableSpell] = "可偷取法術",
	[PowaAuras.BuffTypes.PurgeableSpell] = "可凈化法術",
	[PowaAuras.BuffTypes.TypeBuff] = "Buff type",
	[PowaAuras.BuffTypes.UnitMatch] = "Unit Match"
},

-- Main
nomEnable = "啟用",
aideEnable = "啟用/禁用所有PowerAuras特效",

nomDebug = "調試模式",
aideDebug = "打開調試模式後,將在聊天窗口顯示特效的觸發條件等信息",
nomTextureCount = "Max Textures",
ListePlayer = "分類",
ListeGlobal = "全局",
aideMove = "移動特效",
aideCopy = "復制特效",
nomRename = "重命名",
aideRename = "重命名我的特效分類名",
nomTest = "測試",
nomHide = "全部隱藏",
nomEdit = "編輯",
nomNew = "新建",
nomDel = "刪除",
nomImport = "導入",
nomExport = "導出",
nomImportSet = "批量導入",
nomExportSet = "批量導出",
aideImport = "把特效字串粘貼(Ctrl+v)在此編輯框內,然後點擊\'接受\'按鈕",
aideExport = "復制(Ctrl+c)此編輯框內的特效字串,與其它人分享你的特效",
aideImportSet = "把批量特效字串粘貼(Ctrl+v)在此編輯框內,然後點擊\'接受\'按鈕,註意:批量導入時將會刪除本頁所有現有特效",
aideExportSet = "復制(Ctrl+c)此編輯框內的特效字串,將此頁內所有特效與其它人分享",
aideDel = "刪除所選特效(必須按住Ctrl鍵才能使用此功能)",
nomMove = "移動",
nomCopy = "復制",
nomPlayerEffects = "我的特效",
nomGlobalEffects = "通用特效",
aideEffectTooltip = "按住Shift鍵點擊圖標以啟用/禁用該特效",

-- Editor
nomSound = "播放聲音",
aideSound = "特效觸發時播放聲音",
nomCustomSound = "自定義聲音文件:",
aideCustomSound = "輸入聲音文件名稱,如cookie.mp3 註意:你需要在遊戲啟動前把聲音文件放入Sounds文件夾下,目前僅支持mp3和wav格式.",

nomTexture = "當前材質",
aideTexture = "顯示特效使用的材質.你可以修改相應文件夾內的.tga 文件來增加特效",

nomAnim1 = "動畫效果",
nomAnim2 = "輔助效果",
aideAnim1 = "是否為所選材質使用動畫效果",
aideAnim2 = "此動畫效果以較低不透明度顯示,為了不過多占用屏幕同一時間只顯示一個輔助效果",

nomDeform = "拉伸",

aideColor = "點擊此處修改材質顏色",
aideFont = "點擊此處來選擇字體,點擊OK按鈕使你的選擇生效",
aideMultiID = "此處輸入其它特效的ID,以執行聯合檢查.多個ID號須用'/'分隔. 特效ID可以在某個特效的鼠標提示中第一行找到,如:[2],2就是此特效ID",
aideTooltipCheck = "此處輸入用於激活特效的某個狀態的鼠標提示文字",

aideBuff = "此處輸入用於激活特效的buff的名字,或名字中的幾個連續文字.如果使用分隔符,也可以輸入多個buff的名字.例如輸入: 能量灌註/奧術能量",
aideBuff2 = "此處輸入用於激活特效的debuff的名字,或名字中的幾個連續文字.如果使用分隔符,也可以輸入多個debuff的名字.例如輸入: 墮落治療/燃燒刺激",
aideBuff3 = "此處輸入用於激活特效的debuff的類型名稱,或名稱中的幾個連續文字.如果使用分隔符,也可以輸入多個debuff類型的名稱.例如輸入: 魔法/詛咒/中毒/疾病",
aideBuff4 = "此處輸入用於激活特效的AOE法術的名字,AOE法術名字可以在戰鬥記錄中找到.例如輸入:邪惡光環/火焰之雨/暴風雪",
aideBuff5 = "此處輸入用於激活特效的武器臨時附魔效果.另外你可以通過前置'main/'或者'off/'來指明主副手位置(例如: main/致殘毒藥,表示檢測主手上的這種毒藥)",
aideBuff6 = "此處輸入用於激活特效的連擊點數.例如輸入: 1或者1/2/3或者0/4/5等等自由組合",
aideBuff7 = "此處輸入用於激活特效的動作條上的動作名,或名字中的幾個連續文字,當此動作完全冷卻時此效果觸發.例如輸入:贊達拉英雄護符/法力之潮圖騰/心靈專註",
aideBuff8 = "此處輸入用於激活特效的法術名稱,或名稱中的一部分,或者是你技能書中的技能,也可以輸入一個技能ID",

aideSpells = "此處輸入用於激活法術預警特效的法術名稱",
aideStacks = "輸入用於激活特效的操作符及疊加數量，只能輸入一個操作符，例如：'<5' '>3' '=11' '!5' '>=0' '<=6' '2-8'",

aideStealableSpells = "此處輸入可偷取的法術名稱(用 * 將檢測所有可被偷取的法術).",
aidePurgeableSpells = "此處輸入可凈化的法術名稱(用 * 將檢測所有可被凈化的法術).",

aideUnitn = "此處輸入用於激活特效的特定成員名稱,必須處於同一團隊",
aideUnitn2 = "僅用於團隊/隊伍模式",

aideMaxTex = "定義特效編輯器使用的材質數量,如果你增加了自定義材質請修改此值.",
aideWowTextures = "使用遊戲內置材質",
aideTextAura = "使用文字做為特效材質(圖形材質將被禁用)",
aideRealaura = "清晰光環",
aideCustomTextures = "使用自定義材質,例如: Flamme.tga(自定義材質需保存在custom文件夾下)",
aideRandomColor = "每次激活時使用隨機顏色",

aideTexMode = "材質透明度反向顯示",

nomActivationBy = "激活條件",

nomOwnTex = "使用技能圖標",
aideOwnTex = "使用buff/debuff或技能的默認圖標做為材質",
nomStacks = "疊加",

nomUpdateSpeed = "更新速度",
nomSpeed = "運動速度",
nomTimerUpdate = "計時器更新速度",
nomBegin = "進場效果",
nomEnd = "結束效果",
nomSymetrie = "對稱性",
nomAlpha = "不透明度",
nomPos = "位置",
nomTaille = "大小",

nomExact = "精確匹配名稱",
nomThreshold = "觸發極限",
aideThreshInv = "選中此項可反轉觸發邏輯. 生命值/法力值: 默認=低於指定值時觸發特效 / 選中此項後=高於指定值時觸發特效. 能量/怒氣/符文能量: 默認=高於指定值時觸發特效 / 選中此項後=低於指定值時觸發特效",
nomThreshInv = "</>",
nomStance = "姿態",

nomMine = "自己施放的",
aideMine = "選中此項則僅檢測由玩家自己施放的buff/debuff",
nomDispellable = "自己可以驅散的",
aideDispellable = "選中此項則僅檢測可被驅散的buff",
nomCanInterrupt = "可打斷",
aideCanInterrupt = "選中此項則僅檢測可被打斷的技能",

nomPlayerSpell = "施法狀態",
aidePlayerSpell = "檢測玩家是否正在詠唱一個法術",

nomCheckTarget = "敵方目標",
nomCheckFriend = "友方目標",
nomCheckParty = "團隊目標",
nomCheckFocus = "焦點目標",
nomCheckRaid = "團隊成員",
nomCheckGroupOrSelf = "團隊/小隊或自己",
nomCheckGroupAny = "任何人",
nomCheckOptunitn = "特定成員",

aideTarget = "此buff/debuff僅存在於敵方目標上",
aideTargetFriend = "此buff/debuff僅存在於友方目標上",
aideParty = "此buff/debuff僅存在於小隊中",
aideGroupOrSelf = "選中此項後將僅對團隊或小隊成員(包括自己)進行檢測",
aideFocus = "此buff/debuff僅存在焦點目標上",
aideRaid = "此buff/debuff僅存在於團隊中",
aideGroupAny = "選中此項後,當任何一個小隊/團隊成員有此buff/debuff就觸發特效. 不選中此項(默認狀態),則檢查到所有人都有此buff/debuff才觸發特效",
aideOptunitn = "此buff/debuff僅存在於團隊/小隊中的特定成員身上",
aideExact = "選中此項將精確匹配buff/debuff名稱",
aideStance = "選擇用於觸發特效的姿態",

aideShowSpinAtBeginning = "起始動畫結束後使其做360度旋轉",
nomCheckShowSpinAtBeginning = "動畫結束後旋轉",

nomCheckShowTimer = "顯示",
nomTimerDuration = "延遲消失",
aideTimerDuration = "目標上的buff/debuff計時器延遲到此時間結束後再消失(0為禁用)",
aideShowTimer = "為此效果顯示計時器",
aideSelectTimer = "選擇使用何種計時器來顯示持續時間",
aideSelectTimerBuff = "選擇使用何種計時器來顯示持續時間(僅用於玩家buff)",
aideSelectTimerDebuff = "選擇使用何種計時器來顯示持續時間(僅用於玩家debuff)",

nomCheckShowStacks = "疊加次數",

nomCheckInverse = "不存在",
aideInverse = "選中此項後,僅當buff/debuff不存在時顯示此特效",

nomCheckIgnoreMaj = "忽略大小寫",
aideIgnoreMaj = "選中此項將忽略buff/debuff名字的大小寫字母(供英文玩家使用,中國玩家不需要修改此項)",

nomDuration = "延遲消失",
aideDuration = "特效延遲到此時間結束後再消失(0為禁用)",

nomCentiemes = "顯示百分位",
nomDual = "顯示兩個計時器",
nomHideLeadingZeros = "隱藏前置零位,如:08秒顯示為8秒",
nomTransparent = "使用透明材質",
nomUpdatePing = "刷新提示",
nomClose = "關閉",
nomEffectEditor = "特效編輯器",
nomAdvOptions = "選項",
nomMaxTex = "最大可用材質",
nomTabAnim = "動畫",
nomTabActiv = "條件",
nomTabSound = "聲音",
nomTabTimer = "計時器",
nomTabStacks = "疊加",
nomWowTextures = "使用內置材質",
nomCustomTextures = "使用自定義材質",
nomTextAura = "文字材質",
nomRealaura = "清晰光環",
nomRandomColor = "隨機顏色",

nomTalentGroup1 = "主天賦",
aideTalentGroup1 = "選中此項後,僅當你處於主天賦狀態下才觸發此特效",
nomTalentGroup2 = "副天賦",
aideTalentGroup2 = "選中此項後,僅當你處於副天賦狀態下才觸發此特效",

nomReset = "重置編輯器位置",
nomPowaShowAuraBrowser = "顯示特效瀏覽器",

nomDefaultTimerTexture = "默認計時器材質",
nomTimerTexture = "計時器材質",
nomDefaultStacksTexture = "默認疊加次數材質",
nomStacksTexture = "疊加次數材質",

Enabled = "已啟用",
Default = "默認",

Ternary =
{
	combat = "戰鬥狀態",
	inRaid = "團隊狀態",
	inParty = "小隊狀態",
	isResting = "休息狀態",
	ismounted = "騎乘狀態",
	inVehicle = "載具狀態",
	isAlive = "存活狀態"
},

nomWhatever = "忽略",
aideTernary = "設置這些狀態將影響特效顯示的方式",

TernaryYes =
{
	combat = "在戰鬥狀態時觸發",
	inRaid = "在團隊狀態時觸發",
	inParty = "在小隊狀態時觸發",
	isResting = "在休息狀態時觸發",
	ismounted = "在騎乘狀態時觸發",
	inVehicle = "在載具狀態時觸發",
	isAlive = "在存活狀態時觸發"
},

TernaryNo =
{
	combat = "非戰鬥狀態時觸發",
	inRaid = "非團隊狀態時觸發",
	inParty = "非小隊狀態時觸發",
	isResting = "非休息狀態時觸發",
	ismounted = "非騎乘狀態時觸發",
	inVehicle = "非載具狀態時觸發",
	isAlive = "在死亡狀態時觸發"
},

TernaryAide =
{
	combat = "此效果受戰鬥狀態影響",
	inRaid = "此效果受團隊狀態影響",
	inParty = "此效果受小隊狀態影響",
	isResting = "此效果受休息狀態影響",
	ismounted = "此效果受騎乘狀態影響",
	inVehicle = "此效果受載具狀態影響",
	isAlive = "此效果受存活狀態影響"
},

nomTimerInvertAura = "超時顛倒材質",
aidePowaTimerInvertAuraSlider = "特效持續時間超過設定值時將材質顛倒(0 為禁用)",
nomTimerHideAura = "隱藏特效",
aidePowaTimerHideAuraSlider = "隱藏特效和計時器,直到持續時間超過設定值(0 為禁用)",

aideTimerRounding = "選中此項時將對計時器取整",
nomTimerRounding = "取整",

aideGTFO = "使用首領技能來匹配AOE法術預警檢測",
nomGTFO = "首領AOE法術",

nomIgnoreUseable = "顯示冷卻中的法術",
aideIgnoreUseable = "忽略可用的法術(僅檢測冷卻中的法術)",

-- Diagnostic reason text, these have substitutions (using $1, $2 etc) to allow for different sententance constructions
nomReasonShouldShow = "應該顯示特效,因為$1",
nomReasonWontShow = "不會顯示特效,因為$1",

nomReasonMulti = "所有匹配特征 $1", --$1=Multiple match ID list

nomReasonDisabled = "Power Auras 被禁用了",
nomReasonGlobalCooldown = "忽略了全局冷卻時間(GCD)",

nomReasonBuffPresent = "$1 獲得了 $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 has Debuff Misery")
nomReasonBuffMissing = "$1 沒有獲得 $2 $3", --$1=Target $2=BuffType, $3=BuffName (e.g. "Unit4 doesn't have Debuff Misery")
nomReasonBuffFoundButIncomplete = "$2 $3 作用在 $1 上,但是\n$4", --$1=Target $2=BuffType, $3=BuffName, $4=IncompleteReason (e.g. "Debuff Sunder Armor found for Target but\nStacks<=2")

nomReasonOneInGroupHasBuff = "$1 獲得了 $2 $3", --$1=GroupId $2=BuffType, $3=BuffName (e.g. "Raid23 has Buff Blessing of Kings")
nomReasonNotAllInGroupHaveBuff = "不是所有 $1 的成員都獲得了 $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "Not all in Raid have Buff Blessing of Kings")
nomReasonAllInGroupHaveBuff = "所有$1 的成員都獲得了 $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "All in Raid have Buff Blessing of Kings")
nomReasonNoOneInGroupHasBuff = "沒有$1 的成員獲得了 $2 $3", --$1=GroupType $2=BuffType, $3=BuffName (e.g. "No one in Raid has Buff Blessing of Kings")

nomReasonBuffPresentTimerInvert = "Buff出現, 計時器倒置",
nomReasonBuffFound = "Buff出現",
nomReasonStacksMismatch = "疊加次數 = $1 但預設值是 $2", --$1=Actual Stack count, $2=Expected Stack logic match (e.g. ">=0")

nomReasonAuraMissing = "特效丟失",
nomReasonAuraOff = "特效被禁用",
nomReasonAuraBad = "特效損壞",

nomReasonNotForTalentSpec = "在此套天賦下特效不會觸發",

nomReasonPlayerDead = "玩家死亡",
nomReasonPlayerAlive = "玩家存活",
nomReasonNoTarget = "沒有目標",
nomReasonTargetPlayer = "目標是你",
nomReasonTargetDead = "目標死亡",
nomReasonTargetAlive = "目標存活",
nomReasonTargetFriendly = "友好的目標",
nomReasonTargetNotFriendly = "敵對的目標",

nomReasonNotInCombat = "不在戰鬥狀態",
nomReasonInCombat = "在戰鬥狀態",

nomReasonInParty = "在小隊中",
nomReasonInRaid = "在團隊中",
nomReasonNotInParty = "不在小隊中",
nomReasonNotInRaid = "不在團隊中",
nomReasonNoFocus = "沒有焦點目標",
nomReasonNoCustomUnit = "找不到你定義的單位:$1,不在隊伍\團隊中,或攜帶寵物",

nomReasonNotMounted = "不在騎乘",
nomReasonMounted = "騎乘狀態",
nomReasonNotInVehicle = "不在載具中",
nomReasonInVehicle = "在載具中",
nomReasonNotResting = "不在休息狀態",
nomReasonResting = "休息狀態",
nomReasonStateOK = "狀態正常",

nomReasonInverted = "$1 (被倒置)", -- $1 is the reason, but the inverted flag is set so the logic is reversed

nomReasonSpellUsable = "法術 $1 可用",
nomReasonSpellNotUsable = "法術 $1 不可用",
nomReasonSpellNotReady = "法術 $1 沒有準備好, 在冷卻中, 計時器倒置",
nomReasonSpellNotEnabled = "法術 $1 沒有啟用",
nomReasonSpellNotFound = "法術 $1 沒有找到",
nomReasonSpellOnCooldown = "Spell $1 on Cooldown",

nomReasonStealablePresent = "$1 有可偷取的法術 $2", --$1=Target $2=SpellName (e.g. "Focus has Stealable spell Blessing of Wisdom")
nomReasonNoStealablePresent = "沒有在任何目標上找到可偷取法術 $1", --$1=SpellName (e.g. "Nobody has Stealable spell Blessing of Wisdom")
nomReasonRaidTargetStealablePresent = "團隊目標$1 有可偷取的法術 $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Stealable spell Blessing of Wisdom")
nomReasonPartyTargetStealablePresent = "小隊目標$1 有可偷取的法術 $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Stealable spell Blessing of Wisdom")

nomReasonPurgeablePresent = "$1 有可凈化的法術 $2", --$1=Target $2=SpellName (e.g. "Focus has Purgeable spell Blessing of Wisdom")
nomReasonNoPurgeablePresent = "沒有在任何目標上找到可凈化的法術 $1", --$1=SpellName (e.g. "Nobody has Purgeable spell Blessing of Wisdom")
nomReasonRaidTargetPurgeablePresent = "團隊目標$1 有可凈化的法術 $2", --$1=RaidId $2=SpellName (e.g. "Raid21Target has Purgeable spell Blessing of Wisdom")
nomReasonPartyTargetPurgeablePresent = "小隊目標$1 有可凈化的法術 $2", --$1=PartyId $2=SpellName (e.g. "Party4Target has Purgeable spell Blessing of Wisdom")

nomReasonAoETrigger = "檢測到AoE法術 $1", -- $1=AoE spell name
nomReasonAoENoTrigger = "沒有檢測到AoE法術 $1", -- $1=AoE spell match

nomReasonEnchantMainInvert = "找到主手武器強化效果 $1 計時器倒置", -- $1=Enchant match
nomReasonEnchantMain = "找到主手武器強化效果 $1", -- $1=Enchant match
nomReasonEnchantOffInvert = "找到副手武器強化效果 $1, 計時器倒置", -- $1=Enchant match
nomReasonEnchantOff = "找到副手武器強化效果 $1", -- $1=Enchant match
nomReasonNoEnchant = "沒有在任何武器上找到強化效果 $1", -- $1=Enchant match

nomReasonNoUseCombo = "你沒有使用連擊點數",
nomReasonComboMatch = "目前連擊點數是 $1 與設置值 $2 相匹配", -- $1=Combo Points, $2=Combo Match
nomReasonNoComboMatch = "目前連擊點數是 $1 與設置值 $2 不匹配", -- $1=Combo Points, $2=Combo Match

nomReasonActionNotFound = "沒有在動作條上找到此技能",
nomReasonActionReady = "技能可用了",
nomReasonActionNotReadyInvert = "技能不可用(冷卻中), 計時器倒置",
nomReasonActionNotReady = "技能不可用(冷卻中)",
nomReasonActionlNotEnabled = "技能沒有啟用",
nomReasonActionNotUsable = "技能不可用",

nomReasonYouAreCasting = "你正在施放法術 $1", -- $1=Casting match
nomReasonYouAreNotCasting = "你沒有施放法術 $1", -- $1=Casting match
nomReasonTargetCasting = "目標正在施放法術 $1", -- $1=Casting match
nomReasonFocusCasting = "焦點目標正在施放法術 $1", -- $1=Casting match
nomReasonRaidTargetCasting = "團隊目標$1 正在施放法術 $2", --$1=RaidId $2=Casting match
nomReasonPartyTargetCasting = "小隊目標$1 正在施放法術 $2", --$1=PartyId $2=Casting match
nomReasonNoCasting = "沒有任何人的目標在施放法術 $1", -- $1=Casting match

nomReasonStance = "當前姿態 $1, 與設置值 $2 相匹配", -- $1=Current Stance, $2=Match Stance
nomReasonNoStance = "當前姿態 $1, 與設置值 $2 不匹配", -- $1=Current Stance, $2=Match Stance

ReasonStat =
{
	Health = {MatchReason = "$1 生命值低", NoMatchReason = "$1 生命值不夠低"},
	Mana = {MatchReason = "$1 法術值低", NoMatchReason = "$1法術值不夠低"},
	RageEnergy = {MatchReason = "$1 能量值低", NoMatchReason = "$1 能量值不夠低"},
	Aggro = {MatchReason = "$1 獲得仇恨", NoMatchReason = "$1 沒有獲得仇恨"},
	PvP = {MatchReason = "$1 PVP狀態", NoMatchReason = "$1 不在PVP狀態"}
}
})
end