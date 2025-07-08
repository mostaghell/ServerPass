-- FiveM Post-Spawn Password Handler with Web UI

local isUIOpen = false
local isAuthenticated = false


function showPasswordPrompt()
    if isUIOpen then return end
    
    isUIOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = 'showPasswordPrompt'
    })
end


function hidePasswordPrompt()
    if not isUIOpen then return end
    
    isUIOpen = false
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'hidePasswordPrompt'
    })
end


RegisterNUICallback('submitPassword', function(data, cb)
    local password = data.password
    
    if password and password ~= "" then

        TriggerServerEvent('servepass:submitPassword', password)
    end
    
    cb('ok')
end)


RegisterNUICallback('cancelConnection', function(data, cb)

    hidePasswordPrompt()
    cb('ok')
end)


RegisterNetEvent('servepass:showPasswordPrompt')
AddEventHandler('servepass:showPasswordPrompt', function()
    if not isAuthenticated then
        showPasswordPrompt()
    end
end)

-- Event handlers for server responses
RegisterNetEvent('servepass:passwordCorrect')
AddEventHandler('servepass:passwordCorrect', function()
    isAuthenticated = true
    hidePasswordPrompt()
    
    -- Re-enable player controls
    SetPlayerControl(PlayerId(), true, 0)
    
    -- Show success notification
    SendNUIMessage({
        type = 'passwordCorrect'
    })
    
    -- Show success message
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Authentication successful! Welcome to the server.")
    DrawNotification(false, false)
end)

RegisterNetEvent('servepass:passwordIncorrect')
AddEventHandler('servepass:passwordIncorrect', function()
    SendNUIMessage({
        type = 'passwordIncorrect',
        message = 'Incorrect password. Please try again.'
    })
    
    -- Show error message
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~r~Incorrect password! Try again.")
    DrawNotification(false, false)
end)

-- Prevent certain actions while not authenticated
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if not isAuthenticated then
            -- Disable player controls
            SetPlayerControl(PlayerId(), false, 0)
            
            -- Disable weapon wheel
            DisableControlAction(0, 37, true)
            
            -- Disable phone
            DisableControlAction(0, 288, true)
            
            -- Disable vehicle entry
            DisableControlAction(0, 23, true)
            
            -- Disable interaction with NPCs/objects
            DisableControlAction(0, 38, true)
            
            -- Disable map
            DisableControlAction(0, 199, true)
            
            -- Disable pause menu
            DisableControlAction(0, 200, true)
        else
            break
        end
    end
end)

print("[ServePass] Post-spawn password handler with NUI loaded")