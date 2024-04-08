

local NUIOpen = false

Citizen.CreateThread(function()
while true do 
  local sleep = 2000
 if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.Job then
for data, v in pairs(Config.Positions) do
  local PlayerPed = PlayerPedId()
  local PlayerPedCoords = GetEntityCoords(PlayerPed)
  local distance = #(PlayerPedCoords - v)
  if distance <= 3.0 then 
    sleep = 0
    DrawText3D(v.x, v.y, v.z, ""..Strings.OpenGarage.."")
    if IsControlJustReleased(0, 38) then
      ESX.ShowNotification(Strings.OpenedGarage)
      local data = json.encode(Config.GarageVehicles) 
     
      SendNUIMessage({
        action = 'sendData',
        data = data
      })
      OpenNUI()
    end 
  end

      local distance2 = #(PlayerPedCoords - Config.StoreCar)
      local IsPedVehicle = IsPedInAnyVehicle(PlayerPed)
      if IsPedVehicle then
        if distance2 <= 4.0 then
          sleep = 0
          DrawMarker(6, Config.StoreCar.x, Config.StoreCar.y, Config.StoreCar.z - 0.99, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0, 0, 255, 100, false, true, 2, false, false, false, false)
          DrawText3D(Config.StoreCar.x, Config.StoreCar.y, Config.StoreCar.z, ""..Strings.DeleteCar.."")

          if IsControlJustPressed(0, 74) then 
          ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed))
      end 
    end
  end
  end
end
Wait(sleep)
end
end)

function OpenNUI()
if not NUIOpen then 
  NUIOpen = true 
  SetNuiFocus(true, true)
  SendNUIMessage({
    action = 'open'
  })
else
  NUIOpen = false 
  SetNuiFocus(false, false)
  SendNUIMessage({
    action = 'close'
  })
end
end

RegisterNUICallback('exit', function()
if NUIOpen then
  OpenNUI()
  ESX.ShowNotification(""..Strings.ExitedGarage.."")
end
end)



RegisterNUICallback('spawnvehicle', function(CarData)
  local coords = Config.SpawnPosition
  local heading = Config.SpawnPositionHeading 
  if NUIOpen then
    OpenNUI()
    if not IsPositionOccupied(coords.x, coords.y, coords.z, 5.0, false, true, false, nil, nil, 0, nil) then
    ESX.Game.SpawnVehicle(CarData, Config.SpawnPosition, heading, function() 
    end)
  else
    ESX.ShowNotification(""..Strings.BlockingSpawn.."")
  end
  end
end)




function DrawText3D(x, y, z, text)
  local onScreen, screenX, screenY = World3dToScreen2d(x, y, z)

  if onScreen then 
      local factor = (string.len(text)) / 380
      SetTextScale(0.36, 0.36)
      SetTextFont(4)
      SetTextColour(255, 255, 255, 215)
      SetTextEntry("STRING")
      SetTextCentre(true)
      AddTextComponentSubstringPlayerName(text)
      SetDrawOrigin(x, y, z, 0) 
      EndTextCommandDisplayText(0.0, -0.10)
      DrawRect(0.0, -0.10+0.0125, 0.020+ factor, 0.03, 0, 0, 0, 80)
      ClearDrawOrigin()
  end
end