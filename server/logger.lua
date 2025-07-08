-- ServePass Logging System

Logger = {}
Logger.levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4
}


function Logger.init()
    if not Config.EnableLogging then
        return
    end
    
    Logger.currentLevel = Logger.levels[Config.LogLevel] or Logger.levels.INFO
    Logger.logFile = Config.LogFile or "servepass.log"
    

    Logger.info("ServePass Logger initialized - Level: " .. Config.LogLevel)
end


function Logger.writeToFile(level, message)
    if not Config.EnableLogging then
        return
    end
    
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logEntry = string.format("[%s] [%s] %s\n", timestamp, level, message)
    

    print("[ServePass] " .. logEntry:gsub("\n", ""))
    

end


function Logger.debug(message, ...)
    if Logger.currentLevel <= Logger.levels.DEBUG then
        local formattedMessage = string.format(message, ...)
        Logger.writeToFile("DEBUG", formattedMessage)
    end
end


function Logger.info(message, ...)
    if Logger.currentLevel <= Logger.levels.INFO then
        local formattedMessage = string.format(message, ...)
        Logger.writeToFile("INFO", formattedMessage)
    end
end

-- Log warning messages
function Logger.warn(message, ...)
    if Logger.currentLevel <= Logger.levels.WARN then
        local formattedMessage = string.format(message, ...)
        Logger.writeToFile("WARN", formattedMessage)
    end
end

-- Log error messages
function Logger.error(message, ...)
    if Logger.currentLevel <= Logger.levels.ERROR then
        local formattedMessage = string.format(message, ...)
        Logger.writeToFile("ERROR", formattedMessage)
    end
end

-- Log authentication events
function Logger.logAuth(playerId, playerName, identifier, success, attempts, ip)
    local status = success and "SUCCESS" or "FAILED"
    local message = string.format(
        "Authentication %s - Player: %s [%s] (ID: %s) - Attempts: %s - IP: %s",
        status, playerName, identifier, playerId, attempts or "N/A", ip or "Unknown"
    )
    
    if success then
        Logger.info(message)
    else
        Logger.warn(message)
    end
end

-- Log security events
function Logger.logSecurity(event, playerId, playerName, identifier, details)
    local message = string.format(
        "Security Event: %s - Player: %s [%s] (ID: %s) - Details: %s",
        event, playerName or "Unknown", identifier or "Unknown", playerId or "Unknown", details or "None"
    )
    Logger.warn(message)
end

-- Log system events
function Logger.logSystem(event, details)
    local message = string.format("System Event: %s - Details: %s", event, details or "None")
    Logger.info(message)
end

return Logger