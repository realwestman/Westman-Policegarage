if Config.Framework == "QBCore" then
  QBCore = exports[Config.Engine]:GetCoreObject()
elseif Config.Framework == "ESX" then 
  ESX = exports[Config.Engine]:getSharedObject()
end 

local NUIOpen = false

CreateThread(function()
  while true do 
    if Config.Framework == "QBCore" then
      PlayerData = QBCore.Functions.GetPlayerData()
    elseif Config.Framework == "ESX" then 
      PlayerData = ESX.GetPlayerData()
    end
    Wait(30000)
  end
  end)

CreateThread(function()
  while true do 
    local sleep = 2000
    if PlayerData.job and PlayerData.job.name == Config.Job then
      for _, v in pairs(Config.Positions) do
        local PlayerPed = PlayerPedId()
        local PlayerPedCoords = GetEntityCoords(PlayerPed)
        local distance = #(PlayerPedCoords - vector3(v.x, v.y, v.z))
        if distance <= 3.0 then
          sleep = 1
          DrawText3D(v.x, v.y, v.z, ""..Strings.OpenGarage.."")
          
          if IsControlJustReleased(0, 38) then
            if Config.Framework == "QBCore" then
            QBCore.Functions.Notify(Strings.OpenedGarage)
          elseif Config.Framework == "ESX" then 
            ESX.ShowNotification(Strings.OpenedGarage)
            SendNUIMessage({ action = 'sendData', data = json.encode(Config.GarageVehicles) })
            OpenNUI()
          end
        end
      end 
      
        local distance2 = #(PlayerPedCoords - Config.StoreCar)
        if IsPedInAnyVehicle(PlayerPed) and distance2 <= 4.0 then
          sleep = 1
          DrawMarker(6, Config.StoreCar.x, Config.StoreCar.y, Config.StoreCar.z - 0.99, 0.0, 0.0, 0.0, 270.0, 0.0, 0.0, 3.0, 3.0, 3.0, 0, 0, 255, 100, false, true, 2, false, false, false, false)
          DrawText3D(Config.StoreCar.x, Config.StoreCar.y, Config.StoreCar.z, ""..Strings.DeleteCar.."")
          if IsControlJustPressed(0, 74) then 
            if Config.Framework == "ESX" then
              ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPed))
            elseif Config.Framework == "QBCore" then
            QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPed))
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
  if Config.Framework == "QBCore" then 
    QBCore.Functions.Notify(Strings.ExitedGarage)
  elseif Config.Framework == "ESX" then 
    ESX.ShowNotification(Strings.ExitedGarage)
  end
end
end)

RegisterNUICallback('spawnvehicle', function(CarData)
  local coords = Config.SpawnPosition
  local heading = Config.SpawnPositionHeading 
  if NUIOpen then
    OpenNUI()
    if not IsPositionOccupied(coords.x, coords.y, coords.z, 5.0, false, true, false, nil, nil, 0, nil) then
      if Config.Framework == "ESX" then
        ESX.Game.SpawnVehicle(CarData, Config.SpawnPosition, heading, function() 
        end)
      else
        QBCore.Functions.SpawnVehicle(CarData, cb, coords, true, true)
      end
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
