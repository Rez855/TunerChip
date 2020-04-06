--[[ 
local mph = 2.2369
local kph = 3.6 
]]

-- toggles debug mode
local debug = true

local display = false

local defaultTuneFile = {
    ['1500'] = 1.0,
    ['2000'] = 1.0,
    ['2500'] = 1.0,
    ['3000'] = 1.0,
    ['3500'] = 1.0,
    ['4000'] = 1.0,
    ['4500'] = 1.0,
    ['5000'] = 1.0,
    ['5500'] = 1.0,
    ['6000'] = 1.0,
    ['6500'] = 1.0,
    ['7000'] = 1.0,
    ['7500'] = 1.0,
}

local currentTune = { }

local fMass
local engineSize
local initialDriveForce
local driveBiasFront

-- Toggles ui
function SetDisplay(bool, view)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        view = view,
        status = bool,
    })
end

RegisterNetEvent("RequestVehicleId")

AddEventHandler("RequestVehicleId", function(vehicle)
    print("Sending vehicle id to server")
    TriggerServerEvent("RegisterVehicleId", vehicle, VehToNet(vehicle))
    fMass = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fMass')
    engineSize = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fOilVolume')
    initialDriveForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveForce')
    driveBiasFront = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDriveBiasFront')
end)


-- clears currentTune
RegisterNetEvent("ClearTune")

AddEventHandler("ClearTune", function()
    msg("Clearing Tune")
    currentTune = { }
    SendNUIMessage( {
        type = "tunefile",
        one = defaultTuneFile['1500'],
        two = defaultTuneFile['2000'],
        three = defaultTuneFile['2500'],
        four = defaultTuneFile['3000'],
        five = defaultTuneFile['3500'],
        six = defaultTuneFile['4000'],
        seven = defaultTuneFile['4500'],
        eight = defaultTuneFile['5000'],
        nine = defaultTuneFile['5500'],
        ten = defaultTuneFile['6000'],
        eleven = defaultTuneFile['6500'],
        twelve = defaultTuneFile['7000'],
        thirteen = defaultTuneFile['7500'],
    })
end)

-- set tune received from server
RegisterNetEvent("GiveTune")

AddEventHandler("GiveTune", function(tune)
    msg("Received Tune From Server")
    if(tune == nil) then
        for k,v in pairs(defaultTuneFile) do
            currentTune[k] = v
        end
    else
        currentTune = tune
    end
end)

-- Opens the tuning menu and sends the data needed
RegisterCommand("tune", function(source, args)
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    if(next(currentTune) == nil) then
        for k,v in pairs(defaultTuneFile) do
            currentTune[k] = v
        end
    end

    SendNUIMessage( {
        type = "tune",
        one = currentTune['1500'],
        two = currentTune['2000'],
        three = currentTune['2500'],
        four = currentTune['3000'],
        five = currentTune['3500'],
        six = currentTune['4000'],
        seven = currentTune['4500'],
        eight = currentTune['5000'],
        nine = currentTune['5500'],
        ten = currentTune['6000'],
        eleven = currentTune['6500'],
        twelve = currentTune['7000'],
        thirteen = currentTune['7500'],
    })


    SetDisplay(not display, "tune")
end)


RegisterCommand("tunelog", function(source, args)
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    if(next(currentTune) == nil) then
        for k,v in pairs(defaultTuneFile) do
            currentTune[k] = v
        end
    end

    SendNUIMessage( {
        type = "tunelog",
        one = CalculateVehicleAFRatioAtRPM(veh, currentTune, 1500),
        two = CalculateVehicleAFRatioAtRPM(veh, currentTune, 2000),
        three = CalculateVehicleAFRatioAtRPM(veh, currentTune, 2500),
        four = CalculateVehicleAFRatioAtRPM(veh, currentTune, 3000),
        five = CalculateVehicleAFRatioAtRPM(veh, currentTune, 3500),
        six = CalculateVehicleAFRatioAtRPM(veh, currentTune, 4000),
        seven = CalculateVehicleAFRatioAtRPM(veh, currentTune, 4500),
        eight = CalculateVehicleAFRatioAtRPM(veh, currentTune, 5000),
        nine = CalculateVehicleAFRatioAtRPM(veh, currentTune, 5500),
        ten = CalculateVehicleAFRatioAtRPM(veh, currentTune, 6000),
        eleven = CalculateVehicleAFRatioAtRPM(veh, currentTune, 6500),
        twelve = CalculateVehicleAFRatioAtRPM(veh, currentTune, 7000),
        thirteen = CalculateVehicleAFRatioAtRPM(veh, currentTune, 7500),
    })

    SetDisplay(true, "tunelog")
end)

