    LoadSettings()
    {
        self.presets = [];
        self.presets["X"] = int( self loadPreset( "menuPosX", "155" ) );
        self.presets["Y"] = int( self loadPreset( "menuPosY", "-20" ) );
        self.presets["R"] = int( self loadPreset( "menuColorRed", "255" ) );
        self.presets["G"] = int( self loadPreset( "menuColorGreen", "107" ) );
        self.presets["B"] = int( self loadPreset( "menuColorBlue", "45" ) );
        self.presets["BindOne"] = self loadPreset( "menuBindOne", "+speed_throw" );
        self.presets["BindTwo"] = self loadPreset( "menuBindTwo", "+actionslot 2" );

        self.presets["Option_BG"] = dividecolor(27, 27, 29);
        self.presets["Outline_BG"] = dividecolor(27, 27, 29);
        self.presets["Title_BG"] = dividecolor(255, 255, 255); 
        self.presets["Text"] = dividecolor(255, 255, 255);
        self.presets["Option_Font"] = "default";
        self.presets["Font_Scale"] = 1;
        self.presets["Toggle_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["MenuTitle_Color"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_BG"] = dividecolor(self.presets["R"], self.presets["G"], self.presets["B"]);
        self.presets["Scroller_Shader"] = "white";
    }

    bindButtonPressed( button )
    {
        if( isDefined( button ) )
        {
            switch( button )
            {
                case "+speed_throw": return self AdsButtonPressed();
                case "+smoke": return self SecondaryOffhandButtonPressed();
                case "+attack": return self AttackButtonPressed();
                case "+frag": return self FragButtonPressed();
                case "+melee": return self MeleeButtonPressed();
                case "+actionslot 1": return self ActionSlotOneButtonPressed();
                case "+actionslot 2": return self ActionSlotTwoButtonPressed();
                case "+actionslot 3": return self ActionSlotThreeButtonPressed();
                case "+actionslot 4": return self ActionSlotFourButtonPressed();

                default: return;
            }
        }
    }

    loadPreset( dvar, defaultVal )
    {
        if( isDefined( dvar ) )
        {
            value = self getPlayerCustomDvar( dvar );

            if( value == "" )
            {
                self setPlayerCustomDvar( dvar, defaultVal );
                return defaultVal;
            }
            
            return value;
        }
    }

    updatePreset( value, dvar )
    {
        if( isDefined( value ) )
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
                self newMenu("", "");
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
                    self newMenu( menu, "" );
            }
            self newMenu( current, "" );
            self.menu["isLocked"] = false;
        }
    }

    toggleAlmostHits()
    {
        dvar = self GetPlayerCustomDvar( "almostHits" );

        if ( isDefined( dvar ) && dvar == "1" )
            self SetPlayerCustomDvar( "almostHits", "0" );

        else
            self SetPlayerCustomDvar( "almostHits", "1" );
    }

    toggleDistanceMsg()
    {
        dvar = self GetPlayerCustomDvar( "showDistance" );

        if ( isDefined( dvar ) && dvar == "1" )
            self SetPlayerCustomDvar( "showDistance", "0" );

        else
            self SetPlayerCustomDvar( "showDistance", "1" );
    }