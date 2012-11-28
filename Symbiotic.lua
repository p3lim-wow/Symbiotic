if(select(2, UnitClass('player')) ~= 'DRUID') then return end

local grantSpells = {
	[62] = 113074, -- MAGE Arcane
	[63] = 113074, -- MAGE Fire
	[64] = 113074, -- MAGE Frost
	[65] = 113269, -- PALADIN Holy
	[66] = 113075, -- PALADIN Protection
	[70] = 122287, -- PALADIN Retribution
	[71] = 122294, -- WARRIOR Arms
	[72] = 122294, -- WARRIOR Fury
	[73] = 122286, -- WARRIOR Protection
	[250] = 113072, -- DEATHKNIGHT Blood
	[251] = 113516, -- DEATHKNIGHT Frost
	[252] = 113516, -- DEATHKNIGHT Unholy
	[253] = 113073, -- HUNTER Beast Mastery
	[254] = 113073, -- HUNTER Marksmanship
	[255] = 113073, -- HUNTER Survival
	[256] = 113506, -- PRIEST Discipline
	[257] = 113506, -- PRIEST Holy
	[258] = 113277, -- PRIEST Shadow 
	[259] = 113613, -- ROGUE Assassination
	[260] = 113613, -- ROGUE Combat
	[261] = 113613, -- ROGUE Subtlety
	[262] = 113286, -- SHAMAN Elemental
	[263] = 113286, -- SHAMAN Enhancement
	[264] = 113289, -- SHAMAN Restoration
	[265] = 113295, -- WARLOCK Affliction
	[266] = 113295, -- WARLOCK Demonology
	[267] = 113295, -- WARLOCK Destruction
	[268] = 113306, -- MONK Brewmaster
	[269] = 127361, -- MONK Windwalker
	[270] = 113275, -- MONK Mistweaver
}

local gainSpells = {
	{122292, 112997, 113002, 113004}, -- Warrior
	{110698, 110700, 110701, 122288}, -- Paladin
	{110588, 110597, 110600, 110617}, -- Hunter
	{110788, 110730, 122289, 110791}, -- Rogue
	{110707, 110715, 110717, 110718}, -- Priest
	{110570, 122282, 122285, 110575}, -- Death Knight
	{110802, 110807, 110803, 110806}, -- Shaman
	{110621, 110693, 110694, 110696}, -- Mage
	{122291, 110810, 122290, 112970}, -- Warlock
	{126458, 126449, 126453, 126456}, -- Monk
}

local function UpdateSymbiosis(self)
	local _, unit = self:GetUnit()
	if(unit) then
		if(IsShiftKeyDown()) then
			local _, _, class = UnitClass(unit)
			if(UnitIsPlayer(unit) and class ~= 11) then
				local spec = GetSpecialization()
				if(spec) then
					ShoppingTooltip1:SetOwner(self, 'ANCHOR_NONE')
					ShoppingTooltip1:SetPoint('BOTTOMRIGHT', self, 'BOTTOMLEFT')
					ShoppingTooltip1:SetSpellByID(gainSpells[class][spec])

					ShoppingTooltip1TextRight1:SetText('Symbiosis')
					ShoppingTooltip1TextRight1:SetTextColor(0, 1, 0)
					ShoppingTooltip1TextRight1:Show()

					for index = 1, ShoppingTooltip1:NumLines() do
						_G['ShoppingTooltip1TextLeft' .. index]:SetJustifyH('LEFT')
					end

					if(CanInspect(unit)) then
						NotifyInspect(unit)
					end

					ShoppingTooltip1:Show()
				end
			end
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
		end
	end
end

GameTooltip:HookScript('OnTooltipSetUnit', UpdateSymbiosis)

local Handler = CreateFrame('Frame')
Handler:RegisterEvent('MODIFIER_STATE_CHANGED')
Handler:RegisterEvent('INSPECT_READY')
Handler:SetScript('OnEvent', function(self, event, GUID)
	local tooltip = GameTooltip
	if(not tooltip:IsShown()) then return end

	local _, unit = tooltip:GetUnit()
	if(not unit) then return end

	if(event == 'INSPECT_READY' and UnitGUID(unit) == GUID) then
		local id = GetInspectSpecialization(unit)
		if(id and id ~= 0 and grantSpells[id] and ShoppingTooltip1:IsShown()) then
			ShoppingTooltip2:SetOwner(ShoppingTooltip1, 'ANCHOR_NONE')
			ShoppingTooltip2:SetPoint('BOTTOMRIGHT', ShoppingTooltip1, 'BOTTOMLEFT')
			ShoppingTooltip2:SetSpellByID(grantSpells[id])

			local _, spec, _, _, _, _, class = GetSpecializationInfoByID(id)
			local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) [class]
			ShoppingTooltip2TextRight1:SetText(spec)
			ShoppingTooltip2TextRight1:SetTextColor(color.r, color.g, color.b)
			ShoppingTooltip2TextRight1:Show()

			for index = 1, ShoppingTooltip2:NumLines() do
				_G['ShoppingTooltip2TextLeft' .. index]:SetJustifyH('LEFT')
			end

			ShoppingTooltip2:Show()
		end
	elseif(event == 'MODIFIER_STATE_CHANGED') then
		UpdateSymbiosis(tooltip)
	end
end)
