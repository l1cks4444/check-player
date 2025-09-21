RegisterCommand("check", function(source, args, RawCommand)
    local group = GetPlayerGroup(source)
    if not group == "admin" or group == "superadmin" or group == "mod" then
        print("you need to be admin group")
        return
    end
    if args[1]  == nil then
        print("/check [playerID]")
        return
    end
    if args[1] == source then
        print("cant check yourself")
        return
    end
    local targetId = tonumber(args[1])
    if args[1] then
        TriggerServerEvent("delta_check:checkPlayer", targetId)
        print("checking player ID: " .. targetId)
        print("Done. check discord log!")
    else
        print("Invalid player id.")
    end
    
end, true)



RegisterCommand('jojonas', function()
    TriggerServerEvent('delta_check:Testsent')
end, false)
