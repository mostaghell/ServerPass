-- ServePass - FiveM Server Password Protection System
local resourceName = GetCurrentResourceName()
local authenticatedPlayers = {}
local playerSessions = {} -- Store session data

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    Logger.init()
    Security.init()
    Logger.logSystem("STARTUP", "ServePass system initialized successfully")
end)


AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = identifiers[1]
    

    if not identifier then
        Logger.error("Failed to get identifier for connecting player: %s", name)
        setKickReason("Authentication system error. Please try again.")
        CancelEvent()
        return
    end
    

    if Config.EnableWhitelist and not Security.isWhitelisted(source) then
        Logger.logSecurity("WHITELIST_DENIED", source, name, identifier, "Player not on whitelist")
        setKickReason("You are not whitelisted on this server.")
        CancelEvent()
        return
    end
    

    if Security.isAdmin(source) then
        authenticatedPlayers[identifier] = true
        Logger.logAuth(source, name, identifier, true, 0, Security.getPlayerIP(source))
        Logger.info("Admin player %s bypassed authentication", name)
        return
    end
    

    playerSessions[identifier] = {
        name = name,
        source = source,
        connectTime = os.time(),
        attempts = 0,
        authenticated = false
    }
    

    authenticatedPlayers[identifier] = false
    
    Logger.info("Player %s [%s] connecting, will require authentication after spawn", name, identifier)
end)


AddEventHandler('playerSpawned', function()
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]
    

    if not authenticatedPlayers[identifier] then
        TriggerClientEvent('servepass:showPasswordPrompt', source)
    end
end)


RegisterServerEvent('servepass:submitPassword')
AddEventHandler('servepass:submitPassword', function(password)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = identifiers[1]
    local playerName = GetPlayerName(source)
    

    if not password or password == "" then
        Logger.warn("Player %s submitted empty password", playerName)
        TriggerClientEvent('servepass:passwordIncorrect', source)
        return
    end
    

    if not playerSessions[identifier] then
        Logger.error("Password submission from unknown player: %s [%s]", playerName, identifier)
        return
    end
    

    if not Security.checkRateLimit(source) then
        DropPlayer(source, "Too many authentication attempts. Please try again later.")
        return
    end
    
    -- Record the attempt
    local attempts = Security.recordAttempt(source, false) -- Will be updated if successful
    
    -- Check if max attempts exceeded
    if Security.hasExceededMaxAttempts(source) then
        Logger.logSecurity("MAX_ATTEMPTS_EXCEEDED", source, playerName, identifier, 
            string.format("Attempts: %d", attempts))
        
        if Config.KickOnMaxAttempts then
            DropPlayer(source, Config.ChatMessages.maxAttempts)
        end
        return
    end
    
    -- Validate password
    if password == Config.Password then
        -- Success
        authenticatedPlayers[identifier] = true
        playerSessions[identifier].authenticated = true
        playerSessions[identifier].authTime = os.time()
        
        -- Reset attempts on success
        Security.resetPlayerAttempts(source)
        
        -- Record successful attempt
        Security.recordAttempt(source, true)
        
        TriggerClientEvent('servepass:passwordCorrect', source)
        Logger.info("Player %s authenticated successfully after %d attempts", playerName, attempts)
    else
        -- Failure
        TriggerClientEvent('servepass:passwordIncorrect', source)
        Logger.warn("Player %s entered incorrect password (Attempt %d/%d)", playerName, attempts, Config.MaxAttempts)
    end
end)

-- Event handler for when a player spawns
AddEventHandler('playerSpawned', function()
    local source = source
    local identifier = GetPlayerIdentifiers(source)[1]
    
    -- If player is not authenticated, show password prompt
    if not authenticatedPlayers[identifier] then
        TriggerClientEvent('servepass:showPasswordPrompt', source)
    end
end)



