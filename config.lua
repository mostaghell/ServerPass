-- ServePass Configuration File

Config = {}

-- Security Settings
Config.Password = "ChangeMe123!" -- IMPORTANT: Change this to your desired server password
Config.MaxAttempts = 3 -- Maximum password attempts before kick
Config.AttemptTimeout = 60 -- Timeout in seconds for password entry
Config.KickOnMaxAttempts = true -- Kick player after max attempts

-- Logging Settings
Config.EnableLogging = true -- Enable detailed logging
Config.LogFile = "servepass.log" -- Log file name (in server data folder)
Config.LogLevel = "INFO" -- LOG LEVELS: DEBUG, INFO, WARN, ERROR

-- Security Features
Config.EnableRateLimit = true -- Enable rate limiting for password attempts
Config.RateLimitWindow = 300 -- Rate limit window in seconds (5 minutes)
Config.MaxAttemptsPerWindow = 5 -- Max attempts per IP in the window

-- Admin Settings
Config.AdminGroups = { -- Groups that can bypass authentication
    "admin",
    "moderator",
    "owner"
}

-- Whitelist Settings
Config.EnableWhitelist = false -- Enable whitelist mode
Config.WhitelistedIdentifiers = { -- Steam IDs, Discord IDs, etc.
    -- "steam:110000100000000",
    -- "discord:123456789012345678"
}

-- UI Settings
Config.UISettings = {
    title = "Server Authentication",
    subtitle = "Please enter the server password to continue",
    placeholder = "Enter password...",
    submitText = "Submit",
    cancelText = "Cancel"
}

-- Chat Settings
Config.ChatMessages = {
    authRequired = "You must authenticate before using chat!",
    authSuccess = "Authentication successful! Welcome to the server.",
    authFailed = "Incorrect password! Try again.",
    maxAttempts = "Maximum attempts reached. You have been kicked.",
    timeout = "Authentication timeout. You have been kicked."
}

-- Performance Settings
Config.CleanupInterval = 300 -- Cleanup disconnected players every 5 minutes
Config.SaveAuthState = false -- Save authentication state to database (requires database)

-- Development Settings
Config.DebugMode = false -- Enable debug mode for development
Config.BypassInDev = false -- Bypass authentication in development mode