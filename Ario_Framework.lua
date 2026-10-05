-- ARIO Framework v3
-- Mobile-first Roblox/Luau UI framework
-- API: local Ario = loadstring(game:HttpGet("RAW_URL"))(); Ario.new({...})

local Ario = {}
Ario.__index = Ario
Ario.Name = "Ario"
Ario.Version = "3.0.0"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

Ario.Themes = {
    Ario={A=Color3.fromRGB(55,120,255),A2=Color3.fromRGB(105,170,255),BG=Color3.fromRGB(7,10,17),C=Color3.fromRGB(15,20,31),C2=Color3.fromRGB(23,30,45),I=Color3.fromRGB(18,25,39),S=Color3.fromRGB(50,66,96),T=Color3.fromRGB(245,248,255),M=Color3.fromRGB(145,157,181),OK=Color3.fromRGB(65,220,135),W=Color3.fromRGB(255,190,70),E=Color3.fromRGB(255,82,105)},
    Midnight={A=Color3.fromRGB(126,92,255),A2=Color3.fromRGB(190,155,255),BG=Color3.fromRGB(7,6,14),C=Color3.fromRGB(17,14,29),C2=Color3.fromRGB(28,23,45),I=Color3.fromRGB(24,20,40),S=Color3.fromRGB(69,57,104),T=Color3.fromRGB(248,246,255),M=Color3.fromRGB(163,155,188),OK=Color3.fromRGB(80,225,145),W=Color3.fromRGB(255,190,75),E=Color3.fromRGB(255,88,120)},
    Cyan={A=Color3.fromRGB(0,205,255),A2=Color3.fromRGB(100,240,255),BG=Color3.fromRGB(5,13,18),C=Color3.fromRGB(10,24,31),C2=Color3.fromRGB(15,36,46),I=Color3.fromRGB(13,32,41),S=Color3.fromRGB(33,91,108),T=Color3.fromRGB(240,252,255),M=Color3.fromRGB(137,178,190),OK=Color3.fromRGB(75,230,155),W=Color3.fromRGB(255,195,80),E=Color3.fromRGB(255,85,110)},
    Ruby={A=Color3.fromRGB(255,58,92),A2=Color3.fromRGB(255,125,145),BG=Color3.fromRGB(16,7,10),C=Color3.fromRGB(28,13,18),C2=Color3.fromRGB(42,19,27),I=Color3.fromRGB(38,17,24),S=Color3.fromRGB(91,38,53),T=Color3.fromRGB(255,244,247),M=Color3.fromRGB(190,145,155),OK=Color3.fromRGB(75,225,145),W=Color3.fromRGB(255,190,70),E=Color3.fromRGB(255,65,90)},
    Emerald={A=Color3.fromRGB(45,220,135),A2=Color3.fromRGB(105,255,180),BG=Color3.fromRGB(5,15,11),C=Color3.fromRGB(10,27,20),C2=Color3.fromRGB(16,40,30),I=Color3.fromRGB(14,37,27),S=Color3.fromRGB(34,92,65),T=Color3.fromRGB(239,255,247),M=Color3.fromRGB(137,181,158),OK=Color3.fromRGB(55,235,145),W=Color3.fromRGB(255,195,75),E=Color3.fromRGB(255,82,105)},
    Orange={A=Color3.fromRGB(255,135,45),A2=Color3.fromRGB(255,190,100),BG=Color3.fromRGB(17,10,5),C=Color3.fromRGB(30,18,9),C2=Color3.fromRGB(45,26,13),I=Color3.fromRGB(42,25,12),S=Color3.fromRGB(96,53,24),T=Color3.fromRGB(255,248,238),M=Color3.fromRGB(190,157,125),OK=Color3.fromRGB(70,225,140),W=Color3.fromRGB(255,190,60),E=Color3.fromRGB(255,80,95)},
    Rose={A=Color3.fromRGB(255,85,175),A2=Color3.fromRGB(255,145,210),BG=Color3.fromRGB(16,7,14),C=Color3.fromRGB(29,12,25),C2=Color3.fromRGB(43,18,37),I=Color3.fromRGB(41,17,35),S=Color3.fromRGB(99,39,82),T=Color3.fromRGB(255,244,252),M=Color3.fromRGB(190,145,175),OK=Color3.fromRGB(70,225,145),W=Color3.fromRGB(255,190,75),E=Color3.fromRGB(255,80,115)},
    Mono={A=Color3.fromRGB(235,235,240),A2=Color3.fromRGB(255,255,255),BG=Color3.fromRGB(8,8,10),C=Color3.fromRGB(17,17,20),C2=Color3.fromRGB(29,29,34),I=Color3.fromRGB(24,24,28),S=Color3.fromRGB(62,62,70),T=Color3.fromRGB(248,248,250),M=Color3.fromRGB(150,150,158),OK=Color3.fromRGB(130,235,165),W=Color3.fromRGB(240,195,95),E=Color3.fromRGB(255,105,120)},
    Neon={A=Color3.fromRGB(125,255,0),A2=Color3.fromRGB(210,255,120),BG=Color3.fromRGB(5,10,4),C=Color3.fromRGB(12,23,8),C2=Color3.fromRGB(20,39,13),I=Color3.fromRGB(17,32,11),S=Color3.fromRGB(48,91,26),T=Color3.fromRGB(245,255,235),M=Color3.fromRGB(150,180,125),OK=Color3.fromRGB(125,255,80),W=Color3.fromRGB(255,210,75),E=Color3.fromRGB(255,80,90)},
    DeepSea={A=Color3.fromRGB(40,125,255),A2=Color3.fromRGB(90,210,255),BG=Color3.fromRGB(3,10,17),C=Color3.fromRGB(7,19,30),C2=Color3.fromRGB(10,29,45),I=Color3.fromRGB(9,27,42),S=Color3.fromRGB(22,67,96),T=Color3.fromRGB(237,249,255),M=Color3.fromRGB(125,165,188),OK=Color3.fromRGB(60,225,155),W=Color3.fromRGB(255,195,75),E=Color3.fromRGB(255,85,105)},
    Sunset={A=Color3.fromRGB(255,90,70),A2=Color3.fromRGB(255,175,75),BG=Color3.fromRGB(17,8,8),C=Color3.fromRGB(30,14,12),C2=Color3.fromRGB(44,21,17),I=Color3.fromRGB(42,19,15),S=Color3.fromRGB(100,43,31),T=Color3.fromRGB(255,247,241),M=Color3.fromRGB(192,151,133),OK=Color3.fromRGB(70,225,140),W=Color3.fromRGB(255,185,65),E=Color3.fromRGB(255,75,80)},
    Frost={A=Color3.fromRGB(110,205,255),A2=Color3.fromRGB(210,245,255),BG=Color3.fromRGB(8,13,17),C=Color3.fromRGB(17,25,31),C2=Color3.fromRGB(25,37,45),I=Color3.fromRGB(23,34,42),S=Color3.fromRGB(65,91,105),T=Color3.fromRGB(245,252,255),M=Color3.fromRGB(153,179,191),OK=Color3.fromRGB(80,225,160),W=Color3.fromRGB(255,200,80),E=Color3.fromRGB(255,90,110)}
}

