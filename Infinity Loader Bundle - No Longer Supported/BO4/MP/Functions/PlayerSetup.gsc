    fastLast( player )
    {
        if( !isDefined( player ) ) player = self;

        switch( level.currentGametype )
        {
            case "dm":
            player.pointstowin = 29;
            player.kills   = 29;
            player.score   = 29;
            player.pers["pointstowin"] = 29;
            player.pers["kills"] = 29;
            player.pers["score"] = 29;
            break;
        }
    }

    doWelcomeMessage()
    {
        mode = "";

        switch( level.currentGametype )
        {
            case "dm":
            mode = "FFA";
            break;
        }

        self iprintlnbold("Welcome ^2" + self.name + " ^7to ^1Paradise " + mode +"!");
    }

    menuInst()
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        alpha = ( isDefined( self GetPlayerCustomDvar( "menuInst" ) ) && self GetPlayerCustomDvar( "menuInst" ) == "0" ) ? 0 : 1;
        self.instString = "[{+speed_throw}] + [{+actionslot 2}] = Paradise";
        self.menuInst = self createText( "objective", 1, "LEFT", "CENTER", -425, 230, 1, alpha, self.instString, (0, 0, 0), (1, 1,1 ));

        self thread monitorMenuState( self.menuInst );
    }

    monitorMenuState( menuInst )
    {
        self endon( "disconnect" );
        self endon( "game_ended" );

        for( ;; )
        {
            wait 0.05;

            self.instString = ( isDefined( self.menu["isOpen"] ) && self.menu["isOpen"] ) ? "[{+actionslot 1}]/[{+actionslot 2}] = Scroll [{+usereload}] = Select [{+melee}] = Back/Close" : "[{+speed_throw}] + [{+actionslot 2}] = Paradise";

            self.menuInst setText( self.instString );
        }
    }

    toggleMenuInst()
    {
        dvar = self GetPlayerCustomDvar( "menuInst" );

        if ( isDefined( dvar ) && dvar == "1" )
        {
            self SetPlayerCustomDvar( "menuInst", "0" );

            if ( isDefined( self.menuInst ) )
                self.menuInst.alpha = 0;
        }
        else
        {
            self SetPlayerCustomDvar( "menuInst", "1" );

            if ( isDefined( self.menuInst ) )
                self.menuInst.alpha = 1;
        }
    }