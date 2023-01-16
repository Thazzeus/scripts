-- Prints the sum of all citizens' needs.

local fort_needs = {}
for _, unit in pairs(df.global.world.units.all) do
    if not dfhack.units.isCitizen(unit) or not dfhack.units.isAlive(unit) then
        goto skipunit
    end

    local mind = unit.status.current_soul.personality.needs
    -- sum need_level and focus_level for each need
    for _,need in pairs(mind) do
        if fort_needs[need.id] then
            fort_needs[need.id].cummulitative_need = fort_needs[need.id].cummulitative_need + need.need_level
            fort_needs[need.id].cummulitative_focus = fort_needs[need.id].cummulitative_focus + need.focus_level
            fort_needs[need.id].citizen_count = fort_needs[need.id].citizen_count + 1
        else
            fort_needs[need.id] = {}
            fort_needs[need.id].cummulitative_need = need.need_level
            fort_needs[need.id].cummulitative_focus = need.focus_level
            fort_needs[need.id].citizen_count = 1
        end
    end

    :: skipunit ::
end

local sorted_fort_needs = {}
for id, need in pairs(fort_needs) do
    table.insert(sorted_fort_needs, {
        df.need_type[id],
        need.cummulitative_need,
        need.cummulitative_focus,
        need.citizen_count
    })
end

table.sort(sorted_fort_needs, function(a, b)
    return a[2] > b[2]
end)

-- Print sorted output
print(([[%20s %8s %8s %10s]]):format("Need", "Weight", "Focus", "# Dwarves"))
for _, need in pairs(sorted_fort_needs) do
    print(([[%20s %8.f %8.f %10d]]):format(need[1], need[2], need[3], need[4]))
end
