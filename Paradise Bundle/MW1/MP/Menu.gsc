test()
{

}

menuOptions()
{
    player = self.selected_player;
    menu = self getCurrentMenu();
    
    player_names = [];
    foreach(players in level.players)
        player_names[player_names.size] = players.name;

    switch(menu)
    {
        case "main":
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                self addOpt("Trickshot Menu", ::newMenu, "ts");
                self addOpt("Binds Menu", ::newMenu, "sK");
                self addOpt("Teleport Menu", ::newMenu, "tp");
                self addOpt("Class Menu", ::newMenu, "class");
                self addOpt("Afterhits Menu", ::newMenu, "afthit");
                self addOpt("Killstreak Menu", ::newMenu, "kstrks");

                if(self isHost() || self isDeveloper())
                    self addOpt("Host Options", ::newMenu, "host");
            }
            break;
            
        case "ts":
            self addMenu("ts", "Trickshot Menu");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "sK":
            self addMenu("sK", "Binds Menu");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "tp":
            self addMenu("tp", "Teleport Menu");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "class":
            self addMenu("class", "Class Menu");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "afthit":
            self addMenu("afthit", "Afterhits Menu");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "kstrks":
            self addMenu("kstrks");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        case "host":
            self addMenu("host", "Host Options");
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            self addOpt("Test", ::test);
            break;
            
        default:
            break;
    }
}

menuMonitor()
{
    self endon("disconnect");
    self endon("end_menu");

    while(self.access != 0)
    {
        if(!self.menu["isLocked"])
        {
            if(!self.menu["isOpen"])
            {
                if(self meleeButtonPressed() && self adsButtonPressed())
                {
                    self menuOpen();
                    wait .2;
                }
            }
            else
            {
                if(self adsButtonPressed() || self attackButtonPressed())
                {
                    if(!self adsButtonPressed() || !self attackButtonPressed())
                    {
                        if(!self adsButtonPressed())
                            self.menu[self getCurrentMenu() + "_cursor"] += self attackButtonPressed();
                        if(!self attackButtonPressed())
                            self.menu[self getCurrentMenu() + "_cursor"] -= self adsButtonPressed();

                        self scrollingSystem();
                        wait .25;
                    }
                }
                else if(self fragButtonPressed() || self secondaryOffhandButtonPressed())
                {
                    if(!self fragButtonPressed() || !self secondaryOffhandButtonPressed())
                    {
                        if(isDefined(self.eMenu[self getCursor()].val) || isDefined(self.eMenu[self getCursor()].ID_list))
                        {
                            if(self secondaryOffhandButtonPressed())
                                self updateSlider("L2");
                            if(self fragButtonPressed())
                                self updateSlider("R2");
                            wait .25;
                        }
                    }
                }
                else if(self useButtonPressed())
                {
                    player = self.selected_player;
                    menu = self.eMenu[self getCursor()];

                    if(isDefined(self.sliders[self getCurrentMenu() + "_" + self getCursor()]))
                    {
                        slider = self.sliders[self getCurrentMenu() + "_" + self getCursor()];
                        slider = (isDefined(menu.ID_list) ? menu.ID_list[slider] : slider);
                        player thread doOption(menu.func, slider, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);
                    }
                    else
                        player thread doOption(menu.func, menu.p1, menu.p2, menu.p3, menu.p4, menu.p5);

                    wait .05;
                    if(isDefined(menu.toggle))
                        self setMenuText();
                    if(player != self)
                        self.menu["OPT"]["MENU_TITLE"] setText(self.menuTitle + " (" + player getName() + ")");
                    wait .15;
                    if(isDefined(player.was_edited) && self isHost())
                        player.was_edited = undefined;
                }
                else if(self meleeButtonPressed())
                {
                    if(self.selected_player != self)
                    {
                        self.selected_player = self;
                        self setMenuText();
                        self refreshTitle();
                    }
                    else if(self getCurrentMenu() == "main")
                        self menuClose();
                    else
                        self newMenu();
                    wait .2;
                }
            }
        }
        wait .05;
    }
}

menuOpen()
{
    self.menu["isOpen"] = true;

    self menuOptions();
    self drawMenu();
    self drawText();
    self setMenuText();
    self updateScrollbar();
}

menuClose()
{
    self destroyAll(self.menu["UI"]);
    self destroyAll(self.menu["OPT"]);
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);
    self.menu["isOpen"] = false;
}

drawMenu()
{
    if(!isDefined(self.menu["UI"]))
        self.menu["UI"] = [];
    if(!isDefined(self.menu["UI_TOG"]))
        self.menu["UI_TOG"] = [];
    if(!isDefined(self.menu["UI_SLIDE"]))
        self.menu["UI_SLIDE"] = [];
    if(!isDefined(self.menu["UI_STRING"]))
        self.menu["UI_STRING"] = [];

    #ifdef XBOX
    self.menu["UI"]["TITLE_BG"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 95.5, 200, 47, self.presets["Title_BG"], "gradient_top", 1, 1);
    self.menu["UI"]["MENU_TITLE"] = self createText("objective", 1.8, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
    #endif
    self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);
    self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7);
    self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
    self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
    self resizeMenu();
}

