    LoadSettings()
    {
        self.presets = [];

        self.presets["X"] = int( self LoadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self LoadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self LoadPreset( "menuColorRed", "160" ) );
        self.presets["G"] = int( self LoadPreset( "menuColorGreen", "50" ) );
        self.presets["B"] = int( self LoadPreset( "menuColorBlue", "50" ) );
        self.presets["BindOne"] = self loadPreset( "menuBindOne", "+speed_throw" );
        self.presets["BindTwo"] = self loadPreset( "menuBindTwo", "+melee" );

        self.presets["Option_BG"] = dividecolor(27, 27, 29);
        self.presets["Outline_BG"] = dividecolor(27, 27, 29);
        self.presets["Title_BG"] = dividecolor(255, 255, 255); 
        self.presets["Text"] = dividecolor(255, 255, 255);
        self.presets["Option_Font"] = "default";
        self.presets["Font_Scale"] = 1;
        self.presets["Toggle_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["MenuTitle_Color"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_Shader"] = "hudsoftline";
    }

    bindButtonPressed( button )
    {
        switch( button )
        {
            case "+speed_throw": return self AdsButtonPressed();
            case "+smoke": return self SecondaryOffhandButtonPressed();
            case "+attack": return self AttackButtonPressed();
            case "+frag": return self FragButtonPressed();
            case "+melee": return self MeleeButtonPressed();

            default: return;
        }
    }

    loadPreset( dvar, defaultVal )
    {
        value = self getPlayerCustomDvar( dvar );

        if( value == "" )
            return defaultVal;

        return value;
    }

    updatePreset( value, dvar )
    {
        current = self getPlayerCustomDvar( dvar );

        if( current != value + "" )
        {
            self setPlayerCustomDvar( dvar, value + "" );
            wait .02;
            self LoadSettings();
            self refreshMenu();
        }
    }

    refreshMenu()
    {
        if(!self hasMenu())
            return false;
            
        if(self isMenuOpen())
        { 
            current  = self getCurrentMenu();
            previous = self.previousMenu;
            for(e = previous.size; e > 0; e--)
            {
                self newMenu();
                wait .05;
                waittillframeend;
            }
            self menuClose(); 
            self.menu["isLocked"] = true;
        }
        
        wait .05;
        
        self menuOpen();
        if(IsDefined( previous ))
        {
            foreach( menu in previous )
            {
                if( menu != "main" )
                    self newMenu( menu );
            }
            self newMenu( current );
            self.menu["isLocked"] = false;
        }
    }

    toggleAlmostHits()
    {
        if( self getplayercustomdvar( "almostHits" ) == "1" )
            self setplayerCustomDvar( "almostHits", "0" );

        else
            self setplayercustomdvar( "almostHits", "1" );
    }

    toggleDistanceMsg()
    {
        if( self getplayercustomdvar( "showDistance" ) == "1" )
            self setplayerCustomDvar( "showDistance", "0" );

        else
            self setplayercustomdvar( "showDistance", "1" );
    }