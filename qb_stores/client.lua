--[[
   _____                                         _                _     _                __      __  _   _____             _____ 
  / ____|                                       | |              | |   | |               \ \    / / (_) |  __ \           / ____|
 | |        ___    _ __   __   __   ___   _ __  | |_    ___    __| |   | |__    _   _     \ \  / /   _  | |__) |  _   _  | (___  
 | |       / _ \  | '_ \  \ \ / /  / _ \ | '__| | __|  / _ \  / _` |   | '_ \  | | | |     \ \/ /   | | |  _  /  | | | |  \___ \ 
 | |____  | (_) | | | | |  \ V /  |  __/ | |    | |_  |  __/ | (_| |   | |_) | | |_| |      \  /    | | | | \ \  | |_| |  ____) |
  \_____|  \___/  |_| |_|   \_/    \___| |_|     \__|  \___|  \__,_|   |_.__/   \__, |       \/     |_| |_|  \_\  \__,_| |_____/ 
                                                                                 __/ |                                           
                                                                                |___/                                            
-- Converted by ViRuS for QBCore Framework - https://github.com/qbcore-framework --
]]
local truck,truck_blip 
menuactive = false
empresaAtual = nil
job_data = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------	

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	local timer = 1
	while true do
		timer = 3000
		for k,v in pairs(Config.market_locations) do
			local x,y,z = table.unpack(v.coord)
			local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
			if not menuactive and distance <= 20.0 then
				timer = 1
				DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 2.0 then
					DrawText3D2(x,y,z-0.6, Lang[Config.lang]['open'], 0.40)
					if IsControlJustPressed(0,38) then
						empresaAtual = k
						TriggerServerEvent("qb_stores:getData",empresaAtual) 
					end
				end
			end

			for _,mark in pairs(v.sell_blip_coords) do
				local x,y,z = table.unpack(mark)
				local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
				if distance <= 20.0 then
					timer = 1
					DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
					if distance <= 2.0 then
						DrawText3D2(x,y,z-0.6, Lang[Config.lang]['open_market'], 0.40)
						if IsControlJustPressed(0,38) then
							empresaAtual = k
							TriggerServerEvent("qb_stores:openMarket",k) 
						end
					end
				end
			end

			local x,y,z = table.unpack(v.deliveryman_coord)
			local distance = #(GetEntityCoords(PlayerPedId()) - vector3(x,y,z))
			if distance <= 20.0 then
				timer = 1
				DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
				if distance <= 2.0 then
					if job_data[k] == nil then
						DrawText3D2(x,y,z-0.6, Lang[Config.lang]['download_jobs'], 0.40)
						if IsControlJustPressed(0,38) then
							TriggerServerEvent('qb_stores:getJob',k)
						end
					else
						DrawText3D2(x,y,z-0.6, Lang[Config.lang]['show_jobs']:format(job_data[k].name,job_data[k].reward), 0.40)
						if IsControlJustPressed(0,38) then
							if truck then
								TriggerEvent("Notify","negado",Lang[Config.lang]['already_has_job'])
								break
							end
							local x2,y2,z2,h2 = table.unpack(Config.market_locations[k]['garage_coord'])
							local checkPos = IsSpawnPointClear({['x']=x2,['y']=y2,['z']=z2},5.001)
							if checkPos == false then
								TriggerEvent("Notify","negado",Lang[Config.lang]['occupied_places'])
								break
							end
							empresaAtual = k
							TriggerServerEvent('qb_stores:startJob',k,job_data[k].id)
						end
					end
				else
					job_data[k] = nil
				end
			end
		end
		Citizen.Wait(timer)
	end
end)

RegisterNetEvent('qb_stores:getJob')
AddEventHandler('qb_stores:getJob', function(k,data)
	job_data[k] = data
end)

RegisterNetEvent('qb_stores:open')
AddEventHandler('qb_stores:open', function(dados,update,isMarket)
	-- Abre NUI
	SendNUIMessage({ 
		showmenu = true,
		update = update,
		isMarket = isMarket,
		dados = dados
	})
	if update == false then
		menuactive = true
		SetNuiFocus(true,true)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('startJob', function(data, cb)
	if truck then
		TriggerEvent("Notify","negado",Lang[Config.lang]['already_has_job'])
		return
	end
	local x2,y2,z2,h2 = table.unpack(Config.market_locations[empresaAtual]['garage_coord'])
	local checkPos = IsSpawnPointClear({['x']=x2,['y']=y2,['z']=z2},5.001)
	if checkPos == false then
		TriggerEvent("Notify","negado",Lang[Config.lang]['occupied_places'])
		return
	end
	TriggerServerEvent('qb_stores:startContract',empresaAtual,data.item_id)
end)

RegisterNUICallback('createJob', function(data, cb)
	TriggerServerEvent('qb_stores:createJob',empresaAtual,data)
end)

RegisterNUICallback('buyUpgrade', function(data, cb)
	TriggerServerEvent('qb_stores:buyUpgrade',empresaAtual,data)
end)

local cooldown1 = nil
RegisterNUICallback('deleteJob', function(data, cb)
	if cooldown1 == nil then
		cooldown1 = true
		
		TriggerServerEvent('qb_stores:deleteJob',empresaAtual,data)

		SetTimeout(500,function()
			cooldown1 = nil
		end)
	end
end)

RegisterNUICallback('depositMoney', function(data, cb)
	TriggerServerEvent('qb_stores:depositMoney',empresaAtual,data)
end)

local cooldown2 = nil
RegisterNUICallback('withdrawMoney', function(data, cb)
	if cooldown2 == nil then
		cooldown2 = true
		
		TriggerServerEvent('qb_stores:withdrawMoney',empresaAtual)

		SetTimeout(500,function()
			cooldown2 = nil
		end)
	end
end)

local cooldown3 = nil
RegisterNUICallback('sellMarket', function(data, cb)
	if cooldown3 == nil then
		cooldown3 = true

		TriggerServerEvent('qb_stores:sellMarket',empresaAtual)
		closeUI()
		

		SetTimeout(500,function()
			cooldown3 = nil
		end)
	end
end)

RegisterNUICallback('buyItem', function(data, cb)
	TriggerServerEvent('qb_stores:buyItem',empresaAtual,data)
end)

RegisterNUICallback('close', function(data, cb)
	closeUI()
end)

function closeUI()
	empresaAtual = nil
	menuactive = false
	SetNuiFocus(false,false)
	SendNUIMessage({ hidemenu = true })
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('qb_stores:startContract')
AddEventHandler('qb_stores:startContract', function(item,truck_level,query_delivery)
	local key = empresaAtual
	job_data[key] = nil

	local x2,y2,z2,h2 = table.unpack(Config.market_locations[key]['garage_coord'])
	truck,truck_blip = spawnVehicle(Config.trucks[truck_level],x2,y2,z2,h2)
	TriggerEvent("Notify","sucesso",Lang[Config.lang]['already_is_in_garage'])
	closeUI()

	local rand = math.random(#Config.delivery_locations)
	local x,y,z = table.unpack(Config.delivery_locations[rand])
	local route_blip = createBlip(x,y,z)

	distance_traveled = ((#(GetEntityCoords(PlayerPedId()) - vector3(x,y,z)) * 2)/1000)
	distance_traveled = tonumber(string.format("%.2f",distance_traveled)) or 0
	local fase_coleta = 1
	local timer = 2000
	while truck do
		timer = 2000
		local ped = PlayerPedId()
		veh = GetVehiclePedIsIn(ped,false)

		if fase_coleta == 1 then
			local distance = #(GetEntityCoords(ped) - vector3(x,y,z))
			if distance <= 50 then
				timer = 5
				DrawMarker(39,x,y,z-0.6,0,0,0,0.0,0,0,1.0,1.0,1.0,255,0,0,50,0,0,0,1)
				if distance <= 2 then
					DrawText3D2(x,y,z-0.6, Lang[Config.lang]['objective_marker'], 0.40)
					if IsControlJustPressed(0,38) then
						if not (IsPedSittingInAnyVehicle(ped) or IsPedInAnyVehicle(ped, true)) then
							ResetPedMovementClipset(PlayerPedId(),0)
							SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
							CarregarObjeto("anim@heists@box_carry@","idle","hei_prop_heist_box",50,28422)
							SetVehicleDoorOpen(truck,2,0,0)
							SetVehicleDoorOpen(truck,3,0,0)
							SetVehicleDoorOpen(truck,5,0,0)
							
							RemoveBlip(route_blip)
							route_blip = nil
							fase_coleta = 2

							TriggerEvent("Notify","sucesso",Lang[Config.lang]['bring_to_van'])
						else
							TriggerEvent("Notify","negado",Lang[Config.lang]['out_of_veh'])
						end
					end
				end
			end
		elseif fase_coleta == 2 then

			local distance2 = #(GetEntityCoords(ped) - GetWorldPositionOfEntityBone(truck,GetEntityBoneIndexByName(truck,"door_dside_r")))
			local xa,ya,za = table.unpack(GetWorldPositionOfEntityBone(truck,GetEntityBoneIndexByName(truck,"door_dside_r")))

			local distance2 = #(GetEntityCoords(ped) - GetWorldPositionOfEntityBone(truck,GetEntityBoneIndexByName(truck,"door_pside_r")))
			local xb,yb,zb = table.unpack(GetWorldPositionOfEntityBone(truck,GetEntityBoneIndexByName(truck,"door_pside_r")))

			local x = (xa+xb)/2
			local y = (ya+yb)/2
			local z = (za+zb)/2

			local distance = #(GetEntityCoords(ped) - vector3(x,y,z-1.0))

			if distance <= 50 then
				timer = 5
				DrawMarker(39,x,y,z-0.5,0,0,0,0.0,0,0,1.0,1.0,1.0,255,0,0,50,0,0,0,1)
				if distance <= 1.5 then
					DrawText3D2(x,y,z-0.5, Lang[Config.lang]['objective_marker_2'], 0.40)
					if IsControlJustPressed(0,38) then
						if not (IsPedSittingInAnyVehicle(ped) or IsPedInAnyVehicle(ped, true))  then
							DeletarObjeto()
							route_blip = createBlip(x2,y2,z2)
							fase_coleta = 3

							TriggerEvent("Notify","sucesso",Lang[Config.lang]['bring_to_store'])

							SetTimeout(3000,function()
								SetVehicleDoorShut(truck,2,0)
								SetVehicleDoorShut(truck,3,0)
								SetVehicleDoorShut(truck,5,0)
							end)
						else
							TriggerEvent("Notify","negado",Lang[Config.lang]['out_of_veh'])
						end
					end
				end
			end
		elseif fase_coleta == 3 then
			local distance = #(GetEntityCoords(ped) - vector3(x2,y2,z2))
			if distance <= 50 and veh == truck then
				timer = 5
				DrawMarker(39,x2,y2,z2-0.6,0,0,0,0.0,0,0,1.0,1.0,1.0,255,0,0,50,0,0,0,1)
				DrawText3D2(x2,y2,z2-0.6, Lang[Config.lang]['garage_marker'], 0.40)
				if distance <= 4 then
					BringVehicleToHalt(truck, 2.5, 1, false)
					Citizen.Wait(10)
					DoScreenFadeOut(500)
					Citizen.Wait(500)
					DeleteVehicle(truck)
					RemoveBlip(truck_blip)
					RemoveBlip(route_blip)
					PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
					Citizen.Wait(1000)
					DoScreenFadeIn(1000)
					Citizen.CreateThreadNow(function()
						showScaleform(Lang[Config.lang]['sucess'], Lang[Config.lang]['sucess_finished'], 3)
					end)
					truck = nil
					truck_blip = nil
					route_blip = nil
					TriggerServerEvent("qb_stores:finishContract",key,item,truck_level,distance_traveled,query_delivery)
					return
				end
			end
		end

		if not IsEntityAVehicle(truck) then
			DeletarObjeto()
			DeleteEntity(truck)
			RemoveBlip(truck_blip)
			RemoveBlip(route_blip)
			truck = nil
			truck_blip = nil
			route_blip = nil
			TriggerServerEvent("qb_stores:failed",query_delivery)
			return
		end

		if IsEntityDead(ped) then
			DeletarObjeto()
			SetVehicleEngineHealth(truck,-4000)
			SetVehicleUndriveable(truck,true)
			RemoveBlip(truck_blip)
			RemoveBlip(route_blip)
			truck = nil
			truck_blip = nil
			route_blip = nil
			PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
			TriggerEvent("Notify","negado",Lang[Config.lang]['you_died'])
			TriggerServerEvent("qb_stores:failed",query_delivery)
			return
		end

		engineH = GetVehicleEngineHealth(truck)
		if engineH <= 150 then
			DeletarObjeto()
			SetVehicleEngineHealth(truck,-4000)
			SetVehicleUndriveable(truck,true)
			RemoveBlip(truck_blip)
			RemoveBlip(route_blip)
			truck = nil
			truck_blip = nil
			route_blip = nil
			PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
			TriggerEvent("Notify","negado",Lang[Config.lang]['vehicle_destroyed'])
			TriggerServerEvent("qb_stores:failed",query_delivery)
			return
		end
		
		Citizen.Wait(timer)
	end
end)

function createBlip(x,y,z)
	blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip,478)
	SetBlipColour(blip,5)
	SetBlipAsShortRange(blip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(Lang[Config.lang]['blip_route'])
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, 1)
	return blip
end

function showScaleform(title, desc, sec)
	function Initialize(scaleform)
		local scaleform = RequestScaleformMovie(scaleform)

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(0)
		end
		PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
		PushScaleformMovieFunctionParameterString(title)
		PushScaleformMovieFunctionParameterString(desc)
		PopScaleformMovieFunctionVoid()
		return scaleform
	end
	scaleform = Initialize("mp_big_message_freemode")
	while sec > 0 do
		sec = sec - 0.02
		Citizen.Wait(0)
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
	end
	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CarregarObjeto
-----------------------------------------------------------------------------------------------------------------------------------------

local object = nil
function CarregarObjeto(dict,anim,prop,flag,hand,pos1,pos2,pos3,pos4,pos5,pos6)
	local ped = PlayerPedId()

	RequestModel(GetHashKey(prop))
	while not HasModelLoaded(GetHashKey(prop)) do
		Citizen.Wait(10)
	end

	if pos1 then
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),pos1,pos2,pos3,pos4,pos5,pos6,true,true,false,true,1,true)
	else
		CarregarAnim(dict)
		TaskPlayAnim(ped,dict,anim,3.0,3.0,-1,flag,0,0,0,0)
		local coords = GetOffsetFromEntityInWorldCoords(ped,0.0,0.0,-5.0)
		object = CreateObject(GetHashKey(prop),coords.x,coords.y,coords.z,true,true,true)
		SetEntityCollision(object,false,false)
		AttachEntityToEntity(object,ped,GetPedBoneIndex(ped,hand),0.0,0.0,0.0,0.0,0.0,0.0,false,false,false,false,2,true)
	end
	Citizen.InvokeNative(0xAD738C3085FE7E11,object,true,true)
end

function DeletarObjeto()
    stopAnim(true)
    if DoesEntityExist(object) then
        TriggerServerEvent("qb_stores:trydeleteobj",ObjToNet(object))
        object = nil
    end
end

RegisterNetEvent("qb_stores:syncdeleteobj")
AddEventHandler("qb_stores:syncdeleteobj",function(index)
    if NetworkDoesNetworkIdExist(index) then
        local v = NetToPed(index)
        if DoesEntityExist(v) and IsEntityAnObject(v) then
            Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
            SetEntityAsMissionEntity(v,true,true)
            NetworkRequestControlOfEntity(v)
            Citizen.InvokeNative(0x539E0AE3E6634B9F,Citizen.PointerValueIntInitialized(v))
            DeleteEntity(v)
            DeleteObject(v)
            SetObjectAsNoLongerNeeded(v)
        end
    end
end)

function CarregarAnim(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- spawnVehicle
-----------------------------------------------------------------------------------------------------------------------------------------

function spawnVehicle(name,x,y,z,h)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		vehicle = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
		local networkId = NetworkGetNetworkIdFromEntity(vehicle)

		SetNetworkIdCanMigrate(networkId, true)
		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetVehRadioStation(vehicle, 'OFF')
		SetModelAsNoLongerNeeded(mhash)
		SetVehicleNumberPlateText(vehicle,Lang[Config.lang]['truck_plate'])

		SetVehicleFuelLevel(vehicle,100.0)
		DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))

		local plate = GetVehicleNumberPlateText(vehicle)
		TriggerEvent("vehiclekeys:client:SetOwner", plate)
	
		blip = AddBlipForEntity(vehicle)
		SetBlipSprite(blip,477)
		SetBlipColour(blip,26)
		SetBlipAsShortRange(blip,false)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Lang[Config.lang]['truck_blip'])
		EndTextCommandSetBlipName(blip)
	end
	return vehicle,blip
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- vehicleLock
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread( function()
	local timer = 2000
	while true do
		if truck then
			timer = 5
			if IsControlJustPressed(0,Config.keyToUnlockTruck) then
				TriggerServerEvent("qb_stores:vehicleLock")
			end
		end
		Citizen.Wait(timer)
	end
end)


RegisterNetEvent('qb_stores:vehicleClientLock')
AddEventHandler('qb_stores:vehicleClientLock', function()
	local v = truck
	if DoesEntityExist(v) and IsEntityAVehicle(v) then
		local lock = GetVehicleDoorLockStatus(v)
		playAnim(true,{{"anim@mp_player_intmenu@key_fob@","fob_click"}},false)
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
		if lock == 1 then
			SetVehicleDoorsLocked(v,2)
			TriggerEvent("Notify","importante",Lang[Config.lang]['vehicle_locked'],8000)
		else
			SetVehicleDoorsLocked(v,1)
			TriggerEvent("Notify","importante",Lang[Config.lang]['vehicle_unlocked'],8000)
		end
		SetVehicleLights(v,2)
		Wait(200)
		SetVehicleLights(v,0)
		Wait(200)
		SetVehicleLights(v,2)
		Wait(200)
		SetVehicleLights(v,0)
	end
end)

local anims = {}

function playAnim(upper, seq, looping)
    stopAnim(upper)

    local flags = 0
    if upper then flags = flags+48 end
    if looping then flags = flags+1 end

    Citizen.CreateThread(function()
      for k,v in pairs(seq) do
        local dict = v[1]
        local name = v[2]
        local loops = v[3] or 1

        for i=1,loops do
            local first = (k == 1 and i == 1)
            local last = (k == #seq and i == loops)

            -- request anim dict
            RequestAnimDict(dict)
            local i = 0
            while not HasAnimDictLoaded(dict) and i < 1000 do -- max time, 10 seconds
              Citizen.Wait(10)
              RequestAnimDict(dict)
              i = i+1
            end

            -- play anim
            if HasAnimDictLoaded(dict)then
              local inspeed = 8.0001
              local outspeed = -8.0001
              if not first then inspeed = 2.0001 end
              if not last then outspeed = 2.0001 end

              TaskPlayAnim(GetPlayerPed(-1),dict,name,inspeed,outspeed,-1,flags,0,0,0,0)
            end

            Citizen.Wait(0)
            while GetEntityAnimCurrentTime(GetPlayerPed(-1),dict,name) <= 0.95 and IsEntityPlayingAnim(GetPlayerPed(-1),dict,name,3) and anims[id] do
              Citizen.Wait(0)
            end
          end
      end
    end)
end
function stopAnim(upper)
	anims = {} -- stop all sequences
	if upper then
	  	ClearPedSecondaryTask(GetPlayerPed(-1))
	else
	  	ClearPedTasks(GetPlayerPed(-1))
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- addBlip
-----------------------------------------------------------------------------------------------------------------------------------------

function addBlip(x,y,z,idtype,idcolor,text,scale)
	if idtype ~= 0 then
		local blip = AddBlipForCoord(x,y,z)
		SetBlipSprite(blip,idtype)
		SetBlipAsShortRange(blip,true)
		SetBlipColour(blip,idcolor)
		SetBlipScale(blip,scale)

		if text then
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(text)
			EndTextCommandSetBlipName(blip)
		end
		return blip
	end
end

Citizen.CreateThread(function()
	for k,v in pairs(Config.market_locations) do
		local x,y,z = table.unpack(v.coord)
		local blips = Config.market_types[v.type].blips
		addBlip(x,y,z,blips.id,blips.color,blips.name,blips.scale)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- IsSpawnPointClear
-----------------------------------------------------------------------------------------------------------------------------------------

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			table.insert(nearbyEntities, isPlayerEntities and k or entity)
		end
	end

	return nearbyEntities
end

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)
		local next = true

		repeat
			coroutine.yield(id)
			next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

GetVehiclesInArea = function(coords, maxDistance) return EnumerateEntitiesWithinDistance(GetVehicles(), false, coords, maxDistance) end
IsSpawnPointClear = function(coords, maxDistance) return #GetVehiclesInArea(coords, maxDistance) == 0 end

-----------------------------------------------------------------------------------------------------------------------------------------
-- Debug
-----------------------------------------------------------------------------------------------------------------------------------------

function print_table(node)
	-- to make output beautiful
	local function tab(amt)
		local str = ""
		for i=1,amt do
			str = str .. "\t"
		end
		return str
	end

	local cache, stack, output = {},{},{}
	local depth = 1
	local output_str = "{\n"

	while true do
		local size = 0
		for k,v in pairs(node) do
			size = size + 1
		end

		local cur_index = 1
		for k,v in pairs(node) do
			if (cache[node] == nil) or (cur_index >= cache[node]) then
			
				if (string.find(output_str,"}",output_str:len())) then
					output_str = output_str .. ",\n"
				elseif not (string.find(output_str,"\n",output_str:len())) then
					output_str = output_str .. "\n"
				end

				-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
				table.insert(output,output_str)
				output_str = ""
			
				local key
				if (type(k) == "number" or type(k) == "boolean") then
					key = "["..tostring(k).."]"
				else
					key = "['"..tostring(k).."']"
				end

				if (type(v) == "number" or type(v) == "boolean") then
					output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
				elseif (type(v) == "table") then
					output_str = output_str .. tab(depth) .. key .. " = {\n"
					table.insert(stack,node)
					table.insert(stack,v)
					cache[node] = cur_index+1
					break
				else
					output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
				end

				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				else
					output_str = output_str .. ","
				end
			else
				-- close the table
				if (cur_index == size) then
					output_str = output_str .. "\n" .. tab(depth-1) .. "}"
				end
			end

			cur_index = cur_index + 1
		end

		if (#stack > 0) then
			node = stack[#stack]
			stack[#stack] = nil
			depth = cache[node] == nil and depth + 1 or depth - 1
		else
			break
		end
	end

	-- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
	table.insert(output,output_str)
	output_str = table.concat(output)

	print(output_str)
end