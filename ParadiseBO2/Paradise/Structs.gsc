

    initializeSetup( access, player )
    {
        if(isDefined(player.access) && access == player.access && !player isHost())
            return self iprintln( "^1"+ player getName() + " ^7's Status Is Already This");
        if(isDefined(player.access) && player.access == 4)
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
        player.hud_amount   = 0;
        
        player.selected_player = player;
        player.menu["isOpen"] = false;
        player.menu["isLocked"] = false;
        
        player LoadSettings();

        if( !isDefined(player.menu["current"]) )
            player.menu["current"] = "main";
            
         player thread menuMonitor();
    }

    initializeAllSetup( access, player )
    {
        foreach(player in level.players)
            self initializesetup(access, player);

        self iprintln( "All Players Set To: "+ level.status[player.access] );
    }

    newMenu( menu, access = 0 )
    {
        if( access >= self.access )
            return self IPrintLn( "Access: ^1Denied" );
        if(!isDefined( menu ))
        {
            menu = self.previousMenu[ self.previousMenu.size -1 ];
            self.previousMenu[ self.previousMenu.size -1 ] = undefined;
        }
        else 
            self.previousMenu[ self.previousMenu.size ] = self getCurrentMenu();
            
        self setCurrentMenu( menu );
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


    addOpt( opt, func, p1, p2, p3, p4, p5 )
    {
        if(self.storeMenu != self getCurrentMenu())
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addToggle( opt, bool, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        
        option = spawnStruct();

        option.toggle = (IsDefined( bool ) && bool);
        option.opt    = opt;
        option.func   = func;
        option.p1     = p1;
        option.p2     = p2;
        option.p3     = p3;
        option.p4     = p4;
        option.p5     = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderValue( opt, val, min, max, mult, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        option.opt  = opt;
        option.val  = val;
        option.min  = min;
        option.max  = max;
        option.mult = mult;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    addSliderString( opt, ID_list, RL_list, func, p1, p2, p3, p4, p5 )
    {
        if(self getCurrentMenu() != self.storeMenu)
            return;
        option      = spawnStruct();
        
        if(!IsDefined( RL_list ))
            RL_list = ID_list;
        option.ID_list = (isInArray(ID_list)) ? ID_list : strTok(ID_list, ";");
        option.RL_list = (isInArray(RL_list)) ? RL_list : strTok(RL_list, ";");
        
        option.opt  = opt;
        option.func = func;
        option.p1   = p1;
        option.p2   = p2;
        option.p3   = p3;
        option.p4   = p4;
        option.p5   = p5;
        self.eMenu[self.eMenu.size] = option;
    }

    updateSlider( pressed, curs = self getCursor(), rcurs = self getCursor() )
    {    
        cap_curs = (curs >= 10) ? 9 : curs;
        position_x = abs(self.eMenu[ rcurs ].max - self.eMenu[ rcurs ].min) / ((50 - 14));
        
        if( IsDefined( self.eMenu[ rcurs ].ID_list ) )
        {
            value = self.sliders[ self getCurrentMenu() + "_" + rcurs ];
            if(pressed == "R2") value++;
            if(pressed == "L2") value--;
                
            if( value > self.eMenu[ rcurs ].ID_list.size-1 )   value = 0;
            if( value < 0 ) value = self.eMenu[ rcurs ].ID_list.size-1;

            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = value;
            //count = " ["+ (value+1) +"/"+ (self.eMenu[ rcurs ].RL_list.size) +"]"; // Uncomment this and remove < > if you want the count to be readded
            //self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setText( self.eMenu[ rcurs ].RL_list[ value ] + count );
            self.menu["UI_SLIDE"]["STRING_"+ cap_curs] setText( "< "+ self.eMenu[ rcurs ].RL_list[ value ] +" >" );
            return;
        }
        
        if(!isDefined( self.sliders[ self getCurrentMenu() + "_" + rcurs ] ))
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].val;
        
        if(pressed == "R2")   self.sliders[ self getCurrentMenu() + "_" + rcurs ] += self.eMenu[ rcurs ].mult;
        if(pressed == "L2")   self.sliders[ self getCurrentMenu() + "_" + rcurs ] -= self.eMenu[ rcurs ].mult;
        
        if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] > self.eMenu[ rcurs ].max )
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].min;
        if( self.sliders[ self getCurrentMenu() + "_" + rcurs ] < self.eMenu[ rcurs ].min )
            self.sliders[ self getCurrentMenu() + "_" + rcurs ] = self.eMenu[ rcurs ].max;  
        
        self.menu["UI_SLIDE"][cap_curs + 10].x = self.menu["UI_SLIDE"][cap_curs].x -38 + (abs(self.sliders[ self getCurrentMenu() + "_" + rcurs ] - self.eMenu[ rcurs ].min) / position_x);
        
        value = self.sliders[ self getCurrentMenu() + "_" + self getCursor() ];
        if( IsFloat( value ) )
            self.menu["UI_SLIDE"]["VAL"] setText( value );
        else 
            self.menu["UI_SLIDE"]["VAL"] setValue( value );
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

    setCursor( val )
    {
        self.menu[ self getCurrentMenu() + "_cursor" ] = val;
    }

    isMenuOpen()
    {
        if(isDefined(self.menu["isOpen"]))
            return true;
        return false;
    }

