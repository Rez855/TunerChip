local playerVehIds = { }
local tuneDictionary = { }

-- I know this is messy and isnt the correct way to do this. currentvehicle is different per client
-- Nopixel probably already has a class that handles vehicles so no point in rewriting one to scrap it later

RegisterServerEvent('baseevents:enteringVehicle')

AddEventHandler("baseevents:enteringVehicle", function(targetVehicle, vehicleSeat, vehicleDisplayName)
	if(next(playerVehIds) == nil or playerVehIds[tostring(targetVehicle)] == nil) then
			print("Requesting vehicle Id")
			TriggerClientEvent("RequestVehicleId", source, targetVehicle)
	end
end)

RegisterServerEvent('baseevents:enteredVehicle')

AddEventHandler("baseevents:enteredVehicle", function(currentVehicle, currentSeat, vehicleDisplayName)

	TriggerClientEvent("GiveTune", source, tuneDictionary[playerVehIds[tostring(currentVehicle)]])

end)

RegisterServerEvent('baseevents:leftVehicle')

AddEventHandler("baseevents:leftVehicle", function(currentVehicle, currentSeat, vehicleDisplayName)
	print("Player left vehicle")
	TriggerClientEvent("ClearTune", source, tuneDictionary[currentVehicle])
end)

RegisterNetEvent('SetTune', vehId, tune)

AddEventHandler('SetTune', function(vehId, tune)
	print(vehId)

	for k,v in pairs(tune) do
		print(k .. ":" .. v)
	end
	tuneDictionary[tostring(vehId)] = tune
end)

RegisterNetEvent('RegisterVehicleId', vehicle, id)

AddEventHandler('RegisterVehicleId', function(vehicle, id)
	playerVehIds[tostring(vehicle)] = tostring(id)
end)

