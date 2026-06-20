local Window = _G.NiggerWindow
local GameTab = _G.NiggerGameTab

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

GameTab:Section({
    Title = "Protection",
    Box = false,
    TextXAlignment = "Center",
    TextSize = 17, -- Default Size
    Opened = true,
    TextTransparency = 0.05,    
})

GameTab:Divider()

local function ChangeTitle(VarName, Text)
    if VarName.SetTitle then
        VarName:SetTitle(tostring(Text))
    else
        print(tostring(VarName).."'s Title Cannot Be Set Because Its Not A Fetaure Of WindUI")
    end
end

local Moderators = {"Offmetades1", "mousti007", "ism",
"aboveke", "bonkours","LeaveMeAloneImWeak","nocteun",
"Denis54053", "vidhabibi","Jacinyp","DarkAngel061274",
"ethen121212", "seizedmycrypto", "hamza2vd", "PolarRite",
"zynrn2", "derekphobia", "Maybe_Ashton","linkplays3000",
"joelprinz1", "Central_Nation", "jpop", "munchkinstorms",
"catchitoo", "levelcapped", "ryleeforeveryes","ttm","hatetana",
"ForgetKas", "zyweis", "Itsjszz", "iftk", "noctovoData",
"Hermentic", "xyuv", "Joesefezprime", "AresEchoh",
"Kalinka_Dev", "Devdeath_2", "luaClass", "TencellStudiosData1", "Jaaay64",
"benther123", "triixys", "tokyohorror", "Ayumarex",
"AdrianMartinezSmith", "NiBiriBotaKEK", "miscolor",
"InvestingEthereum", "AimFromFG", "AgharX", "hadizera",
"Alyperia", "ChristosGC", "tridazer", "lonnielovesrylee",
"EpicKingCelestial", "daffodilswarm", "GangstaBanana", "YoungRelli",
"OVOBoyNYC", "BBDotplay", "DasPariet", "Primeheide",
"thebossinnicaragua", "kareemsalvatore","levelcapped",
"claudecoding", "MeloInteractive", "bytemelo"
}

local LeaveWhenModToggle
local LWMTState = false

LeaveWhenModToggle = GameTab:Toggle({
    Title = "Auto Leave: Off",
    Callback = function(state)
        print("Auto Leave:", state)
        LWMTState = state

        for i, player in ipairs(Players:GetPlayers()) do
            if table.find(Moderators, player.Name) then
                Player:Kick("Mod Detected!: "..player.Name)
            end
        end

        if state then    
            ChangeTitle(LeaveWhenModToggle, "Auto Leave: On")
        else
            ChangeTitle(LeaveWhenModToggle, "Auto Leave: Off")
        end

    end
})

Players.PlayerAdded:Connect(function(player)
    if LWMTState then
        if table.find(Moderators, player.Name) then
             Player:Kick("Mod Detected!: "..player.Name)
        end
    end
end)
