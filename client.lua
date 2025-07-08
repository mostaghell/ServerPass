-- FiveM Client Password Protection Script

local isAuthenticated = false
local isPromptActive = false


local function showPasswordPrompt()
    if isPromptActive then return end
    
    isPromptActive = true
    

    SetPlayerControl(PlayerId(), false, 0)
    

    Citizen.CreateThread(function()
        while isPromptActive do
            Citizen.Wait(0)
            

            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 200)
            

            SetTextFont(4)
            SetTextProportional(1)
            SetTextScale(0.8, 0.8)
            SetTextColour(255, 255, 255, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("SERVER PASSWORD REQUIRED")
            DrawText(0.5 - 0.15, 0.3)
            

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 255, 255, 255)
            SetTextDropShadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString("Press ENTER to open password input")
            DrawText(0.5 - 0.12, 0.4)
            

            SetTextEntry("STRING")
            AddTextComponentString("ESC to disconnect from server")
            DrawText(0.5 - 0.1, 0.6)
            

            if IsControlJustPressed(0, 18) then -- ENTER key
                local password = getPasswordInput()
                if password and password ~= "" then
                    TriggerServerEvent('servepass:submitPassword', password)
                end
            end
            
            if IsControlJustPressed(0, 322) then -- ESC key
                TriggerServerEvent('servepass:disconnect')
            end
        end
    end)
end


function getPasswordInput()
    AddTextEntry('FMMC_KEY_TIP1', 'Enter Server Password:')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 64)
    
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    
    if UpdateOnscreenKeyboard() ~= 2 then
        local password = GetOnscreenKeyboardResult()
        return password
    else
        return nil
    end
end


RegisterNetEvent('servepass:showPasswordPrompt')
AddEventHandler('servepass:showPasswordPrompt', function()
    if not isAuthenticated then
        showPasswordPrompt()
    end
end)


RegisterNetEvent('servepass:passwordCorrect')
AddEventHandler('servepass:passwordCorrect', function()
    isAuthenticated = true
    isPromptActive = false
    
    -- Re-enable player controls
    SetPlayerControl(PlayerId(), true, 0)
    
    -- Show success message
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~g~Authentication successful! Welcome to the server.")
    DrawNotification(false, false)
    
    -- Clear any UI elements
    ClearPrints()
end)


RegisterNetEvent('servepass:passwordIncorrect')
AddEventHandler('servepass:passwordIncorrect', function()
    -- Show error message
    SetNotificationTextEntry("STRING")
    AddTextComponentString("~r~Incorrect password! Try again.")
    DrawNotification(false, false)
    
    -- Keep the prompt active for retry
    Citizen.Wait(2000)
    if not isAuthenticated then
        showPasswordPrompt()
    end
end)

-- Prevent certain actions while not authenticated
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if not isAuthenticated then
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
        end
    end
end)

print("[ServePass] Client password protection loaded")