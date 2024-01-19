ESX = exports["es_extended"]:getSharedObject()

lib.callback.register('frp-witwas:switch', function(source, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem("black_money")
	lib.print.info(data)
	lib.print.info(xItem.count)
    if xItem.count < 0 then
        return false
    else
        local profit = math.floor(xItem.count * 1.0)
        xPlayer.removeInventoryItem(Config.ITEMS.remove, xItem.count)
        xPlayer.addAccountMoney(Config.ITEMS.add, profit)
        return profit
    end
end)

