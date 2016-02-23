
local frame = CreateFrame("FRAME", "bestformUIFrame")
frame:RegisterEvent("MERCHANT_SHOW")

-- Part of the Autosell code is based on the work of Lars Norberg for his Goldpaw's UI addons
local function Autosell(self, event, ...)
  print("bestformUI autosell")
  local sold = 0
  for bag = 0, 4, 1 do
    for slot = 1, GetContainerNumSlots(bag), 1 do
      itemID = GetContainerItemID(bag, slot)
      if itemID then
        count = select(2, GetContainerItemInfo(bag, slot))
        _, link, rarity, _, _, _, _, _, _, _, price = GetItemInfo(itemID)
        if rarity == 0 then
          stack = (price or 0) * (count or 1)
          sold = sold + stack
          UseContainerItem(bag, slot)
        end
      end
    end
  end
  local repairCost = select(1, GetRepairAllCost()) or 0
  local repaired = false
  if CanMerchantRepair() and repairCost > 0 and GetMoney() > repairCost then
    RepairAllItems()
    repaired = true
  end
  print("Sold for: " .. GetCoinTextureString(sold))
  if repaired then
    print("Repaired for " .. GetCoinTextureString(repairCost))
    print("Earned: " .. GetCoinTextureString(sold - repairCost))
  end
end

frame:SetScript("OnEvent", Autosell)
