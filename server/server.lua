ESX = exports["es_extended"]:getSharedObject()


table.merge = function(t1, t2)
    local t = t1
    for i, v in next, (t2) do
        table.insert(t, v)
    end
    return t
end

GetAllIdentifiers = function(player)
    local all = table.merge(GetPlayerIdentifiers(player), GetPlayerTokens(player))
    local allowedTypes = { "steam:", "license:", "xbl:", "live:", "discord:", "fivem:" }
    local filtered = {}
    local discordId = nil
    for _, id in ipairs(all) do
        if string.sub(id, 1, 8) == "discord:" then
            discordId = string.sub(id, 9)
        else
            for _, prefix in ipairs(allowedTypes) do
                if string.sub(id, 1, #prefix) == prefix and prefix ~= "discord:" then
                    table.insert(filtered, id)
                    break
                end
            end
        end
    end
    return filtered, discordId
end




RegisterNetEvent('delta_check:checkPlayer')
AddEventHandler('delta_check:checkPlayer', function(targetId)
    local s = targetId
    local playerName = GetPlayerName(targetId)
    local playerPed = GetPlayerPed(targetId)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHealth = GetEntityHealth(playerPed)
    local playerArmor = GetPedArmour(playerPed)
    local identifiers, discordId = GetAllIdentifiers(s)
    local ping = GetPlayerPing(targetId)
    print("before db")
    MySQL.Async.fetchAll("SELECT * FROM `users` WHERE `identifier` = @identifier", {
        ['@identifier'] = ESX.GetIdentifier(targetId)
    }, function(result)
        for k, v in ipairs(result) do
            print("database")
            local data = result[1]
            local accounts = json.decode(v.accounts)
            local inventory = json.decode(v.inventory or "[]")

            local fields = {
                { name = "Player ID", value = tostring(targetId), inline = true },
                { name = "Name", value = playerName, inline = true },
                { name = "Health", value = tostring(playerHealth), inline = true },
                { name = "Armor", value = tostring(playerArmor), inline = true },
                { name = "Ping", value = tostring(ping), inline = true },
                { name = "Inventar", value = json.encode(inventory), inline = false },
                { name = "Coords", value = string.format("X=%.2f, Y=%.2f, Z=%.2f", playerCoords.x, playerCoords.y, playerCoords.z), inline = false },
                { name = "Cash", value = tostring(accounts.money), inline = true },
                { name = "Bank", value = tostring(accounts.bank), inline = true },
                { name = "Black Money", value = tostring(accounts.black_money), inline = true },
                { name = "Job", value = ESX.GetJobs()[data.job].label, inline = false },
                { name = "Job Rang", value = ESX.GetJobs()[data.job].grades[tostring(data.job_grade)].label, inline = true },
                { name = "Idents", value = table.concat(identifiers, ", "), inline = false },
            }
            if discordId then
                table.insert(fields, 1, { name = "Discord", value = "<@" .. discordId .. ">", inline = true })
            end

            local embed = {
                title = "Player Check - " .. playerName .. " (ID: " .. targetId .. ")",
                color = 16711680,
                fields = fields,
                footer = {
                    text = "Player Check - " .. os.date("%d.%m.%Y %H:%M"),
                }
            }
            print("after embed")
            local webhookUrl = "https://discord.com/api/webhooks/1342195138843115562/njIGLjw2_SpSF3u_tidFokWyAxGN2Cxwfem2j8U_zs4EkA4T17RHw7mfuPxRrCXASlqD"
            PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
                username = "Player Check Bot",
                embeds = {embed}
            }), { ['Content-Type'] = 'application/json' })
        end
    end)
end)



local sendToDiscord = function(title, message)
    local webhookUrl = "https://discord.com/api/webhooks/1342195138843115562/njIGLjw2_SpSF3u_tidFokWyAxGN2Cxwfem2j8U_zs4EkA4T17RHw7mfuPxRrCXASlqD"
    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = "Player Check Bot",
        embeds = {{
            title = title,
            description = message,
            color = 16711680
        }}
    }), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('delta_check:Testsent')
AddEventHandler('delta_check:Testsent', function()
    local embed = "was geht yallah"
    sendToDiscord("AA", embed)
end)