-- [ NUI CALLBACKS ] --
RegisterNUICallback("exit", function(data)
    chat("exited", {0,255,0})
    SetDisplay(false, "tune")
end)


RegisterNUICallback("main", function(data)
    chat(data.text, {0,255,0})
    SetDisplay(false, "tune")
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false, "tune")
end)

RegisterNUICallback("tune", function(data)
    -- update current tune
    currentTune['1500'] = data.one
    currentTune['2000'] = data.two
    currentTune['2500'] = data.three
    currentTune['3000'] = data.four
    currentTune['3500'] = data.five
    currentTune['4000'] = data.six
    currentTune['4500'] = data.seven
    currentTune['5000'] = data.eight
    currentTune['5500'] = data.nine
    currentTune['6000'] = data.ten
    currentTune['6500'] = data.eleven
    currentTune['7000'] = data.twelve
    currentTune['7500'] = data.thirteen

    -- set new log data
    local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

    SendNUIMessage( {
        type = "tunelog",
        one = CalculateVehicleAFRatioAtRPM(veh, currentTune, 1500),
        two = CalculateVehicleAFRatioAtRPM(veh, currentTune, 2000),
        three = CalculateVehicleAFRatioAtRPM(veh, currentTune, 2500),
        four = CalculateVehicleAFRatioAtRPM(veh, currentTune, 3000),
        five = CalculateVehicleAFRatioAtRPM(veh, currentTune, 3500),
        six = CalculateVehicleAFRatioAtRPM(veh, currentTune, 4000),
        seven = CalculateVehicleAFRatioAtRPM(veh, currentTune, 4500),
        eight = CalculateVehicleAFRatioAtRPM(veh, currentTune, 5000),
        nine = CalculateVehicleAFRatioAtRPM(veh, currentTune, 5500),
        ten = CalculateVehicleAFRatioAtRPM(veh, currentTune, 6000),
        eleven = CalculateVehicleAFRatioAtRPM(veh, currentTune, 6500),
        twelve = CalculateVehicleAFRatioAtRPM(veh, currentTune, 7000),
        thirteen = CalculateVehicleAFRatioAtRPM(veh, currentTune, 7500),
    })

    TriggerServerEvent('SetTune', VehToNet(GetVehiclePedIsIn(GetPlayerPed(-1), false)), currentTune)

    --SetDisplay(false)
end)

-- Disables controls while player is in menus
Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)

        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride


    end
end)

function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end

-- Speedometer and helper functions
function msg(text)
	TriggerEvent("chatMessage", "[Server]", {255,0,0}, text)
end

function text(content, x, y) 
    --SetTextFont(1)
    SetTextProportional(0)
    SetTextScale(0.8,0.8)
    SetTextEntry("STRING")
    AddTextComponentString(content)
    DrawText(x,y)
end

-- Sets cars boost based on tune
Citizen.CreateThread(function()
    local lastRoundedRPM

    while true do
        Citizen.Wait(20)

        -- check if the ped is in a vehicle
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then

            if(lastRoundedRPM ~= math.floor(GetVehicleRPM(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 500 + 0.5)*500) then
                lastRoundedRPM = math.floor(GetVehicleRPM(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 500 + 0.5)*500
                local afRatio = CalculateVehicleAFRatio(GetVehiclePedIsIn(GetPlayerPed(-1), false), tuneFile)
            
                -- (x-h)^2=4p(y-k)   formula to find the correct multiplier equation
                -- https://www.youtube.com/watch?v=_X82bqW0cTM
                local base = 50

                local multiplier = (afRatio^2 - 25*afRatio + 152.25) / -4

                if(multiplier < 0) then
                    multiplier = 0
                end

                multiplier = multiplier * base

                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), multiplier)
            end
        end
    end
end)