local function tw(o,t,p,s,d) local x=TweenService:Create(o,TweenInfo.new(t or .25,s or Enum.EasingStyle.Quint,d or Enum.EasingDirection.Out),p);x:Play();return x end
local function cr(o,r)local x=Instance.new("UICorner");x.CornerRadius=UDim.new(0,r or 10);x.Parent=o;return x end
local function st(o,c,tr)local x=Instance.new("UIStroke");x.Color=c;x.Transparency=tr or 0;x.Thickness=1;x.Parent=o;return x end
local function truth(v)return v==true or tostring(v):lower()=="true" end
local function cb(f,...)if type(f)=="function" then task.spawn(function(...)local ok,e=pcall(f,...);if not ok then warn("[ARIO]",e)end end,...)end end
local function theme(n)for k in pairs(Ario.Themes)do if k:lower()==tostring(n or "Ario"):lower()then return k end end;return "Ario"end

function Ario:Notify(x)
    x=type(x)=="table" and x or {Content=tostring(x)}
    if not self.Notifs then return end
    local typ=x.Type or "info"
    local color=typ=="success" and self.C.OK or typ=="warning" and self.C.W or typ=="error" and self.C.E or self.C.A
    local n=Instance.new("TextButton")
    n.AutoButtonColor=false;n.Text="";n.BackgroundColor3=self.C.C;n.Size=UDim2.new(1,0,0,66);n.Parent=self.Notifs;cr(n,12);st(n,self.C.S,.25)
    local b=Instance.new("Frame");b.BackgroundColor3=color;b.BorderSizePixel=0;b.Position=UDim2.new(0,8,0,10);b.Size=UDim2.new(0,4,1,-20);b.Parent=n;cr(b,3)
    local a=Instance.new("TextLabel");a.BackgroundTransparency=1;a.Text=x.Title or "ARIO";a.TextColor3=self.C.T;a.TextSize=14;a.Font=Enum.Font.GothamBold;a.TextXAlignment=Enum.TextXAlignment.Left;a.Position=UDim2.new(0,23,0,8);a.Size=UDim2.new(1,-30,0,20);a.Parent=n
    local m=Instance.new("TextLabel");m.BackgroundTransparency=1;m.Text=x.Content or x.Message or "";m.TextColor3=self.C.M;m.TextSize=12;m.Font=Enum.Font.Gotham;m.TextXAlignment=Enum.TextXAlignment.Left;m.TextTruncate=Enum.TextTruncate.AtEnd;m.Position=UDim2.new(0,23,0,31);m.Size=UDim2.new(1,-30,0,20);m.Parent=n
    n.Position=UDim2.new(1,30,0,0);tw(n,.35,{Position=UDim2.new(0,0,0,0)})
    local closed=false
    local function close()if closed then return end;closed=true;tw(n,.25,{Position=UDim2.new(1,30,0,0),BackgroundTransparency=1});task.delay(.27,function()if n then n:Destroy()end end)end
    n.MouseButton1Click:Connect(close);task.delay(x.Duration or 3.5,close)
    return {Close=close,Instance=n}
