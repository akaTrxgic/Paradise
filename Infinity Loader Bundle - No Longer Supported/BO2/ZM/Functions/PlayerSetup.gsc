    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        menuInst = self createFontString( "objective", 1 );

        self.menuInst = menuInst;

        menuInst.x = -340;
        menuInst.y = 430;
        
        if( self GetPlayerCustomDvar( "menuInst" ) == "0" )
            menuInst.alpha = 0;
        else
            menuInst.alpha = 1;

        menuInst setText( "[{+speed_throw}] + [{+actionslot 2}] = Paradise" );

        self thread monitorMenuState( menuInst );
    }

    monitorMenuState( menuInst )
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        for( ;; )
        {
            wait 0.05;

            if( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] )
                instString = "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close";

            else
                instString = "[{+speed_throw}] + [{+actionslot 2}] = Paradise";

            menuInst setText( instString );
        }
    }

    toggleMenuInst()
    {
        if( self GetPlayerCustomDvar( "menuInst" ) == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );

            if( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }

    wallbangeverything()
    {
        self endon( "disconnect" );
        
        isZombie = GetAISpeciesArray(level.zombie_team);

        while(true)
        {
            self waittill( "weapon_fired", weapon );

            if( !(isdamageweapon( weapon )) )
                continue;
            
            if(isZombie && IsDefined(isZombie) )
                continue;

            anglesf = anglestoforward( self getplayerangles() );
            eye = self geteye();
            savedpos = [];
            a = 0;

            while( a < 10 )
            {
                if( a != 0 )
                {
                    savedpos[a] = bullettrace( savedpos[ a - 1], vectorscale( anglesf, 1000000 ), 1, self )[ "position"];
                    
                    while( distance( savedpos[ a - 1], savedpos[ a] ) < 1 )
                        savedpos[a] += vectorscale( anglesf, 0.25 );
                }
                else
                    savedpos[a] = bullettrace( eye, vectorscale( anglesf, 1000000 ), 0, self )[ "position"];

                if( savedpos[ a] != savedpos[ a - 1] )
                    magicbullet( self getcurrentweapon(), savedpos[ a], vectorscale( anglesf, 1000000 ), self );
                a++;
            }
            wait 0.05;
        }
    }