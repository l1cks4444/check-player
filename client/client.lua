RegisterCommand("check", function(source, args, RawCommand)
    local group = GetPlayerGroup(source)
    if not group == "admin" or group == "superadmin" or group == "mod" then
        print("keine rechte brudi")
        return
    end
    if args[1]  == nil then
        print("Usage: /check [playerID]")
        return
    end
    if args[1] == source then
        print("You cannot check yourself.")
        return
    end
    local targetId = tonumber(args[1])
    if args[1] then
        TriggerServerEvent("delta_check:checkPlayer", targetId)
        print("Checking player ID: " .. targetId)
        print("Done. Check Discord Log!")
    else
        print("Invalid player ID.")
    end
    
end, true)



RegisterCommand('jojonas', function()
    TriggerServerEvent('delta_check:Testsent')
end, false)