end

function Ario:_drag(handle,obj)
    local drag=false;local start;local pos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true;start=i.Position;pos=obj.Position
            i.Changed:Connect(function()if i.UserInputState==Enum.UserInputState.End then drag=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then
            local d=i.Position-start
            obj.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
        end
    end)
end

function Ario:ChangeTheme(n)
    n=theme(n);self.ThemeName=n;self.C=Ario.Themes[n]
    self:Notify({Title="Theme Changed",Content=n,Type="success"})
    cb(self.Config.OnThemeChanged,n)
end

function Ario:AddTab(name)
    name=type(name)=="table" and (name.Name or name.Title) or name or "Tab"
    if self.Tabs[name]then return self.Tabs[name]end
    local b=Instance.new("TextButton");b.AutoButtonColor=false;b.Text=name;b.TextColor3=self.C.M;b.TextSize=12;b.Font=Enum.Font.GothamMedium;b.BackgroundTransparency=1;b.Size=UDim2.new(0,90,1,0);b.Parent=self.TabBar
    local p=Instance.new("ScrollingFrame");p.BackgroundTransparency=1;p.BorderSizePixel=0;p.Size=UDim2.fromScale(1,1);p.Visible=false;p.ScrollBarThickness=3;p.ScrollBarImageColor3=self.C.A;p.Parent=self.Pages
    local l=Instance.new("UIListLayout");l.Padding=UDim.new(0,9);l.Parent=p
    local pad=Instance.new("UIPadding");pad.PaddingTop=UDim.new(0,3);pad.PaddingBottom=UDim.new(0,12);pad.Parent=p
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()p.CanvasSize=UDim2.new(0,0,0,l.AbsoluteContentSize.Y+20)end)
    b.MouseButton1Click:Connect(function()self:SelectTab(name)end)
    self.Tabs[name]={Button=b,Page=p}
    if not self.CurrentTab then self:SelectTab(name)end
    return p
end

function Ario:SelectTab(name)
    for n,t in pairs(self.Tabs)do t.Page.Visible=n==name;tw(t.Button,.15,{TextColor3=n==name and self.C.T or self.C.M})end
    self.CurrentTab=name
