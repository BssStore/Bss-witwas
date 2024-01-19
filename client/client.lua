ESX = exports["es_extended"]:getSharedObject()

CreateBlip = function(coords, sprite, colour, text, scale)
    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

CreateThread(function()
    for i=1, #Config.NPC do
        exports.qtarget:AddBoxZone(i.."_sell_shop", Config.NPC[i].coords, 1.0, 1.0, {
            name=i.."_sell_shop",
            heading=Config.NPC[i].blip.heading,
            debugPoly=false,
            minZ=Config.NPC[i].coords.z-1.5,
            maxZ=Config.NPC[i].coords.z+1.5
        }, {
            options = {
                {
                    event = 'frp-witwas:witwas',
                    icon = 'fas fa-hand-paper',
                    label = 'Witwassen',
                    store = Config.NPC[i]
                }
            },
            job = 'all',
            distance = 1.5
        })
        if Config.NPC[i].blip.enabled then
            CreateBlip(Config.NPC[i].coords, Config.NPC[i].blip.sprite, Config.NPC[i].blip.color, Config.NPC[i].label, Config.NPC[i].blip.scale)
        end
    end
end)

AddEventHandler('frp-witwas:witwas', function()
    lib.progressCircle({
        label = "Witwassen",
        position = "Bottom",
        duration = 10000,
        useWhileDead = false,
        canCancel = false,
        anim = {
            scenario = Config.animationScenario
          }
      })

    lib.callback.await("frp-witwas:switch", source)
end)


local pedSpawned = {}
local pedPool = {}
CreateThread(function()
	while true do
		local sleep = 1500
        local playerPed = cache.ped
        local pos = GetEntityCoords(playerPed)
		for i=1, #Config.NPC do
			local dist = #(pos - Config.NPC[i].coords)
			if dist <= 20 and not pedSpawned[i] then
				pedSpawned[i] = true
                lib.requestModel(Config.NPC[i].ped, 100)
                -- lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
				pedPool[i] = CreatePed(28, Config.NPC[i].ped, Config.NPC[i].coords.x, Config.NPC[i].coords.y, Config.NPC[i].coords.z, Config.NPC[i].heading, false, false)
				FreezeEntityPosition(pedPool[i], true)
				SetEntityInvincible(pedPool[i], true)
				SetBlockingOfNonTemporaryEvents(pedPool[i], true)
				-- TaskPlayAnim(pedPool[i], 'mini@strip_club@idles@bouncer@base','base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
			elseif dist >= 21 and pedSpawned[i] then
				local model = GetEntityModel(pedPool[i])
				SetModelAsNoLongerNeeded(model)
				DeletePed(pedPool[i])
				SetPedAsNoLongerNeeded(pedPool[i])
                pedPool[i] = nil
				pedSpawned[i] = false
			end
		end
		Wait(sleep)
	end
end)