-- Event handler for player disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = identifiers and identifiers[1]
    local playerName = GetPlayerName(source)
    
    if not identifier then
        Logger.warn("Player disconnected without valid identifier: %s", playerName or "Unknown")
        return
    end
    
    -- Log disconnect
    local wasAuthenticated = authenticatedPlayers[identifier] or false
    Logger.info("Player %s [%s] disconnected - Reason: %s - Was Authenticated: %s", 
        playerName, identifier, reason, tostring(wasAuthenticated))
    
    -- Clean up player data
    authenticatedPlayers[identifier] = nil
    playerSessions[identifier] = nil
    Security.resetPlayerAttempts(source)
    
    Logger.debug("Cleaned up data for disconnected player: %s", playerName)
end)

-- Admin Commands

-- Command to kick unauthenticated players (console only)
RegisterCommand('servepass:kickunauthenticated', function(source, args, rawCommand)
    if source == 0 then -- Console command only
        local kicked = 0
        for playerId = 1, GetNumPlayerIndices() do
            local player = GetPlayerFromIndex(playerId - 1)
            if player and player ~= -1 then
                local identifier = GetPlayerIdentifiers(player)[1]
                if identifier and not authenticatedPlayers[identifier] then
                    DropPlayer(player, "Authentication required")
                    kicked = kicked + 1
                end
            end
        end
        Logger.logSystem("ADMIN_COMMAND", string.format("Kicked %d unauthenticated players", kicked))
        print(string.format("[ServePass] Kicked %d unauthenticated players", kicked))
    else
        print("This command can only be executed from the server console.")
    end
end, true)

-- Command to change password (console only)
RegisterCommand('servepass:changepassword', function(source, args, rawCommand)
    if source == 0 then -- Console command only
        local newPassword = args[1]
        if not newPassword or newPassword == "" then
            print("Usage: servepass:changepassword <new_password>")
            return
        end
        
        local isValid, message = Security.validatePassword(newPassword)
        if not isValid then
            print("Invalid password: " .. message)
            return
        end
        
        Config.Password = newPassword
        Logger.logSystem("PASSWORD_CHANGED", "Server password changed by console")
        print("[ServePass] Password changed successfully")
    else
        print("This command can only be executed from the server console.")
    end
end, true)

-- Command to show authentication status
RegisterCommand('servepass:status', function(source, args, rawCommand)
    if source == 0 then -- Console command only
        local total = 0
        local authenticated = 0
        
        for playerId = 1, GetNumPlayerIndices() do
            local player = GetPlayerFromIndex(playerId - 1)
            if player and player ~= -1 then
                total = total + 1
                local identifier = GetPlayerIdentifiers(player)[1]
                if identifier and authenticatedPlayers[identifier] then
                    authenticated = authenticated + 1
                end
            end
        end
        
        print(string.format("[ServePass] Players: %d total, %d authenticated, %d pending", 
            total, authenticated, total - authenticated))
    else
        print("This command can only be executed from the server console.")
    end
end, true)

-- Prevent unauthenticated players from using certain features
AddEventHandler('chatMessage', function(source, name, message)
    local identifiers = GetPlayerIdentifiers(source)
    local identifier = identifiers and identifiers[1]
    
    if not identifier then
        Logger.warn("Chat message from player without identifier: %s", name)
        CancelEvent()
        return
    end
    
    if not authenticatedPlayers[identifier] then
        CancelEvent()
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"System", Config.ChatMessages.authRequired}
        })
        
        Logger.debug("Blocked chat message from unauthenticated player: %s", name)
    end
end)

-- Cleanup thread for old session data
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.CleanupInterval * 1000)
        
        local currentTime = os.time()
        local cleaned = 0
        
        for identifier, session in pairs(playerSessions) do
            -- Clean up sessions older than 1 hour for disconnected players
            if not authenticatedPlayers[identifier] and 
               (currentTime - session.connectTime) > 3600 then
                playerSessions[identifier] = nil
                cleaned = cleaned + 1
            end
        end
        
        if cleaned > 0 then
            Logger.debug("Cleaned up %d old player sessions", cleaned)
        end
    end
end)

Logger.logSystem("INITIALIZATION", "ServePass server password protection system loaded successfully")