end

function Ario:AddButton(tab,data)
    local t=self.Tabs[tab];if not t then return end;data=data or {}
    local b=Instance.new("TextButton");b.AutoButtonColor=false;b.Text=data.Title or data.Name or "Button";b.TextColor3=self.C.T;b.TextSize=13;b.Font=Enum.Font.GothamMedium;b.BackgroundColor3=self.C.C2;b.Size=UDim2.new(1,0,0,43);b.Parent=t.Page;cr(b,10);st(b,self.C.S,.3)
    b.MouseEnter:Connect(function()tw(b,.15,{BackgroundColor3=self.C.I})end);b.MouseLeave:Connect(function()tw(b,.15,{BackgroundColor3=self.C.C2})end);b.MouseButton1Click:Connect(function()cb(data.Callback)end)
    return b
end

function Ario:AddParagraph(tab,data)
    local t=self.Tabs[tab];if not t then return end;data=data or {}
    local f=Instance.new("Frame");f.BackgroundColor3=self.C.C;f.Size=UDim2.new(1,0,0,72);f.Parent=t.Page;cr(f,12);st(f,self.C.S,.35)
    local a=Instance.new("TextLabel");a.BackgroundTransparency=1;a.Text=data.Title or "ARIO";a.TextColor3=self.C.T;a.TextSize=14;a.Font=Enum.Font.GothamBold;a.TextXAlignment=Enum.TextXAlignment.Left;a.Position=UDim2.new(0,14,0,9);a.Size=UDim2.new(1,-28,0,20);a.Parent=f
    local m=Instance.new("TextLabel");m.BackgroundTransparency=1;m.Text=data.Content or data.Description or "";m.TextColor3=self.C.M;m.TextSize=12;m.Font=Enum.Font.Gotham;m.TextWrapped=true;m.TextXAlignment=Enum.TextXAlignment.Left;m.Position=UDim2.new(0,14,0,32);m.Size=UDim2.new(1,-28,0,30);m.Parent=f
    return f
end

function Ario:AddKeyInput(tab,data)
    local t=self.Tabs[tab];if not t then return end;data=data or {}
    local x=Instance.new("TextBox");x.BackgroundColor3=self.C.I;x.TextColor3=self.C.T;x.PlaceholderColor3=self.C.M;x.PlaceholderText=data.Placeholder or "Enter key...";x.Text=data.Default or "";x.TextSize=13;x.Font=Enum.Font.Gotham;x.ClearTextOnFocus=false;x.Size=UDim2.new(1,0,0,44);x.Parent=t.Page;cr(x,10);st(x,self.C.S,.3)
    x.FocusLost:Connect(function(enter)if enter then cb(data.Callback,x.Text)end end);return x
end

function Ario:_keyValid(k)
    local ks=self.Config.KeySystem or {};local keys=ks.Key or ks.Keys or {}
    if type(keys)=="string"then keys={keys}end
    for _,v in ipairs(keys)do if tostring(v)==tostring(k)then return true end end
    return false
end

