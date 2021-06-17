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
RegisterServerEvent("stores:addInventoryItem")
AddEventHandler("stores:addInventoryItem",function(xPlayer,item,amount)
    xPlayer.Functions.AddItem(item, amount)
    TriggerClientEvent('inventory:client:ItemBox', xPlayer.PlayerData.source, QBCore.Shared.Items[item], "add")
end)