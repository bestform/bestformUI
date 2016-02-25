
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
        name, link, rarity, iLevel, _, class, _, _, equipSlot, _, price = GetItemInfo(itemID)
        if rarity == 0 then
          stack = (price or 0) * (count or 1)
          sold = sold + stack
          UseContainerItem(bag, slot)
        elseif price > 0 then
          print("You might want to sell " .. link .. " for " .. GetCoinTextureString(price))
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
  if sold > 0 then
    print("Sold for: " .. GetCoinTextureString(sold))
  else
    print("Did not sell anything")
  end
  if repaired then
    print("Repaired for " .. GetCoinTextureString(repairCost))
    print("Earned/Lost: " .. GetCoinTextureString(sold - repairCost))
  end
end


-- Slash commands

SLASH_BUINET1 = "/buinet"

local function ShowNetworkStats()
  bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
  print("bandwidthIn: " .. bandwidthIn)
  print("bandwidthOut: " .. bandwidthOut)
  print("latencyHome: " .. latencyHome)
  print("latencyWorld: " .. latencyWorld)
end

function SlashCmdList.BUINET(msg, editbox)
  ShowNetworkStats()
end


frame:SetScript("OnEvent", Autosell)