function Ario:_keyScreen()
    local h=Instance.new("Frame");h.BackgroundTransparency=1;h.Size=UDim2.fromScale(1,1);h.ZIndex=50;h.Parent=self.Pages
    local c=Instance.new("Frame");c.AnchorPoint=Vector2.new(.5,.5);c.Position=UDim2.fromScale(.5,.52);c.Size=UDim2.new(0,370,0,245);c.BackgroundColor3=self.C;c.ZIndex=51;c.Parent=h;cr(c,17);st(c,self.C.S,.1)
    local s=Instance.new("UIScale");s.Scale=.85;s.Parent=c;tw(s,.45,{Scale=1})
    local title=Instance.new("TextLabel");title.BackgroundTransparency=1;title.Text=self.Config.Description or "Key System";title.TextColor3=self.C.T;title.TextSize=21;title.Font=Enum.Font.GothamBold;title.TextXAlignment=Enum.TextXAlignment.Left;title.Position=UDim2.new(0,22,0,18);title.Size=UDim2.new(1,-44,0,30);title.Parent=c
    local sub=Instance.new("TextLabel");sub.BackgroundTransparency=1;sub.Text="Enter your ARIO key to continue.";sub.TextColor3=self.C.M;sub.TextSize=12;sub.Font=Enum.Font.Gotham;sub.TextXAlignment=Enum.TextXAlignment.Left;sub.Position=UDim2.new(0,22,0,50);sub.Size=UDim2.new(1,-44,0,25);sub.Parent=c
    local x=Instance.new("TextBox");x.BackgroundColor3=self.C.I;x.TextColor3=self.C.T;x.PlaceholderColor3=self.C.M;x.PlaceholderText="Enter key...";x.TextSize=13;x.Font=Enum.Font.Gotham;x.ClearTextOnFocus=false;x.Position=UDim2.new(0,22,0,86);x.Size=UDim2.new(1,-44,0,45);x.Parent=c;cr(x,10);st(x,self.C.S,.2)
    local go=Instance.new("TextButton");go.AutoButtonColor=false;go.Text="VERIFY KEY";go.TextColor3=Color3.new(1,1,1);go.TextSize=13;go.Font=Enum.Font.GothamBold;go.BackgroundColor3=self.C.A;go.Position=UDim2.new(0,22,0,143);go.Size=UDim2.new(1,-44,0,42);go.Parent=c;cr(go,10)
    local status=Instance.new("TextLabel");status.BackgroundTransparency=1;status.Text="";status.TextSize=12;status.Font=Enum.Font.Gotham;status.Position=UDim2.new(0,22,0,191);status.Size=UDim2.new(1,-44,0,24);status.Parent=c
    local busy=false
    local function verify()
        if busy then return end;busy=true;go.Text="CHECKING..."
        if self:_keyValid(x.Text)then
            status.Text="Key accepted!";status.TextColor3=self.C.OK
            self:Notify({Title="Key Accepted",Content="Welcome to ARIO.",Type="success"})
            task.wait(.4);tw(c,.3,{Position=UDim2.fromScale(.5,.56),BackgroundTransparency=1});task.wait(.32);h:Destroy();self.KeyPassed=true;cb(self.Config.Callback,x.Text)
        else
            status.Text="Invalid key.";status.TextColor3=self.C.E;go.Text="TRY AGAIN";tw(c,.07,{Position=UDim2.fromScale(.47,.52)});task.wait(.07);tw(c,.07,{Position=UDim2.fromScale(.53,.52)});task.wait(.07);tw(c,.07,{Position=UDim2.fromScale(.5,.52)});busy=false
        end
    end
    go.MouseButton1Click:Connect(verify);x.FocusLost:Connect(function(e)if e then verify()end end)
end

function Ario:Destroy()if self.Gui then self.Gui:Destroy()end end

