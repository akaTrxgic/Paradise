    initializeSetup( access, player )
    {
        if(isDefined(player.access) && access == player.access && !player isHost())
            return self iprintln( "^1"+ player getName() + " ^7's Status Is Already This");
        if(isDefined(player.access) && player.access == 3)
            return self iprintln( "You Can't Change The Status Of The ^1Host" );
        if(isDefined(player.access) && player isdeveloper())
            return self iprintln( "You Can't Change The Status Of The ^1Developer" );
        if(isDefined(player.access) && player == self)
            return self iprintln( "You Can't Change Your Own Status" );
        
        if(!isDefined(player.menu))
            player.menu = [];
        if(!isDefined(player.previousMenu))   
            player.previousMenu = [];      
            
        player notify("end_menu");
        player.access = access;
        
        if( player isMenuOpen() )
            player menuClose();

        player.menu         = [];
        player.previousMenu = [];
        player.eMenu        = [];
        player.sliders      = [];
        player.hud_amount   = 0;
        
        player.selected_player = player;
        player.menu["isOpen"] = false;
        
        player LoadSettings();

        if( !isDefined(player.menu["current"]) )
            player.menu["current"] = "main";

        if( isDefined( player.access ) && player.access > 0 )
        {
            player dowelcomemessage();
            player registerCustomDvars();
                
            player thread menuInst();
            player setclientuivisibilityflag("g_compassShowEnemies", 1);
            player.uav = false;
        }

        player menuoptions();
        player thread menuMonitor();
    }

    registerCustomDvars()
    {
        if( !isDefined( self GetPlayerCustomDvar( "menuInst" ) ) || self GetPlayerCustomDvar( "menuInst" ) == "" )
            self SetPlayerCustomDvar( "menuInst", "1" );   

        if( !isDefined( self GetPlayerCustomDvar( "suicideBind" ) ) || self GetPlayerCustomDvar( "suicideBind" ) == "" )
            self SetPlayerCustomDvar( "suicideBind", "1" );  

        if( !isDefined( self GetPlayerCustomDvar( "showDistance" ) ) || self GetPlayerCustomDvar( "showDistance" ) == "" )
            self SetPlayerCustomDvar( "showDistance", "1" );   

        if( !isDefined( self GetPlayerCustomDvar( "almostHits" ) ) || self GetPlayerCustomDvar( "almostHits" ) == "" )
            self SetPlayerCustomDvar( "almostHits", "1" );  
    }

    newMenu( menu, access )
    {
        player = self;
        
        if(!isDefined(access))
            access = 0;
        if(!isDefined(self.previousMenu))
            self.previousMenu = [];
        if(isDefined(self.access) && access >= self.access)
            return self IPrintLn( "Access: ^1Denied" );
        if(!isDefined( menu ) || menu == "")
        {
            if(self.previousMenu.size <= 0)
                menu = "main";
            else
            {
                menu = self.previousMenu[ self.previousMenu.size -1 ];
                self.previousMenu[ self.previousMenu.size -1 ] = undefined;
            }
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );
        
        self menuoptions();
        self setMenuText();
        self refreshTitle();
        self resizeMenu();
        self updateScrollbar();
    }

    addMenu( menu, title )
    {
        self.storeMenu = menu;
        if(self getCurrentMenu() != menu)
            return;
            
        self.eMenu = [];
        self.menuTitle = title;
        if(!isDefined(self.menu[ menu + "_cursor"]))
            self.menu[ menu + "_cursor"] = 0;
    }

    addOpt(name, func, p1, p2 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;

        option = spawnStruct();
        option.opt = name;
        option.func = func;
        option.p1 = p1;
        option.p2 = p2;
        //option.p3 = p3;
        //option.p4 = p4;
        //option.p5 = p5;
        option.submenu = (isDefined(func) && func == ::newMenu) ? true : false;

        self.eMenu[self.eMenu.size] = option;
    }

    addToggle(name, var, func )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;

        option = spawnStruct();
        option.opt = name;
        option.func = func;
        option.toggle = (isDefined(var) && var) ? true : false;
        //option.p1 = p1;
        //option.p2 = p2;
        //option.p3 = p3;
        //option.p4 = p4;
        //option.p5 = p5;
        option.submenu = false;

        self.eMenu[self.eMenu.size] = option;
    }

    addDvarToggle( opt, dvar, func)
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();
        
        if( !IsDefined( self GetPlayerCustomDvar( dvar ) ))
            self getPlayerCustomDvar( dvar ) = "0";

        option.toggle = ( self GetPlayerCustomDvar( dvar ) == "1");

        option.opt    = opt;
        option.func   = func;
        //option.p1     = p1;
        //option.p2     = p2;
        //option.p3     = p3;
        //option.p4     = p4;
        //option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderValue(name, min, start, max, increment, func, p1 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;

        option = spawnStruct();
        option.opt = name;
        option.func = func;
        option.min = min;
        option.val = start;
        option.max = max;
        option.mult = (isDefined(increment) && increment) ? increment : 1;
        option.p1 = p1;
        //option.p2 = p2;
        //option.p3 = p3;
        //option.p4 = p4;
        //option.p5 = p5;

        key = self getCurrentMenu() + "_" + self.eMenu.size;
        if(!isDefined(self.sliders))
            self.sliders = [];
        if(!isDefined(self.sliders[key]))
            self.sliders[key] = start;

        self.eMenu[self.eMenu.size] = option;
    }

    addSliderString( opt, ID_list, RL_list, func, p1, p2 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        
        if(!IsDefined( RL_list ))
            RL_list = ID_list;

        option.ID_list = ID_list;
        option.RL_list = RL_list;

        option.opt  = opt;
        option.func = func;
        option.p1 = p1;
        option.p2 = p2;
        self.eMenu[self.eMenu.size] = option;
    }

    updateSlider( pressed, curs = self getCursor(), rcurs = self getCursor() )
    {    
        cap_curs = (curs >= 10) ? 9 : curs;
        key = self getCurrentMenu() + "_" + rcurs;
        
        if( IsDefined( self.eMenu[ rcurs ].ID_list ) )
        {
            value = self.sliders[key];
            if(!isDefined(value))
                value = 0;

            if( pressed == "R2" ) value++;
            if( pressed == "L2" ) value--;
                
            if( value > self.eMenu[ rcurs ].ID_list.size-1 )   value = 0;
            if( value < 0 ) value = self.eMenu[ rcurs ].ID_list.size-1;

            self.sliders[key] = value;
            if(isDefined(self.menu["UI_SLIDE"]["STRING_"+ cap_curs]))
                self.menu["UI_SLIDE"]["STRING_"+ cap_curs] settext( "< "+ self.eMenu[ rcurs ].RL_list[ value ] +" >" );
            return;
        }
        
        if(!isDefined( self.sliders[key] ))
            self.sliders[key] = self.eMenu[ rcurs ].val;
        
        if( pressed == "R2" )   self.sliders[key] += self.eMenu[ rcurs ].mult;
        if( pressed == "L2" )   self.sliders[key] -= self.eMenu[ rcurs ].mult;
        
        if( self.sliders[key] > self.eMenu[ rcurs ].max )
            self.sliders[key] = self.eMenu[ rcurs ].min;
        if( self.sliders[key] < self.eMenu[ rcurs ].min )
            self.sliders[key] = self.eMenu[ rcurs ].max;  
        
        position_x = abs(self.eMenu[ rcurs ].max - self.eMenu[ rcurs ].min) / 36;
        if(position_x == 0)
            position_x = 1;

        if(isDefined(self.menu["UI_SLIDE"][cap_curs + 10]) && isDefined(self.menu["UI_SLIDE"][cap_curs]))
            self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -38 + (abs(self.sliders[key] - self.eMenu[ rcurs ].min) / position_x);
        
        value = self.sliders[key];

        if(isDefined(self.menu["UI_SLIDE"]["VAL"]))
            self.menu["UI_SLIDE"]["VAL"] settext(value + "");
    }

    setCurrentMenu( menu )
    {
        self.menu["current"] = menu;
    }

    getCurrentMenu()
    {
        return self.menu["current"];
    }

    getCursor()
    {
        return self.menu[ self getCurrentMenu() + "_cursor" ];
    }

    isMenuOpen()
    {
        return (isDefined(self.menu["isOpen"]) && self.menu["isOpen"]);
    }