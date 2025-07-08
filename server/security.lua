-- ServePass Security Manager

Security = {}
Security.rateLimitData = {} -- Store rate limit data per IP
Security.playerAttempts = {} -- Store attempts per player


function Security.init()
    Logger.info("Security Manager initialized")
    

    if Config.EnableRateLimit then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(Config.CleanupInterval * 1000)
                Security.cleanupRateLimitData()
            end
        end)
    end
end


function Security.getPlayerIP(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in pairs(identifiers) do
        if string.match(identifier, "ip:") then
            return string.gsub(identifier, "ip:", "")
        end
    end
    return "unknown"
end


function Security.isWhitelisted(source)
    if not Config.EnableWhitelist then
        return true
    end
    
    local identifiers = GetPlayerIdentifiers(source)
    
    for _, identifier in pairs(identifiers) do
        for _, whitelisted in pairs(Config.WhitelistedIdentifiers) do
            if identifier == whitelisted then
                Logger.debug("Player %s is whitelisted with identifier: %s", GetPlayerName(source), identifier)
                return true
            end
        end
    end
    
    Logger.warn("Player %s is not whitelisted", GetPlayerName(source))
    return false
end

-- Check if player is admin
function Security.isAdmin(source)
    -- This would typically integrate with your permission system
    -- For now, we'll use a simple identifier check
    local identifiers = GetPlayerIdentifiers(source)
    
    for _, identifier in pairs(identifiers) do
        -- Check if player has admin group (this would need integration with your permission system)
        -- For demonstration, we'll check for specific Steam IDs
        if string.match(identifier, "steam:") then
            -- In a real implementation, you'd check against your admin database
            Logger.debug("Checking admin status for identifier: %s", identifier)
        end
    end
    
    return false -- Default to false for security
end

-- Check rate limiting
function Security.checkRateLimit(source)
    if not Config.EnableRateLimit then
        return true
    end
    
    local ip = Security.getPlayerIP(source)
    local currentTime = os.time()
    
    -- Initialize IP data if not exists
    if not Security.rateLimitData[ip] then
        Security.rateLimitData[ip] = {
            attempts = 0,
            windowStart = currentTime
        }
    end
    
    local ipData = Security.rateLimitData[ip]
    
    -- Check if we're in a new window
    if currentTime - ipData.windowStart >= Config.RateLimitWindow then
        ipData.attempts = 0
        ipData.windowStart = currentTime
    end
    
    -- Check if rate limit exceeded
    if ipData.attempts >= Config.MaxAttemptsPerWindow then
        Logger.logSecurity("RATE_LIMIT_EXCEEDED", source, GetPlayerName(source), GetPlayerIdentifiers(source)[1], 
            string.format("IP: %s, Attempts: %d", ip, ipData.attempts))
        return false
    end
    
    return true
end

-- Record authentication attempt
function Security.recordAttempt(source, success)
    local ip = Security.getPlayerIP(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    
    -- Record rate limit attempt
    if Config.EnableRateLimit and Security.rateLimitData[ip] then
        Security.rateLimitData[ip].attempts = Security.rateLimitData[ip].attempts + 1
    end
    
    -- Record player attempts
    if not Security.playerAttempts[identifier] then
        Security.playerAttempts[identifier] = {
            attempts = 0,
            lastAttempt = os.time()
        }
    end
    
    local playerData = Security.playerAttempts[identifier]
    playerData.attempts = playerData.attempts + 1
    playerData.lastAttempt = os.time()
    
    -- Log the attempt
    Logger.logAuth(source, GetPlayerName(source), identifier, success, playerData.attempts, ip)
    
    return playerData.attempts
end

-- Check if player has exceeded max attempts
function Security.hasExceededMaxAttempts(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    
    if Security.playerAttempts[identifier] then
        return Security.playerAttempts[identifier].attempts >= Config.MaxAttempts
    end
    
    return false
end

-- Reset player attempts
function Security.resetPlayerAttempts(source)
    local identifier = GetPlayerIdentifiers(source)[1]
    Security.playerAttempts[identifier] = nil
    Logger.debug("Reset attempts for player: %s", GetPlayerName(source))
end

-- Clean up old rate limit data
function Security.cleanupRateLimitData()
    local currentTime = os.time()
    local cleaned = 0
    
    for ip, data in pairs(Security.rateLimitData) do
        if currentTime - data.windowStart >= Config.RateLimitWindow * 2 then
            Security.rateLimitData[ip] = nil
            cleaned = cleaned + 1
        end
    end
    
    if cleaned > 0 then
        Logger.debug("Cleaned up %d old rate limit entries", cleaned)
    end
end

-- Validate password strength (for admin commands)
function Security.validatePassword(password)
    if not password or password == "" then
        return false, "Password cannot be empty"
    end
    
    if string.len(password) < 6 then
        return false, "Password must be at least 6 characters long"
    end
    
    -- Add more validation rules as needed
    return true, "Password is valid"
end

-- Generate secure session token (for future use)
function Security.generateSessionToken()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local token = ""
    
    for i = 1, 32 do
        local rand = math.random(1, #chars)
        token = token .. string.sub(chars, rand, rand)
    end
    
    return token
end

return Security