function Ario.new(config)
    config=config or {};local self=setmetatable({},Ario);self.Config=config;self.ThemeName=theme(config.Theme);self.C=Ario.Themes[self.ThemeName];self.Tabs={};self.KeyPassed=false
    if config.SupportedGames and config.SupportedGames[game.PlaceId]==false then return self end
    local g=Instance.new("ScreenGui");g.Name="Ario_"..tostring(config.Folder or "UI");g.ResetOnSpawn=false;g.IgnoreGuiInset=true;g.Parent=PlayerGui;self.Gui=g
    local r=Instance.new("Frame");r.BackgroundTransparency=1;r.Size=UDim2.fromScale(1,1);r.Parent=g;self.Root=r
    local w=Instance.new("Frame");w.AnchorPoint=Vector2.new(.5,.5);w.Position=UDim2.fromScale(.5,.54);w.Size=UDim2.new(0,570,0,390);w.BackgroundColor3=self.C.BG;w.Parent=r;cr(w,18);st(w,self.C.S,.15);self.Window=w
    local sc=Instance.new("UIScale");sc.Scale=.82;sc.Parent=w;tw(sc,.5,{Scale=1})
    self:_drag(w,w)
    local top=Instance.new("Frame");top.BackgroundTransparency=1;top.Position=UDim2.new(0,12,0,8);top.Size=UDim2.new(1,-24,0,60);top.Parent=w
    local title=Instance.new("TextLabel");title.BackgroundTransparency=1;title.Text=config.Title or "Ario";title.TextColor3=self.C.T;title.TextSize=20;title.Font=Enum.Font.GothamBold;title.TextXAlignment=Enum.TextXAlignment.Left;title.Position=UDim2.new(0,10,0,5);title.Size=UDim2.new(1,-60,0,27);title.Parent=top
    local desc=Instance.new("TextLabel");desc.BackgroundTransparency=1;desc.Text=config.Description or "Premium Interface";desc.TextColor3=self.C.M;desc.TextSize=11;desc.Font=Enum.Font.Gotham;desc.TextXAlignment=Enum.TextXAlignment.Left;desc.Position=UDim2.new(0,10,0,32);desc.Size=UDim2.new(1,-60,0,18);desc.Parent=top
    local close=Instance.new("TextButton");close.AutoButtonColor=false;close.Text="×";close.TextColor3=self.C.M;close.TextSize=24;close.BackgroundColor3=self.C.C;close.Position=UDim2.new(1,-45,0,6);close.Size=UDim2.new(0,36,0,36);close.Parent=top;cr(close,10);close.MouseButton1Click:Connect(function()self:Destroy()end)
    local tb=Instance.new("Frame");tb.BackgroundColor3=self.C.C;tb.Position=UDim2.new(0,16,0,75);tb.Size=UDim2.new(1,-32,0,42);tb.Parent=w;cr(tb,11);self.TabBar=tb
    local tl=Instance.new("UIListLayout");tl.FillDirection=Enum.FillDirection.Horizontal;tl.Parent=tb
    local pages=Instance.new("Frame");pages.BackgroundTransparency=1;pages.Position=UDim2.new(0,16,0,125);pages.Size=UDim2.new(1,-32,1,-141);pages.Parent=w;self.Pages=pages
    local nf=Instance.new("Frame");nf.BackgroundTransparency=1;nf.AnchorPoint=Vector2.new(1,1);nf.Position=UDim2.new(1,-15,1,-15);nf.Size=UDim2.new(0,300,0,300);nf.Parent=r;local nl=Instance.new("UIListLayout");nl.VerticalAlignment=Enum.VerticalAlignment.Bottom;nl.HorizontalAlignment=Enum.HorizontalAlignment.Right;nl.Padding=UDim.new(0,6);nl.Parent=nf;self.Notifs=nf
    self:AddTab("Home");self:AddParagraph("Home",{Title="Welcome to "..(config.Title or "ARIO"),Content="Mobile-first interface powered by ARIO."})
    self:AddTab("Settings");self:AddParagraph("Settings",{Title="Theme System",Content="Choose a theme below."})
    for n in pairs(Ario.Themes)do self:AddButton("Settings",{Title=n,Callback=function()self:ChangeTheme(n)end})end
    if config.Intro then
        local o=Instance.new("Frame");o.BackgroundColor3=self.C.BG;o.Size=UDim2.fromScale(1,1);o.ZIndex=100;o.Parent=r
        local l=Instance.new("TextLabel");l.BackgroundTransparency=1;l.AnchorPoint=Vector2.new(.5,.5);l.Position=UDim2.fromScale(.5,.48);l.Size=UDim2.new(0,300,0,60);l.Text="ARIO";l.TextColor3=self.C.T;l.TextSize=46;l.Font=Enum.Font.GothamBlack;l.TextTransparency=1;l.ZIndex=101;l.Parent=o;tw(l,.5,{TextTransparency=0});task.wait(config.IntroDuration or 1.2);tw(l,.3,{TextTransparency=1});task.wait(.32);o:Destroy()
    end
    if config.KeySystem and (config.KeySystem.Key or config.KeySystem.Keys) then task.spawn(function()self:_keyScreen()end)else self.KeyPassed=true;cb(config.Callback)end
    self:Notify({Title="ARIO",Content="Interface loaded.",Type="success",Duration=2.5})
    return self
end

function Ario.GetThemes()local x={}for n in pairs(Ario.Themes)do x[#x+1]=n end;table.sort(x);return x end
function Ario.GetVersion()return Ario.Version end

return Ario