-- Debug info loop
Citizen.CreateThread(function()
    while debug do
        Citizen.Wait(1)
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            if(debug) then
                text("ID: " .. GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.8, 0.4)
                text("Speed: " .. GetVehicleSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)), 0.8, 0.8)
                local rpm = GetVehicleCurrentRpm(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                text("RPM: " .. math.floor(GetVehicleRPM(GetVehiclePedIsIn(GetPlayerPed(-1), false)) / 500 + 0.5)*500, 0.8, 0.5)
                text("AF Ratio: " .. math.floor(CalculateVehicleAFRatio(GetVehiclePedIsIn(GetPlayerPed(-1), false), tuneFile)*100)/100, 0.8, 0.7)
                text("Boost: " .. math.floor(multiplier*100)/100, 0.8, 0.6)
            end
        end
    end
end)

-- [ Vehicle info getters ] --

-- Checks if vehicle exists and is valid
function DoesVehicleExist(vehicle)
    if(vehicle ~= nil and DoesEntityExist(vehicle)) then
        return true
    else
        return false
    end
end

-- Gets the vehicles current speed in MPH
-- Returns -1 if vehicle is invalid
function GetVehicleSpeed(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return math.floor(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))*2.2369)
    else
        return -1
    end
end

-- Gets the vehicles current RPM
-- All vehicles have a max RPM of 7500
-- Returns -1 if vehicle is invalid
function GetVehicleRPM(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return math.floor(GetVehicleCurrentRpm(vehicle)*7500)
    else
        return -1
    end
end

-- Checks if the vehicle has a turbo equipped
-- Returns -1 if vehicle is invalid
function DoesVehicleHaveTurbo(vehicle)
    if(DoesVehicleExist(vehicle)) then
        if(IsToggleModOn(vehicle, 18)) then
            return true
        else
            return false
        end
    else
        return -1
    end
end

----- [ Vehicle Mod Level Getters ] -----

function GetVehicleExhaustLevel(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return GetVehicleMod(vehicle, 4)
    else
        return -1
    end
end

function GetVehicleTransmissionLevel(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return GetVehicleMod(vehicle, 13)
    else
        return -1
    end
end

function GetVehicleEngineLevel(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return GetVehicleMod(vehicle, 11)
    else
        return -1
    end
end

function GetVehicleArmorLevel(vehicle)
    if(DoesVehicleExist(vehicle)) then
        return GetVehicleMod(vehicle, 16)
    else
        return -1
    end
end

----- [ END ] -----

function CalculateVehicleAFRatio(vehicle, tune)
    if(DoesVehicleExist(vehicle)) then
        -- get closest fuel data from tune
        local roundedRPM = math.floor(GetVehicleRPM(vehicle) / 500 + 0.5)*500

        return CalculateVehicleAFRatioAtRPM(vehicle, tune, roundedRPM)

    else
        return -1
    end
end


function CalculateVehicleAFRatioAtRPM(vehicle, tune, rpm)
    if(DoesVehicleExist(vehicle)) then
        -- check is vehicle has tune
        if(currentTune == nil) then
            return 14.5
        end

        -- vehicle data
        local speed = GetVehicleSpeed(vehicle)

        -- mods
        local exhaustLevel = GetVehicleExhaustLevel(vehicle)
        local transmissionLevel = GetVehicleTransmissionLevel(vehicle)
        local engineLevel = GetVehicleEngineLevel(vehicle)
        local armorLevel = GetVehicleArmorLevel(vehicle)
        local hasTurbo = DoesVehicleHaveTurbo(vehicle)

        
        -- get closest fuel data from tune
        local roundedRPM = math.floor(rpm / 500 + 0.5)*500
        local fuelData = currentTune[tostring(roundedRPM)]



        -- If a person gets out of the car in the time it takes to calculate the data fueldata will return nil
        -- Return base tune level
        if(fuelData == nil) then
            return 14.5
        end

        -- Calculate how much air the car needs
        local airData = 14.5

        if(hasTurbo) then
            airData = airData + roundedRPM / 1000
        end

        if(exhaustLevel ~= -1) then
            airData = airData + 0.1*exhaustLevel
        end

        if(engineLevel ~= -1) then
            airData = airData + 0.1*engineLevel
        end

        if(armorLevel ~= -1) then
            airData = airData + 0.05*armorLevel
        end

        if(transmissionLevel ~= -1) then
            airData = airData + 0.1*transmissionLevel
        end

        local engineSizeToMass = (engineSize/fMass)*500

        if(engineSizeToMass > 4) then
            engineSizeToMass = 4
        end

        airData = airData + engineSizeToMass
        airData = airData + initialDriveForce
        airData = airData + driveBiasFront

        return airData/fuelData

    else
        return -1
    end
end