local UIConfig = CreateFrame("Frame", "GoldTracker", UIParent, "UIPanelDialogTemplate")


function UIConfig:mainFrame()
	UIConfig:SetSize(250, 120) -- Window size
	UIConfig:SetPoint("CENTER") -- Position
	UIConfig:SetMovable(true) -- Drag and drop option's
	UIConfig:EnableMouse(true) -- Drag and drop option's
	UIConfig:RegisterForDrag("LeftButton") -- Drag and drop option's
	UIConfig:SetScript("OnDragStart", UIConfig.StartMoving) -- Drag and drop option's
	UIConfig:SetScript("OnDragStop", UIConfig.StopMovingOrSizing) -- Drag and drop option's

	UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY")
	UIConfig.title:ClearAllPoints();
	UIConfig.title:SetFontObject("GameFontHighlight")
	UIConfig.title:SetPoint("LEFT", GoldTrackerTitleBG, "LEFT", 5, 0)
	UIConfig.title:SetText("GoldTracker")

	UIConfig:Show()
end

function UIConfig:CreateFont(point, relativeFrame, relativePoint, xOffset, yOffset)
    local txt = UIConfig:CreateFontString(nil, "ENCHANT")
    txt:SetFontObject("GameFontNormalLarge")
    txt:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    return txt
end

SLASH_GT1 = "/gt"
SlashCmdList["GT"] = function(arg)
   UIConfig:mainFrame()
end

local currentGold = nil
local update = nil
local signe = nil

UIConfig:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		if not GoldTrackerSV then -- Create Table if not exist
			GoldTrackerSV = {
			}
		end
		currentGold = GetMoney()
		UIConfig.start = UIConfig:CreateFont("TOPLEFT", UIConfig, "TOPLEFT", 10, -30)
		UIConfig.start:SetText("Start: " .. GetMoneyString(currentGold))
		UIConfig.currentGold = UIConfig:CreateFont("TOPLEFT", UIConfig, "TOPLEFT", 10, -45)
		UIConfig.currentGold:SetText("Current : " .. GetMoneyString(GetMoney()))
		UIConfig.updateGold = UIConfig:CreateFont("TOPLEFT", UIConfig, "TOPLEFT", 10, -75)
		UIConfig.lastSession = UIConfig:CreateFont("TOPLEFT", UIConfig, "TOPLEFT", 10, -90)
		if GoldTrackerSV[1] and GoldTrackerSV[2] ~= nil then -- Load last session informations
			UIConfig.lastSession:SetText("Last Session: " .. GoldTrackerSV[1] .. GetMoneyString(GoldTrackerSV[2]) .. "|r")
		end
	end

	if event == "PLAYER_MONEY" then
		update = GetMoney() - currentGold
		signe = nil

		if currentGold > GetMoney() then
			signe = "|cffff0000 -"
			update = math.abs(update)
		else
			signe = "|c0000ff00 +"
		end
		UIConfig.currentGold:SetText("Current : " .. GetMoneyString(GetMoney()))
		UIConfig.updateGold:SetText("Profit: " .. signe .. GetMoneyString(update) .. "|r")
	end

	if event == "PLAYER_LOGOUT" then
		if signe and update ~= nil then -- Save informations in SaveVariable
			GoldTrackerSV[1] = signe
			GoldTrackerSV[2] = update
		end
	end
end)

UIConfig:RegisterEvent("PLAYER_LOGIN")
UIConfig:RegisterEvent("PLAYER_LOGOUT")
UIConfig:RegisterEvent("PLAYER_MONEY")