drawText()
{
    self destroyAll(self.menu["OPT"]);
    if(!isDefined(self.menu["OPT"]))
        self.menu["OPT"] = [];

    for(e = 0; e < 10; e++)
    {
        self.menu["OPT"][e] = self createText("default", 1.4, "LEFT", "CENTER", self.presets["X"] + 61, self.presets["Y"] - 62 + (e * 15), 3, 1, "", self.presets["Text"]);
        self.menu["OPT"][e] settext("Test Option " + e);
    }
}

refreshTitle()
{
    self.menu["UI"]["MENU_TITLE"] settext(level.MenuName);
}

scrollingSystem()
{
    if(self getCursor() >= self.eMenu.size || self getCursor() < 0 || self getCursor() == 9)
    {
        if(self getCursor() <= 0)
            self.menu[self getCurrentMenu() + "_cursor"] = self.eMenu.size - 1;
        else if(self getCursor() >= self.eMenu.size)
            self.menu[self getCurrentMenu() + "_cursor"] = 0;
    }

    self setMenuText();
    self updateScrollbar();
}

updateScrollbar()
{
    curs = (self getCursor() >= 10) ? 9 : self getCursor();
    self.menu["UI"]["SCROLLER"].y = (self.menu["OPT"][curs].y);
    self.menu["UI"]["SCROLLERICON"].y = (self.menu["OPT"][curs].y);

    size = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height = int(15 * size);
    math = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);
    position_Y = (self.eMenu.size - 1) / ((height - 15) - math);
}

setMenuText()
{
    self endon("disconnect");
    self menuOptions();
    self resizeMenu();

    ary = (self getCursor() >= 10) ? (self getCursor() - 9) : 0;
    self destroyAll(self.menu["UI_TOG"]);
    self destroyAll(self.menu["UI_SLIDE"]);

    for(e = 0; e < 10; e++)
    {
        self.menu["OPT"][e].x = self.presets["X"] + 61;

        if(isDefined(self.eMenu[ary + e].opt))
            self.menu["OPT"][e] settext(self.eMenu[ary + e].opt);
        else
            self.menu["OPT"][e] settext("");

        if(isDefined(self.eMenu[ary + e].toggle))
        {
            self.menu["OPT"][e].x += 0;
            #ifdef XBOX
            self.menu["UI_TOG"][e + 10] = self createRectangle("CENTER", "CENTER", self.menu["OPT"][e].x + 189, self.menu["OPT"][e].y, 7, 7, (self.eMenu[ary + e].toggle) ? self.presets["Toggle_BG"] : divideColor(150, 150, 150), "white", 5, 1);
            #endif
        }
        if(isDefined(self.eMenu[ary + e].val))
        {
            self.menu["UI_SLIDE"][e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 38, 1, (0,0,0), "white", 4, 1);
            self.menu["UI_SLIDE"][e + 10] = self createRectangle("LEFT", "CENTER", self.menu["OPT"][e].x + 188, self.menu["UI_SLIDE"][e].y, 1, 6, self.presets["Toggle_BG"], "white", 5, 1);
            if(self getCursor() == (ary + e))
                self.menu["UI_SLIDE"]["VAL"] = self createText("default", 1, "RIGHT", "CENTER", self.menu["OPT"][e].x + 150, self.menu["OPT"][e].y, 5, 1, self.sliders[self getCurrentMenu() + "_" + self getCursor()] + "", self.presets["Text"]);
            self updateSlider("", e, ary + e);
        }
        if(isDefined(self.eMenu[ary + e].ID_list))
        {
            if(!isDefined(self.sliders[self getCurrentMenu() + "_" + (ary + e)]))
                self.sliders[self getCurrentMenu() + "_" + (ary + e)] = 0;

            self.menu["UI_SLIDE"]["STRING_" + e] = self createText("default", 1.4, "RIGHT", "CENTER", self.menu["OPT"][e].x + 193, self.menu["OPT"][e].y, 6, 1, "", self.presets["Text"]);
            self updateSlider("", e, ary + e);
        }
        if(self.eMenu[ary + e].func == ::newMenu && isDefined(self.eMenu[ary + e].func))
        {
            self.menu["UI_SLIDE"]["SUBMENU" + e] = self createRectangle("RIGHT", "CENTER", self.menu["OPT"][e].x + 196, self.menu["OPT"][e].y, 9, 9, self.presets["Toggle_BG"], "ui_arrow_right", 5, 1);
            self.menu["UI_SLIDE"]["SUBMENU" + e].foreground = true;
        }
    }
}

resizeMenu()
{
    size = (self.eMenu.size >= 10) ? 10 : self.eMenu.size;
    height = int(15 * size);
    math = (self.eMenu.size > 10) ? ((180 / self.eMenu.size) * size) : (height - 15);

    self.menu["UI"]["OPT_BG"] setShader("white", 200, height + 1);
    self.menu["UI"]["OUTLINE"] setShader("white", 204, height + 54);
}