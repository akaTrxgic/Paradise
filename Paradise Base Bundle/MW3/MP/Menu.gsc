menuOptions()
{
    player = self.selected_player;        
    menu = self getCurrentMenu();

    player_ID = [];
    foreach(players in level.players)
        player_ID[player_ID.size] = players.name;

    switch(menu)
    {
        case "main":
            if(self.access > 0)
            {
                self addMenu("main", "Main Menu");
                self addOpt("Submenu 1", ::newMenu, "sm1");
                self addOpt("Submenu 2", ::newMenu, "sm2");
                self addOpt("Submenu 3", ::newMenu, "sm3");
                self addOpt("Submenu 4", ::newMenu, "sm4");
                self addOpt("Submenu 5", ::newMenu, "sm5");
                self addOpt("Submenu 6", ::newMenu, "sm6");
                self addOpt("Submenu 7", ::newMenu, "sm7");
                self addOpt("Submenu 8", ::newMenu, "sm8");
                self addOpt("Submenu 9", ::newMenu, "sm9");

                if(self ishost() || self isDeveloper())
                    self addOpt("Submenu 10", ::newMenu, "sm10");
            }
            break;

        case "sm1":
            self addMenu("sm1", "Submenu 1");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            self addToggle("Option 6", self.toggleTest, ::toggletest);

            self addSliderValue("Value Slider", 0, 0, 10, 1, ::valueSliderTest);

            testInput = ["abc","def","ghi"];
            testDisplay = ["ABC","DEF","GHI"];
            self addsliderstring("String Slider", testInput, testDisplay, ::stringSliderTest);
            break;

        case "sm2":
            self addMenu("sm2", "Submenu 2");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm3":
            self addMenu("3", "Submenu 3");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm4":
            self addMenu("sm4", "Submenu 4");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm5":
            self addMenu("sm5", "Submenu 5");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm6":
            self addMenu("sm6", "Submenu 6");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm7":
            self addMenu("sm7", "Submenu 7");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm8":
            self addMenu("sm8", "Submenu 8");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm9":
            self addMenu("sm9", "Submenu 9");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;

        case "sm10":
            self addMenu("sm10", "Submenu 10");
            self addOpt("Option 1", ::test);
            self addOpt("Option 2", ::test);
            self addOpt("Option 3", ::test);
            self addOpt("Option 4", ::test);
            self addOpt("Option 5", ::test);
            break;
    }
    self clientOptions();
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

        self.menu["UI"]["MENU_TITLE"] = self createtext("objective", 2, "TOPLEFT", "CENTER", self.presets["X"] + 109, self.presets["Y"] - 105, 5, 1, level.MenuName, self.presets["MenuTitle_Color"]);
        self.menu["UI"]["OPT_BG"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 70, 204, 182, self.presets["Option_BG"], "white", 1, 1);    
        self.menu["UI"]["OUTLINE"] = self createRectangle("TOPLEFT", "CENTER", self.presets["X"] + 56.4, self.presets["Y"] - 121.5, 204, 234, self.presets["Outline_BG"], "white", 0, .7); 
        self.menu["UI"]["SCROLLER"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 57.6, self.presets["Y"] - 108, 200, 10, self.presets["Scroller_BG"], self.presets["Scroller_Shader"], 2, 1);
        self.menu["UI"]["SCROLLERICON"] = self createRectangle("LEFT", "CENTER", self.presets["X"] + 45, self.presets["Y"] - 108, 10, 10, self.presets["ScrollerIcon_BG"], self.presets["Scroller_ShaderIcon"], 3, 1);
        resizeMenu();
    }